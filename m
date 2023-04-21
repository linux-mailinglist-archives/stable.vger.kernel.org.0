Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236836EA1BB
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 04:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbjDUCj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 22:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbjDUCjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 22:39:23 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4364C6EB2;
        Thu, 20 Apr 2023 19:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682044762; x=1713580762;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=As/hQyF6XZ2nYWj4c1S45CLoGSk1PuSVlDWudqv5fik=;
  b=nYy7JEjIK/ZjTes70laKwSRvXsvIKK5IKdQXQ3exX5MubHl7wnZqtZWB
   oFE4l3PFxDOcu+19Cwk7FYOJtbK/CxVUpoeAMdX47jiM8xpDh/1FyvJki
   IxFoHHcXnUMwC+Gf5HxkS+M3BbH7eFaaelzOeSWD6XUEie5WIxbP2Chwb
   70m8/g65WI80NcvZkAa0Fqj6CogWuOQMZ6ZEnk0lJQTDhDqkGV7qlYHXU
   nm58ehyMqR89Pt9+weMGyJYmA54CS6hANZoVSyqom0NaZ3I7mf+LhsEl8
   2izk5r6Wmrrh5Hsl7z7T/goEnQrlA2HdSueJxXEl1mWN5laeUrTOqA4IH
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="373821397"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="373821397"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 19:39:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10686"; a="642367017"
X-IronPort-AV: E=Sophos;i="5.99,214,1677571200"; 
   d="scan'208";a="642367017"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 20 Apr 2023 19:39:21 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 19:39:21 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 19:39:21 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 19:39:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IIJS1VUZ8Sa8nY2jymr4gHURiMQpyG1opieUNip7qJQ59poFnkMXdHjQmp8tC0s6NSHi6VTkKl1n1MfDwpkpQ6pUNVME4Gc4PxRd0orx6fNRe8+E2Ot6ezGfUEvHubFKSrUqqux37ncUkISOFRSIwxdBgrT6XxOvOECNjCsLvu34JZiJmlzOdR7PvVh1f9iQGq2fBYvGhXpkPD5lfqv4dGlSMnkv1pZvjgsXIvRkuzqPUxXzMDSC3K60HWBAVOPkwxjKmkaBXeyw9XCHEans5WsXL4fdc2pEK3eJSB1PmMpU42XkDaulyHNRT773UZoOku0oNrzRXxfb0payeiMFRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=As/hQyF6XZ2nYWj4c1S45CLoGSk1PuSVlDWudqv5fik=;
 b=R3ADOsB9smFU0c4LuAtmOKhMexKtWhH+4bpqhYZyz+5wUMDRgUaTqXIkd6+EFJapNEhAJ4aeiommXbNnEAgLry83v+R57ViyJhsz7f3E87MsBk7i121IqeB5N2P3F2Ux7Y1BEfUSyKwX8or8rEvhc3Tesz9rXqf9/+o65kgGiFWq6EfYdVjlztRyPAk+ahPGeKC7ziffJnUKjdubTvGTIWf+GaKIC5Lr+1LxGUZJuGZz36CAiyp/7Bf0Si1QSB+uisacH4n/0VvdzYh+x2nnJ7GzmUfblpwDWz8TW2OMU9aExsVN7jh292KhV///wTGXyAwAVVMthNje8s5al/iHNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ2PR11MB7618.namprd11.prod.outlook.com (2603:10b6:a03:4cb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Fri, 21 Apr
 2023 02:39:19 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%6]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 02:39:19 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Baolu Lu <baolu.lu@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        Joerg Roedel <joro@8bytes.org>
CC:     Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Ghorai, Sukumar" <sukumar.ghorai@intel.com>
Subject: RE: [PATCH v3] iommu/vt-d: Fix PASID directory pointer coherency
Thread-Topic: [PATCH v3] iommu/vt-d: Fix PASID directory pointer coherency
Thread-Index: AQHZZ9UC392MOCylEECV+/pkunR29a8z8GhggAEzdYCAAAEm0A==
Date:   Fri, 21 Apr 2023 02:39:19 +0000
Message-ID: <BN9PR11MB5276FD0BC9777D5253E7627A8C609@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230405154447.2436308-1-jacob.jun.pan@linux.intel.com>
 <BN9PR11MB52762EABB8EF8E685291604A8C639@BN9PR11MB5276.namprd11.prod.outlook.com>
 <706b94c0-b0bd-4488-081f-6a955b99284a@linux.intel.com>
In-Reply-To: <706b94c0-b0bd-4488-081f-6a955b99284a@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ2PR11MB7618:EE_
x-ms-office365-filtering-correlation-id: 1fdfc24c-e93e-4275-3526-08db42119b8f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xdBzuBG+E6a3Hyq13lg8XfG2DEdhxA6z5AYPkUepnEYH/jzOjG6evnFWp/k7uced2M743lDKGr5YZcztMzb3lsdtr3X9QoKOkPf9RJk2n/b/8tZ7a84TkNWSwcLL/v7AmOzD6WbzQCo2aNjSlDX9GfUlWdCqGVEh3DaAVK62hWuHreA1PTkLXfcOtWWIttBNamMkInnZXIcSotmUfSarpdSx7ZTWJm8Tcgse0oZCE/VmQ9/fbWtQcPWyrq7lCrvM6hPo0bAGBG/Ak7NbaXldPsnCrq2E1HEcOUpugNjncA4h0M0Feizrt8qt0KuL6O8X4DXhphNq4co3NLDhCI/Es2+kRBFDf6kyp1ky2L2V3wLmf6FVUSewv74VpqdOApus3M3EMRfk/OW6kOFnoZK1tZmkzaUgfZFULBGccCZUG9umHUF3AlzDOOZtOyneVE0wHswIOpynEaui6TWf3wz7+/F1CO1Q5+/jnfb0CPQ9j3AlbwdjKXUcEM4Jec3PUG+/E7hUdqYok+Uj1aCzYQl4TuRmeYqipIJvr4mjCnTA5HCWWQcoeOv12w5bmUi5PZ993euiy8mkfoGyTBhZJhUD27BpzxYLB6xXnAusivuAnM8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(366004)(376002)(136003)(346002)(451199021)(26005)(186003)(9686003)(41300700001)(53546011)(6506007)(110136005)(54906003)(86362001)(316002)(55016003)(4326008)(83380400001)(76116006)(64756008)(66946007)(66476007)(66446008)(8676002)(966005)(8936002)(7696005)(122000001)(52536014)(33656002)(2906002)(66556008)(82960400001)(38100700002)(38070700005)(5660300002)(71200400001)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1phYlk3ZnFNd2cwVno2S1lGejRoM1dpRHZnRmtseEpMdmhLUzlid3k2OVBT?=
 =?utf-8?B?Z1Y2aDlVY1oxYTh6K21tbEUvUk9YMEZwZVhWenoxcmVlcGVLMTZ6K3JmLzdP?=
 =?utf-8?B?eVJmNnNicDFGTFRVYTdxUk5hMllOSWpuSXR4YUlMSXAvZE5kc2tQN3RhMFIv?=
 =?utf-8?B?dTZFa1dyc1A0dUdud0twNzlOd2V0L0Z5d3VOMWE3dURWTXJOTzl4K2xTUXht?=
 =?utf-8?B?ZzFxV3QxdHVCallqRGYxQmcrZDVpek1adEhiRU82UGp2T3FiNURnRTFCZks0?=
 =?utf-8?B?ODdaQjl2V2VwWUoraE8zNUpCWndoWFhlaktJOWNNOWFtWndzUzhIR1pMNExG?=
 =?utf-8?B?M0hxak14cWw2Y1JlQzVSM0E1NlNlc3VnV205cjBRNHhiWit4RjhJK2xYbjBk?=
 =?utf-8?B?WWRNaDk1WkROMTRZeTEyMXMzWDlWNUVwSmRaQUJPUk96c3FTdzFBek0yQ1pV?=
 =?utf-8?B?YnR2M0pxWnlkMkxsZTljTXVjWWhDTUR4UlBoVStia0V5QlZaWFErd3Q0Q1Fm?=
 =?utf-8?B?SFdmUCtoQ21zcUtNWjJwbndVLzJmV096T2U5UmpFT0Q1RUFLK1lZTmxDNEhQ?=
 =?utf-8?B?R1dhUjZUNk0wV2svVnBaTjAyemh3c1hRdm1xQUVId2RLRnc3SmttSTRQTHRR?=
 =?utf-8?B?NGQ1V2xrOXA3bHQvQ0JiM0trTU9XL3BsQWJ5V3R4MVVLYlFEdHYxYXhlQk5V?=
 =?utf-8?B?TlA3b3ltYU9EQ1lKMzVTbEc5NFhZYjM4cEZISlY5Z0dqQjA4WGN1L1FCUUtq?=
 =?utf-8?B?QlFPeXJGUmVDOVIweUttVi9BdTRnMjBpdWJnajd6enRYeEtEa3VIbkRuUllK?=
 =?utf-8?B?M3BHNUhvQTR2d2ZOSW9ialZEZXQ0ZVFXbjJXVFVSYUt6QUU1aENPTTdRWUZI?=
 =?utf-8?B?OXRoWU1uaUhFaFhxSndNS0NtRjVrUjEzN3gzZmxnMkdZSUpGeTc3VGIybjE0?=
 =?utf-8?B?MEdob1AySGFHZHVrZERJd09GdlV4YllvSGJDOUVES0dldWNhZjNTS1ZZZElK?=
 =?utf-8?B?K05OMDg5bDBKV1hRTmxPZWJ6N21CWEFaazVXeXMrOGlRQ3dUUDBad0IxN0NK?=
 =?utf-8?B?V1B5RWt6ZlJlSW4wckxseVA1aFlHdllRREo5R1JBRFhyUFNMcWVnSWFDQS9D?=
 =?utf-8?B?YWRValhYQUY1TjlCQ25UM2lhYkw1QUt0eTBkRU5yT29zZ0VuaUxUb0NaclA3?=
 =?utf-8?B?UC8rVnVtRE4xbnBzSXRwREdOYkdCS2R6ZUdCQmFZTU96RGNwMnZNWEVmYXlx?=
 =?utf-8?B?ZFFuRTMrWWF6QVJRcTZhS2srUlZ3MDdpTmJyQ3pCdlV0K1JqbjFNcFR4T2Vi?=
 =?utf-8?B?dGNBMkNMdzZEL1g3TmZuMXlSaHRHQnE2VHZacEtCYllpcERhOEhER1F2Mm1z?=
 =?utf-8?B?YkNqZmRPNEdtNkljc21RUVBQTzVibXVjeVF3RWFBYlpIbUppTW9PVHRHcFk1?=
 =?utf-8?B?cGZYVTh3NlJIdFlzUXRiTWVibE1rTVg0Z1lSeHhETm8zOFB6RDdZREQvRGlo?=
 =?utf-8?B?c0lRTjAwcGcvRjBaaVg0b2hCa2lxWFc5alg4eXFJU1RZN3NWVHFzZEp0L3F1?=
 =?utf-8?B?b3V5VkM4UGo5VXpJa0duSW9zaW9VdGMvb1lCZXZHUG5JbjJDcEZrN0MwMkti?=
 =?utf-8?B?dm9PWWpMUW50bXVzcXN5ZitndzhxWUZrcHcxdldNWkljSHNhZEVQSmRoRUpN?=
 =?utf-8?B?bi9RMzlZUllJdzZhRjFyNkQ1NGIzMTZTZmFZNVVuandmZFVHV3U2WDZDeE9z?=
 =?utf-8?B?Um5DSW9BbG1jaFhybEUxc1F3dmtUV2k3b3BPWWgyclNVck1lUUlyKzNPdWxH?=
 =?utf-8?B?WmhKend4eWJNVDd3dkoveDFiSTRUY2VvZlhYVThFck5rcWRjOVJQeW9iSnlJ?=
 =?utf-8?B?a2lGNnhhRXRIOTZvT2R0TURmS0x1L0hGMWtGUStlRHAxeHBrNXd0UGdkSmhr?=
 =?utf-8?B?M2ZaZEQyc2RMa1N4bTRsalhrcS82OFgzY1p1NVo5SW5lTVhydkRXcGViMDBL?=
 =?utf-8?B?cGpzc3l0M2hwMXZDdGk0Y3dLays3TXFOU254VGFaSXFsMGowc2prYjVUdWhi?=
 =?utf-8?B?NFUwL24wSHFsUmhXcWlTN2F2VTkxbUl4cFVUaFAzTnVYbXEybkFLNTVBTjlI?=
 =?utf-8?Q?FZzsGTIj7cb+XS0KLBVKQv2w8?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fdfc24c-e93e-4275-3526-08db42119b8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 02:39:19.4499
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dRTpmuB4yHhcpFQyv5vaxvR1kFaXLZ4qScpP362fn7m24PZgIaZr6PnZaL35oNoeQIn7oAiVJSVBNocMVuBfFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7618
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBGcm9tOiBCYW9sdSBMdSA8YmFvbHUubHVAbGludXguaW50ZWwuY29tPg0KPiBTZW50OiBGcmlk
YXksIEFwcmlsIDIxLCAyMDIzIDEwOjM0IEFNDQo+IA0KPiBPbiA0LzIwLzIzIDQ6MTYgUE0sIFRp
YW4sIEtldmluIHdyb3RlOg0KPiA+PiBGcm9tOiBKYWNvYiBQYW4gPGphY29iLmp1bi5wYW5AbGlu
dXguaW50ZWwuY29tPg0KPiA+PiBTZW50OiBXZWRuZXNkYXksIEFwcmlsIDUsIDIwMjMgMTE6NDUg
UE0NCj4gPj4NCj4gPj4gT24gcGxhdGZvcm1zIHRoYXQgZG8gbm90IHN1cHBvcnQgSU9NTVUgRXh0
ZW5kZWQgY2FwYWJpbGl0eSBiaXQgMA0KPiA+PiBQYWdlLXdhbGsgQ29oZXJlbmN5LCBDUFUgY2Fj
aGVzIGFyZSBub3Qgc25vb3BlZCB3aGVuIElPTU1VIGlzDQo+ID4+IGFjY2Vzc2luZw0KPiA+PiBh
bnkgdHJhbnNsYXRpb24gc3RydWN0dXJlcy4gSU9NTVUgYWNjZXNzIGdvZXMgb25seSBkaXJlY3Rs
eSB0bw0KPiA+PiBtZW1vcnkuIEludGVsIElPTU1VIGNvZGUgd2FzIG1pc3NpbmcgYSBmbHVzaCBm
b3IgdGhlIFBBU0lEIHRhYmxlDQo+ID4+IGRpcmVjdG9yeSB0aGF0IHJlc3VsdGVkIGluIHRoZSB1
bnJlY292ZXJhYmxlIGZhdWx0IGFzIHNob3duIGJlbG93Lg0KPiA+Pg0KPiA+PiBUaGlzIHBhdGNo
IGFkZHMgY2xmbHVzaCBjYWxscyB3aGVuZXZlciBhbGxvY2F0aW5nIGFuZCB1cGRhdGluZw0KPiA+
PiBhIFBBU0lEIHRhYmxlIGRpcmVjdG9yeSB0byBlbnN1cmUgY2FjaGUgY29oZXJlbmN5Lg0KPiA+
Pg0KPiA+PiBPbiB0aGUgcmV2ZXJzZSBkaXJlY3Rpb24sIHRoZXJlJ3Mgbm8gbmVlZCB0byBjbGZs
dXNoIHRoZSBQQVNJRCBkaXJlY3RvcnkNCj4gPj4gcG9pbnRlciB3aGVuIHdlIGRlYWN0aXZhdGUg
YSBjb250ZXh0IGVudHJ5IGluIHRoYXQgSU9NTVUgaGFyZHdhcmUgd2lsbA0KPiA+PiBub3Qgc2Vl
IHRoZSBvbGQgUEFTSUQgZGlyZWN0b3J5IHBvaW50ZXIgYWZ0ZXIgd2UgY2xlYXIgdGhlIGNvbnRl
eHQgZW50cnkuDQo+ID4+IFBBU0lEIGRpcmVjdG9yeSBlbnRyaWVzIGFyZSBhbHNvIG5ldmVyIGZy
ZWVkIG9uY2UgYWxsb2NhdGVkLg0KPiA+Pg0KPiA+PiBbICAgIDAuNTU1Mzg2XSBETUFSOiBEUkhE
OiBoYW5kbGluZyBmYXVsdCBzdGF0dXMgcmVnIDMNCj4gPj4gWyAgICAwLjU1NTgwNV0gRE1BUjog
W0RNQSBSZWFkIE5PX1BBU0lEXSBSZXF1ZXN0IGRldmljZSBbMDA6MGQuMl0gZmF1bHQNCj4gPj4g
YWRkciAweDEwMjZhNDAwMCBbZmF1bHQgcmVhc29uIDB4NTFdIFNNOiBQcmVzZW50IGJpdCBpbiBE
aXJlY3RvcnkgRW50cnkgaXMNCj4gPj4gY2xlYXINCj4gPj4gWyAgICAwLjU1NjM0OF0gRE1BUjog
RHVtcCBkbWFyMSB0YWJsZSBlbnRyaWVzIGZvciBJT1ZBIDB4MTAyNmE0MDAwDQo+ID4+IFsgICAg
MC41NTYzNDhdIERNQVI6IHNjYWxhYmxlIG1vZGUgcm9vdCBlbnRyeTogaGkgMHgwMDAwMDAwMTAy
NDQ4MDAxLA0KPiBsb3cNCj4gPj4gMHgwMDAwMDAwMTAxYjNlMDAxDQo+ID4+IFsgICAgMC41NTYz
NDhdIERNQVI6IGNvbnRleHQgZW50cnk6IGhpIDB4MDAwMDAwMDAwMDAwMDAwMCwgbG93DQo+ID4+
IDB4MDAwMDAwMDEwMWI0ZDQwMQ0KPiA+PiBbICAgIDAuNTU2MzQ4XSBETUFSOiBwYXNpZCBkaXIg
ZW50cnk6IDB4MDAwMDAwMDEwMWI0ZTAwMQ0KPiA+PiBbICAgIDAuNTU2MzQ4XSBETUFSOiBwYXNp
ZCB0YWJsZSBlbnRyeVswXTogMHgwMDAwMDAwMDAwMDAwMTA5DQo+ID4+IFsgICAgMC41NTYzNDhd
IERNQVI6IHBhc2lkIHRhYmxlIGVudHJ5WzFdOiAweDAwMDAwMDAwMDAwMDAwMDENCj4gPj4gWyAg
ICAwLjU1NjM0OF0gRE1BUjogcGFzaWQgdGFibGUgZW50cnlbMl06IDB4MDAwMDAwMDAwMDAwMDAw
MA0KPiA+PiBbICAgIDAuNTU2MzQ4XSBETUFSOiBwYXNpZCB0YWJsZSBlbnRyeVszXTogMHgwMDAw
MDAwMDAwMDAwMDAwDQo+ID4+IFsgICAgMC41NTYzNDhdIERNQVI6IHBhc2lkIHRhYmxlIGVudHJ5
WzRdOiAweDAwMDAwMDAwMDAwMDAwMDANCj4gPj4gWyAgICAwLjU1NjM0OF0gRE1BUjogcGFzaWQg
dGFibGUgZW50cnlbNV06IDB4MDAwMDAwMDAwMDAwMDAwMA0KPiA+PiBbICAgIDAuNTU2MzQ4XSBE
TUFSOiBwYXNpZCB0YWJsZSBlbnRyeVs2XTogMHgwMDAwMDAwMDAwMDAwMDAwDQo+ID4+IFsgICAg
MC41NTYzNDhdIERNQVI6IHBhc2lkIHRhYmxlIGVudHJ5WzddOiAweDAwMDAwMDAwMDAwMDAwMDAN
Cj4gPj4gWyAgICAwLjU1NjM0OF0gRE1BUjogUFRFIG5vdCBwcmVzZW50IGF0IGxldmVsIDQNCj4g
Pj4NCj4gPj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPiA+PiBGaXhlczogMGJiZWIw
MWE0ZmFmICgiaW9tbXUvdnQtZDogTWFuYWdlIHNjYWxhbGJsZSBtb2RlIFBBU0lEIHRhYmxlcyIp
DQo+ID4+IFJlcG9ydGVkLWJ5OiBTdWt1bWFyIEdob3JhaSA8c3VrdW1hci5naG9yYWlAaW50ZWwu
Y29tPg0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBBc2hvayBSYWogPGFzaG9rLnJhakBpbnRlbC5jb20+
DQo+ID4+IFNpZ25lZC1vZmYtYnk6IEphY29iIFBhbiA8amFjb2IuanVuLnBhbkBsaW51eC5pbnRl
bC5jb20+DQo+ID4+IC0tLQ0KPiA+PiB2MzogQWRkIGNsZmx1c2ggYWZ0ZXIgUEFTSUQgZGlyZWN0
b3J5IGFsbG9jYXRpb24gdG8gcHJldmVudCBtYWxpY2lvdXMNCj4gPj4gZGV2aWNlIGF0dGFjayB3
aXRoIHVuYXV0aG9yaXplZCBQQVNJRHMuIEFsc28gZmx1c2ggYWxsIHRoZSBQQVNJRCBlbnRyaWVz
DQo+ID4+IGFmdGVyIGRpcmVjdG9yeSB1cGRhdGVzLiAoQmFvbHUpDQo+ID4+IHYyOiBBZGQgY2xm
bHVzaCB0byBQQVNJRCBkaXJlY3RvcnkgdXBkYXRlIGNhc2UgKEJhb2x1LCBLZXZpbiByZXZpZXcp
DQo+ID4+IC0tLQ0KPiA+PiAgIGRyaXZlcnMvaW9tbXUvaW50ZWwvaW9tbXUuYyB8IDIgKysNCj4g
Pj4gICBkcml2ZXJzL2lvbW11L2ludGVsL3Bhc2lkLmMgfCA3ICsrKysrKysNCj4gPj4gICAyIGZp
bGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKQ0KPiA+Pg0KPiA+PiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9pb21tdS9pbnRlbC9pb21tdS5jIGIvZHJpdmVycy9pb21tdS9pbnRlbC9pb21tdS5jDQo+
ID4+IGluZGV4IDU5ZGY3ZTQyZmQ1My4uMTYxMzQyZTcxNDlkIDEwMDY0NA0KPiA+PiAtLS0gYS9k
cml2ZXJzL2lvbW11L2ludGVsL2lvbW11LmMNCj4gPj4gKysrIGIvZHJpdmVycy9pb21tdS9pbnRl
bC9pb21tdS5jDQo+ID4+IEBAIC0xOTc2LDYgKzE5NzYsOCBAQCBzdGF0aWMgaW50IGRvbWFpbl9j
b250ZXh0X21hcHBpbmdfb25lKHN0cnVjdA0KPiA+PiBkbWFyX2RvbWFpbiAqZG9tYWluLA0KPiA+
PiAgIAkJcGRzID0gY29udGV4dF9nZXRfc21fcGRzKHRhYmxlKTsNCj4gPj4gICAJCWNvbnRleHQt
PmxvID0gKHU2NCl2aXJ0X3RvX3BoeXModGFibGUtPnRhYmxlKSB8DQo+ID4+ICAgCQkJCWNvbnRl
eHRfcGR0cyhwZHMpOw0KPiA+PiArCQlpZiAoIWVjYXBfY29oZXJlbnQoaW9tbXUtPmVjYXApKQ0K
PiA+PiArCQkJY2xmbHVzaF9jYWNoZV9yYW5nZSh0YWJsZS0+dGFibGUsIHNpemVvZih1NjQpKTsN
Cj4gPg0KPiA+IHYyIG9mIHRoaXMgcGF0Y2ggd2FzIGFscmVhZHkgbWVyZ2VkIHcvbyB0aGlzIGNo
YW5nZS4NCj4gDQo+IFRoZSBtZXJnZWQgcGF0Y2ggaXMgdjQuDQo+IA0KPiBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9hbGwvMjAyMzAyMDkyMTI4NDMuMTc4ODEyNS0xLQ0KPiBqYWNvYi5qdW4ucGFu
QGxpbnV4LmludGVsLmNvbS8NCj4gDQo+ID4gY2FuIHlvdSBlbGFib3JhdGUgdGhlIHB1cnBvc2Ug
b2YgdjM/IEhlcmUgbm8gZmx1c2ggaXMgcmVxdWlyZWQgYXMgbG9uZw0KPiA+IGFzIGl0J3MgZG9u
ZSBpbiBvdGhlciB0d28gcGxhY2VzIGJlbG93Lg0KPiANCj4gTm8gYWJvdmUgY29kZSBpbiB0aGUg
bWVyZ2VkIHBhdGNoLg0KPiANCg0Kc28gdGhpcyBvbmUgbWlnaHQgYmUganVzdCBzZW50IGluYWR2
ZXJ0ZW50bHkgYnkgSmFjb2IuDQo=
