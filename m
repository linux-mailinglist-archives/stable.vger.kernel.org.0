Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5A681754B6
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 08:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgCBHnB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 02:43:01 -0500
Received: from mail-db8eur05on2124.outbound.protection.outlook.com ([40.107.20.124]:37729
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725446AbgCBHnB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 02:43:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZYYP3GNjrRN9Hsa6Gtf0Q7PJjrA5XWAY66RjVnMmBvetZw8zgwtz/DsBaxk5iVZLutr93E4l/FpU25xCuO1J96lJWnN+liLG1uiW5GcSL5JWT9K/FXN8QTTs5K9FtY/yErXVzRm5MPsKFFqRpbhU1M4BPZtYoDYbSeXG8KSly6QiOUDA3zRpcwjuu2WDy2pWdRnNnd4tkH02rxjghG1MwKmze4fUpXhrwR31lut4Yb5lb/nZBWSAzD9hwmmXdavr+ZsvkJ1/sLiYM+0zdFlJCYmWPz5uQ2txvy0JSiT0FkuXPmXlP5RiHFv5eu+kD8wG3UnrAlYvIOLa2FMGeVGTFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZBig3szRmUtkhCU8wZEcPNMUe6ZrFCN9ZKIUHJZFjc=;
 b=DQVctc2ZdzHPjOa0Xv2SRzImjPlzThB1x8cD7tiyY6ZgHeHYTLuF5WjZF8/oxXMxmz0V6GMo6YLh12F9vD1N6XBNm9aSyLqwCtWdor5DKzdW7SM/JhpwInm8mq6Rt1Yp45QuKpGZRq59DKfpSiaZgHlZQ5lxYf3BDXptyd/GkByEdRW9Tce1+2t80rejwPvOYsXZY9vHEXHxpnapJB1MwXypf7KPiKhzvmYmIrzFxjYYOUAh9qRL7G/RT3OFiwOduHuMqy8iaJDd8sbobBZShTqjhVMyWg9b1kl3ZmkIpMG/Q4kOok8gMnGlV7BEzUYdP2USEeWe/GcPgKuTvYLfQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZBig3szRmUtkhCU8wZEcPNMUe6ZrFCN9ZKIUHJZFjc=;
 b=mkNr6jZvgw9fTpS6GpzS311hP+YZmQR9abjtEXa8e4NAUr1AD+c297HidGMhZPmuEtIJO549HQ4wTvBTbqP8zx7OI9WYnPEKegk5ceP7NErUCnHdnKoiNvNYE+Wpw+XMqUWQBGt2q49m0R0aC5qwAIMdIO49Dte9jDfRxzFTS1g=
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com (10.167.127.12) by
 HE1PR0702MB3675.eurprd07.prod.outlook.com (10.167.127.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.5; Mon, 2 Mar 2020 07:42:56 +0000
Received: from HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::2806:c34c:d469:8e87]) by HE1PR0702MB3675.eurprd07.prod.outlook.com
 ([fe80::2806:c34c:d469:8e87%5]) with mapi id 15.20.2793.011; Mon, 2 Mar 2020
 07:42:56 +0000
From:   "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "pmladek@suse.com" <pmladek@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: LTS "sysrq: Restore original console_loglevel when sysrq disabled"
Thread-Topic: LTS "sysrq: Restore original console_loglevel when sysrq
 disabled"
Thread-Index: AQHV8GYvL7ZsI+Ea1kmPKrkj/6nrEw==
Date:   Mon, 2 Mar 2020 07:42:55 +0000
Message-ID: <563356cd76b666048db40743c169152f4b6efb53.camel@nokia.com>
Accept-Language: fi-FI, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tommi.t.rantala@nokia.com; 
x-originating-ip: [131.228.2.19]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dc19976f-eefe-4849-127b-08d7be7d527e
x-ms-traffictypediagnostic: HE1PR0702MB3675:
x-microsoft-antispam-prvs: <HE1PR0702MB36758D3EF03610448BF31DD8B4E70@HE1PR0702MB3675.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:949;
x-forefront-prvs: 033054F29A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(346002)(39860400002)(376002)(396003)(366004)(199004)(189003)(5660300002)(54906003)(71200400001)(66476007)(66556008)(64756008)(66946007)(76116006)(66446008)(110136005)(26005)(316002)(186003)(4326008)(2616005)(6512007)(8936002)(81166006)(81156014)(6486002)(8676002)(2906002)(6506007)(86362001)(478600001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:HE1PR0702MB3675;H:HE1PR0702MB3675.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1rGIJN2Bj0wQTNWc/al0gyEh6t5SSQft7jQ6YMrDgsb71t2QWpLkjGgs7EPry2yNaP4kqPg0D0so+z6Gv3uow/svJ69kPR14MV8hXZFSHRLs+8lfrNnzbdtdxr+ZhwxlMwq9v4OO3h3FXQKmPMMh4RZr1pd0aovLBX2B8itKg3fB8chFFccnCvCGhmfb3eVZczKw31MZkNe2yIL7/ZByo4nlWFRNp2EB1J07Pca2k8svLZExLygoqWzwmIV7kVNt3kxTVzjzCv8sfaNaJCRUb2Ly4HMuNMSrqeXXTmJy5D59kL9/GZQdYzJS3EfQK0BJOb8w5v2gAgrvkAka0+l2gUEV+PctWNk4+NGFwAgjrU+GZIOnbvJzWp+aiff27Y53qDIxVIGTBNWLQUTLN24KO0wrJ75Z7VoC795WArTUhMhnue3WC5CcJkyRePrOmdrv
x-ms-exchange-antispam-messagedata: eUTfHMMd2KFRZlLD7jTFQpJnLPVEB0IoXLTzX2DEPe/2wCSJ5ERpoUDIG2Iek5L/WBrSmb/u6jNFEgeD+Kfuk9Qv7BXLIGemFKr/rwxvrJbrEi3FBZCwisQ8d/X/2hERcTcyJjyNicttKaxIcctdIA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E317FF577A0C984D9596273F6C171CDA@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc19976f-eefe-4849-127b-08d7be7d527e
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2020 07:42:55.8339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bGmjKFxMLgrNBsy86vIjrnF4fXe6ukSldCkLsN7wg6e9lHZiVIgH/cLPuItxOGr3QFYDDlY84g7d4XIw6JbLLuDA37e1qbWjPIcqgIQ/rQI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3675
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZywgU2FzaGEsDQoNCkNhbiB5b3UgY2hlcnJ5LXBpY2sgdGhlc2UgdHdvIHN5c3JxIHBh
dGNoZXMgdG8gTFRTIGtlcm5lbHM/DQpUaGV5J3JlIGludHJvZHVjZWQgaW4gdjUuMS1yYzEgYW5k
IHNob3VsZCBnbyB0byBhbGwgcHJpb3IgTFRTIHZlcnNpb25zLg0KDQoNCmNvbW1pdCAwNzVlMWEw
YzUwZjU5ZWEyMTA1NjFkMGQwZmVkYmQ5NDU2MTVkZjc4DQpBdXRob3I6IFBldHIgTWxhZGVrIDxw
bWxhZGVrQHN1c2UuY29tPg0KRGF0ZTogICBGcmkgSmFuIDExIDEzOjQ1OjE1IDIwMTkgKzAxMDAN
Cg0KICAgIHN5c3JxOiBSZXN0b3JlIG9yaWdpbmFsIGNvbnNvbGVfbG9nbGV2ZWwgd2hlbiBzeXNy
cSBkaXNhYmxlZA0KICAgIA0KICAgIFRoZSBzeXNycSBoZWFkZXIgbGluZSBpcyBwcmludGVkIHdp
dGggYW4gaW5jcmVhc2VkIGxvZ2xldmVsDQogICAgdG8gcHJvdmlkZSB1c2VycyBzb21lIHBvc2l0
aXZlIGZlZWRiYWNrLg0KICAgIA0KICAgIFRoZSBvcmlnaW5hbCBsb2dsZXZlbCBpcyBub3QgcmVz
dG9yZWQgd2hlbiB0aGUgc3lzcnEgb3BlcmF0aW9uDQogICAgaXMgZGlzYWJsZWQuIFRoaXMgYnVn
IHdhcyBpbnRyb2R1Y2VkIGluIDIuNi4xMiAocHJlLWdpdC1oaXN0b3J5KQ0KICAgIGJ5IHRoZSBj
b21taXQgKCJBbGxvdyBhZG1pbiB0byBlbmFibGUgb25seSBzb21lIG9mIHRoZSBNYWdpYy1TeXNy
cQ0KICAgIGZ1bmN0aW9ucyIpLg0KDQoNCmNvbW1pdCBjM2ZlZTYwOTA4ZGI0YTg1OTRmMmU0YTIx
MzE5OTgzODRiOGZhMDA2DQpBdXRob3I6IFBldHIgTWxhZGVrIDxwbWxhZGVrQHN1c2UuY29tPg0K
RGF0ZTogICBGcmkgSmFuIDExIDE3OjIwOjM3IDIwMTkgKzAxMDANCg0KICAgIHN5c3JxOiBSZW1v
dmUgZHVwbGljYXRlZCBzeXNycSBtZXNzYWdlDQogICAgDQogICAgVGhlIGNvbW1pdCA5N2Y1ZjBj
ZDhjZDBhMDU0NCAoIklucHV0OiBpbXBsZW1lbnQgU3lzUnEgYXMgYSBzZXBhcmF0ZQ0KaW5wdXQN
CiAgICBoYW5kbGVyIikgYWRkZWQgcHJfZm10KCkgZGVmaW5pdGlvbi4gSXQgY2F1c2VkIGEgZHVw
bGljYXRlZCBtZXNzYWdlDQogICAgcHJlZml4IGluIHRoZSBzeXNycSBoZWFkZXIgbWVzc2FnZXMs
IGZvciBleGFtcGxlOg0KICAgIA0KICAgIFsgIDE3Ny4wNTM5MzFdIHN5c3JxOiBTeXNScSA6IFNo
b3cgYmFja3RyYWNlIG9mIGFsbCBhY3RpdmUgQ1BVcw0KICAgIFsgIDc0Mi44NjQ3NzZdIHN5c3Jx
OiBTeXNScSA6IEhFTFAgOiBsb2dsZXZlbCgwLTkpIHJlYm9vdChiKSBjcmFzaChjKQ0KICAgIA0K
ICAgIEZpeGVzOiA5N2Y1ZjBjZDhjZDBhMDUgKCJJbnB1dDogaW1wbGVtZW50IFN5c1JxIGFzIGEg
c2VwYXJhdGUgaW5wdXQNCmhhbmRsZXIiKQ0KDQoNCg==
