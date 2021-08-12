Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42ADC3EA410
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 13:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237075AbhHLLw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 07:52:26 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:57428 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S237050AbhHLLwY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 07:52:24 -0400
X-UUID: 28db4f2661534bfc82978398dd98e7d3-20210812
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=o5yQE89gdYCYu7eWqzFOm+rxuVOn4wsz8C3jYhE/fLY=;
        b=b+F+oEpqu8kkucuyH6NElqg7QlGBou/YQaPSnTAk68VIiULLHC/SI8BP5J1J/7EIweoIoKEtTFYznSkUhGDdu1C9dN16k//xI5xJeUxp1TwyO8+KjUgzi9V5uxcOySUPhS7b0ZpxhaQFlZdqyffchlpO0+W4H+2/TALKowELF2I=;
X-UUID: 28db4f2661534bfc82978398dd98e7d3-20210812
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw02.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1757579713; Thu, 12 Aug 2021 19:51:45 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 12 Aug 2021 19:51:43 +0800
Received: from APC01-PU1-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Thu, 12 Aug 2021 19:51:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5M/mnKPL4ge8Dq2rH9Q5DX9ORVB4Ryv6OXJMx+TKYYIZkRg6boYnArXS5rKAVlR6n0AFgeWGebim1fcvX7LJN8x850zdhy3xDf0QB9EGAI4OTYrqf7nH4RYTFbmYfa3yCbZs6wPYdK41gmNbVRczHtgwv/axfbb2wT6HabHyShWiJOBjEXpVfD0IrX2lqkwFLLdWmcw3rl9RPE+l7YxV3PZ3gRfsOlWeUHhJPngXBZaed41QR+6cypWOVoINix4rdpFMP2NniMeg5LZZujr4x8jQPROxTxguDSwPaxq+j4JiB8ESc7JrY0sRYIMPj0ps6/Z0ZOjqQV+om5CqtgipA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5yQE89gdYCYu7eWqzFOm+rxuVOn4wsz8C3jYhE/fLY=;
 b=I10drTLpATRvHBMP1CqVpTF0YEjjfwEdKTUynjMSlUpG77+9oY3gmHILeYm9OLjhXmrSs2VTlBOSxNJ0vtr2zpl5MCECXcjRiubJtI6TNR36uZH5LSVxjywJab0ri0/atQ3as5UFZkg5de+Z8nFaXALaOKQtJvWfSxyOjoVg+HbdzZQ7nTRu1F/pb+NMqhRjtgL/Zs/61WLt+Atspjq3C+ms2iY0xKMD15RdOS0GKm3YeHVMfkTMfVOazEgutzFBecYBTKMru/J1z9Tbi1U8ALnBoTNQFq6+u+rwfbuC0iiD0d9EgFoH1dsYbBokfAb5Mzvz3CgvZraArjQFLLDEnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o5yQE89gdYCYu7eWqzFOm+rxuVOn4wsz8C3jYhE/fLY=;
 b=c96mMkkluI8lLeH9ThtkTt+AkuY8wWdPGKeGiz7yt27PYOo7ZJBbo3XBJ5m6rXnbG1mVSYXX47fRKeQrrOSNPnA/9v0FuBoNjB8HS4SALrFFWudleGqYp2fDW5CwqGlKfII6MQngsITUsDsimPbHAdzqm79+E/WzRQXKYM6cpps=
Received: from KL1PR03MB5062.apcprd03.prod.outlook.com (2603:1096:820:1a::22)
 by KL1PR03MB6227.apcprd03.prod.outlook.com (2603:1096:820:8d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9; Thu, 12 Aug
 2021 11:51:32 +0000
Received: from KL1PR03MB5062.apcprd03.prod.outlook.com
 ([fe80::3ce4:e30e:bb67:c608]) by KL1PR03MB5062.apcprd03.prod.outlook.com
 ([fe80::3ce4:e30e:bb67:c608%7]) with mapi id 15.20.4415.017; Thu, 12 Aug 2021
 11:51:32 +0000
From:   =?utf-8?B?Q2h1bmZlbmcgWXVuICjkupHmmKXls7Ap?= 
        <Chunfeng.Yun@mediatek.com>
To:     "balbi@kernel.org" <balbi@kernel.org>
CC:     "rikard.falkeborn@gmail.com" <rikard.falkeborn@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jonathanh@nvidia.com" <jonathanh@nvidia.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
        <bcm-kernel-feedback-list@broadcom.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?utf-8?B?RWRkaWUgSHVuZyAo5rSq5q2j6ZGrKQ==?= 
        <Eddie.Hung@mediatek.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "alcooperx@gmail.com" <alcooperx@gmail.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "christophe.jaillet@wanadoo.fr" <christophe.jaillet@wanadoo.fr>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>,
        "pawell@cadence.com" <pawell@cadence.com>
Subject: Re: [PATCH 2/6] usb: mtu3: fix the wrong HS mult value
Thread-Topic: [PATCH 2/6] usb: mtu3: fix the wrong HS mult value
Thread-Index: AQHXjyrcTkb2UO5pUEy9TCMupU/7gatvbhcAgABUXAA=
Date:   Thu, 12 Aug 2021 11:51:32 +0000
Message-ID: <f9b8b57550dc1f368d035e437fa8530c59c6576e.camel@mediatek.com>
References: <1628739182-30089-1-git-send-email-chunfeng.yun@mediatek.com>
         <1628739182-30089-2-git-send-email-chunfeng.yun@mediatek.com>
         <87pmujyx5f.fsf@kernel.org>
In-Reply-To: <87pmujyx5f.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 371173f8-dd6e-42ab-c637-08d95d87877a
x-ms-traffictypediagnostic: KL1PR03MB6227:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <KL1PR03MB622714DD7AD2105782F8EAADFDF99@KL1PR03MB6227.apcprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M1seEP80guyvJKiRFZE22MoaxZyXK3CaRNl8tJG/XI7AN1ONOeuWwiRuKRo6WOLIWkBN0fMyfdQ/T6I14GVk6szSpRb/Ex2Mcl7zMudiafkAWZL+1du88j/hZbOVEfqF5kbPDGN+6rjrH69Qga/iVbPV3zjIQIjqtKnS1SxjGjCOOC9cmE/Bt51kfUbC/08FSXQTrAvRZdodFnax1+PRfP5Rc4NrsCrTZuI2ByxUbtkaZxhHhkaC4Msn0QS1FPzaqLlr+4cwBfJCSrXrH/w1pT6l0VgzTM8kVMT3Hzij8La+hZkFygInUcxVRxBMydd36iaSgnhYlFPSvfevy63mJuqRPPRyiF21HSnBADHJ22HO00rGQihYfKpDFs1TagOLjSmgz/LowEtXMXguAH1bz6X3ofMDcXwRB2ZPOA+GFc2uEbECXgHJuxNv/4QjTKLhQ5qD2NDNtRjcuvnHUx3Wsn3aGpSJS9+obVMyt+B4KgMicidfmR9iYmgsYU4hgTA4pR/PukNHO1aHTlApYzr006LacK9AXNKMZ9YzVXsBei7j5cRBjlq76S6hUUlyjCpnRRaGnA6MX9pEHDg3vi7QhDzpGl6DDAdn7IkUnc1nQhPbXteAj7yeXT3gNfBHtJzLhgHrxAIbz6U4Amtpa2vKWi8OP0QE6DIJAtT1dKrxtdT5fUNMDO4N8kc0hKGNIErxv2jQb4cuQkJi/CPhRdP7xA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR03MB5062.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(86362001)(66946007)(85182001)(7416002)(6486002)(4326008)(2616005)(6512007)(316002)(26005)(36756003)(6916009)(91956017)(4744005)(66446008)(54906003)(5660300002)(6506007)(71200400001)(38070700005)(66476007)(64756008)(186003)(66556008)(38100700002)(8936002)(508600001)(8676002)(2906002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ajNqU1kwMzNaK0VNeFFMNThwdEJFUWVFU2doMmdPdDQ5Q2x2UEk3R1E3WWVX?=
 =?utf-8?B?YlB0bjBocEVyNE5JS25vN3hQNDVmYUlDanlHKzRTTE15bjlXV3VEZFFHSVhK?=
 =?utf-8?B?L0dEa0trdDk2R0dLRXJBRlF2NjJNa2J0TWFMWGc1RkpMVTZINElLQnN5U0xS?=
 =?utf-8?B?cTlocllMWWhJUlcvL29RVUl0YndqWXFzcHFNYU5lbTlSQ1V0TXlGRklJcGxr?=
 =?utf-8?B?a2JYUEZMZ2Uyeko1MXRGN1JYRXRaUU5kb3N4dXJGaVZkM3kyNnErNU9SU2wz?=
 =?utf-8?B?blpoazc3ZDEraVRGaExnVTdEZWxtMWI4T2FSVS9XaGw1ampsV0YweGwxTjJQ?=
 =?utf-8?B?OEN2OFRWVXBCZWRIdkxQdGh4NVRzWTY4WE9MRTd4Y0hKb0dpazE3Y2JESVNh?=
 =?utf-8?B?QVRvQWtvTTBCZ1VtcXEvazllODkyU1lla3VPaStOUm80OHpjQlpMLzd4ZTQ5?=
 =?utf-8?B?TlFESVpmcGQxY3FiOUIvbWZKN280M29zZEIzTWFkeGxXMjlQdG9IUWxSL0gv?=
 =?utf-8?B?SDJsSGNTTkdGOWhLbDlSYjM5Zzd5VVd2R0RFd1RpNEwyUktwSXBxdldmWVNq?=
 =?utf-8?B?bHV3UFZGNjFtTnRLZndnMm51QUVTZlE1a0RCRWJ4aXhZRU1yVlE4a0ZlL3Zm?=
 =?utf-8?B?NzlzY3F2WEFITm9Nam1hVkxJS3huekhxRDNMZ2IyMElISVZqeWxNdEdzUlYr?=
 =?utf-8?B?QVNZL0F2anJ0eVJTSWhTelRjR3RLbFpIZVkvMlE1SlhyZjBhV0c1bENsb3Uz?=
 =?utf-8?B?Z09GN2IycnZkK2pBbTljQTcvT2VNWnNxckJqNW55MEpsaGlFeWVYOENNWFhj?=
 =?utf-8?B?eW4zQm5mbVh1VmtnbmlYaFVMN0Z0UmlNcTEvV2hSdnBNMnFaaExrOTVyNmt5?=
 =?utf-8?B?ZS9qNjFQSFRDNUhmdTV4UTNldkxWN0gyRGg4L0RsNkVVRDNnamptVVRyR3pP?=
 =?utf-8?B?cHdmZUUrYVVBdDZXYTBVVWY2OU5OTlg1RUVGS1BjRWljcVE4YUpRaHlpaUlZ?=
 =?utf-8?B?RHNVVDg5LzhxYzhjRXpoUG1OamgrZ0FOa2VXVFJVWEdTaVNEbGxjd1hNRUNx?=
 =?utf-8?B?aENFZDBlaGV1OHdCajhJN3gzK0FoQjliS0QrLytIRUY4bklkMWNVSW9EdWIw?=
 =?utf-8?B?dzE3SlpVWmJhdW8xdEZuODQ3L3FQSWtBckZVOWlVUFhlcmN4bHZCWWZKZVVQ?=
 =?utf-8?B?RDBZcmk3YTBjUW05Z3JQdUtMQ09KaFM5NzFNcHpOWGFKZE5MSEoyamRzNk1u?=
 =?utf-8?B?Y3J3b29BbVNtSnJjNEluWjh1d0lwSzJ0NnVZVk9Ea0FJQ1lqUThGeXFhQ3du?=
 =?utf-8?B?QjluRjg3cXdmd1NndXo5WHQydVJpOWJoN2tPcHVWMFNUWWhpZnArWm94b09D?=
 =?utf-8?B?RGZJd29oVFVyN1NraUlLNTVDU203OFF2VTF4MlhwMzh3MTFHL2s0akhhbDY0?=
 =?utf-8?B?bDgxRjVyM05hWTRWNGhLK1JYU0I5L1l6a3ByRTlEbVZuaUtGOTJ2a1hQMjZk?=
 =?utf-8?B?bkJxRnVhajZaeUNhMXI4UGZ2cFhTSHNyaHdvZTRsMnBZNTM2b3FTU0k4a1Vj?=
 =?utf-8?B?Q2d3eVhKaVp3UDRvQXppcjU4M3J4dDduZmVPSU03czM0YWJWMTRCMTVlbFha?=
 =?utf-8?B?Z3F6YzBEOXp3clgwSWpOdWtHMTBEVGNzeDNFbHViQTJndVE3RFhzV1ExRGFu?=
 =?utf-8?B?Zk5iL1FOWGdaK1V5eUZKbWRlK0ZpZXIvZTVRMm52MEp1UUtJUmVrN0dCV3Bp?=
 =?utf-8?Q?BJE2EUyQIsdiMElTwpLKesM3iXpKDAYovyxxiOB?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <16F41DC3929F1747B775B09F5AF8B54D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1PR03MB5062.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 371173f8-dd6e-42ab-c637-08d95d87877a
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Aug 2021 11:51:32.2415
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4sOyxwJY3XctjhnuifZZsf1u4iDfpkb2mSZa0w9MTHdFp16E3EBiJyJIPx2uwDUa+qG7gAe/7x11JXQ5IMV5dGZ60qSE2lAkJ3AgaMF711U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR03MB6227
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCAyMDIxLTA4LTEyIGF0IDA5OjQ5ICswMzAwLCBGZWxpcGUgQmFsYmkgd3JvdGU6DQo+
IENodW5mZW5nIFl1biA8Y2h1bmZlbmcueXVuQG1lZGlhdGVrLmNvbT4gd3JpdGVzOg0KPiANCj4g
PiBVc2UgdXNiX2VuZHBvaW50X21heHAoKSBhbmQgdXNiX2VuZHBvaW50X21heHBfbXVsdCgpIHNl
cGVyYXRlbHkNCj4gPiB0byBnZXQgbWF4cGFja2V0IGFuZCBtdWx0Lg0KPiA+IE1lYW53aGlsZSBm
aXggdGhlIGJ1ZyB0aGF0IHNob3VsZCB1c2UgQG11bHQgYnV0IG5vdCBAYnVyc3QNCj4gPiB0byBz
YXZlIG11bHQgdmFsdWUuDQo+IA0KPiBJIHJlYWxseSB0aGluayB5b3Ugc2hvdWxkIHNwbGl0IHRo
aXMgaW50byB0d28gcGF0Y2hlcy4gT25lIHdoaWNoDQo+ICpvbmx5Kg0KPiBmaXhlcyB0aGUgYnVn
IGFuZCBhbm90aGVyIChwYXRjaCAyKSB3aGljaCAqb25seSogY29ycmVjdHMgdGhlIHVzZQ0KPiB1
c2JfZW5kcG9pbnRfbWF4cCgpDQpPaywgdGhhbmtzDQo+IA0K
