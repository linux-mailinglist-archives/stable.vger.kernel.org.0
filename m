Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AEB3603D0
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 10:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbhDOIFS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 04:05:18 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:60038 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230090AbhDOIFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 04:05:18 -0400
Received: from mailhost.synopsys.com (sv1-mailhost1.synopsys.com [10.205.2.131])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 54F75C063C;
        Thu, 15 Apr 2021 08:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1618473895; bh=8Oxx64TjkloCA1pDyuENDkI8nms/8z5pBzkaAhu7P/Y=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=XMqwE2bW+n0QwbWFaS7eEc0PNrXBYfTMIXpg/v9xu6dH34sELMmJ+6b6fUsA3SFKU
         OHI9Gq7jR9/vFXcLvU0lR37tmrfXMmGBi2K/ehXnWNCjc3f95UiKaDpvKHWcHleMk6
         0GINswYvwk7DxHDstwQ/K8sQxgSh/zduA6s0Diu9wFdK3p0aFV4MOLq1wpK8dimQLJ
         U+ZmXoqbSzPpCGEadOc+Mitk+wMhE9Tuf56Un2jEEZGJ3Wb8BfD9dymISoPGJH9jSS
         u6JTn0yH65YEWJoCGS1LSexzCnh1ZGiyAhy1EVlQKeKOUtIK+eXuLE7UvXi0HSwdKA
         yS4ViislHG6bQ==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 7C981A005E;
        Thu, 15 Apr 2021 08:04:54 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2053.outbound.protection.outlook.com [104.47.36.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id F31F3800C1;
        Thu, 15 Apr 2021 08:04:52 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="DnlhdJQJ";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hiwr1mEki1fK8tP5CRSBWRrxz9yV51huG2FbgyIrdDqfx78BpgHgydlKsCDHjjQhf72lYlLfgQUroXbzPlAF590udMku5Oah+cFdeGwzeZVRJ/OQ39K6FjSFZeAdqDYyjCGXSZ8C++FVdQZ4327PUW+tVhgE/hXlTGPh8jqpIKtLe7rnbNDDl4PwqpkzNtSi7pKuhtjy5gpLFWvbNzyTe6NoxxoLeuDvyDE9SgaqFRmHdSsHLaNwhgEUTZwyiDg40FbjEwZXq69cwiAytp2XA5gEn3K8XIetlhju9YjxQDDrhD15G9QpSCgYg51NELvdY0zzJym9QRkkw1/uRB7f9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Oxx64TjkloCA1pDyuENDkI8nms/8z5pBzkaAhu7P/Y=;
 b=HN6TZvklGk2VUaL/CWmisktcQudbrSuCBbs3vt/jNqtYKxvXfWHFyRZPnuobYPEPuo3GL8h6uKWr7fSrYpFzIxHeg49hcLE2/G0l6lgf/3J4PS3futfV0t8AkQ0gDJ3jgLN9a1d8oO3jgiqs1U/9jd37BApHuUlPuRBGkDRRLdx1g2bLw9ltWtLE9hc+JOQfq9VVoFKPavDndW+i5v3fi33eYSKJetFHB/j3Ob4MPQpoLKBhklPkqHk0DRrjfRiZ4fQcwk7N5biUbNO0bxcOB3AKunQ14jQz23rowxCcxKGFjl0rMO37df+thYb4REjL5jVK5XPoC6OxLMmAHLbX0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Oxx64TjkloCA1pDyuENDkI8nms/8z5pBzkaAhu7P/Y=;
 b=DnlhdJQJFacPRFrhEf1OzedwVcoXEOf9s89JYvc4pjV8QGW9+Y2vDrHVgImif8/OoyUJPi20ucSWMop8ZJBhKz/nRtlQj1fK/4hFyYuy18UJ3z48Y/kSFRL/00YUA3BefIDmOtzglWKyEcAjHZl/uAjvh29E2BXxPwTX0s/bXWA=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BY5PR12MB5014.namprd12.prod.outlook.com (2603:10b6:a03:1c4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 15 Apr
 2021 08:04:50 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c%6]) with mapi id 15.20.4042.016; Thu, 15 Apr 2021
 08:04:50 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     Felipe Balbi <balbi@kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>,
        John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Ferry Toth <fntoth@gmail.com>, Yu Chen <chenyu56@huawei.com>
Subject: Re: [PATCH] usb: dwc3: core: Do core softreset when switch mode
Thread-Topic: [PATCH] usb: dwc3: core: Do core softreset when switch mode
Thread-Index: AQHXMZ5ZpPhhG1Y+NESFNK78+41CJ6q1HFYAgAANRoCAAAwKAIAAAyCA
Date:   Thu, 15 Apr 2021 08:04:50 +0000
Message-ID: <b2f0c24c-62a2-10b3-af37-8a19b0466a74@synopsys.com>
References: <96c64e6a788552371081f37f544041b7ee046ef5.1618452732.git.Thinh.Nguyen@synopsys.com>
 <87sg3snk1l.fsf@kernel.org>
 <c125a30b-edde-8fe5-3370-d9e62a24f7e9@synopsys.com>
 <YHfxAnbHNrjSwLE+@kroah.com>
In-Reply-To: <YHfxAnbHNrjSwLE+@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=synopsys.com;
x-originating-ip: [98.248.94.126]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2ef9a450-91be-4652-0ae9-08d8ffe524f1
x-ms-traffictypediagnostic: BY5PR12MB5014:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB5014643F5056EC23446FC4A7AA4D9@BY5PR12MB5014.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QyRSq9QvCl6zn1xCb+vk7XI7Ykb+i+JtiL7/M6NVCPIeCdgMKAsWwKJeRemGKcHbs6yR57FrCDVCAvz7qRWhFYJXSHSkgdvtmLHiBUSfEFJSdGvmQqa7OaH5euX/doxzThpau/5mcRKZjK7pYoz8k+Wanop6OgcBO05VSd0d+Z8Uu+e1yNABD5os3lLk8HjUgzBTaB+0a1JpGl01gZqOocy18OMenQD50rA8S8eU8FMl9HRBhfHhEbORKfxfpn0q17DUah+lV6hopUqvF+CVaFcCUnjGTYI4pS0AFoz5VNgrGDnjrmWXaZqETEooyqtkEk/OI2XYYIZ6OLc2K4C/msowuKEMKlJi/yI1ERIRA3gumWzAvoT14kFFP6HP+VliQBdqEUzC1o+5wnLypYC5yL3K6u3m5QGH7o0y6vdKKVN6hW5NV2oC4DVoVoHSuF23KdR4IWLWnuXEgmNRvm0U9Np7AcDyjOVRWLpnkrXu2yJMl8hMJ6W31/oxJx9RH39HzKXeCMQOcjHjSTb8Vo61E0GIRqif8tfuA7Y0AUkfhruSjlZ8lYDPO64sBsA1lmIzqLARezxw4nsARXK800i8iNXS7M0F7z7LpNhUJizYUntiDcWbC6caUkS9EpKqpUPzExFTo9ZzTJSYyLFls81aJlCt9K7+HtgKYabGTUT9XL+KYRoxlF9WSj8a/cqvq5GY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39860400002)(396003)(376002)(346002)(31686004)(186003)(316002)(478600001)(31696002)(54906003)(110136005)(122000001)(86362001)(83380400001)(4326008)(26005)(64756008)(76116006)(7416002)(8676002)(2616005)(8936002)(66446008)(6512007)(6486002)(66476007)(66946007)(66556008)(5660300002)(38100700002)(36756003)(6506007)(71200400001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?NTNsOERxZkw2NVIzSVV4VSt2MWR1a05IeGk5b3lhRmtwY285N1htb3pTWWQz?=
 =?utf-8?B?Z0JsdEpHaFArbkhPbG5WN21QOWQ5OGFGMGlGaWlWT0hOemhBaDlaS3JNOGhl?=
 =?utf-8?B?VkFxYmpzQ2RQOUhWc3FHeXlPS1BUaDc2Tk96SDFSZG5kNjh5bjJqaGJDT1pm?=
 =?utf-8?B?dy9uYkFwb1R3ckhHZThiY1VBeFBlajBFeTNucGNmNzk0dWNlS2c2UmsrelMr?=
 =?utf-8?B?aUFmNEQxR1MyaDBwcUkzdmIvRDJtdVBVNXVjYW42bS9Ha0xBbmhaRmRLallz?=
 =?utf-8?B?SWdOSVM0S3h4RTBzdTd6Z3lXRHBUbGwzeWd5aXg1SVlKUFJ1aEZUdVlPOExH?=
 =?utf-8?B?d2tock1OeXJ1TjJIdURxaStsdDBycTZEQlFLbXh5dHYyY05HdHB2TzE2VWl4?=
 =?utf-8?B?OEVvT3lUdStTaDFDZlFyYVZreTdKc2ZRaWFoNXJJbmhPck8rVUVvSmRLOUcw?=
 =?utf-8?B?NUVpS1prVkZVa0xsN3FEbzlkRVNCbmJteHV4QlhOV0ZOc3UzbElkQjJpU3FR?=
 =?utf-8?B?UExPaEJxNmR0VGUvRnlSa1VidzNram1Fakh1eTAyaTY2RW8yMnZFNE4vOE5R?=
 =?utf-8?B?dUw2dFhNL05LL212ak1teDZaSjUzaXh3R1Z6eUdWVjhVdENWQ0R0MXU4QXlp?=
 =?utf-8?B?UkQ4MXhyTE1DUUNpd29VR1IzanhLTU9xVmVzRk15MlRPWXJKUnlFZkxIVFBC?=
 =?utf-8?B?TDZOcFExWVBzSkxEV3IzRXNPcmFzS3hzcW9IditCZ1VBdUJucmI3d3lSYVpU?=
 =?utf-8?B?K1FXWndCNlVtZHU3eThzSGtLRGhVNkhZc04xRjNFTXVHRFo4Wjd1RVNrOTBH?=
 =?utf-8?B?QWF3aHkrQ25Wd2dEV0NKUjUrMk84Z2hBRDErL29yekZvd215bGQxbVFhRXNv?=
 =?utf-8?B?QjI5bStFSlRrUThhWm9LZGE5czJHdmdFU3dEOFFMVjhsTzdzWlBzazg0Qkhr?=
 =?utf-8?B?bkh2dzVIamd2YzJ1eStVMVJ6R2UwTTVQQlJlK09YVmZnMGV4SStHTnBjWUc0?=
 =?utf-8?B?aEUvMUt5NUFOUURjZ2VvTDU4VnIzbUZDWkk0Y2V5eGVCTktJeEJENGZMaEFh?=
 =?utf-8?B?K1Y0QU1DSXVLaG1oM3ZaWFpPRy9qaTVwQmlXdmtWS0JwL1RWY1hMZFdqUWFj?=
 =?utf-8?B?anNiOWNCNkhSWXgxUitCaGhSY01BSnVUUmZoUkZtUDREd3JKZ2lReGx1NnV5?=
 =?utf-8?B?K0dSU21Ja3NzdFEvUXl4SWExWVljWFpVdDA0Q1poay9rd09UamdtNHVza0hW?=
 =?utf-8?B?N21aeGJhRWgrMmZib2pMMS8yck8xWHRIYVVCNndDazlxYUtqa0ZtUHFVMEpF?=
 =?utf-8?B?RVRvcDcxYm0vZWl1NE1MT1ZmMWhGQXQwWFcwZnVVUmprb2R3aW5nenRXUjly?=
 =?utf-8?B?d3FSdEErd2tlU1VkVXFXTjFUNk1WemE5ZHk2ODFSY0syTXpjQW9CdXVxWHVt?=
 =?utf-8?B?ckIreFEwbU54YnBkcDJFR3J6OVNMWFoxamoxRmVlNkNxSjF1Ry9OdWVuRnIz?=
 =?utf-8?B?ekhCS2hMUC9SeTF0Z0FpdDdmL0ZmQ010MWxzTi9NZzFYZWgxa2RQVTlZZ25P?=
 =?utf-8?B?cGpkVUdaWktSZVZoaS9EdjJRclhPWjFMdmVJZzRvUjA2dktCSWM3QXBlOEEx?=
 =?utf-8?B?clJHbXI3K09sU2E3ZnBwaUJ6RzJLczMvMlpxVHB2cnU2VHJrRWpNZnJ2Q1p0?=
 =?utf-8?B?bHNGWU9XQnlEb01qT1J3QUoyVkNYbWMwNmQ1Q2lkWEZncm00MXRWb2ZiWGtW?=
 =?utf-8?Q?KO7l+leBV7umFWJeNTwcRcTAz245qVCdk5qnd4W?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <368BAEE540560D4AAA29378C28C7A74D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ef9a450-91be-4652-0ae9-08d8ffe524f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2021 08:04:50.3136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qJZ+x9rJXdNouVxdNODy89z8dKwaDdKs3zygLxdkQ+uuL7xHL+rfaoeGI2j73R0GdZT0LKLLkCiOlXzF4h+TZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB5014
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

R3JlZyBLcm9haC1IYXJ0bWFuIHdyb3RlOg0KPiBPbiBUaHUsIEFwciAxNSwgMjAyMSBhdCAwNzox
MDozNEFNICswMDAwLCBUaGluaCBOZ3V5ZW4gd3JvdGU6DQo+PiBGZWxpcGUgQmFsYmkgd3JvdGU6
DQo+Pj4NCj4+PiBIaSwNCj4+Pg0KPj4+IFRoaW5oIE5ndXllbiA8VGhpbmguTmd1eWVuQHN5bm9w
c3lzLmNvbT4gd3JpdGVzOg0KPj4+PiBGcm9tOiBZdSBDaGVuIDxjaGVueXU1NkBodWF3ZWkuY29t
Pg0KPj4+PiBGcm9tOiBKb2huIFN0dWx0eiA8am9obi5zdHVsdHpAbGluYXJvLm9yZz4NCj4+Pj4N
Cj4+Pj4gQWNjb3JkaW5nIHRvIHRoZSBwcm9ncmFtbWluZyBndWlkZSwgdG8gc3dpdGNoIG1vZGUg
Zm9yIERSRCBjb250cm9sbGVyLA0KPj4+PiB0aGUgZHJpdmVyIG5lZWRzIHRvIGRvIHRoZSBmb2xs
b3dpbmcuDQo+Pj4+DQo+Pj4+IFRvIHN3aXRjaCBmcm9tIGRldmljZSB0byBob3N0Og0KPj4+PiAx
LiBSZXNldCBjb250cm9sbGVyIHdpdGggR0NUTC5Db3JlU29mdFJlc2V0DQo+Pj4+IDIuIFNldCBH
Q1RMLlBydENhcERpcihob3N0IG1vZGUpDQo+Pj4+IDMuIFJlc2V0IHRoZSBob3N0IHdpdGggVVNC
Q01ELkhDUkVTRVQNCj4+Pj4gNC4gVGhlbiBmb2xsb3cgdXAgd2l0aCB0aGUgaW5pdGlhbGl6aW5n
IGhvc3QgcmVnaXN0ZXJzIHNlcXVlbmNlDQo+Pj4+DQo+Pj4+IFRvIHN3aXRjaCBmcm9tIGhvc3Qg
dG8gZGV2aWNlOg0KPj4+PiAxLiBSZXNldCBjb250cm9sbGVyIHdpdGggR0NUTC5Db3JlU29mdFJl
c2V0DQo+Pj4+IDIuIFNldCBHQ1RMLlBydENhcERpcihkZXZpY2UgbW9kZSkNCj4+Pj4gMy4gUmVz
ZXQgdGhlIGRldmljZSB3aXRoIERDVEwuQ1NmdFJzdA0KPj4+PiA0LiBUaGVuIGZvbGxvdyB1cCB3
aXRoIHRoZSBpbml0aWFsaXppbmcgcmVnaXN0ZXJzIHNlcXVlbmNlDQo+Pj4+DQo+Pj4+IEN1cnJl
bnRseSB3ZSdyZSBtaXNzaW5nIHN0ZXAgMSkgdG8gZG8gR0NUTC5Db3JlU29mdFJlc2V0IGFuZCBz
dGVwIDMpIG9mDQo+Pj4NCj4+PiB3ZSdyZSBub3QgcmVhbGx5IG1pc3NpbmcsIGl0IHdhcyBhIGRl
bGliZXJhdGUgY2hvaWNlIDotKSBUaGUgb25seSByZWFzb24NCj4+PiB3aHkgd2UgbmVlZCB0aGUg
c29mdCByZXNldCBpcyBiZWNhdXNlIGhvc3QgYW5kIGdhZGdldCByZWdpc3RlcnMgbWFwIHRvDQo+
Pj4gdGhlIHNhbWUgcGh5c2ljYWwgc3BhY2Ugd2l0aGluIGR3YzMgY29yZS4gSWYgd2UgY2FjaGUg
YW5kIHJlc3RvcmUgdGhlDQo+Pj4gYWZmZWN0ZWQgcmVnaXN0ZXJzLCB3ZSdyZSBnb29kIDstKQ0K
Pj4NCj4+IEl0J3MgcGFydCBvZiB0aGUgcHJvZ3JhbW1pbmcgbW9kZWwuIEkndmUgYWxyZWFkeSBk
aXNjdXNzZWQgd2l0aCBpbnRlcm5hbA0KPj4gUlRMIGRlc2lnbmVycy4gVGhpcyBpcyBuZWVkZWQs
IGFuZCBJJ3ZlIHByb3ZpZGVkIHRoZSBkaXNjdXNzaW9uIHdlIGhhZA0KPj4gcHJpb3IgYWxzby4g
V2UgaGF2ZSBzZXZlcmFsIGRpZmZlcmVudCBkZXZpY2VzIGluIHRoZSB3aWxkIHRoYXQgbmVlZA0K
Pj4gdGhpcy4gV2hhdCBpcyB0aGUgY29uY2Vybj8NCj4+DQo+Pj4NCj4+PiBJTUhPLCB0aGF0J3Mg
YSBiZXR0ZXIgY29tcHJvbWlzZSB0aGFuIGRvaW5nIGEgZnVsbCBzb2Z0IHJlc2V0Lg0KPj4+DQo+
Pj4+IEBAIC00MCw2ICs0MSw4IEBADQo+Pj4+ICANCj4+Pj4gICNkZWZpbmUgRFdDM19ERUZBVUxU
X0FVVE9TVVNQRU5EX0RFTEFZCTUwMDAgLyogbXMgKi8NCj4+Pj4gIA0KPj4+PiArc3RhdGljIERF
RklORV9NVVRFWChtb2RlX3N3aXRjaF9sb2NrKTsNCj4+Pg0KPj4+IHRoZXJlIGFyZSBzZXZlcmFs
IHBsYXRmb3JtcyB3aGljaCBtb3JlIHRoYW4gb25lIERXQzMgaW5zdGFuY2UuIFN1cmUgdGhpcw0K
Pj4+IHdvbid0IGJyZWFrIG9uIHN1Y2ggc3lzdGVtcz8NCj4+Pg0KPj4NCj4+IEhvdz8gQW0gSSBt
aXNzaW5nIHNvbWV0aGluZz8gUGxlYXNlIGxldCBtZSBrbm93IHNvIEkgY2FuIG1ha2UgdGhlIGNo
YW5nZS4NCj4gDQo+IEFsbCBkYXRhIG5lZWRzIHRvIGJlIHBlci1kZXZpY2UsIG5vdCAiZ2xvYmFs
IGZvciB0aGUgY29kZWJhc2UiIGxpa2UgdGhlDQo+IHdheSB5b3UgZGVjbGFyZWQgdGhpcyBsb2Nr
Lg0KPiANCg0KU3VyZS4gSSBjYW4gbWFrZSB0aGUgY2hhbmdlLiBUaGFua3MgZm9yIHRoZSByZXZp
ZXcuDQoNCkJSLA0KVGhpbmgNCg==
