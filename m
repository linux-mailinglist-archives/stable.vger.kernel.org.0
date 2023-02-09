Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CC6691212
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 21:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjBIU3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 15:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjBIU3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 15:29:13 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A0B6643ED;
        Thu,  9 Feb 2023 12:29:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675974550; x=1707510550;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FfoOWFnvmhQKfbENOMBENhk7EUgk2qZaBStRe3M+ECw=;
  b=Seo80DpbLBemY6QIckw8t+EslST0f9V14esIIDnFAnh+mjGcoucCyqgr
   abtaRvBC/uICEajkB+b/l5kbuNrg/x9Ade80zsR/kdzGYJ7APr+C8IX+y
   +gii50lzELCjIrjttTAADHs0eo4GLQE/g3B0ogsjQSS6WmfNgoWRmnr0D
   5KDlWSyPoeEPcBrq9JyPFUNB7AxVhQj0mdqxd4OOsI3wsc4WcloOACTt9
   ah8t83lScuWXobajhpd4rPfcYaNlFn8QrbC82vwiqUWB2p+TCk2LRPLio
   MgbYABf5xIfZ8zZOm7zcyBoQ0/wSfFyRewMc9vjQvSDjA75b4Lg3B0yDj
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="328871072"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="328871072"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2023 12:28:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10616"; a="913278931"
X-IronPort-AV: E=Sophos;i="5.97,284,1669104000"; 
   d="scan'208";a="913278931"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 09 Feb 2023 12:28:53 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 9 Feb 2023 12:28:53 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 9 Feb 2023 12:28:53 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 9 Feb 2023 12:28:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hz5I8dJai9/JreVWZMZZCiQ+KGrEhEXGbuFD+5Nq6PDj7GcaUP7xsWwOMxzz5jG6KETIqsplS0tr1vv6olr0VMbsknS06RpxK9AMJs3iZR5GRxjzXgugvMMR5hM1HrLK/tygOpIdnqAo9dSxXUlbAjdzlG3fAfufPZbWKuaT4R3zeLRStdoKA/g2h7dg5AEam8pU/xtTGJnaJCnos2iA12KHFdd9uoOb9Qm08TKvipZN8N2HC/TExFRmz6bo2UESIgIgh7hxzE2z7/OxA9EGWEeoRFh0gamNsFMXa12e0FwwO2BpBiNiK5V/SALd4QTVG+a7enoEDrrbDCR/dskk/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FfoOWFnvmhQKfbENOMBENhk7EUgk2qZaBStRe3M+ECw=;
 b=e236YY5nJIvQBh0Wwj1Si25E02xz/DXaDueRBAQuPQkOrXju1TV/LE+TiQZoAfxkbKc46TLO7LgSqs78gZ5UT8DDgDBT9B1HVuYUgiDSI5jSDSvx/j/jNazUOwZbCf4os4WVbie+Wc6CmiBMuQNkVKfj/Vnceb7/XM4r3uZO6cMXTdWZ7tuwUCrQuF+mCxbevj3xrGDVNE3cP9K9Z+ijfZqUUVA0EvjhLLE69tpONKbe82JtiUtibUfcRo0mNht/VS/xPbJMpLr+eCZIawshLZt2xiFgRHov/aubMDK2AfOuZ1PRGTrhWubeIz3Zw/JUhYgNrveCFRIrBj5b/V/e1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3999.namprd11.prod.outlook.com (2603:10b6:208:154::32)
 by DS0PR11MB6469.namprd11.prod.outlook.com (2603:10b6:8:c3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 20:28:51 +0000
Received: from MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::35af:d7a8:8484:627]) by MN2PR11MB3999.namprd11.prod.outlook.com
 ([fe80::35af:d7a8:8484:627%5]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 20:28:51 +0000
From:   "Verma, Vishal L" <vishal.l.verma@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 10/18] cxl/region: Fix passthrough-decoder detection
Thread-Topic: [PATCH 10/18] cxl/region: Fix passthrough-decoder detection
Thread-Index: AQHZOcbiPatDUgszpkODxA6SvBfLXK7HFq2A
Date:   Thu, 9 Feb 2023 20:28:51 +0000
Message-ID: <db7835f7e40d984238abd9fc342adb1b532f19dd.camel@intel.com>
References: <167564534874.847146.5222419648551436750.stgit@dwillia2-xfh.jf.intel.com>
         <167564540422.847146.13816934143225777888.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167564540422.847146.13816934143225777888.stgit@dwillia2-xfh.jf.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3 (3.46.3-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR11MB3999:EE_|DS0PR11MB6469:EE_
x-ms-office365-filtering-correlation-id: e8cae981-b1f8-403f-559a-08db0adc4196
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CA++EI/iWyZ1PJc/+2esusEOnhd1vDTDCNJ2hOLLVjDAd2Uwka43A8iBompE5qLIFPSCAlUVtPYSj9Wdci1tFycNfcSsri5cu83f5ryaoRUKnup9GR3dvvue46rpaAblEY3LY3mNhyTtTipSwGPjU6/L2hUy8EgtLFksJnxESc5nipcWHkQcmyR3e6ntimpGrAdsSeKfmZSPdgXLhlZCXHm13ZeIrP1AkMO1+fqwyM8k0ksCwkjdL80wlwBfc7sbLrmkUmphoHSGioPmnv2Ypz4yAd9oj6zVxCmqQTmXCsoF8Hv8QQWPCYvTt3H7Xh56kmP0yJSHqRqNbIhyW3zCMzVBSzgnvc5Gy2bbV3rQbM3nluSM8cZUXNjohSfJNFUFrBvUIC5FTzlUxICcOw3Zm6lwWimr4HG+wROQf50EiJLN9EL+SdoMh9Aa8XLSxJmvEP7OpCq47j4/RlMXFq6KRcB7+NTX6HR39ozdMK5I9WhM3YdlrtCBinTK/aC03Ifi+TVgU3H0jhs+380orjg7kzpHplA/JA0YHuw7f4uN3etkJBeU/ujvru5lOolVLITlRWX8fDDuKdFLjj5WTLJClAdr/r7WId4fsmJpVZtfHmDPUX0eo0htyrysEI3VaOS58dIDtpfQbPV9KdV/25OuZWHxuuPEec+iSOp4vlI4Jz8DqBijv0swcTjvxGchXEWGnD6Uqt2Ka0lwv23NHPdV3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3999.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(136003)(376002)(396003)(346002)(451199018)(36756003)(83380400001)(122000001)(38100700002)(82960400001)(6506007)(6512007)(186003)(26005)(110136005)(54906003)(71200400001)(2906002)(316002)(478600001)(6486002)(38070700005)(8936002)(41300700001)(5660300002)(86362001)(2616005)(91956017)(76116006)(4326008)(64756008)(8676002)(66946007)(66556008)(66476007)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SkZRMW8zNzJhUW15SURLUzBVci9Oalh1NWhzM3hIaXZuR0xVYk5URlNEZHJs?=
 =?utf-8?B?K1dBMmM3alcvV0k2VGJncjRRR2VhNjBDcDZXTDkyL1RSZThNaVBBU0I0dXJW?=
 =?utf-8?B?cU9PZnhtaHkwNStReGdQVmM5blVNeERFYThLNnl6dzNPbi9LVDM4N1NjZXI1?=
 =?utf-8?B?RW1nR3JTS2dYcXBmUGs0aDF1ZXJwSlI4SXVTZHVUK2E1ak9mSGdiMDFvcUNr?=
 =?utf-8?B?ZEhQOEZJMzcyb1ZWanRzenJYV2NrZTRIYXhRN3ljQkkvaGQ0UndIVHFjd3pt?=
 =?utf-8?B?U0dvcFpZVTdEeFk3VXh4emthR1A2alNFSnFFbEYwZVY1OTRVNW1Zbzd4aVpJ?=
 =?utf-8?B?alI4TThPVEFkOE5QQVBoUjJKb2dJbUl2cGg5ajBkdUFpWFgwZGN3SDQ3eGxv?=
 =?utf-8?B?T24wekxJUkhwaHQzd2xFa3FGYS9maVRYNTFPMjVONWpiYlJVYTlsWks2N0NY?=
 =?utf-8?B?T3NiSWlzM2FnajF6dkhESCtEcVBFSUxVa3k4aUJXOWhCRVJWK0NCbU9FY1U0?=
 =?utf-8?B?bWNqSHJtM2VUSWpON1h5V2dzOGNIN3VBQzY4Z3hlRkFiSkdDc3loZUpFdnB5?=
 =?utf-8?B?eG9HU2ZSMUJHNjk2OXFsanpkY1kyUFZBQ0tEVmtmYUVCWWNQUElyMFlSUEVI?=
 =?utf-8?B?QUR2Q012UlMxSTNRTDdXRnpNWkd2MzFYQndiVTBkTzFzZTNvT21xWDExYmJO?=
 =?utf-8?B?NnMzelFoRkx2R2x6ZHVnSW5DSmNmNXl0VThsaUMyMEVIQTJnVjNHSnhvUkFa?=
 =?utf-8?B?aVlMeW8yUW5mWVBMTUVIR0c2QlJPY2YyQkZCYnFsSzhhVk5HdW5oSk1RVFQy?=
 =?utf-8?B?QWhWbVN6TTJvd0haSU9iRUNzdVdVOGxnVkxWY2J4VTNKWXgwczdnQXAxdFZ3?=
 =?utf-8?B?UWJvVUVQTWNyOEpIVExFZHMrcjA1Mk9zV2p5MG5uYitFcm4ycVE1RlpZN1gv?=
 =?utf-8?B?ODZJcFRmeERHeDk3MWFZSkQ2Y1dST0dmSFliYmlWSVd1bmNGQnhhNW01eU9o?=
 =?utf-8?B?SXY5enYrSnZMeStLd0RHRXpXeU5sWEVRMXB0NGxCeCthRDdCekgrc1pFYk43?=
 =?utf-8?B?TGtKekhFYlFJS2Z5aldhZ2VlS1dxKzNnOG1HczV5WnhLOU96L2ZiMUpuemYz?=
 =?utf-8?B?R0ZRRVBnV0x4RWNDV2Z2L0J5ZjlQeFhDa1Z4NnZFTTBoK3VKV2MxSHpoSDhP?=
 =?utf-8?B?UmZxbzllU2JlUlJ1ekNnTStJeHhTeCsvT3UzREFlZDkydzRkMU9TZGlUeVVw?=
 =?utf-8?B?SDBQaXJXb2pLVEVzdTR3WTZTSTVuVjcrRHdpZE9YaVBJd3hkSXd6NTM5UFQx?=
 =?utf-8?B?NnZTc3ROWVR0bkNZQlp3LzlpeG1tQWVFZFYwTHdWZUZGU1lhRjZNUmhRVGxo?=
 =?utf-8?B?MlM1L3FXRitZWkw0S1JrL0I0SnhEWUJjbnRMaFNEVGQ0NldxN0JESjVCVXNp?=
 =?utf-8?B?T2diMUIwSFdhZUFweVRIdW1FYkRhTXMvTkRhQkhuYWNSTWJzdmxRa1dObk9n?=
 =?utf-8?B?TzhzalNzZEluQ3JFWFZqNFVqRlZ3TVQvT1hxZzdHZEdJWVJxc0k1TnBZODVG?=
 =?utf-8?B?NzlQV2NvdkIrL2twK1NhRnJBQnJqR25BcVdHVWt2eElaeW5leUU4dlNhZW5k?=
 =?utf-8?B?bmlnYlhXZS9KbWsxbU1yZjFLeEtOc1hEVisrdEJYSDZrZitFQkFVRVpWTVFV?=
 =?utf-8?B?c1QvYUk0OUNBSHVEZG9HK3pDMGlESUtvNVAyNHBkcklXUXE4SnZScHJicnNi?=
 =?utf-8?B?MDdhQUhwNkh4djM2MC9KNS81ZkdnU3JJRGl0M0FBU1d4UTRLdSsxeWVORGZO?=
 =?utf-8?B?VFN6UE5qLzRvenNRSk1zb0k3U0NhSVlQUy90L2plTkExengrelpzcnJiTHFF?=
 =?utf-8?B?Qjk1QlBHWEFTSW1WeXBxcW1oZmVZZ3ZaZk05SHM2VFNtVU1rVWdNcVV5Nkxw?=
 =?utf-8?B?b1A0NHhJSEZFOGMrMThOYlM1QmlDY0ZoTHpNOFBZV3VjSTZheU56em55ZUt0?=
 =?utf-8?B?Qk5kZXFZS0dtcnNSZlN6dVc3RnZtcUJ6Z09raTJOWmJYbllzbUZ3L0JhWXRs?=
 =?utf-8?B?V09pMHcrUk1TZGtrM3UrTnVTaHVpZUJVb3J5QWVSUnpsMjlIL2wyaEh6bm1o?=
 =?utf-8?B?M285Qkhrcng4TWcwb2kyU0JOYzNGZnozNU1XcHlPQ2ZNM28xRU1FOEZqRjhI?=
 =?utf-8?B?dnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4E10ADC0A9FFA04B8E537AA8DA2AE733@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3999.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8cae981-b1f8-403f-559a-08db0adc4196
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 20:28:51.1886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 53IvJ5lT+K7UPfr+SxRV1zXG4wVw+kWeRRPSlnnpMtJ/Jtjm7o69N3zPHO0QApDrYk+av9oF2n1YCuM+v0BPEQ5Bsak/ij5fVVCFFI5NGQs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6469
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gU3VuLCAyMDIzLTAyLTA1IGF0IDE3OjAzIC0wODAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6Cj4g
QSBwYXNzdGhyb3VnaCBkZWNvZGVyIGlzIGEgZGVjb2RlciB0aGF0IG1hcHMgb25seSAxIHRhcmdl
dC4gSXQgaXMgYQo+IHNwZWNpYWwgY2FzZSBiZWNhdXNlIGl0IGRvZXMgbm90IGltcG9zZSBhbnkg
Y29uc3RyYWludHMgb24gdGhlCj4gaW50ZXJsZWF2ZS1tYXRoIGFzIGNvbXBhcmVkIHRvIGEgZGVj
b2RlciB3aXRoIG11bHRpcGxlIHRhcmdldHMuIEV4dGVuZAo+IHRoZSBwYXNzdGhyb3VnaCBjYXNl
IHRvIG11bHRpLXRhcmdldC1jYXBhYmxlIGRlY29kZXJzIHRoYXQgb25seSBoYXZlIG9uZQo+IHRh
cmdldCBzZWxlY3RlZC4gSS5lLiB0aGUgY3VycmVudCBjb2RlIHdhcyBvbmx5IGNvbnNpZGVyaW5n
IHBhc3N0aHJvdWdoCj4gKnBvcnRzKiB3aGljaCBhcmUgb25seSBhIHN1YnNldCBvZiB0aGUgcG90
ZW50aWFsIHBhc3N0aHJvdWdoIGRlY29kZXIKPiBzY2VuYXJpb3MuCj4gCj4gRml4ZXM6IGU0ZjZk
ZmE5ZWY3NSAoImN4bC9yZWdpb246IEZpeCAnZGlzdGFuY2UnIGNhbGN1bGF0aW9uIHdpdGggcGFz
c3Rocm91Z2ggcG9ydHMiKQo+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4KPiBTaWduZWQt
b2ZmLWJ5OiBEYW4gV2lsbGlhbXMgPGRhbi5qLndpbGxpYW1zQGludGVsLmNvbT4KPiAtLS0KPiDC
oGRyaXZlcnMvY3hsL2NvcmUvcmVnaW9uLmMgfMKgwqDCoCA0ICsrLS0KPiDCoDEgZmlsZSBjaGFu
Z2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCgpMb29rcyBnb29kLAoKUmV2aWV3
ZWQtYnk6IFZpc2hhbCBWZXJtYSA8dmlzaGFsLmwudmVybWFAaW50ZWwuY29tPgoKPiAKPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9jeGwvY29yZS9yZWdpb24uYyBiL2RyaXZlcnMvY3hsL2NvcmUvcmVn
aW9uLmMKPiBpbmRleCBjODJkM2I2ZjNkMWYuLjM0Y2Y5NTIxNzkwMSAxMDA2NDQKPiAtLS0gYS9k
cml2ZXJzL2N4bC9jb3JlL3JlZ2lvbi5jCj4gKysrIGIvZHJpdmVycy9jeGwvY29yZS9yZWdpb24u
Ywo+IEBAIC0xMDE5LDEwICsxMDE5LDEwIEBAIHN0YXRpYyBpbnQgY3hsX3BvcnRfc2V0dXBfdGFy
Z2V0cyhzdHJ1Y3QgY3hsX3BvcnQgKnBvcnQsCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBpbnQgaSwgZGlzdGFuY2U7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoC8qCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIFBhc3N0aHJvdWdoIHBv
cnRzIGltcG9zZSBubyBkaXN0YW5jZSByZXF1aXJlbWVudHMgYmV0d2Vlbgo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBQYXNzdGhyb3VnaCBkZWNvZGVycyBpbXBvc2Ugbm8gZGlz
dGFuY2UgcmVxdWlyZW1lbnRzIGJldHdlZW4KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCAqIHBlZXJzCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKi8KPiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKHBvcnQtPm5yX2Rwb3J0cyA9PSAxKQo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAoY3hsX3JyLT5ucl90YXJnZXRzID09IDEp
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZGlzdGFu
Y2UgPSAwOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZWxzZQo+IMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRpc3RhbmNlID0gcC0+bnJf
dGFyZ2V0cyAvIGN4bF9yci0+bnJfdGFyZ2V0czsKPiAKPiAKCg==
