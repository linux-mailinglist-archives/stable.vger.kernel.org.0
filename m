Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5818C201F7D
	for <lists+stable@lfdr.de>; Sat, 20 Jun 2020 03:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731423AbgFTBhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 21:37:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:37309 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731418AbgFTBhu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 21:37:50 -0400
IronPort-SDR: JuuGMzE/j6eAuRBnDgU+wuTdg9DG4B2rG0XO9xWC9U1Wxb/xyUG3fEVzNOj1T5cB6Hh/q7kau7
 +H7KkrLwphOw==
X-IronPort-AV: E=McAfee;i="6000,8403,9657"; a="142262526"
X-IronPort-AV: E=Sophos;i="5.75,256,1589266800"; 
   d="scan'208";a="142262526"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2020 18:37:48 -0700
IronPort-SDR: UvoCD/G3oFC1HVTHJ6vaE/NUBFNH4ZT3KDYInbi9H2iXGvUi85HWZ2jm74cl567fkIHr3Z/afD
 AQHd1hSqrmxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,256,1589266800"; 
   d="scan'208";a="318285664"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Jun 2020 18:37:48 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 19 Jun 2020 18:37:48 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 19 Jun 2020 18:37:47 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 19 Jun 2020 18:37:47 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Fri, 19 Jun 2020 18:37:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kS0uUvu2oKUetTy8oBLAtbZLClSASCqgLToHjFBOaaF88KFGWTX7q8uvAQTpioHUAmYznYXgO1SsaZzetc54T+n9TF0hcSGj1jswHsx9Ky4wzBZTiQ82SCV1K+B92a0fnZAnME6edfwDudvihC7CVW9JUT/bPCJzTdAt6FuoqHYIV0xsDsU6AkibgkwzV7VWqbC02i4/m61nlW6XjXz0zsJi1XBOGnUR9jzshpHf+SCAfhImjkml+a2VKIOIcVMZkyFhzYbFVv+dAS0/y2udUxjExZ6jwagll7k9ajtZpUOt9iMzSy01toghmy+pNcm/hNyhxAHTEPtwcdEieBzFlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZU0IyHDbdUGZI1KqRqsqnv99mXPC/5lDZJgC3eiecq8=;
 b=XqGTSzcWO8U9CDOAj/ZBzDGJBfLcUaCZFe9jBWGXe0q7RGmEZ7OJSejNa0JAf8kl/Cfce8/zkYMh3/PherpQOKjGQ+13j9fTVPIFgBS9KKWqNRMVu0RgGUMPocvMAU7IDc1f6GSQ6cLHz1qZLs6z3gSnue1iDhbctPPAlGi+1KMd8LsIBKciY/PN3yWuYiezbM0ZW1Tjj+R/5YxdB6tUv+25oT95E7gtk5zHUtfc0BtnOsHB0xzKdZUPvwLG+bxtCh1lvfU6mSTAsoqAh2oncW9j11FZANKMjK/5T8X1R/n5NuGu9DwDHRlbrEwZsEHpzxF9biI3ZPd0XrAPF+ERuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZU0IyHDbdUGZI1KqRqsqnv99mXPC/5lDZJgC3eiecq8=;
 b=jc23iq4164LrHTKRqlqn4Y4M3ZR+LVpeZM1oKmGwSSUgqxOJk2R1p+VYJCXB5Dq6Lecyl8AJbD751a53cmcBllnrgXkO1fd3URWe7yzxHRSmBoVQOjbKQT9SKrcy2xcpv+AHXkoBNe/ZOh7Mo5tocXzsFvNsCjlNkJ09b5xk88Q=
Received: from BN6PR11MB4132.namprd11.prod.outlook.com (2603:10b6:405:81::10)
 by BN8PR11MB3780.namprd11.prod.outlook.com (2603:10b6:408:90::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Sat, 20 Jun
 2020 01:37:45 +0000
Received: from BN6PR11MB4132.namprd11.prod.outlook.com
 ([fe80::f1fa:3128:2198:e48d]) by BN6PR11MB4132.namprd11.prod.outlook.com
 ([fe80::f1fa:3128:2198:e48d%4]) with mapi id 15.20.3109.023; Sat, 20 Jun 2020
 01:37:45 +0000
From:   "Williams, Dan J" <dan.j.williams@intel.com>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "Huang, Ying" <ying.huang@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "richard.weiyang@gmail.com" <richard.weiyang@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "mhocko@suse.com" <mhocko@suse.com>,
        "mgorman@techsingularity.net" <mgorman@techsingularity.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] mm/shuffle: don't move pages between zones and
 don't read garbage memmaps
Thread-Topic: [PATCH v2 1/3] mm/shuffle: don't move pages between zones and
 don't read garbage memmaps
Thread-Index: AQHWRqNlMdaKs5n8vkexxU3ANW17sA==
Date:   Sat, 20 Jun 2020 01:37:45 +0000
Message-ID: <52c25f52d25d989b54e974f7c5c1c7de1bae674f.camel@intel.com>
References: <20200619125923.22602-1-david@redhat.com>
         <20200619125923.22602-2-david@redhat.com>
In-Reply-To: <20200619125923.22602-2-david@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.5 (3.32.5-1.fc30) 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.223]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 227d9224-0083-4e53-6206-08d814ba883a
x-ms-traffictypediagnostic: BN8PR11MB3780:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB378010CB01CD587CC6DF92CBC6990@BN8PR11MB3780.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0440AC9990
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lBde4+kj8fq97g465uiaYa5yB+TJGcAD+Z4oYrYUIKOrHgZ3HWfE1cgb+C7m0LMwZn53huXTb1q2GjTqToFNDfxpgPFaXxJaK++YDKbD08EOnH9KHzxUci738/zyHH3T3BRTvlxI6DXrg944VEbwwfoAFIlgX5NZJHttli7+eEluhSxJ453wdmFpY/xqj6IUSre9eTOkcxwCoeYnC5eCRClmcHIJYiUAyo0k6SRmjDwZhmgoh6moCu8Fj1CcwEQjgitl6gV3DQbwp8XjhuSCUiuAlF3wGdyp0ILbgnY9gCPVxWJkykouWwtN6xJZ61qNm4oyF6Rh5niHMzTyOd2Mfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4132.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(83380400001)(71200400001)(2906002)(26005)(8936002)(186003)(6486002)(8676002)(4326008)(6506007)(7416002)(54906003)(2616005)(110136005)(86362001)(91956017)(66946007)(76116006)(6512007)(5660300002)(36756003)(66446008)(316002)(66556008)(478600001)(64756008)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 9Qd16Hobf9UYCTIYxsFo+wiJx5bV1Kk3B1NsvdLpCYINyDpkYcqcM0a9wNnk2rxuRKjXof3TguG5Y/OmCexTApej3srSf/ysmyXCHUwPuV8LRzgWs2Bba1FSPemKDUkbKiAS1yBRpQRG35py4yDx86ELzeT0NkDUOtdYoEmNRjgJ3N5XZOQe3XP4SY5DyMmqMnfU2yF/GdYJ/MsbOFIJCAC82aCg3anPa/0B/dMNeANCX7B6tCQdfpIGZRA17C68e5aYbIgrn/d+N2yc8YusgKc6a33zlbtIEXN4xSBkZi/xZgtB2osMEPuLNBelgHf0EhuqhM/S+1YvVBIc4DWdUWM6n3dra+iKpgEVp3IWZqZGIMy4phYtF0tglgIA6JwS94nPj3qFZn3LCZf69OUwIvOQ3LMDjRBapqyQlmobQYhNrOtY9COpMAlSZuwANm89oknVEnDW4fiuZu8WpZJ9tSQBM+tzo9zl8iV+zbQhOy4=
Content-Type: text/plain; charset="utf-7"
Content-ID: <7C683C8E3AA38147BEEAEE67C0A4ACCE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 227d9224-0083-4e53-6206-08d814ba883a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2020 01:37:45.3066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UyKu58XgkJHlPaoFIIICNBBojSZNZYEHwyNRp3eOAqNr4jeYpZHb1ydqpsdbu51wOQA+4CDnLEJbCMmsD9BblIwtR672rgkXeHgHNsgpxmE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3780
X-OriginatorOrg: intel.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2020-06-19 at 14:59 +-0200, David Hildenbrand wrote:
+AD4- Especially with memory hotplug, we can have offline sections (with a
+AD4- garbage memmap) and overlapping zones. We have to make sure to only
+AD4- touch initialized memmaps (online sections managed by the buddy) and
+AD4- that
+AD4- the zone matches, to not move pages between zones.
+AD4-=20
+AD4- To test if this can actually happen, I added a simple
+AD4- 	BUG+AF8-ON(page+AF8-zone(page+AF8-i) +ACEAPQ- page+AF8-zone(page+AF8=
-j))+ADs-
+AD4- right before the swap. When hotplugging a 256M DIMM to a 4G x86-64 VM
+AD4- and
+AD4- onlining the first memory block +ACI-online+AF8-movable+ACI- and the =
second
+AD4- memory
+AD4- block +ACI-online+AF8-kernel+ACI-, it will trigger the BUG, as both z=
ones (NORMAL
+AD4- and MOVABLE) overlap.
+AD4-=20
+AD4- This might result in all kinds of weird situations (e.g., double
+AD4- allocations, list corruptions, unmovable allocations ending up in the
+AD4- movable zone).
+AD4-=20
+AD4- Fixes: e900a918b098 (+ACI-mm: shuffle initial free memory to improve
+AD4- memory-side-cache utilization+ACI-)
+AD4- Acked-by: Michal Hocko +ADw-mhocko+AEA-suse.com+AD4-
+AD4- Cc: stable+AEA-vger.kernel.org +ACM- v5.2+-
+AD4- Cc: Andrew Morton +ADw-akpm+AEA-linux-foundation.org+AD4-
+AD4- Cc: Johannes Weiner +ADw-hannes+AEA-cmpxchg.org+AD4-
+AD4- Cc: Michal Hocko +ADw-mhocko+AEA-suse.com+AD4-
+AD4- Cc: Minchan Kim +ADw-minchan+AEA-kernel.org+AD4-
+AD4- Cc: Huang Ying +ADw-ying.huang+AEA-intel.com+AD4-
+AD4- Cc: Wei Yang +ADw-richard.weiyang+AEA-gmail.com+AD4-
+AD4- Cc: Mel Gorman +ADw-mgorman+AEA-techsingularity.net+AD4-
+AD4- Signed-off-by: David Hildenbrand +ADw-david+AEA-redhat.com+AD4-

Looks good to me.

Acked-by: Dan Williams +ADw-dan.j.williams+AEA-intel.com+AD4-

