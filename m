Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB9C01C314D
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 04:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgEDCNM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 May 2020 22:13:12 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:40632 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726419AbgEDCNL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 May 2020 22:13:11 -0400
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6E0F8C0540;
        Mon,  4 May 2020 02:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1588558391; bh=9QYrX7F6pdt6g4WNawhW0eEQDO4kWw3QZcn991yRz08=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=PtooWiXqw8/ae+ivcvOh9cT2FzT4uCHCqm/t/TqweZsSTuC869bZR2votU2bMnMmZ
         pcDssWX8AkXBf8r3X8EHvdQgKkOF2L3G4XlMNEJVNVSVJ5gPV1rp50XJY7VgYLMMpB
         gYW+nNGxWSOid0HRdSmFPtzSeGlTDa83lKYiaRu1Gs767L0pG0ICOM19AliSioL3vS
         qf05LwJbb7QhFATLc+XERNA6YFvabk9uN2lfcuObfVFLCBdKBY9YI+AbT9AtAXEXfk
         XaxMTKJ+saJvh01b2OMxqFNl+cQYPt0jiZ1Av0h8Wg83Lu/SXUO41j/hoCce5Z8qC5
         cos5naTGECuaA==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 9CCB8A006E;
        Mon,  4 May 2020 02:13:09 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.200.27.51) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Sun, 3 May 2020 19:13:09 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.200.27.51) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Sun, 3 May 2020 19:13:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ewux/+NMcHgBIlUOPDRJsFD6yd5VM1MHfA6oo2RDjD3uHgoz8+NpBQoNV1yyMjzWxDq2vws8Ml15wzQdjbmFGMxEqxTWVuyOngsZLy0OgZOOo9TowkmAMExNzDg3jO56zbEIfwHRCebEqhy2BMYqFD5yb9JmHdTw+E/jtB98A0c7dYPz5Re0Qg6iLr9s/E3rbPKn/Sp5/+4qnUYhezyDp3xMaJpFMF10jwPbwvNS68zeTvqyexoRBUO+cFy/G0WiccRdHgym3W6dLMeKDyyke8u2PFbCND8o/PvfnTZ61RFeI2bUBgUqFFdDzhvvL0QOgMzh64x1gSVRSiwNe9QWBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9QYrX7F6pdt6g4WNawhW0eEQDO4kWw3QZcn991yRz08=;
 b=jhQioGejYVSDs67AV3UqIC/5ZqpU4ECmMLjaT11K5zVJQwLHguxjHaEhaOXwpWfOT88AKn4JcoFmD9N6rrkLPwX672kE/qUT1gFVF+jh+/70IS73QKdL755gJwND4JBPxji3QRsn3+WfchEToSBDcJvH3r4vhJamkNKloORnWElsuUvh3aAHWoozjfIGzAWgkGXJXsh9LUK4wDrvzd2ItlaKZ8YAbU+8DY5uVHeKSzbVkVqvRB1pHHpvu1Um9zWuwOh1dllyL4PACXYkwXQBKbFGOFmfyM2mGariOLxxvU7C55UKOLQm3++MAjX1BWa5MuP0oQJb2IDmLoPX8eqP1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9QYrX7F6pdt6g4WNawhW0eEQDO4kWw3QZcn991yRz08=;
 b=esi5HDqRQVx8MV7rc/+cd+YUvuiUxMXKPKxri8xV82yOyyTWKmf5gYpr10dSVXy7I0rYsJjcLueVXf0gkmNO1zv6i+nR7o6lvcTSGdun2kq1P4j7pb0q0jFJCTqNutDIQ65HeApasNxXVE8efd9sgaYQr/+nPzJ3aF8y1Z5jnDM=
Received: from BYAPR12MB2917.namprd12.prod.outlook.com (2603:10b6:a03:130::14)
 by BYAPR12MB3192.namprd12.prod.outlook.com (2603:10b6:a03:139::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Mon, 4 May
 2020 02:13:08 +0000
Received: from BYAPR12MB2917.namprd12.prod.outlook.com
 ([fe80::3860:a61:5aeb:a248]) by BYAPR12MB2917.namprd12.prod.outlook.com
 ([fe80::3860:a61:5aeb:a248%7]) with mapi id 15.20.2958.029; Mon, 4 May 2020
 02:13:07 +0000
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Anurag Kumar Vulisha <anuragku@xilinx.com>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: gadget: Don't setup more than requested
Thread-Topic: [PATCH] usb: dwc3: gadget: Don't setup more than requested
Thread-Index: AQHWIBsJPSxG1MKpvkmFNaRaXNMgP6iXMuOA
Date:   Mon, 4 May 2020 02:13:07 +0000
Message-ID: <1f7268ec-d0c1-343b-582d-f753ee49a5e1@synopsys.com>
References: <7685ba14eaa185a170d6c4c9668d2ad98eeb8b14.1588380090.git.thinhn@synopsys.com>
In-Reply-To: <7685ba14eaa185a170d6c4c9668d2ad98eeb8b14.1588380090.git.thinhn@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
authentication-results: synopsys.com; dkim=none (message not signed)
 header.d=none;synopsys.com; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [149.117.7.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4daed0d0-efce-4ee0-5f1a-08d7efd0afe3
x-ms-traffictypediagnostic: BYAPR12MB3192:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3192D2C34BCC636EC361F4C0AAA60@BYAPR12MB3192.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-forefront-prvs: 03932714EB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +w67Llsq9v/JvA4oxF6ZnO8KjHf6rnd7q/qY03eswBk6TWtKMtSS9PBkM2U0maGuKJrgHW88uJ36qeFbEQ95B7NO3N2yxGX71ZrBJMEILaltg5f1ItwUzART5WKxt7diDbo/NIJ6wZjokR9kp0qXKTYVPQaeuNDvJa4DqJZ7J3Gh+Z0forMxwpLd2V/mJqwSr181PYxaM9KCuSBqH3fUyY4LTawHcXbnZOtG7EMq5ouR/zdzsJlUB8Hvvd6ORQnC8GNnzesGHNOA4/TzvOjEXH1yp8wuzSkbLGFhtlGNPnB/qdOBvP3KFVtG/jK/qyVSkdxHLDCgVnnl5tZ7rjKqJ4ehlwpGr27RF/wzV25zSh1BnsmZDQ00kiA76mVVLvYvgEUteUnHBTONwKmpveAW6ZTBgxD75Ob+cU1OdgoFyoAl75jixx4c4xXUGYti0IzG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2917.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(346002)(366004)(376002)(396003)(39850400004)(54906003)(110136005)(71200400001)(316002)(4326008)(66946007)(66476007)(66556008)(64756008)(66446008)(6512007)(76116006)(2616005)(31686004)(478600001)(36756003)(2906002)(186003)(6486002)(31696002)(86362001)(8676002)(8936002)(5660300002)(6506007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 5skunKxh/ghpz7pWN5oXDAYOTO2YAAVbxAa0Z4azaXt8xCcvYxbl94F+j9jMvMeuDdzjuAej4t0mBPGAWvcJapV93hgDyxBn2wKS9Zx+70+cs2oCeIFcE1bJ4Lgz/2qfVgymYInKT/kOpUyi85WP60Ui+YDOMuxQOITjf4+rY24AswSr4DzFLrLACRn2kZRXwcQzmesVCqRYWwYurkT4yueZ2HzzjTrA1SozSdlNc+XbG357LI2YR3LLYJQsyfwF4q83z987wtxzdHFCl4KaqjKwKjrOp4FtNBGSYGT8Z94ajQjfUSzPt0AdNcKshXxy8O2405SZ4XmF0x2FGmw//YhyUrXr7ct3zXzImrlcKgbc74W2mznplr7HLYJ9RO8gSdkFU8jlhjvGJZI2jbun0dA6OGYJS0G0zDkhTmiCrlOvfu6NT2K30z3lfR55gCYqJBEFY+GF2HovKiVGsYl+K26o46PSS7TTHM6IAXllDm9G1dT3ZJw/6wpxDo5RLy7j+Qjk9odgbBWrzmBhZAV6N2rXwsBziXfW/uYuj/k/acvx7Pl7IBG9oPaQV4PXcXvldJK6Ods2+tlhW/0PW1qYQq+yYzXRA8bFu5U8ZT4iUyzqkn4vewthyjKzsmjikVezjU/955DM7/aXSzjX0RyIVg+bagIrpSTvMLCuTix5W5oL0srqx0W1KqBxVWXt8de9QwPG7x2bh+/pqL67R5cQP7OkdaL+qrozApCg9NK1xRDdswKrEuTIpDZFdwRVnodCSE1Hw8S9nTGAgTloz9btEeUrJgqNAWkjCZBYEbnDky4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <794D01177E4751418E1264BE024FA11D@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4daed0d0-efce-4ee0-5f1a-08d7efd0afe3
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2020 02:13:07.8924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vt0XRMFnFRfhcLSmdfOlOy/+BZoyZU0i5VONMkid8DNX0ept6tsKXKS38EuTtX5pb9QfC+78iU0l+0oPsox07w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3192
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhpbmggTmd1eWVuIHdyb3RlOg0KPiBUaGUgc2dsIG1heSBiZSBhbGxvY2F0ZWQgbGFyZ2VyIHRo
YW4gdGhlIHJlcXVlc3RlZCBsZW5ndGguIENoZWNrIHRoZQ0KPiB1c2JfcmVxdWVzdC0+bGVuZ3Ro
IGFuZCBtYWtlIHN1cmUgdGhhdCB3ZSBkb24ndCBzZXR1cCB0aGUgVFJCIHRvDQo+IHNlbmQvcmVj
ZWl2ZSBtb3JlIHRoYW4gcmVxdWVzdGVkLg0KPg0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9y
Zw0KPiBGaXhlczogYTMxZTYzYjYwOGZmICgidXNiOiBkd2MzOiBnYWRnZXQ6IENvcnJlY3QgaGFu
ZGxpbmcgb2Ygc2NhdHRlcmdhdGhlciBsaXN0cyIpDQo+IFNpZ25lZC1vZmYtYnk6IFRoaW5oIE5n
dXllbiA8dGhpbmhuQHN5bm9wc3lzLmNvbT4NCj4gLS0tDQo+ICAgZHJpdmVycy91c2IvZHdjMy9n
YWRnZXQuYyB8IDMgKystDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYyBi
L2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4gaW5kZXggNGNhM2UxOTdiZWU0Li45NWVjMzll
NDI0MDkgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4gKysrIGIv
ZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYw0KPiBAQCAtMTA0MCw3ICsxMDQwLDggQEAgc3RhdGlj
IHZvaWQgZHdjM19wcmVwYXJlX29uZV90cmIoc3RydWN0IGR3YzNfZXAgKmRlcCwNCj4gICAJdW5z
aWduZWQJCW5vX2ludGVycnVwdCA9IHJlcS0+cmVxdWVzdC5ub19pbnRlcnJ1cHQ7DQo+ICAgDQo+
ICAgCWlmIChyZXEtPnJlcXVlc3QubnVtX3NncyA+IDApIHsNCj4gLQkJbGVuZ3RoID0gc2dfZG1h
X2xlbihyZXEtPnN0YXJ0X3NnKTsNCj4gKwkJbGVuZ3RoID0gbWluX3QodW5zaWduZWQgaW50LCBy
ZXEtPnJlcXVlc3QubGVuZ3RoLA0KPiArCQkJICAgICAgIHNnX2RtYV9sZW4ocmVxLT5zdGFydF9z
ZykpOw0KPiAgIAkJZG1hID0gc2dfZG1hX2FkZHJlc3MocmVxLT5zdGFydF9zZyk7DQo+ICAgCX0g
ZWxzZSB7DQo+ICAgCQlsZW5ndGggPSByZXEtPnJlcXVlc3QubGVuZ3RoOw0KDQpEb24ndCBwaWNr
IHRoaXMgdXAgeWV0LiBUaGlzIGNoYW5nZSBvbmx5IGNvdmVycyBzaW5nbGUgU0cgZW50cnkuIEkn
bGwgDQpzZW5kIGEgdjIgYWZ0ZXIgbW9yZSB0ZXN0aW5nLg0KDQpCUiwNClRoaW5oDQo=
