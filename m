Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3B65E629C
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 14:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbiIVMkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 08:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiIVMkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 08:40:52 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38BB5E7C3E
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 05:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663850451; x=1695386451;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=twjIN/9xdvdaOkvMLMozxYV7QDBxNsKizeJ+ODhInnc=;
  b=aYIItPDsCz5GslpHZm4l6RYco1s6p9B0Imi17nzlEZi0iut8fYmCHbjk
   sb+1MwEGbtjYBUnyKA7UfRNplgNVcLeVRJr5hQjHD3L/vrAtvqqcg6Ztq
   nudpATmhhoawev/onEeVld7VtFJdi/6Jc7KvkRbMdFKsWOMOzB0N35jmM
   T8dWXlXEEZ3jG/bMNZ1Y66qS6W4ZYJlUW1sbbCJzOxw2ZzlnGq5dwscsI
   76HbyKaqZkl5LQYOOua89hSlmAZt1otxiJV0nBc7bC2qVtVGUexOhCKjb
   VHxGlIImAV2TkpkzNxCoIUiGpswGoP0pyjvrdQkHSo+gVdR4a1VwVPVxS
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="386572314"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="386572314"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 05:40:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="864838776"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 22 Sep 2022 05:40:49 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 05:40:49 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 22 Sep 2022 05:40:49 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 22 Sep 2022 05:40:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UOlwBf6MEhG8sRBvg5WwSUbpgDHobQiqk+FxQvXtLzW0QLnl7G+QaKdN9+UFCSi1dJ8FaOlcgHkrpnDfK7buW3Dh/AtAr+H2zRzuM1UWSxgHawICtXsPMFOuivOjFqrXcdQs5YEgyxZ/scr4IkQamU43yivJ6dljjOLgiNezgIq2kQskTq3WHcZC2UiQsLsJPvA4JKA/bit8+4/MfHuV5TQJmvf3d2DXnTvpfOZtsfhYd8TCfFPYT7o8XtzkCfR+hOzb/D60J083kUQCOMRZmbqC2YzvdPMmuTc5G+/4uECTv2O0T6py7zbD4ETviNCxr70h909BpLK3b+tlKZfMGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=twjIN/9xdvdaOkvMLMozxYV7QDBxNsKizeJ+ODhInnc=;
 b=oFP1aBVTNNOK5pY1muSxaFRlc7eIa+TkI1WfJjixL6BcX0ux8fG3tXPueg3sLiz61AlGs5ZL2cPfzjEmK5oTaIKWOjaZrHEZIg7+Rz1i2UQwU8mXwmn3RD5YE5NioyUG9jz0xsnr/PwuDVTFtnWi7HRk9rQmwKa/CpLaIBUPTCuGJQvU9DaziWjPiwfKES3Zs3qsvedR4UZynnoWuTMNrnreC7zfcX8nxbg/1/xnrS1qV7r3IiFuuNEGN22TOVDI7R3zngpaZgC4NFvV5sBjLTCqEBhqoC58LELSNZ9NtNq2pD8ZHzDfwZQpNLCeNIYvrqH7jUA/eixx/T0lDiidVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CY5PR11MB6211.namprd11.prod.outlook.com (2603:10b6:930:25::6)
 by MW4PR11MB5774.namprd11.prod.outlook.com (2603:10b6:303:182::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.19; Thu, 22 Sep
 2022 12:40:47 +0000
Received: from CY5PR11MB6211.namprd11.prod.outlook.com
 ([fe80::c144:218:70eb:9cbe]) by CY5PR11MB6211.namprd11.prod.outlook.com
 ([fe80::c144:218:70eb:9cbe%4]) with mapi id 15.20.5654.016; Thu, 22 Sep 2022
 12:40:47 +0000
From:   "Gupta, Anshuman" <anshuman.gupta@intel.com>
To:     "Vivi, Rodrigo" <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
CC:     "Nikula, Jani" <jani.nikula@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Daniel J Blueman <daniel@quora.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [Intel-gfx] [PATCH] drm/i915: Allow D3 when we are not actively
 managing a known PCI device.
Thread-Topic: [Intel-gfx] [PATCH] drm/i915: Allow D3 when we are not actively
 managing a known PCI device.
Thread-Index: AQHYzeEYznFvOgAuv0yf0c+ZzLKSUa3rFcAAgAAd7ACAABg0AIAAENyw
Date:   Thu, 22 Sep 2022 12:40:47 +0000
Message-ID: <CY5PR11MB6211DA61B9089B4D700DE745954E9@CY5PR11MB6211.namprd11.prod.outlook.com>
References: <20220921173914.1606359-1-rodrigo.vivi@intel.com>
 <2f318650-b01a-a526-8b74-bff99d5b2010@linux.intel.com>
 <YywuKoAg35X1Pclh@intel.com> <d2a3a63e-597a-6423-3660-f16717dc85e2@intel.com>
In-Reply-To: <d2a3a63e-597a-6423-3660-f16717dc85e2@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CY5PR11MB6211:EE_|MW4PR11MB5774:EE_
x-ms-office365-filtering-correlation-id: b56b84ec-a0d5-4355-1b8a-08da9c97ac67
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PqhVfPpwQpSKTQdBxcV6lj/f9mRdRdH9jiXjWRw1Tu3Bg57dAzu3l1653cIRpSnzV2fIVytem3n6HYqGtSjqvatNDlPfDshGKJ/Y+GUq4XazRKPHoe1IpPXoCmWWHzR+oqWDKMmQeuT2Y5ivRYTNEEQESr/X+yUAPKZ95lps7+kChmH7eBUvyR6VWSUcFmU/pRf3DZrQC4RNRM61a4dx8kWyS+/93FwXBSSRFg7IScP1yVOC1I+PDzVdazHV+Pna/sB2fsU9kPuw+i4a2eyIvH7xUbOU7cw3Tnk8oCbE2elWLR6ESltfr85iuRIeMJ2SKfOHJsgHssMvvJ2bnOe9NpLdqvAl8byRi4lFXLCcB7SkzcFrNrFpkuoJ8MBwFF7sft2etKidXBcdQFonNUxLvu9XWNJotAqaHdW1N4mu19HTuQvQvRDKHJg83PlEL5WqlE8k4uTXZTHcOiil7Og/0doUQju6+K/vsVFUdGqDmFYz5e+os8V4MtmB6OuiRdtH35BnLZrIDOW/H4aNbDl1W3s70AqKStCZABzIEe62xLCy+AQ3qyyGHU7M8V8QC3rhY1BOTD+ZEHq6qIBZOO4/IJBa2IA2dIdQCCmnyj0Kx2Idl8ZWYOKqx5tgoZ/GWTQ0PZHFvIjubzf0wwL7TsQTGMv+ktgc+3EwB4ZKQJhuFEHeX2HP1xymNJp6UppuaHywbU89FMHmDtP5UvA3NDRUgWeJwKEcNgk3b4HIy0hFXOfrFl6662CygeIwjiaIir+L7HB8Mq2wbi0/+FG8xpWZcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6211.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199015)(2906002)(186003)(41300700001)(8936002)(52536014)(6506007)(7696005)(9686003)(26005)(55236004)(53546011)(5660300002)(86362001)(122000001)(55016003)(83380400001)(38100700002)(82960400001)(33656002)(38070700005)(316002)(54906003)(110136005)(478600001)(4326008)(66946007)(71200400001)(66476007)(66446008)(64756008)(8676002)(66556008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TzhoeDU5VXdrdUJiQm5WZDdyTUNxY25zZnVKbG56TEZiVkFFN0pvSUVlb0VO?=
 =?utf-8?B?TXVJekoxWkgvalNDekg5b0F4VDR1bk5FQ2Vsc2lwaGh4N2dYd0U1UnkvdW1F?=
 =?utf-8?B?UXZnbnpncU5NeThiclpPL3EvRXM0SVl1OXFnMUF4UmV2aVZCc1Y3bWhiRDZm?=
 =?utf-8?B?dGE4KzhEaHF4UEJuemh0OGN5VkpwelN1T2tuVTdScmVBeE5NbWozUFBMZ21w?=
 =?utf-8?B?em9pb2YwbWtTeVFSYXZzZmpGeUo0TXJITWJzcmdEK0RJU0lYYkR0bEsrWUsv?=
 =?utf-8?B?eGVHQjF5K2dSL2h0eVZ6dlBuWEJEWGpDS09XemtGQkRtME9udFgwS2hBZlRu?=
 =?utf-8?B?RWwyR3BRaTlmdG4zWW9IYU0rMmE5TFdIUlE5QXUwYWxINmsrb2VsbGxiVG5G?=
 =?utf-8?B?VkRjejFEQTgvdE54a3ZmV2ZXWmozcWNrUjlMZXl6T1hlVDN3NTByODhQbFBr?=
 =?utf-8?B?bW5uSnZtZE9jTFkxc2t1Y3FCQXJSQXY5Mjl3QmJFeGs1VVNoVjc4VzJNVDcx?=
 =?utf-8?B?akcrSmp0bzdQR0p4SFdWUm9rWFdsS1lQaEtTb3dwazRabUE5UktLbWxSVHQw?=
 =?utf-8?B?TUVPbUN5M2RwenRLL0czZGhKdG9PRVRWejBvUEF6U3JPWjJZc0pkVDhOc2xZ?=
 =?utf-8?B?WS9KbzByc0MwT1JYZmU2MTNWZ2lwdVhZK1g0K1BEYmhaZWZEWFhMUHN0T0tU?=
 =?utf-8?B?U1d2cURYNDNoL21UNXU3NTdrcHREdUZGYmxGeWRHdmg5bkNSc1IxTDlEVTRS?=
 =?utf-8?B?VGdMeGcxTWpvc1ZDMWdxeEVxV3gwZVdmbFZGbDltRE5hVzFZMkNjMFB5NXI5?=
 =?utf-8?B?NnUwdHlwZFF4Y3JNbGpnL1ZkdklvQ1ZmWFY4Vmo4eit0Z3V6VytOS1d6WlBh?=
 =?utf-8?B?NDVybC9GekJ0UXdGUUtDYWdNMzVpbkRpZUUxT2x0dm1WZG12OVlpUmd6WTJl?=
 =?utf-8?B?Qis1Z01FbEwyeVhkQ1dUN2RhSVduTkg5RnMzbzczR3I2LzJBK2xVaWY5a2JI?=
 =?utf-8?B?VDNOWEhJMFIyYUZoYVJnaE5tbEYvZEZwMGlxQ3hVd0FyZTNIcnhzREowb1FB?=
 =?utf-8?B?RjNEM3kxeUdWOXRlODROWUhzYjUrd1EzTTdsbmFQVVBwejJFTEEyMjZmYlpp?=
 =?utf-8?B?eU16cGdsbko1cG13STNib3FlU1lGOGpPeElSY2ZpK1VvMGpPU25jQStKR0Jy?=
 =?utf-8?B?Vmp2VE5MZTVOdjkyblNCeWVoS29sQkM3R0dNdU9oRlhVWjVNeHJOQmYvQlpa?=
 =?utf-8?B?bk9mU1pubkpIRTRIbUl3Z01IcnVEL1laQUxBd1AvNFFxS3p6NzNXeXZDUlZ0?=
 =?utf-8?B?Y2pNZ05NL0xxQnNNU3FFZDhORFlEZU1zY0RiWW5WMTZNSGhKM1RTVnRnSVpR?=
 =?utf-8?B?OGNMTlRIZ2tiN1NRa3VzdVh2WkZRa3JYeG52dUg0dnI4Q0JWQzVxbC9jMGFn?=
 =?utf-8?B?K0dZalNNNTRWYlpoaVczQ0Q1cHVXdUlNNVRSMUdjdUtTT2VaRDRGcmM4YmlF?=
 =?utf-8?B?NytEVVhQMjFKQzdFK1dROWpjMkgzaEg5R0ZXMTVTbnhOUGRWWW40b0RrWEpt?=
 =?utf-8?B?ZDE3YjhwWEdENDgxb0tKbGdkUTJqM3p1S3h2RVRySU5jS080dzVoTEUzd0M0?=
 =?utf-8?B?YzlmbFJwU05Fd1VYNTczdUp4dzBnRkh1YWg1QVNJaTVpZFNvQmVXMHBZL3k2?=
 =?utf-8?B?NlJaUEtlcjBaQnYwcjRabHFBdDM3akxTd0pxcGQzMjRpclpGblU5L2diaWNs?=
 =?utf-8?B?M1dvbjJabkcyS1Y4d0dBYk8vSi9CWXU3QjcvaWt2dzBpeFRpUDRNWWhnb2h4?=
 =?utf-8?B?eDNxelkzMkNYbmdTeDV1UGc3UEdCc1BXb05rMXhWMEJaWUJNeEtFT2FtZzFR?=
 =?utf-8?B?aHRUanhpY1JjMEp6NDZ3L2wxN0FlTE1KMWVYQ2RrblZ4di9TL21BY0RxaytF?=
 =?utf-8?B?alpCbUhtNGpRTlNFL3psd3A0N09Tb0dmWlg3d1R1YWdtVjBSOU9jQ3JMcUkx?=
 =?utf-8?B?Ky84dDE4WlAxWEM1eG9jTUgvZThWMUMzNWNjaWdUTVFTbXBuTDhhei9VNTV1?=
 =?utf-8?B?OEcxK2lTWCtkSjR3dVk1Ly9VR2k2QjFyYmNKVUhGTlhpZjhFSUVkRjFZSVRr?=
 =?utf-8?Q?tiqoJeq35oUdo6zPfUPZHXKi8?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6211.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b56b84ec-a0d5-4355-1b8a-08da9c97ac67
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 12:40:47.2467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dag4dSrKGXaQHLgUG5DNot/IDHRhZe6XWqF9ZcuqTwQ527uoVNGL9kvD7Ley779CLlqi3N4qi4GonE12IYfgoWSHp202Ohj3YDCTl6dc7BA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5774
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogR3VwdGEsIEFuc2h1bWFu
DQo+IFNlbnQ6IFRodXJzZGF5LCBTZXB0ZW1iZXIgMjIsIDIwMjIgNDo0MCBQTQ0KPiBUbzogVml2
aSwgUm9kcmlnbyA8cm9kcmlnby52aXZpQGludGVsLmNvbT47IFR2cnRrbyBVcnN1bGluDQo+IDx0
dnJ0a28udXJzdWxpbkBsaW51eC5pbnRlbC5jb20+DQo+IENjOiBOaWt1bGEsIEphbmkgPGphbmku
bmlrdWxhQGludGVsLmNvbT47IGludGVsLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmc7IERhbmll
bA0KPiBKIEJsdWVtYW4gPGRhbmllbEBxdW9yYS5vcmc+OyBXeXNvY2tpLCBSYWZhZWwgSg0KPiA8
cmFmYWVsLmoud3lzb2NraUBpbnRlbC5jb20+OyBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFN1
YmplY3Q6IFJlOiBbSW50ZWwtZ2Z4XSBbUEFUQ0hdIGRybS9pOTE1OiBBbGxvdyBEMyB3aGVuIHdl
IGFyZSBub3QgYWN0aXZlbHkNCj4gbWFuYWdpbmcgYSBrbm93biBQQ0kgZGV2aWNlLg0KPiANCj4g
DQo+IA0KPiBPbiA5LzIyLzIwMjIgMzoxMyBQTSwgUm9kcmlnbyBWaXZpIHdyb3RlOg0KPiA+IE9u
IFRodSwgU2VwIDIyLCAyMDIyIGF0IDA4OjU2OjAwQU0gKzAxMDAsIFR2cnRrbyBVcnN1bGluIHdy
b3RlOg0KPiA+Pg0KPiA+PiBPbiAyMS8wOS8yMDIyIDE4OjM5LCBSb2RyaWdvIFZpdmkgd3JvdGU6
DQo+ID4+PiBUaGUgZm9yY2VfcHJvYmUgcHJvdGVjdGlvbiBhY3RpdmVseSBhdm9pZHMgdGhlIHBy
b2JlIG9mIGk5MTUgdG8NCj4gPj4+IG1hbmFnZSBhIGRldmljZSB0aGF0IGlzIGN1cnJlbnRseSB1
bmRlciBkZXZlbG9wbWVudC4gSXQgaXMgYSBuaWNlDQo+ID4+PiBwcm90ZWN0aW9uIGZvciBmdXR1
cmUgdXNlcnMgd2hlbiBnZXR0aW5nIGEgbmV3IHBsYXRmb3JtIGJ1dCB1c2luZw0KPiA+Pj4gc29t
ZSBvbGRlciBrZXJuZWwuDQo+ID4+Pg0KPiA+Pj4gSG93ZXZlciwgd2hlbiB3ZSBhdm9pZCB0aGUg
cHJvYmUgd2UgZG9uJ3QgdGFrZSBiYWNrIHRoZSByZWdpc3RyYXRpb24NCj4gPj4+IG9mIHRoZSBk
ZXZpY2UuIFdlIGNhbm5vdCBnaXZlIHVwIHRoZSByZWdpc3RyYXRpb24gYW55d2F5IHNpbmNlIHdl
DQo+ID4+PiBjYW4gaGF2ZSBtdWx0aXBsZSBkZXZpY2VzIHByZXNlbnQuIEZvciBpbnN0YW5jZSBh
biBpbnRlZ3JhdGVkIGFuZCBhDQo+ID4+PiBkaXNjcmV0ZSBvbmUuDQo+ID4+Pg0KPiA+Pj4gV2hl
biB0aGlzIHNjZW5hcmlvIG9jY3VycywgdGhlIHVzZXIgd2lsbCBub3QgYmUgYWJsZSB0byBjaGFu
Z2UgYW55DQo+ID4+PiBvZiB0aGUgcnVudGltZSBwbSBjb25maWd1cmF0aW9uIG9mIHRoZSB1bm1h
bmFnZWQgZGV2aWNlLiBTbywgaXQgd2lsbA0KPiA+Pj4gYmUgYmxvY2tlZCBpbiBEMCBzdGF0ZSB3
YXN0aW5nIHBvd2VyLiBUaGlzIGlzIHNwZWNpYWxseSBiYWQgaW4gdGhlDQo+ID4+PiBjYXNlIHdo
ZXJlIHdlIGhhdmUgYSBkaXNjcmV0ZSBwbGF0Zm9ybSBhdHRhY2hlZCwgYnV0IHRoZSB1c2VyIGlz
DQo+ID4+PiBhYmxlIHRvIGZ1bGx5IHVzZSB0aGUgaW50ZWdyYXRlZCBvbmUgZm9yIGV2ZXJ5dGhp
bmcgZWxzZS4NCj4gPj4+DQo+ID4+PiBTbywgbGV0J3MgcHV0IHRoZSBwcm90ZWN0ZWQgYW5kIHVu
bWFuYWdlZCBkZXZpY2UgaW4gRDMuIFNvIHdlIGNhbg0KPiA+Pj4gc2F2ZSBzb21lIHBvd2VyLg0K
PiA+Pj4NCj4gPj4+IFJlcG9ydGVkLWJ5OiBEYW5pZWwgSiBCbHVlbWFuIDxkYW5pZWxAcXVvcmEu
b3JnPg0KPiA+Pj4gQ2M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPj4+IENjOiBEYW5pZWwg
SiBCbHVlbWFuIDxkYW5pZWxAcXVvcmEub3JnPg0KPiA+Pj4gQ2M6IFR2cnRrbyBVcnN1bGluIDx0
dnJ0a28udXJzdWxpbkBpbnRlbC5jb20+DQo+ID4+PiBDYzogQW5zaHVtYW4gR3VwdGEgPGFuc2h1
bWFuLmd1cHRhQGludGVsLmNvbT4NCj4gPj4+IFNpZ25lZC1vZmYtYnk6IFJvZHJpZ28gVml2aSA8
cm9kcmlnby52aXZpQGludGVsLmNvbT4NCj4gPj4+IC0tLQ0KPiA+Pj4gICAgZHJpdmVycy9ncHUv
ZHJtL2k5MTUvaTkxNV9wY2kuYyB8IDggKysrKysrKysNCj4gPj4+ICAgIDEgZmlsZSBjaGFuZ2Vk
LCA4IGluc2VydGlvbnMoKykNCj4gPj4+DQo+ID4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUv
ZHJtL2k5MTUvaTkxNV9wY2kuYw0KPiA+Pj4gYi9kcml2ZXJzL2dwdS9kcm0vaTkxNS9pOTE1X3Bj
aS5jIGluZGV4IDc3ZTdkZjIxZjUzOS4uZmMzZTdjNjlhZjJhDQo+ID4+PiAxMDA2NDQNCj4gPj4+
IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9pOTE1L2k5MTVfcGNpLmMNCj4gPj4+ICsrKyBiL2RyaXZl
cnMvZ3B1L2RybS9pOTE1L2k5MTVfcGNpLmMNCj4gPj4+IEBAIC0yNSw2ICsyNSw3IEBADQo+ID4+
PiAgICAjaW5jbHVkZSA8ZHJtL2RybV9jb2xvcl9tZ210Lmg+DQo+ID4+PiAgICAjaW5jbHVkZSA8
ZHJtL2RybV9kcnYuaD4NCj4gPj4+ICAgICNpbmNsdWRlIDxkcm0vaTkxNV9wY2lpZHMuaD4NCj4g
Pj4+ICsjaW5jbHVkZSA8bGludXgvcG1fcnVudGltZS5oPg0KPiA+Pj4gICAgI2luY2x1ZGUgImd0
L2ludGVsX2d0X3JlZ3MuaCINCj4gPj4+ICAgICNpbmNsdWRlICJndC9pbnRlbF9zYV9tZWRpYS5o
Ig0KPiA+Pj4gQEAgLTEzMDQsNiArMTMwNSw3IEBAIHN0YXRpYyBpbnQgaTkxNV9wY2lfcHJvYmUo
c3RydWN0IHBjaV9kZXYgKnBkZXYsDQo+IGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkICplbnQp
DQo+ID4+PiAgICB7DQo+ID4+PiAgICAJc3RydWN0IGludGVsX2RldmljZV9pbmZvICppbnRlbF9p
bmZvID0NCj4gPj4+ICAgIAkJKHN0cnVjdCBpbnRlbF9kZXZpY2VfaW5mbyAqKSBlbnQtPmRyaXZl
cl9kYXRhOw0KPiA+Pj4gKwlzdHJ1Y3QgZGV2aWNlICprZGV2ID0gJnBkZXYtPmRldjsNCj4gPj4+
ICAgIAlpbnQgZXJyOw0KPiA+Pj4gICAgCWlmIChpbnRlbF9pbmZvLT5yZXF1aXJlX2ZvcmNlX3By
b2JlICYmIEBAIC0xMzE0LDYgKzEzMTYsMTIgQEANCj4gPj4+IHN0YXRpYyBpbnQgaTkxNV9wY2lf
cHJvYmUoc3RydWN0IHBjaV9kZXYgKnBkZXYsIGNvbnN0IHN0cnVjdCBwY2lfZGV2aWNlX2lkDQo+
ICplbnQpDQo+ID4+PiAgICAJCQkgIm1vZHVsZSBwYXJhbWV0ZXIgb3INCj4gQ09ORklHX0RSTV9J
OTE1X0ZPUkNFX1BST0JFPSUwNHggY29uZmlndXJhdGlvbiBvcHRpb24sXG4iDQo+ID4+PiAgICAJ
CQkgIm9yIChyZWNvbW1lbmRlZCkgY2hlY2sgZm9yIGtlcm5lbCB1cGRhdGVzLlxuIiwNCj4gPj4+
ICAgIAkJCSBwZGV2LT5kZXZpY2UsIHBkZXYtPmRldmljZSwgcGRldi0+ZGV2aWNlKTsNCj4gPj4+
ICsNCj4gPj4+ICsJCS8qIExldCdzIG5vdCB3YXN0ZSBwb3dlciBpZiB3ZSBhcmUgbm90IG1hbmFn
aW5nIHRoZSBkZXZpY2UgKi8NCj4gPj4+ICsJCXBtX3J1bnRpbWVfdXNlX2F1dG9zdXNwZW5kKGtk
ZXYpOw0KPiA+Pj4gKwkJcG1fcnVudGltZV9hbGxvdyhrZGV2KTsNCj4gPj4+ICsJCXBtX3J1bnRp
bWVfcHV0X2F1dG9zdXNwZW5kKGtkZXYpOw0KPiBBRkFJSyB3ZSBkb24ndCBuZWVkIHRvIGVuYWJs
ZSBhdXRvc3VzcGVuZCBoZXJlLA0KPiBwbV9ydW50aW1lX3B1dF9hdXRvc3VzcGVuZCgpIHdpbGwg
Y2F1c2UgYSBOVUxMIHBvaW50ZXIgZGUtcmVmZXJlbmNlIGFzIGl0IHdpbGwNCj4gaW1tZWRpYXRl
bHkgY2FsbCB0aGUgaW50ZWxfcnVudGltZV9zdXNwZW5kKCkoYmVjYXVzZSB3ZSBoYXZlbid0IGNh
bGxlZCB0aGUNCj4gcG1fcnVudGltZV9tYXJrX2xhc3RfYnVzeSkgd2l0aG91dCBpbml0aWFsaXpp
bmcgaTkxNS4NCj4gDQo+IEhhdmluZyBzYWlkIHRoYXQgd2Ugb25seSBuZWVkIGJlbG93LCBpbiBv
cmRlciB0byBsZXQgcGNpIGNvcmUga2VlcCB0aGUgcGNpIGRldiBpbg0KPiBEMy4NCj4gDQo+IHBt
X3J1bnRpbWVfcHV0X25vaWRsZSgpDQpIaSBSb2RyaWdvICwNCkl0IHNlZW1zIHBsYXlpbmcgd2l0
aCB0aGVzZSBydW50aW1lIGhvb2tzLCB3aWxsIG9ubHkgZW5hYmxlIHRoZSAicnVudGltZSBzdXNw
ZW5kIg0KYnV0IGFjdHVhbCBzdGF0ZSBpbiAiUE1DU1IiIHBjaSBjb25maWcgaXMgRDAgZGVzcGl0
ZSBkZXZpY2UgaXMgcnVudGltZSBzdXNwZW5kZWQsIHdoZW4gdGhlcmUgaXMgbm8gZHJpdmVyLg0K
RXhhbXBsZToNCnJvb3RARFVUMjEzNS1ERzJNUkI6L2hvbWUvZ3RhIyBjYXQgL3N5cy9idXMvcGNp
L2RldmljZXMvMDAwMFw6MDNcOjAwLjAvcG93ZXIvcnVudGltZV9zdGF0dXMNCnN1c3BlbmRlZA0K
cm9vdEBEVVQyMTM1LURHMk1SQjovaG9tZS9ndGEjIHNldHBjaSAtcyAwMzowMC4wIDB4ZDQubA0K
MDAwMDAwMDgNCihCaXRzIDAwOjAxIGFyZSB0aGUgcG93ZXIgc3RhdGUgaW4gUE1DU1Iob2Zmc2V0
ID0gNCkgY29uZmlnIHJlZ2lzdGVyIGZyb20gUE0gQ2FwIG9mZnNldCBhdCAweGQwKS4NCg0KVGhh
bmtzLA0KQW5zaHVtYW4gR3VwdGEuDQo+IA0KPiBCciwNCj4gQW5zaHVtYW4gR3VwdGENCj4gDQo+
IA0KPiA+Pg0KPiA+PiBUaGlzIHNlcXVlbmNlIGlzIGJsYWNrIG1hZ2ljIHRvIG1lIHNvIGNhbid0
IHJlYWxseSBjb21tZW50IG9uIHRoZSBzcGVjaWZpY3MuDQo+IEJ1dCBpbiBnZW5lcmFsLCB3aGF0
IEkgdGhpbmsgSSd2ZSBmaWd1cmVkIG91dCBpcywgdGhhdCB0aGUgUENJIGNvcmUgY2FsbHMgb3Vy
IHJ1bnRpbWUNCj4gcmVzdW1lIGNhbGxiYWNrIGJlZm9yZSBwcm9iZToNCj4gPj4NCj4gPj4gbG9j
YWxfcGNpX3Byb2JlOg0KPiA+PiAuLi4NCj4gPj4gICAgICAgICAgLyoNCj4gPj4gICAgICAgICAg
ICogVW5ib3VuZCBQQ0kgZGV2aWNlcyBhcmUgYWx3YXlzIHB1dCBpbiBEMCwgcmVnYXJkbGVzcyBv
Zg0KPiA+PiAgICAgICAgICAgKiBydW50aW1lIFBNIHN0YXR1cy4gIER1cmluZyBwcm9iZSwgdGhl
IGRldmljZSBpcyBzZXQgdG8NCj4gPj4gICAgICAgICAgICogYWN0aXZlIGFuZCB0aGUgdXNhZ2Ug
Y291bnQgaXMgaW5jcmVtZW50ZWQuICBJZiB0aGUgZHJpdmVyDQo+ID4+ICAgICAgICAgICAqIHN1
cHBvcnRzIHJ1bnRpbWUgUE0sIGl0IHNob3VsZCBjYWxsIHBtX3J1bnRpbWVfcHV0X25vaWRsZSgp
LA0KPiA+PiAgICAgICAgICAgKiBvciBhbnkgb3RoZXIgcnVudGltZSBQTSBoZWxwZXIgZnVuY3Rp
b24gZGVjcmVtZW50aW5nIHRoZSB1c2FnZQ0KPiA+PiAgICAgICAgICAgKiBjb3VudCwgaW4gaXRz
IHByb2JlIHJvdXRpbmUgYW5kIHBtX3J1bnRpbWVfZ2V0X25vcmVzdW1lKCkgaW4NCj4gPj4gICAg
ICAgICAgICogaXRzIHJlbW92ZSByb3V0aW5lLg0KPiA+PiAgICAgICAgICAgKi8NCj4gPj4gICAg
ICAgICAgcG1fcnVudGltZV9nZXRfc3luYyhkZXYpOw0KPiA+PiAgICAgICAgICBwY2lfZGV2LT5k
cml2ZXIgPSBwY2lfZHJ2Ow0KPiA+PiAgICAgICAgICByYyA9IHBjaV9kcnYtPnByb2JlKHBjaV9k
ZXYsIGRkaS0+aWQpOw0KPiA+PiAgICAgICAgICBpZiAoIXJjKQ0KPiA+PiAgICAgICAgICAgICAg
ICAgIHJldHVybiByYzsNCj4gPj4gICAgICAgICAgaWYgKHJjIDwgMCkgew0KPiA+PiAgICAgICAg
ICAgICAgICAgIHBjaV9kZXYtPmRyaXZlciA9IE5VTEw7DQo+ID4+ICAgICAgICAgICAgICAgICAg
cG1fcnVudGltZV9wdXRfc3luYyhkZXYpOw0KPiA+PiAgICAgICAgICAgICAgICAgIHJldHVybiBy
YzsNCj4gPj4gICAgICAgICAgfQ0KPiA+Pg0KPiA+DQo+ID4gWWVzLCBpbiBMaW51eCB0aGUgZGVm
YXVsdCBpcyBEMCBmb3IgYW55IHVubWFuYWdlZCBkZXZpY2UuIEJ1dCB0aGVuIHRoZQ0KPiA+IHVz
ZXIgY2FuIGdvIHRoZXJlIGluIHRoZSBzeXNmcyBhbmQgY2hhbmdlIHRoZSBwb3dlci9jb250cm9s
IHRvICdhdXRvJw0KPiA+IGFuZCBnZXQgdGhlIGRldmljZSB0byBEMy4NCj4gPg0KPiA+PiBBbmQg
aWYgcHJvYmUgZmFpbHMgaXQgY2FsbHMgcG1fcnVudGltZV9wdXRfc3luYyB3aGljaCBwcmVzdW1h
Ymx5IGRvZXMgbm90DQo+IHByb3ZpZGUgdGhlIHN5bW1ldHJ5IHdlIG5lZWQ/DQo+ID4NCj4gPiBU
aGUgbWFpbiBwcm9ibGVtIEkgc2VlIGlzIHRoYXQgd2hlbiB0aGUgcHJvYmUgZmFpbCBpbiBvdXIg
Y2FzZSB3ZQ0KPiA+IGRvbid0IHVucmVnaXN0ZXIgYW5kIGk5MTUgaXMgc3RpbGwgbGlzdGVkIGFz
IGNvbnRyb2xsaW5nIHRoYXQgZGV2aWNlDQo+ID4gYXMgd2UgY291bGQgc2VlIHdpdGggbHNwY2kg
LS1ubnYuDQo+ID4NCj4gPiBBbmQgYW55IGF0dGVtcHQgdG8gY2hhbmdlIHRoZSBjb250cm9sIHRv
ICdhdXRvJyBmYWlscy4gU28gd2UgYXJlDQo+ID4gZm9yZXZlciBzdHVjayBpbiBEMC4NCj4gPg0K
PiA+IFNvLCBJIHJlYWxseSBiZWxpZXZlIGl0IGlzIGJldHRlciB0byBicmluZyB0aGUgZGV2aWNl
IHRvIEQzIHRoZW4NCj4gPiBsZWF2aW5nIGl0IHRoZXJlIGJsb2NrZWQgaW4gRDAgZm9yZXZlci4N
Cj4gPg0KPiA+IE9yIGZvcmNpbmcgdXNlcnMgdG8gdXNlIGFub3RoZXIgcGFyYW1ldGVyIHRvIGVu
dGlyZWx5IGF2b2lkIGk5MTUgdG8NCj4gPiBnZXQgdGhpcyBkZXZpY2UgYXQgZmlyc3QgcGxhY2Uu
DQo+ID4NCj4gPj4NCj4gPj4gQW55d2F5IHNpbmNlIEkgY2FuJ3QgcHJvdmlkZSBtZWFuaW5nZnVs
IHJldmlldyBJJ2xsIGNvcHkgSW1yZSBzaW5jZSBJIHRoaW5rIGhlDQo+IHdvcmtlZCBpbiB0aGUg
YXJlYSBpbiB0aGUgcGFzdC4gSnVzdCBzbyBtb3JlIGV5ZXMgaXMgYmV0dGVyLg0KPiA+Pg0KPiA+
PiBSZWdhcmRzLA0KPiA+Pg0KPiA+PiBUdnJ0a28NCj4gPj4NCj4gPj4NCj4gPj4+ICsNCj4gPj4+
ICAgIAkJcmV0dXJuIC1FTk9ERVY7DQo+ID4+PiAgICAJfQ0K
