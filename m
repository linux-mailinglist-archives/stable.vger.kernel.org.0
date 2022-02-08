Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6FF4AD6E2
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 12:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241799AbiBHLaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 06:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356823AbiBHLIc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 06:08:32 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6508AC03FEC5;
        Tue,  8 Feb 2022 03:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644318511; x=1675854511;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7Yqt9Me3rvirigE3d9cr8aN9ZPM9Y78pNhy04CEmlHA=;
  b=kwQUCuEYSH/4h4oKb62zOrQK8Fz8r4Ys6FO6eHBWgIZ7JV6Y4aLlSbI5
   6MvAYMoez5NLZfw71GGCDbaNzJn4816/MUX64NEgUHevTGW/j6/pL6I7C
   vsOAhxs1JZOSpLjc2pTWD/OxtkI3Hh+u+ciQe+ZAlXiw0RWDB5QQlbL/s
   f8QNPzeCIxoV1RZfVd1APpfYAcmHAXyEDeo42pMuHg+la/uD5OOIJbeie
   fGr7EyFfEEaNo/nsbFv9LeKR2fKgLHNY/15I/OmdXIlF29zAQnA2hUtao
   8TGA5p7GE+Ovlaf9Q9K7KdcnuwgbIcv0SGXHGhBGvMv5/OxEbjPC8bnBl
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="246515571"
X-IronPort-AV: E=Sophos;i="5.88,352,1635231600"; 
   d="scan'208";a="246515571"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 03:08:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,352,1635231600"; 
   d="scan'208";a="621875399"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Feb 2022 03:08:30 -0800
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 8 Feb 2022 03:08:29 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 8 Feb 2022 03:08:29 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 8 Feb 2022 03:08:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+zUQeFMCJG8HNwPym/Y5vXYRu/ZXW4G64Z93SkfZU+2NAkU6BdhR9otbIoIBRbg8nMvOjn9Z0vk8o/eTWKhcAWGJlPzDYH80G/k2C+FdqLKYM1tYYJYg4dsrxDFxJ+/mwRV4IQfCGRDJTPCsG4Yv69RdDdRAGXlnfpll8rUlMQI/cpcz7g4URyhX8yw4iDi1a/p5FG8pyWdlL8v5J16y4o6qedYKgGjtYvy2fP5ia9ApUNfq9p3V1fP0B9hA3TjMAX2nVmEan48TAcxLBkEO6yk7YZ97esnEqXdj2QX/a2aSFghWdhv6xiTGiJqn+p9aMcUsLbQ6ifnXIJVzecVlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Yqt9Me3rvirigE3d9cr8aN9ZPM9Y78pNhy04CEmlHA=;
 b=FKAlyAd0L1AEPQuNvhfJxiR/51iWk74+ncT4YBpivmAXWVZjVOOTycskkhmnAg3hZiqtdR+mW0On2Xd0An+46qr0g5+Yau66gqxXHfzoaQGTFyBVJ7Fp432q3E4OYtETFDO9Y9SRXUT5EJ7X1aaNodifsljTPw1uYRLhpk38wdOxIIEMH7jUuc3aqcllANDXOp2bblGhSRT0z8efhb47M3ddpXkL10bqwJl40nBe3UmyQ8R3c4WauXwUDQZljUEr2iB/t1ULtSfxY/lE6FJr2m0xFLxIuhf2/ZZmAlxlLdS3U3XcSGV5FuFlx4a1vTjNkNknl8xlMOt6JZ+74tg72Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from DM6PR11MB2731.namprd11.prod.outlook.com (2603:10b6:5:c3::25) by
 SJ0PR11MB4911.namprd11.prod.outlook.com (2603:10b6:a03:2ad::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 11:08:26 +0000
Received: from DM6PR11MB2731.namprd11.prod.outlook.com
 ([fe80::b4f9:69c4:33a4:aca2]) by DM6PR11MB2731.namprd11.prod.outlook.com
 ([fe80::b4f9:69c4:33a4:aca2%6]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 11:08:26 +0000
From:   "Hogander, Jouni" <jouni.hogander@intel.com>
To:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "lyude@redhat.com" <lyude@redhat.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "De Marchi, Lucas" <lucas.demarchi@intel.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915/psr: Disable PSR2 selective fetch
 for all TGL steps
Thread-Topic: [Intel-gfx] [PATCH] drm/i915/psr: Disable PSR2 selective fetch
 for all TGL steps
Thread-Index: AQHYHGtCvBOYjfwJOUWrtRpPBGzng6yJf4uA
Date:   Tue, 8 Feb 2022 11:08:26 +0000
Message-ID: <89b5f3210a3f3e9c629967890090b21a94749f0a.camel@intel.com>
References: <20220207213923.3605-1-lyude@redhat.com>
In-Reply-To: <20220207213923.3605-1-lyude@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b16baba-cfcd-4555-9d06-08d9eaf35488
x-ms-traffictypediagnostic: SJ0PR11MB4911:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <SJ0PR11MB4911FB2F53181F6C673229038A2D9@SJ0PR11MB4911.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SK1HxcOb9voSckarz8+5iddq/Gt6an4Aff3nh5qWRNP9ujJOFAbIQPnAinL5nqommE0C3ac+EwJ01JwL3o3GoAFE6rbCPJbeVhIATfK5S/ZLPV1MMm7UM515aZfGJEgeZ8awjcfDCsZVvtx/Pfa8XLRisaw6DAFJeB8bFY0uj5HSJ3OfXaLd1B4aIsAHxk9LRqGToeY3fpxQzqhaLIkw+UV/AZhhkReBRh08XI5aNYshIvNEWoEBJFor3LkgTJDcpapyRKRX8ACHImmMlcpMCStmzonJq7cZo63eNhY/+DQ/g8KMBTwLiFFi5MXcdYJ/XXKHWiK2KnxUikGWgBAyd5AthyHrqjYYCx0dvlmJERLkqFB5JM2Qz1fRIGZUusRuCEnkNqzQ4GBG720u/xmhj95/il5Yxbys2yySq1+P+smGVYy42jhu6gdckQdU283XdmG4pZGj8ZdtkCXs0s9VuczeLIWJicalBYMA66Tpn3nE3etVzIS5g12xjT/GF1MrK03FMX/4RjC42X1F0Be9E8DC6Kq2jCDSy5YDD7vCQDSG+R9zLe+wGt7RTmi8zieEoayvH+HYgsmbiOZUb7mcwV6eq2PS96zt2ggoJxypAM6fHdDQWzxSI3q27XXm6GgsJX/pifSYNVhGsIxPtPBvjulgmXDcemyQ6t2Yvm+PtvHc7ImDqyMwcaJpVzpu3ZWQ+qeryPQnubqbG44rXDNQOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2731.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(316002)(36756003)(38100700002)(122000001)(38070700005)(966005)(110136005)(82960400001)(508600001)(6486002)(107886003)(2906002)(6512007)(8676002)(186003)(91956017)(26005)(66946007)(4326008)(66446008)(66476007)(66556008)(5660300002)(64756008)(2616005)(8936002)(83380400001)(6506007)(76116006)(71200400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UlE1c0RhNFEvQlBJT2dKSlN6YXc1aXBaT2NGSlZiNmd5bnVtQ1JTMFdzWCtw?=
 =?utf-8?B?REY0Nk5QT0dRSWpJekZxblEvdVZpQWYrSGlBRTVUR2NTTVFuenhUcGs0eXJz?=
 =?utf-8?B?dUd5Uk5YczBHemJtMjAzUWVOT0xFN0lESy9WaFdISnoveUlFUk9EVExCOThE?=
 =?utf-8?B?K3o2NitHSUhMRDVWLzVYK2c5SGRuVmJxU2VQWVllYlQrZEtLQ05qVUtBS2JD?=
 =?utf-8?B?eWlFUFNyUnlGSm41Q2F5UGNDRjEvcXhrVW5sWHBqVk9NYjIvY3NhRDZUR05C?=
 =?utf-8?B?dG4rUG4wUEhsZmxIMHlsKy9RTUtWWFdqaGFqam81VnM1bjl3YStmUHhXUEVs?=
 =?utf-8?B?dUtUN0FEQzMrQ2FqMTlQQjUyelp2aUhobWRzN3NXSjZYUlFEd2E4Q2RNajBz?=
 =?utf-8?B?UkZaSFZKaDZnVDNhblRydGkxNW1GODQ0OFp3KzB2bDVraWw2OVZCbGRGN1R6?=
 =?utf-8?B?Sk5HY0doRDh0aktqcHVJRGlORit3WWRrN3p5cGhrakNOSEZTeEtBUzNNMTNL?=
 =?utf-8?B?VG81UjEwcGw3RmFObWJKanVPS05VajZnc3JhbTMxbVNoNGdya0ZMMEIvNXp0?=
 =?utf-8?B?Y3VNMWF5cFF4OFY4bTVKTGhBMVNUYnRvdGpHZncreTdBbi9udXNsMklWWHJ5?=
 =?utf-8?B?dDZyeVU2SXk1R3htd2JGbnI3RENCTHoxb0cyZlAzUDV3NEV1dDIxaE5Da3gx?=
 =?utf-8?B?YjVGNStvVVlvaUp2VGM1QmhCWXNUZGc5TWltcGpwWC9ubkhPMGJPZ2t1ei9m?=
 =?utf-8?B?TnNUYUt6VHpFNVM0UnVPeHdONDZnaGFpSXVYREhieGdEanlTQmJnZlNLYWNF?=
 =?utf-8?B?cXZOemx2R2NIQmprNDV1UEVEWFhYeVk1enlOYnZrZlZBc1N2UUdGVlhRM0dO?=
 =?utf-8?B?MisrYzZUNVF5RFl0Vk1GaFI0NEQrb0RPc0RyQjE1TDJuUGRXZzJERGJjbGhr?=
 =?utf-8?B?RXNHeEJQKzJCdzF2VjBNT2cxWkNWMnhjRWd3WG14U2xjK3QxSjB1TXZBdENN?=
 =?utf-8?B?d1BnNk5FWjFBK0Q1R1doY0dtMDFGRVJKNndwT0lRbWFLYUN5UFpIdzVWU2JD?=
 =?utf-8?B?c2hwZmhRYTI1SlZaQ0FhdDUycnpWb3ZKWjhkZEtHMjQyREVwMWJ2SmhkbU5V?=
 =?utf-8?B?WFNpOUh4MHZrVm9ERXFEdFFWc25YemR5SWw0TGw0b0owTTNPbGhzOStmeFRC?=
 =?utf-8?B?bjdQUFE5MjRzaWE2MHFqZFZzR3lHTWxNREFKN29xTkcvdHV5azVXUFl5K2Fi?=
 =?utf-8?B?ZmFNRDVCbUo0VWpEV3dZcVp6aDZSa0ptYi9MbXBsVEp0ZzBkRUQ5b210SVY1?=
 =?utf-8?B?VlE1QWRVTWx3eXNHbFZWbk9uL2NlV08vMkg0MzZ3dVN1YTBWRlViZWxvY1JN?=
 =?utf-8?B?dGQ0STR4bTlnS2ViWTduV0laMGRDWGpROHVJZ0JhUzdaSGtlcTZQOFB5TG85?=
 =?utf-8?B?eXkrUE4xRjhvRERONXNjbTk1OERKLy9sS3lQQVlCRU10L2J6d2xJbi84NFJk?=
 =?utf-8?B?eDNKdEF2a29YcmhXM3E4N2Z0a3ZwMVVRamRvZkFsOVpjNWNmcFNsc1B0cHpK?=
 =?utf-8?B?TG13N09KQ2x2dmVvM0xPK0sxWWJsWHBUL00vdS9IWk5BUHJiNFZqaGxBTnZp?=
 =?utf-8?B?NVlGV0YwbU1PYWQ5YzBrWXljcFgxcUlLLzBvQ3RDbVF3RGx2UDUzNlRkU3o5?=
 =?utf-8?B?cnhKRHhmZG80VzlJbmtLajBZVHg4NldiaHR5QzBpdlV3d3BGVkRMaGVJUlNx?=
 =?utf-8?B?S1R3WnZhQjE5YjN6ZGVVQ0VQeUFRcWxIOGdZUjgrdjFvUXg0bHBtaTN1UW5Z?=
 =?utf-8?B?a2VMN1c1TXJtbEN3V05zemRVSWYyemNGSnp3K1J5SlZpdEZ6allBYzJMcEtE?=
 =?utf-8?B?elZNa0E2WnlUdmV1cnhvNTUxeTZRYlNVcEdtQ3hoMmNETW40VVg5MVJ6YXhS?=
 =?utf-8?B?aGhuWHhCMC9ZMmNDc0pyZmVYQ1h4Uy93UVZneFJBSWQ5ZjVDc3F0bTdUOENY?=
 =?utf-8?B?N21hMnZHN2tDWHVsc25HbGNzVzlPR3dsdjlYNXkxUVB5VHQ0SzJpNFBDQThM?=
 =?utf-8?B?NjIybGJXUnF0eXNFcTJvaEZpNld5KzdRalhZck0wc3hjaGRLbll0RFJ3ODl4?=
 =?utf-8?B?dlFTd1FrSkVZNzJQeTBpNUx1M3hocUNpNy9YZFg1dlp0aUk5ZUovbmwzeDBK?=
 =?utf-8?B?b0VuYWhZNzlKcDVKT3d1QnZLNlluSjVsRjIyZ3lBL1RycUJUYkJ2T2lXUng5?=
 =?utf-8?Q?n7irioVEsvG1yhMNLclObZcFF3NJvhV5xqVsyqyy3g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D27ABC53883508479A9849288C338441@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2731.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b16baba-cfcd-4555-9d06-08d9eaf35488
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 11:08:26.5358
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 18iP9pKdQnKBTUVnr8ZVwMnJDnCamKziFRrP2Q+zHgcCgQl0ae7RY6e/VIzQF+uc/lKulSGLdI4sesc/HM/gTtyeXwI2MyV5aZgc+Nmdrfw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4911
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8gUGF1bCwNCg0KT24gTW9uLCAyMDIyLTAyLTA3IGF0IDE2OjM4IC0wNTAwLCBMeXVkZSBQ
YXVsIHdyb3RlOg0KPiBBcyB3ZSd2ZSB1bmZvcnR1bmF0ZWx5IHN0YXJ0ZWQgdG8gY29tZSB0byBl
eHBlY3QgZnJvbSBQU1Igb24gSW50ZWwNCj4gcGxhdGZvcm1zLCBQU1IyIHNlbGVjdGl2ZSBmZXRj
aCBpcyBub3QgYXQgYWxsIHJlYWR5IHRvIGJlIGVuYWJsZWQgb24NCj4gVGlnZXJsYWtlIGFzIGl0
IHJlc3VsdHMgaW4gc2V2ZXJlIGZsaWNrZXJpbmcgaXNzdWVzIC0gYXQgbGVhc3Qgb24NCj4gdGhp
cw0KPiBUaGlua1BhZCBYMSBDYXJib24gOXRoIGdlbmVyYXRpb24uIFRoZSBlYXNpZXN0IHdheSBJ
J3ZlIGZvdW5kIG9mDQo+IHJlcHJvZHVjaW5nIHRoZXNlIGlzc3VlcyBpcyB0byBqdXN0IG1vdmUg
dGhlIGN1cnNvciBhcm91bmQgdGhlIGxlZnQNCj4gYm9yZGVyDQo+IG9mIHRoZSBzY3JlZW4gKHN1
c3BpY2lvdXPigKYpLg0KDQpTb3JyeSB0byBoZWFyIHlvdSBoYXZlIHRoaXMgYmFkIGV4cGVyaWVu
Y2Ugd2l0aCBpOTE1IFBTUjIgc2VsZWN0aXZlDQpmZXRjaCBzdXBwb3J0LiBUaGVyZSBpcyBhbHJl
YWR5IHNvbWUgZGlzY3Vzc2lvbiBhYm91dCB0aGVzZSBwcm9ibGVtcw0KYW5kIHBvc3NpYmxlIHJv
b3QgY2F1c2VzIGhlcmU6DQoNCmh0dHBzOi8vZ2l0bGFiLmZyZWVkZXNrdG9wLm9yZy9kcm0vaW50
ZWwvLS9pc3N1ZXMvNDk1MQ0KDQpJIGhhdmUgRGVsbCBYUFMgMTMgNzM5MCB3aGljaCBoYXMgcGFu
ZWwgc3VwcG9ydGluZyBQU1IyLiBMdWNraWx5IEknbQ0Kbm90IGZhY2luZyB0aGVzZSBwcm9ibGVt
cyB3aXRoIGl0Lg0KIA0KPiANCj4gU28sIGZpeCBwZW9wbGUncyBkaXNwbGF5cyBhZ2FpbiBhbmQg
dHVybiBQU1IyIHNlbGVjdGl2ZSBmZXRjaCBvZmYgZm9yDQo+IGFsbA0KPiBzdGVwcGluZ3Mgb2Yg
VGlnZXJsYWtlLiBUaGlzIGNhbiBiZSByZS1lbmFibGVkIGFnYWluIGlmIHNvbWVvbmUgZnJvbQ0K
PiBJbnRlbA0KPiBmaW5kcyB0aGUgdGltZSB0byBmaXggdGhpcyBmdW5jdGlvbmFsaXR5IG9uIE9F
TSBtYWNoaW5lcy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEx5dWRlIFBhdWwgPGx5dWRlQHJlZGhh
dC5jb20+DQo+IEZpeGVzOiA3ZjYwMDJlNTgwMjUgKCJkcm0vaTkxNS9kaXNwbGF5OiBFbmFibGUg
UFNSMiBzZWxlY3RpdmUgZmV0Y2gNCj4gYnkgZGVmYXVsdCIpDQo+IENjOiBHd2FuLWd5ZW9uZyBN
dW4gPGd3YW4tZ3llb25nLm11bkBpbnRlbC5jb20+DQo+IENjOiBWaWxsZSBTeXJqw6Rsw6QgPHZp
bGxlLnN5cmphbGFAbGludXguaW50ZWwuY29tPg0KPiBDYzogSm9zw6kgUm9iZXJ0byBkZSBTb3V6
YSA8am9zZS5zb3V6YUBpbnRlbC5jb20+DQo+IENjOiBKYW5pIE5pa3VsYSA8amFuaS5uaWt1bGFA
bGludXguaW50ZWwuY29tPg0KPiBDYzogUm9kcmlnbyBWaXZpIDxyb2RyaWdvLnZpdmlAaW50ZWwu
Y29tPg0KPiBDYzogaW50ZWwtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZw0KPiBDYzogPHN0YWJs
ZUB2Z2VyLmtlcm5lbC5vcmc+ICMgdjUuMTYrDQo+IC0tLQ0KPiAgZHJpdmVycy9ncHUvZHJtL2k5
MTUvZGlzcGxheS9pbnRlbF9wc3IuYyB8IDEwICsrKysrKystLS0NCj4gIDEgZmlsZSBjaGFuZ2Vk
LCA3IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF9wc3IuYw0KPiBiL2RyaXZlcnMvZ3B1L2Ry
bS9pOTE1L2Rpc3BsYXkvaW50ZWxfcHNyLmMNCj4gaW5kZXggYTFhNjYzZjM2MmU3Li4yNWMxNmFi
Y2Q5Y2QgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2Rpc3BsYXkvaW50ZWxf
cHNyLmMNCj4gKysrIGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvZGlzcGxheS9pbnRlbF9wc3IuYw0K
PiBAQCAtNzM3LDEwICs3MzcsMTQgQEAgc3RhdGljIGJvb2wNCj4gaW50ZWxfcHNyMl9zZWxfZmV0
Y2hfY29uZmlnX3ZhbGlkKHN0cnVjdCBpbnRlbF9kcCAqaW50ZWxfZHAsDQo+ICAJCXJldHVybiBm
YWxzZTsNCj4gIAl9DQo+ICANCj4gLQkvKiBXYV8xNDAxMDI1NDE4NSBXYV8xNDAxMDEwMzc5MiAq
Lw0KPiAtCWlmIChJU19UR0xfRElTUExBWV9TVEVQKGRldl9wcml2LCBTVEVQX0EwLCBTVEVQX0Mw
KSkgew0KPiArCS8qDQo+ICsJICogVGhlcmUncyB0d28gdGhpbmdzIHN0b3BwaW5nIHRoaXMgZnJv
bSBiZWluZyBlbmFibGVkIG9uIFRHTDoNCj4gKwkgKiBGb3Igc3RlcHMgQTAtQzA6IHdvcmthcm91
bmRzIFdhXzE0MDEwMjU0MTg1IFdhXzE0MDEwMTAzNzkyDQo+IGFyZSBtaXNzaW5nDQo+ICsJICog
Rm9yIGFsbCBzdGVwczogUFNSMiBzZWxlY3RpdmUgZmV0Y2ggY2F1c2VzIHNjcmVlbiBmbGlja2Vy
aW5nDQo+ICsJICovDQo+ICsJaWYgKElTX1RJR0VSTEFLRShkZXZfcHJpdikpIHsNCj4gIAkJZHJt
X2RiZ19rbXMoJmRldl9wcml2LT5kcm0sDQo+IC0JCQkgICAgIlBTUjIgc2VsIGZldGNoIG5vdCBl
bmFibGVkLCBtaXNzaW5nIHRoZQ0KPiBpbXBsZW1lbnRhdGlvbiBvZiBXQXNcbiIpOw0KPiArCQkJ
ICAgICJQU1IyIHNlbCBmZXRjaCBub3QgZW5hYmxlZCwgY3VycmVudGx5DQo+IGJyb2tlbiBvbiBU
R0xcbiIpOw0KPiAgCQlyZXR1cm4gZmFsc2U7DQo+ICAJfQ0KPiAgDQoNCkJSLA0KDQpKb3VuaSBI
w7ZnYW5kZXINCg==
