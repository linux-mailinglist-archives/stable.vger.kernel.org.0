Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53937F8693
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 02:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfKLBsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 20:48:07 -0500
Received: from mail-eopbgr1410115.outbound.protection.outlook.com ([40.107.141.115]:8944
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726793AbfKLBsH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 20:48:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kPliTW9xEUJ29zQAEeBX5t7KenuelWbI6/G3lL6ZG5KPgevRlEMeNp23Tdp5W+JoFlH2FNruOL7N7srj4dWNdy2qnXaw22tWAXeuWRUDoljP9z0U8uhvPv7fZhbWFtKxdBu/YSQIrfAxXgQ+lB8BrRnJ+tOqQtG/UhbkxFQWPF02UGQT2dWdeFaU/1a8wL/DuPcpF98nUhqew+lf7P241FJ/E3KEGR7lJjuUjUnFhn0nbyEVxKH7BW2gg6KK7H3uvsWlPyGv+h75qRwqLACbYAVc7wuWZDiy17W+smcpMCv4Cgz3cYGa+57SNzWlo9ZHxhrd4FNolhYvdT2TjNXhQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DMVr8C3gmBZwoHjRyzfkckvP/TxN1T4lTqOreSTyZmQ=;
 b=OLnXP93Q0Wma4mepPQ6Qv2f/TgHnZia1VIo9b2fQM28nyMQFIjaj59P0rJ7ofinJ4apHY2+0cYl8u1Q7EtSwm38iwRGaviV0l/+mlO7Sl0MZamgy+Um0LuC02VyMpLF4BqVeWYJ+t0YEEk1CTqId59YBbdyLSDoSgZbDA9B1TTKo/2Wg5sfXZPDZQouje6sjjPon1NpU0t/OEf/x7q4zFllPCWU//kRXRP4AsfKdvqXHlzXGlLcgGn70BTaJ/58ti4oJU/lS/8I+O9Atw7t3S+7rZ+GBksNhOjLjuP5SjRmw+OHs0T5jWXqS+21UhfLLY/MZhvJd0w1vL5pLLZHTBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DMVr8C3gmBZwoHjRyzfkckvP/TxN1T4lTqOreSTyZmQ=;
 b=l/VWGMVofwZWT5QLZzhzm/zwPT07srBCoURPmpCcIEjA1EW5Z796kZJ2MJVmvfwLmQfi7QrQRQnUsMRRpPARQ37INPnEORUjpdMuYHhimzh24P9EBDgWDfHOXlJ758fHPR4DOfmL1+G2Nw5w9ZOu8Tt5MYPKwr08yPZBA2CJgCk=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB2477.jpnprd01.prod.outlook.com (20.177.101.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Tue, 12 Nov 2019 01:48:03 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::6998:f6cf:8cf1:2528]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::6998:f6cf:8cf1:2528%5]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 01:48:03 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC:     "marek.vasut+renesas@gmail.com" <marek.vasut+renesas@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v4 2/2] PCI: rcar: Fix missing MACCTLR register setting in
 initialize sequence
Thread-Topic: [PATCH v4 2/2] PCI: rcar: Fix missing MACCTLR register setting
 in initialize sequence
Thread-Index: AQHVk8b75iTnpBH/kkeyIqRIXE+o+qeGFPYAgACz2rA=
Date:   Tue, 12 Nov 2019 01:48:03 +0000
Message-ID: <TYAPR01MB4544F0F0BCAC5116731D15A9D8770@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <1572951089-19956-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <1572951089-19956-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <20191111144236.GB9653@e121166-lin.cambridge.arm.com>
In-Reply-To: <20191111144236.GB9653@e121166-lin.cambridge.arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [150.249.235.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c7f28b3c-5422-42e7-88d2-08d767125b4d
x-ms-traffictypediagnostic: TYAPR01MB2477:
x-microsoft-antispam-prvs: <TYAPR01MB2477609D087BDC66AE64B76CD8770@TYAPR01MB2477.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(366004)(346002)(39860400002)(136003)(396003)(199004)(189003)(476003)(52536014)(76116006)(6246003)(486006)(74316002)(99286004)(86362001)(8936002)(186003)(4326008)(6916009)(7736002)(5660300002)(6506007)(7696005)(66946007)(54906003)(26005)(11346002)(446003)(305945005)(33656002)(66476007)(76176011)(102836004)(71200400001)(64756008)(66556008)(66446008)(2906002)(71190400001)(66066001)(25786009)(478600001)(9686003)(81166006)(81156014)(55016002)(6116002)(3846002)(6436002)(14454004)(256004)(8676002)(229853002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB2477;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w6lTA6Lljysda4etcbVWZUDiUz9fvkfojtWpup297xewuYsq0Z4zE/PnNKm9yU6b+NC66C0UyrjvLMpy1aybNqeyZsEyH5gYDotejyuVflYO4A5YARnjPrMJlyzXOeeJsZ2IYe+gzwEufOGX4o9iVXCB2mx0Lr0a4OlO4H3msI/4Yc/Q5BqBQfmUc7YfGx0xrx+z7yJd5orC4FN6uaND02ILzQ2hDQLcVvwEV6YgEYDcS6hLlQan7h8+G79qmTeiuLlJjOilnjjWBzzRm4q8Popdq/rrZs/NoV1pvyFMJh87knQv4jrtVlxkyCh169C9B8h5D5AsYHlLHFWtykvFQjwefYeYaRl4WM/ovl0zulvkjEJJetwglOWym5jCxDjO71KvyD0JMnEkE5TallzMRufzrw1Msg6ErRyBw3ZLYKMsia31WYUBKuzT1Dv4jH2D
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7f28b3c-5422-42e7-88d2-08d767125b4d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 01:48:03.3965
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QofVbJGes9RBcxmt0lAjaOxpGZ+2YuU5hbV9UBnhIVrOhvp6PcloI4/Kr9bCH2ToYq9629ZRzxtMc8YheLlm8saJ7gB7vPJnDLHh+qIu3bTs9OmH8zGm9k00HVLn8D5Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2477
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Lorenzo,

> From: Lorenzo Pieralisi, Sent: Monday, November 11, 2019 11:43 PM
>=20
> Never ever add stable@vger.kernel.org in the CC list of the email
> header. You should add the tag in the commit log as you did but
> never CC stable when sending the patch email.

Thank you for the pointed it out. I had added stable@vger.kernel.org
in such cases, but I understood it. I will drop stable@vger.kernel.org.

> On Tue, Nov 05, 2019 at 07:51:29PM +0900, Yoshihiro Shimoda wrote:
> > According to the R-Car Gen2/3 manual, "Be sure to write the initial
> > value (=3D H'80FF 0000) to MACCTLR before enabling PCIETCTLR.CFINIT".
> > To avoid unexpected behaviors, this patch fixes it. Note that
> > the SPCHG bit of MACCTLR register description said "Only writing 1
> > is valid and writing 0 is invalid" but this "invalid" means
> > "ignored", not "prohibited". So, any documentation conflict doesn't
> > exist about writing the MACCTLR register.
>=20
> I am sorry but I don't understand what you mean, if either you or
> any rcar maintainer can help me rewrite this log I will merge this
> patch then, appreciated.

I'm sorry. I think I should not drop a sentence "because the bit 0 is
set to 1 on reset" which has the reverted patch from this version. Also,
the note seems to be difficult to understand. So, I'll rewrite this log
like below. Is it acceptable?

---
According to the R-Car Gen2/3 manual, "Be sure to write the initial
value (=3D H'80FF 0000) to MACCTLR before enabling PCIETCTLR.CFINIT"
because the bit 0 of MACCTLR is set to 1 on reset. To avoid unexpected
behaviors, this patch fixes it.

Note that the SPCHG bit (bit 24) of MACCTLR register description said
"Only writing 1 is valid and writing 0 is invalid", but this "invalid"
means "ignored", not "prohibited". So, even if the driver writes
the SPCHG to 0, there is no problem.
---

Best regards,
Yoshihiro Shimoda

