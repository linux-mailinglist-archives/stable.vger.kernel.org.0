Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 476FF116D6E
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 14:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbfLINBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 08:01:02 -0500
Received: from mail-eopbgr1400122.outbound.protection.outlook.com ([40.107.140.122]:44960
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727437AbfLINBC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 08:01:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSiwJcib0iimkICflmf4uN7S4xvMdf5Q4K93uMZQd4/2Oft/aRJaDoiTC/tLS1D5CJUsPzHNu8VqkuHYzPMT9kK8pmrdBKA2jsYngwCpmJPKasnInp/zoULYnAIqmgwlwiDgkxHk4/f5y7LgTenTKP0jmDe0H0G1hkxOLCpJ/Nn5lBaRJQoeX4vEoTU9xlwHpzvuUwEkJ76BMcO5SCuEQWAw8yxOaFBP2UpET0n/B+eSF+zqjNH9hFi40Y3X3+YYic+F2XiFbc0qhFfAYZJ7cpf6zScrRUYL+7yGP2u0cW8bPiLgWv/0jGcRTjQdq0TS/eoV5bJeCTqtbERFuSpvfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5AKnniztpr7Y3n64nGFMWkcQg+GgNEpX9Y4n5WzHOMw=;
 b=UYJS6IziBdyqdkqcOFcK9B0CT3ybbEMe2yjVZ1Rq7l2vR0EjTBmbhFyXrFUHIvZILEWnB7y0WhFtfQo6BjlXWZNrtDdRXdobuVxjE/JLo1lVb3zkPmx0AALn1IIjElFOdAJpWhXGfnr3YWy+u/HYw1ueUJY5cIIMtRe1utL2h+FJtjHod8RbE2EHfKLyup3Z1I7jzpYd0QaQJcgXUx0cQxaj1Ht7dncEDDTBaXgNSr5fwlbq8QxZRoC5IQ172/PhySf9ogQu9HFU1Psyt9i24U6lhnwgwsuWoMtyn/hbVpm1lzWnOU9MFicQ3vP+a4hBpsNHARewzxQY7N44X9u9bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5AKnniztpr7Y3n64nGFMWkcQg+GgNEpX9Y4n5WzHOMw=;
 b=CQkUhcTOjlv8AKuPNRaPsO7losG7nm2AZ1pnkve5mJ4pz1GDL/4ur8tal1dL8xXQOxoWUc5faFT+84LZisjI7tUO5R6D5qTSODdnQKWH4l8p9iYw67efDs6LxPrex29Sgz07y3RcdeP9O9/CP76165SBudHUGwdjRkfy1ZKUi+8=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB3901.jpnprd01.prod.outlook.com (20.178.139.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.13; Mon, 9 Dec 2019 13:00:59 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5025:20cb:31a2:4be1]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5025:20cb:31a2:4be1%5]) with mapi id 15.20.2516.018; Mon, 9 Dec 2019
 13:00:59 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Latest stable-review releases?
Thread-Topic: Latest stable-review releases?
Thread-Index: AdWujqTrZLhelHs0Rwe1wAvCU9PFAg==
Date:   Mon, 9 Dec 2019 13:00:59 +0000
Message-ID: <TYAPR01MB22853B1C228C3D7A0C35B064B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 45e3551c-ff47-42f3-151b-08d77ca7d647
x-ms-traffictypediagnostic: TYAPR01MB3901:
x-microsoft-antispam-prvs: <TYAPR01MB39015EC76BFF2BA26257136CB7580@TYAPR01MB3901.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(199004)(189003)(4744005)(8936002)(186003)(81156014)(81166006)(71200400001)(71190400001)(8676002)(55016002)(2906002)(316002)(3480700005)(6506007)(9686003)(86362001)(5660300002)(4326008)(52536014)(66946007)(76116006)(33656002)(7696005)(66446008)(305945005)(26005)(66556008)(6916009)(64756008)(478600001)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB3901;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cqY3oNBNZe5S0zxk4pmvwAysJNzV0gTdJfWDctH++R0V2ylg4xopx4rbx9VIXsjSdYL+mZtKbZh3ce6fsvRYhvRCBWiDSeJttPrrMzLUPDTZgd4TIxgL8vEUm/YFMjIPeKhjFr2d4p+tEvWO0g9U32CoCeX7zquLya9Puxa7pEnJUUPQA25DQK/aPLM6b1ATiD3LmK3Af9rQczcqXrR/oWSToRCEsb/m+UwqEAFYuy2vunlZHr6DEnFklURxFZGic8k127A7QrNL31aAk7mPm6Jto2ZJ9OzEccbaCFv/scUkQxzNOIcS6dYFIRRKaV0srogjLIoSrPUAB8jqTp+1l2qpObyA7OTWwpf4wgjRPx5rRVHL6miAzQPGtWwt9wvNaCtooIOASII/dsW/CYumt7aiNWaO+sa3UhRIgGhCgbuq9S4u9jwZGLzb+VzzIbka
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45e3551c-ff47-42f3-151b-08d77ca7d647
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 13:00:59.1020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tH6C23BhwW9DCW/CE3fMnyNjTjHjNU+Y9UEWPbBgpmrFuTrDa1pbKiwLs/+30fV5jrnAwVPvu6nkIML+yDUdRW2cM3q6X3Rw9bNJfTpd3E0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3901
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

I see that you pushed 4.4.207-rc1 and 4.19.89-rc1 commits on linux-stable-r=
c at the weekend, but I haven't seen your usual "stable review" emails to t=
he stable mailing list.

Am I just failing to find them or have you not got around to sending them y=
et?

I ask as I've seen some build issues, but didn't want to make noise in case=
 the next 4.4/4.19 rc releases aren't ready yet.

Kind regards, Chris

