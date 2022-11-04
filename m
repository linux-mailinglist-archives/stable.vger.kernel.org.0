Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0C8619007
	for <lists+stable@lfdr.de>; Fri,  4 Nov 2022 06:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiKDFjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Nov 2022 01:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiKDFjn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Nov 2022 01:39:43 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3772F252BA;
        Thu,  3 Nov 2022 22:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667540380; x=1699076380;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=S12i+JjeDeDG8j9K+AheH1lIZbd5k7zT3QEBnOgf1eY=;
  b=ERELTvcjxLBm39CKmVhFRwvsrGxp76NfpShFzJ5u2CuQRAPrYrmWsZhS
   fn/qXM+twfEsjW9lgU2cXVDQtpYn7YjIGRYsXhk/LGrCnzgaj1RSkuZr2
   +zvsrWdOpZgG4SZsDmzZOUO2X9NLJTP9c5MV++z7B0Grvsa7ianArA9Gr
   SWNTtbeSIZwyAb5s5cR654GSePjHRQqVxwM7VYxiX123IM1w0oVRiMXJ2
   BGeszcqbPrlyY7pSKdVoy/gT0iPB3gHeD21Y1lN65zQfiW6xjv+UW1qsP
   t4kiGZ4Q1HbW7RiiMCu0SA7OCu3WmGhObOT8U3jFkOxIkHgGR3SS09pXI
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="309876961"
X-IronPort-AV: E=Sophos;i="5.96,136,1665471600"; 
   d="scan'208";a="309876961"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2022 22:39:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10520"; a="964221722"
X-IronPort-AV: E=Sophos;i="5.96,136,1665471600"; 
   d="scan'208";a="964221722"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga005.fm.intel.com with ESMTP; 03 Nov 2022 22:39:39 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 22:39:39 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 3 Nov 2022 22:39:39 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 3 Nov 2022 22:39:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gdrhorQL0n8qBjBsnPI63j86q8UMimmiDlsotFeAo9/5lu/NOGbArRxsqS2cvHsVVYvMMmae9C5mNHaQsAoRuZNdlr+4bn2GNVC3kvuULIJcRH6OiednRm3FNQOf+6UoinTm0sQUIOgrLLl4fk1vV5XvvRgxZGRfNofzBXU/j5aVh3g782H9h3jTfR7zvO04EuqLfZ9rDpuHHoC3qDBZrvprirtWSMVkF/04a9Ri3evJ3jKsfnaozLOUrTgvwOANH2WPlvsUkncqmU+D/10naEAGDlolBapeWGmUWOlTIj/jIJhIv+5bovsF6J3DdQOzEXZRAU8fYisn317aN6G3Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S12i+JjeDeDG8j9K+AheH1lIZbd5k7zT3QEBnOgf1eY=;
 b=aPBEX+tcfWG2e9hsUfeGbtK0WU47CF9H5EKwfPYFceauofIo/Bs84aztE4PvabfVfar/IixNpm0D35I50IRG21qx/OGs4d5gziRPoBWVrrlt5CyekRytIw5Pdn/gqWH1f0N9TqrwncB8mslzG0+USgp0cJCbjweMODyYucPDnOoVELYqUac1azNFK/HFb/8S7A7vgs2453q+dbPxUi9wQHvyIuKfUaOYAaafaKl1yNqVkRIuhwUh8ZyLWxt+O6VlEvEP/UWiaXTHckOBuQHfa3acczgIyldRFRdGEppcIlHX0Xc7Gfvv9AnoKZ1HOKfyeqWkhzt2pwVhq3Q8RTPpLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by SJ0PR11MB6766.namprd11.prod.outlook.com (2603:10b6:a03:47c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 4 Nov
 2022 05:39:36 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::c275:940e:a871:646e]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::c275:940e:a871:646e%7]) with mapi id 15.20.5791.022; Fri, 4 Nov 2022
 05:39:36 +0000
From:   "Verma, Vishal L" <vishal.l.verma@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC:     "Schofield, Alison" <alison.schofield@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [PATCH 2/7] cxl/region: Fix cxl_region leak, cleanup targets at
 region delete
Thread-Topic: [PATCH 2/7] cxl/region: Fix cxl_region leak, cleanup targets at
 region delete
Thread-Index: AQHY7+SwQuBa/s5JlE2FjuHbD4/Hza4uP9uA
Date:   Fri, 4 Nov 2022 05:39:36 +0000
Message-ID: <69231be8c337443403022b82de73c1723b454478.camel@intel.com>
References: <166752181697.947915.744835334283138352.stgit@dwillia2-xfh.jf.intel.com>
         <166752183055.947915.17681995648556534844.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166752183055.947915.17681995648556534844.stgit@dwillia2-xfh.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 (3.44.4-2.fc36) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|SJ0PR11MB6766:EE_
x-ms-office365-filtering-correlation-id: f02e915b-54f5-488c-8c09-08dabe26f5a9
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: whTlBWY/kVCTj6Dl9St1RAhV4ZCOBHFyzoJfCmq25yFUJweMWkzL2kUBMFEwT2cldXRIzGRhLRxoiN4GjFCjc/cWBLFSjLTgX/LSLa2LzFScZOnwWoDu09C53i0Rh+whltlwVbKBRUeSvGnXFzsbGyxXPD4QaNKOFAr3l+7ORPfEiVpHgpGjGPzE6kbuyhZRHaWAAyncYQZZEgkQ3s0v+k6Jc2pQPe5o+xdwYPF9LehLKVk+F3ZCFZe3SA07jufJ6cw87YdutS98G8WeJGT0YiPPfWyx49HnVoV15M70XAzvCE45X5iTkDiXEsOrd3O43zf1gZgkmK79lFQUXXYmSkQLn+Y6nwk+V0K+kRlkq7M/BpMenYkNNI99vXv/CSSRybgisXzpMw63DwZoMe/pxCv7+pse0mx+hMk04m32pD+DFDVK6FPJR9EJqEcdSNvq1vbwEDkm52Wtd22c+rHCUBqijC3vioUYBrRIN5s+WVwSV4bon/mp5fU2pUCGzNxE26YBY2H36RIBoR/N/zu0yqcEX8GsYltk+eKvgmUMsC4m9jEMIf8lNS3caDLKIOMdmRaO0jVfQqQMYkcTEsfvjw8A7SnR96DL0cQUZ75pKjaHAHiZjYsD1AAlXFxDwanpMD2xtMuYiZJc1QXzWuGDz2JH+Erp32Sk09Fzxahxxgsw58Ipm/JDr8bUUsRTumqM3Ry9JRTU9CXULE5LEmciBKJxPQVVmuux7/zyBegJxG+kPJvhQBHVUrVjUpEQuzwkWtneuvcAUbBqy4t7pr0pyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(396003)(376002)(39860400002)(366004)(451199015)(38070700005)(316002)(6506007)(54906003)(110136005)(5660300002)(66556008)(66476007)(450100002)(8676002)(36756003)(64756008)(91956017)(66946007)(76116006)(26005)(4326008)(66446008)(6512007)(8936002)(71200400001)(2616005)(83380400001)(186003)(122000001)(82960400001)(107886003)(86362001)(6486002)(478600001)(38100700002)(41300700001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VTRoS0pJa0RiL3lhUU4yQitYS3J4VVZ6bUdCVk83STBHN0hmWFFETHpmSER3?=
 =?utf-8?B?YjR3U2kyUjZ3c3Y2V093YmF6S0hpOG15c2wyY2VnYnBnL2hPanhsMEkxZ2Nk?=
 =?utf-8?B?QXhac1o0NHpZeWNFRUZjcU9UUU5wMVZ5ZGxmZ3dSVEFTVTh3VENkbzhJWGVz?=
 =?utf-8?B?RE1jaXEyQ3cyM054aGYyTGdvbFIrT1JuazByTWFRSlN4a3hzOWl6bFVCZHlR?=
 =?utf-8?B?VTlqTXg2bjN6RTJoVk5TdmVSK005TzVlMUtpWjJuK05ndjhOdktjQk1nM3NM?=
 =?utf-8?B?UEl1MHp4a054cUhkVFI4elJjeHFpOG1OWDJOdXFudjRzUFkyZ1o4OUNzS1la?=
 =?utf-8?B?bkZYWVc5b3VjL21XUG9UVU4rKzVZRDFkTXpSM3JNdWMySlBiVERMekMwRlJI?=
 =?utf-8?B?dk1oMHJiREwveU9lcFc1Yk8rbUYwSTZRbDFSRG5zYmY5TXJOTUpjQW9MWlNu?=
 =?utf-8?B?OXJvSXd2cUdFeVVLbGE5VERQcytNbmRudlo2U1ErbG53US9Ua1kxaXZPTDdJ?=
 =?utf-8?B?SWQ1cUpETDZSSytISktMV2owbm9XYWY0WUpIQ2QyYUVQNFhLeWtTci9nYzNG?=
 =?utf-8?B?RmdCUDc4ZFdVRUJyMy9pVERMa3pCWDBObW8xN3FtNUdIQjNoMjkxenRaTm1J?=
 =?utf-8?B?aGdvcG5NVTY5bkJxblZBY2g0NWRUeGtFR3dUc21FZ2kvVXZaYlk4dFIwaVpX?=
 =?utf-8?B?L3RHUTQ1R0Y4WldpcFo2TWlKVlFQMHNlTlgzYmY4L1pnUjlZZUNiWTJFUFh3?=
 =?utf-8?B?V2REUHFRaDZMMHJhNlpXWUUxeXl3aGtDbEl6dGVJTU5Fanl5TklvbUUxYXJN?=
 =?utf-8?B?Q3pwamJZRE4rUG5reTI4eG1FendlMUFzZlhYak92bHVzVFFIT3l0aGI4bUhq?=
 =?utf-8?B?M1RhS05LejUzNzVGNldjeFpvSGQ4UE9MMnhqTHBSYzVvT3BUYnlZUXJMY2dn?=
 =?utf-8?B?OERzWmIrUFNZMDVZNzc2bndIa00rRElUL3RzZHBCZE10UFgycEN6am1hWExq?=
 =?utf-8?B?VWRDY053RGhtVURkZzNQcG9oTkExN0JnQjZGMUJpTjhqV3FrSCtSQUZDMDdH?=
 =?utf-8?B?eU5ob2pQRkhxVm0zUTc1YVhNZnlJM21pblNvS1JRME9Pc2tIN3M0azFjdE5h?=
 =?utf-8?B?NDB5VkNKbEh5SFZrb2Yzd05ITjlpbGowTnRaOStJYzNkUFlCYW0wdURwY3k4?=
 =?utf-8?B?VlRHVkJQWmRBVG5ndGV6MEJSaGRBZ0NWOHNhc2RRY3VMbU1Bc0Q2TU9GczJx?=
 =?utf-8?B?eForREpReXRJc1dPYkVYdUV3cUJPMSt0bFVMSU1MNFhaL1F4bHNwK1gxMnVs?=
 =?utf-8?B?TDVFMG9qOC95SEE3MGZyd1lKUUMvRDVFSk1WZVJ2Z0JObEI4Z09KSHcxUnFa?=
 =?utf-8?B?Sk9OZVdNUC8vU3d0RWJPS002VGJSRnZEOFpyRWtFZC96ZkxIbTU0eGxyOHNu?=
 =?utf-8?B?bm9yc1FSN2tiWWdXNDM4bmhXY010alBjcXRGNTNoM0l2aVJHYWF2blErK00y?=
 =?utf-8?B?dFY4YnF6U291bkRSQ3RuaisvSFZqOHB5bGIvaG9Gc0MwZzJSbnlUM29zUXMr?=
 =?utf-8?B?anpDQXk2K25Pd08xT3NBNk4yZk9tc0taRWlFK0FuckRVQ2VvbzdCdTdweUlu?=
 =?utf-8?B?ZzBVZVRkb3p4RjVHaVkxdHRwVC9ycnNsTnA1UWRWVFFueVV2dE9WQzRwb1RI?=
 =?utf-8?B?K0NBbFBYNWZNRUNTc3Z4Rlo5ZklzRFVDUTNheVk3dTZMZFRzWXIycW1oZmNu?=
 =?utf-8?B?cVhReTdyU1Jnd3RyMno5S3BUZzFIZFFXdWtsc01qLzQ1Z3MzTDd4enlaMG5E?=
 =?utf-8?B?cHVNZExtaGVHS1RhQkhqYTFBQ1QwR0phUDMzbjRuSlJRUlA1N2hhU0NvZGk2?=
 =?utf-8?B?UTlUQlJlZ0pPMWcrZy93c0srNUwzZ0lkNmZrRjgvcEljeWlsbGEyRXZPeGoy?=
 =?utf-8?B?cFMyL3Q5UUZSOVkwRmJSZlRtMStPdU1pOWVoclV2THFxQ0U5ejRHL3E3d2NQ?=
 =?utf-8?B?WEd5UStYdFRNVlRYcHlkZkRpdVhFUGs1cnBUZ0dmdDhaZTJvL0p4eEpidW5I?=
 =?utf-8?B?dFU1WmFScWpwUFRpSWVHMXZFd2hlOTJtbi9FN3JaVFhvZFJkdFFFWWZEVkEx?=
 =?utf-8?B?TGd5b2dkQUoycElwTk5RNnR3VTNwYkVRd1FxUXFDeFVNR0JvOHZMblVMTFVM?=
 =?utf-8?B?Snc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <45E6035BE257224B89FE46713276C462@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f02e915b-54f5-488c-8c09-08dabe26f5a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2022 05:39:36.5285
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DelNiFER8cWa1P3VEdfRjhLpjCB6BKbdL9ICQ/CtNkgkfy4m/7O3N39uX+RC3cbDgbGp7NKxppMja1JT90a7aclphwDygGGlCCvrIoostcc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6766
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIyLTExLTAzIGF0IDE3OjMwIC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IFdoZW4gYSByZWdpb24gaXMgZGVsZXRlZCBhbnkgdGFyZ2V0cyB0aGF0IGhhdmUgYmVlbiBwcmV2
aW91c2x5IGFzc2lnbmVkDQo+IHRvIHRoYXQgcmVnaW9uIGhvbGQgcmVmZXJlbmNlcyB0byBpdC4g
VHJpZ2dlciB0aG9zZSByZWZlcmVuY2VzIHRvDQo+IGRyb3AgYnkgZGV0YWNoaW5nIGFsbCB0YXJn
ZXRzIGF0IHVucmVnaXN0ZXJfcmVnaW9uKCkgdGltZS4NCj4gDQo+IE90aGVyd2lzZSB0aGF0IHJl
Z2lvbiBvYmplY3Qgd2lsbCBsZWFrIGFzIHVzZXJzcGFjZSBoYXMgbG9zdCB0aGUgYWJpbGl0eQ0K
PiB0byBkZXRhY2ggdGFyZ2V0cyBvbmNlIHJlZ2lvbiBzeXNmcyBpcyB0b3JuIGRvd24uDQo+IA0K
PiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+DQo+IEZpeGVzOiBiOTY4NmU4YzhlMzkgKCJj
eGwvcmVnaW9uOiBFbmFibGUgdGhlIGFzc2lnbm1lbnQgb2YgZW5kcG9pbnQgZGVjb2RlcnMgdG8g
cmVnaW9ucyIpDQo+IFNpZ25lZC1vZmYtYnk6IERhbiBXaWxsaWFtcyA8ZGFuLmoud2lsbGlhbXNA
aW50ZWwuY29tPg0KPiAtLS0NCj4gwqBkcml2ZXJzL2N4bC9jb3JlL3JlZ2lvbi5jIHzCoMKgIDEx
ICsrKysrKysrKysrDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKykNCg0KTG9v
a3MgZ29vZCwNCg0KUmV2aWV3ZWQtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50
ZWwuY29tPg0KDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jeGwvY29yZS9yZWdpb24uYyBi
L2RyaXZlcnMvY3hsL2NvcmUvcmVnaW9uLmMNCj4gaW5kZXggZDI2Y2E3YTZiZWFlLi5jNTI0NjVl
MDlmMjYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvY3hsL2NvcmUvcmVnaW9uLmMNCj4gKysrIGIv
ZHJpdmVycy9jeGwvY29yZS9yZWdpb24uYw0KPiBAQCAtMTU1Nyw4ICsxNTU3LDE5IEBAIHN0YXRp
YyBzdHJ1Y3QgY3hsX3JlZ2lvbiAqdG9fY3hsX3JlZ2lvbihzdHJ1Y3QgZGV2aWNlICpkZXYpDQo+
IMKgc3RhdGljIHZvaWQgdW5yZWdpc3Rlcl9yZWdpb24odm9pZCAqZGV2KQ0KPiDCoHsNCj4gwqDC
oMKgwqDCoMKgwqDCoHN0cnVjdCBjeGxfcmVnaW9uICpjeGxyID0gdG9fY3hsX3JlZ2lvbihkZXYp
Ow0KPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgY3hsX3JlZ2lvbl9wYXJhbXMgKnAgPSAmY3hsci0+
cGFyYW1zOw0KPiArwqDCoMKgwqDCoMKgwqBpbnQgaTsNCj4gwqANCj4gwqDCoMKgwqDCoMKgwqDC
oGRldmljZV9kZWwoZGV2KTsNCj4gKw0KPiArwqDCoMKgwqDCoMKgwqAvKg0KPiArwqDCoMKgwqDC
oMKgwqAgKiBOb3cgdGhhdCByZWdpb24gc3lzZnMgaXMgc2h1dGRvd24sIHRoZSBwYXJhbWV0ZXIg
YmxvY2sgaXMgbm93DQo+ICvCoMKgwqDCoMKgwqDCoCAqIHJlYWQtb25seSwgc28gbm8gbmVlZCB0
byBob2xkIHRoZSByZWdpb24gcndzZW0gdG8gYWNjZXNzIHRoZQ0KPiArwqDCoMKgwqDCoMKgwqAg
KiByZWdpb24gcGFyYW1ldGVycy4NCj4gK8KgwqDCoMKgwqDCoMKgICovDQo+ICvCoMKgwqDCoMKg
wqDCoGZvciAoaSA9IDA7IGkgPCBwLT5pbnRlcmxlYXZlX3dheXM7IGkrKykNCj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRldGFjaF90YXJnZXQoY3hsciwgaSk7DQo+ICsNCj4gwqDC
oMKgwqDCoMKgwqDCoGN4bF9yZWdpb25faW9tZW1fcmVsZWFzZShjeGxyKTsNCj4gwqDCoMKgwqDC
oMKgwqDCoHB1dF9kZXZpY2UoZGV2KTsNCj4gwqB9DQo+IA0KDQo=
