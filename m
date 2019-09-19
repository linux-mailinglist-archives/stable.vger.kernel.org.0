Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F192B7993
	for <lists+stable@lfdr.de>; Thu, 19 Sep 2019 14:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387837AbfISMga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 08:36:30 -0400
Received: from mail-me1aus01hn2052.outbound.protection.outlook.com ([52.103.198.52]:12136
        "EHLO AUS01-ME1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387792AbfISMga (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 08:36:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHN3czFfc5i1vGUbAaRglmcBUshDIOhPpHUl2dNrj9smtsjOX7qwgbnpB+l1QF6JeFL7Cn7c904e2XvKFd52dZyvjnwj+9Ytkk+j4SxB7GqJJiR6Brkra2unNmAoyMynRI6ZtUiaaaMqdcuQMh2rR/PrrHKcSVo70dVxblSiOzxBDL9s2NH8CnRnataNTHcnb8LcmVyH5fKuxC4KBKDNTqRMmb6gapJKeweiUeLY/6jrmKQVGTrTBDc4jjOL8uiVUYDOJp/WepfPZ2S7vZyIFx+itUqSBxv5i9Xo1nVuEkhN5Rx1X5vY/AY+LSZ5x/xZYAdOWVsiKjneedtbhUu23Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctOHH2mTYytKOkOB/KQgjBv82LXnbGG7XKgNOOQYhPo=;
 b=CLfdY+HS3qmNrnbnpQNuAZTjdAuBv7TxPsNzPNUL+X3d1Psn64C3yk5C1s+nYMpRRkq++Thrj49GEAuQz4eJAmA/bSSl/+U1qFLGpd0QYs2OfqqcMWwd4FtcaoZFT0MyBxYC5WvtP1xilC8oh8KM5iaymZCTJNF9wfTmYHAjTsLCm0uNV+DuQK3Ps4t59xKSXkDjpZStr0dxCox0qdVQQt4GyiPve41KhtTJVMhWxVaosXF+tl8af5DQ6MEi81foSkwBo2I93W0cVyWf316s/+xgiIT41nYWqlQx/GnAfizQYzvymMwqUSWS2kbGFjCDi7f+oHhAHRvqJGZxwAmrgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=student.uts.edu.au; dmarc=pass action=none
 header.from=student.uts.edu.au; dkim=pass header.d=student.uts.edu.au;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=studentutsedu.onmicrosoft.com; s=selector2-studentutsedu-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ctOHH2mTYytKOkOB/KQgjBv82LXnbGG7XKgNOOQYhPo=;
 b=uXeCRGxYzcuIc16tYwj5l4O0KiXV2MMmrgMQsZHzuCl2q5vdoGkz6jh1YiK6pPYYaXkbnGpqMvarSAkgbV1xTQb1ab1qrAIgLMjxm26nA9NfVKsrMcocAUBNAFY2wrLoYa5DurQPhl7dQedycgThmdNTxkrk0qziWlJIuNa6UX8=
Received: from ME2PR01MB3059.ausprd01.prod.outlook.com (52.134.210.142) by
 ME2PR01MB3044.ausprd01.prod.outlook.com (52.134.210.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.17; Thu, 19 Sep 2019 12:36:25 +0000
Received: from ME2PR01MB3059.ausprd01.prod.outlook.com
 ([fe80::cde5:dbfc:c27a:ee04]) by ME2PR01MB3059.ausprd01.prod.outlook.com
 ([fe80::cde5:dbfc:c27a:ee04%4]) with mapi id 15.20.2263.023; Thu, 19 Sep 2019
 12:36:25 +0000
From:   <13092299@student.uts.edu.au>
To:     Giorgia Rapella <Giorgia.Rapella-1@student.uts.edu.au>
Subject: Darlehensangebot
Thread-Topic: Darlehensangebot
Thread-Index: AQHVbubZY8kalxkl9EiKGu+BfGUGFQ==
Date:   Thu, 19 Sep 2019 12:36:25 +0000
Message-ID: <ME2PR01MB305966B3C8B00A8F4C229932A4890@ME2PR01MB3059.ausprd01.prod.outlook.com>
Reply-To: "chelsealoan4@gmail.com" <chelsealoan4@gmail.com>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LNXP265CA0046.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::34) To ME2PR01MB3059.ausprd01.prod.outlook.com
 (2603:10c6:201:25::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Giorgia.Rapella-1@student.uts.edu.au; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [154.160.2.25]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 215e280d-fb80-4975-8ea9-08d73cfdfc2c
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600167)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:ME2PR01MB3044;
x-ms-traffictypediagnostic: ME2PR01MB3044:
x-microsoft-antispam-prvs: <ME2PR01MB304461A3EDE5F7CC7AE7E47E86890@ME2PR01MB3044.ausprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 016572D96D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(346002)(39860400002)(376002)(189003)(199004)(2906002)(476003)(66806009)(88552002)(71190400001)(14444005)(66574012)(43066004)(99286004)(7116003)(7416002)(7736002)(5003540100004)(52536014)(6862004)(3480700005)(5660300002)(4744005)(66446008)(64756008)(66476007)(66556008)(81156014)(66066001)(81166006)(221733001)(66946007)(8796002)(8676002)(8936002)(71200400001)(2860700004)(256004)(486006)(6116002)(33656002)(3846002)(102836004)(9686003)(26005)(186003)(55016002)(22416003)(7696005)(325944009)(52116002)(14454004)(6636002)(386003)(25786009)(478600001)(305945005)(74316002)(2171002)(316002)(6436002)(6506007)(786003)(81742002);DIR:OUT;SFP:1501;SCL:1;SRVR:ME2PR01MB3044;H:ME2PR01MB3059.ausprd01.prod.outlook.com;FPR:;SPF:None;LANG:de;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: student.uts.edu.au does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7KhXMRDV04cl/UMhfKyWCXZTNa3AhSHizHbxodDaNplrLvhv1uLyeSoDWPaskAc1lS2l9Xo1sC6+uvt6WziMCrwvhTZNcbw/4HG7ck5DL66PK9M1nFBpDUMYC5kyIPLO7XdGmJTx2PtPPsX2j3TO1nuuMh/Hlcik1kdvrfJ/xMfWFNhP7sDtMfLK+2tyUbZdUihXStiLGWWOuPwBASwH90MIZwFqFFOK9Ix++lDEuBQ37RcOi5gNIqdF4gyiI18p9i2fVTkkcZoxfRwDeaCvqARQB2CxVIzHpMLDFwMGM4F9c21RMBg7bqRyrBAPISWJrhKWsUddwGrGAa0RoHjwUvEY2Ep/y2AlPaKxnTE4CCWCrTMbrIve2SDSm5tK71zpcNljHU/IIXjBcZCgX1q5FG3NQ0lI4WrbRf/jY66F/bc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <87E9C7ECE53CE6448BA5E739E04F87BF@ausprd01.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: student.uts.edu.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 215e280d-fb80-4975-8ea9-08d73cfdfc2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2019 12:36:25.2784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e8911c26-cf9f-4a9c-878e-527807be8791
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K6K4Q32kYTsK5xKyEq9GY1YPMAyow0MK+/GfpkWZXrdlypibFV0WEsb7L+pWOsggZtQtw71U1me9MHh+KcXYTXPvmNVOCNYiYxRB+UdeWPQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ME2PR01MB3044
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sch=F6nen Tag

Ben=F6tigen Sie ein echtes Darlehen online, um Ihre Rechnungen zu sichern u=
nd starten Sie ein
neues Gesch=E4ft? Ben=F6tigen Sie einen pers=F6nlichen Kredit? Wir bieten a=
lle Arten von Darlehen
mit 3% zinssatz und auch mit einem erschwinglichen r=FCckzahlungsbedingunge=
n.

F=FCr weitere Informationen antworten Sie mit den unten stehenden Informati=
onen.

Name:
Land:
Zustand:
Ben=F6tigte Menge:
Dauer:
Telefonnummer:
Monatliches Einkommen:

Bitte beachten Sie, dass auf Kontakt-E-Mail:
chelsealoan4@gmail.com
