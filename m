Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764E359B542
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 17:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiHUPys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Aug 2022 11:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbiHUPyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Aug 2022 11:54:44 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AC42615
        for <stable@vger.kernel.org>; Sun, 21 Aug 2022 08:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1661097283; x=1692633283;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/O4P9vzvqOitmbUS2L7AoQO+Cic7NKsF9Kl86+ZFgns=;
  b=Tgk9WM5jb5mwbvwPh4BxJo47QJ96jvXdRzpgaC/tHeNW8y/mQgVprdN/
   wx6Tk3q80Ji2iJNlBKBUMZl/p79PWVUuiLyQnD1+Tf+DKn+dgh+Jv8GG5
   Viicf44TVpPaLNftD3HL+oINOgUdVzLKt4sy5c6V04jL7ULkaWlFoeaH/
   1V/T9sH5DV0Eek4Y/PTDj0KmSlJu2Mm0DrGK6G063cqkYu3uv0g7lGgP1
   JERIuNTtC4hc9ib1/8Cey0kYHvwAkIOIYIAUVZ3XE0nd3A5jgpk6RzSX3
   E8Wwuqm/2tvXgQshoiPQMz2mcQ9gLBQGijE7jiz/Kw3zmP5dNIBV13NaQ
   w==;
X-IronPort-AV: E=Sophos;i="5.93,253,1654585200"; 
   d="scan'208";a="110000357"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Aug 2022 08:54:38 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 21 Aug 2022 08:54:37 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Sun, 21 Aug 2022 08:54:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fULz7sPC4UUw6Y3keeRcBeEyhNQtLkN801XNzdWrLMRXQ5xWR7JnJ19UfsM37Q7dRAU5TtAdnxuxjSuEM2QbHODASUthSvTgxhMKaSM55wEueJhiQGAkYjut+mGbbYYzpFN99Aw3bsMPwR+Vg0UKSvTJIR029z7fvJjdmxCqSQ6g4ICgo0Qj2LsrHD2cXjoCTukMI3tX3eism7bQSDwuWeOlxNjd87qZ/OyOEEMIfk2qF6eUW26R9w0KsmHq2WBDyd9GBSKqyQ6P7SIhLB1DpV8yl+gbBXzWcTXdAVRgqDqYY2lHzMvF77fBSPlfPfxbAbarCfLRVcsMmxIwnXKlrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/O4P9vzvqOitmbUS2L7AoQO+Cic7NKsF9Kl86+ZFgns=;
 b=lt9Q6f9u9dviVibDSLi/YTeobAZDQclRHHs1BPokPLA++JIHnp2PxoQgnWITRDbVo4WzjeExoj5M45HJWCniTHtDdhg2iMm7ITTkii5VrHafviovYUKiXu4KhRJrnMhUtsL3CwudbaB1D6L839RP3ZBR6dmX/6V/z0Qzu01jdc7rqpj6FkAqyTU8upi/iYSWE6lO2VqeKUj/WTBgXkZjbcoqqXY3Pp182lWp5bJgVLx/k0ZEx5vu5sHsXdzM3f6PuHkAt6hcS1WZjArUJwYPXnowDSTX4PmNe8V4n6dBj4eg4kYQ7CBJHYdDF0W1Bt0OcFU1CBDX7xA6miBYIr6LzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/O4P9vzvqOitmbUS2L7AoQO+Cic7NKsF9Kl86+ZFgns=;
 b=NBtqcru8Lu8spCR6cEziCzlxtKzRey8BGg+2j2g2w7/3pzf/WHWYWoWejhE44Xrfl53Z3Se79Rut3IByaghT+Gx5GgHU0b9/rJFge/fs44AWLCik+vxkxpBpPr1iEOpkVGpF7GCf18bSRriG189MLtcxcsiD/y6CTo6lTUukt9M=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by MWHPR1101MB2333.namprd11.prod.outlook.com (2603:10b6:300:70::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Sun, 21 Aug
 2022 15:54:35 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::ac89:75cd:26e0:51c3]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::ac89:75cd:26e0:51c3%9]) with mapi id 15.20.5546.021; Sun, 21 Aug 2022
 15:54:34 +0000
From:   <Conor.Dooley@microchip.com>
To:     <gregkh@linuxfoundation.org>, <ajones@ventanamicro.com>,
        <apatel@ventanamicro.com>, <atishp@rivosinc.com>,
        <palmer@rivosinc.com>, <re@w6rz.net>
CC:     <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] riscv: Ensure isa-ext static keys are
 writable" failed to apply to 5.19-stable tree
Thread-Topic: FAILED: patch "[PATCH] riscv: Ensure isa-ext static keys are
 writable" failed to apply to 5.19-stable tree
Thread-Index: AQHYtWQC6/lrKS7FX0+goL2q8MXPda25gdUA
Date:   Sun, 21 Aug 2022 15:54:34 +0000
Message-ID: <edafce2a-a42e-9c85-115e-4dffd4b70466@microchip.com>
References: <166108940135238@kroah.com>
In-Reply-To: <166108940135238@kroah.com>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8471e357-c062-4800-1cb3-08da838d71be
x-ms-traffictypediagnostic: MWHPR1101MB2333:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 46RV3anC47iZRQiZIZRnhfaX8DQnaFaFgsxETZj70ReU1Q8f0zGixgVnywin8Nc4Qd7lt6phJXT9YJg/Z4nCkQrUw3dXVdq38hTLfq/buA4vIPQWwwAP+2T0RRHUTUC7qPVtoCYVsqePkHHtzw34C3G0ylAmItQxiteChgbfegg7YNTElxzWWFwkWjaKv5vDA3U1pFcQKYyYjFP59f666aWZ4NfIPmGw8nJphHZ9R9wzd4R7uyrrlZdJXF5z+BUwdAoArNz9ZfjRwsiuZYUdGNYF+jdqZ6yp21DMDMlvjA4Ipm+OD4XEg51/GtMT67zy4eHvViZ8dVEROdJD7jRUNqmG8zTZonBe6wCsWixmZ82CZW2HIVICl7hudSp9C7go8o/vFN8di52iy0KamkQNKCr5BlW7OnqzHa6HNZmy5sdQeTgO713l5HHa+jR0ACQU0iQUoZHHsAQOi4La4J8IySaaaJlNQS+4mgeLbIearq40E2T1cec6K0TBaFWkx0LTp/5SYbzxPa9n1ZFbJuDJMCA6yoX26i2hBgFnqZYFLGzq6xLtTcbGlMiH1XvvxfENT+UOfDS+c3jGZlKAd++cc3F5f83scxzdvXxrl3V9Nrw74zAqsGnXIMf0Qy6qfDj71vFhktOhWzCBt/DD+LNoowXTQHvL0dy2psX+cjLT4Jruv9xmQ+KmtiOfyulAGH0vW0tKPLl77S2rC6+zexy/fp92lRJ4pxm2v4RSU8e1PN4pcXQVm/+z84G4JOp2OWzPk9AjLhBK+lUSXbLsALeHATyF3stGpRruumNVxPYe2IR3V/uIfb8lSjtGvxYkgpwsczXKDeTHq/n95ZAxVoMti+KhMUzPmjWsW8seQ6PMXAHAktTuSIXa49vpVEQn4HZZOLmsM5vBcGQkUJ2MGrh8Qg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(396003)(136003)(366004)(376002)(346002)(316002)(2616005)(186003)(966005)(6486002)(110136005)(31686004)(36756003)(31696002)(86362001)(2906002)(5660300002)(8936002)(66946007)(64756008)(66446008)(66476007)(4326008)(8676002)(66556008)(91956017)(122000001)(38070700005)(26005)(6512007)(6506007)(478600001)(41300700001)(71200400001)(38100700002)(76116006)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlgyVStweWVIcjdBTWFSSDFEbkZEMW1TRWQwZ3pMU3lOU1NPSVN1NE1lK2lo?=
 =?utf-8?B?U0JVaWtwWm9LRlFFRTk0Z0JFaEFxdHFkbkNFYy9TMGtibmx4a0NOaU1mZ2NS?=
 =?utf-8?B?c2E1dE82SXkwR2x0SHNvaHBSQ2xkZU4vMlErUlhkRklrQy9XZ0ZvemRzK3Y0?=
 =?utf-8?B?MEJlL1NCb1oySDVxYnlRcEtiYWx1ZU1VR2w1OW5GN3ZiSWlGYXhBQ1VaeXcx?=
 =?utf-8?B?ZHhzZ2FoZUxpQmV1MkNrUnR0OGIvSEFDSHpBcHZZNVMvT1RaRGZMMDhRWXd1?=
 =?utf-8?B?NnZDYnhmMjBsMDNjVWhueWQ5c0s0VEgvR01RZGZTbTJiYWxVVlZDQ3FvenNw?=
 =?utf-8?B?RWZpTStuTlQzbzVQYm5GRUNhZWU5OHRPeGhKL0lCR1ptbU41WHFUamh1T1Vw?=
 =?utf-8?B?RnJBdzFLcHJLYk1pY1IyWU1WQlZVUWR4QUV5cHRYWVFtZmpIb1d4MDJzT3l5?=
 =?utf-8?B?Wmk4ZnJScmUwNzZtei82N24za2IxUDE1bDJLZEZ5clNlWWF3WmwrNUZneWtL?=
 =?utf-8?B?UW14akhZMWxCLy9TNCt0V2gzMUFUNXZrVTRtd0Q5OG41OU5XYy9tSmZqZ0Fk?=
 =?utf-8?B?N3hUS0kzRlBTL3Rjb1lITGpuNWZ3NlNDVS9aSVFtMUFNK2dlcVNoQ09SNm9k?=
 =?utf-8?B?TmQwbSs1dVFRNThEMExnRVJFN0pkaXlFNG9NbzF0RVNMcVB6R09FSldJWnVi?=
 =?utf-8?B?cUdHdTJBZ1dIYkRlb1FnbWV2cnNwYWttWm15T2lLY1ZyRVp5c2RDWHNxWjJO?=
 =?utf-8?B?R2h3SzgzOGlubDhWY08wY0N2T0VnTWdwWUNCQnRwR0NkYndLL0dIL2tvQ0lG?=
 =?utf-8?B?RkVKQ2lrSE45UURlNStzUFhSRVNHS1RoQ1h0b2ZsOGFNV0Q0ckNEam96UlYx?=
 =?utf-8?B?OUErZ0FQZnBiVGh3SjB1cUhNUVZueHZpZkhyczkxYmNremxBcUgrbkJ3T3lp?=
 =?utf-8?B?VythTWo3TUc1Q2pjcy91eU5YY2VHQUIza3RUVU5ZMlVEOU1ZQXRGV3ZHOWJ2?=
 =?utf-8?B?NHU4NzNHNmZheVRqdGJ0MXdUWUplL0ROL1ErREZFSmY4VUxYcXRmU1dvcHF2?=
 =?utf-8?B?RDF0S0Y1Q0t0bTJ2L1NzOE16K0lheVRveDZyZ0g5a1Y0NGwxR1ZIK2MydnF1?=
 =?utf-8?B?L0xVZml6aTh1Y3RNMWZTYWhvQXpJMnFDZGV3NmdQNkc2VHVoTExUSTY4YW1j?=
 =?utf-8?B?SE1lMnVQYnZVT2w5SDBnQjltY3orZ3IwanQ0ZlcrTGRmMlh5Z2I5M1RJZmdB?=
 =?utf-8?B?SDR0dzBlT0trNVROM0NRaHFNZ0N6VkRhcWE0Z295OEFObjBOc1NQTW9DZEs5?=
 =?utf-8?B?Q2pxbGIyUFdJWEY0eUlON0Uwa2xvdkpwRFgxcmtvZ25QWVlhT0YxdjRCbjAx?=
 =?utf-8?B?TDQydVVoQVM0VUtOTVFPUFpUMjRxUWhtb0xJOEZrbGJEcEVaeGQyenpWd2hN?=
 =?utf-8?B?clpIdjdUbmZtVDFUMUsxcmxsbUI1d092YWczUWQzNTFycTdocnkwWmxIcDR1?=
 =?utf-8?B?RlYrbzZzU3krQVBVMWVZL2lXUjNLOUtHdlJzN1lrZHZ1cGtkV1haN25vaHdK?=
 =?utf-8?B?c1RodDUrTWdRcG1ONnB6SUFkMll2KzZ2OGhJZ0VRNjZkVVBFN3BIZU5NQmV6?=
 =?utf-8?B?a2xsaE1UYUhwSXpyUk51T2NndlNOMXZTdnZ2eFlzbzVDWm1yV1g0aVE4amVx?=
 =?utf-8?B?QXdsWUpkOVprVEZoaUFTa0JBb21sNWNZUFVIOTVIeWF0emIreUY0eklZRTFM?=
 =?utf-8?B?Z3lhdzhhT29KdjlrTTZKOUZTYUlzZm92OHcxSVhKNkVabGNHYUlKQkJLaE1I?=
 =?utf-8?B?a0VNc2ZzR25CRjV6NW5VNDMrUGdUanBWZnJDZHFMNkVRa21IWHpONUR1UEpS?=
 =?utf-8?B?VnBEOHJHSUFuYlRQcUhBYWNERUZsaXpwOWo1U3lpYVJoenFHTW5qbWZmWU13?=
 =?utf-8?B?VzJvQU1tVWlDY0VXZ1VBMGpEbDBxSHloOUwzL3JzNDY5MFNBZ0lnNU5mZ3lG?=
 =?utf-8?B?Z1pSUjVKUmJZeXNzVTJPWHFUUFRIL3l1UFM3QWUrZDJ3cXQyTElmNFhncFFv?=
 =?utf-8?B?WHFCNVIwN2JUMWFQbmw3UHpGTzFZZ05MVDY1M1hzWGN6U0hHS3hkN3IwWDBs?=
 =?utf-8?Q?nkfUUz9TdxCuVr9xQhkAC196A?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <39C3110B1C3BF743ACC656B62334CDAD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8471e357-c062-4800-1cb3-08da838d71be
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2022 15:54:34.8101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kgq/oaU/SiPmvwY7m0lQrQvyfMstt+CVgOeR8z8a4oTnQwOgX7D5ckEy/kwz7KzCra9/PwIAUyg4smXNwieO+JddZHJJNg5bT7KKAnTH3rE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2333
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGV5IEdyZWcsDQpPbiAyMS8wOC8yMDIyIDE0OjQzLCBncmVna2hAbGludXhmb3VuZGF0aW9uLm9y
ZyB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0
dGFjaG1lbnRzIHVubGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBUaGUg
cGF0Y2ggYmVsb3cgZG9lcyBub3QgYXBwbHkgdG8gdGhlIDUuMTktc3RhYmxlIHRyZWUuDQo+IElm
IHNvbWVvbmUgd2FudHMgaXQgYXBwbGllZCB0aGVyZSwgb3IgdG8gYW55IG90aGVyIHN0YWJsZSBv
ciBsb25ndGVybQ0KPiB0cmVlLCB0aGVuIHBsZWFzZSBlbWFpbCB0aGUgYmFja3BvcnQsIGluY2x1
ZGluZyB0aGUgb3JpZ2luYWwgZ2l0IGNvbW1pdA0KPiBpZCB0byA8c3RhYmxlQHZnZXIua2VybmVs
Lm9yZz4uDQoNCkkgZG9uJ3QgdGhpbmsgdGhpcyBuZWVkcyBiYWNrcG9ydGluZy4gVGhlIG9yaWdp
bmFsL2ZpeGVkIGNvbW1pdCBvbmx5DQpzaG93ZWQgdXAgaW4gUGFsbWVyJ3MgZmlyc3QgIjUuMjAi
IFBSICYgaXMgYSBmZWF0dXJlIGFkZGl0aW9uOg0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGlu
dXgtcmlzY3YvbWhuZy0xY2JiYTYzNy02ZGQyLTQ1NmEtODU5Yi05ZDNmOGJlNmJhYjdAcGFsbWVy
LW1icDIwMTQvDQpUaGFua3MsDQpDb25vci4NCg0KPiANCj4gdGhhbmtzLA0KPiANCj4gZ3JlZyBr
LWgNCj4gDQo+IC0tLS0tLS0tLS0tLS0tLS0tLSBvcmlnaW5hbCBjb21taXQgaW4gTGludXMncyB0
cmVlIC0tLS0tLS0tLS0tLS0tLS0tLQ0KPiANCj4gRnJvbSBlYjYzNTRlMTE2MzA1YWZiZmRlMTk2
YmU1MTIwYmZhODY2OWZkYzZhIE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQ0KPiBGcm9tOiBBbmRy
ZXcgSm9uZXMgPGFqb25lc0B2ZW50YW5hbWljcm8uY29tPg0KPiBEYXRlOiBUdWUsIDE2IEF1ZyAy
MDIyIDE4OjMwOjU4ICswMjAwDQo+IFN1YmplY3Q6IFtQQVRDSF0gcmlzY3Y6IEVuc3VyZSBpc2Et
ZXh0IHN0YXRpYyBrZXlzIGFyZSB3cml0YWJsZQ0KPiANCj4gcmlzY3ZfaXNhX2V4dF9rZXlzW10g
aXMgYW4gYXJyYXkgb2Ygc3RhdGljIGtleXMgdXNlZCBpbiB0aGUgdW5pZmllZA0KPiBJU0EgZXh0
ZW5zaW9uIGZyYW1ld29yay4gVGhlIGtleXMgYWRkZWQgdG8gdGhpcyBhcnJheSBtYXkgYmUgdXNl
ZA0KPiBhbnl3aGVyZSwgaW5jbHVkaW5nIGluIG1vZHVsZXMuIEVuc3VyZSB0aGUga2V5cyByZW1h
aW4gd3JpdGFibGUgYnkNCj4gcGxhY2luZyB0aGVtIGluIHRoZSBkYXRhIHNlY3Rpb24uDQo+IA0K
PiBUaGUgbmVlZCB0byBjaGFuZ2UgcmlzY3ZfaXNhX2V4dF9rZXlzW10ncyBzZWN0aW9uIHdhcyBm
b3VuZCB3aGVuIHRoZQ0KPiBrdm0gbW9kdWxlIHN0YXJ0ZWQgZmFpbGluZyB0byBsb2FkLiBDb21t
aXQgOGViMDYwZTEwMTg1ICgiYXJjaC9yaXNjdjoNCj4gYWRkIFppaGludHBhdXNlIHN1cHBvcnQi
KSBhZGRzIGEgc3RhdGljIGJyYW5jaCBjaGVjayBmb3IgYSBuZXdseQ0KPiBhZGRlZCBpc2EtZXh0
IGtleSB0byBjcHVfcmVsYXgoKSwgd2hpY2gga3ZtIHVzZXMuDQo+IA0KPiBGaXhlczogYzM2MGNi
ZWMzNTExICgicmlzY3Y6IGludHJvZHVjZSB1bmlmaWVkIHN0YXRpYyBrZXkgbWVjaGFuaXNtIGZv
ciBJU0EgZXh0ZW5zaW9ucyIpDQo+IFNpZ25lZC1vZmYtYnk6IEFuZHJldyBKb25lcyA8YWpvbmVz
QHZlbnRhbmFtaWNyby5jb20+DQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFJlcG9y
dGVkLWJ5OiBSb24gRWNvbm9tb3MgPHJlQHc2cnoubmV0Pg0KPiBSZXBvcnRlZC1ieTogQW51cCBQ
YXRlbCA8YXBhdGVsQHZlbnRhbmFtaWNyby5jb20+DQo+IFJlcG9ydGVkLWJ5OiBDb25vciBEb29s
ZXkgPGNvbm9yLmRvb2xleUBtaWNyb2NoaXAuY29tPg0KPiBUZXN0ZWQtYnk6IEF0aXNoIFBhdHJh
IDxhdGlzaHBAcml2b3NpbmMuY29tPg0KPiBMaW5rOiBodHRwczovL2xvcmUua2VybmVsLm9yZy9y
LzIwMjIwODE2MTYzMDU4LjMwMDQ1MzYtMS1ham9uZXNAdmVudGFuYW1pY3JvLmNvbQ0KPiBTaWdu
ZWQtb2ZmLWJ5OiBQYWxtZXIgRGFiYmVsdCA8cGFsbWVyQHJpdm9zaW5jLmNvbT4NCj4gDQo+IGRp
ZmYgLS1naXQgYS9hcmNoL3Jpc2N2L2tlcm5lbC9jcHVmZWF0dXJlLmMgYi9hcmNoL3Jpc2N2L2tl
cm5lbC9jcHVmZWF0dXJlLmMNCj4gaW5kZXggNTUzZDc1NTQ4M2VkLi4zYjU1ODNkYjlkODAgMTAw
NjQ0DQo+IC0tLSBhL2FyY2gvcmlzY3Yva2VybmVsL2NwdWZlYXR1cmUuYw0KPiArKysgYi9hcmNo
L3Jpc2N2L2tlcm5lbC9jcHVmZWF0dXJlLmMNCj4gQEAgLTI4LDcgKzI4LDcgQEAgdW5zaWduZWQg
bG9uZyBlbGZfaHdjYXAgX19yZWFkX21vc3RseTsNCj4gIC8qIEhvc3QgSVNBIGJpdG1hcCAqLw0K
PiAgc3RhdGljIERFQ0xBUkVfQklUTUFQKHJpc2N2X2lzYSwgUklTQ1ZfSVNBX0VYVF9NQVgpIF9f
cmVhZF9tb3N0bHk7DQo+IA0KPiAtX19yb19hZnRlcl9pbml0IERFRklORV9TVEFUSUNfS0VZX0FS
UkFZX0ZBTFNFKHJpc2N2X2lzYV9leHRfa2V5cywgUklTQ1ZfSVNBX0VYVF9LRVlfTUFYKTsNCj4g
K0RFRklORV9TVEFUSUNfS0VZX0FSUkFZX0ZBTFNFKHJpc2N2X2lzYV9leHRfa2V5cywgUklTQ1Zf
SVNBX0VYVF9LRVlfTUFYKTsNCj4gIEVYUE9SVF9TWU1CT0wocmlzY3ZfaXNhX2V4dF9rZXlzKTsN
Cj4gDQo+ICAvKioNCj4gDQoNCg==
