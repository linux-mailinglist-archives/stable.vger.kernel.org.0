Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E618611E30D
	for <lists+stable@lfdr.de>; Fri, 13 Dec 2019 12:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfLMLzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Dec 2019 06:55:32 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:58428 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726750AbfLMLzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Dec 2019 06:55:31 -0500
Received: from mailhost.synopsys.com (badc-mailhost2.synopsys.com [10.192.0.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 35C87C0116;
        Fri, 13 Dec 2019 11:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1576238130; bh=kraXGo31KQ0Hn7jSpVngBxoEwahrA9VcSC7xCp0WKjI=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=aT/gea4d5fNodlrW9KcIfflGa2MoARdL466SufL+/iSBvDuI2sq/YNWtZmCumYafI
         chkHIUdHnSDdvQ11NaKNGTIfu5C22FWqKHyHQLMmdsUVV0ClIJY+VVTmvlwyQlruzB
         aexS0+plm4EeJ0yx9ZYlkUtjwLTF3Cd9fFQsZrqBmBuIsa26JNYYYgZqPmndgZHa6I
         +DRQ0oQGtDRw9/jzfLxDpvhn6gXcu1+qDsDkV1AWbrLrCBsey9LzhGoUVX3QetlFKP
         fSmjXu1Zv4LU6O1wXbGQfygxE8hpbVp9tLAV7Lie11vZTJnasCPh85p7Fg88c3jK+2
         VCyZyoD0WpKjg==
Received: from US01WEHTC3.internal.synopsys.com (us01wehtc3.internal.synopsys.com [10.15.84.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id AAD71A0083;
        Fri, 13 Dec 2019 11:55:29 +0000 (UTC)
Received: from us01hybrid1.internal.synopsys.com (10.13.188.44) by
 US01WEHTC3.internal.synopsys.com (10.15.84.232) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Fri, 13 Dec 2019 03:54:13 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.202.3.67) by
 mrs.synopsys.com (10.13.188.44) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Fri, 13 Dec 2019 03:54:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UBc1HiQs0Q3YuH/M9OjZZhkC/9OiwKwBHnafmXEuP9NIPwrOj9B2uqBnAbHev/bFa+756W8jzzYjo1pq6owD9zHQIKbRUeL9pngHJMAAIbaQL9rcNCJ4DOXdC/Q7j3SNh8HsnY46nHoy7ZvXFLE+Wj/eszJpcn5PT4aJu8mOK+GokF7WTaQYGujEU8tKAyK+lcM2caGadWiYkH1iDG9Y3OCoyS9NY0eOIm9xtHf6j7d68a4KVduQZeKR+lwUM/OuBqHUed9m4pnyvKgdBgtEiVEWwKqDaeKsJkz9DM81H83YAYFRMcp0XOLmN3Y1VvDSN8IrFPyJ5HoIdzB5/J8TOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kraXGo31KQ0Hn7jSpVngBxoEwahrA9VcSC7xCp0WKjI=;
 b=LyK0BDj61R47Xwgb3DmiwcRpAhWUqWzk4eQlyYfXXO6dHwdPesidrDuB2RqYi8uXeflXbrl9jhJAPEwIYCCu2joTfLwqX2qCclY4RTbrHmVBYFWJIeM9hqtgEKte4KKamN3FSkYbnnXjgZgr234rJyOTyhdNoEB+aZ51WsC4FNttPMCbgqjfomc+tBxJxjAkWMBBn5aP4Rl2+uQ7NJwvf5qPdUTKxRjXXujzUyugtfV0RMP2urn+uLTcxAaXvIKx0UHcHlRnoR/VIpJ1DNPrHn5Uyk53GproQuoLYYhZiTGabF1KbzD/Ds9CpFqX7KLJuaicZ/y9EQUEcaUpE26lDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector2-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kraXGo31KQ0Hn7jSpVngBxoEwahrA9VcSC7xCp0WKjI=;
 b=I7OjsViOMTHZEGXO4F3IR4I4M2HIjrzHh5m41F6BVkNIkXqcRdF6V6yq/MZLUUuMoUt8g3NgdwhkZHHHZZEqwQmjQd5n3Z6719knajF5wZDNMDoXa8AVAUqlEvwUjcsH8RcAVbo3/KCiwIsG8uPlHgxgeuL/r3+hVVHWLfWs31U=
Received: from MN2PR12MB4093.namprd12.prod.outlook.com (52.135.51.203) by
 MN2PR12MB2928.namprd12.prod.outlook.com (20.179.83.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Fri, 13 Dec 2019 11:54:11 +0000
Received: from MN2PR12MB4093.namprd12.prod.outlook.com
 ([fe80::d0e:7272:4a88:ffeb]) by MN2PR12MB4093.namprd12.prod.outlook.com
 ([fe80::d0e:7272:4a88:ffeb%5]) with mapi id 15.20.2538.017; Fri, 13 Dec 2019
 11:54:11 +0000
From:   Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc2: Fix SET/CLEAR_FEATURE and GET_STATUS flows
Thread-Topic: [PATCH] usb: dwc2: Fix SET/CLEAR_FEATURE and GET_STATUS flows
Thread-Index: AQHVpd4S46cbjx1MuUy0bLcfyWi1rqezZeCAgAAX+ACABI57AA==
Date:   Fri, 13 Dec 2019 11:54:11 +0000
Message-ID: <d89dc76f-ab19-e7e7-1375-534cd2cfaa1c@synopsys.com>
References: <f8af9e4b892a8d005f0ae3d42401fee532f44a27.1574938826.git.hminas@synopsys.com>
 <8736dsl4u4.fsf@gmail.com>
 <e314d265-6d87-eb7a-997e-52d77ccdb725@synopsys.com>
In-Reply-To: <e314d265-6d87-eb7a-997e-52d77ccdb725@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=hminas@synopsys.com; 
x-originating-ip: [46.162.196.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5f5e878d-4331-4f58-aaed-08d77fc32b09
x-ms-traffictypediagnostic: MN2PR12MB2928:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR12MB2928F1E3740CA7CB12709C44A7540@MN2PR12MB2928.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-forefront-prvs: 0250B840C1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(110136005)(81156014)(8676002)(8936002)(26005)(81166006)(6512007)(66946007)(76116006)(66446008)(2906002)(2616005)(66476007)(478600001)(64756008)(91956017)(186003)(66556008)(36756003)(31686004)(4326008)(71200400001)(6486002)(53546011)(316002)(6506007)(4744005)(86362001)(31696002)(54906003)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR12MB2928;H:MN2PR12MB4093.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pjPlAa2U+qOtOKE1UdUd+USb/SOy24iHHYeZoYUW3oK2qMfCdbdzqBMqiMoCWrcGB4ZgJSCLgzuAfEVEBMcLiegWby8PU7/ho9s5ctxAnS1DI20qflpMn/Jum6HUfJjLvERI6DcKB64YYeFiQ6Hh+tWNFca0jQfsTGYUcfuy9RnND7ahl2wfIVBk1fg5TDePWj4Hw+5rlM2hsr/eHsyRzUKAkTuPnrnAcxLbuPggS+DK7tpKjEE0F0xJ+fJuJxa9PnxE8z3/UR+YL18NWRum0PiuuFWBPvJVx1lHPVSQX5QRj+o3i1FBHwenBJKjpkbMUPbqCcOt4+7IwK8upMX0lMrmc0pYHFuwn392EgSYc4nkZMVqdA/cXLCwF6tPcZGjzUa6Zmt0dJ9qMnQiuhZrSlAuWRJxbYYIfS06dAOHTqiyxWqCfzwe4qQt9qOZth11
Content-Type: text/plain; charset="utf-8"
Content-ID: <AC14982FD750FC4980F258276B3337BB@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f5e878d-4331-4f58-aaed-08d77fc32b09
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2019 11:54:11.2284
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 18mHZZ+bFFdtO9luUkSWf98Ux6wXLQMYHQ3KQRbOphGnspQSOX0WA7v6n2g2MeUJ2L2ksfFdJBiT7unYKr6r9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2928
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgRmVsaXBlLA0KDQpPbiAxMi8xMC8yMDE5IDY6MTkgUE0sIE1pbmFzIEhhcnV0eXVueWFuIHdy
b3RlOg0KPiBIaSBGZWxpcGUsDQo+IA0KPiBPbiAxMi8xMC8yMDE5IDQ6NTMgUE0sIEZlbGlwZSBC
YWxiaSB3cm90ZToNCj4+DQo+PiBIaSwNCj4+DQo+PiBNaW5hcyBIYXJ1dHl1bnlhbiA8TWluYXMu
SGFydXR5dW55YW5Ac3lub3BzeXMuY29tPiB3cml0ZXM6DQo+Pg0KPj4+IFNFVC9DTEVBUl9GRUFU
VVJFIGZvciBSZW1vdGUgV2FrZXVwIGFsbG93YW5jZSBub3QgaGFuZGxlZCBjb3JyZWN0bHkuDQo+
Pj4gR0VUX1NUQVRVUyBoYW5kbGluZyBwcm92aWRlZCBub3QgY29ycmVjdCBkYXRhIG9uIERBVEEg
U3RhZ2UuDQo+Pj4gSXNzdWUgc2VlbiB3aGVuIGdhZGdldCdzIGRyX21vZGUgc2V0IHRvICJvdGci
IG1vZGUgYW5kIGNvbm5lY3RlZA0KPj4+IHRvIE1hY09TLg0KPj4+IEJvdGggYXJlIGZpeGVkIGFu
ZCB0ZXN0ZWQgdXNpbmcgVVNCQ1YgQ2guOSB0ZXN0cy4NCj4+Pg0KPj4+IFNpZ25lZC1vZmYtYnk6
IE1pbmFzIEhhcnV0eXVueWFuIDxobWluYXNAc3lub3BzeXMuY29tPg0KPj4NCj4+IGRvIHlvdSB3
YW50IHRvIGFkZCBhIEZpeGVzIHRhZyBoZXJlPw0KPiANCj4gRml4ZXM6IGZhMzg5YTZkNzcyNiAo
InVzYjogZHdjMjogZ2FkZ2V0OiBBZGQgcmVtb3RlX3dha2V1cF9hbGxvd2VkIGZsYWciKQ0KPiAN
CkdvdCB0ZXN0ZWQgdGFnIGJ5IGlzc3VlIHJlcG9ydGVkLg0KDQpUZXN0ZWQtQnk6IEphY2sgTWl0
Y2hlbGwgPG1sQGVtYmVkLm1lLnVrPg0KDQoNClNob3VsZCBJIHJlc3VibWl0IHBhdGNoIGFzIHYy
IHdpdGggYWRkZWQgIkZpeGVzIiBhbmQgIlRlc3RlZC1ieSIgdGFncy4NCg0KPiBUaGFua3MsDQo+
IE1pbmFzDQo+IA0KPj4NCg==
