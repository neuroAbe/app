import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'campaign_manager.db';
  static const int _databaseVersion = 1;
  final _uuid = const Uuid();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> initialize() async {
    await database;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createTables(db);
    await _seedData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle migrations here
  }

  Future<void> _createTables(Database db) async {
    // Clients table
    await db.execute('''
      CREATE TABLE clients (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        company TEXT NOT NULL,
        email TEXT,
        phone TEXT,
        instagram_handle TEXT,
        facebook_page TEXT,
        twitter_handle TEXT,
        youtube_channel TEXT,
        logo_url TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // Campaigns table
    await db.execute('''
      CREATE TABLE campaigns (
        id TEXT PRIMARY KEY,
        client_id TEXT NOT NULL,
        name TEXT NOT NULL,
        description TEXT,
        status TEXT NOT NULL,
        platform TEXT NOT NULL,
        start_date INTEGER NOT NULL,
        end_date INTEGER,
        budget REAL,
        target_reach INTEGER,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL,
        FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
      )
    ''');

    // Campaign metrics table
    await db.execute('''
      CREATE TABLE campaign_metrics (
        id TEXT PRIMARY KEY,
        campaign_id TEXT NOT NULL,
        date INTEGER NOT NULL,
        impressions INTEGER DEFAULT 0,
        reach INTEGER DEFAULT 0,
        engagement INTEGER DEFAULT 0,
        followers_gained INTEGER DEFAULT 0,
        clicks INTEGER DEFAULT 0,
        shares INTEGER DEFAULT 0,
        comments INTEGER DEFAULT 0,
        FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE
      )
    ''');

    // Scheduled posts table
    await db.execute('''
      CREATE TABLE scheduled_posts (
        id TEXT PRIMARY KEY,
        campaign_id TEXT NOT NULL,
        content TEXT NOT NULL,
        media_url TEXT,
        platform TEXT NOT NULL,
        scheduled_time INTEGER NOT NULL,
        status TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE CASCADE
      )
    ''');

    // Tasks table
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        campaign_id TEXT,
        priority TEXT NOT NULL,
        due_date INTEGER,
        is_completed INTEGER DEFAULT 0,
        created_at INTEGER NOT NULL,
        completed_at INTEGER,
        FOREIGN KEY (campaign_id) REFERENCES campaigns(id) ON DELETE SET NULL
      )
    ''');

    // Create indexes for better query performance
    await db.execute('CREATE INDEX idx_campaigns_client_id ON campaigns(client_id)');
    await db.execute('CREATE INDEX idx_campaigns_status ON campaigns(status)');
    await db.execute('CREATE INDEX idx_metrics_campaign_id ON campaign_metrics(campaign_id)');
    await db.execute('CREATE INDEX idx_posts_campaign_id ON scheduled_posts(campaign_id)');
    await db.execute('CREATE INDEX idx_tasks_priority ON tasks(priority)');
    await db.execute('CREATE INDEX idx_tasks_completed ON tasks(is_completed)');
  }

  Future<void> _seedData(Database db) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final oneWeekAgo = DateTime.now().subtract(const Duration(days: 7)).millisecondsSinceEpoch;
    final twoWeeksAgo = DateTime.now().subtract(const Duration(days: 14)).millisecondsSinceEpoch;
    final oneMonthAgo = DateTime.now().subtract(const Duration(days: 30)).millisecondsSinceEpoch;
    final tomorrow = DateTime.now().add(const Duration(days: 1)).millisecondsSinceEpoch;
    final nextWeek = DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch;

    // Seed Clients
    final client1Id = _uuid.v4();
    final client2Id = _uuid.v4();
    final client3Id = _uuid.v4();
    final client4Id = _uuid.v4();

    await db.insert('clients', {
      'id': client1Id,
      'name': 'Ahmed Al-Rashid',
      'company': 'Riyadh Restaurant Group',
      'email': 'ahmed@rrg.sa',
      'phone': '+966 50 123 4567',
      'instagram_handle': 'riyadh_restaurants',
      'facebook_page': 'RiyadhRestaurantGroup',
      'twitter_handle': 'RRG_Official',
      'youtube_channel': '',
      'logo_url': '',
      'created_at': oneMonthAgo,
      'updated_at': now,
    });

    await db.insert('clients', {
      'id': client2Id,
      'name': 'Fatima Hassan',
      'company': 'Jeddah Fashion House',
      'email': 'fatima@jfh.com',
      'phone': '+966 55 987 6543',
      'instagram_handle': 'jeddah_fashion',
      'facebook_page': 'JeddahFashionHouse',
      'twitter_handle': 'JFH_Style',
      'youtube_channel': 'JeddahFashionHouse',
      'logo_url': '',
      'created_at': twoWeeksAgo,
      'updated_at': now,
    });

    await db.insert('clients', {
      'id': client3Id,
      'name': 'Omar Khalid',
      'company': 'TechStart Solutions',
      'email': 'omar@techstart.sa',
      'phone': '+966 54 456 7890',
      'instagram_handle': 'techstart_sa',
      'facebook_page': 'TechStartSolutions',
      'twitter_handle': 'TechStartSA',
      'youtube_channel': 'TechStartSolutions',
      'logo_url': '',
      'created_at': oneWeekAgo,
      'updated_at': now,
    });

    await db.insert('clients', {
      'id': client4Id,
      'name': 'Layla Mohammed',
      'company': 'Wellness Center KSA',
      'email': 'layla@wellnessksa.com',
      'phone': '+966 56 321 0987',
      'instagram_handle': 'wellness_ksa',
      'facebook_page': 'WellnessCenterKSA',
      'twitter_handle': 'WellnessKSA',
      'youtube_channel': '',
      'logo_url': '',
      'created_at': oneMonthAgo,
      'updated_at': now,
    });

    // Seed Campaigns
    final campaign1Id = _uuid.v4();
    final campaign2Id = _uuid.v4();
    final campaign3Id = _uuid.v4();
    final campaign4Id = _uuid.v4();
    final campaign5Id = _uuid.v4();

    await db.insert('campaigns', {
      'id': campaign1Id,
      'client_id': client1Id,
      'name': 'Ramadan Special Menu Launch',
      'description': 'Promote new Ramadan iftar and suhoor menu items across all social platforms',
      'status': 'active',
      'platform': 'multi',
      'start_date': oneWeekAgo,
      'end_date': nextWeek,
      'budget': 15000.0,
      'target_reach': 50000,
      'created_at': oneWeekAgo,
      'updated_at': now,
    });

    await db.insert('campaigns', {
      'id': campaign2Id,
      'client_id': client2Id,
      'name': 'Summer Collection 2024',
      'description': 'Launch and promote the new summer fashion collection',
      'status': 'active',
      'platform': 'instagram',
      'start_date': twoWeeksAgo,
      'end_date': null,
      'budget': 25000.0,
      'target_reach': 100000,
      'created_at': twoWeeksAgo,
      'updated_at': now,
    });

    await db.insert('campaigns', {
      'id': campaign3Id,
      'client_id': client3Id,
      'name': 'Product Demo Series',
      'description': 'Weekly product demonstration videos and tutorials',
      'status': 'active',
      'platform': 'youtube',
      'start_date': oneWeekAgo,
      'end_date': null,
      'budget': 10000.0,
      'target_reach': 25000,
      'created_at': oneWeekAgo,
      'updated_at': now,
    });

    await db.insert('campaigns', {
      'id': campaign4Id,
      'client_id': client4Id,
      'name': 'Mental Health Awareness',
      'description': 'Series of posts about mental health and wellness tips',
      'status': 'completed',
      'platform': 'twitter',
      'start_date': oneMonthAgo,
      'end_date': oneWeekAgo,
      'budget': 8000.0,
      'target_reach': 30000,
      'created_at': oneMonthAgo,
      'updated_at': oneWeekAgo,
    });

    await db.insert('campaigns', {
      'id': campaign5Id,
      'client_id': client1Id,
      'name': 'Customer Loyalty Program',
      'description': 'Promote the new customer loyalty and rewards program',
      'status': 'draft',
      'platform': 'facebook',
      'start_date': nextWeek,
      'end_date': null,
      'budget': 12000.0,
      'target_reach': 40000,
      'created_at': now,
      'updated_at': now,
    });

    // Seed Campaign Metrics (last 7 days for active campaigns)
    for (int i = 6; i >= 0; i--) {
      final date = DateTime.now().subtract(Duration(days: i)).millisecondsSinceEpoch;

      // Campaign 1 metrics
      await db.insert('campaign_metrics', {
        'id': _uuid.v4(),
        'campaign_id': campaign1Id,
        'date': date,
        'impressions': 8000 + (i * 500),
        'reach': 5000 + (i * 300),
        'engagement': 400 + (i * 50),
        'followers_gained': 50 + (i * 10),
        'clicks': 200 + (i * 20),
        'shares': 30 + (i * 5),
        'comments': 80 + (i * 10),
      });

      // Campaign 2 metrics
      await db.insert('campaign_metrics', {
        'id': _uuid.v4(),
        'campaign_id': campaign2Id,
        'date': date,
        'impressions': 15000 + (i * 1000),
        'reach': 10000 + (i * 600),
        'engagement': 1200 + (i * 100),
        'followers_gained': 150 + (i * 20),
        'clicks': 500 + (i * 50),
        'shares': 100 + (i * 15),
        'comments': 250 + (i * 30),
      });

      // Campaign 3 metrics
      await db.insert('campaign_metrics', {
        'id': _uuid.v4(),
        'campaign_id': campaign3Id,
        'date': date,
        'impressions': 5000 + (i * 400),
        'reach': 3500 + (i * 250),
        'engagement': 600 + (i * 40),
        'followers_gained': 80 + (i * 8),
        'clicks': 150 + (i * 15),
        'shares': 50 + (i * 8),
        'comments': 120 + (i * 12),
      });
    }

    // Seed Scheduled Posts
    await db.insert('scheduled_posts', {
      'id': _uuid.v4(),
      'campaign_id': campaign1Id,
      'content': 'Experience the magic of Ramadan with our special iftar menu! Book your table now. #RamadanKareem #Iftar',
      'media_url': '',
      'platform': 'instagram',
      'scheduled_time': tomorrow,
      'status': 'scheduled',
      'created_at': now,
    });

    await db.insert('scheduled_posts', {
      'id': _uuid.v4(),
      'campaign_id': campaign2Id,
      'content': 'New arrivals alert! Check out our stunning summer dresses. Link in bio! #SummerFashion #JeddahStyle',
      'media_url': '',
      'platform': 'instagram',
      'scheduled_time': tomorrow + 3600000,
      'status': 'scheduled',
      'created_at': now,
    });

    await db.insert('scheduled_posts', {
      'id': _uuid.v4(),
      'campaign_id': campaign1Id,
      'content': 'Behind the scenes: Our chefs preparing for tonight\'s iftar service',
      'media_url': '',
      'platform': 'facebook',
      'scheduled_time': nextWeek,
      'status': 'draft',
      'created_at': now,
    });

    // Seed Tasks
    await db.insert('tasks', {
      'id': _uuid.v4(),
      'title': 'Review campaign analytics report',
      'description': 'Analyze last week\'s performance and prepare summary for client',
      'campaign_id': campaign1Id,
      'priority': 'high',
      'due_date': tomorrow,
      'is_completed': 0,
      'created_at': now,
      'completed_at': null,
    });

    await db.insert('tasks', {
      'id': _uuid.v4(),
      'title': 'Create content calendar for next month',
      'description': 'Plan all social media posts for the upcoming month',
      'campaign_id': campaign2Id,
      'priority': 'urgent',
      'due_date': now,
      'is_completed': 0,
      'created_at': oneWeekAgo,
      'completed_at': null,
    });

    await db.insert('tasks', {
      'id': _uuid.v4(),
      'title': 'Schedule product demo video',
      'description': 'Edit and schedule the new product walkthrough video',
      'campaign_id': campaign3Id,
      'priority': 'medium',
      'due_date': nextWeek,
      'is_completed': 0,
      'created_at': now,
      'completed_at': null,
    });

    await db.insert('tasks', {
      'id': _uuid.v4(),
      'title': 'Client meeting preparation',
      'description': 'Prepare presentation slides for quarterly review',
      'campaign_id': null,
      'priority': 'high',
      'due_date': tomorrow,
      'is_completed': 0,
      'created_at': now,
      'completed_at': null,
    });

    await db.insert('tasks', {
      'id': _uuid.v4(),
      'title': 'Update brand guidelines document',
      'description': 'Include new logo variations and color codes',
      'campaign_id': null,
      'priority': 'low',
      'due_date': nextWeek,
      'is_completed': 0,
      'created_at': oneWeekAgo,
      'completed_at': null,
    });

    await db.insert('tasks', {
      'id': _uuid.v4(),
      'title': 'Respond to customer inquiries',
      'description': 'Reply to all pending DMs and comments',
      'campaign_id': campaign2Id,
      'priority': 'medium',
      'due_date': now,
      'is_completed': 1,
      'created_at': oneWeekAgo,
      'completed_at': now,
    });
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
