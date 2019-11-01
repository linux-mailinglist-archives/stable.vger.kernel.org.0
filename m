Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAEAEBE06
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 07:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfKAGjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 02:39:08 -0400
Received: from mail-eopbgr1400103.outbound.protection.outlook.com ([40.107.140.103]:6122
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725936AbfKAGjI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Nov 2019 02:39:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MzdLuJZ4BOzRPJ7/oKVcMIEkL0WnypJNtVLAg/BJoaMKxBR6Qxl2v3RflxWEyFBbSBO7hIZ9Ru4TFTQr6nZPNx4+ADoVxh1+XHecahq3lOaTCU/327/DtB6DZRygyqnUZNWhfP6mLqOzQ1uGK4N58TJGHt66pRe1fGQlhjBCBWrHiC9cfuWdULmNbgUZx6NU2JKoyzTbhA4m/E7YsTOd78Lcb3B4PREbHG4rllr64K350aZ8ZQSbncBd6gnBuy/WYAkv5QN9ZMUkJcd+qePvs+1OE+U7t5wkfmFH8bbh5nZfzXPEkVWCxPATpn7iTM9p/kQX+oE6T6v5cdKOIr8D5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2qB9oo/nloZeIoedEbj2vJawQIfQfwnmmYyHpxR15U=;
 b=btBju0khnaFoDKOh9qIA2QVKIYl5FvUAdzE9M4AWaniwymu3YrmQ1/VDbqGTZBJQYL1jYOVK6Ett3wI9IJgFJk0bBe+EmesHGfHBdFLzFdkgRTW6Wu3Nhm1HLLrIMBl9wmBgvrfsFb5bsTaxtrGKxBZdrwA66JvHnoYkdhx6DbLwpeHSQLmjcvNHOAcWW3LhZF2yEWdokt0nZ6Fpei004tSQToZL6da5J6aOWHDGiZagoKTgnOULTgWUIhWiMxAoWzgxp8UjVtk3jD4d5SM23U31ixM4xZfG1YG0qKX99VyQz2l73cWL7sffj93O2HQrVCEn5QZDS3YCvaehZxS7ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2qB9oo/nloZeIoedEbj2vJawQIfQfwnmmYyHpxR15U=;
 b=Fqh0fLKmAgtJqHYpkMsOYl8NQleqIwDKSaib8v1/uRc+0MfrNNy6wsN1GMqqYTg/AbuBClQ+4ONdQ9MKlAlD3edm4TavIoTRosJp24l2fYRHeCDs3JrRe8y307wq3dpAcwlIoOGH+MboVy08Ugg45QMdaeTIlpQ0Xt/Uy1AqXh4=
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com (20.179.175.203) by
 TYAPR01MB5055.jpnprd01.prod.outlook.com (20.179.187.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.18; Fri, 1 Nov 2019 06:39:04 +0000
Received: from TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::548:32de:c810:1947]) by TYAPR01MB4544.jpnprd01.prod.outlook.com
 ([fe80::548:32de:c810:1947%4]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 06:39:04 +0000
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
Thread-Index: AQHVjxT2kZdfxah3ZU+EwXO4DqSuW6dzYaWAgAJefDCAAB7e4A==
Date:   Fri, 1 Nov 2019 06:39:03 +0000
Message-ID: <TYAPR01MB4544C58FAB805796583B428AD8620@TYAPR01MB4544.jpnprd01.prod.outlook.com>
References: <1572434824-1850-1-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <1572434824-1850-3-git-send-email-yoshihiro.shimoda.uh@renesas.com>
 <20191030163431.GA882@vmlxhi-102.adit-jv.com>
 <TYAPR01MB45442B94AAFF1F7E8FFB0CE6D8620@TYAPR01MB4544.jpnprd01.prod.outlook.com>
In-Reply-To: <TYAPR01MB45442B94AAFF1F7E8FFB0CE6D8620@TYAPR01MB4544.jpnprd01.prod.outlook.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yoshihiro.shimoda.uh@renesas.com; 
x-originating-ip: [150.249.235.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 829dc6da-dfbe-4d8e-bcdd-08d75e96301d
x-ms-traffictypediagnostic: TYAPR01MB5055:
x-ms-exchange-purlcount: 1
x-ld-processed: 53d82571-da19-47e4-9cb4-625a166a4a2a,ExtAddr
x-microsoft-antispam-prvs: <TYAPR01MB50558F96BD4F6C58F7C31D67D8620@TYAPR01MB5055.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(396003)(346002)(39860400002)(366004)(136003)(199004)(189003)(2940100002)(229853002)(305945005)(8676002)(25786009)(81166006)(7736002)(316002)(6246003)(478600001)(66066001)(54906003)(110136005)(33656002)(6436002)(8936002)(81156014)(4326008)(99286004)(966005)(186003)(6306002)(55016002)(9686003)(5660300002)(74316002)(3846002)(71200400001)(66446008)(86362001)(66556008)(52536014)(66946007)(64756008)(6116002)(2906002)(26005)(76116006)(71190400001)(446003)(14454004)(256004)(486006)(7416002)(102836004)(476003)(6506007)(11346002)(7696005)(76176011)(66476007);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB5055;H:TYAPR01MB4544.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hvjDYroEiAPHeoJo/FPsm27ViR9cvfqo6clb8hTZcFigCNzPwTh0Yi7IhuU9E3HlVPhz7YSxSLAnUeL2evD/lwr8OuVmSqBC40KBlt7vI04C+e7NPBhoI1pDHyoIeTdUAQHO8nyugNCbpguWyvtrbOZCPSlcQhwSigtwW4nTcC0He4yrvi1AdZpM4mDtsDX5SHumjZc/P/YscMqBX66ErHGzPHNXV4mgIOjBqO/9W+44NtdyRdzdmQ1dz3cGxSjdk0Kdzod9zgzi/rbYh7nOAxmOPk1eszYdtndskx1/3C0EH7I3Rlng+/+95zc4Lt6YsDR/3mnRbSimlrzquXvFvskRrejM4r871HCVtc3cDpawjuozpsixjBsLNX18aa7bytTWCF9i8yT673PhZRPhN8CdM09BWymUZW/Rc727nnTprLPFACGxtjoWEYsX6mW3S81iJHYmq1xWt7sb/zNfKogz1kOajelPjoeOK/Zf158=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 829dc6da-dfbe-4d8e-bcdd-08d75e96301d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 06:39:03.9706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VgrEbGDo/AVFy6tVVrf95BRuMyY9dizBTqtaPqKVvGHsQb5mxRlEoKL9OZ+sQFWvN2LlU0DjBqawo5n0P7xMb4wE7rQ5EpqKACDA5aStbmG5WVG3csdWMOisCmyuknce
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5055
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello again,

> From: Yoshihiro Shimoda, Sent: Friday, November 1, 2019 2:08 PM
<snip>
> Hello Eugeniu-san,
>=20
> > From: Eugeniu Rosca, Sent: Thursday, October 31, 2019 1:35 AM
> <snip>
> > > diff --git a/drivers/pci/controller/pcie-rcar.c b/drivers/pci/control=
ler/pcie-rcar.c
> > > index 40d8c54..d470ab8 100644
> > > --- a/drivers/pci/controller/pcie-rcar.c
> > > +++ b/drivers/pci/controller/pcie-rcar.c
> > > @@ -91,6 +91,7 @@
> > >  #define  LINK_SPEED_2_5GTS	(1 << 16)
> > >  #define  LINK_SPEED_5_0GTS	(2 << 16)
> > >  #define MACCTLR			0x011058
> > > +#define  MACCTLR_INIT_VAL	0x80ff0000
> >
> > Actually, I do believe there is an inconsistency in the manual,
> > since the following statements pretty much contradict one another:
> >
> > 1. (as quoted by Shimoda-san from "Initial Setting of PCI Express")
> >    > Be sure to write the initial value (=3D H'80FF 0000) to MACCTLR
> >    > before enabling PCIETCTLR.CFINIT.
> > 2. Description of SPCHG bit in "54.2.98 MAC Control Register (MACCTLR)"
> >    > Only writing 1 is valid and writing 0 is invalid.
> >
> > The last "invalid" sounds like "bad things can happen" aka "expect
> > undefined behaviors" when SPCHG is written "0".
>=20
> I asked the hardware team about the "invalid" in the SPCHG bit and then
> this "invalid" means "ignored", not "prohibited". So, even if we write
> the SPCHG to 0, no bad things/undefined behaviors happen.
>=20
> > While leaving the decision on the patch inclusion to the maintainers, I
> > hope, in the long run, Renesas can resolve the documentation conflict
> > with the HW team and the tech writers.
>=20
> So, I don't think the documentation conflict exists about the MACCTLR reg=
ister.
> But, what do you think?

JFYI, I have submitted v2 patch series which was described about the SPCHG:
https://patchwork.kernel.org/project/linux-renesas-soc/list/?series=3D19655=
7

Best regards,
Yoshihiro Shimoda

