Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566CA64B5F3
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 14:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbiLMNTT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 08:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbiLMNTS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 08:19:18 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE8D18357
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 05:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670937556; x=1702473556;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kCmF0+bMu6ILQqIrjrez+pj7aumcggi5vYMYzrG7UIc=;
  b=eZG7zWhf1Bo0mVesAOLA/RGkq6F/JgNXs2FNJ7K1p7CYGirgj9RF19GW
   LUTzpVFsq3GIjc2iRHSzv/eWs39Cap3dhO1gq331pJFpECCg4P4efrS+b
   F2hlsyX+nH+tLm5e520HZ8WY/z7JEYosJVhikjPOV6yq8qx2tcEDYHXWw
   DTUi9USy+zpPxdn+g6VfK/W9sQlV0yF/M5mFvuG+678HsKaYS6ttlpcge
   3vtt462//ihSZ8OL5ndcckjHLiVQqhVOtsHwB+cnd/n3TB3EtfQ0cJt7Z
   hea5C31IllHM1COUgP/ej7aRcquyLkRP/2HB3A1Xi2aGTpjJb3Frkno7i
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="380331287"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="380331287"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2022 05:18:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10559"; a="977449061"
X-IronPort-AV: E=Sophos;i="5.96,241,1665471600"; 
   d="scan'208";a="977449061"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 13 Dec 2022 05:18:51 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 13 Dec 2022 05:18:51 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 13 Dec 2022 05:18:51 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 13 Dec 2022 05:18:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQ0liMC15ihesh3vlQT6oyEW/HooRl0Yb7yCEaay+jJePd/uyj91RRHB2HOS7FN7tbNZyBn8nqE/r+jI87P4ynVMBYdwXauzInKHM2h3W/k6FWQ975dtzsmhkIotzpUg23mxSlOby/qBCxbAprA+mppDHj1LlcVsa2DvlJKeldMQJfVU82kCPoV/lLpVaYNjOZnA8CLVK6tuiHgqVWmNeXCZwtvSL1aI52bKER1kFY+YoYE8A+JAYEhnFcqwF8KiKakTqv+GIRFVpmt7H3ivQyYZXqMWtg8A+/uzZjtZ3Iph/ZDZj+KXXL2oirlrDu2P0IG/cfRcHsXibKZxnssl6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kCmF0+bMu6ILQqIrjrez+pj7aumcggi5vYMYzrG7UIc=;
 b=C25L1vlALc5zn0r3cM4XZNuHF23MiIVY/+0tjeDG9tA5bX0K3i0B70ZWD9HHfu8yDzfCLt7XxLXylgmnZGgRMfthmGXKxJ4GqX5iQeR1x3iA2hilTHekVKcEjC1QM5yFUZbS0SEdXCXI9vzQL7g0Y1Kkdukl/OLH9XcLcnThVL5z+QYbbVtqDyn9GDMh6HbyFLQr3JErhuH5Pd7N1uIRMKMKOlGu3IXLX3gCq0Y/ohxyTTt130/EeIG6s8pXGuSyfYQnZFlMIUymqrWzbVGYigq6cx8PvY9uf2UNTuzKUd37EuqS0nRgzPcR+mpxRQXVrHT8qE92Sfo6/WUyQcwLJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9)
 by PH0PR11MB4982.namprd11.prod.outlook.com (2603:10b6:510:37::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Tue, 13 Dec
 2022 13:18:48 +0000
Received: from MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::499c:efe3:4397:808]) by MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::499c:efe3:4397:808%9]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 13:18:48 +0000
From:   "Vivi, Rodrigo" <rodrigo.vivi@intel.com>
To:     "andi.shyti@linux.intel.com" <andi.shyti@linux.intel.com>
CC:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "mika.kuoppala@linux.intel.com" <mika.kuoppala@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "andi@etezian.org" <andi@etezian.org>,
        "chris@chris-wilson.co.uk" <chris@chris-wilson.co.uk>
Subject: Re: [PATCH] drm/i915/gt: Reset twice
Thread-Topic: [PATCH] drm/i915/gt: Reset twice
Thread-Index: AQHZDkqCfILIy71Hu0S3uwUNmXC0OK5q4M8AgADtdoA=
Date:   Tue, 13 Dec 2022 13:18:48 +0000
Message-ID: <51402d0d8cfdc319d0786ec03c5ada4d82757cf0.camel@intel.com>
References: <20221212161338.1007659-1-andi.shyti@linux.intel.com>
         <Y5dc7vhfh6yixFRo@intel.com> <Y5e0gh2u8uTlwQL6@ashyti-mobl2.lan>
In-Reply-To: <Y5e0gh2u8uTlwQL6@ashyti-mobl2.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.2 (3.46.2-1.fc37) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB6059:EE_|PH0PR11MB4982:EE_
x-ms-office365-filtering-correlation-id: c92c6a63-1bc1-4d1b-d50d-08dadd0c91f3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WuQGZsIAEjelJbziuNkDMYdcEPr4hqRJA9L8T6GiLc35ZKrgTJdWlJ+Ix6oC9MBMzmLmGIIA2kL0flgaEDsM1uGscI9Xo9n489yURYKN0f90ZJzUIF7CjDffS9th6i/VhGbT/PUWRE9hi3w3cdd0L/czZ/bnreVFfBmJr/y5vtI1SKm02QSrJ1+QyZXJRTVfQq1wBG0MqlaLvRNdfigW4k3utwkYcKMxtdHjv/jOnHQ6Yh90wUxPIAHTpEAQYtcRhvUWBon9e+1pLeFWtxcJZh/veFkkDUYmEzdndnNqXA8Ld+QEeS1ulNL43W/1zf/RF0aK6h6wsT1/Rup1/1qCwPVdh32TNsX7DE0y87zA6n/zeDGsWwwPp7W2LtZ+K25U8my9qhs7yk2lI0r87cdY/jB1hM445NZzL52ReNIinz2t11jNQYZ0GhcUE60cehwiZa8/n+kS/qoVF40QYgWy0FhB53wA6V6lwTMgbPX0+3ghDIM9A2A3Rp8YUdL1cZmH/UC5QGEAvE9+fGCP5IZmAM0DLYOzvlgKacqXTC7qzGP8OSdKyU/8OCjFc40TbnGwk7rchlOIUOkQz54xRZeWlpk31eBiTtSTMv7XR40iPmD7Xujn7/nyAq/SkYwYxn562REDUwvTnyqmmAXGaBFcdw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6059.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199015)(86362001)(38070700005)(478600001)(71200400001)(36756003)(6486002)(966005)(6512007)(66946007)(91956017)(4326008)(66476007)(66556008)(8676002)(64756008)(8936002)(66446008)(316002)(41300700001)(76116006)(4001150100001)(54906003)(2906002)(5660300002)(6916009)(38100700002)(26005)(82960400001)(2616005)(122000001)(186003)(6506007)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bnNtZWJPRkhvYk12aURsOHBaeWV0aWtPOElCYzRDbTdzYWxxZDdJS0tEWkdl?=
 =?utf-8?B?VEZvdVkwWUZlSTJRaUtMOTNLalR6T1B3eHB4ZStaSUsydHpVc2J1ZFZZdEFk?=
 =?utf-8?B?QzJTQ1Q4RlZVcGpFZlRmVVBPL2xNZExDUEYxa1FWeXYrWmJ2TDZQRVdCZkdk?=
 =?utf-8?B?VkllVWd5ZlBLZDBIVThJTngyVU9OU0I2QjJrVDJGcldEMDgzOGRudmNNN1o5?=
 =?utf-8?B?RXp6Ykh5YlZRV0pKOER3bXhJbzJmc2Rva3dvWHBRd0dld2dhOTN0V1VhaVpH?=
 =?utf-8?B?S0N4VjNualEveVFxQU9CU2p4SFFBSzVob0dpc1l1eld1a3hjUEEwaENjWlhj?=
 =?utf-8?B?bVl4cDlNT3J6Z011bjFMNzNtVHdFQUpxbUUvdDJUb1Mxb3oyeVplWmRTUkRP?=
 =?utf-8?B?SjFQRFBaQkFwSWNYdTVVZkZ4TFU3NmEvMEliU1p4R3paclBZbEZtMUpFNWVz?=
 =?utf-8?B?MzdkSDZURzBXaWJWQ0E4VFVtbWMrZjJPdllvQVQ5TVhLQjk3YjBUK3FIeHNS?=
 =?utf-8?B?Qng2MElRMkxOc2FLMHFDVk50NmVsTnQ1K3RCU2FjT29mcjVieWlJZ0VYcXJE?=
 =?utf-8?B?UkN0NStETy9kVDRWc252bER4bkExUEJLTW9NRnVIaDRLOSsyZEZla1d4bW5G?=
 =?utf-8?B?d1RpSHJQd1k5dG1Nd1lXc1YrdnFTeUxzTGtvSytDRTFPUElLOThEdDU3aTlv?=
 =?utf-8?B?UTRIRUZ0OTN0Z1VRV2NvWEg4RFlYQUNZQWZ2dDA0M3F3QUlwUFBuM09pcWo0?=
 =?utf-8?B?WEZSWng2VVMzTkhjdlpiWjFEUjAxSzhMbFRXUmVIV1hXTjRZSVU4d01YdjJh?=
 =?utf-8?B?aERHRXBDaGZzMHIzMWVmcjQxYjR4VkV1TU9pcWRSTkd2UzV2b1Y4d3hnZ0cx?=
 =?utf-8?B?cEVDWW9qakxRK2h2dld3SmFPVkJRMjQwb2IvN3pONjZzU1MxMVdRV003Y2lP?=
 =?utf-8?B?V0hsL0ZXVUxLb0pKVXoyaStuTWR6WHlqS0tuRm02UmRSeXdwTnVKdGRLbFJt?=
 =?utf-8?B?cHVudHFrYXJzbEN2V0RranE1MFZ6OFBERnlBNll0b3BYWWpvTEVwd2ZtYStG?=
 =?utf-8?B?VWp3ekZqNUNiVVBQUWVrajQ1dmUwUTNaR0tvMmh4SjY4TEhtTklmZ2dWSktX?=
 =?utf-8?B?SVo5SGJnbXBKNjk5MU5UT1MyOUs3bmxCNEtvd0FkaC8zdFU1eldTYVpRSE8x?=
 =?utf-8?B?U2Ywbk40NlIyVkhvK2lWUnFWSlZOd2VvUVVWSll6Y0I4TlNaNDhEc0F5MWZK?=
 =?utf-8?B?aEl5MXR2MzJ1TW9ENHhYWG9GUCtvMU83Mit5QXZTL05zTHZZa1FGaWxybkwx?=
 =?utf-8?B?bjVwa1dJMmZHTHVJczkycXBzcFJ2LzZQT0N5UnA0cXlxL0pHdTl1a2lDZmdO?=
 =?utf-8?B?L1BNejFmbDJZVGlRM1EvWDh3RlRIbllmbGUrajRxMVg4cTZMNVRqUWM0UXBM?=
 =?utf-8?B?KzZWOWFEanQwaW5ZbGI4SFdTVzVXeTNtMHFHQ1VaWGhzaTMrRGlFdXNoSVdu?=
 =?utf-8?B?NzA5bXVZZ3ZZdjR4Ujh2Z3B1UVFqN0c4Vzh4WnQ3RmpTQ3FxczJZZllhNFMy?=
 =?utf-8?B?WmFkL1JhcWdNSC9BSzh6dEI0d1NXdHdualhSZU1rUlEwRXlIVlplVUJ3L0lz?=
 =?utf-8?B?REdlZ3IwWXd5UHgrU1g3ZFJibWVXVjNJWm14ZFBHckIzdE1qM09GK0REeTgw?=
 =?utf-8?B?VGFpcXhWRHcvSVFLZzBKZDRFcVg1ZGVVZHZKMjZobkx1L3pFWkdJajd1RzRp?=
 =?utf-8?B?SGowemxXSi9pWEwvUHZhSk1wd21jbjhYZkM0a2hKZzZuK21NajdsUkNEbkVm?=
 =?utf-8?B?N2NESFRIazdqd1ZtWmFBZEExbldicGN0NlBXZWVlUVBhYVRZVWY5NUcyYkNG?=
 =?utf-8?B?UEVkNnZuVVRhdk0yZEJXejArZHQ2TEh6MmVzUDRyMzQwQ2phUFgvaDRrbDQ2?=
 =?utf-8?B?TGc2b0xHNGovY0sxVWtEZlA4SUlxTVZKQ0hBZmpFaERDbENrbTdPTUg1L1By?=
 =?utf-8?B?Tnovd1doWHA3TUhlWTFnbUR0eC9DMngwNGNtdnZEb1NFZThVL0JwOU85d0p4?=
 =?utf-8?B?aWJSUDJrWU1SWGsvd2gzM2NtYlc1SG1xdG4yREFvbVhXdWRWa2lTK3djTHRX?=
 =?utf-8?B?NUxEUjN3anFPQW53OXhDQ2JCY2ZHa21BblVqVUxpR0dXSk5tUkk2WVZ1RUpC?=
 =?utf-8?B?RlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CAD9FBEB7D13E848A2D2F3AF00301987@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6059.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c92c6a63-1bc1-4d1b-d50d-08dadd0c91f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2022 13:18:48.4212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sI9BgAUZwul5X6g1IuOz/nt6I/58zZoEXelMke/hxPO0eeVwLj7imaEMhs/uPCljWWirfkoDt7utKCRqbfwe9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4982
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCAyMDIyLTEyLTEzIGF0IDAwOjA4ICswMTAwLCBBbmRpIFNoeXRpIHdyb3RlOgo+IEhp
IFJvZHJpZ28sCj4gCj4gT24gTW9uLCBEZWMgMTIsIDIwMjIgYXQgMTE6NTU6MTBBTSAtMDUwMCwg
Um9kcmlnbyBWaXZpIHdyb3RlOgo+ID4gT24gTW9uLCBEZWMgMTIsIDIwMjIgYXQgMDU6MTM6MzhQ
TSArMDEwMCwgQW5kaSBTaHl0aSB3cm90ZToKPiA+ID4gRnJvbTogQ2hyaXMgV2lsc29uIDxjaHJp
c0BjaHJpcy13aWxzb24uY28udWs+Cj4gPiA+IAo+ID4gPiBBZnRlciBhcHBseWluZyBhbiBlbmdp
bmUgcmVzZXQsIG9uIHNvbWUgcGxhdGZvcm1zIGxpa2UKPiA+ID4gSmFzcGVybGFrZSwgd2UKPiA+
ID4gb2NjYXNpb25hbGx5IGRldGVjdCB0aGF0IHRoZSBlbmdpbmUgc3RhdGUgaXMgbm90IGNsZWFy
ZWQgdW50aWwKPiA+ID4gc2hvcnRseQo+ID4gPiBhZnRlciB0aGUgcmVzdW1lLiBBcyB3ZSB0cnkg
dG8gcmVzdW1lIHRoZSBlbmdpbmUgd2l0aCB2b2xhdGlsZQo+ID4gPiBpbnRlcm5hbAo+ID4gPiBz
dGF0ZSwgdGhlIGZpcnN0IHJlcXVlc3QgZmFpbHMgd2l0aCBhIHNwdXJpb3VzIENTIGV2ZW50IChp
dCBsb29rcwo+ID4gPiBsaWtlCj4gPiA+IGl0IHJlcG9ydHMgYSBsaXRlLXJlc3RvcmUgdG8gdGhl
IGh1bmcgY29udGV4dCwgaW5zdGVhZCBvZiB0aGUKPiA+ID4gZXhwZWN0ZWQKPiA+ID4gaWRsZS0+
YWN0aXZlIGNvbnRleHQgc3dpdGNoKS4KPiA+ID4gCj4gPiA+IFNpZ25lZC1vZmYtYnk6IENocmlz
IFdpbHNvbiA8aHJpc0BjaHJpcy13aWxzb24uY28udWs+Cj4gPiAKPiA+IFRoZXJlJ3MgYSB0eXBv
IGluIHRoZSBzaWduYXR1cmUgZW1haWwgSSdtIGFmcmFpZC4uLgo+IAo+IG9oIHllcywgSSBmb3Jn
b3QgdGhlICdDJyA6KQoKeW91IGZvcmdvdD8Kd2hvIHNpZ25lZCBpdCBvZmY/Cgo+IAo+ID4gT3Ro
ZXIgdGhhbiB0aGF0LCBoYXZlIHdlIGNoZWNrZWQgdGhlIHBvc3NpYmlsaXR5IG9mIHVzaW5nIHRo
ZQo+ID4gZHJpdmVyLWluaXRpYXRlZC1mbHIgYml0Cj4gPiBpbnN0ZWFkIG9mIHRoaXMgc2Vjb25k
IGxvb3A/IFRoYXQgc2hvdWxkIGJlIHRoZSByaWdodCB3YXkgdG8KPiA+IGd1YXJhbnRlZSBldmVy
eXRoaW5nIGlzCj4gPiBjbGVhcmVkIG9uIGdlbjExKy4uLgo+IAo+IG1heWJlIEkgYW0gbWlzaW50
ZXJwcmV0aW5nIGl0LCBidXQgaXMgRkxSIHRoZSBzYW1lIGFzIHJlc2V0dGluZwo+IGhhcmR3YXJl
IGRvbWFpbnMgaW5kaXZpZHVhbGx5PwoKTm8sIGl0IGlzIGJpZ2dlciB0aGFuIHRoYXQuLi4gYWxt
b3N0IHRoZSBQQ0kgRkxSIHdpdGggc29tZSBleGNlcHRpb25zOgoKaHR0cHM6Ly9saXN0cy5mcmVl
ZGVza3RvcC5vcmcvYXJjaGl2ZXMvaW50ZWwtZ2Z4LzIwMjItRGVjZW1iZXIvMzEzOTU2Lmh0bWwK
Cj4gSG93IGFtIEkgc3VwcG9zZWQgdG8gdXNlIGRyaXZlcl9pbml0aWF0ZWRfZmxyKCkgaW4gdGhp
cyBjb250ZXh0PwoKU29tZSBkcml2ZXJzIGFyZSBub3QgZXZlbiB1c2luZyB0aGlzIGd0IHJlc2V0
IGFueW1vcmUgYW5kIGdvaW5nCmRpcmVjdGx5IHdpdGggdGhlIGRyaXZlci1pbml0aWF0ZWQgRkxS
IGluIGNhc2UgdGhhdCBndWMgcmVzZXQgZmFpbGVkLgoKSSBiZWxpZXZlIHdlIGNhbiBzdGlsbCBr
ZWVwIHRoZSBndCByZXNldCBpbiBvdXIgY2FzZSBhcyB3ZSBjdXJyZW50bHkKaGF2ZSwgYnV0IGlu
c3RlYWQgb2Yga2VlcCByZXRyeWluZyBpdCB1bnRpbCBpdCBzdWNjZWVkcyB3ZSBwcm9iYWJseQpz
aG91bGQgZ28gdG8gdGhlIG5leHQgbGV2ZWwgYW5kIGRvIHRoZSBkcml2ZXIgaW5pdGlhdGVkIEZM
UiB3aGVuIHRoZSBHVApyZXNldCBmYWlsZWQuCgo+IAo+IFRoYW5rcywKPiBBbmRpCj4gCj4gPiA+
IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCj4gPiA+IENjOiBNaWthIEt1b3BwYWxhIDxtaWth
Lmt1b3BwYWxhQGxpbnV4LmludGVsLmNvbT4KPiA+ID4gU2lnbmVkLW9mZi1ieTogQW5kaSBTaHl0
aSA8YW5kaS5zaHl0aUBsaW51eC5pbnRlbC5jb20+Cj4gPiA+IC0tLQo+ID4gPiDCoGRyaXZlcnMv
Z3B1L2RybS9pOTE1L2d0L2ludGVsX3Jlc2V0LmMgfCAzNAo+ID4gPiArKysrKysrKysrKysrKysr
KysrKysrLS0tLS0KPiA+ID4gwqAxIGZpbGUgY2hhbmdlZCwgMjggaW5zZXJ0aW9ucygrKSwgNiBk
ZWxldGlvbnMoLSkKPiA+ID4gCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vaTkx
NS9ndC9pbnRlbF9yZXNldC5jCj4gPiA+IGIvZHJpdmVycy9ncHUvZHJtL2k5MTUvZ3QvaW50ZWxf
cmVzZXQuYwo+ID4gPiBpbmRleCBmZmRlODljNTgzNWE0Li44OGRmYzBjNTMxNmZmIDEwMDY0NAo+
ID4gPiAtLS0gYS9kcml2ZXJzL2dwdS9kcm0vaTkxNS9ndC9pbnRlbF9yZXNldC5jCj4gPiA+ICsr
KyBiL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2d0L2ludGVsX3Jlc2V0LmMKPiA+ID4gQEAgLTI2OCw2
ICsyNjgsNyBAQCBzdGF0aWMgaW50IGlsa19kb19yZXNldChzdHJ1Y3QgaW50ZWxfZ3QgKmd0LAo+
ID4gPiBpbnRlbF9lbmdpbmVfbWFza190IGVuZ2luZV9tYXNrLAo+ID4gPiDCoHN0YXRpYyBpbnQg
Z2VuNl9od19kb21haW5fcmVzZXQoc3RydWN0IGludGVsX2d0ICpndCwgdTMyCj4gPiA+IGh3X2Rv
bWFpbl9tYXNrKQo+ID4gPiDCoHsKPiA+ID4gwqDCoMKgwqDCoMKgwqDCoHN0cnVjdCBpbnRlbF91
bmNvcmUgKnVuY29yZSA9IGd0LT51bmNvcmU7Cj4gPiA+ICvCoMKgwqDCoMKgwqDCoGludCBsb29w
cyA9IDI7Cj4gPiA+IMKgwqDCoMKgwqDCoMKgwqBpbnQgZXJyOwo+ID4gPiDCoAo+ID4gPiDCoMKg
wqDCoMKgwqDCoMKgLyoKPiA+ID4gQEAgLTI3NSwxOCArMjc2LDM5IEBAIHN0YXRpYyBpbnQgZ2Vu
Nl9od19kb21haW5fcmVzZXQoc3RydWN0Cj4gPiA+IGludGVsX2d0ICpndCwgdTMyIGh3X2RvbWFp
bl9tYXNrKQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgICogZm9yIGZpZm8gc3BhY2UgZm9yIHRoZSB3
cml0ZSBvciBmb3JjZXdha2UgdGhlIGNoaXAgZm9yCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqAgKiB0
aGUgcmVhZAo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgICovCj4gPiA+IC3CoMKgwqDCoMKgwqDCoGlu
dGVsX3VuY29yZV93cml0ZV9mdyh1bmNvcmUsIEdFTjZfR0RSU1QsCj4gPiA+IGh3X2RvbWFpbl9t
YXNrKTsKPiA+ID4gK8KgwqDCoMKgwqDCoMKgZG8gewo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgaW50ZWxfdW5jb3JlX3dyaXRlX2Z3KHVuY29yZSwgR0VONl9HRFJTVCwKPiA+
ID4gaHdfZG9tYWluX21hc2spOwo+ID4gPiDCoAo+ID4gPiAtwqDCoMKgwqDCoMKgwqAvKiBXYWl0
IGZvciB0aGUgZGV2aWNlIHRvIGFjayB0aGUgcmVzZXQgcmVxdWVzdHMgKi8KPiA+ID4gLcKgwqDC
oMKgwqDCoMKgZXJyID0gX19pbnRlbF93YWl0X2Zvcl9yZWdpc3Rlcl9mdyh1bmNvcmUsCj4gPiA+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIEdFTjZfR0RSU1QsCj4gPiA+IGh3X2RvbWFpbl9t
YXNrLCAwLAo+ID4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA1MDAsIDAsCj4gPiA+IC3C
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIE5VTEwpOwo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgLyoKPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIFdh
aXQgZm9yIHRoZSBkZXZpY2UgdG8gYWNrIHRoZSByZXNldCByZXF1ZXN0cy4KPiA+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqCj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgKiBPbiBzb21lIHBsYXRmb3JtcywgZS5nLiBKYXNwZXJsYWtlLCB3ZSBzZWUgc2Vl
Cj4gPiA+IHRoYXQgdGhlCj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgKiBl
bmdpbmUgcmVnaXN0ZXIgc3RhdGUgaXMgbm90IGNsZWFyZWQgdW50aWwKPiA+ID4gc2hvcnRseSBh
ZnRlcgo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogR0RSU1QgcmVwb3J0
cyBjb21wbGV0aW9uLCBjYXVzaW5nIGEgZmFpbHVyZSBhcwo+ID4gPiB3ZSB0cnkKPiA+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIHRvIGltbWVkaWF0ZWx5IHJlc3VtZSB3aGls
ZSB0aGUgaW50ZXJuYWwgc3RhdGUKPiA+ID4gaXMgc3RpbGwKPiA+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAqIGluIGZsdXguIElmIHdlIGltbWVkaWF0ZWx5IHJlcGVhdCB0aGUg
cmVzZXQsCj4gPiA+IHRoZSBzZWNvbmQKPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCAqIHJlc2V0IGFwcGVhcnMgdG8gc2VyaWFsaXNlIHdpdGggdGhlIGZpcnN0LCBhbmQKPiA+
ID4gc2luY2UKPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqIGl0IGlzIGEg
bm8tb3AsIHRoZSByZWdpc3RlcnMgc2hvdWxkIHJldGFpbgo+ID4gPiB0aGVpciByZXNldAo+ID4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICogdmFsdWUuIEhvd2V2ZXIsIHRoZXJl
IGlzIHN0aWxsIGEgY29uY2VybiB0aGF0Cj4gPiA+IHVwb24KPiA+ID4gK8KgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoCAqIGxlYXZpbmcgdGhlIHNlY29uZCByZXNldCwgdGhlIGludGVybmFs
IGVuZ2luZQo+ID4gPiBzdGF0ZQo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
ICogaXMgc3RpbGwgaW4gZmx1eCBhbmQgbm90IHJlYWR5IGZvciByZXN1bWluZy4KPiA+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAqLwo+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgZXJyID0gX19pbnRlbF93YWl0X2Zvcl9yZWdpc3Rlcl9mdyh1bmNvcmUsCj4g
PiA+IEdFTjZfR0RSU1QsCj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoAo+ID4gPiBod19kb21haW5fbWFzaywgMCwKPiA+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIDIwMDAsIDAsCj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBOVUxMKTsKPiA+ID4gK8KgwqDCoMKgwqDCoMKgfSB3
aGlsZSAoZXJyID09IDAgJiYgLS1sb29wcyk7Cj4gPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAoZXJy
KQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoEdUX1RSQUNFKGd0LAo+ID4g
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgIldhaXQg
Zm9yIDB4JTA4eCBlbmdpbmVzIHJlc2V0Cj4gPiA+IGZhaWxlZFxuIiwKPiA+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGh3X2RvbWFpbl9tYXNrKTsK
PiA+ID4gwqAKPiA+ID4gK8KgwqDCoMKgwqDCoMKgLyoKPiA+ID4gK8KgwqDCoMKgwqDCoMKgICog
QXMgd2UgaGF2ZSBvYnNlcnZlZCB0aGF0IHRoZSBlbmdpbmUgc3RhdGUgaXMgc3RpbGwKPiA+ID4g
dm9sYXRpbGUKPiA+ID4gK8KgwqDCoMKgwqDCoMKgICogYWZ0ZXIgR0RSU1QgaXMgYWNrZWQsIGlt
cG9zZSBhIHNtYWxsIGRlbGF5IHRvIGxldAo+ID4gPiBldmVyeXRoaW5nIHNldHRsZS4KPiA+ID4g
K8KgwqDCoMKgwqDCoMKgICovCj4gPiA+ICvCoMKgwqDCoMKgwqDCoHVkZWxheSg1MCk7Cj4gPiA+
ICsKPiA+ID4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiBlcnI7Cj4gPiA+IMKgfQo+ID4gPiDCoAo+
ID4gPiAtLSAKPiA+ID4gMi4zOC4xCj4gPiA+IAoK
