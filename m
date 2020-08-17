Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD075247050
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389940AbgHQSGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:06:46 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:58512 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390289AbgHQSGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 14:06:31 -0400
Received: from mailhost.synopsys.com (sv2-mailhost1.synopsys.com [10.205.2.133])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 22454C008E;
        Mon, 17 Aug 2020 18:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1597687591; bh=rsxB5sZlaTHQrsklhX+wSTff9Zi8rBcw6Vx1Ck1oOkk=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=VB7z5wv9ejbhJiRmQ5ksdNFTxb8MMb86XuvnBI+ZtUdO/L4QNeEld2Wv6K79OXsdr
         y/jR9K2jwV1R780AIreSx5iv0zEmPHUhzWNlXByYmxLP5t2RWPZWZFmDNk4IxBwZXW
         QPwyFg9snHVExOXcC4iNtchwEeKnLG1JANFNTucF7mN5gK1ktFRQyxBvZXWqTZFDwu
         WSP0uhAJ8Qj5KAgLGpJ5ub70F514qB6pTfXPdrrxhFzTcTqZ19I03w6Q4v53h0GvXF
         k+iEdmpYaj4fTSWmK2bI8SQTWhmUI6QIF4xqWMAde1ciVW9ZORW4qg8AvXzHsjAozu
         mAbBcIQfxJ6tg==
Received: from o365relay-in.synopsys.com (sv2-o365relay1.synopsys.com [10.202.1.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id B86AAA005A;
        Mon, 17 Aug 2020 18:06:30 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "GlobalSign Organization Validation CA - SHA256 - G3" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 142134011C;
        Mon, 17 Aug 2020 18:06:29 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="mIiXObN5";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZG8HJdfcH5Q4tY1EEYV/XYo8zk7RbqujB2T/WNcxLZ8OoSmO7/uYE8i4+iFVfhQjeDzz6uYylByYAxM/pOvD1pv7Pr+RwvSVy8yeDYKlHtY0xqUg4z78lJ5Lmx8IL1B8U5DINqJU047KG2Lw4MmZniCatYXyF/AkR3RDTyqYkowO3JcfAniXvB+4uS5Vz9wBT0Pnls/JHmVHg1Kk3zGeJgj1kvbyN4JUzZO/asKv5hfzZhrjaXlN26bRkXv1TqMK6zCLPaRvOrJZUQYlujIH1yzlEbqFS7HtEhjP74UgydsLAfaig3oxVUXH+bwuA9StnuddbciPV0mPazQimjisgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsxB5sZlaTHQrsklhX+wSTff9Zi8rBcw6Vx1Ck1oOkk=;
 b=QTRfGqBBJQ7i/dCUyYpf0AvsNl3jBAVJGPUBB4BKXkp0CdNknSZBcWHU9errvEwjqW/yAnJtJBqAHlPEn/paXNqw11rlshYS3obGEDhN1jyKvdmO1xQVm6+D9koGVWD3bI2F/aMXbSJXkEwnq5Lz35XK3oZdjUCFKKsiWTI9MRS5k2Qtds1Mhrss50hijiRqCeUCwR5fkUAWWEgeR253zsbuNh+63VEEWWb1HcjaRoIvaQjNaLf2EZGUM9TexSioA3nHQtDzJo6dlTLsSu540zbOY8fpgQ4VtXJKFL2aEBcjPuzLWOGhksBOkl5HZ5/7t/UtggCzvIwpTgbEHg7ofA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rsxB5sZlaTHQrsklhX+wSTff9Zi8rBcw6Vx1Ck1oOkk=;
 b=mIiXObN5xMRHSiFi3RO+Xv+XBP3EbT/Kpp7jnjHGQxSq0dFpoWAzwNnFexZ3rXBRaeCjt/C93b4w0yVqyk58lX1VvwFJgJxm0yTPcvMhLiXGHsERN44vbLxGCf4tWRXD20ftOSTfc1fPTkbEMf/dobh63aeP8DI4sJl64UPAXEs=
Received: from BYAPR12MB2917.namprd12.prod.outlook.com (2603:10b6:a03:130::14)
 by BYAPR12MB2823.namprd12.prod.outlook.com (2603:10b6:a03:96::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15; Mon, 17 Aug
 2020 18:06:28 +0000
Received: from BYAPR12MB2917.namprd12.prod.outlook.com
 ([fe80::c98f:a13f:fd88:c209]) by BYAPR12MB2917.namprd12.prod.outlook.com
 ([fe80::c98f:a13f:fd88:c209%7]) with mapi id 15.20.3283.027; Mon, 17 Aug 2020
 18:06:28 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 0/3] usb: dwc3: gadget: Fix halt/clear_stall handling
Thread-Topic: [PATCH 0/3] usb: dwc3: gadget: Fix halt/clear_stall handling
Thread-Index: AQHWZsksAG75pvdLnE6BrdQIXUle+Kk8tK2A
Date:   Mon, 17 Aug 2020 18:06:27 +0000
Message-ID: <988d2d58-59f6-3d1e-bc66-ab424cc0fff4@synopsys.com>
References: <cover.1596151437.git.thinhn@synopsys.com>
In-Reply-To: <cover.1596151437.git.thinhn@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [149.117.7.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a77021b0-42e3-4819-b5a1-08d842d8433c
x-ms-traffictypediagnostic: BYAPR12MB2823:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB2823AC08528B72FF20BFA01AAA5F0@BYAPR12MB2823.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:669;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UrxwivOoDuGuW+NK1x3ZKj+QFvyWPZZQkvzfuj6AU02HYCtj7/9f32USyP81skFSO+i9HbR+xK2DYfDKzZT7ToinoN/T/GRDdzpO2AslanG0DRQUB0V1KGO7xjzOn3SaNNlwHQL8HqWWEKPoL0gOIEf12mkChEYmBBQYGD99O/Sorq4CxIHHll479enob20qtSWTkW0Kq3XhpDeUi7+uY3nZ8svvXnysBhtLSYiyHtalVlyV0HNXxfqX07VW5kEnDwW7O5olNiXgUt1gNI6G98HYw0LMsgFUDz6Jhig7c53Cz6zLrSLDhht24oTkg4M2LypVfQ0COv8GvXl+21NXCRJMUCeVoA/ID4vdefDPq6BWG6hlZliR9czPQrYSrQ+8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2917.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(346002)(39860400002)(396003)(36756003)(26005)(6486002)(6512007)(6506007)(2616005)(478600001)(31686004)(86362001)(66446008)(64756008)(8676002)(66476007)(83380400001)(31696002)(66556008)(8936002)(2906002)(76116006)(66946007)(110136005)(71200400001)(54906003)(5660300002)(316002)(186003)(4326008)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: xc5tyBtnH1Ikgnmn0EPPq8srg9qEevz7SiUpQB3llSQXL+Nf6GdChLVjd1OKtyHhYfCJq35p2GGcU7ne70dYkDhUVk4lTrbcXzMNm5geyJfpV8bUx35C/d9lsoNYDDVSX1rFWT/S9uZo4obu1irMkHJ3ATulsZIaraGS+dF14Cmjjx/5P1sR4ZnBSOrbKva1b1tLzfilYHb58HIOesJPIey0w+8y93kkHTK3tlORexJk4xNQCc7WSAHulZudKtEWHWbFrLCFZetPIZknz7JOoJDOQA+yzyp7kLbQs083+/qU23QKlwLduV6mGAPqQCubtgE2LChS1rkbLvVboPQNf8dX3TzoUPSJWBDc7lkMvtkFB7n4JcFwMzCHcv0mo5HPxe1biz/uJsYroxuNUAKsBAAsRecFQxfnVwfS8RCpmgviI5QxDf1R9K2Wgpo0D+h+5PcanmXZL7m3ZkEhQ97kWhNHw1e4+hNjHzfutmHjnAp8NxdagGes/BPzh2T22/ZcL9bxy8NYO6Z23CjqJAA4uIsCGcqa9NrwNXW2S4wNlz4Ob8YRUcxOQqAvbx3QLjHR9xru65/zuWwBStd/X9pRTnuYU0Hpa/BtzR6/dPjlbBOa+UGzR6L1vZy8ugBzih73iL1idUnxWk/cl9Mn7LxM3w==
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7989FA8702B074BAD0C9B1D8C433FEC@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2917.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a77021b0-42e3-4819-b5a1-08d842d8433c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2020 18:06:27.9557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AxR/+I9D9C5IcJFfEBtAuH5BQYqbKgjTIuNZcsUKfOgf9ck2y/v9B1kXM7TJBLIxRa0odm+F3njlll6QhoWpWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2823
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgRmVsaXBlLA0KDQpUaGluaCBOZ3V5ZW4gd3JvdGU6DQo+IFRoaXMgc2VyaWVzIGZpeGVzIGEg
Y291cGxlIG9mIGRyaXZlciBpc3N1ZXMgaGFuZGxpbmcgQ2xlYXJGZWF0dXJlKGhhbHQpDQo+IHJl
cXVlc3Q6DQo+DQo+IDEpIEEgZnVuY3Rpb24gZHJpdmVyIG9mdGVuIHVzZXMgc2V0X2hhbHQoKSB0
byByZWplY3QgYSBjbGFzcyBkcml2ZXIgcHJvdG9jb2wNCj4gY29tbWFuZC4gQWZ0ZXIgc2V0X2hh
bHQoKSwgdGhlIGVuZHBvaW50IHdpbGwgYmUgc3RhbGxlZC4gSXQgY2FuIHF1ZXVlIG5ldw0KPiBy
ZXF1ZXN0cyB3aGlsZSB0aGUgZW5kcG9pbnQgaXMgc3RhbGxlZC4gSG93ZXZlciwgZHdjMyBjdXJy
ZW50bHkgZHJvcHMgdGhvc2UNCj4gcmVxdWVzdHMgYWZ0ZXIgQ0xFQVJfU1RBTEwuIFRoZSBkcml2
ZXIgc2hvdWxkIG9ubHkgZHJvcCBzdGFydGVkIHJlcXVlc3RzLiBLZWVwDQo+IHRoZSBwZW5kaW5n
IHJlcXVlc3RzIGluIHRoZSBwZW5kaW5nIGxpc3QgdG8gcmVzdW1lIGFuZCBwcm9jZXNzIHRoZW0g
YWZ0ZXIgdGhlDQo+IGhvc3QgaXNzdWVzIENsZWFyRmVhdHVyZShIYWx0KSB0byB0aGUgZW5kcG9p
bnQuDQo+DQo+IDIpIERXQzMgc2hvdWxkIGlzc3VlIENMRUFSX1NUQUxMIGNvbW1hbmQgX2FmdGVy
XyBFTkRfVFJBTlNGRVIgY29tbWFuZCBjb21wbGV0ZXMuDQo+DQo+DQo+IFRoaW5oIE5ndXllbiAo
Myk6DQo+ICAgdXNiOiBkd2MzOiBnYWRnZXQ6IFJlc3VtZSBwZW5kaW5nIHJlcXVlc3RzIGFmdGVy
IENMRUFSX1NUQUxMDQo+ICAgdXNiOiBkd2MzOiBnYWRnZXQ6IEVORF9UUkFOU0ZFUiBiZWZvcmUg
Q0xFQVJfU1RBTEwgY29tbWFuZA0KDQpTaW5jZSB5b3UncmUgcGlja2luZyB0aGUgZml4IHBhdGNo
ZXMgZm9yIFJDIGN5Y2xlLCBjYW4geW91IHBpY2sgdXAgdGhlc2UNCjIgcGF0Y2hlcyBvZiB0aGlz
IHNlcmllcyBhbHNvPyBXZSBjYW4gbGVhdmUgdGhlIHJlZmFjdG9yaW5nIHBhdGNoIGluDQp0aGlz
IHNlcmllcyBmb3IgdjUuMTAuDQoNClRoYW5rcywNClRoaW5oDQoNCg0KPiAgIHVzYjogZHdjMzog
Z2FkZ2V0OiBSZWZhY3RvciBlcCBjb21tYW5kIGNvbXBsZXRpb24NCj4NCj4gIGRyaXZlcnMvdXNi
L2R3YzMvY29yZS5oICAgfCAgMSArDQo+ICBkcml2ZXJzL3VzYi9kd2MzL2VwMC5jICAgIHwgMTYg
KysrKysrKysrDQo+ICBkcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jIHwgODUgKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0NCj4gIGRyaXZlcnMvdXNiL2R3YzMv
Z2FkZ2V0LmggfCAgMSArDQo+ICA0IGZpbGVzIGNoYW5nZWQsIDc1IGluc2VydGlvbnMoKyksIDI4
IGRlbGV0aW9ucygtKQ0KPg0KPg0KPiBiYXNlLWNvbW1pdDogZTNlZTBlNzQwYzM4ODdkMjI5M2U4
ZDU0YTg3MDcyMThkNzBkODZjYQ0KDQo=
