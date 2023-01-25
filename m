Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D935C67A8DC
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 03:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbjAYCiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 21:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjAYCiY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 21:38:24 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFE548A10;
        Tue, 24 Jan 2023 18:38:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674614301; x=1706150301;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Aqq4erEvrr5HgP3AIHKXE9pDUeT1mizQGR3cs14OgAY=;
  b=JE4ChdrPU3WVfsI36qhb8tEFql2djghKruWB51npB3UL8jJ8ZasA8MDU
   aiEO+cD/FnJrT7KEIfJUtroyaFBsmrclIoci/n1Mcsvdy6tCu8igr8xdE
   Z5PsOa8PdVBCcSRpWqCV85kayRZts+N4qoUDDcu0gwkGbXh2d7igkmiK1
   dW+M97mbctrN0EX7WcvNZg9IXRyMqig8YlE6dd3KwGn4wLRM7U7f4w3cf
   gbJOQA0kfwydgIe2c4raQHy/nil6RDvsO+XydilqIl72bMRj59vy5TyN3
   NOeLnvEvHfiAVw4Z4l/CdjD4P2Pe808wk9+AqnVdUVP35gViLQbpCcvuY
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="306130374"
X-IronPort-AV: E=Sophos;i="5.97,244,1669104000"; 
   d="scan'208";a="306130374"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2023 18:38:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10600"; a="804847672"
X-IronPort-AV: E=Sophos;i="5.97,244,1669104000"; 
   d="scan'208";a="804847672"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga001.fm.intel.com with ESMTP; 24 Jan 2023 18:38:21 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 24 Jan 2023 18:38:20 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 24 Jan 2023 18:38:20 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 24 Jan 2023 18:38:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7VdbJl5mDvm3NVwq2MEl5ChQe9mAySYlKzAUykRrZIx5i4+nQ0DIOyeFCNtVn+sYep/eGKFfL5XyTlLYrnxvvbenX4Vok3XtP3FhoDy4F+CsU4aytEo4sOlh4ulZ799zzf6zONsGFTGi7HU6I97cYRJVHn3g5B42ongg40FgU3kIsvj26ATy20XF2iTc4LHCBO0dtmDJTE3IAKGNNhV8XqS/0R/Vsv9ZoVxT7K7ogAllz6b3tI+1plZtFIUiDgff2t7iwFYvIH/zbFMsp6wGn0Mqd3IBGKciu6+tFzxEzt+xU264d6skUbEQF7ybkF6C8vqVNagDSEOM1qgGyeEsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aqq4erEvrr5HgP3AIHKXE9pDUeT1mizQGR3cs14OgAY=;
 b=FiiuClEWq8goh+/8mWHKamm6QczIecX5Z/5ZORLhGkTNnFVWNAfIW4nChG+FUNHFUFAzH3Uungi21KA80Qo5MeyRaF9b050URgxCKOKY5ZgqobVY866+ll+htY3YPLZMZJiLH1eFGm+dkHSnwNohV0G4JMD+4eDn6bJO4WIqQc/0ppDrPgDEmSOJTfLYEiXBVAKEpVFxnSJN66gDZPa+PUbD7nVM0wbJZFhvAeXJfDM0GAtSII//ubHwVPcPm9c3dou9nCLNiEUWvGkDEz9hDyPV+PVW/p17LNOKTybIELSb1gxmSBHN23Q69m2F/Uk7U/DZSsnth98lD6q1IUkTdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 SA2PR11MB4780.namprd11.prod.outlook.com (2603:10b6:806:11d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 02:38:13 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::cf29:418d:2ed1:c1b9]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::cf29:418d:2ed1:c1b9%5]) with mapi id 15.20.6002.027; Wed, 25 Jan 2023
 02:38:13 +0000
From:   "Wang, Wei W" <wei.w.wang@intel.com>
To:     "Christopherson,, Sean" <seanjc@google.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        =?utf-8?B?5p+z6I+B5bOw?= <liujingfeng@qianxin.com>
Subject: RE: [PATCH v1] KVM: destruct kvm_io_device while unregistering it
 from kvm_io_bus
Thread-Topic: [PATCH v1] KVM: destruct kvm_io_device while unregistering it
 from kvm_io_bus
Thread-Index: AQHZG4G35lVMEMdAHEKf7mCxBCtF/K6szOiAgAG2ZzA=
Date:   Wed, 25 Jan 2023 02:38:12 +0000
Message-ID: <DS0PR11MB6373545E338020F96CF9F57BDCCE9@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20221229123302.4083-1-wei.w.wang@intel.com>
 <Y88XYR0L2DyiKnIM@google.com>
In-Reply-To: <Y88XYR0L2DyiKnIM@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|SA2PR11MB4780:EE_
x-ms-office365-filtering-correlation-id: d5b8ee29-0e41-48b3-016f-08dafe7d3463
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yzZSlfROotRmJY1Sa2irM7VlCwxwz5iL5l+BbFenHfrEk4lwinNjJWcrjs34txcGnREK/ByvccYa+wiCKoQHyVfrPeK735T4gxHczNOfvkf45K2tpZScA18RpOHLFW+s0yZpURB3+0H1SWmSM+533iY2z7mUxUBEJS2TlGRlXxQFJUZFmj3fP78kRiZB/MRpUL962/VQSaspWouE7k/BLBuDhNmYc9EMCiSGNPQRs7GMqQweOOSXDOj43pIzTS0qdKBbUtBdVSVgr/TbCThw9jjyM3A9+M0JB2PL/CdXEzHnlu7os4jaKrIzOzGuVElY1yXRcykuxhnYkq2I7U04hLMVgJI24pbhexPnMYqeOpFBXAW2KJpTnbhGaLXSXbXzBY+5ptkG651YgD4CDl/lFNYlpNBodT8IJDaxFS9Frd3xng2gFHggjA94VekP//ctQ6giMNsNIZej5tVEANdPdX1D19p91k2nVOYcLOoxK+FJPl5ve1GVANDnxkPQ6bFtoXiAStXGBNV8XhIvEstAjt4NUH62nrQjMdsqPGHu9hjNC8x9vRkfWf7buA7mUQKQHAs+16QobmWkGQFFsDtUJUqKSm9usr/RWolWFm4BqGlrJ/0PCDdUq2WEVEtbpQKgMQXC30Tq6LVl8GfY7slLifcMJll7Z4OC87QaLcV4YizH99B6u92FeT81+yMY/DuAmzMojJ+iPndQFYQR8+TnKA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199018)(86362001)(2906002)(38070700005)(4744005)(82960400001)(4326008)(33656002)(8936002)(122000001)(5660300002)(66476007)(52536014)(316002)(478600001)(38100700002)(7696005)(71200400001)(9686003)(8676002)(26005)(6916009)(55016003)(6506007)(186003)(76116006)(66446008)(66946007)(53546011)(64756008)(54906003)(66556008)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TGovMXhwZnVBcTR1VjFKcTkzREVBR2cxYXp1TEpjMUNreVk0VVhHL3g4SEtJ?=
 =?utf-8?B?alh5YTFuWHl6MjJnZVZOaElta3QwcmxoOGp4c0FFUGxtVkIrSmlmT1VTdlBm?=
 =?utf-8?B?S3ppcWppN3Bla29SR1kzaW5sb2IwV0l6Ylk0SW9uRm5VREh0V2I3UklERURl?=
 =?utf-8?B?VElycFAzcksvZy9hRFczOVFXSHI2SWtQL1M2MmwzaXBrZXpYYndCTUVCOFlx?=
 =?utf-8?B?T3NpZGhKTm5wcExiSmw3N014Mk1zREdMV3VjSTVkV3JJSnNpKzVxdCtSYUNS?=
 =?utf-8?B?cWx0SmFuTVVIbGJLZkFxVDdFWkZIcU1SaEJSM25jaFU2NUd5OUduTkFWUUNi?=
 =?utf-8?B?bFFPMjBnOU1VaENpZXlWRlQxSk1vWWlJbXJOVHltdG8wSlJYV29SckhMbTZN?=
 =?utf-8?B?bkNHb2UyUzlkQWJjcGVrbXdGZjdCMUxIbjBqWXJDQm1HQThTSWVRM09PUEk5?=
 =?utf-8?B?aUMxR3ljdDB0d2RXSUdnczQzUDhvTGNTQzlYSmo4azArRnpKZG10VGVlenNV?=
 =?utf-8?B?d1hDYjdLZVQ3V214ZlZYU2dlYXVTL0E5d1dadVFGdzdtQTV4UE56SGx4SWE2?=
 =?utf-8?B?RWwraURmSUtNV21EY3RrMmxSM3RDZTB4QkdYZEhLYSs2Nk13OXJINkxqZzdU?=
 =?utf-8?B?YnlqK013MjdWbS8wYS9zcXhMTWZIcDZVaUpvbnhXTDVlNm9ob2RuMVNnKzVN?=
 =?utf-8?B?VHNpQXU0U3VjaUN4MENTYmtLQjhZR3BzbDFMQVdkVmFhSDJVYnB1OWRsN21L?=
 =?utf-8?B?aTJQc2hqc2o1UjZLa0xxUFBHeGVrWWZodDk2ZFdMR0syR0laNzkwdXpqanhD?=
 =?utf-8?B?a1hnWlhGNmJmckcySDZoVllNaHZ1c2dmbFU0Yk1XZVlVM1FubFY5L0J0N2RG?=
 =?utf-8?B?NW1ibHVRckQvL3Q0TnR0NHhHcFhyUFFDRFJrOGRDKzQ2eUY4NFVyNGNPdTkx?=
 =?utf-8?B?b0w5OUdMOHNSeXRyOW9qYTUyakVVRW40ZGJHS0I5NHNLbFNRL1c2NzNLRzA3?=
 =?utf-8?B?RllDSVRZZmZxblBQazZ2M1V1R29ublVBVTdkRmxpdnd0R1VWM25qVVZPcW9O?=
 =?utf-8?B?OTQ1a0tYR1dpdlRoMnJzYWZpemNkaXZlUSsvSzNaTTY0WFFueUdSQjgrVHl4?=
 =?utf-8?B?a2o3cEt6eVlEb202RlZkYk9CRFZ5THRVdXl2UHVLdG1pVUFGTHh1ajBpS2t6?=
 =?utf-8?B?bHF3VElxT1dKeDltTWtIczRrQW1yRExGak4vUHRrYTVoQVdTdk9kNW5vSVdP?=
 =?utf-8?B?SDFKUDRpV0xCaG56OHhyTVVrZkYyOW00Wk9PV1FGVGdmdWwwSkdJMzlERlpU?=
 =?utf-8?B?dm52VG5rYjBGMFlRUHNES0t3d1JMVFkycGg3TVduZEF1ejRlWnZjRUhtZ1Zz?=
 =?utf-8?B?T203cExyYUdoaytUYlFIeG1VcXF1eUFnOVVvY2ZXMDhrc2Nmc1h3eEZldUNH?=
 =?utf-8?B?bVY1T2RWQk4ySVh2eG1RRkNQSnc0U0RiKzZxWGRoWkFOVWdJRHpFR0JGc0Nw?=
 =?utf-8?B?RTVZc1BxWWxiRlQyNHZvcVlJcGl4YTBHNFQ2NzBBV0ZwUVlIb3loUlZGcVhO?=
 =?utf-8?B?WklzT1crM0lYUEV3U3RIMDV1NTdsMDhualRNNFNYWHVnWjNqNkZSazRyc3Zv?=
 =?utf-8?B?UDZ3VkNwdlVKdWhDdlRaZ2M3VmwvSlFDVG01MzZKbHdZTXZaVk1IN1luYnBy?=
 =?utf-8?B?T2h2K3NRclEyeVpuRE5YUWp5WjRSeU1jRkdQQ3lNMmQzS3hxWFZvSGZpa0V1?=
 =?utf-8?B?S3daeURuQVhoNXVKc1ExQy83UU1ock1ORTRXUXd4Y2o3Skp0WG5HVk1TcmFQ?=
 =?utf-8?B?Y04vL2U5RXYzWjRuZkMwQThyYTRnMk1SL2tZclQwOERQM3AxREpXUnNkZEty?=
 =?utf-8?B?dWR2cEIzYXl3ZlY1Y0UrWUxOcjZoZlpGZlA4ZmNHeUhydW9uSXZVNThoWWRm?=
 =?utf-8?B?S094V0Y4b2l0My9POENzdlUvbHdqaW1HQTE4ZStLNXNrbjA4Z0cvd1lWTTZP?=
 =?utf-8?B?d0o0QkxucmpuYi9ZK01Wazc2MUNsR21LVzU0MTlmYnJ3cXpITUtVa3RsL2FM?=
 =?utf-8?B?NTdWbCtld3FkYytEUUJHY3V6Q2VoTTJMQjN6QkErYk9HTithTWp1dThzNUFG?=
 =?utf-8?Q?WQfeCgvwdKT+wJ2TniPpgufPd?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5b8ee29-0e41-48b3-016f-08dafe7d3463
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jan 2023 02:38:12.8992
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tLvwszoQrr7ebNZxrYzB+M09Xvjw+JY/znCh7xLf4DHHvqHpalNfk57ce5RAyidDgIUeo8ODr4e3esfYkzFk7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4780
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlc2RheSwgSmFudWFyeSAyNCwgMjAyMyA3OjI1IEFNLCBTZWFuIENocmlzdG9waGVyc29u
IHdyb3RlOg0KPiA+IC0Ja2ZyZWUoYnVzKTsNCj4gPiAtCXJldHVybiBuZXdfYnVzID8gMCA6IC1F
Tk9NRU07DQo+ID4gKwlrdm1faW9kZXZpY2VfZGVzdHJ1Y3RvcihkZXYpOw0KPiA+ICsJcmV0dXJu
IDA7DQo+IA0KPiBVbmxlc3MgSSdtIG1pc3JlYWRpbmcgdGhpbmdzLCB0aGlzIHBhdGggbGVha3Mg
ImJ1cyIuDQoNClJpZ2h0LCBzaG91bGQga2VlcCB0aGUga2ZyZWUgYWJvdmUuDQoNCj4gR2l2ZW4g
dGhhdCB0aGF0IGludGVudCBpcyB0byBzZW5kIHRoZSBmaXggZm9yIHN0YWJsZSwgdGhhdCB0aGlz
IGlzIGFzIG11Y2ggYQ0KPiBjbGVhbnVwIGFzIGl0IGlzIGEgYnVnIGZpeCwgYW5kIHRoYXQgaXQn
cyBub3Qgc3VwZXIgdHJpdmlhbCwgSSdtIGluY2xpbmVkIHRvIHF1ZXVlDQo+IG15IHBhdGNoIGFu
ZCB0aGVuIGxhbmQgdGhpcyBvbiB0b3AgYXMgY2xlYW51cC4NCg0KU291bmRzIGdvb2QgdG8gbWUu
DQo=
