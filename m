Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B49F1F119E
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 05:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbgFHDHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 23:07:05 -0400
Received: from mail-eopbgr30066.outbound.protection.outlook.com ([40.107.3.66]:42119
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728065AbgFHDHE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Jun 2020 23:07:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1RNhslFJT4CAUMktBTctmpW2sV/l56aMU3N0MyzaOWk=;
 b=75yy+12S5//1kGAQ4N/4oihvwm8si6vYRsbYje5EWt1Hi3JJlY96FP68Kre2ltEuePHxnoVPPF8TPMc61NjsrBuUvkNgp9u4ebFTSct47Bu74ZuxP8AqgyInoNm5fTWurIjbwOSCjC+SahYzM+N21LLRl4hYRXEGIXg2rLuL2uw=
Received: from DB6PR0201CA0035.eurprd02.prod.outlook.com (2603:10a6:4:3f::45)
 by VI1PR0801MB1968.eurprd08.prod.outlook.com (2603:10a6:800:88::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.22; Mon, 8 Jun
 2020 03:06:59 +0000
Received: from DB5EUR03FT026.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:3f:cafe::d9) by DB6PR0201CA0035.outlook.office365.com
 (2603:10a6:4:3f::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend
 Transport; Mon, 8 Jun 2020 03:06:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT026.mail.protection.outlook.com (10.152.20.159) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3066.18 via Frontend Transport; Mon, 8 Jun 2020 03:06:59 +0000
Received: ("Tessian outbound 8bb15bb571b3:v59"); Mon, 08 Jun 2020 03:06:59 +0000
X-CR-MTA-TID: 64aa7808
Received: from 7d4364cbe064.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id F463D980-0883-40A8-A1A3-6167202031AE.1;
        Mon, 08 Jun 2020 03:06:54 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 7d4364cbe064.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 08 Jun 2020 03:06:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N8tJbbU4nGh1xHpXa2nwRMCG39dkLaA8BMTgni2q+iJvfjGs3uDtryQ/ap9p0Rs+tLJ2RaLKX3gohsvwZmwQYbqGP/SztLGhemM/lxbIGAIKudkfGFSQIgugzmk+/jcfu/M/edhVdYCk3n9GDxYkn8lWvOdhFAThwUam36XyJ+V1qnPw1jeb9Vv8jebc3Jb1zA0XVYxZZq8CPEhe8rWXp0+S73TVGV1YiEjp+681Gl2JWmYSiWxVcK4iwYTbe2nDFZ4vkWrDY6Y/FRpN0ykEPrYGRin8lcduQML4X/WX1A+euJ1/X/53WcHYCpKCzsN0TCyUErv3KeipHcqAltsZXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1RNhslFJT4CAUMktBTctmpW2sV/l56aMU3N0MyzaOWk=;
 b=B9rEyqfA5XVz6J/zzK8z1z9quJGd7Vu4AKv9FUnJ2fED+ENT+0YST8IYRik5aFo/YGNcXlHCcQbtT3ne6KalF5Mp8lj1/bVmf6hIp22Qc5d4pjjo82NMyfmXKzsz/NNd1njbyZYVrla0qVoCEgxtmS7dd/oJ3M/pFzOxr+M2rnPsB8eF7H1bPGbXGslsCDXmgiU8dqHb1sMavzyiGLqQwD5LUkt1vkibvRfG7AW2BYKhDmV10Waev9aDioIyQ7iHrMFEElzcYnN4FJr+p34DLesuo7/I3OEoQsCWHOiDAlxVqAV9KNda+8QKY1kweT4+qsah3e7YBtrZUpt3Nn91rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1RNhslFJT4CAUMktBTctmpW2sV/l56aMU3N0MyzaOWk=;
 b=75yy+12S5//1kGAQ4N/4oihvwm8si6vYRsbYje5EWt1Hi3JJlY96FP68Kre2ltEuePHxnoVPPF8TPMc61NjsrBuUvkNgp9u4ebFTSct47Bu74ZuxP8AqgyInoNm5fTWurIjbwOSCjC+SahYzM+N21LLRl4hYRXEGIXg2rLuL2uw=
Received: from AM6PR08MB4069.eurprd08.prod.outlook.com (2603:10a6:20b:af::32)
 by AM6PR08MB4567.eurprd08.prod.outlook.com (2603:10a6:20b:b0::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Mon, 8 Jun
 2020 03:06:52 +0000
Received: from AM6PR08MB4069.eurprd08.prod.outlook.com
 ([fe80::8c97:9695:2f8d:3ae0]) by AM6PR08MB4069.eurprd08.prod.outlook.com
 ([fe80::8c97:9695:2f8d:3ae0%5]) with mapi id 15.20.3066.023; Mon, 8 Jun 2020
 03:06:52 +0000
From:   Justin He <Justin.He@arm.com>
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Sasha Levin <sashal@kernel.org>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2] virtio_vsock: Fix race condition in
 virtio_transport_recv_pkt
Thread-Topic: [PATCH v2] virtio_vsock: Fix race condition in
 virtio_transport_recv_pkt
Thread-Index: AQHWNcziU+BZVxkkR0u4Tcyr1QL4sKjKH/LsgAP3TjA=
Date:   Mon, 8 Jun 2020 03:06:52 +0000
Message-ID: <AM6PR08MB4069A0F5B5E0BED4ED167E95F7850@AM6PR08MB4069.eurprd08.prod.outlook.com>
References: <20200529152102.58397-1-justin.he@arm.com>
 <20200605141049.A67B9207ED@mail.kernel.org>
 <20200605142930.wz45eysnbi7kyqyc@steredhat>
In-Reply-To: <20200605142930.wz45eysnbi7kyqyc@steredhat>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 4032aadb-f832-4d07-a528-2cc7c4dbc235.1
x-checkrecipientchecked: true
Authentication-Results-Original: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
x-originating-ip: [203.126.0.111]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 19d0217c-8a35-4e87-2ed5-08d80b59026b
x-ms-traffictypediagnostic: AM6PR08MB4567:|VI1PR0801MB1968:
X-Microsoft-Antispam-PRVS: <VI1PR0801MB1968B09CF4BA2BBC6B1506E0F7850@VI1PR0801MB1968.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:4714;OLM:10000;
x-forefront-prvs: 042857DBB5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 2+ogtErgTG6JFjFTgzO7t06FCewGUj963DjI0zw6magAei3N62r5Cj/MUFhSQPmFl1sT9m8vyAo8lSyyjnsRmWSQHXU0KqOCBuxi/3S1wOuT4QKDWm5Nm6o4o/5tI2Oa5tyDhanH3Oy0onaaK78+nIeKR99YR17OybQmr0EvfDn+SnvdBHgKjJh8lYydLu9n4CibKKavWIvXEMoMWmxec9E/BC2qHoXCCCfZPE50Ss3IjhhqOTkdfjY64deYX/m6aXRxrYQdvI1WaVlcuMBFm88keTxAg+9jfjDGKZgkZYc3ZI0li+rAPU6NFkXeOzpFtvO1UgiUiQ12u9PlJZ4odw==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4069.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(39850400004)(396003)(136003)(376002)(66946007)(66446008)(5660300002)(66476007)(64756008)(8676002)(66556008)(52536014)(71200400001)(86362001)(55016002)(8936002)(2906002)(9686003)(76116006)(316002)(33656002)(53546011)(54906003)(186003)(7696005)(6506007)(45080400002)(478600001)(4326008)(110136005)(83380400001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: y846PE5sKE5cY3+Q/AnGbiyRrP4U/qdiT71D0JyZKN3Jdq/bdktzvmQ/BuQ15Gil6XmGeK5o0nhiccsdQhdCzuDBb2/fBpDBSSJKXltfJbREKLjkki0jFT4EFcKgAi25RI+45UUyyK+o9pzGFbUlWazy5DUrrOJq7Gr4ZUgiDgzLWkKXpd+8AImpgIKhl4uuP0riAp9AboB2CpG5XeQg4iopGeU/v5UfLLB2Y0sFwzBaPGxZ6Qu2HOx/cp3vJXxvEjcgTxC6v+ccDrBDl9lnNcVwWab9Rm1GFAP/fhOtW8lvrfbxHdkNwy8J1NsIqWWf2gXkB2ZVcUjZn/MIJKcmZy//jCCpAjWprUl8Ec8f8mAwlkKwJcmLGRDTOLdviIdUL8ztC27MJSezsCiRLjnONbEa+B22IQcCmx5KOSHUT2TxnQztQIW8NkD6EI527SmVkK1ONeNG5EU7/VzCVgfatmdlZ8WNfjZjKerS1ooOEQE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4567
Original-Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT026.eop-EUR03.prod.protection.outlook.com
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(39850400004)(346002)(46966005)(83380400001)(82740400003)(356005)(54906003)(5660300002)(110136005)(2906002)(53546011)(6506007)(52536014)(45080400002)(81166007)(82310400002)(8676002)(7696005)(47076004)(316002)(26005)(336012)(33656002)(4326008)(478600001)(8936002)(86362001)(55016002)(186003)(70586007)(9686003)(70206006);DIR:OUT;SFP:1101;
X-MS-Office365-Filtering-Correlation-Id-Prvs: e0163a06-43ed-4652-a0b1-08d80b58fe2d
X-Forefront-PRVS: 042857DBB5
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3gMgCbtkBpxSrxIQXMF8cNrZ/GJM2ykFNkMzZ5gL3vcZhovhpS/pgAlcytWqGPSc5bSvJKJ3a5ce0fw381NPV75qUsw40imWV4jj7TktMBEepyIZeGP6N4S6d+WcyVhR4MJFi/DjzXs36YaxP9kVie0GCSR3459sKH1txHp6EDhGp+2uUlc6tj3CsPey27XxTp8Fohh1TtYNM4/JgDNH43wXoU8uAYjQpFyBk0esZaEtcG5XJstaqan1/vquPxtKxLHlQFOoBvSbY8LXUYR4i9/BDrSFwMK5ezCo8bGrCg6Bpffhc09XRpoHlbDkryQhZgyn9APkc8/DTlVUL8ElxxsmUNbAAXlF9TDi9JYP2o/Dci5B3YiMQXbp6aCqWOPaJhv707s2m+uJ1Q54DkflVA==
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2020 03:06:59.3428
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19d0217c-8a35-4e87-2ed5-08d80b59026b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0801MB1968
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU3RlZmFubyBHYXJ6YXJl
bGxhIDxzZ2FyemFyZUByZWRoYXQuY29tPg0KPiBTZW50OiBGcmlkYXksIEp1bmUgNSwgMjAyMCAx
MDozMCBQTQ0KPiBUbzogU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwub3JnPg0KPiBDYzogSnVz
dGluIEhlIDxKdXN0aW4uSGVAYXJtLmNvbT47IFN0ZWZhbiBIYWpub2N6aSA8c3RlZmFuaGFAcmVk
aGF0LmNvbT47DQo+IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IHN0YWJs
ZUB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2Ml0gdmlydGlvX3Zzb2Nr
OiBGaXggcmFjZSBjb25kaXRpb24gaW4NCj4gdmlydGlvX3RyYW5zcG9ydF9yZWN2X3BrdA0KPg0K
PiBPbiBGcmksIEp1biAwNSwgMjAyMCBhdCAwMjoxMDo0OVBNICswMDAwLCBTYXNoYSBMZXZpbiB3
cm90ZToNCj4gPiBIaQ0KPiA+DQo+ID4gW1RoaXMgaXMgYW4gYXV0b21hdGVkIGVtYWlsXQ0KPiA+
DQo+ID4gVGhpcyBjb21taXQgaGFzIGJlZW4gcHJvY2Vzc2VkIGJlY2F1c2UgaXQgY29udGFpbnMg
YSAtc3RhYmxlIHRhZy4NCj4gPiBUaGUgc3RhYmxlIHRhZyBpbmRpY2F0ZXMgdGhhdCBpdCdzIHJl
bGV2YW50IGZvciB0aGUgZm9sbG93aW5nIHRyZWVzOiBhbGwNCj4gPg0KPiA+IFRoZSBib3QgaGFz
IHRlc3RlZCB0aGUgZm9sbG93aW5nIHRyZWVzOiB2NS42LjE1LCB2NS40LjQzLCB2NC4xOS4xMjUs
DQo+IHY0LjE0LjE4MiwgdjQuOS4yMjUsIHY0LjQuMjI1Lg0KPiA+DQo+ID4gdjUuNi4xNTogQnVp
bGQgT0shDQo+ID4gdjUuNC40MzogQnVpbGQgZmFpbGVkISBFcnJvcnM6DQo+ID4gICAgIG5ldC92
bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9jb21tb24uYzoxMTA5OjQwOg0KPiBlcnJvcjogPz8/
Pz8/Pz8/Pz8/Pz8/dD8/Pz8/Pz8/Pz8/Pz8/Pz8/PyB1bmRlY2xhcmVkIChmaXJzdCB1c2UgaW4g
dGhpcw0KPiBmdW5jdGlvbik7IGRpZCB5b3UgbWVhbiA/Pz8/Pz8/Pz8/Pz8/Pz90bT8/Pz8/Pz8/
Pz8/Pz8/Pz8/Pz8NCj4gPiAgICAgbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1v
bi5jOjExMDk6OTogZXJyb3I6IHRvbyBtYW55DQo+IGFyZ3VtZW50cyB0bw0KPiBmdW5jdGlvbiA/
Pz8/Pz8/Pz8/Pz8/Pz92aXJ0aW9fdHJhbnNwb3J0X3Jlc2V0X25vX3NvY2s/Pz8/Pz8/Pz8/Pz8/
Pz8/Pz8NCj4gPg0KPiA+IHY0LjE5LjEyNTogQnVpbGQgZmFpbGVkISBFcnJvcnM6DQo+ID4gICAg
IG5ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9jb21tb24uYzoxMDQyOjQwOg0KPiBlcnJv
cjogPz8/Pz8/Pz8/Pz8/Pz8/dD8/Pz8/Pz8/Pz8/Pz8/Pz8/PyB1bmRlY2xhcmVkIChmaXJzdCB1
c2UgaW4gdGhpcw0KPiBmdW5jdGlvbik7IGRpZCB5b3UgbWVhbiA/Pz8/Pz8/Pz8/Pz8/Pz90bT8/
Pz8/Pz8/Pz8/Pz8/Pz8/Pz8NCj4gPiAgICAgbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0
X2NvbW1vbi5jOjEwNDI6OTogZXJyb3I6IHRvbyBtYW55DQo+IGFyZ3VtZW50cyB0bw0KPiBmdW5j
dGlvbiA/Pz8/Pz8/Pz8/Pz8/Pz92aXJ0aW9fdHJhbnNwb3J0X3Jlc2V0X25vX3NvY2s/Pz8/Pz8/
Pz8/Pz8/Pz8/Pz8NCj4gPg0KPiA+IHY0LjE0LjE4MjogQnVpbGQgZmFpbGVkISBFcnJvcnM6DQo+
ID4gICAgIG5ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9jb21tb24uYzoxMDM4OjQwOg0K
PiBlcnJvcjogPz8/Pz8/Pz8/Pz8/Pz8/dD8/Pz8/Pz8/Pz8/Pz8/Pz8/PyB1bmRlY2xhcmVkIChm
aXJzdCB1c2UgaW4gdGhpcw0KPiBmdW5jdGlvbik7IGRpZCB5b3UgbWVhbiA/Pz8/Pz8/Pz8/Pz8/
Pz90bT8/Pz8/Pz8/Pz8/Pz8/Pz8/Pz8NCj4gPiAgICAgbmV0L3Ztd192c29jay92aXJ0aW9fdHJh
bnNwb3J0X2NvbW1vbi5jOjEwMzg6OTogZXJyb3I6IHRvbyBtYW55DQo+IGFyZ3VtZW50cyB0bw0K
PiBmdW5jdGlvbiA/Pz8/Pz8/Pz8/Pz8/Pz92aXJ0aW9fdHJhbnNwb3J0X3Jlc2V0X25vX3NvY2s/
Pz8/Pz8/Pz8/Pz8/Pz8/Pz8NCj4gPg0KPiA+IHY0LjkuMjI1OiBCdWlsZCBmYWlsZWQhIEVycm9y
czoNCj4gPiAgICAgbmV0L3Ztd192c29jay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jOjk2ODo0
MDoNCj4gZXJyb3I6ID8/Pz8/Pz8/Pz8/Pz8/P3Q/Pz8/Pz8/Pz8/Pz8/Pz8/Pz8gdW5kZWNsYXJl
ZCAoZmlyc3QgdXNlIGluIHRoaXMNCj4gZnVuY3Rpb24pOyBkaWQgeW91IG1lYW4gPz8/Pz8/Pz8/
Pz8/Pz8/dG0/Pz8/Pz8/Pz8/Pz8/Pz8/Pz8/DQo+ID4gICAgIG5ldC92bXdfdnNvY2svdmlydGlv
X3RyYW5zcG9ydF9jb21tb24uYzo5Njg6OTogZXJyb3I6IHRvbyBtYW55DQo+IGFyZ3VtZW50cyB0
bw0KPiBmdW5jdGlvbiA/Pz8/Pz8/Pz8/Pz8/Pz92aXJ0aW9fdHJhbnNwb3J0X3Jlc2V0X25vX3Nv
Y2s/Pz8/Pz8/Pz8/Pz8/Pz8/Pz8NCj4gPg0KPiA+IHY0LjQuMjI1OiBGYWlsZWQgdG8gYXBwbHkh
IFBvc3NpYmxlIGRlcGVuZGVuY2llczoNCj4gPiAgICAgMDZhOGZjNzgzNjdkICgiVlNPQ0s6IElu
dHJvZHVjZSB2aXJ0aW9fdnNvY2tfY29tbW9uLmtvIikNCj4gPg0KPiA+DQo+ID4gTk9URTogVGhl
IHBhdGNoIHdpbGwgbm90IGJlIHF1ZXVlZCB0byBzdGFibGUgdHJlZXMgdW50aWwgaXQgaXMgdXBz
dHJlYW0uDQo+ID4NCj4gPiBIb3cgc2hvdWxkIHdlIHByb2NlZWQgd2l0aCB0aGlzIHBhdGNoPw0K
Pg0KPiBJIHRoaW5rIHdlIGNhbiBzaW1wbHkgcmVtb3ZlIHRoZSAndCcgZnJvbSB2aXJ0aW9fdHJh
bnNwb3J0X3Jlc2V0X25vX3NvY2soKSwNCj4gdGhlIGZvbGxvd2luZyBwYXRjaCBzaG91bGQgd29y
azoNCj4NCj4gZGlmZiAtLWdpdCBhL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9jb21t
b24uYw0KPiBiL25ldC92bXdfdnNvY2svdmlydGlvX3RyYW5zcG9ydF9jb21tb24uYw0KPiBpbmRl
eCBmYjIwNjBkZmZiMGEuLjE3ZjRjOTNmNWU3NSAxMDA2NDQNCj4gLS0tIGEvbmV0L3Ztd192c29j
ay92aXJ0aW9fdHJhbnNwb3J0X2NvbW1vbi5jDQo+ICsrKyBiL25ldC92bXdfdnNvY2svdmlydGlv
X3RyYW5zcG9ydF9jb21tb24uYw0KPiBAQCAtMTEwNCw2ICsxMTA0LDE0IEBAIHZvaWQgdmlydGlv
X3RyYW5zcG9ydF9yZWN2X3BrdChzdHJ1Y3QNCj4gdmlydGlvX3Zzb2NrX3BrdCAqcGt0KQ0KPg0K
PiAgICAgICAgIGxvY2tfc29jayhzayk7DQo+DQo+ICsgICAgICAgLyogQ2hlY2sgaWYgc2sgaGFz
IGJlZW4gcmVsZWFzZWQgYmVmb3JlIGxvY2tfc29jayAqLw0KPiArICAgICAgIGlmIChzay0+c2tf
c2h1dGRvd24gPT0gU0hVVERPV05fTUFTSykgew0KPiArICAgICAgICAgICAgICAgKHZvaWQpdmly
dGlvX3RyYW5zcG9ydF9yZXNldF9ub19zb2NrKHBrdCk7DQo+ICsgICAgICAgICAgICAgICByZWxl
YXNlX3NvY2soc2spOw0KPiArICAgICAgICAgICAgICAgc29ja19wdXQoc2spOw0KPiArICAgICAg
ICAgICAgICAgZ290byBmcmVlX3BrdDsNCj4gKyAgICAgICB9DQo+ICsNClRoYW5rcyBTdGVmYW5v
LA0KWWVzLCB0aGlzICh0KSBwYXJhbWV0ZXIgY2hhbmdlcyBpcyBpbnRyb2R1Y2VkIGFmdGVyIDRj
NzI0NmRjNDVlMjcgKHY1LjQtcmM2LTE3MTIpLg0KU28gdGhlIHN0YWJsZSB0cmVlICh2ZXJzaW9u
IGxlc3MgdGhhbiB2NS40KSBzaG91bGQgYXBwbHkgYWJvdmUgcGF0Y2guDQoNClNvcnJ5IGZvciBt
eSBsYXRlIHJlc3BvbnNlLCB0aGUgYXV0byBtYWlsIGlzIGZpbHRlcmVkIGJ5IG91ciBvdXRsb29r
IHNlcnZlciDimLkNCg0KLS0NCkNoZWVycywNCkp1c3RpbiAoSmlhIEhlKQ0KDQoNCklNUE9SVEFO
VCBOT1RJQ0U6IFRoZSBjb250ZW50cyBvZiB0aGlzIGVtYWlsIGFuZCBhbnkgYXR0YWNobWVudHMg
YXJlIGNvbmZpZGVudGlhbCBhbmQgbWF5IGFsc28gYmUgcHJpdmlsZWdlZC4gSWYgeW91IGFyZSBu
b3QgdGhlIGludGVuZGVkIHJlY2lwaWVudCwgcGxlYXNlIG5vdGlmeSB0aGUgc2VuZGVyIGltbWVk
aWF0ZWx5IGFuZCBkbyBub3QgZGlzY2xvc2UgdGhlIGNvbnRlbnRzIHRvIGFueSBvdGhlciBwZXJz
b24sIHVzZSBpdCBmb3IgYW55IHB1cnBvc2UsIG9yIHN0b3JlIG9yIGNvcHkgdGhlIGluZm9ybWF0
aW9uIGluIGFueSBtZWRpdW0uIFRoYW5rIHlvdS4NCg==
