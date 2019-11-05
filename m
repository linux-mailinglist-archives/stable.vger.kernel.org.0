Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5734EF27C
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 02:16:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729758AbfKEBQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 20:16:27 -0500
Received: from mail-eopbgr1400123.outbound.protection.outlook.com ([40.107.140.123]:15582
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728602AbfKEBQ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 20:16:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gb3ZTldMv0WKKF9gZ0xTMoN5bKBnxm5NVgoOoM0NrP8pJy94iqeI+aW6EHrf+gKywa9Nen14pwuKAIJYLIKiBKVQvEMcUsPXjFNHkpwgQxphOQvZy2lqZoMnCfhCU+ufEwU9mlhlmV+8fpf1XgqG9dACdiAmOtQPsHq34BAj1wZB62zkKSkoSZpeDtSVamBG3m5R3j8UlrkERlOWf0nQfD91ECkquSbGX2RY+/a+JtrND0dYXS+JD+jrCz608xg1sXdhEs3l+SCuzSfaeyuqX1BQB084/0w+YqqZ8cUQIxRqAUGA7w8WqyYT5g44xmR+uJ1QpQg32mKzasxAt99xLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRm/sxrs0GunQJJPoxb2Tu4six5XCvLYrcUgzx2qSDM=;
 b=ANvDxUES0KWg4xaQIiIEo0DsABmthgFIILaDTeOFWVIxoGfQ0pE92cWtb/YIE7/77YnaMOJ8OA2EJnOVaTR2Yn7K0ZFzWAp6x5mlL5Xc8qvtH2xuRncrlTN+BAzCaQU7aq9Ifqj5nQ+t8FE2QSMbYOrRaGPzZXkCy1Za8RhVbcSpeUsPO+TNLOeooM4RAssiIOrdir1bRKDca9W+BkTa/+jtrQBe0k0xxSn9xYnERjAN/y6esFziDEQzsW5TETmUFnWaQ04ZX5OZHDXpE1FyvCWOMr+CMjN2t6mXHCkIyNa4+p0g4iH+X3zKFMu73s+KxP+zTsstUA/hChsQECHdRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRm/sxrs0GunQJJPoxb2Tu4six5XCvLYrcUgzx2qSDM=;
 b=S1cyk1ba6uO5HujJNUiDihVwIPM4P2W2oYL4lSXLc2j3izNky7fpyunNbKZZUzl9argwGkH8+4tzLMqaJJ7sBTXTZyPFUG73iULfT9xhOs5f9et2PJ4nL5bgLhMDALT2YLm7XRVU3VxR28q2W3MdeQhHoiCHtyw+R5w3bpqrhwY=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB2847.jpnprd01.prod.outlook.com (20.177.105.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Tue, 5 Nov 2019 01:16:23 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::6998:f6cf:8cf1:2528]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::6998:f6cf:8cf1:2528%5]) with mapi id 15.20.2408.024; Tue, 5 Nov 2019
 01:16:23 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Andrew Murray <andrew.murray@arm.com>
CC:     "horms@verge.net.au" <horms@verge.net.au>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Lorenzo.Pieralisi@arm.com" <Lorenzo.Pieralisi@arm.com>
Subject: RE: [PATCH 2/2] PCI: rcar: Fix missing MACCTLR register setting in
 initialize sequence
Thread-Topic: [PATCH 2/2] PCI: rcar: Fix missing MACCTLR register setting in
 initialize sequence
Thread-Index: AQHVjxT2kZdfxah3ZU+EwXO4DqSuW6d2JN2AgAWpo5A=
Date:   Tue, 5 Nov 2019 01:16:23 +0000
Message-ID: <TYAPR01MB45446E09055A4E222F6932C8D87E0@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <1572434824-1850-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <1572434824-1850-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <20191101104544.GA9723@e119886-lin.cambridge.arm.com>
In-Reply-To: <20191101104544.GA9723@e119886-lin.cambridge.arm.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [150.249.235.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9c67a8db-0124-4cfa-b490-08d7618dc61d
x-ms-traffictypediagnostic: TYAPR01MB2847:
x-microsoft-antispam-prvs: <TYAPR01MB284795ECC4467A8258693B0ED87E0@TYAPR01MB2847.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:983;
x-forefront-prvs: 0212BDE3BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(346002)(39860400002)(136003)(366004)(396003)(189003)(199004)(99286004)(2906002)(54906003)(6246003)(55016002)(81166006)(6916009)(316002)(6506007)(66556008)(7696005)(7736002)(186003)(102836004)(71200400001)(66446008)(76116006)(25786009)(8936002)(66946007)(64756008)(71190400001)(305945005)(76176011)(6116002)(81156014)(8676002)(4326008)(86362001)(446003)(11346002)(14454004)(256004)(6436002)(14444005)(66476007)(26005)(476003)(486006)(5660300002)(33656002)(52536014)(9686003)(229853002)(478600001)(66066001)(74316002)(3846002);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB2847;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pvpJYdCVk14t4rGjY9tKDJONG41i11k4COFQen0KNOqaEsJ4Wn7VGjboy9hROHYRXD7fYPLeLnHLGTdX6zHZUGlm2Xng7TPVcHpMYSjk5HGF6429wyqwO81u1HMvAoCohbIGnPQ0eUUgCiXpVxPv1knHcyHYckbj2+PNjWW+5OrAGSly6bAXVIKxKlhFXBEUV9elDw5dIWQd2c1EpyURe2Wa3rh19KdiOtRjW5eKkLByyqZIH4v2ZzZF9Mg3BvtiE7myzAeGQzsrklRAwqP8HE7OIFk4fdYJI8Ax9MEl1+gd7XsqOofADTyMhblHCKzZGTxSXfOnT9JwsKr2kZcZPq2TJ1AnvI71UE1IYxKf92PuvPenMq6G/eCPMlR8k5MUUr36xINY9fFb2OirBLIetH/JaHvvQo/5a7ONZnxtxs1Fn6YROgVqreKMZa0FsN6c
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c67a8db-0124-4cfa-b490-08d7618dc61d
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2019 01:16:23.6424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EOQcSaOi4mp3KIsU02Rb+oouh6oWoSQlqWzgA7M5uws7yH4Q9WRadPLrFSkTnIpbrL3iQ1NPOZPvFg2fp6aLAXyaIFlp6ssE11y/XQ8nleMMWo7fO5cv5dpjGN/ByaMD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2847
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Andrew-san,

> From: Andrew Murray, Sent: Friday, November 1, 2019 7:46 PM
>=20
> On Wed, Oct 30, 2019 at 08:27:04PM +0900, Yoshihiro Shimoda wrote:
> > According to the R-Car Gen2/3 manual, "Be sure to write the initial
> > value (=3D H'80FF 0000) to MACCTLR before enabling PCIETCTLR.CFINIT."
> > To avoid unexpected behaviors, this patch fixes it.
> >
> > Fixes: c25da4778803 ("PCI: rcar: Add Renesas R-Car PCIe driver")
> > Fixes: be20bbcb0a8c ("PCI: rcar: Add the initialization of PCIe link in=
 resume_noirq()")
> > Cc: <stable@vger.kernel.org> # v5.2+
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > ---
> >  drivers/pci/controller/pcie-rcar.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
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
> Geert's previous feedback was to avoid using magic numbers such as this. =
Is it
> possible to define the bits you set instead?

Oops, you're correct. I'll fix it.

> Also perhaps Lorenzo has some feedback as if he prefers these two patches=
 to
> be squashed together or not, rather than a revert commit.

I got it. At the moment, I'll update this series as v3.

Best regards,
Yoshihiro Shimoda

> Thanks,
>=20
> Andrew Murray
>=20
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
> > --
> > 2.7.4
> >
