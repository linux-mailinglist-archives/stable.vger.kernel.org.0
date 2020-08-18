Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46E17249049
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 23:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgHRVk5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 17:40:57 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:34974 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726366AbgHRVkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 17:40:55 -0400
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A6689C0760;
        Tue, 18 Aug 2020 21:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1597786853; bh=TxZC17pV6wcP6BBSSjxMM9gi4ERIBdQQnZEL0SzU3zA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=TIsu1+/G7oINiEemG5fvBDAq2R1zAlVkGlEbnr0Xf9iVcnB9awrfT/Gt17BMP8b7c
         R6A1P52br2xkbwvnwymsvADQmvDmD9BYQ+Y7gvWWwQN9ClhCQUl0zB3rfMYsLgx8Le
         oMAirVzLrxCGwJth/CENqNFHziENoBULFL2rCAc2lqwpH4OxOSpI8jNdA69XpP6DXD
         DDeXG2NHkUMWmXjl5bKTpZhT7EvtieYJuBo67Mf89H8wluJ1MX/Q3394juuYSBoOzV
         q832XbwhE7GR+jPt2nMZBwe2gIdACKGh34a2iHXC6Z2fmjbKAzL3f5z6CxjwLvEwKJ
         OeDiDRYIq0+1Q==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id C7CF8A005A;
        Tue, 18 Aug 2020 21:40:52 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "GlobalSign Organization Validation CA - SHA256 - G3" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id ECEE9801E2;
        Tue, 18 Aug 2020 21:40:51 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="UyZk63He";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R259ke8EcZbZ2huf1tFDt/qrbpU2M1WmWBp8i5VYuYU+qv0h6lsGft3Am2o0L3Ny8ycCTuMAGIkaXx4pr16ecVf5d3sdj5H/5Js68J3zygoGFedGGglp0M3Li53GjjkGfhPQxPKrLRH0cfQEONYXuq9TUrP08F9z9HmX2V60QBbdzUe9CVokWH1XrMNgH0VKjTTUtUWPdiiaTsLfBSr0ycWsPs4MLXswAY995e9lqiJDSiryfkOPIuBG1clhR7TjN4JHpYihXmvPohabjcvL1H5f3jsXWx67okJygDu172L/SFC2cy7WAWDlMsYHF/aJ407wy7qsrLCd1k2IlLVk+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TxZC17pV6wcP6BBSSjxMM9gi4ERIBdQQnZEL0SzU3zA=;
 b=nynF+/F8GVjS1lhxno0qu8p1BBJF3LjPiFbY1y+BMqzNj5QFW+XuVBR0EzXUoA5cU7/B6xH5sFRDnWkPrMxRD2NGDp0RDTk+CUQdI7Uj08Hw+6BXkSLhwQbyt7ONcNz3Xf/XG18rxM7cLRCa+o9y3vbnoUNo4tfTeWonVhaX6/CTL0n83N6t3KSYhbwUQLc1lFlRVGh96v0Mt2XfmmGsiNWPGtyWuCeeARwA94mxWw/wRr8PKj07dHkSkFFRfs4tH027wostjxxEbFnwXeYHZI1qrWElQgdLns7ByRw7T90vm+k79CVJu3A/ifsGLtxSnpHcanXLvn+Pwa0EIdu0AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TxZC17pV6wcP6BBSSjxMM9gi4ERIBdQQnZEL0SzU3zA=;
 b=UyZk63Heb/wbR9oRD1qYOXXpx7n3KpfiP0Pliu6j5AiuXq44qMzsBHi2ZCTa8F/nBhRVVlasPU9TX6pU09ZUKB3fPyiUpOM5hY2nA5M7OQsB52xWpsutSHDc9w38zTONMQJAJHb8+ZYOSRmhCqgAFAwHvcbcONuOUTy2Fun+l9E=
Received: from BYAPR12MB2917.namprd12.prod.outlook.com (2603:10b6:a03:130::14)
 by BYAPR12MB3576.namprd12.prod.outlook.com (2603:10b6:a03:d8::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.22; Tue, 18 Aug
 2020 21:40:50 +0000
Received: from BYAPR12MB2917.namprd12.prod.outlook.com
 ([fe80::c98f:a13f:fd88:c209]) by BYAPR12MB2917.namprd12.prod.outlook.com
 ([fe80::c98f:a13f:fd88:c209%7]) with mapi id 15.20.3283.028; Tue, 18 Aug 2020
 21:40:50 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 0/3] usb: dwc3: gadget: Fix halt/clear_stall handling
Thread-Topic: [PATCH 0/3] usb: dwc3: gadget: Fix halt/clear_stall handling
Thread-Index: AQHWZsksAG75pvdLnE6BrdQIXUle+Kk8tK2AgADXNICAAPcGgA==
Date:   Tue, 18 Aug 2020 21:40:50 +0000
Message-ID: <31442b8f-409a-d87b-944d-0f799cfe1211@synopsys.com>
References: <cover.1596151437.git.thinhn@synopsys.com>
 <988d2d58-59f6-3d1e-bc66-ab424cc0fff4@synopsys.com>
 <87364kzbkm.fsf@kernel.org>
In-Reply-To: <87364kzbkm.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [149.117.7.24]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7ac11dd-429f-4beb-e41e-08d843bf602a
x-ms-traffictypediagnostic: BYAPR12MB3576:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3576BD1D9472AB54ED0227FCAA5C0@BYAPR12MB3576.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XgrtDgzdX4cVc92GBGqrzKIbg0fj+/Q6PSsRJpDiaRKSpNy2/ZH1ShAp09kwqXJI5ruCbFqgJDXS/n3Ze8uf2uFXzyIsv+fRbnfrTF9gALpyLxW4D39451J8brxAShdoHI2kwEOIdJ03C4Pldg+rYKKOSZU7aIa+TqeWZkFA8Q5guGfZ6kXahK1WXG9+PSOI+bUjhGgIL/w0Ry1RMAnDGR71kgMKmMttynJos/5Pvy4XSS4Oc6DAJr98cb0Z70dZdzR6ldHruD0pxZYhV563du4pzzo3qCUK/5/QKNewRfvAsyr6H95vC/g1nPb8L/pUk1SY2x0gcLD6Qs8S8rkgjQA9EVQt9iQfUCbVpzOfzeL0CjC49D+3GhgSjRpfUCaR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2917.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39850400004)(346002)(66446008)(83380400001)(31696002)(31686004)(8936002)(2616005)(4326008)(36756003)(86362001)(66946007)(76116006)(8676002)(6506007)(54906003)(6486002)(2906002)(66476007)(316002)(110136005)(5660300002)(64756008)(26005)(71200400001)(6512007)(186003)(66556008)(478600001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: h3c9YMYWanrkfE4Y2Anz8v77f+tf1Dja5hIjNA51QjfF97jq+t2IKBQuoQT8TOaoMmWiE69oWTj9mawgmX0f24CqdiGuHsEUzaIYEGoei6q+wyHOTsK71MBkZqLVfXXrQfKEo1eLKEsz3x9GcNxLCrvHPnVbz9eQXLKAbH8H6BKW65XrYmJwS8BFS7XqsgLkfZ2LTVn1hl33rjBIuEhZPOYHZX3nzPNXbtupPxi4nWZbbnPJfczqVoOtkcp1nLPbUEVyYGygsZLcf/7eGJUSkG52HzfZlJN/jqwBVxDsjuuXyB6ZF9iRIjVBy+HKDHMh2W+Bxnc29wm+jQjYI7mPkmF2ICH9gfb+Fc24gJZGQ8ZGjAoa36llQ0vkL5MszubiZRXcRvkCFhABzuFRZ1jU1Y+J9gVOxEdioWvTrqGbSklsQktva+v4u+qfO5qt3k5IQLUcL2eQwvMSEvDusKAaI41aPhjmyMaqMtde7BLokuVWGOyPOoAbvxUi8IFOsX0pcQOhX+7HfkCH3ATkc6dmWiVHg/KzMxzPBC0lWfyoCZdhcAtjO+SwACKyWrOJ1KhSo19jYHvXGtjqPVhTnQbForQgy/2DdXdcH27R/lvpEJyAs0W2yVHKtUP2YKIjosZzxAYUsbPYsxrCfwEtBJ9eCw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA120944EE997148919461E2A480ED63@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2917.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7ac11dd-429f-4beb-e41e-08d843bf602a
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2020 21:40:50.3004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rDhAiYiA+QWeBxkV+8lY4yOVSCHakruAZkLOVMMTopbv/cEpGTNgxqOKsCDtlMg5tb9atbenF5c0raEOltxqPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3576
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RmVsaXBlIEJhbGJpIHdyb3RlOg0KPiBUaGluaCBOZ3V5ZW4gPFRoaW5oLk5ndXllbkBzeW5vcHN5
cy5jb20+IHdyaXRlczoNCj4NCj4+IEhpIEZlbGlwZSwNCj4+DQo+PiBUaGluaCBOZ3V5ZW4gd3Jv
dGU6DQo+Pj4gVGhpcyBzZXJpZXMgZml4ZXMgYSBjb3VwbGUgb2YgZHJpdmVyIGlzc3VlcyBoYW5k
bGluZyBDbGVhckZlYXR1cmUoaGFsdCkNCj4+PiByZXF1ZXN0Og0KPj4+DQo+Pj4gMSkgQSBmdW5j
dGlvbiBkcml2ZXIgb2Z0ZW4gdXNlcyBzZXRfaGFsdCgpIHRvIHJlamVjdCBhIGNsYXNzIGRyaXZl
ciBwcm90b2NvbA0KPj4+IGNvbW1hbmQuIEFmdGVyIHNldF9oYWx0KCksIHRoZSBlbmRwb2ludCB3
aWxsIGJlIHN0YWxsZWQuIEl0IGNhbiBxdWV1ZSBuZXcNCj4+PiByZXF1ZXN0cyB3aGlsZSB0aGUg
ZW5kcG9pbnQgaXMgc3RhbGxlZC4gSG93ZXZlciwgZHdjMyBjdXJyZW50bHkgZHJvcHMgdGhvc2UN
Cj4+PiByZXF1ZXN0cyBhZnRlciBDTEVBUl9TVEFMTC4gVGhlIGRyaXZlciBzaG91bGQgb25seSBk
cm9wIHN0YXJ0ZWQgcmVxdWVzdHMuIEtlZXANCj4+PiB0aGUgcGVuZGluZyByZXF1ZXN0cyBpbiB0
aGUgcGVuZGluZyBsaXN0IHRvIHJlc3VtZSBhbmQgcHJvY2VzcyB0aGVtIGFmdGVyIHRoZQ0KPj4+
IGhvc3QgaXNzdWVzIENsZWFyRmVhdHVyZShIYWx0KSB0byB0aGUgZW5kcG9pbnQuDQo+Pj4NCj4+
PiAyKSBEV0MzIHNob3VsZCBpc3N1ZSBDTEVBUl9TVEFMTCBjb21tYW5kIF9hZnRlcl8gRU5EX1RS
QU5TRkVSIGNvbW1hbmQgY29tcGxldGVzLg0KPj4+DQo+Pj4NCj4+PiBUaGluaCBOZ3V5ZW4gKDMp
Og0KPj4+ICAgdXNiOiBkd2MzOiBnYWRnZXQ6IFJlc3VtZSBwZW5kaW5nIHJlcXVlc3RzIGFmdGVy
IENMRUFSX1NUQUxMDQo+Pj4gICB1c2I6IGR3YzM6IGdhZGdldDogRU5EX1RSQU5TRkVSIGJlZm9y
ZSBDTEVBUl9TVEFMTCBjb21tYW5kDQo+PiBTaW5jZSB5b3UncmUgcGlja2luZyB0aGUgZml4IHBh
dGNoZXMgZm9yIFJDIGN5Y2xlLCBjYW4geW91IHBpY2sgdXAgdGhlc2UNCj4+IDIgcGF0Y2hlcyBv
ZiB0aGlzIHNlcmllcyBhbHNvPyBXZSBjYW4gbGVhdmUgdGhlIHJlZmFjdG9yaW5nIHBhdGNoIGlu
DQo+PiB0aGlzIHNlcmllcyBmb3IgdjUuMTAuDQo+IGp1c3QgdG8gYmUgc3VyZTogeW91IGRpZCBy
dW4gdGhlc2UgdGhyb3VnaCB1c2JjdiBhbmQgdXNiMyBjb21wbGlhbmNlDQo+IHN1aXRlLCByaWdo
dD8gV2hpY2ggZ2FkZ2V0IGRyaXZlcnMgZGlkIHlvdSB1c2U/DQo+DQoNClllcyBJIGRpZCBmb3Ig
Y2hhcHRlciA5LCBNU0MsIGFuZCBVQVNQIENWLiBJIG1pc3NlZCB0aGlzIGlzc3VlIGJlY2F1c2UN
CiJzdGFsbCIgd2FzIG5vdCBlbmFibGVkIGJ5IGRlZmF1bHQgZm9yIG1hc3Nfc3RvcmFnZSBjb25m
aWdmcy4gV2l0aG91dA0KdGhpcyBmaXgsIG1hc3Nfc3RvcmFnZSBmdW5jdGlvbiB3b24ndCB3b3Jr
IHdpdGggInN0YWxsIiBlbmFibGVkLg0KDQooTm90ZTogZm9yIFVBU1AgQ1YsIGl0IHJlcXVpcmVz
IG1hbnkgZml4ZXMvZW5oYW5jZW1lbnRzIGluIGZfdGNtIGFuZCB0aGUNCnRhcmdldCBzdWJzeXN0
ZW0gdG8gd29yayBwcm9wZXJseS4pDQoNClRoYW5rcywNClRoaW5oDQo=
