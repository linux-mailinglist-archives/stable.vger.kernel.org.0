Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A99EEBCFB
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 06:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729663AbfKAFIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 01:08:19 -0400
Received: from mail-eopbgr1400137.outbound.protection.outlook.com ([40.107.140.137]:62880
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728737AbfKAFIT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Nov 2019 01:08:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EfBIERmh1rk4PO6aaKDMrhM5WTJE50PQUqX674oBSxt9s9U4oH85HGkzmUN9wnXlgaoPN8hHnNg4f4Zzt6uggUDqMKotZ62Hj4jWZR4OD6IRrc2bTDAbQokwICtALiJpIRbyUnKGWOO+hrGO/0RIpUs1nSRAHtNcdUgF5cN/6HrQnTCJ57H8jUgqXiHPbfgVyFnYVcW2SWYDi/DpSkAqAoAPp2xQRPyzIq0SIPfXoWmpd+3tiUQZec63WMdENeCfZy+jrUhA5C2YLzzlEAyGFDHtfdsTpQ7yvECYyOUV7CKXR21cawPOvCIz4X18BHOsPeWrwBL6HTui0QiPBjEjnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vyE3yt5dV1d6XZpKgjoxuv+yDBxROI5YpAcEhNS5P30=;
 b=mzrq37cMl6MFgp6L+u3O0iBS2hnFVRknNtx+50hwWM4uxgV0abmO/J59FWAAGbeO3N96LOXnRIlLE7kNEipNRLphQ/N9zRrlsErAgg6iynQIVDgw+R3sDRoM5hnCqBTxMT29MSs8IhLLZsvrNfPvY3BRlJ/BLNQpAthFYzWVAJsqj5CJWURV+0Wgp9A6jkQjVc74S+R4338HRK7NpT429nT77rokh1tUSi4SaE9qm6584TVsC5j52H+IrCcUzM65zVCGUmGNowQpGqH/WQ4NPSt2mcLwvQdkbeseuiSQGWhOZirJlkPFfhl7Kp0aYRmH4LpwyeGGX28BQ0mgP6BbXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vyE3yt5dV1d6XZpKgjoxuv+yDBxROI5YpAcEhNS5P30=;
 b=USTtYO6nW+ksT+cK/PzI+Vtd8Y47zdojIkqteRuotw548TkxhUpbHbYDgwK6Zp+bAiV5v+qYWUD2MPsg4OrKOEzGteQIaJRPfQL1Z6HbySgQuHTDuWwNV/Wvm8/Js86WPyMIuLTX55xWH2rpSy5rDYBn4JTJ89ML0k01JdPDcyk=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB3455.jpnprd01.prod.outlook.com (20.178.136.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 05:08:03 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::548:32de:c810:1947]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::548:32de:c810:1947%4]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 05:08:02 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     "REE erosca@DE.ADIT-JV.COM" <erosca@DE.ADIT-JV.COM>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC:     "horms@verge.net.au" <horms@verge.net.au>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Asano Yasushi <yasano@jp.adit-jv.com>,
        Yohhei Fukui <yohhei.fukui@denso-ten.com>,
        "REE erosca@DE.ADIT-JV.COM" <erosca@DE.ADIT-JV.COM>,
        Eugeniu Rosca <roscaeugeniu@gmail.com>
Subject: RE: [PATCH 2/2] PCI: rcar: Fix missing MACCTLR register setting in
 initialize sequence
Thread-Topic: [PATCH 2/2] PCI: rcar: Fix missing MACCTLR register setting in
 initialize sequence
Thread-Index: AQHVjxT2kZdfxah3ZU+EwXO4DqSuW6dzYaWAgAJefDA=
Date:   Fri, 1 Nov 2019 05:08:02 +0000
Message-ID: <TYAPR01MB45442B94AAFF1F7E8FFB0CE6D8620@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <1572434824-1850-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <1572434824-1850-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <20191030163431.GA882@vmlxhi-102.adit-jv.com>
In-Reply-To: <20191030163431.GA882@vmlxhi-102.adit-jv.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [150.249.235.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4173d98a-371d-442a-29d5-08d75e8978fc
x-ms-traffictypediagnostic: TYAPR01MB3455:
x-ld-processed: 53d82571-da19-47e4-9cb4-625a166a4a2a,ExtAddr
x-microsoft-antispam-prvs: <TYAPR01MB3455048B94FF4B0E2E6315ACD8620@TYAPR01MB3455.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(189003)(199004)(478600001)(66446008)(33656002)(55016002)(66946007)(26005)(305945005)(186003)(8676002)(7736002)(66476007)(6506007)(81156014)(66556008)(81166006)(76176011)(64756008)(4326008)(7416002)(3846002)(6116002)(71200400001)(66066001)(14454004)(71190400001)(9686003)(52536014)(76116006)(86362001)(2906002)(229853002)(5660300002)(11346002)(476003)(54906003)(110136005)(486006)(25786009)(256004)(316002)(74316002)(8936002)(99286004)(7696005)(446003)(6246003)(102836004)(6436002);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB3455;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MHZt+EXPnnkPxAh66I2rE39OdhtrVP19W9XDmVUTpPfooQbmEaaGlZv+QRBhCzjVqypfihQhKt0l+npBZKFn6u/XE7laUqbRU32J00jo2erdCAryftwfiP0vXJwZO4CCd8Rrud/zpECgQ2GwKMPqjxA0NMNWgu1Lgn/or4jarZiy1XGCBM1ZOSc2UEgATGRYXVLsgXTAabpKp04HkEYEXiGmgeqiNTsVSsSmYNkyGPSXF1B2fpYUVzmcrC2I9YYc76RwlLYNigWOajObKjHf7e4hrZ/HivqkQnGBhIK8qYkigiCA1wdelmh6WQ2IHQzDIpjx26jxu4QQb0MjGeP8Ayu30wxzuQ/evzFWkEjiFGXhFDB4NMydg0meUYz9LCXI/1B36P402kVqZnjo/yjsX74SKPBB2Vf49jHiKHnJi6aVswr9E5ig+pC8s8kyykHK
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4173d98a-371d-442a-29d5-08d75e8978fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 05:08:02.8487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0fr0zl7KkPo4jkQTavgV3hvKYYM0T0cSzsQFSvcfXuEIJnr8cSow/hG1TYDJIjdtLOp7hMC7B+OHtkPWbUgoc/DS+nR43fJa7lokNmqjMwcqPsmlWOXxiB24EkUaW1sB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3455
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Eugeniu-san,

> From: Eugeniu Rosca, Sent: Thursday, October 31, 2019 1:35 AM
<snip>
> > diff --git a/drivers/pci/controller/pcie-rcar.c b/drivers/pci/controlle=
r/pcie-rcar.c
> > index 40d8c54..d470ab8 100644
> > --- a/drivers/pci/controller/pcie-rcar.c
> > +++ b/drivers/pci/controller/pcie-rcar.c
> > @@ -91,6 +91,7 @@
> >  #define  LINK_SPEED_2_5GTS	(1 << 16)
> >  #define  LINK_SPEED_5_0GTS	(2 << 16)
> >  #define MACCTLR			0x011058
> > +#define  MACCTLR_INIT_VAL	0x80ff0000
>=20
> Actually, I do believe there is an inconsistency in the manual,
> since the following statements pretty much contradict one another:
>=20
> 1. (as quoted by Shimoda-san from "Initial Setting of PCI Express")
>    > Be sure to write the initial value (=3D H'80FF 0000) to MACCTLR
>    > before enabling PCIETCTLR.CFINIT.
> 2. Description of SPCHG bit in "54.2.98 MAC Control Register (MACCTLR)"
>    > Only writing 1 is valid and writing 0 is invalid.
>=20
> The last "invalid" sounds like "bad things can happen" aka "expect
> undefined behaviors" when SPCHG is written "0".

I asked the hardware team about the "invalid" in the SPCHG bit and then
this "invalid" means "ignored", not "prohibited". So, even if we write
the SPCHG to 0, no bad things/undefined behaviors happen.

> While leaving the decision on the patch inclusion to the maintainers, I
> hope, in the long run, Renesas can resolve the documentation conflict
> with the HW team and the tech writers.

So, I don't think the documentation conflict exists about the MACCTLR regis=
ter.
But, what do you think?

Best regards,
Yoshihiro Shimoda

> >  #define  SPEED_CHANGE		BIT(24)
> >  #define  SCRAMBLE_DISABLE	BIT(27)
> >  #define PMSR			0x01105c
> > @@ -613,6 +614,8 @@ static int rcar_pcie_hw_init(struct rcar_pcie *pcie=
)
> >  	if (IS_ENABLED(CONFIG_PCI_MSI))
> >  		rcar_pci_write_reg(pcie, 0x801f0000, PCIEMSITXR);
> >
> > +	rcar_pci_write_reg(pcie, MACCTLR_INIT_VAL, MACCTLR);
> > +
> >  	/* Finish initialization - establish a PCI Express link */
> >  	rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
> >
> > @@ -1235,6 +1238,7 @@ static int rcar_pcie_resume_noirq(struct device *=
dev)
> >  		return 0;
> >
> >  	/* Re-establish the PCIe link */
> > +	rcar_pci_write_reg(pcie, MACCTLR_INIT_VAL, MACCTLR);
> >  	rcar_pci_write_reg(pcie, CFINIT, PCIETCTLR);
> >  	return rcar_pcie_wait_for_dl(pcie);
> >  }
>=20
> --
> Best Regards,
> Eugeniu
