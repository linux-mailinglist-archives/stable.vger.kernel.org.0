Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C18494648
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 05:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358404AbiATEGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 23:06:17 -0500
Received: from mail-bn8nam12on2057.outbound.protection.outlook.com ([40.107.237.57]:48608
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229787AbiATEGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Jan 2022 23:06:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgvN3TZiPUM0d4a8OCj1QGH/f5cAJ/RRsDTZ0eI7oz5qjMivXW5VuwSD5HXc9n2PAbBACH9xWHw3JhRURNarbKH2ha9GZuz/mOJzZQypUoXJY1HJTfX0TGSIvuHWlRauBdoBBYfyA3Egvv+/siNenIghQvD1a2tc4oJcC5E72H3f1ex3b310GKzUZn/Jecx0y08NJyZl0Pu3xPPMl3Oe7DqQz7nZF5v/AzWaAI9pUoYzQOwc1yye7YK93rDpMo7NdOCG1+XZ76R2AdrWgassvCzk3D5dPadcpfPmNZIbfwD9fa8GcjTAeQjfCd6CUQW7NRTQ45BdyBwteLXRkZAcrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PK0f7TyVR1zpmXEOpEkjdaebBHRgX3SHlc3eaXYfywA=;
 b=JJIeekvFhQ3/WVzoPEP9MMAi/T0xmlxPvRhGGXPXDAN2qHiJd8ip4E/aed5SYZ5NMDTRsv6hW7ONHuwNwwwPYZxKfUWNleTpCFrdpwjkGM+fFRZcV4Bcy/YNCoTb+eILljejaGfPcanwOQXSQYou6K2mFjkhS5Dcb1Hh7eCTNvQxAbLpr7gRlW5RlnMBV3AVkDtbmzGpC50dqCgszVUnrfMoX8iZzRjJalfhAwc56r4LIVEw0NkU5pqt3iVMkuSx7uwxG5A17LPgTXZAZ9zkg7oIidn2j3q+3cmmMTTkJWPm3p1KOz4gVRa+boZQDSwiv9fKcP6K4KrSnsivt0ulcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PK0f7TyVR1zpmXEOpEkjdaebBHRgX3SHlc3eaXYfywA=;
 b=NQGYAjQ2RMppRlTn5LhGprR7ZmTBakBMdHdeG9JWvixYEJ0wqLMayKrOSiluN/vGXAzlUFiBLeDEXaahxXPotmfldi5K+YjjyxUlXvnkGLI39Ao56VUvwWIqBKI477AFEpvCuof/84ptC+8my4WkxQ7W9VjgO0Ii7icFuPjXv4Q=
Received: from MN2PR05MB6624.namprd05.prod.outlook.com (2603:10b6:208:d8::18)
 by MW4PR05MB8220.namprd05.prod.outlook.com (2603:10b6:303:11f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.2; Thu, 20 Jan
 2022 04:06:13 +0000
Received: from MN2PR05MB6624.namprd05.prod.outlook.com
 ([fe80::3de2:ebe0:8c9:c112]) by MN2PR05MB6624.namprd05.prod.outlook.com
 ([fe80::3de2:ebe0:8c9:c112%5]) with mapi id 15.20.4930.004; Thu, 20 Jan 2022
 04:06:13 +0000
From:   Zack Rusin <zackr@vmware.com>
To:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "javierm@redhat.com" <javierm@redhat.com>,
        "tzimmermann@suse.de" <tzimmermann@suse.de>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Martin Krastev <krastevm@vmware.com>,
        Maaz Mombasawala <mombasawalam@vmware.com>
Subject: Re: [PATCH] drm/vmwgfx: Stop requesting the pci regions
Thread-Topic: [PATCH] drm/vmwgfx: Stop requesting the pci regions
Thread-Index: AQHYC8yinmr5RRCrG02Gv/mSECQCTKxpI6WAgAB5uACAAHSWgIAAUE4AgAAUKgCAAAqSAIAAzYgA
Date:   Thu, 20 Jan 2022 04:06:13 +0000
Message-ID: <e9f42f83d7966952c8c0ff78be7e510a2aebdf01.camel@vmware.com>
References: <20220117180359.18114-1-zack@kde.org>
         <1c177e79-d28a-e896-08ec-3cd4cd2fb823@redhat.com>
         <da4e34772a9557cf4c4733ce6ee2a2ad47615044.camel@vmware.com>
         <5292edf8-0e60-28e1-15d3-6a1779023f68@suse.de>
         <afc4c659-b92e-3227-634f-7c171b7a74b3@suse.de>
         <80fc6b88d659dd7281364daccfed1fd294e785dc.camel@vmware.com>
         <89f1b9df-6ace-d59c-86a4-571cd92d0a4c@suse.de>
In-Reply-To: <89f1b9df-6ace-d59c-86a4-571cd92d0a4c@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4-1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39a12ea0-2b85-4db5-22de-08d9dbca32e4
x-ms-traffictypediagnostic: MW4PR05MB8220:EE_
x-microsoft-antispam-prvs: <MW4PR05MB8220149F53AE56C1D589B7C9CE5A9@MW4PR05MB8220.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cZ8SPLGFdjNk72AahpbeYd0/WcpfQPMMuBqEDbZJmOwbUuFhJTXn7hiWk1ZAXjlgA5z8LNwd1k95lL+Prk4vgo8iJskiooEnkkRTvUmjxL1f7qzLeNHohJoIaHNaO2grGcoQiTF3cF9hgZe+Z3HpFlj0BzlakXkh2OACL0BGZnWL7UR376vBVt/YUwGR9GtIl2OOVNHSUaX1IXWmBEQdkWlwU0ktPKJsMa2SH5m43jHrqjB/u8/raU5Hec9oF8fChpSvtByXzI4gx/2MsFVKQHE9hYEhU/m6c4zQP2fsySg9feE3DHNkyHFVL/LwOxypz638K9SD4An0RYH7JBHVUHLfVxOQQXIBf6Z8jK9T+TsuelyfEk/NnqeL9Q0iJlhTnO161WxaJSn57tvvSxwT301A1NgSZkapVrHRGF1U+pY26uo2UUsWnJD+xupuXSz6ibGOHr7Cj4gPvtnglp7PcTUQ+3RGGq1zsdbSV3g1PXY15t/izZay0SDKc1aP/XedVOi8Lpl8z3RnQTVS9yNaXXB5wD4HQTiUg2oxxFuaXn1IG2bnC/Llf8ISP5NBimrjYSk0gAvxaCscu7t0eOh1O3FNLW3isQ27QimLgU7cMGxV/7Qm7yBOnEkU7BCfGiNDEC9xV9vgQ1TONeo6CnqSNTNIgA3upItyl7NJixlYy2KFaFRppZ6D0XL15Ihv36ybk/z9JURM5+bUEi3vClPg9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR05MB6624.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(316002)(110136005)(6486002)(71200400001)(54906003)(6506007)(53546011)(76116006)(36756003)(86362001)(38100700002)(508600001)(66476007)(122000001)(6512007)(26005)(38070700005)(64756008)(4326008)(66446008)(66556008)(8676002)(2616005)(186003)(5660300002)(66946007)(2906002)(8936002)(107886003)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SHpVOWlHaEthaDRUdHk3VHFBcVNmdndReFdzaHJHSXZndmVFak96MTRlWVlE?=
 =?utf-8?B?Q21rRDhCdHVYbjVlcHY1VDE2YmUxQUpsaEdQOXMvRFRpb1JlSERxdHhEUC9V?=
 =?utf-8?B?c0JCU3RzeW1OUy9uNEY1elBDTGk5cnZyTTFoWEFPQzV4VVVYaEhsdlhIWU9t?=
 =?utf-8?B?U085WXd0eEJkK213NWlPbjA5anZvUXJyaDVKVmlSdUt1b0VtaytSNVh0YjVT?=
 =?utf-8?B?dXZEMjRiT2pHYzlrTk9xd0tBVDExMW1nSFl1UVh3eHdLdGdjQXBDcEhWNUQ0?=
 =?utf-8?B?N0Y3R2tYWjk3T3ZoNkVRTlJXK2JZQm9WbzZBS3FGMmhCVnpLajFMWkJNM1lS?=
 =?utf-8?B?SDFORE5hcWdEa29jSEYwUHowVTlqOCs2Z25yZTNvMFZjUFlEYkQ5WDRPOEQ3?=
 =?utf-8?B?Q3VONjZSQVIrSUxlTzczTkd0dDNVZE94cUV3eCtLNXJweHpBelhoVGx6RnpV?=
 =?utf-8?B?ejhZNms5czJOU3hHaFRYQzd4RXl6RkxXYUNmeE9QaTh0U1Q1emxPSUlkdG9K?=
 =?utf-8?B?ZXo5a1JWVzdCSGk1c2g1dlJhUGdzNThFOUhQRlpKekZicXQwbG9iNFlXcGxG?=
 =?utf-8?B?R3pwYUp1cE1hKzNCcUNHMXZxaFk2ZGxGZ1NEcnBCTVdKUlRxbzdwb0h2a0d5?=
 =?utf-8?B?czhFVUhtc2NnalVWT0lxM0tRS1loanJQNURCem16Umg5aEIrUVlFV21Od2p5?=
 =?utf-8?B?OEpNUmgvMEVsc0cwcjByUW5aclRpWE0vclRxVktJZDN1RXFoVGdFNkNZQVJl?=
 =?utf-8?B?dDlaR3V6OHNtV0l5RnJSRC9MbUtoMFRIdHVEV0MveU4rcUxQOE52b3BvNzdG?=
 =?utf-8?B?NzdzYkxzalIyOCtpVlZMcUU2ZFVPdWNacVVWUEI0SXZzaVdsNDZudkpYLzhS?=
 =?utf-8?B?RWhycUt6bjNqYWxTeGZwSGxyLzBqdnhFdm5DYWU0SW5Pa3RIV0RQbGRwNlR0?=
 =?utf-8?B?K0lmWlBYNnZ3d1l3TEFxd3hNNVE1Sit5b3IyT2ZybDJJNklpTGdpbExsN1FB?=
 =?utf-8?B?UDhiYVpwekNtVm1kUDNJTVpBSXV2T1NET09BVWtYb1JmN3hYajRMb0x4UXdV?=
 =?utf-8?B?MUo5YmtGUDZrSGt5am9GenhJaWcyYytSZ2h6QTRPS09rQ3RlSTBaYVdGUm53?=
 =?utf-8?B?VE53emhUQ0RzcHNPaHV5Ui9ncmJrU3p6eGtJUzZtS3FFZmZoT3lpcTdXamJt?=
 =?utf-8?B?RGlTVUNPQUV6czlGNVFKdWZDaXdsL1QrMzJPR3BoL1Y5WUZNVUZIVk50N2ZW?=
 =?utf-8?B?NitIY2RrMFhQUVpQV2p2ejU4eUYxdDRoQWMwczV6N1FSSTRzVllNQTR4MVFx?=
 =?utf-8?B?TzJoQ3BSQlhzNkd3a1VKbXBJRXRHbUpuRWEvZHhnUEJOLzhMRGNLWklNV0N5?=
 =?utf-8?B?c3VqYzAwR2RDWEE2UVhoZkdjVk5CNFJLL3Bkc25xaktkME9uZklyZ3g0Skc1?=
 =?utf-8?B?ai9sbnVXaWZidk1Sak16WTc1ZTExcUZVS3V3MlJmeE5hOXVSc2k5dGdoRDB6?=
 =?utf-8?B?VzlCL2t0a21KSlJtNGNhVkRVV3ZpZ0swVzVNbG80alNxTTFaRzBaUjRnemNk?=
 =?utf-8?B?WFlkRmtXS2hpUXhCMFJjMXVJa1FVL282NUVlSlpVZXJ3bFZtSHp1cnp5OVNX?=
 =?utf-8?B?T1lha0xZYlpLL1FjNTI0S0NUanZDb1N6TXA2cGIzWHl4dE9PdWVqa1JRenlo?=
 =?utf-8?B?cUN0NTlIdU5lQWpXNExIalA5cktLMU1iQnR5d3pKVXpNY2dXbUE0NDR2T3pE?=
 =?utf-8?B?L2dZb3Irc2V1YzQyUXUrMXVoU2JLKzVBem5zNG1PbXpLS05rS0I0Qk5IaGFK?=
 =?utf-8?B?QjMwWTZlVisrWnFnN2RqcnBCZDAwdGd4eDl5ZWNKUm9ZTWJka3NSZW5Fa21O?=
 =?utf-8?B?TThQSkRFQnc3MDZIakJxVElVL2ljN3M1TEEwekZjMXBORjdyTTQ0YnRuRGJn?=
 =?utf-8?B?V1RKTWZ2VmhYK1lFcXBkb2cwZ1pmbmtYcjRRZ1REbmZBWlhGRlJPOVVoNUVX?=
 =?utf-8?B?MzA4NTF1UnBudFlSbURQZm04K0NRRDFFTXh4am9rZkhpdFVRZzVEWlRTZTg5?=
 =?utf-8?B?NDZrOHhMZVRVSHdqR0R2NTl0ZkxaUjhQcXlpTVlDZ2F1MVh5eTZyWGJuTWJO?=
 =?utf-8?B?U1lXUVpLait3NWNDc1JyVVZqSzBFQzFUTzg4UmM0eThoNmd1WlJDT1dBampx?=
 =?utf-8?Q?xGXSQdiEgTYNFNLO7uBW+OQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <649A643CE60A2346BD7C6476C0148D25@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR05MB6624.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39a12ea0-2b85-4db5-22de-08d9dbca32e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2022 04:06:13.1918
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4d3y5dYzyP2jTaOcVULhGeJiSzF1beSeY3uvJOMGtbcSCe/U5BpVSNVRv6pzax67xHFSttdacDWwGo/DYmAZPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR05MB8220
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDIyLTAxLTE5IGF0IDE2OjUwICswMTAwLCBUaG9tYXMgWmltbWVybWFubiB3cm90
ZToNCj4gSGkNCj4gDQo+IEFtIDE5LjAxLjIyIHVtIDE2OjEyIHNjaHJpZWIgWmFjayBSdXNpbjoN
Cj4gPiBPbiBXZWQsIDIwMjItMDEtMTkgYXQgMTU6MDAgKzAxMDAsIFRob21hcyBaaW1tZXJtYW5u
IHdyb3RlOg0KPiA+ID4gSGkgWmFjaw0KPiA+ID4gDQo+ID4gPiBBbSAxOS4wMS4yMiB1bSAxMDox
MyBzY2hyaWViIFRob21hcyBaaW1tZXJtYW5uOg0KPiA+ID4gPiBIaQ0KPiA+ID4gPiANCj4gPiA+
ID4gQW0gMTkuMDEuMjIgdW0gMDM6MTUgc2NocmllYiBaYWNrIFJ1c2luOg0KPiA+ID4gPiA+IE9u
IFR1ZSwgMjAyMi0wMS0xOCBhdCAyMDowMCArMDEwMCwgSmF2aWVyIE1hcnRpbmV6IENhbmlsbGFz
DQo+ID4gPiA+ID4gd3JvdGU6DQo+ID4gPiA+ID4gPiBIZWxsbyBaYWNrLA0KPiA+ID4gPiA+ID4g
DQo+ID4gPiA+ID4gPiBPbiAxLzE3LzIyIDE5OjAzLCBaYWNrIFJ1c2luIHdyb3RlOg0KPiA+ID4g
PiA+ID4gPiBGcm9tOiBaYWNrIFJ1c2luIDx6YWNrckB2bXdhcmUuY29tPg0KPiA+ID4gPiA+ID4g
PiANCj4gPiA+ID4gPiA+ID4gV2hlbiBzeXNmYl9zaW1wbGUgaXMgZW5hYmxlZCBsb2FkaW5nIHZt
d2dmeCBmYWlscyBiZWNhdXNlDQo+ID4gPiA+ID4gPiA+IHRoZQ0KPiA+ID4gPiA+ID4gPiByZWdp
b25zDQo+ID4gPiA+ID4gPiA+IGFyZSBoZWxkIGJ5IHRoZSBwbGF0Zm9ybS4gSW4gdGhhdCBjYXNl
DQo+ID4gPiA+ID4gPiA+IHJlbW92ZV9jb25mbGljdGluZypfZnJhbWVidWZmZXJzDQo+ID4gPiA+
ID4gPiA+IG9ubHkgcmVtb3ZlcyB0aGUgc2ltcGxlZmIgYnV0IG5vdCB0aGUgcmVnaW9ucyBoZWxk
IGJ5DQo+ID4gPiA+ID4gPiA+IHN5c2ZiLg0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IA0K
PiA+ID4gPiA+ID4gSW5kZWVkLCB0aGF0J3MgYW4gaXNzdWUuIEkgd29uZGVyIGlmIHdlIHNob3Vs
ZCBkcm9wIHRoZQ0KPiA+ID4gPiA+ID4gSU9SRVNPVVJDRV9CVVNZDQo+ID4gPiA+ID4gPiBmbGFn
IGZyb20gdGhlIG1lbW9yeSByZXNvdXJjZSBhZGRlZCB0byB0aGUgInNpbXBsZS0NCj4gPiA+ID4g
PiA+IGZyYW1lYnVmZmVyIg0KPiA+ID4gPiA+ID4gZGV2aWNlDQo+ID4gPiA+ID4gPiA/DQo+ID4g
PiA+ID4gDQo+ID4gPiA+ID4gSSB0aGluayB0aGlzIGlzIG9uZSBvZiB0aG9zZSBjYXNlcyB3aGVy
ZSBpdCBkZXBlbmRzIG9uIHdoYXQNCj4gPiA+ID4gPiB3ZSBwbGFuDQo+ID4gPiA+ID4gdG8NCj4g
PiA+ID4gPiBkbyBhZnRlciB0aGF0LiBTZW1lbnRpY2FsbHkgaXQgbWFrZXMgc2Vuc2UgdG8gaGF2
ZSBpdCBpbg0KPiA+ID4gPiA+IHRoZXJlIC0NCj4gPiA+ID4gPiB0aGUNCj4gPiA+ID4gPiBmcmFt
ZWJ1ZmZlciBtZW1vcnkgaXMgY2xhaW1lZCBieSB0aGUgInNpbXBsZS1mcmFtZWJ1ZmZlciIgYW5k
DQo+ID4gPiA+ID4gaXQncw0KPiA+ID4gPiA+IGJ1c3ksIGl0J3MganVzdCB0aGF0IGl0IGNyZWF0
ZXMgaXNzdWVzIGZvciBkcml2ZXJzIGFmdGVyDQo+ID4gPiA+ID4gdW5sb2FkaW5nLg0KPiA+ID4g
PiA+IEkNCj4gPiA+ID4gPiB0aGluayByZW1vdmluZyBpdCwgd2hpbGUgbWFraW5nIHRoaW5ncyBl
YXNpZXIgZm9yIGRyaXZlcnMsDQo+ID4gPiA+ID4gd291bGQgYmUNCj4gPiA+ID4gPiBjb25mdXNp
bmcgZm9yIHBlb3BsZSByZWFkaW5nIHRoZSBjb2RlIGxhdGVyLCB1bmxlc3MgdGhlcmUncw0KPiA+
ID4gPiA+IHNvbWUNCj4gPiA+ID4gPiBraW5kDQo+ID4gPiA+ID4gb2YgY2xlYW51cCB0aGF0IHdv
dWxkIGhhcHBlbiB3aXRoIGl0IChlLmcuIHJlbW92aW5nDQo+ID4gPiA+ID4gSU9SRVNPVVJDRV9C
VVNZDQo+ID4gPiA+ID4gYWx0b2dldGhlciBhbmQgbWFraW5nIHRoZSBkcm0gZHJpdmVycyBwcm9w
ZXJseSByZXF1ZXN0IHRoZWlyDQo+ID4gPiA+ID4gcmVzb3VyY2VzKS7CoEF0IGxlYXN0IGJ5IGl0
c2VsZiBpdCBkb2Vzbid0IHNlZW0gdG8gYmUgbXVjaA0KPiA+ID4gPiA+IGJldHRlcg0KPiA+ID4g
PiA+IHNvbHV0aW9uIHRoYW4gaGF2aW5nIHRoZSBkcm0gZHJpdmVycyBub3QgY2FsbA0KPiA+ID4g
PiA+IHBjaV9yZXF1ZXN0X3JlZ2lvbltzXSwNCj4gPiA+ID4gPiB3aGljaCBhcGFydCBmcm9tIGh5
cGVydiBhbmQgY2lycnVzIChpaXJjIGJvY2hzIGRvZXMgaXQgZm9yDQo+ID4gPiA+ID4gcmVzb3Vy
Y2VzDQo+ID4gPiA+ID4gb3RoZXIgdGhhbiBmYiB3aGljaCB3b3VsZG4ndCBoYXZlIGJlZW4gY2xh
aW1lZCBieSAic2ltcGxlLQ0KPiA+ID4gPiA+IGZyYW1lYnVmZmVyIikNCj4gPiA+ID4gPiBpcyBh
bHJlYWR5IHRoZSBjYXNlLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IEkgZG8gdGhpbmsgd2Ugc2hv
dWxkIGRvIG9uZSBvZiB0aGVtIHRvIG1ha2UgdGhlIGNvZGViYXNlDQo+ID4gPiA+ID4gY29oZXJl
bnQ6DQo+ID4gPiA+ID4gZWl0aGVyIHJlbW92ZSBJT1JFU09VUkNFX0JVU1kgZnJvbSAic2ltcGxl
LWZyYW1lYnVmZmVyIiBvcg0KPiA+ID4gPiA+IHJlbW92ZQ0KPiA+ID4gPiA+IHBjaV9yZXF1ZXN0
X3JlZ2lvbltzXSBmcm9tIGh5cGVydiBhbmQgY2lycnVzLg0KPiA+ID4gPiANCj4gPiA+ID4gSSBq
dXN0IGRpc2N1c3NlZCB0aGlzIGEgYml0IHdpdGggSmF2aWVyLiBJdCdzIGEgcHJvYmxlbSB3aXRo
DQo+ID4gPiA+IHRoZQ0KPiA+ID4gPiBzaW1wbGUtZnJhbWVidWZmZXIgY29kZSwgcmF0aGVyIHRo
ZW4gdm13Z2Z4Lg0KPiA+ID4gPiANCj4gPiA+ID4gSU1ITyB0aGUgYmVzdCBzb2x1dGlvbiBpcyB0
byBkcm9wIElPUkVTT1VSQ0VfQlVTWSBmcm9tIHN5c2ZiDQo+ID4gPiA+IGFuZCBoYXZlDQo+ID4g
PiA+IGRyaXZlcnMgcmVnaXN0ZXIvcmVsZWFzZSB0aGUgcmFuZ2Ugd2l0aCBfQlVTWS4gVGhhdCB3
b3VsZA0KPiA+ID4gPiBzaWduYWwgdGhlDQo+ID4gPiA+IG1lbW9yeSBiZWxvbmdzIHRvIHRoZSBz
eXNmYiBkZXZpY2UgYnV0IGlzIG5vdCBidXN5IHVubGVzcyBhDQo+ID4gPiA+IGRyaXZlcg0KPiA+
ID4gPiBoYXMNCj4gPiA+ID4gYmVlbiBib3VuZC4gQWZ0ZXIgc2ltcGxlZmIgcmVsZWFzZWQgdGhl
IHJhbmdlLCBpdCBzaG91bGQgYmUNCj4gPiA+ID4gJ25vbi0NCj4gPiA+ID4gYnVzeScNCj4gPiA+
ID4gYWdhaW4gYW5kIGF2YWlsYWJsZSBmb3Igdm13Z2Z4LiBTaW1wbGVkcm0gZG9lcyBhIGhvdC11
bnBsdWcgb2YNCj4gPiA+ID4gdGhlDQo+ID4gPiA+IHN5c2ZiDQo+ID4gPiA+IGRldmljZSwgc28g
dGhlIG1lbW9yeSByYW5nZSBnZXRzIHJlbGVhc2VkIGVudGlyZWx5LiBJZiB5b3UNCj4gPiA+ID4g
d2FudCwgSSdsbA0KPiA+ID4gPiBwcmVwYXJlIHNvbWUgcGF0Y2hlcyBmb3IgdGhpcyBzY2VuYXJp
by4NCj4gPiA+IA0KPiA+ID4gQXR0YWNoZWQgaXMgYSBwYXRjaCB0aGF0IGltcGxlbWVudHMgdGhp
cy4gRG9pbmcNCj4gPiA+IA0KPiA+ID4gwqDCoCBjYXQgL3Byb2MvaW9tZW0NCj4gPiA+IMKgwqDC
oCAuLi4NCj4gPiA+IMKgwqDCoCBlMDAwMDAwMC1lZmZmZmZmZiA6IDAwMDA6MDA6MDIuMA0KPiA+
ID4gDQo+ID4gPiDCoMKgwqDCoMKgIGUwMDAwMDAwLWUwN2U4ZmZmIDogQk9PVEZCDQo+ID4gPiAN
Cj4gPiA+IMKgwqDCoMKgwqDCoMKgIGUwMDAwMDAwLWUwN2U4ZmZmIDogc2ltcGxlZmINCj4gPiA+
IA0KPiA+ID4gwqDCoMKgIC4uLg0KPiA+ID4gDQo+ID4gPiBzaG93cyB0aGUgbWVtb3J5LiAnQk9P
VEZCJyBpcyB0aGUgc2ltcGxlLWZyYW1lYnVmZmVyIGRldmljZSBhbmQNCj4gPiA+ICdzaW1wbGVm
YicgaXMgdGhlIGRyaXZlci4gT25seSB0aGUgbGF0dGVyIHVzZXMgX0JVU1kuIFNhbWUgZm9yDQo+
ID4gPiBhbmQgdGhlIG1lbW9yeSBjYW5iZSBhY3F1aXJlZCBieSB2bXdnZnguDQo+ID4gPiANCj4g
PiA+IFphY2ssIHBsZWFzZSB0ZXN0IHRoaXMgcGF0Y2guIElmIGl0IHdvcmtzLCBJJ2xsIHNlbmQg
b3V0IHRoZSByZWFsDQo+ID4gPiBwYXRjaHNldC4NCj4gPiANCj4gPiBIbW0sIHRoZSBwYXRjaCBs
b29rcyBnb29kIGJ1dCBpdCBkb2Vzbid0IHdvcmsuIEFmdGVyIGJvb3Q6DQo+ID4gL3Byb2MvaW9t
ZW0NCj4gPiA1MDAwMDAwMC03ZmZmZmZmZiA6IHBjaWVAMHg0MDAwMDAwMA0KPiA+IMKgwqAgNzgw
MDAwMDAtN2ZmZmZmZmYgOiAwMDAwOjAwOjBmLjANCj4gPiDCoMKgwqDCoCA3ODAwMDAwMC03ODJm
ZmZmZiA6IEJPT1RGQg0KPiA+IA0KPiA+IGFuZCB2bXdnZnggZmFpbHMgb24gcGNpX3JlcXVlc3Rf
cmVnaW9uczoNCj4gPiANCj4gPiBrZXJuZWw6IGZiMDogc3dpdGNoaW5nIHRvIHZtd2dmeCBmcm9t
IHNpbXBsZQ0KPiA+IGtlcm5lbDogQ29uc29sZTogc3dpdGNoaW5nIHRvIGNvbG91ciBkdW1teSBk
ZXZpY2UgODB4MjUNCj4gPiBrZXJuZWw6IHZtd2dmeCAwMDAwOjAwOjBmLjA6IEJBUiAyOiBjYW4n
dCByZXNlcnZlIFttZW0gMHg3ODAwMDAwMC0NCj4gPiAweDdmZmZmZmZmIDY0Yml0IHByZWZdDQo+
ID4ga2VybmVsOiB2bXdnZng6IHByb2JlIG9mIDAwMDA6MDA6MGYuMCBmYWlsZWQgd2l0aCBlcnJv
ciAtMTYNCj4gPiANCj4gPiBsZWF2aW5nIHRoZSBzeXN0ZW0gd2l0aG91dCBhIGZiIGRyaXZlci4N
Cj4gDQo+IE9LLCBJIHN1c3BlY3QgdGhhdCBpdCB3b3VsZCB3b3JrIGlmIHlvdSB1c2Ugc2ltcGxl
ZHJtIGluc3RlYWQgb2YgDQo+IGludG8gdGhlIGtlcm5lbCBiaW5hcnkuDQoNClllcywgc2ltcGxl
ZHJtIHdvcmtzIGZpbmUuIEJUVywgaXMgdGhlcmUgYW55IHJlbWFpbmluZyB3b3JrIGJlZm9yZQ0K
ZGlzdHJvcyBjYW4gZW5hYmxlIGl0IGJ5IGRlZmF1bHQ/DQoNCj4gDQo+IElmIHRoYXQgd29ya3Ms
IHdvdWxkIHlvdSBjb25zaWRlciBwcm90ZWN0aW5nIHBjaV9yZXF1ZXN0X3JlZ2lvbigpDQo+IHdp
dGgNCj4gwqAgI2lmIG5vdCBkZWZpbmVkKENPTkZJR19GQl9TSU1QTEUpDQo+IMKgICNlbmRpZg0K
PiANCj4gd2l0aCBhIEZJWE1FIGNvbW1lbnQ/DQoNClllcywgSSB0aGluayB0aGF0J3MgYSBnb29k
IGNvbXByb21pc2UuIEknbGwgcmVzcGluIHRoZSBwYXRjaCB3aXRoIHRoYXQuDQoNCnoNCg==
