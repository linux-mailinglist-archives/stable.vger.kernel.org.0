Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 953B3F860A
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 02:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfKLB0V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 20:26:21 -0500
Received: from mail-eopbgr1410128.outbound.protection.outlook.com ([40.107.141.128]:32692
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726962AbfKLB0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 20:26:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MVaorG7zPK+8rXs7fCWSKQVt1ptAcc6eqmJHpVaN4P22uFDrDnLSuKqv5b/vYrX3xUXprL4xFjumlVlnBnxpKyPCvfHV+nrFg9WnWJ8LRuwMG1DoMTOSfbXkATyBe5+Djh14h5aKcLG3gyqeFy9zBEcbn5/H1Qh0k/U4y2ADxtnFfH+K1WUF7ZnaKxGwT1NnABPY8mAD77jPwQV8slqI6Pmgnh4h4L00WEPc0FOft7Xx+5ABLAz9aBEXsYYnGvXRwA4ovIE3u8oldfz67lJ2Q7FNxFwiwe/MflIIkoT4NGxkbYdj3KPCFLSI853Z/0JWK9x+zxmDaLTrdssvlz5FUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4KgSDd6W1krHnOvkPQK7jY53rjk19lK4eakHDto68XU=;
 b=iBV3RSua6kHLzgYf2r1FmSntBdz5sDU1WxhEek/AZtpU+xtuXsHnKi1bNk+Q8xzbSvh70CfIJyjq+KxQW/m1gkr0XcBmVSELsy8WTAiTedCy6CbKBtQDHSo7+ZCQFZ0dORRCld7cGQI8mwfcWl/d2ECoWgoE5Ic88jL9eX7SsLb9WSr4XAiF3dvKttqQDQ3azettr1s4CyJ96DXEtCJtQJytDc5VDLtkQo1JN43Kwy+keEOSVAZLua3WrlVXcDeqg8rB13twSDVxPPMripln2+j72KxKPMr1d4U5w1eFdhYIRL+qQ1yQz9ji2lbilgptBV7pNraBUKSlSSaoVMMiZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4KgSDd6W1krHnOvkPQK7jY53rjk19lK4eakHDto68XU=;
 b=DbyAbY4wwhfnSBCPpnrfwkhHZG4WwYxWkL+GLtI6cAmQyWtOHVVQpH1y/ZjGPcPEMsFH93dEf7hqNaj88isGd6syyEoMZbJDcmjmG0030sy/AFEdusDBkFNqqwBaze8mmHbygZP32HICzSBpfBA/iVHFFHZoUs0a+F70bvPvjyM=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB2862.jpnprd01.prod.outlook.com (20.177.101.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Tue, 12 Nov 2019 01:26:16 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::6998:f6cf:8cf1:2528]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::6998:f6cf:8cf1:2528%5]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 01:26:16 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC:     "marek.vasut+renesas@gmail.com" <marek.vasut+renesas@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v4 1/2] Revert "PCI: rcar: Fix missing MACCTLR register
 setting in rcar_pcie_hw_init()"
Thread-Topic: [PATCH v4 1/2] Revert "PCI: rcar: Fix missing MACCTLR register
 setting in rcar_pcie_hw_init()"
Thread-Index: AQHVk8b8IQkr90MvDUeJ+YAJwjpCjaeGE+yAgAC0k9A=
Date:   Tue, 12 Nov 2019 01:26:16 +0000
Message-ID: <TYAPR01MB4544C4D4103EC2C9ACFB672ED8770@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <1572951089-19956-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <1572951089-19956-2-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <20191111143853.GA9653@e121166-lin.cambridge.arm.com>
In-Reply-To: <20191111143853.GA9653@e121166-lin.cambridge.arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [150.249.235.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5f84f074-6984-4c45-26a0-08d7670f5052
x-ms-traffictypediagnostic: TYAPR01MB2862:
x-microsoft-antispam-prvs: <TYAPR01MB2862F11D38647E962D583F4CD8770@TYAPR01MB2862.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(189003)(199004)(66946007)(9686003)(8936002)(55016002)(81156014)(81166006)(8676002)(6436002)(229853002)(71200400001)(256004)(14454004)(7696005)(33656002)(6246003)(74316002)(76116006)(6916009)(52536014)(4326008)(6506007)(102836004)(446003)(11346002)(5660300002)(25786009)(99286004)(186003)(76176011)(26005)(476003)(486006)(478600001)(66066001)(71190400001)(316002)(305945005)(3846002)(6116002)(54906003)(4744005)(7736002)(86362001)(2906002)(66446008)(66476007)(66556008)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB2862;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jzGjTmFh773FCmK2hA4G+lZnpfCoP5VcPm3JyStEv2ty9FQ6jNf16j1tdmxkOqfUTqL9hjNTxD0e6EFU40leWDU6QudMkyE9OyftYscTaYZNcI34FmzrQak/1nuDX71vLHY+qIL5WWTiG9jFU/EZP11nEWY1ZbeQ/2Y/rUaR64KrpBdDqGnfDqTVZiF6coWpK/JROWAjSf3x10vNCDdv1INkqlbyUhwM+UFsyawhVmoL3AcHFShfpabtms0qIm6LYuNPjYFcGBmgJquzGav6nd/lamTLLlR632wFS2srVOkeIEPAF/95J4iltzm0OezFYChWHIdE6RBbgy00TFFrlQTz5jM2CQdI/RRjWMwPsM+Z7rZK6kmQscoVczNv5GgRu3+vgui5Yl8mhdTdst+/hbw+d5a0IRTwQEaZ43R//VyUX6y89GLwGf3F410C6zWk
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f84f074-6984-4c45-26a0-08d7670f5052
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 01:26:16.4886
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W+IOoZhZToSrnal17WI9zxkJTIjaj0fJDovsGvWxNkHARDhDVAHoMqMsG4aXmXgY5OSeK4mLNxBnbOrsf3uJm7D3aPuOdS7gLWanTLzJrElsVQX0O1k15YG/n5p+xOQ9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2862
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Lorenzo,

> From: Lorenzo Pieralisi, Sent: Monday, November 11, 2019 11:39 PM
>=20
> On Tue, Nov 05, 2019 at 07:51:28PM +0900, Yoshihiro Shimoda wrote:
> > This reverts commit 175cc093888ee74a17c4dd5f99ba9a6bc86de5be.
> >
> > The commit description/code don't follow the manual accurately,
> > it's difficult to understand. So, this patch reverts the commit.
> >
> > Fixes: 175cc093888e ("PCI: rcar: Fix missing MACCTLR register setting i=
n rcar_pcie_hw_init()"
>=20
> This patch is not in the mainline, I will just drop it.

I got it.

> > Cc: <stable@vger.kernel.org>
>=20
> This is valid for any fix: there is no reason to send to stable a fix
> for a patch that is not in the mainline yet.

I understood it. So, I'll drop both tags on v5 patches.

Best regards,
Yoshihiro Shimoda

