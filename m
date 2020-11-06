Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA202A9E8D
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 21:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgKFU1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 15:27:52 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:36558 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728140AbgKFU1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 15:27:51 -0500
Received: from mailhost.synopsys.com (us03-mailhost2.synopsys.com [10.4.17.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A2710C0344;
        Fri,  6 Nov 2020 20:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1604694471; bh=a6KY4C43XvchpirgUitxGKFFPB7MG3vs4MgouK110c0=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=HWhGXwDJroh5XmfWy+oEV6q27tyLI0kv471fL0Tm3hsAwGgIR+IiUe/banc4Af22J
         gXy3UxWuVJldYwEfjvSbgV3nd64LBAPyDuevulRy66mDDrKOunnhO+lgJKkpU1Qd8y
         nIAbIVdoJ2UD2Xc79lic0tOuaHf1KpccPnXQPunogfA7XpV07SfF5tOYTUzoi1V2Ud
         M3t5NBYoKEbto16BjqVTdfdnddsDPPTSS1ZDCLlaxHlV9jroY3WoBHWHLfVhB9F8jY
         ssuA9EDsxbcOKO5dCKFn+TVeUlN7f0lQYtmSTImcUaMCWNW2O0ndEzhELghPKv93JB
         dRI1Iwn3icwOQ==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id D5534A0084;
        Fri,  6 Nov 2020 20:27:48 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "GlobalSign Organization Validation CA - SHA256 - G3" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 94B66800C8;
        Fri,  6 Nov 2020 20:27:46 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=vgupta@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="f2p9rAro";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gfzZyimI7Ui68DapLp5KvWRppXzLnYKE2X9jrmag2xrR2BdTeoRxwU44veYJGh/LRLboaTqBP55Rtt/uE46vXnZApkfIdb0lKFegojUj8NlknkPqDIvBReh+dGMocLr4CD+XWQCms2U6PA4JRS0IozP19ip3hi/wmsOU6Sfgt9ia0FKuUA5aVokQhubETYsKPIInYtiqzXFtyzLnjo54rGwmm/SXiab1y9eSka3OC8JJ0QSa0TA+rvY0ghoAsc5yzL0GTv57Jmlw2JLaGoMdHKgfqe4nkr4ohs4XLcCs7IGaqlJKojVCohb903P1Z+qCdNTzn19Iinn2IPs+H+eXGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6KY4C43XvchpirgUitxGKFFPB7MG3vs4MgouK110c0=;
 b=ZK3sIl5mJU16bqraq+z7ymkKx22d7haUt1XzANb9o4fJvtymiUVJLY1wizjxg2Bx6XrBH1S7kuAC7ZU1e4gYwCbB8jxLjHEXWUO2SaIP/5L8Na8U5LZyrgH4u3DbcP9DmgnrC6+TPwFaflweUN1zsYdaMk3cuiZfx2zDE/vBbuwI+YUQYHSscepS3AyAXsI4F/PRFGMtIbaoiNZfEFE3XLxDsRr+akqjXI92bMINkaZ25pNRhKqujYzB2kIH4WBFJeOzR44VckttWQJYaH2GbD4PuuSibkB9XHqCOsxDzTxA9YF+k2JCrc0NgXM4Mhw2IzC+73jLuLae4fHdFUcpSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a6KY4C43XvchpirgUitxGKFFPB7MG3vs4MgouK110c0=;
 b=f2p9rArooz7oZWbc4zmJbVdwAFVA5xNBc9yz7rrI/e6NjbZGRMhfkOzeQ62/rv7tOWUc0iUsCl4qUiUl6xAw6/4i7kGDZi8b4E1VPxZ8yxGBMM/7N0/Z8JvnZdN+v3Keid+PMIAcPcF6Ni/VFPaHr1GxEP5Onv8P49aQzZgqL3Q=
Received: from BYAPR12MB3479.namprd12.prod.outlook.com (2603:10b6:a03:dc::26)
 by BY5PR12MB4257.namprd12.prod.outlook.com (2603:10b6:a03:20f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Fri, 6 Nov
 2020 20:27:45 +0000
Received: from BYAPR12MB3479.namprd12.prod.outlook.com
 ([fe80::c562:e026:68d6:cd31]) by BYAPR12MB3479.namprd12.prod.outlook.com
 ([fe80::c562:e026:68d6:cd31%6]) with mapi id 15.20.3541.021; Fri, 6 Nov 2020
 20:27:44 +0000
X-SNPS-Relay: synopsys.com
From:   Vineet Gupta <Vineet.Gupta1@synopsys.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Waldemar Brodkorb <wbx@uclibc-ng.org>
Subject: Re: [PATCH] Revert "ARC: entry: fix potential EFA clobber when
 TIF_SYSCALL_TRACE"
Thread-Topic: [PATCH] Revert "ARC: entry: fix potential EFA clobber when
 TIF_SYSCALL_TRACE"
Thread-Index: AQHWpoeFs2lAESMsXEi9RfDQ8a2iPKm7qYCA
Date:   Fri, 6 Nov 2020 20:27:44 +0000
Message-ID: <9cec26bd-6839-b90d-9bda-44936457e883@synopsys.com>
References: <20201020021957.1260521-1-vgupta@synopsys.com>
In-Reply-To: <20201020021957.1260521-1-vgupta@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=synopsys.com;
x-originating-ip: [24.4.73.83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d52aaf7c-2aa9-4ea3-1faf-08d882926b4d
x-ms-traffictypediagnostic: BY5PR12MB4257:
x-microsoft-antispam-prvs: <BY5PR12MB42578FC5F05E5348700FBCA1B6ED0@BY5PR12MB4257.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cEjCbGmP/pEna8fQ+1UIIz7Rf3yPPliUsOeFnVH3x2ODTDPaQpYEIYTj/utPIXF00VQEPNro5M2srskX5FyDtsuC98Tq3eWR5shr2GHOZjjefO5+ESSWydjRuCMx/yayai8SRjk6bJPOG4o/DPgsfxJuiQHAP2/ocfXUjuo4o4PJ4ckgyQpEG1s7goBhxMUX57Jdo5rm500rD8CwNCjj2EExkgWQu0ACDIuAWY/+RWo2Jy5qh4SdmhR/PYHsS0sjkVFtypYdarXTwOGRW7tlJ7zlQ1zSH+n1kB34paStpJCO1bZJXtsR1PT1A8wQR2LTiCEssKoHil9w4PLeZrRFY3Iz9wNGmJIe/ItBwRAzqZ09BYXTiSb/dZhwQ3VvURU5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3479.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(8676002)(64756008)(66476007)(66556008)(5660300002)(31696002)(86362001)(31686004)(2616005)(316002)(66946007)(66446008)(110136005)(478600001)(8936002)(71200400001)(54906003)(76116006)(2906002)(6506007)(4326008)(26005)(6512007)(83380400001)(36756003)(186003)(6486002)(53546011)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 9gz9iu4sJgo/J2PNuYfZuoNT9vJgbUzylczKlN957EeiYfghbHYDEMQq8Dkj7QOI/P2rTUicVMFPH9v5LUBWbTPKiwN+DRkeRKLsXldty8/dCoiaGEcFCS0xETOUWWRO7uLyVSpHF+3Zy7WBVDuxLQisSoZc36kFjM2rTbr63hwI65llO2KbE4jkWZoJ4d5U+XPpLC8tz9JxiKDJI9g7g9w/7O3mx2j0hYGuzTCcAuh97/mnVLe8xRZiqjolYT4P2vQnzBbbymR1CEzobrHf7CK51GUDtEMBES+ndVWfpvrFjax1yR9k7X20tXZJ+5z5F8+Tm8fVpqbJdFULo5y+7lD1KX20kEeJFXy5fnObR6EQwX1+ek2BujA3imEO0GieWWCMpqzxNeCgmiRsQ/M5NGIoXJlW4IJAcACxKMd7tcXfUHkUgQNfH/E6F5VZstAC9VZ4QJshwbA6tGx6aVadecDFPGUfXlmcBFHINt2hd5dDsDdm7ddBf55fTsPVu95AJuS55n+8Fb7qb0rCPhuqTyiASJuJA8Fp0ZRBwBbrafsaShLARj8+LQ/+zzIbrr5Cfi7BgNkls5k2kIDWv4WRHR8dIMDsNmqECTLcH4E3CHaNXApK/3o5B/Gd6HmEvUa+/s/Wdzl/FDkYTxGQPQ3Dww==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <06712E46A88E9E4DBE1F370BA65AA0C5@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3479.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d52aaf7c-2aa9-4ea3-1faf-08d882926b4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2020 20:27:44.9138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +1YHQ1WU042Dmsklr4N3UwAgAGmIrYQQaUCL/XOeKDDUqNplJTJ+Z1nZWYRGZXUR8amp48qS3i2OaULBhxOMwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4257
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgU3RhYmxlIFRlYW0sDQoNCk9uIDEwLzE5LzIwIDc6MTkgUE0sIFZpbmVldCBHdXB0YSB3cm90
ZToNCj4gVGhpcyByZXZlcnRzIGNvbW1pdCAwMGZkZWM5OGQ5ODgxYmY1MTczYWYwOWFlYmQzNTNh
YjNiOWFjNzI5Lg0KPiAoYnV0IG9ubHkgZnJvbSA1LjIgYW5kIHByaW9yIGtlcm5lbHMpDQo+IA0K
PiBUaGUgb3JpZ2luYWwgY29tbWl0IHdhcyBhIHByZXZlbnRpdmUgZml4IGJhc2VkIG9uIGNvZGUt
cmV2aWV3IGFuZCB3YXMNCj4gYXV0by1waWNrZWQgZm9yIHN0YWJsZSBiYWNrLXBvcnQgKGZvciBi
ZXR0ZXIgb3Igd29yc2UpLg0KPiBJdCB3YXMgT0sgZm9yIHY1LjMrIGtlcm5lbHMsIGJ1dCB0dXJu
ZWQgdXAgbmVlZGluZyBhbiBpbXBsaWNpdCBjaGFuZ2UNCj4gNjhlNWM2ZjA3M2JjZjcwICIoQVJD
OiBlbnRyeTogRVZfVHJhcCBleHBlY3RzIHIxMCAodnMuIHI5KSB0byBoYXZlDQo+ICBleGNlcHRp
b24gY2F1c2UpIiBtZXJnZWQgaW4gdjUuMyB3aGljaCBpdHNlbGYgd2FzIG5vdCBiYWNrcG9ydGVk
Lg0KPiBTbyB0byBzdW1tYXJpemUgdGhlIHN0YWJsZSBiYWNrcG9ydCBvZiB0aGlzIHBhdGNoIGZv
ciB2NS4yIGFuZCBwcmlvcg0KPiBrZXJuZWxzIGlzIGJ1c3RlZCBhbmQgaXQgd29uJ3QgYm9vdC4N
Cj4gDQo+IFRoZSBvYnZpb3VzIHNvbHV0aW9uIGlzIGJhY2twb3J0IDY4ZTVjNmYwNzNiY2Y3MCBi
dXQgdGhhdCBpcyBhIHBhaW4gYXMNCj4gaXQgZG9lc24ndCByZXZlcnQgY2xlYW5seSBhbmQgZWFj
aCBvZiBhZmZlY3RlZCBrZXJuZWxzIChzbyBmYXIgdjQuMTksDQo+IHY0LjE0LCB2NC45LCB2NC40
KSBuZWVkcyBhIHNsaWdodGx5IGRpZmZlcmVudCBtYXNzYWdlZCB2YXJhaW50Lg0KPiBTbyB0aGUg
ZWFzaWVyIGZpeCBpcyB0byBzaW1wbHkgcmV2ZXJ0IHRoZSBiYWNrcG9ydCBmcm9tIDUuMiBhbmQg
cHJpb3IuDQo+IFRoZSBpc3N1ZSB3YXMgbm90IGEgYmlnIGRlYWwgYXMgaXQgd291bGQgY2F1c2Ug
c3RyYWNlIHRvIHNwb3JhZGljYWxseQ0KPiBub3Qgd29yayBjb3JyZWN0bHkuDQo+IA0KPiBXYWxk
ZW1hciBCcm9ka29yYiBmaXJzdCByZXBvcnRlZCB0aGlzIHdoZW4gcnVubmluZyBBUkMgdUNsaWJj
IHJlZ3Jlc3Npb25zDQo+IG9uIGxhdGVzdCBzdGFibGUga2VybmVscyAod2l0aCBvZmZlbmRpbmcg
YmFja3BvcnQpLiBPbmNlIGhlIGJpc2VjdGVkIGl0LA0KPiB0aGUgYW5hbHlzaXMgd2FzIHRyaXZp
YWwsIHNvIHRoeCB0byBoaW0gZm9yIHRoaXMuDQo+IA0KPiBSZXBvcnRlZC1ieTogV2FsZGVtYXIg
QnJvZGtvcmIgPHdieEB1Y2xpYmMtbmcub3JnPg0KPiBCaXNlY3RlZC1ieTogV2FsZGVtYXIgQnJv
ZGtvcmIgPHdieEB1Y2xpYmMtbmcub3JnPg0KPiBDYzogc3RhYmxlIDxzdGFibGVAdmdlci5rZXJu
ZWwub3JnPiAjIDUuMiBhbmQgcHJpb3INCj4gU2lnbmVkLW9mZi1ieTogVmluZWV0IEd1cHRhIDx2
Z3VwdGFAc3lub3BzeXMuY29tPg0KDQpDYW4gdGhpcyByZXZlcnQgYmUgcGxlYXNlIGFwcGxpZWQg
dG8gNC4xOSBhbmQgb2xkZXIga2VybmVscyBmb3IgdGhlIG5leHQgY3ljbGUuDQoNCk9yIGlzIHRo
ZXJlIGlzIGEgcHJvY2VkdXJhbCBpc3N1ZSBnaXZlbiB0aGlzIHJldmVydCBpcyBub3QgaW4gbWFp
bmxpbmUuIEkndmUNCmRlc2NyaWJlZCB0aGUgaXNzdWUgaW4gZGV0YWlsIGFib3ZlIHNvIGlmIHRo
ZXJlJ3MgYSBiZXR0ZXIvZGVzaXJhYmxlIHdheSBvZg0KcmV2ZXJ0aW5nIGl0IGZyb20gYmFja3Bv
cnRzLCBwbGVhc2UgbGV0IG1lIGtub3cuDQoNClRoeCwNCg0KPiAtLS0NCj4gIGFyY2gvYXJjL2tl
cm5lbC9lbnRyeS5TIHwgMTYgKysrKysrKysrKystLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEx
IGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC9h
cmMva2VybmVsL2VudHJ5LlMgYi9hcmNoL2FyYy9rZXJuZWwvZW50cnkuUw0KPiBpbmRleCBlYTAw
YzhhMTdmMDcuLjYwNDA2ZWM2MmViOCAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcmMva2VybmVsL2Vu
dHJ5LlMNCj4gKysrIGIvYXJjaC9hcmMva2VybmVsL2VudHJ5LlMNCj4gQEAgLTE2NSw2ICsxNjUs
NyBAQCBFTkQoRVZfRXh0ZW5zaW9uKQ0KPiAgdHJhY2VzeXM6DQo+ICAJOyBzYXZlIEVGQSBpbiBj
YXNlIHRyYWNlciB3YW50cyB0aGUgUEMgb2YgdHJhY2VkIHRhc2sNCj4gIAk7IHVzaW5nIEVSRVQg
d29uJ3Qgd29yayBzaW5jZSBuZXh0LVBDIGhhcyBhbHJlYWR5IGNvbW1pdHRlZA0KPiArCWxyICBy
MTIsIFtlZmFdDQo+ICAJR0VUX0NVUlJfVEFTS19GSUVMRF9QVFIgICBUQVNLX1RIUkVBRCwgcjEx
DQo+ICAJc3QgIHIxMiwgW3IxMSwgVEhSRUFEX0ZBVUxUX0FERFJdCTsgdGhyZWFkLmZhdWx0X2Fk
ZHJlc3MNCj4gIA0KPiBAQCAtMjA3LDkgKzIwOCwxNSBAQCB0cmFjZXN5c19leGl0Og0KPiAgOyBC
cmVha3BvaW50IFRSQVANCj4gIDsgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tDQo+ICB0cmFwX3dpdGhfcGFyYW06DQo+IC0JbW92IHIwLCByMTIJOyBFRkEgaW4g
Y2FzZSBwdHJhY2VyL2dkYiB3YW50cyBzdG9wX3BjDQo+ICsNCj4gKwk7IHN0b3BfcGMgaW5mbyBi
eSBnZGIgbmVlZHMgdGhpcyBpbmZvDQo+ICsJbHIgIHIwLCBbZWZhXQ0KPiAgCW1vdiByMSwgc3AN
Cj4gIA0KPiArCTsgTm93IHRoYXQgd2UgaGF2ZSByZWFkIEVGQSwgaXQgaXMgc2FmZSB0byBkbyAi
ZmFrZSIgcnRpZQ0KPiArCTsgICBhbmQgZ2V0IG91dCBvZiBDUFUgZXhjZXB0aW9uIG1vZGUNCj4g
KwlGQUtFX1JFVF9GUk9NX0VYQ1BODQo+ICsNCj4gIAk7IFNhdmUgY2FsbGVlIHJlZ3MgaW4gY2Fz
ZSBnZGIgd2FudHMgdG8gaGF2ZSBhIGxvb2sNCj4gIAk7IFNQIHdpbGwgZ3JvdyB1cCBieSBzaXpl
IG9mIENBTExFRSBSZWctRmlsZQ0KPiAgCTsgTk9URTogY2xvYmJlcnMgcjEyDQo+IEBAIC0yMzYs
MTAgKzI0Myw2IEBAIEVOVFJZKEVWX1RyYXApDQo+ICANCj4gIAlFWENFUFRJT05fUFJPTE9HVUUN
Cj4gIA0KPiAtCWxyICByMTIsIFtlZmFdDQo+IC0NCj4gLQlGQUtFX1JFVF9GUk9NX0VYQ1BODQo+
IC0NCj4gIAk7PT09PT09PT09PT09IFRSQVAgMSAgIDpicmVha3BvaW50cw0KPiAgCTsgQ2hlY2sg
RUNSIGZvciB0cmFwIHdpdGggYXJnIChQUk9MT0dVRSBlbnN1cmVzIHIxMCBoYXMgRUNSKQ0KPiAg
CWJtc2suZiAwLCByMTAsIDcNCj4gQEAgLTI0Nyw2ICsyNTAsOSBAQCBFTlRSWShFVl9UcmFwKQ0K
PiAgDQo+ICAJOz09PT09PT09PT09PSBUUkFQICAobm8gcGFyYW0pOiBzeXNjYWxsIHRvcCBsZXZl
bA0KPiAgDQo+ICsJOyBGaXJzdCByZXR1cm4gZnJvbSBFeGNlcHRpb24gdG8gcHVyZSBLIG1vZGUg
KEV4Y2VwdGlvbi9JUlFzIHJlbmFibGVkKQ0KPiArCUZBS0VfUkVUX0ZST01fRVhDUE4NCj4gKw0K
PiAgCTsgSWYgc3lzY2FsbCB0cmFjaW5nIG9uZ29pbmcsIGludm9rZSBwcmUtcG9zdC1ob29rcw0K
PiAgCUdFVF9DVVJSX1RIUl9JTkZPX0ZMQUdTICAgcjEwDQo+ICAJYnRzdCByMTAsIFRJRl9TWVND
QUxMX1RSQUNFDQo+IA0KDQo=
