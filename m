Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125D9216409
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 04:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgGGC2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 22:28:39 -0400
Received: from mail-eopbgr690088.outbound.protection.outlook.com ([40.107.69.88]:23125
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726900AbgGGC2j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jul 2020 22:28:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dwptldaA/eiNZThYdw09ysjDxFOxVqDAIb+2VJeiaKbc6E2TFabqW1/4POcbQjbDHTPxHOYALTVbg80gYoGHMO5Jiy72WoM45fdYL+Fub0xFFLWrTn6n56iLKUwka3dh7p4qMlAheYreqopRlmkLPrKQgYZyrE1ZzWaoKzh8d6OuzSlzBLwrYiz82L8+VHpGK8MLnI1Ig6El3hiOL2elNTMPvTptlLLZcByqsi5K51P0bp7p2aU/U3Jap6gdCmVk7/wb1usFAwfKxGQdIBnjRz+LHonZ9a10aTrY6QnzD5CgEzTJUWEYnXbmVt0+pp8m4QjCDSLbdVuiyYUZGe/bEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4IR/4ALF159AU4slbTgbM462PUfZuy39KdQfEFCM+E=;
 b=Osloj+sEhvn/lRQE4wDxSYxmGwBUE2vNUaZ+glzj61CjsftDQxAeXEeTj1HADtQFoMgF+4wCNz0dJJR1Ga4rmFuijO1Qluj6xFdKrdRJEZ46uwSM2aE4d5ReJXIqMQGb038RNezUnK0YXBv4zpSUK9/bfTV2wMIzHX6MCWpcquYGRWrTLIu3tQYtEhOQDy0OZT3//9BpXceDcRaQtmDhO099GrG6O1vOM+H8S/d8B5HrO5WDDcuHEPYJ9PAZJX79VawMy+JiwM27IzvuL5/RfglhzbjRIeu0cWTEZ1XxA/Pl1lql+iluVYEwVe+mCsf7tyIyPAOJvFC4fENqFMRCbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M4IR/4ALF159AU4slbTgbM462PUfZuy39KdQfEFCM+E=;
 b=RwMcdawMBSFSYxsJ23a54gs+JBk2ZO2P+llz9hXa+RqUOKFpCCb7xnaqw/1dJKtLSpcJGnLpwjiDqA8/vgy3qoOGoZsw/Wq4l4Da51z83XgbJl+jc8m28QmmedX7P5MiuqpnrDEEMzX1KVRyx+TdCDp2Jxk2YRX6JRjiH2amUYI=
Received: from BYAPR11MB2632.namprd11.prod.outlook.com (2603:10b6:a02:c4::17)
 by BYAPR11MB3608.namprd11.prod.outlook.com (2603:10b6:a03:b1::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Tue, 7 Jul
 2020 02:28:36 +0000
Received: from BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::3d7d:dfc1:b35d:63d1]) by BYAPR11MB2632.namprd11.prod.outlook.com
 ([fe80::3d7d:dfc1:b35d:63d1%7]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 02:28:36 +0000
From:   "Zhang, Qiang" <Qiang.Zhang@windriver.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "balbi@kernel.org" <balbi@kernel.org>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: =?gb2312?B?u9i4tDogW1BBVENIIHYzXSB1c2I6IGdhZGdldDogZnVuY3Rpb246IGZpeCBt?=
 =?gb2312?B?aXNzaW5nIHNwaW5sb2NrIGluIGZfdWFjMV9sZWdhY3k=?=
Thread-Topic: [PATCH v3] usb: gadget: function: fix missing spinlock in
 f_uac1_legacy
Thread-Index: AQHWU6GFwxzNMTsA4EC2CGkysfw8Xqj6934AgABoBsA=
Date:   Tue, 7 Jul 2020 02:28:36 +0000
Message-ID: <BYAPR11MB26323A0A7687EC2CE3C9E17FFF660@BYAPR11MB2632.namprd11.prod.outlook.com>
References: <20200705124027.30011-1-qiang.zhang@windriver.com>,<20200706195520.GA93712@kroah.com>
In-Reply-To: <20200706195520.GA93712@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=windriver.com;
x-originating-ip: [60.247.85.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e31533ee-dcfc-493e-10cc-08d8221d73a5
x-ms-traffictypediagnostic: BYAPR11MB3608:
x-microsoft-antispam-prvs: <BYAPR11MB36080443ADE5640615CAC0C6FF660@BYAPR11MB3608.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 0457F11EAF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jbRb6xHzJAcrne2zFqsXPaAh0sl/Z/RrtEhSzqu6rRlT8WwhDVxUvvIGzqcblrqm1VPeo4gKaH98AUQ2d4w75Wupja6NP/kDEhLoxIZ8R5j5oSibnbg+43G/V4JxOSNF7HpSRS3ki7dEWaS/zxdbO0nhK00BpkNaPteQZDsGIfG7iLYGq6WHYGaQMeiUqjFZNGrPV+rPYqcw+6M8GHbXU7XnaYO2+hlYDy+sPvr4se929GoU/O8bfucOEKiQjhWnmvCUcHZdiyhKhcc1gK2gLk3y8Z58NcdFLnvfaMiJPJsfxbDEu3RQRuatdG5XboHpTJt4ZmZ3we+oVc0g/GT22w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2632.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(376002)(366004)(396003)(136003)(346002)(6506007)(33656002)(4326008)(5660300002)(8936002)(478600001)(316002)(54906003)(52536014)(83380400001)(55016002)(9686003)(186003)(2906002)(64756008)(224303003)(86362001)(71200400001)(26005)(7696005)(6916009)(66946007)(66476007)(66556008)(66446008)(76116006)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /1a7oyF7Bz7TBs7XIi+TcbkuTFu5nmwNutj5N0yHd7P1PN9dMGZcVvmz7oDHTsuLJfTaKMl/9qCIa5XvfhqkNmPDOMF+KsmvkKLmFEcsMYTLamPhqTU3umfYN+9PuO+hsKpQotzHbd1T7shfWu7gzvO85Ch2fXCqx+oURSmg1oBFA9Q9ZlRjI/aFrNWlZXQj0iyI2A/anT5UyYZf+cSvmjJ+ArdUErbYCB9XOUAcCQ9L1jasduVtD7w7tsPQIS2vft4ds2QSb6z15LcGOkxM/aItrjvk8qXOfq5177EE6hUcJRLEqLo1Xd/2VjAB0aiJpWFUYwd08DrZXzQvIE9u8IPK9jWwHkZRYX+2Sg/UxeI9fClljO2+b23WAl52VAVRRVOvPnNDg/v0aaLLjsd2rIAriPkEhorPtp8P243t522FHYgH8W1RlaGbijx5RaTRtTkGCkIFxfSwPRBq7y01PjDWjie0+Av423D+WgOhaAM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2632.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e31533ee-dcfc-493e-10cc-08d8221d73a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2020 02:28:36.0909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: P4Okis8j9aNZi11RCU+QfQubjedBYX2OUrPzpr4ROtwMkF9kclhZcUtkoe6xTt52Rh9I0YBbXna2cv5PSWXDYJYFkOiEhPGAmY/svA3kQg0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3608
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZyBLSApJbiB0aGUgZWFybHkgc3VibWlzc2lvbjoKImNvbW1pdCBpZCBjNjk5NGU2ZjA2
N2NmMGZjNGM2Y2NhM2QxNjQwMThiMTE1MDkxNmY4IiB3aGljaCBhZGQgVVNCIEF1ZGlvIEdhZGdl
dCBkcml2ZXIgIiAgIAp0aGUgImF1ZGlvLT5wbGF5X3F1ZXVlIiB3YXMgcHJvdGVjdGVkIGZyb20g
ImF1ZGlvLT5sb2NrIgpzcGlubG9jayBpbiAicGxheWJhY2tfd29yayIgZnVuYywgQnV0IGluICJm
X2F1ZGlvX291dF9lcF9jb21wbGV0ZSIgZnVuYyAKdGhlcmUgaXMgbm8gcHJvdGVjdGlvbiBmb3Ig
dGhlIG9wZXJhdGlvbiBvZiB0aGlzICJhdWRpby0+cGxheV9xdWV1ZSIuIHRoZXJlCmFyZSBtaXNz
aW5nIHNwaW5sb2NrLCAgRml4IHRhZ3Mgc2hvdWxkIGFkZCB1cCBoZXJlIGNvbW1pdKO/CgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCreivP7IyzogR3JlZyBLSCA8Z3Jl
Z2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+Creiy83KsbzkOiAyMDIwxOo31MI3yNUgMzo1NQrK1bz+
yMs6IFpoYW5nLCBRaWFuZwqzrcvNOiBiYWxiaUBrZXJuZWwub3JnOyBjb2xpbi5raW5nQGNhbm9u
aWNhbC5jb207IGxpbnV4LXVzYkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc7IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcK1vfM4jogUmU6IFtQQVRDSCB2M10gdXNi
OiBnYWRnZXQ6IGZ1bmN0aW9uOiBmaXggbWlzc2luZyBzcGlubG9jayBpbiBmX3VhYzFfbGVnYWN5
CgpPbiBTdW4sIEp1bCAwNSwgMjAyMCBhdCAwODo0MDoyN1BNICswODAwLCBxaWFuZy56aGFuZ0B3
aW5kcml2ZXIuY29tIHdyb3RlOgo+IEZyb206IFpoYW5nIFFpYW5nIDxxaWFuZy56aGFuZ0B3aW5k
cml2ZXIuY29tPgo+Cj4gQWRkIGEgbWlzc2luZyBzcGlubG9jayBwcm90ZWN0aW9uIGZvciBwbGF5
X3F1ZXVlLCBiZWNhdXNlCj4gdGhlIHBsYXlfcXVldWUgbWF5IGJlIGRlc3Ryb3llZCB3aGVuIHRo
ZSAicGxheWJhY2tfd29yayIKPiB3b3JrIGZ1bmMgYW5kICJmX2F1ZGlvX291dF9lcF9jb21wbGV0
ZSIgY2FsbGJhY2sgZnVuYwo+IG9wZXJhdGUgdGhpcyBwYWx5X3F1ZXVlIGF0IHRoZSBzYW1lIHRp
bWUuCgoicGxheV9xdWV1ZSIsIHJpZ2h0PwoKPgo+IENjOiBzdGFibGUgPHN0YWJsZUB2Z2VyLmtl
cm5lbC5vcmc+Cj4gU2lnbmVkLW9mZi1ieTogWmhhbmcgUWlhbmcgPHFpYW5nLnpoYW5nQHdpbmRy
aXZlci5jb20+CgpCZWNhdXNlIHlvdSBkbyBub3QgaGF2ZSBhIEZpeGVzOiB0YWcgaW4gaGVyZSwg
aG93IGZhciBiYWNrIGRvIHlvdSB3YW50CnRoZSBzdGFibGUgcGF0Y2ggdG8gZ28gdG8/ICBUaGF0
J3Mgd2h5LCBpZiB5b3UgY2FuLCBpdCdzIGFsd2F5cyBnb29kIHRvCmhhdmUgYSAiRml4ZXM6IiB0
YWcgaW4gdGhlcmUgdG8gc2hvdyB3aGF0IGNvbW1pdCBjYXVzZWQgdGhlIHByb2JsZW0geW91CmFy
ZSBmaXhpbmcgaGVyZS4KClNvLCB3aGF0IGNvbW1pdCBjYXVzZWQgdGhpcz8KCnRoYW5rcywKCmdy
ZSBnay1oCg==
