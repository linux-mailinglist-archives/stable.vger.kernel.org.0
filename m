Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1434A87CCA
	for <lists+stable@lfdr.de>; Fri,  9 Aug 2019 16:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfHIOfY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Aug 2019 10:35:24 -0400
Received: from mail-me1aus01hn2044.outbound.protection.outlook.com ([52.103.198.44]:48114
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726157AbfHIOfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Aug 2019 10:35:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UL3xj82WWJszN1nKHeNYUgqIMsVN/KznGaXr2ifmGzN2+IUkSrJ8BuvWiKy4cL5lFIvqGSMeYQZd7lETLKt/NTFbW/mZLMNAAGwLM8bspZuWo65rp0I+eJbnLxOtkDyJylbApnKng6nUnj61Y5mcT+ySVThO5vRRrUbKHm3CR4p/J4JVyNJiVMdp83NWxipto0Ih1/OnbLoS4FXRBBMkt0t53diHLM2xE1tHUBO7/kreD/5MdFbxu46dLDc9AEJINC8QgNGRe9fdCdXve31rS1U5WvrwuA/pAi6AW2Z9cV5AJOFYET9KImeKD110Ag4MEZQvr0BQmmACoan14cvGMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/VFidb23qiM+TupwPfDpCFe6+g/KHhHfeSfUJDYG/Ls=;
 b=AWuMp1Ahzzy2BAwBAeriBvzFGp6AYNiftpavsx4g1Xty99y198W0hMGrr4wArJ4IXw+4butFS5K+lUsFVWaMy2GMo/E5FHtjIoVJ+QatEnHB1it8aq+TXFBBYI32Yk/BAb6QJrmfWPh8Ws8kmAanOySRJ2S7aJOilNz+EzcwQ0HwZJPEUrexzLhZ6gklbDVDZu1TCF0Gfr7sQ/rkEZ9fv7b4M61awnPYfTyUTWgJrdH1na2sqsFGprcYv8UOrZPII6fI/X/CTFStbUGPfHUfwaDYtbgV9K2CmflO+2PfNi3Mgu4VBb/ryO9EBuYki0A/PDYQzSW1VtDCt2ekEO8AJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=student.uts.edu.au; dmarc=pass action=none
 header.from=student.uts.edu.au; dkim=pass header.d=student.uts.edu.au;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=studentutsedu.onmicrosoft.com; s=selector2-studentutsedu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/VFidb23qiM+TupwPfDpCFe6+g/KHhHfeSfUJDYG/Ls=;
 b=jlywtflpyQdPp15f/CBK+VCCrTb9TSyH0u7kYnuMES2ZZhVRHAQOSHplw6VxT4RE+3CZmVwgnSMDIQyyfpouTzvW05dXcDfDZPUZ2k7i7On1epRyaBkSStbojyMkVjohHwfdpkhy+QL4B6Xfg3LBlM3BEbLXxPv2f4TBZuDPjQk=
Received: from SYBPR01MB4281.ausprd01.prod.outlook.com (20.178.189.78) by
 SYBPR01MB4220.ausprd01.prod.outlook.com (20.178.189.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Fri, 9 Aug 2019 14:35:20 +0000
Received: from SYBPR01MB4281.ausprd01.prod.outlook.com
 ([fe80::4059:307a:7cfa:e571]) by SYBPR01MB4281.ausprd01.prod.outlook.com
 ([fe80::4059:307a:7cfa:e571%4]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 14:35:20 +0000
From:   Mrs Elizabeth <13586146@student.uts.edu.au>
To:     Chloe Young <Chloe.M.Young@student.uts.edu.au>
Subject: Spende
Thread-Topic: Spende
Thread-Index: AQHVTr+nlJJM0/vRqUyPXC7Pq5KoyA==
Date:   Fri, 9 Aug 2019 14:35:13 +0000
Message-ID: <SYBPR01MB42816010C7EDF8C975CEA98BA5D60@SYBPR01MB4281.ausprd01.prod.outlook.com>
Reply-To: "maunoveutileina@gmail.com" <maunoveutileina@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0136.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::28) To SYBPR01MB4281.ausprd01.prod.outlook.com
 (2603:10c6:10:55::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chloe.M.Young@student.uts.edu.au; 
x-ms-exchange-messagesentrepresentingtype: 1
x-antivirus: Avast (VPS 190809-0, 08/08/2019), Outbound message
x-antivirus-status: Clean
x-originating-ip: [185.248.13.41]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da2409e4-f814-4cbc-a184-08d71cd6c954
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:SYBPR01MB4220;
x-ms-traffictypediagnostic: SYBPR01MB4220:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <SYBPR01MB42208C9F9A0F2DB3A5561907C5D60@SYBPR01MB4220.ausprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(366004)(346002)(396003)(376002)(136003)(39860400002)(189003)(199004)(966005)(14454004)(2860700004)(99286004)(43066004)(14444005)(256004)(66446008)(22416003)(66476007)(786003)(316002)(64756008)(66556008)(478600001)(6436002)(2906002)(81166006)(7116003)(81156014)(7336002)(25786009)(6306002)(7736002)(55016002)(7276002)(9686003)(88552002)(3480700005)(8676002)(7366002)(7406005)(7416002)(6636002)(71190400001)(71200400001)(8936002)(8796002)(74316002)(66574012)(305945005)(6666004)(3846002)(4744005)(221733001)(53936002)(33656002)(6116002)(2171002)(486006)(561924002)(6862004)(186003)(52116002)(7696005)(66946007)(386003)(6506007)(26005)(102836004)(66066001)(5660300002)(66806009)(476003)(52536014)(5003540100004)(81742002);DIR:OUT;SFP:1501;SCL:1;SRVR:SYBPR01MB4220;H:SYBPR01MB4281.ausprd01.prod.outlook.com;FPR:;SPF:None;LANG:de;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: student.uts.edu.au does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XoI2tKRvbd6DiYAYWlQvFlav6cphxKotRp00JDJZjyeRLVHsA4cxtTxgh3uIkqUKra8ABEy4brkOj0HsNuOpUIJyohP+cXBya1Tnh3KB5w4k0O5dL8pGirYOkg8clzP7RG5Odb9PNBwCnOoaGCgUzabiyPswRBqknaxLcL/uSUHY7LvgtVU0YnzI7VvOhpPfvI6s21c2hOGGjRpW1eCDpGjhT//PhAc9PRzYrodwBgXOjoG4Pu8qgIVMfSWjgdwFmOJ/tRgXa6XcfqIfxD1C31qXOlQvj/kCBd7VsIVs7UsyjC2BFGaBIAy8jb5lEdc2+8qrUHpDHSAri37unNZKlyTIVKQNQOI4LCstvjOph7onhy/f9uwe8ARjbksM1bYAUvcn3CpWf5QQqeFB1sas/ykEi9AOJ4FvhRvJ5qeURI0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <400CD5F12FDC394DA82B38BFECE32FE3@ausprd01.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: student.uts.edu.au
X-MS-Exchange-CrossTenant-Network-Message-Id: da2409e4-f814-4cbc-a184-08d71cd6c954
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 14:35:13.1905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e8911c26-cf9f-4a9c-878e-527807be8791
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +rICPaFMQtyu/SjDjDF4jzOn9RMzBtKYfGo7OOLyOyGTJiOATsSm6N8NifIxR/ykMVWTEZFQHVKSlrpj5pX82nV/DsjAk5VayRGOe92JMe4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SYBPR01MB4220
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Mein lieber Freund

Ich bin Frau Elizabeth Kerli James aus Deutschland. Ich lebe mein ganzes Le=
ben in
Die Vereinigten Staaten.
Ungef=E4hr zwei Jahre lang wurde bei mir Krebs diagnostiziert und jetzt l=
=FCge ich die
krankes Bett, ich m=F6chte, dass du mir hilfst, meinen letzten Wunsch auf E=
rden zu erf=FCllen, der
wird f=FCr Sie sehr profitabel sein. Ich w=FCrde diese gerne spenden
6.470.000,00 EUR an Sie, ich m=F6chte, dass Sie teilen
es zu einer Wohlt=E4tigkeitsorganisation nach Hause.
F=FCr Ihre G=FCte in dieser Arbeit, die Sie durchf=FChren sollten, biete ic=
h Ihnen
40% wile der andere
60% des Fonds gehen an Wohlt=E4tigkeitsorganisationen Ihrer Wahl
Bitte kontaktieren Sie meinen Anwalt =FCber diese E-Mail f=FCr weitere Info=
rmationen.
maunoveutileina@gmail.com
respektvoll

---
This email has been checked for viruses by Avast antivirus software.
https://www.avast.com/antivirus

