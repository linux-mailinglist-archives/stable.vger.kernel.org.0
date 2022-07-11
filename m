Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B734A5704E5
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 16:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiGKOB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 10:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiGKOB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 10:01:57 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2058.outbound.protection.outlook.com [40.107.94.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37050627E;
        Mon, 11 Jul 2022 07:01:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IPcByFXCRaqGBFz6rcyD5Va8tD3H4Zl9dBoSGVII4Det1x0Dq3ESwII7NE26USRC6APNq5rqN2bIt9gMIuIEeIMxn2EJz4/0Bnb0CLS7HAGvqVRNyllo5TC4yMMkt9ElGABK3j9BrBv+u7/L8nFuVgxfzQYCrZJJUr5yPqaUWHnRNu2Otac7ifn/vfPXtbTH7wbkJ+Hzn87kVGawRYC69Xdt3eBlTHnycAkYEx0x0nZpwK9xkb3WGRY+A9f6rUSH0toxYrJUjw0m7P9yCVZ+fqeijP5QIkCXYKUV2bD6MxvvInT+7bCvXaZ3Yklb7PkIhp+nqXWzSUC3QjH9xFzykg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DmB5TGfoHIipthTG4/2m2Pa9JKDU4K2C0hhCq+cmx+k=;
 b=najy1R9jsmxgtLG/cT1UjT4OTS327Q6YH48JBMn0FqpoUoIT/yuk0t5ydojGCFIKfXlkTGrpPD9E27ImB6+VAt7vafRbWJHb75HiD0oVV0YNBSaqONS5D1qhT4VoPLdwEOWTSJDWhMbilFWHQwjXmaUndk8IboemYHOoTO1lFTtOWjItXepLaizeZ1zMUCf31Pnjdy9C2HTWGWgSja4RVkAl16wO14TYd4MtP5jc495KYsY0u48VWUjZNprG3EXOVvyOzoulKemp+XbRlJFFsMTNlcCALTQUIkx42AGxlrUfiSuJ3oIBNYmlnjkqO30rdd/5vrtrDlN+99BvDtzgJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DmB5TGfoHIipthTG4/2m2Pa9JKDU4K2C0hhCq+cmx+k=;
 b=Z51bRleomtCfaFwOG4qfQ6RSqFA5QZjYa90WwzPS9yQ3aDqyTaaFchiTkslqmXt5RsdgUnNhOWjGb8S61gFvtSsixe8ymuDYKtQvY3hiL+bJVnbfHbOGscMBd4yeEP2XsViLBbZaz3nIUPdQsZTJgMdQvbVev0HZzG2pb7bjuIo=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by BY5PR12MB3777.namprd12.prod.outlook.com (2603:10b6:a03:1a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.25; Mon, 11 Jul
 2022 14:01:50 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::589b:a1f6:9c87:a8ba]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::589b:a1f6:9c87:a8ba%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 14:01:50 +0000
From:   "Deucher, Alexander" <Alexander.Deucher@amd.com>
To:     "Koenig, Christian" <Christian.Koenig@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 5.15 138/230] drm/amdgpu: bind to any 0x1002 PCI diplay
 class device
Thread-Topic: [PATCH 5.15 138/230] drm/amdgpu: bind to any 0x1002 PCI diplay
 class device
Thread-Index: AQHYlQhuifN6TX9jWUePaopElcAkBa1453yAgABLu7A=
Date:   Mon, 11 Jul 2022 14:01:50 +0000
Message-ID: <BL1PR12MB514417DBBDC4502936002F8BF7879@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20220711090604.055883544@linuxfoundation.org>
 <20220711090607.978575207@linuxfoundation.org>
 <8c73c2b5-f70e-f343-7ca4-e1db420d5419@amd.com>
In-Reply-To: <8c73c2b5-f70e-f343-7ca4-e1db420d5419@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-07-11T14:01:10Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=4bcaf85f-3019-4131-a60e-87f610f75c7d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-07-11T14:01:48Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: fee56004-1103-4d1a-a8e6-193520f08d29
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62759288-8442-4296-4414-08da6345e6c9
x-ms-traffictypediagnostic: BY5PR12MB3777:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DypVKtOn/z7Ln8xwyOY6nukxVwdmBhTMO53sB1uOjKOKKHkRLzdPyegi9p2mcACZ8Pl5geAj8Ch+PyYHOh6XU2+eY7Yizqh93eCPI6OeygTq91FF4GtPue21MEtcssAEaPeusdhrHg/zGzIo8Kns4qC8eDXupLE8pMBZ/XMgqE+KHujPtLm4QH9o9eJnp+xQORtlqn5w+9JGP+3/IJoAgRoVhvxYnXBOy6tUkBUyBm+CiYL55Uj5Zyuk2UnuIBCt30KpZ0tMYGxXQ2ZTKLK+fx/aZQmRF97Hq+47jt3gnKU+ngNz4pR7P68sc05ppr5P+R7TbIv1YphrKRi7bwRYRjQZE1HIS78tDMICNCAsQnRZKni1NpoZO7jjggBiCNh9e4BX4lRLQ+rSDcU3MN64yj5kV6VKDwngvn/MjeZC8obz+3HFYXKaS6JvCvOkYHbr2nVCK79h+/YcNEUBqjzOIRT+qAC/khKP+WI5p7rFz2v64BVjz5Wz9tTxTY7mIei5sw3HmYQR+BiToSBZYk5bRENpe6irjAC8EE6jJ14UDTOsXYW9izeVqX2kmnS/kNpcoHwyeuueZTSbXy5Clu0yh+v8Vq4u+pIov9djb6+WErImU02BoTk4P5N2Q9ATN6vNKmBZiBUfk3gTjK21qW+Qlq2eK7AAseSEvy9I2/DbZ61uLYcDYkPHlQYoAP1nnwRU3JPkHASi7sEcAfQIQV2K1VVcQS+jlSilQXKpqAUAepXcEmlFLB6fSFvsiBqsl8ltf+B5h3QXnqjH/3x6AnhF2lWAVBRmruz+ei75lMLI+rKaeZWwKacihghW7CoqpaoQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(8936002)(52536014)(71200400001)(110136005)(54906003)(55016003)(316002)(33656002)(38100700002)(5660300002)(122000001)(83380400001)(478600001)(26005)(2906002)(66476007)(66556008)(9686003)(53546011)(38070700005)(66946007)(6506007)(186003)(76116006)(41300700001)(86362001)(66446008)(8676002)(7696005)(64756008)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TnMwSzlvSVp5MU9rTWtYMG5EUkVreE5TNHZ5c2llSmlhem85REQ1dHMxb2ZX?=
 =?utf-8?B?djVHMmp3dWJvUVlvQ0JKZEVBL2wvN0NpdytWNGF2WWc1U0NoTTMycDlnOHBI?=
 =?utf-8?B?akx4NlV3YVhEOGRsWkxlYUpOS0ZpRG1mWGorUHByc0xVNTJpNWhXbGw1Sk4r?=
 =?utf-8?B?YmtPTG5vRGxzZksvWTZDZ29SSmtzWXorRFBwdzU5SkNlTkx3Q3hnUVd4QnI4?=
 =?utf-8?B?Zk5qcHg4M0ZVdVNtS2Fpb0phVFcwS3FNSnNCNWlJRjlBajlKMTV0Yy90Z3JC?=
 =?utf-8?B?MndtdTc5ZWtMdE1IZ2pFZFg4K0hFQ1BDN3FnbU1maTd3c3pXaWhXNEE3V0Z6?=
 =?utf-8?B?cTNxSlNKVkNoZXZsU3pORnpWTHJXeTY4MFowcDdVZFJ1ZTNZZDNPMXJnSVBL?=
 =?utf-8?B?bU8vcDYvTEsxeGY0VldjWVh6WFg0eW4rOTdwYUlaSDRoVE5vQ1RqMlNRdGgw?=
 =?utf-8?B?WGRraEN4MjZrbldNbDJuTmZMRXBvdmxqSzhwTHlBNHQ1bEplTU9VS3QxbmNi?=
 =?utf-8?B?T3I3Mzc1cjdWSGQ3RTB2YXBUZXRvVitrN0lldGJMNHZlZ1pnZDNZU1E4ckxl?=
 =?utf-8?B?cWJ6aHlaTVE4WXp2eXh1YWxZeWhFL3l2cjdqc2k0ZkFYdVI5aG56Sjh3bUNW?=
 =?utf-8?B?R0V3SDdsUE55eUZ1aSsyRk14UUJ6Rm40eWpuMW1Fb1d1RSs2RUY1bDNMZ2xu?=
 =?utf-8?B?YTU3cWhET0Z0R1dHNDJBKzFGZ1A5OEFaUUtqbEhLSGROQlFiQllqcWxYOUF2?=
 =?utf-8?B?UWtINUV6TTVwcm1QeXVSZ2p2Vll4WUhVaWdUU2tKOWZib2JNYytXYVFzelR2?=
 =?utf-8?B?R2xiVXphQlF4bWNMcXVRQmtuUWFyVkRZbThVcWV3NXhkWHpmNloydEVTZjRT?=
 =?utf-8?B?VG5KSndqM0VOTDhEV3NOZFhHS2pJRHMzbnUwdkhRMUJoVmtBSENzQVRNaGhO?=
 =?utf-8?B?OTFRQi95ejA1QXhuR3JzUEhYUS9XZDl5eE0xYithanBQeExzODVBQVVzbkVC?=
 =?utf-8?B?VDU0TytDcVZTYWNxVXRoNTMwZWh3SE9GRm95YTlkRFJsQjhkMGJ2RDFBTFg5?=
 =?utf-8?B?WE5hQi9uWWNpdXFNemJldE93aHhva0VHTGZweVdmWWV2dExUS1hFVVA0d1Vt?=
 =?utf-8?B?em92eVIzMkROZEtySFA5NW5KaVhTdmZJblFoQnBySDMxZTVlZjV0LzlqMld4?=
 =?utf-8?B?OEVvblJYeUFXV3RSeUY2WXh2ai9pdGxqWkZZMS9TSXJXL2N5NE9uckF4WmY0?=
 =?utf-8?B?Y2ZwT0pQWGd5U2lLNWxlNnRxNDlqdURGWjE3S2FUVVRYMDVIWE5CRzBVT0Fy?=
 =?utf-8?B?NThra2gwZHplYnJkb3AyWk9FS1llNG5DQ1FTS1NyRGIvcEhDSnlORThYdE1l?=
 =?utf-8?B?T3hXM3dYOTN4T3FKblN1eXl1N0k1SnZiYnFVWmR4eCtNdnpYRzlWKzVrYlVF?=
 =?utf-8?B?TUhlSEtUZGdPWEZVajhaK3JOVlg0a2xEOVN3MlI3aWt0NWs0L1RFZG5Yc01x?=
 =?utf-8?B?SkVuYVVIRG9hN3hQZmdwTkM1NlNHeHhDN2NLbEtBT3VTVVlLTE5YMFFjaGE4?=
 =?utf-8?B?ZEJ5TFdTUnNReExsay9ZTW5oRE1JeEYwaG1EdmZVYnVGNFZUdGlZTERwbXIx?=
 =?utf-8?B?Smg0NlZwZjhaRkRnbUg5NTZZUms2dENiNi9TZ1R4YjE3UWtnbWpuaWFUcXdq?=
 =?utf-8?B?MURPWHdoWnJmLzNlVFVNeUpnZDFiRVkxbTlvT0hpelZ0NGdvWHhpSlBGYWxw?=
 =?utf-8?B?L1RZV3l5eWZicktrajc5czd0VVNwY00rcEFnOWlvdnJtcktneGYvdGdaWUhE?=
 =?utf-8?B?dFZmQjZpbi9MeHNVc3NJVjBEcDNxWGJUTVBic1p0ckVxdmhTSVZyMWlXYW1R?=
 =?utf-8?B?Z3NyV0F6ZVZQejdjMTZyK1pUdFRSeXpDYWNpZjEvL1I3Z0JhSFNKbWpQbDNo?=
 =?utf-8?B?UXVqYmxsY2MveEF3UGpkZFZXb0UxOEJaUFgzdkxWVDZFSko2SmJkZ05qbHRk?=
 =?utf-8?B?ZlB1WUd6V0JRMGs2bUhFWnRibjJMRkxPTjIxRk1SVW1RVFdHUHRBclRIelNu?=
 =?utf-8?B?VklnVi9yTUY2L01oemx6NkEvWkFMYVAyaG9XaVlKTzVOd1V1b1Y0Zk9SQlpJ?=
 =?utf-8?Q?IInc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62759288-8442-4296-4414-08da6345e6c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 14:01:50.2033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4ukdzuCnUr8o9U33URr4U21ZLhQkKug0upxWr4HSH74emNjjV3djrXJ/ukLxyDQPQsehxGSkRAJ2+ETzg706Jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3777
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBLb2VuaWcs
IENocmlzdGlhbiA8Q2hyaXN0aWFuLktvZW5pZ0BhbWQuY29tPg0KPiBTZW50OiBNb25kYXksIEp1
bHkgMTEsIDIwMjIgNTozMCBBTQ0KPiBUbzogR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVna2hAbGlu
dXhmb3VuZGF0aW9uLm9yZz47IERldWNoZXIsDQo+IEFsZXhhbmRlciA8QWxleGFuZGVyLkRldWNo
ZXJAYW1kLmNvbT47IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IHN0YWJsZUB2
Z2VyLmtlcm5lbC5vcmc7IFNhc2hhIExldmluIDxzYXNoYWxAa2VybmVsLm9yZz4NCj4gU3ViamVj
dDogUmU6IFtQQVRDSCA1LjE1IDEzOC8yMzBdIGRybS9hbWRncHU6IGJpbmQgdG8gYW55IDB4MTAw
MiBQQ0kNCj4gZGlwbGF5IGNsYXNzIGRldmljZQ0KPiANCj4gSGkgR3JlZyAmIEFsZXgNCj4gDQo+
IHdoeSBpcyB0aGF0IHBhdGNoIHBpY2tlZCB1cCBmb3Igc3RhYmxlPyBPciBhcmUgd2UgYmFja3Bv
cnRpbmcgSVAgYmFzZWQNCj4gZGlzY292ZXJ5Pw0KPiANCg0KTG9va3MgbGlrZSBTYXNoYSBwaWNr
ZWQgaXQgdXAuICBUaGlzIHNob3VsZCBub3QgZ28gdG8gc3RhYmxlLg0KDQpBbGV4DQoNCj4gSWYg
eWVzLCBpcyB0aGF0IHdpc2U/IElJUkMgd2UgaGFkIHF1aXRlIGEgbnVtYmVyIG9mIHR5cG9zIGV0
Yy4uIGluIHRoZSBpbml0aWFsDQo+IHBhdGNoZXMuDQo+IA0KPiBSZWdhcmRzLA0KPiBDaHJpc3Rp
YW4uDQo+IA0KPiBBbSAxMS4wNy4yMiB1bSAxMTowNiBzY2hyaWViIEdyZWcgS3JvYWgtSGFydG1h
bjoNCj4gPiBGcm9tOiBBbGV4IERldWNoZXIgPGFsZXhhbmRlci5kZXVjaGVyQGFtZC5jb20+DQo+
ID4NCj4gPiBbIFVwc3RyZWFtIGNvbW1pdCBlYjRmZDI5YWZkNGFhMWM5OGQ4ODI4MDBjZWVlZTdk
MWY1MjYyODAzIF0NCj4gPg0KPiA+IEJpbmQgdG8gYWxsIDB4MTAwMiBHUFUgZGV2aWNlcy4NCj4g
Pg0KPiA+IEZvciBub3cgd2UgZXhwbGljaXRseSByZXR1cm4gLUVOT0RFViBmb3IgZ2VuZXJpYyBi
aW5kaW5ncy4NCj4gPiBSZW1vdmUgdGhpcyBjaGVjayBvbmNlIElQIGRpc2NvdmVyeSBiYXNlZCBj
aGVja2luZyBpcyBpbiBwbGFjZS4NCj4gPg0KPiA+IHYyOiByZWJhc2UgKEFsZXgpDQo+ID4NCj4g
PiBSZXZpZXdlZC1ieTogQ2hyaXN0aWFuIEvDtm5pZyA8Y2hyaXN0aWFuLmtvZW5pZ0BhbWQuY29t
Pg0KPiA+IFNpZ25lZC1vZmYtYnk6IEFsZXggRGV1Y2hlciA8YWxleGFuZGVyLmRldWNoZXJAYW1k
LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBTYXNoYSBMZXZpbiA8c2FzaGFsQGtlcm5lbC5vcmc+
DQo+ID4gLS0tDQo+ID4gICBkcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfZHJ2LmMg
fCAxNSArKysrKysrKysrKysrKysNCj4gPiAgIDEgZmlsZSBjaGFuZ2VkLCAxNSBpbnNlcnRpb25z
KCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2FtZC9hbWRncHUvYW1k
Z3B1X2Rydi5jDQo+ID4gYi9kcml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfZHJ2LmMN
Cj4gPiBpbmRleCBmNjViNGIyMzNmZmIuLmMyOTQwODEwMjJiZCAxMDA2NDQNCj4gPiAtLS0gYS9k
cml2ZXJzL2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfZHJ2LmMNCj4gPiArKysgYi9kcml2ZXJz
L2dwdS9kcm0vYW1kL2FtZGdwdS9hbWRncHVfZHJ2LmMNCj4gPiBAQCAtMTk1Miw2ICsxOTUyLDE2
IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCBwY2lpZGxpc3RbXSA9IHsNCj4g
PiAgIAl7MHgxMDAyLCAweDc0MjQsIFBDSV9BTllfSUQsIFBDSV9BTllfSUQsIDAsIDAsIENISVBf
QkVJR0VfR09CWX0sDQo+ID4gICAJezB4MTAwMiwgMHg3NDNGLCBQQ0lfQU5ZX0lELCBQQ0lfQU5Z
X0lELCAwLCAwLCBDSElQX0JFSUdFX0dPQll9LA0KPiA+DQo+ID4gKwl7IFBDSV9ERVZJQ0UoMHgx
MDAyLCBQQ0lfQU5ZX0lEKSwNCj4gPiArCSAgLmNsYXNzID0gUENJX0NMQVNTX0RJU1BMQVlfVkdB
IDw8IDgsDQo+ID4gKwkgIC5jbGFzc19tYXNrID0gMHhmZmZmZmYsDQo+ID4gKwkgIC5kcml2ZXJf
ZGF0YSA9IDAgfSwNCj4gPiArDQo+ID4gKwl7IFBDSV9ERVZJQ0UoMHgxMDAyLCBQQ0lfQU5ZX0lE
KSwNCj4gPiArCSAgLmNsYXNzID0gUENJX0NMQVNTX0RJU1BMQVlfT1RIRVIgPDwgOCwNCj4gPiAr
CSAgLmNsYXNzX21hc2sgPSAweGZmZmZmZiwNCj4gPiArCSAgLmRyaXZlcl9kYXRhID0gMCB9LA0K
PiA+ICsNCj4gPiAgIAl7MCwgMCwgMH0NCj4gPiAgIH07DQo+ID4NCj4gPiBAQCAtMTk5OSw2ICsy
MDA5LDExIEBAIHN0YXRpYyBpbnQgYW1kZ3B1X3BjaV9wcm9iZShzdHJ1Y3QgcGNpX2Rldg0KPiAq
cGRldiwNCj4gPiAgIAkJCXJldHVybiAtRU5PREVWOw0KPiA+ICAgCX0NCj4gPg0KPiA+ICsJaWYg
KGZsYWdzID09IDApIHsNCj4gPiArCQlEUk1fSU5GTygiVW5zdXBwb3J0ZWQgYXNpYy4gIFJlbW92
ZSBtZSB3aGVuIElQDQo+IGRpc2NvdmVyeSBpbml0IGlzIGluIHBsYWNlLlxuIik7DQo+ID4gKwkJ
cmV0dXJuIC1FTk9ERVY7DQo+ID4gKwl9DQo+ID4gKw0KPiA+ICAgCWlmIChhbWRncHVfdmlydHVh
bF9kaXNwbGF5IHx8DQo+ID4gICAJICAgIGFtZGdwdV9kZXZpY2VfYXNpY19oYXNfZGNfc3VwcG9y
dChmbGFncyAmIEFNRF9BU0lDX01BU0spKQ0KPiA+ICAgCQlzdXBwb3J0c19hdG9taWMgPSB0cnVl
Ow0K
