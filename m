Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FBFB5F5ECF
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 04:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiJFCpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 22:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiJFCpX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 22:45:23 -0400
X-Greylist: delayed 122 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 05 Oct 2022 19:45:22 PDT
Received: from esa2.hc3370-68.iphmx.com (esa2.hc3370-68.iphmx.com [216.71.145.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3F55850F
        for <stable@vger.kernel.org>; Wed,  5 Oct 2022 19:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1665024322;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=G2ZDCCfufWsQ6h0hchuGOAQn1Xd00BfOLIsztOwhTEw=;
  b=Zb29yno5m0RZNBz+bA3vG2iLzZDN6DA3eMfkjzlSsRxgnkXDr4z9MOqx
   My24RTgoK/CvOCaJL1Dhvbxf+wOZav6j/h1/7WvLy7tUVgL6+duQPwENs
   HAtluY/6vhEtUELMBrd5FMHfcoMFmR4ZZGM1asOUg2EbPLeDY55H+o6iQ
   w=;
X-IronPort-RemoteIP: 104.47.56.40
X-IronPort-MID: 82093397
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: =?us-ascii?q?A9a23=3AU/5cQanG4QgK7SUr4o9xy47o5mJPLRPaJntM2?=
 =?us-ascii?q?Kg6bVvmP7IAGkBGC+LNIZm0g9T+3OM0Jj3oTE4NhPO6rT3xq9uvgserEX2yY?=
 =?us-ascii?q?qGZBGdQfXyySKirsId2frTF9P6WN0D2daxnToX3iEJG+LeJr45vJycE2Oc7Q?=
 =?us-ascii?q?OiZvisFZb1+UUHTTyh6Ls9sbRuIBLvmpC0d8bUfgtoTPH0i7qz33QbK5tcMM?=
 =?us-ascii?q?uWwE+cxuVoxnQDus90O81TVyN5uXJubo3fhIAKqfjko3DWnT/EAmo1xXzcGM?=
 =?us-ascii?q?GTlLNYgEW7i55GpxIX3MKdAIL9QzpvuRw79kamea+00ubVpLbTiHsdhlnhYo?=
 =?us-ascii?q?vp+ummozIkOTLH4eBDN5kTj5BWCvqBAYd53YYPmGMozr88RZZH20NjO9ZBJZ?=
 =?us-ascii?q?0a8LlMHT9ujhD+DPextRyYdkFOGxOK1Bu2KAzJZ53VWoXs3MbyZt/DLsD7tD?=
 =?us-ascii?q?mX4v6Hs5TTjVi6cNJ5qNRx6ojRy2jSFglx5UQglHq1QU/2gSJkgiTIppDzax?=
 =?us-ascii?q?MCGh8sui+G0hkd/EuD/ZmwGQgOsEvSTxZsNgXce9QmL6BzXLRSw2/CObQaiW?=
 =?us-ascii?q?6wO40nC2CxQQjRTeDaIHWYJdWJFgTLPcZCF1EEV117lEOxVSCsmG6MHWPmd7?=
 =?us-ascii?q?JEi5339EtSyMO8bp72xBz6qbu6N1esO1ta+EGXYYkDJyg2+lHh0cHWlPGTZI?=
 =?us-ascii?q?snsgWvwPe+IkB1sashVHdKBxiIy+yJWm+j1XFRj5Tv7ExoygdaR1LWNnVVeX?=
 =?us-ascii?q?QrlR3LyuYqpXgukFaYTwzBBSgXvsMBXt0m2UHdfk0DQnGkIMcpD0EFY0PsIO?=
 =?us-ascii?q?1q4kGZz2xBVGRCAPm8uHs1zAYEJdGr82BbDGcQBdhaTzvElXFQL2j7HnavCj?=
 =?us-ascii?q?bMJaIwQS6VLlxL7iZXZZAeLOjLcb7ZzWfPm41nFsYmE0i2DQVj6iH0RgoBCM?=
 =?us-ascii?q?0V4EFquVrw2dyuzvCGxSiEF+zqCnb5VAfQ2OqMcte0lOMOfNK7zoLIH8E2Je?=
 =?us-ascii?q?SdaiezZ62koVnHsBJLkWrwm1fKHmKaN0IEEWpEIFqnJji53JzwfWQO0GqI5e?=
 =?us-ascii?q?kKb5AvjyPQJDfDiCss9n/wRzz037qofLOMEkKw5Ysu0WRVU1n0AjzCESHExO?=
 =?us-ascii?q?pMNNk51PGb1n8HB86PlmyxJseu7YVtjyBrAPjK9WIEXGG+7UUKXz8H6kE72x?=
 =?us-ascii?q?jKDQlOxZ9yk2toqH9IwkIuEFYFrpC+DJwaK7bnLutn+VoA9NnZg+MjEPlVpI?=
 =?us-ascii?q?Tf/+9/t38lUaEKvT6snb6TD9ixvh//uS1xRK0O9xSs9kjJqsOEEamlxSh1ef?=
 =?us-ascii?q?wdCItq2efLUlwfsYJjUS51KjtHLC6inV+s3i3/A+ZmyPbxjkbvBcnP4lhQQj?=
 =?us-ascii?q?ne9qkNvrzPeRtun15DZUm894FrEbbuw21CzhZqu7hb2WdNxvXXzk6VtHTfO5?=
 =?us-ascii?q?0M5AXyQS00dzZ1SPA9GOuK/ZioWqjdrc46PQiSoj5q6bv+yjxvgXloNQZTbb?=
 =?us-ascii?q?dpcZBuK6a64qXYuviU7u3HVQyWalMwWkT6O305LuqRV0agr0U/LAOGY1Ldqu?=
 =?us-ascii?q?WuWf5OZMPKDcY4cIPu4v7/FGxeVToaAl05pmfh81vP90zzyPyEutOLm8ZAVv?=
 =?us-ascii?q?vCvbysrbRiVqYYRczhFmtKKpwhn+THh/J7UYYa6J5NHz8wruNdN4d7OENCHW?=
 =?us-ascii?q?u45mYPiNyvym/TUjWjAqjIZK2IazsSh5onZrmY6JRKpmenwQ2xJLOB9s7r1c?=
 =?us-ascii?q?T8pt+DN6V8txl9GgUSdY61ewWnh5fdOKYb00rGpv3zO2MJomMu70Iyuej3i3?=
 =?us-ascii?q?k7CyTUjBF5pxrbNZasmg8Dl3avgBGzNm6TWh5zEoRZs6dyzVnbwmlpIcphNN?=
 =?us-ascii?q?OfrhoIHLO+n8qWQGA4bZIPzrlF89UEIwbgkOiIkoyJbn1oAtxklvh6FdpKtf?=
 =?us-ascii?q?AZfkvbb7kTJrQfxde1aWV8kYTgi+FY/cqRfrrAKxYdP2WC7OjRjM9aDx3o8k?=
 =?us-ascii?q?U5lx978PCSTF8qTHvLeaZt2W//mJMgsUxLXxoaLzgniWyEgnXAYJrDG1Dsre?=
 =?us-ascii?q?0UbvlMdhUTpEpdbTXdqbhTCaz10MmR7lL6qETODWsP9Juwb2FVCJYz4cGzfu?=
 =?us-ascii?q?HzNSZXoGADPVDyu7YkvgbRvTXrUboukHDvUOOBHp2pswZHg1M71SJlFoUh4H?=
 =?us-ascii?q?IrL+y5OekjUSROTK1qp43eYDHaTg1+uZkfFxtP85AznLrunxuAQRm/7Wv2Tb?=
 =?us-ascii?q?S7OIW4sAqXQoXTQ1VoVtwciuK6cTNvtZBLoVNlnlAzWYBmg90z2xrYsN6H/m?=
 =?us-ascii?q?dnfeItvS2isIJt8YvHN84GeE8BibZLNHrf4tGe9OenZgQij+DgQrY+uoahYO?=
 =?us-ascii?q?hy+mE/YkqhsOOtHkDsPPRvNib+vXroEe2OeofF4SHLJhsc3IvTVIf9k42bHJ?=
 =?us-ascii?q?Hd1lwlk7vf6GJGsiCoquPWr07g9cLmrPnCrd9QZOCH7DdNgL4kW42xEBf873?=
 =?us-ascii?q?+ogAaDtxx4PT10WyXhJw2+itiAkDGu04cBL5LPxKwoGVCyNpIb8WEhAv01dL?=
 =?us-ascii?q?dSHrE4JeMCmq0K0NcYvNi+WCXUdO+TXdYltYlnvb3mobKvt08kNNM2Vcym3/?=
 =?us-ascii?q?4IXU7t7hSA4W54LF8LbEEcZWFQY03Fe3vZG3Jn6myMOiSA2QQbOclKYY0UCM?=
 =?us-ascii?q?JpsEmjEWfzy/la5TzygB1G8rpiTxKjq63gKhM/3gnxvJfWO64cshvcfAbqIG?=
 =?us-ascii?q?xzrHR9eld016obl/SB1R9o00gBao3cU7CJkNdN2AQv7NYpKZX4N413D42oEi?=
 =?us-ascii?q?G8GzEBEoCb5sb5qHZb+RrETtsMGHuDaL+jCImxbnF78lmMyAt+TnxJnbwhEa?=
 =?us-ascii?q?/yUUJP0YOZrHSuoOKqEF2+aZj7Jtir7m0VFHc1dzGNmNe3IiDF8COE16IDMt?=
 =?us-ascii?q?uiXoHY2UmBoLDggNEeMSpnqIEGILo7BAGSyiXN9DVWvw714RGftpLAdCP9ST?=
 =?us-ascii?q?NPewNDrS5nD0bR8HlCGZXA+HA2o0d+updZafgk/kDNd26mizxvOhZCzsJ6JH?=
 =?us-ascii?q?Vo9L0yzolF2s/aT6e9vsYPc20sNeHLvZpONiyJTd8BEtJadpLOsW7983og1h?=
 =?us-ascii?q?aQ/fGEUA9mKYmAJlFdNXw7Db8OjXCs9iRbvAVZa3MfC6kOYUbYs7jQ5u8Fmj?=
 =?us-ascii?q?oi5bFx4n92Rd93iHrmuQF47W5rpZITFeZFXwQWhaYZNuOJ47hyjIx9Zu2M4p?=
 =?us-ascii?q?izq3yrpLtO/LHyWnYGWJCwvp7fa4ddaxOgd/NL1QaiIYpepf1FYZX01z8e++?=
 =?us-ascii?q?f0cQks=3D?=
X-IronPort-AV: E=Sophos;i="5.95,162,1661832000"; 
   d="scan'208";a="82093397"
Received: from mail-dm3nam02lp2040.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.40])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Oct 2022 22:42:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k8QgQay4zyzQkF/c/z76S6ygNVu50868jwF+HWO+04hllT2oNYGqLpdS/pqUqqOs1g52rJNJrHH413731Qe6moRwSqmZOOzAhYjaFbDBJ2jQLy7U+NUI8wx2LXYFNAaq8Qqd7KDTMaXQQOzNfrZii8nkHVHMlMrImKkt6+NihzdDLPp9ssIkG+3R3VYS2j4UEwSlrd2xoaBeV9qSarJ+vSo7EBZHx8lDC6QgeaFOLpI1vvduB4Pust6qIh6eUaslt1bx50ky/zgJ5HBFZekIx0+gyNn/P4FovlzPjO+BeH+Yx8cVh4DWkgKt79jQUphdf57umZ9H76gr7dIej6mwlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G2ZDCCfufWsQ6h0hchuGOAQn1Xd00BfOLIsztOwhTEw=;
 b=WbW+bWQDBBMxYvtJPgHJszENUQIHcJA9AASjjq7z2EJPgYr+lHjh4yNeAa+zBjTdfVxihQgsLOlz3N8UWNE2AFwfvxORuWXYftJusN18yTR4wDp/GFLN7DfP2cDqRQEfytsp07/QlKR5prPddUGyDsrYRcjrMWP2awvnvLCqgTOhAJqdM88mEGjQi3pqxAveChn9iD6qs46U8l7jDw1dbiqDiobR0XuBC9jVtijkMS0ockURm8Kwj/xmHhjz36hb2as+l/+NcphNiLWM67PcnTcA2KsWMZShUaE5WbR4T/0oQoPP6EsF5rhiSPKOvhgx0qyli6o8usxicQ9k/jvYyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2ZDCCfufWsQ6h0hchuGOAQn1Xd00BfOLIsztOwhTEw=;
 b=gcZlme1dxwAOVoR1nNBgeeCli5IoznKJQ/NKd8t3z67QzKaXeW/hehxT9DQzny/iR0703ujy2lunI0JNvk2P2yWKJVzJdLxpcEBMqTAGHiUyMPB4Bq8q9ERcOZ9LMY7ATxyDKBkcLeMCg7ChK1yhy54n+oCqqdQtDQYljcTCYFY=
Received: from BN7PR03MB3618.namprd03.prod.outlook.com (2603:10b6:406:c3::27)
 by SJ0PR03MB5406.namprd03.prod.outlook.com (2603:10b6:a03:28e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Thu, 6 Oct
 2022 02:42:10 +0000
Received: from BN7PR03MB3618.namprd03.prod.outlook.com
 ([fe80::e026:95ff:3651:8e37]) by BN7PR03MB3618.namprd03.prod.outlook.com
 ([fe80::e026:95ff:3651:8e37%6]) with mapi id 15.20.5676.032; Thu, 6 Oct 2022
 02:42:10 +0000
From:   Andrew Cooper <Andrew.Cooper3@citrix.com>
To:     Suraj Jitindar Singh <surajjs@amazon.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "sjitindarsingh@gmail.com" <sjitindarsingh@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@suse.de" <bp@suse.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
        "daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>,
        "pawan.kumar.gupta@linux.intel.com" 
        <pawan.kumar.gupta@linux.intel.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>
Subject: Re: [PATCH] x86/speculation: Mitigate eIBRS PBRSB predictions with
 WRMSR
Thread-Topic: [PATCH] x86/speculation: Mitigate eIBRS PBRSB predictions with
 WRMSR
Thread-Index: AQHY2R18zq6wlbA6C0K295wdvUaLRa4AqDqA
Date:   Thu, 6 Oct 2022 02:42:10 +0000
Message-ID: <11ebe489-0734-28af-07a4-f658709cfd9e@citrix.com>
References: <20221005220227.1959-1-surajjs@amazon.com>
In-Reply-To: <20221005220227.1959-1-surajjs@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN7PR03MB3618:EE_|SJ0PR03MB5406:EE_
x-ms-office365-filtering-correlation-id: 44fcf7c9-6f15-4171-4225-08daa7445e17
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7vTJszliV9sLmcSR8f9oyBbr+H9vbUCQrlwNpue+f7o+2ein0HGdz3bh6oTU9Nmgk7O5nlOMPDCd/Icof01krEv+KFrM6ENlRbCwT70jskYMaM7/nmgWPdsgxJP8t+stF7WFxIF0bVDfTEnut9I6X2Lr4w/QnQsQUc+muaeotjdTD3E0IzN2Jhr9BeCnTIY9+goarvjk8QJzuCffmwKedChRuUPhXo0f+E48OpZAnFM9/x9W5s8BUz5VP+w4nvQyuFE6F9KYNwnKEEfJBPjqXqOVO+dhlJn2ltJgvrvDQE+T9IGwGLQgDXnfXV3vTcGoH+Iepd4Vk0yVb2HPQTnu/sGJ/RQqALa+ch4ogDJNd+ZPn0HeoU8McMwpKSxr+LI3lACl2wwFdfoLmaEe3Rwak1AUhGpPK+9SxO2itCSkOQIqE9K5MOTIwpGACjIwXeanUrQi6efHqqQ3BVV5uEF21fv9GTOOHh1Ty+XRbBbJueEbcNJw5dotScUSQ50T1xGs9Og+Km62CKJ7QVsv/ceL9QRhRMNiRFU/y1tbkS8OdqI/crCSc/gMEwUAV0dWx4umrCM9f/khyIXRcVjVKhFDKz6W6uePyfuGwIS+BmnuCZcZPoguknPccTrIfLySZNkwllGvjeqytwJA8X2rgUpKlcTf/6vyolGyCmGvRZO353/ja0492qmGCU7WbmNHFcu5jnnPy7bSZNx20ajKb9thPbThSMX7vUbIYXoKKVFdwcXGDCXnnmsV3takiIxBOPEqC8wzzJyNSj9kPUra4ocjszga3C3PBIsiBL8XPzo/egDZfetIY3dcnwIKsovzvVPp/JH7lp3RIxMlbbIQK6MhN3kgInR+dRAf/XGZZkEJ7Fg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR03MB3618.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(451199015)(83380400001)(186003)(2616005)(82960400001)(38070700005)(122000001)(38100700002)(7416002)(2906002)(41300700001)(5660300002)(8936002)(6486002)(966005)(478600001)(53546011)(26005)(6512007)(107886003)(71200400001)(6506007)(4326008)(8676002)(64756008)(66446008)(66476007)(66556008)(91956017)(76116006)(66946007)(316002)(54906003)(110136005)(31696002)(36756003)(31686004)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SkJ5VFJBSWFhMFlkUjFVY3FWWnNrcGNZNHVMbys1YUIrVllHSTRoVFFFQ3FF?=
 =?utf-8?B?L1VJdnF6ZlpGVVRYWFNyVjBNRG5qbjluNnpxYUlqR2lCY3M2aEVCcDJDK3pr?=
 =?utf-8?B?S3pQZnI5YkdOZ3FjQUNtbjg1N2JpanQ3WW03Tng3S2l3K1gvOFlxMnc3WW1Y?=
 =?utf-8?B?dVRlSDd4NFBPcGxKeEJibUJUc0VWWEJzNnNjckZHaDJKcDNwTGRQYzdYNlU4?=
 =?utf-8?B?SjkxZHVNQlQvNnhsSmlIdHkvZWlYd2hyaEh5aldtN3lpVElNRVhwbTViK0F1?=
 =?utf-8?B?U1BDb0ozM3RsVjREZm5FcEx6OEF5emlXNVVxNW13SmRIK1hjZ0RtRk9Za1ky?=
 =?utf-8?B?TWJ3eVFTdEE0Wi9uYUVUblVMMFZkbTJISzhDbDJwME51V0NoUUYyQnBHaXZU?=
 =?utf-8?B?VnhZd3cvL2lPRklNT2M3QUdqY0wzS2xRZTVXSjN0eExiY3RrTUNKRGt5U08v?=
 =?utf-8?B?R1FxNjR3aHNlM3o1WjhlYnp1Rkwzc011RUhIZjhvWmszZHI2djZpemdSNHhO?=
 =?utf-8?B?L3Q2VWNQTE5GbzZWdGVLeDRoUGRTMFdvSUhhVHFzRDMyQS8zd0NSVldBNUlX?=
 =?utf-8?B?TEtQQXlJb3VNMGNXZkJxMVJWT1FuRHF1emRuMk5CQmx4ZmJlVWlLcTZKanA0?=
 =?utf-8?B?QXZHMnpqY1dOeHVyckM2NzQ0bC8zNzB0dDl0SVM3NzJqUyt0Tzk5WDFyaXZ5?=
 =?utf-8?B?UVpYWWpFa0FidkRTN3NJZWtGZlpNczd6TnFMN3JuTytuQnJNZ2pxbkNIcHl3?=
 =?utf-8?B?Yjl6ZTBGQ0VWWU5aMTdFRmxaMkVBSnB4M0VDdUp5d1Fzb3dTTGcrejZZTEQ3?=
 =?utf-8?B?R0pBb1M3WUs2M1F6dDhISUdmNVcrSkhYa0hmdnJqMFdueGs1SUxVTTdCcVF4?=
 =?utf-8?B?dkl6QXNyMlRjbTg0Y2t4YU1LZ0tmNnFnRnEwbzRnRkRWY0gxUGhYZjMrd3Rl?=
 =?utf-8?B?U056Y3ZOMXc3a2lrZ2FNdC9zU25PSzd1NGNoZnNXNnB1VHJkWGVNMGNYa0J6?=
 =?utf-8?B?MWtDQmJQMHFnOXA1YVYrSDlpNDdQeTRTTW52bFJGb1Rzc2ovSDJ4K1d1UFNq?=
 =?utf-8?B?U0hJajJ5c2dvejNnTEdKbmM5MnFnU1crSTdTL0xOcVh3UzUvWjdnZGZtVHVi?=
 =?utf-8?B?SHEzVTBNS25DWFdsdFg0U3lnTHFDemx5VjBPMHFhK3I4NEpneXN1ODgwWDJR?=
 =?utf-8?B?aithYndBV3NLTVAwMGVNWTk4WFN5RlppdzRSSVdWZThHMXZ4RXpTVmdCd0Vw?=
 =?utf-8?B?d3JPbFFsUGgxanhhMkhGSlhBOGhCQ3k3S1hYbHZLUGwzNXkyLzFGSDgzNzZR?=
 =?utf-8?B?MitQL0RPNHAzU3lFRXJTNndiVjVaekYxYkxzczg5ZTdBaE9HRjVhUGsrckUv?=
 =?utf-8?B?OWpjMzRVV1FhSWlVOHlOVEVkaGVJazdNQUNaSmljM2t3a3kvWVVPdlFJSTdC?=
 =?utf-8?B?TUsrRUp5MlJyZUI4OU5sOHljRkc1S1o2UEFVQUNOTm82cWs3SXFHTUZCWk5J?=
 =?utf-8?B?NDRocTdnU0k5dzBlNUlCcjkrSGx1RUhIN1FOejJzMGZIdVdaK2pQb0FUa0Rp?=
 =?utf-8?B?dXREaktVTUp5VU1jWWN1QUI5aWExbHA5bEhMTGY5aDVIOG5kODlabjJpVGVs?=
 =?utf-8?B?MHBpOWtqUEJGdCtDVHFHWWR0QjFUQ0JYSjZmUVROZE5tbXhRMVJZSzgxQU12?=
 =?utf-8?B?V2dId0xzcWc4UStHcFl2a204TTd2OUtYQllWUmM5Skt3QTVVcXJKRGpGR0Nm?=
 =?utf-8?B?MmY1ODZTMGhGKzd1bVc3ZmtRZ3hSakozalUvZm5DdVdoc2xIaDdDaVo1bHpI?=
 =?utf-8?B?QTZJRnlkcXpvalRQVkxWdEdlaDFEOHVaRGR3R08veW9aUENNOUZmb3NISGFX?=
 =?utf-8?B?QXNvMzNvUXJiWlYrOG52WWRwNnhQeGZuTDc3TXgxdG01UmJReHVUaVgyMFdi?=
 =?utf-8?B?bE9NY2NuZzB6OTdEUDk1ODByUm9la1ZWTDJFQWdYNHdsQkE1YmRGYUx6a1Fi?=
 =?utf-8?B?a3l4UEd2SGNHUVhaM0xZVHRZeldFTkJMRHlwaTQ0UFp0aHpKd0F2ODhwZnpl?=
 =?utf-8?B?c3JabnB2YzJYaXRWeU4vYmJpQm5sY3hJSklXT202R2lVNTI0WUhLTlNGSWtl?=
 =?utf-8?Q?FWxV4XP3m0MN+0ORmPd/SOYqd?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C1683F638191048B146FD0FCC03B316@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TTNlZG9UTXhNRXJlTU45Uld6TVVOMUVHcDNDQTBXamNvL0xxcDlIRDJDWk5I?=
 =?utf-8?B?eG4rOXJKQ1VwNmZVRUREZDlaRXZPTEQ0NndCWW91eDlBckVYZVZNTUx0K2N2?=
 =?utf-8?B?Z0lVT3VybHczMExLUjRZVHcxbmtaVzRFVDFKOGphU3dKMjRLYVlLcEN0MHBp?=
 =?utf-8?B?cXZkemNJMEFkcEZOOUhjSWgxRU9EMFdUSjNiK0UvcmdRQXRvVGVlUi9ENHdV?=
 =?utf-8?B?WjF0YzY4VGp2WVRZaDRqRUVscDl5eks2Q1kyVEFHdVZ0U0ljYnFWbGhCbE5p?=
 =?utf-8?B?RC9qOEwzVFVVUWpBbkxZYVpwSmlXOFJHbmNLTSthYk5YWmEzemYrQ0ZoK0VQ?=
 =?utf-8?B?WGFqOVlCNnh1MzVTTjVPTjZUL2I5RzBKcmttZzJXYXRDcmNXcVRYNU13SzEy?=
 =?utf-8?B?WFpVOTZpOENVUG5kNTlpTFF2SlI1ZS9iazJ4UTBXMGlRazJUNncvS3NTa1lQ?=
 =?utf-8?B?MWxibnREc2pHSkY2WHFoWnI3SmxjTjV5dVNIZGkweUd2STNycVBLNVd6Ulhm?=
 =?utf-8?B?Y2M4akxvcG1JTzU5MW1ndVVwUFBkRDRhNzVlZWlqc2RxNWlnVndwVmZ1ZXM5?=
 =?utf-8?B?S2p1MC9iOEtYWTZabDR3aXlUditYL0tBbGlKc2F3WVozd3Z1SjRHcmFhRXRH?=
 =?utf-8?B?WEIxWWhaTUpNcTdqT3dnNWpQbVRvZE1xckdRd3JCbXZWTFMwOVk0RnBhbWZk?=
 =?utf-8?B?U2p6alF4TlJ1Q3NlNTRZZHRYemVKNVJEdVFaODVMa04zSS9rT0J4WGx1bGVX?=
 =?utf-8?B?K3NEUitCZFg2RldWWXd6SysvcjU5ZnFEd2hSNmtucWNxTXYyRWtSMFdoMVVN?=
 =?utf-8?B?c3pQTTJyK3EyaFRVNUpndndRdlp3ZTd5Q3V0K1lMTUtDREtoc0d0Ni9qSll3?=
 =?utf-8?B?M0ZxRUo2SWgrbExvTWt3MVdKby9peHhvOFlxT3BuNERIQ3BHQ2w4OXI2UzF4?=
 =?utf-8?B?cW1Ib05ZdUZNeVIrTS9VZU5QaE0rYXBFN1c5cUM1REhtU21KbUFMQjJBNlBn?=
 =?utf-8?B?dmU2blQxQUtlNEt5dFQremR5ZDF0Q0dRcDZUbkwxamorUE1nd29JZEJjL1h3?=
 =?utf-8?B?K3hMdjNCZ1F6YzMrMHZ5SXVqZEw5QnpPM3Bjc1hUVFpUMEZqMEZWWXJqREY1?=
 =?utf-8?B?MGE4NFR4NmR6TzNGMUxRRUVMcDJxNkVUTXZPeGN1d1lGckpHK2cxQzdBWlJo?=
 =?utf-8?B?NWptUnJBQW5TZ0FxUjBYdExrbDFlbFRlK0svcFhlOWhCM3NhQmdueE1GSlZ0?=
 =?utf-8?B?TCtlL2RxY2d4OS9sTTdIV0FUemZwNXFzRFIvNHRldFpoSzhIYWg1NDBGQTM2?=
 =?utf-8?B?SlM4MUoxRlBGNTBLY1VqZ24zOGdoVTUyNWx3SGVDNzY0Qk83Q2JxOU1jdHd3?=
 =?utf-8?B?UHErMTZWVzJqMnFQZHkzZFVEdVZXNWYvUmgvL0xvSlplNEU1SWdIKzJJWmZS?=
 =?utf-8?B?a283YUt6a2lOVFpaNStaeURPYk1EODdSVGJqbG9rakFnUnBvWmpvVjZIalU5?=
 =?utf-8?B?UlFzSkxmWnZPUEx1QTRpS1VSMVJraDVoVlhYTXVhT0MrWENWSnFEYjNjREVO?=
 =?utf-8?B?K050T05yTnJmY0ltTTZTUkV0MXBFTHk0UjVvUGxqMVplNEpUdWM5ciszUTUy?=
 =?utf-8?B?cFhMZ3h6TnI2bDh2QXlvL09OT1lNYkxWRnh3cEwyL081MGN4b05hNXpETWha?=
 =?utf-8?B?Q0NZaEswdE9RMm5sQnFQWVlRamh3eXJZbzh4QVBmV2JXbFNVR0Zpc1hBb2hZ?=
 =?utf-8?Q?RS5GHmdpZcKbZcrKfe9A+fzmDflHZV2VvPXssCQ?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR03MB3618.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44fcf7c9-6f15-4171-4225-08daa7445e17
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2022 02:42:10.4075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3tyiYFR6AGR+1bXd92bYMhbI6Uysk0CIp+ANGNN8DO7F55XEKnTe//3yDLHPSWT49IT2sIf82meLIWgVU1q3WJwuOTcJChSkNR5plCjcVxI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR03MB5406
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMDUvMTAvMjAyMiAyMzowMiwgU3VyYWogSml0aW5kYXIgU2luZ2ggd3JvdGU6DQo+IHRsO2Ry
OiBUaGUgZXhpc3RpbmcgbWl0aWdhdGlvbiBmb3IgZUlCUlMgUEJSU0IgcHJlZGljdGlvbnMgdXNl
cyBhbiBJTlQzIHRvDQo+IGVuc3VyZSBhIGNhbGwgaW5zdHJ1Y3Rpb24gcmV0aXJlcyBiZWZvcmUg
YSBmb2xsb3dpbmcgdW5iYWxhbmNlZCBSRVQuDQoNCk5vIGl0IGRvZXNuJ3QuwqAgVGhlIElOVDMg
aXMgdHJhbnNpZW50LsKgIFRoZSBleGlzdGluZyBtaXRpZ2F0aW9uIHVzZXMgYW4NCkxGRU5DRS4N
Cg0KPiBSZXBsYWNlIHRoaXMgd2l0aCBhIFdSTVNSIHNlcmlhbGlzaW5nIGluc3RydWN0aW9uIHdo
aWNoIGhhcyBhIGxvd2VyIHBlcmZvcm1hbmNlDQo+IHBlbmFsdHkuDQoNCldoYXQgaXMgInRoaXMi
P8KgIFRoZSBJTlQzXlcgTEZFTkNFPw0KDQpXUk1TUiBpcyBub3QgbG93ZXIgb3ZlcmhlYWQgdGhh
biBhbiBMRkVOQ0UuDQoNCj4gPT0gU29sdXRpb24gPT0NCj4NCj4gVGhlIFdSTVNSIGluc3RydWN0
aW9uIGNhbiBiZSB1c2VkIGFzIGEgc3BlY3VsYXRpb24gYmFycmllciBhbmQgYSBzZXJpYWxpc2lu
Zw0KPiBpbnN0cnVjdGlvbi4gVXNlIHRoaXMgb24gdGhlIFZNIGV4aXQgcGF0aCBpbnN0ZWFkIHRv
IGVuc3VyZSB0aGF0IGEgQ0FMTA0KPiBpbnN0cnVjdGlvbiAoaW4gdGhpcyBjYXNlIHRoZSBjYWxs
IHRvIHZteF9zcGVjX2N0cmxfcmVzdG9yZV9ob3N0KSBoYXMgcmV0aXJlZA0KPiBiZWZvcmUgdGhl
IHByZWRpY3Rpb24gb2YgYSBmb2xsb3dpbmcgdW5iYWxhbmNlZCBSRVQuDQoNCldoaWxlIGJvdGgg
b2YgdGhlc2Ugc2VudGVuY2VzIGFyZSB0cnVlIHN0YXRlbWVudHMsIHlvdSd2ZSBtaXNzZWQgdGhl
DQpuZWNlc3Nhcnkgc2FmZXR5IHByb3BlcnR5Lg0KDQpPbmUgQ0FMTCBoYXMgdG8gcmV0aXJlIGJl
Zm9yZSAqYW55KiBSRVQgY2FuIGV4ZWN1dGUuDQoNClRoZXJlIGFyZSBzZXZlcmFsIHdheXMgdGhl
IGZyb250ZW5kIGNhbiBlbmQgdXAgZXZlbnR1YWxseSBjb25zdW1pbmcgdGhlDQpiYWQgUlNCIGVu
dHJ5OyB0aGV5IGFsbCBzdGVtIGZyb20gYW4gZXhlY3V0ZSAobm90IHByZWRpY3Rpb24pIG9mIHRo
ZQ0KbmV4dCBSRVQgaW5zdHJ1Y3Rpb24uDQoNCkFzIHRvIHRoZSBjaGFuZ2UsIC4uLg0KDQo+IGRp
ZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jIGIvYXJjaC94ODYva3ZtL3ZteC92bXgu
Yw0KPiBpbmRleCBjOWI0OWEwOWU2YjUuLmZkY2Q4ZTEwYzJhYiAxMDA2NDQNCj4gLS0tIGEvYXJj
aC94ODYva3ZtL3ZteC92bXguYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+IEBA
IC03MDQ5LDggKzcwNDksMTMgQEAgdm9pZCBub2luc3RyIHZteF9zcGVjX2N0cmxfcmVzdG9yZV9o
b3N0KHN0cnVjdCB2Y3B1X3ZteCAqdm14LA0KDQouLi4gb3V0IG9mIGNvbnRleHQgYWJvdmUgdGhp
cyBodW5rIGlzOg0KDQrCoMKgIMKgaWYgKCFjcHVfZmVhdHVyZV9lbmFibGVkKFg4Nl9GRUFUVVJF
X01TUl9TUEVDX0NUUkwpKQ0KwqDCoCDCoMKgwqDCoCByZXR1cm47DQoNCm1lYW5pbmcgdGhhdCB0
aGVyZSBpcyBhIHJldHVybiBpbnN0cnVjdGlvbiB3aGljaCBpcyBwcm9ncmFtbWF0aWNhbGx5DQpy
ZWFjaGFibGUgYWhlYWQgb2YgdGhlIFdSTVNSLg0KDQpXaGV0aGVyIGl0IGlzIHNwZWN1bGF0aXZl
bHkgcmVhY2hhYmxlIGRlcGVuZHMgb24gd2hldGhlciB0aGUgZnJvbnRlbmQNCmNhbiBzZWUgdGhy
b3VnaCB0aGUgX3N0YXRpY19jcHVfaGFzKCksIGFzIHdlbGwgYXMNClg4Nl9GRUFUVVJFX01TUl9T
UEVDX0NUUkwgbmV2ZXIgYmVjb21pbmcgY29tcGlsZSB0aW1lIGV2YWx1YWJsZS4NCg0KVGhlcmUg
aXMgYWxzbyBhIHNlY29uZCBsYXRlbnQgYnVnLCB0byBkbyB3aXRoIHRoZSBjb2RlIGdlbmVyYXRp
b24gZm9yDQp0aGlzX2NwdV9yZWFkKHg4Nl9zcGVjX2N0cmxfY3VycmVudCkuDQoNCg0KSXQncyB3
b3J0aCBzYXlpbmcgdGhhdCwgaW4gcHJpbmNpcGxlLCB0aGlzIG9wdGltaXNhdGlvbiBpcyBzYWZl
LCBidXQNCnByZXR0eSBtdWNoIGFsbCB0aGUgZGlzY3Vzc2lvbiBhYm91dCBpdCBpcyB3cm9uZy7C
oCBIZXJlIGlzIG9uZSBJDQpwcmVwYXJlZCBlYXJsaWVyOg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcveGVuLWRldmVsLzIwMjIwODA5MTcwMDE2LjI1MTQ4LTMtYW5kcmV3LmNvb3BlcjNAY2l0cml4
LmNvbS8NCg0KDQpPVE9ILCBiZWxvdyB0aGUgaHVuayBpbiBxdWVzdGlvbiwgdGhlcmUncyBhIGJh
cnJpZXJfbm9zcGVjKCkgd2hpY2ggaXMNCmdpdmluZyB5b3UgdGhlIGFjdHVhbCBwcm9qZWN0aW9u
IHlvdSBuZWVkIChzdWJqZWN0IHRvIGxhdGVudCBhbmQvb3IgY29kZQ0KbGF5b3V0IGJ1Z3MpLCBp
cnJlc3BlY3RpdmUgb2YgdGhlIGV4dHJhIFdSTVNSLg0KDQp+QW5kcmV3DQo=
