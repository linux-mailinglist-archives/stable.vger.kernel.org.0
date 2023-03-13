Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757DD6B7D58
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 17:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjCMQWl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 12:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjCMQWk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 12:22:40 -0400
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2108.outbound.protection.outlook.com [40.107.103.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A7674DEB;
        Mon, 13 Mar 2023 09:22:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQks+6Scurnri/pDeST0kF+uPE8aCHJjMw1mqgMdoDNQ+hTZ8rXllNJ/tFn+4EmXHSNIKGRJM0K3l62Z/upHwlihBShVYVgaK718hjpFIoFa4hxF6G8Zk+pdAQwXdpd7gt5BA1ARH/jdXUUUKGNmjSL+sEXKz6XylD8QQRWbJM0aaoEPGDNQ3cbsxMO8RWM5mZ7XCZL6JJ+he2Zo22Eb46+qeOSvermtJJD4KlEt/a5Gzm5jq+ZjYXh5X660J2uknq1NRWwBVCSqY7Vv+Wl8iNb7HhUoi1Aq8uJiHnAGuD8C0EQlxwggNpgCFmDqwM0x6XIk7PhU/nw8i/N1tOPb3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wm6V5HCr2Q/Y7ZjtE6f0jMzy/9VU1E2mYuHd5HnR8HA=;
 b=mclFLS8+7s8nZ45Tt9YusD+aJ7S4HO5vyf+hPqfhSTKFtbcLuNIJ3WpxMWAVZC02vWopn9GTsym0Wcu0JnMDdphqVlsxgbopB6ANf/O9rKOgSf9HzMiCmwS7Pn8lMgCT3l5Ab2UzhyToR2h1yNL8Ej69o+3GjU7ZOKYT8jd+lqKS+0H1/5W9ybys+7iCcarSPJ4cjoeXR8zyNkSx3w2WgjFEzfUTT7zlvURzXT1fhWm+/q4Mzsaubj8BqsgsWjCPPH94MIYcFbMQUESPR4vqZ0xt/+df3gYuTu3chIx35mWuzKzgQbPC+Dr9gSE+oYF+11ZP3Cy84mO29N+eGBJN9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wm6V5HCr2Q/Y7ZjtE6f0jMzy/9VU1E2mYuHd5HnR8HA=;
 b=Ew0Gbwgc7lL1rzXe+tV4KQSSwIsHs4TPpv8Eu4p6CFdCqOBP+LWW1ubUIC3ef0nLGOuEKRCJmqIV8Z9+qsSg33XjNbY2FQB8v9IJk6rJ+FP0UeOf+AcDcBuLDZx1TmxR0hbna7fAYUd8hgS8nVYUwnzQsFQH5dLArGdpJefYv5I=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by VI1PR03MB6559.eurprd03.prod.outlook.com (2603:10a6:800:193::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 16:22:34 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::8fbf:de56:f9fd:ccba]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::8fbf:de56:f9fd:ccba%6]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 16:22:34 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     kernel test robot <lkp@intel.com>
CC:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Marek Vasut <marex@denx.de>,
        "oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] extcon: usbc-tusb320: unregister typec port on driver
 removal
Thread-Topic: [PATCH] extcon: usbc-tusb320: unregister typec port on driver
 removal
Thread-Index: AQHZVavlSGq1k72/rEO666JZb8fHWa7436kAgAAFBoA=
Date:   Mon, 13 Mar 2023 16:22:34 +0000
Message-ID: <20230313162233.oqcd67kwcskenzxa@bang-olufsen.dk>
References: <20230313130105.4183296-1-alvin@pqrs.dk>
 <202303132335.Qnq7apal-lkp@intel.com>
In-Reply-To: <202303132335.Qnq7apal-lkp@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|VI1PR03MB6559:EE_
x-ms-office365-filtering-correlation-id: 7de140ce-f739-4e95-d228-08db23df26ed
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MUyrf7SRtnfCBfuhIvRBQg6qlAIP+T8nu4CFx7iHnBvekB/PLhYqVcsHUz2buSHbp3n5Ya3K3IjVS+z+BYvC8BCDVgo+t9XLOs51nSBDnwKN7MwCmLsy/hFDdFpj3kjH8il8uwTSk8aSUVvTg0lvVkTyO8/hkLCnCwsDPcUF5KdBoN4DUVB6N17VlNnHCmaPmnLXvo+J2sauvQLGvOpSK0cG3McUsUUQS56hG46TTWZ203wy7lwTa8g5/jYtUMS+hs+8KV8tFoGAjBv7f3qcVk2gG3GyTjhbuigeD5WDyc0RSCuuobtmc5b1/wY7d98e3Mb5MkQIPyISOCJcFCtl3vK2V7qFzfrbxOgT+QvY3qCc5Yptn9b8m/mRoH2YSyTLB7XzZ8qCooMZpF+aBD/tx3L/j9QLYjpCiBw26Adfb+UpgL7MF0AS7tpQA6mwe/RpJ6bX4qGA5CYmrrzrZIBSo4hn9ei031j/cPlOuXvf24bB0+uT2da3rHBMKREAmWCzCJQcSfSNN8/uyj/yhWzS3ZynpStw3QG4GpVy3hdFXRIqTJod8HrA+ydZ3Hceh7gvU9Tdxsdggr/aw8El19lGoIygw2cqh6DgjB9fpewHq+xiA/ODZukjamZxUoHML3lt9xtDsuzrMU5veCeHzHmdSwfP3IFdPvyAN/sduFf0z4MAMDOcdI5E5EFF8GMR1jaN5zDx7SxMoBGiJtKlqEGZZX1FVmL0W6amVugtzfcSf60=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39850400004)(366004)(376002)(136003)(451199018)(2906002)(122000001)(38100700002)(2616005)(478600001)(316002)(1076003)(6506007)(6512007)(71200400001)(54906003)(85202003)(86362001)(85182001)(38070700005)(36756003)(41300700001)(66556008)(91956017)(4326008)(66476007)(66446008)(64756008)(6916009)(8676002)(66946007)(76116006)(186003)(6486002)(8976002)(966005)(26005)(8936002)(7416002)(5660300002)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YW1QenptdWc4N0pjY2dLc2dFRU1wUUdqSk1PNjNlZm8vMjRTTEdvaU1LK1Bk?=
 =?utf-8?B?cHk2NWw0eHNvdUF3VkJQOFJOdUhEQ0pscXpyN0FMbnpubzJQcEU3V1RNNmY4?=
 =?utf-8?B?UkVNeTl4Nkk5R3NaQUdvdm1EREVGZTRRaHltelFZUUNKZmpJM1Nzd3EyNjFs?=
 =?utf-8?B?Q2lMdXVLVWhReVRnc1FwSlJEMTdscXI5M2NVczBONHpUaTNLVWxoRU5vSkJo?=
 =?utf-8?B?Z3diV1FydHVPSURQM1d5WDZIekR3VE05Z2hNV2xkUTZDK2dKYmZ3U0FGWXEw?=
 =?utf-8?B?VWpCMnh0QzkweTdKTHJzV0xjN2c5WVZydnFtaVpTZmh4MTRZb2V5QTV3b0RW?=
 =?utf-8?B?Ymppb3pGakl1Q0trZkhXVGI3WSt3a3hlaGlDRFpaaDVub0U0aG1MRDhMMmZP?=
 =?utf-8?B?S0N3eXZmZys4Q1VEM25jT1BYMlBhaU5YbmxlZnhqSk0vdGM3R1JXUW1nV00v?=
 =?utf-8?B?NThrMkJQd1IwcjFqMnZUVzZlWmhNUHQ5SFRpaWtQenhqSkRrNk1aZ1ZSZXhL?=
 =?utf-8?B?K0d6b29RdC9xVjU1OWFrWldCTEVrYlg5OTQ1c2VKV1A5Z2ZNWVZUb0hTTkRr?=
 =?utf-8?B?NkRiWGJGUVNQZFFhdzArRnJ5M0RmT1ltT2VNZDViYWlMQ3krTTNNeHM4cUg4?=
 =?utf-8?B?WTZxeGhUNnBsR1FRUGsyc3AyMGxKRlUydFZXSmJsUUJuNGVCMjFnRkZlSWFq?=
 =?utf-8?B?ZEkvcGpvaUlFTWtjQStaT0hoUkxxTjRLK0xRYkVsd0d5SW0xZW9VRVd6V0hQ?=
 =?utf-8?B?K1hYVUE1cm5qWmhhdkRndEpIMzc4dVlCdkxMNEtZOXNmRzFOZlVETWFsdnhm?=
 =?utf-8?B?RklZL0xwRHpmbno1N1FPc0dhbm9DVHorWVliVTNBQWNKL2pSNEFQV005bjlo?=
 =?utf-8?B?OC9MMU9FS2NzOGxrUGpkN1U1ZXZCSXo4RlhlWDZyV0pOVXNuQlNZYzRJQzN2?=
 =?utf-8?B?dG9zSk0rc01sQkhqWGJLaXNrMHZGdXVVUnBISUladjZ2cWYxMVlTQmJpR2tS?=
 =?utf-8?B?QnNnNTQ5NEJTNGdDWUU2K1d6S2NrOTczVk93UmdvYm5zOEt0ZTQwK1JnNits?=
 =?utf-8?B?SWZNQlJpQXV1MVVxeEExN3JXMjBWQjBESWE1bitudW8xVzQwTHlGTTZ3NFFK?=
 =?utf-8?B?c2pDTFB6b2ZiYitDdmx3QXEycThXUFpPWk1NdnhQSEpnWURqeUNOTDBBYVZH?=
 =?utf-8?B?YW9Mb2g3TUdqSkRFMzkvUEErWWV5Y2dCUDAwYkNDTnB3SE1NTlNCUklnZUdw?=
 =?utf-8?B?aDJOZWEyRnRhb3pUK0V3dytuZk93aXFMWjk3UkRiSW53bFc5eDdtdDM5ci91?=
 =?utf-8?B?SEcwSVFNSTk2Q0xsRUtldDhPSVl1NmUrblFNTmU3L0JMTWZDdUtITHBPRitv?=
 =?utf-8?B?ZDE3MHZsUjRqaXJxRVNIRXNSck5taGYrL1ZnbllDNUEyeG9ZUXlNa0JZdVpJ?=
 =?utf-8?B?UGpJdTJYNE1EZy90K3VJZEJFbW9hRy9WZ1pJanA2T3FnT3BPY2YvYVp0S25K?=
 =?utf-8?B?K2dTVGthcVFFOUxiKzk1bmdSZzdVQlBtcFRsNlZLZ0JTbVBML0RxaEwvVm5h?=
 =?utf-8?B?Y1ZKR3Y0WkJEUVpzVkcwWW9vZkZCRDA1b0I3MlBjeWUzRVNQalRiTFc3QWkz?=
 =?utf-8?B?a0lZd3d6STJsNi9aMXhobmxmM0tQQWFqMWFjTEw0TXR1aTBWS3hSQmVHTmFv?=
 =?utf-8?B?Sndrd0hHL041Vk5WSmo0YW1xS0l6N1RzQXpmeHE3a0d0SktPZHZ6Z2JueXVJ?=
 =?utf-8?B?a09HUUFBK2hQYnlDOFhGOEZIWkx0WnpucHU1ZExkU3ZCcUxqcDhEcVZxOE5T?=
 =?utf-8?B?RFVvY3ZzaGRNVUROYXNXUDZHWU93em9lbFN0eG1lMkVScThwWHY1NjdVL3di?=
 =?utf-8?B?dUxlMCttMWtFNlU0K1NzQXdNUGVVRXpxdlBPRSt6M0VaNkFEc2JZa2xGOTdt?=
 =?utf-8?B?dVN0VXc4WkFpYjFKUHlBQUN1R0lQR01GZ3ZoVUJPMjhNV1ZxSC96OEVPRTgy?=
 =?utf-8?B?Q2FIMUdycHhoQVBpUmxqb3F2RWluOUlxUDlJSXlzL3lHcFZ1dWR4Y1FOZ1pq?=
 =?utf-8?B?d0dtYkEyV2J1RVZNeVh6YnlLQ2NlR3IxWVFsZXVQM0kvZGQ0RDQ4WmpPcjFi?=
 =?utf-8?B?Qy9pbjYwZjRKeG9UMm5paFR6aGg1SlhrdmxBUUNadmdyeEFZS245V1pSVmpI?=
 =?utf-8?B?RFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E9FC7BA226FAD146A913C87751A99DC1@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7de140ce-f739-4e95-d228-08db23df26ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 16:22:34.0700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jAHpB7PYnQZRJKexrs+GHszOeJfsQ+6FNJ3uarhnzxbqMKrqM+hwfTMWj0DWkOnCZLr5pkMcU1qSNR/UZ6Ei3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR03MB6559
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCBNYXIgMTQsIDIwMjMgYXQgMTI6MDQ6MzRBTSArMDgwMCwga2VybmVsIHRlc3Qgcm9i
b3Qgd3JvdGU6DQo+IEhpIEFsdmluLA0KPiANCj4gSSBsb3ZlIHlvdXIgcGF0Y2ghIFBlcmhhcHMg
c29tZXRoaW5nIHRvIGltcHJvdmU6DQo+IA0KPiBbYXV0byBidWlsZCB0ZXN0IFdBUk5JTkcgb24g
Y2hhbndvby1leHRjb24vZXh0Y29uLW5leHRdDQo+IFthbHNvIGJ1aWxkIHRlc3QgV0FSTklORyBv
biBsaW51cy9tYXN0ZXIgdjYuMy1yYzIgbmV4dC0yMDIzMDMxMF0NCj4gW0lmIHlvdXIgcGF0Y2gg
aXMgYXBwbGllZCB0byB0aGUgd3JvbmcgZ2l0IHRyZWUsIGtpbmRseSBkcm9wIHVzIGEgbm90ZS4N
Cj4gQW5kIHdoZW4gc3VibWl0dGluZyBwYXRjaCwgd2Ugc3VnZ2VzdCB0byB1c2UgJy0tYmFzZScg
YXMgZG9jdW1lbnRlZCBpbg0KPiBodHRwczovL2dpdC1zY20uY29tL2RvY3MvZ2l0LWZvcm1hdC1w
YXRjaCNfYmFzZV90cmVlX2luZm9ybWF0aW9uXQ0KPiANCj4gdXJsOiAgICBodHRwczovL2dpdGh1
Yi5jb20vaW50ZWwtbGFiLWxrcC9saW51eC9jb21taXRzL0FsdmluLWlwcmFnYS9leHRjb24tdXNi
Yy10dXNiMzIwLXVucmVnaXN0ZXItdHlwZWMtcG9ydC1vbi1kcml2ZXItcmVtb3ZhbC8yMDIzMDMx
My0yMTAyNDUNCj4gYmFzZTogICBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC9jaGFud29vL2V4dGNvbi5naXQgZXh0Y29uLW5leHQNCj4gcGF0Y2ggbGluazog
ICAgaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDIzMDMxMzEzMDEwNS40MTgzMjk2LTEtYWx2
aW4lNDBwcXJzLmRrDQo+IHBhdGNoIHN1YmplY3Q6IFtQQVRDSF0gZXh0Y29uOiB1c2JjLXR1c2Iz
MjA6IHVucmVnaXN0ZXIgdHlwZWMgcG9ydCBvbiBkcml2ZXIgcmVtb3ZhbA0KPiBjb25maWc6IHg4
Nl82NC1hbGx5ZXNjb25maWcgKGh0dHBzOi8vZG93bmxvYWQuMDEub3JnLzBkYXktY2kvYXJjaGl2
ZS8yMDIzMDMxMy8yMDIzMDMxMzIzMzUuUW5xN2FwYWwtbGtwQGludGVsLmNvbS9jb25maWcpDQo+
IGNvbXBpbGVyOiBnY2MtMTEgKERlYmlhbiAxMS4zLjAtOCkgMTEuMy4wDQo+IHJlcHJvZHVjZSAo
dGhpcyBpcyBhIFc9MSBidWlsZCk6DQo+ICAgICAgICAgIyBodHRwczovL2dpdGh1Yi5jb20vaW50
ZWwtbGFiLWxrcC9saW51eC9jb21taXQvZmU0MTQwNjlkMTlmNmQ1OWM3YzM0ZjgyMDQ1OWY0MTE0
ZTJkZTEzNg0KPiAgICAgICAgIGdpdCByZW1vdGUgYWRkIGxpbnV4LXJldmlldyBodHRwczovL2dp
dGh1Yi5jb20vaW50ZWwtbGFiLWxrcC9saW51eA0KPiAgICAgICAgIGdpdCBmZXRjaCAtLW5vLXRh
Z3MgbGludXgtcmV2aWV3IEFsdmluLWlwcmFnYS9leHRjb24tdXNiYy10dXNiMzIwLXVucmVnaXN0
ZXItdHlwZWMtcG9ydC1vbi1kcml2ZXItcmVtb3ZhbC8yMDIzMDMxMy0yMTAyNDUNCj4gICAgICAg
ICBnaXQgY2hlY2tvdXQgZmU0MTQwNjlkMTlmNmQ1OWM3YzM0ZjgyMDQ1OWY0MTE0ZTJkZTEzNg0K
PiAgICAgICAgICMgc2F2ZSB0aGUgY29uZmlnIGZpbGUNCj4gICAgICAgICBta2RpciBidWlsZF9k
aXIgJiYgY3AgY29uZmlnIGJ1aWxkX2Rpci8uY29uZmlnDQo+ICAgICAgICAgbWFrZSBXPTEgTz1i
dWlsZF9kaXIgQVJDSD14ODZfNjQgb2xkZGVmY29uZmlnDQo+ICAgICAgICAgbWFrZSBXPTEgTz1i
dWlsZF9kaXIgQVJDSD14ODZfNjQgU0hFTEw9L2Jpbi9iYXNoIGRyaXZlcnMvDQo+IA0KPiBJZiB5
b3UgZml4IHRoZSBpc3N1ZSwga2luZGx5IGFkZCBmb2xsb3dpbmcgdGFnIHdoZXJlIGFwcGxpY2Fi
bGUNCj4gfCBSZXBvcnRlZC1ieToga2VybmVsIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+DQo+
IHwgTGluazogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvb2Uta2J1aWxkLWFsbC8yMDIzMDMxMzIz
MzUuUW5xN2FwYWwtbGtwQGludGVsLmNvbS8NCj4gDQo+IEFsbCB3YXJuaW5ncyAobmV3IG9uZXMg
cHJlZml4ZWQgYnkgPj4pOg0KPiANCj4gICAgZHJpdmVycy9leHRjb24vZXh0Y29uLXVzYmMtdHVz
YjMyMC5jOiBJbiBmdW5jdGlvbiAndHVzYjMyMF90eXBlY19wcm9iZSc6DQo+ID4+IGRyaXZlcnMv
ZXh0Y29uL2V4dGNvbi11c2JjLXR1c2IzMjAuYzo0Mjk6MTM6IHdhcm5pbmc6IHN0YXRlbWVudCB3
aXRoIG5vIGVmZmVjdCBbLVd1bnVzZWQtdmFsdWVdDQo+ICAgICAgNDI5IHwgICAgICAgICBwcml2
LT5jb25uZWN0b3JfZndub2RlOw0KPiAgICAgICAgICB8ICAgICAgICAgfn5+fl5+fn5+fn5+fn5+
fn5+fn5+fg0KDQpPb3BzLCBJIHdhcyBvbiBhbiBvbGQgdGVzdCBicmFuY2ggd2hlbiBzZW5kaW5n
IHRoaXMgcGF0Y2guLi4gVGhhbmsgeW91DQprZXJuZWwgdGVzdCByb2JvdC4gSSB3aWxsIHNlbmQg
djIgdG9tb3Jyb3cgdG8gYWxsb3cgZm9yIHNvbWUgb3RoZXINCmNvbW1lbnRzIGZpcnN0LiBUaGUg
b25seSBkaWZmZXJlbmNlIGluIHYyIGlzIHRoYXQgdGhpcyBsaW5lIGlzIGNvcnJlY3RlZA0KdG86
DQoNCiAgICAgICAgcHJpdi0+Y29ubmVjdG9yX2Z3bm9kZSA9IGNvbm5lY3RvcjsNCg0KS2luZCBy
ZWdhcmRzLA0KQWx2aW4NCg0KPiANCj4gDQo+IHZpbSArNDI5IGRyaXZlcnMvZXh0Y29uL2V4dGNv
bi11c2JjLXR1c2IzMjAuYw0KPiANCj4gICAgMzc5CQ0KPiAgICAzODAJc3RhdGljIGludCB0dXNi
MzIwX3R5cGVjX3Byb2JlKHN0cnVjdCBpMmNfY2xpZW50ICpjbGllbnQsDQo+ICAgIDM4MQkJCQkg
ICAgICAgc3RydWN0IHR1c2IzMjBfcHJpdiAqcHJpdikNCj4gICAgMzgyCXsNCj4gICAgMzgzCQlz
dHJ1Y3QgZndub2RlX2hhbmRsZSAqY29ubmVjdG9yOw0KPiAgICAzODQJCWNvbnN0IGNoYXIgKmNh
cF9zdHI7DQo+ICAgIDM4NQkJaW50IHJldDsNCj4gICAgMzg2CQ0KPiAgICAzODcJCS8qIFRoZSBU
eXBlLUMgY29ubmVjdG9yIGlzIG9wdGlvbmFsLCBmb3IgYmFja3dhcmQgY29tcGF0aWJpbGl0eS4g
Ki8NCj4gICAgMzg4CQljb25uZWN0b3IgPSBkZXZpY2VfZ2V0X25hbWVkX2NoaWxkX25vZGUoJmNs
aWVudC0+ZGV2LCAiY29ubmVjdG9yIik7DQo+ICAgIDM4OQkJaWYgKCFjb25uZWN0b3IpDQo+ICAg
IDM5MAkJCXJldHVybiAwOw0KPiAgICAzOTEJDQo+ICAgIDM5MgkJLyogVHlwZS1DIGNvbm5lY3Rv
ciBmb3VuZC4gKi8NCj4gICAgMzkzCQlyZXQgPSB0eXBlY19nZXRfZndfY2FwKCZwcml2LT5jYXAs
IGNvbm5lY3Rvcik7DQo+ICAgIDM5NAkJaWYgKHJldCkNCj4gICAgMzk1CQkJZ290byBlcnJfcHV0
Ow0KPiAgICAzOTYJDQo+ICAgIDM5NwkJcHJpdi0+cG9ydF90eXBlID0gcHJpdi0+Y2FwLnR5cGU7
DQo+ICAgIDM5OAkNCj4gICAgMzk5CQkvKiBUaGlzIGdvZXMgaW50byByZWdpc3RlciAweDggZmll
bGQgQ1VSUkVOVF9NT0RFX0FEVkVSVElTRSAqLw0KPiAgICA0MDAJCXJldCA9IGZ3bm9kZV9wcm9w
ZXJ0eV9yZWFkX3N0cmluZyhjb25uZWN0b3IsICJ0eXBlYy1wb3dlci1vcG1vZGUiLCAmY2FwX3N0
cik7DQo+ICAgIDQwMQkJaWYgKHJldCkNCj4gICAgNDAyCQkJZ290byBlcnJfcHV0Ow0KPiAgICA0
MDMJDQo+ICAgIDQwNAkJcmV0ID0gdHlwZWNfZmluZF9wd3Jfb3Btb2RlKGNhcF9zdHIpOw0KPiAg
ICA0MDUJCWlmIChyZXQgPCAwKQ0KPiAgICA0MDYJCQlnb3RvIGVycl9wdXQ7DQo+ICAgIDQwNwkN
Cj4gICAgNDA4CQlwcml2LT5wd3Jfb3Btb2RlID0gcmV0Ow0KPiAgICA0MDkJDQo+ICAgIDQxMAkJ
LyogSW5pdGlhbGl6ZSB0aGUgaGFyZHdhcmUgd2l0aCB0aGUgZGV2aWNldHJlZSBzZXR0aW5ncy4g
Ki8NCj4gICAgNDExCQlyZXQgPSB0dXNiMzIwX3NldF9hZHZfcHdyX21vZGUocHJpdik7DQo+ICAg
IDQxMgkJaWYgKHJldCkNCj4gICAgNDEzCQkJZ290byBlcnJfcHV0Ow0KPiAgICA0MTQJDQo+ICAg
IDQxNQkJcHJpdi0+Y2FwLnJldmlzaW9uCQk9IFVTQl9UWVBFQ19SRVZfMV8xOw0KPiAgICA0MTYJ
CXByaXYtPmNhcC5hY2Nlc3NvcnlbMF0JCT0gVFlQRUNfQUNDRVNTT1JZX0FVRElPOw0KPiAgICA0
MTcJCXByaXYtPmNhcC5hY2Nlc3NvcnlbMV0JCT0gVFlQRUNfQUNDRVNTT1JZX0RFQlVHOw0KPiAg
ICA0MTgJCXByaXYtPmNhcC5vcmllbnRhdGlvbl9hd2FyZQk9IHRydWU7DQo+ICAgIDQxOQkJcHJp
di0+Y2FwLmRyaXZlcl9kYXRhCQk9IHByaXY7DQo+ICAgIDQyMAkJcHJpdi0+Y2FwLm9wcwkJCT0g
JnR1c2IzMjBfdHlwZWNfb3BzOw0KPiAgICA0MjEJCXByaXYtPmNhcC5md25vZGUJCT0gY29ubmVj
dG9yOw0KPiAgICA0MjIJDQo+ICAgIDQyMwkJcHJpdi0+cG9ydCA9IHR5cGVjX3JlZ2lzdGVyX3Bv
cnQoJmNsaWVudC0+ZGV2LCAmcHJpdi0+Y2FwKTsNCj4gICAgNDI0CQlpZiAoSVNfRVJSKHByaXYt
PnBvcnQpKSB7DQo+ICAgIDQyNQkJCXJldCA9IFBUUl9FUlIocHJpdi0+cG9ydCk7DQo+ICAgIDQy
NgkJCWdvdG8gZXJyX3B1dDsNCj4gICAgNDI3CQl9DQo+ICAgIDQyOAkNCj4gID4gNDI5CQlwcml2
LT5jb25uZWN0b3JfZndub2RlOw0KPiAgICA0MzAJDQo+ICAgIDQzMQkJcmV0dXJuIDA7DQo+ICAg
IDQzMgkNCj4gICAgNDMzCWVycl9wdXQ6DQo+ICAgIDQzNAkJZndub2RlX2hhbmRsZV9wdXQoY29u
bmVjdG9yKTsNCj4gICAgNDM1CQ0KPiAgICA0MzYJCXJldHVybiByZXQ7DQo+ICAgIDQzNwl9DQo+
ICAgIDQzOAkNCj4gDQo+IC0tIA0KPiAwLURBWSBDSSBLZXJuZWwgVGVzdCBTZXJ2aWNlDQo+IGh0
dHBzOi8vZ2l0aHViLmNvbS9pbnRlbC9sa3AtdGVzdHM=
