Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8615810FA21
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 09:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbfLCIsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 03:48:25 -0500
Received: from mail-bgr052100132067.outbound.protection.outlook.com ([52.100.132.67]:25027
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725773AbfLCIsY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 03:48:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1w5atDEx5mSKqrKUwe8JwM+iRaZ5dZnUQFszqq25Ju44uU0e5BmgbrVPrDPRsgxaIW+qnHj3ksw9IpwJZd/iOw+4oN0cJzr8ZOZF9Ss0+0MkBUMcEW1QyrSXCiECtuoweVVxgX+h6IvnCMcR1f/o08IKqsPMAW6iFKt6ESNFqBbFqKIHuEfGabrKXEYZ0nHmCoaZIlJtz/dl9Kdozppkzh2DSJNXVAMiK5RRXg/jN9oawkz9joKTcDkQcoeBVpVvfFLASn6eMGuL6qfl3sGHxcmE9SmPfjd3If6YuPc6PEXVzIkeDsSn7uxpsCPc8qOq/nA2bih2UsMgvhvjrtY8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62syisZc9qtveK+sLxpnmFs1kxIGIrUlvHy8s6657Vs=;
 b=Mp3aKm3vH6Pvbd4envUwIlDB1HXb5SUZjxnDJFSmhwV4+1BAmsKcDKtH3X+x8xGOttQHrZd3dNsWf2nzu8M4aZlwqgjKevzkCeKjtESET+xYqtJMcGjqWJlNhniKawcNC+SMUZcmAL9EOnZpM99LDjJ0c3cN0t/MVrCglEo74jylKD63tzfYbdyNNWEjVnGzMBUl0AHzwHa3LkxbknmALcz6dME/Pyc6Px77H2rIOLILAJu149a5w+W8ErN5SLg83grkl0axmUk+QVUEuCE/wBAq2jmOuSMY83bCzLFh69Fy3xjWjBNC0vCowu97YFad3J3Ah0Fxzby9UOaHqB4NdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wayne.edu; dmarc=pass action=none header.from=wayne.edu;
 dkim=pass header.d=wayne.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wayne.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62syisZc9qtveK+sLxpnmFs1kxIGIrUlvHy8s6657Vs=;
 b=dClFEuqdyY20XhyFtaEohMrGugSKRbnUgmEnIMVuwdN9UmLBBbuTcBEHuV09iri4swHzDWq/J6ER9+O6sZEmBVuA0ydnhtF+Ca6EiPjHMehutkmgwXq1ZL2ynx2FR0pF5rJV+ugef/b2ayQM3khAtLuWonCAD018aZZwX4h/8JM=
Received: from DM6PR11MB3739.namprd11.prod.outlook.com (20.178.230.202) by
 DM6PR11MB3386.namprd11.prod.outlook.com (20.176.121.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.17; Tue, 3 Dec 2019 08:48:20 +0000
Received: from DM6PR11MB3739.namprd11.prod.outlook.com
 ([fe80::f4d2:da09:6569:60d9]) by DM6PR11MB3739.namprd11.prod.outlook.com
 ([fe80::f4d2:da09:6569:60d9%5]) with mapi id 15.20.2495.014; Tue, 3 Dec 2019
 08:48:20 +0000
From:   "Mrs. Jane Cheng" <af5532@wayne.edu>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Product List
Thread-Topic: Product List
Thread-Index: AQHVqbZaOKn1U3vmb0aa3h5lbbeBdg==
Date:   Tue, 3 Dec 2019 08:47:54 +0000
Message-ID: <DM6PR11MB3739BD9AA489585E1F0705B0C2420@DM6PR11MB3739.namprd11.prod.outlook.com>
Reply-To: "janecheng1495@outlook.com" <janecheng1495@outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0215.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::35) To DM6PR11MB3739.namprd11.prod.outlook.com
 (2603:10b6:5:13b::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lavinia@wayne.edu; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [105.112.121.107]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed92f82d-3d60-49df-0615-08d777cd7d15
x-ms-traffictypediagnostic: DM6PR11MB3386:
x-microsoft-antispam-prvs: <DM6PR11MB3386F6B8E657DFEEE704B157B0420@DM6PR11MB3386.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 02408926C4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(376002)(39860400002)(396003)(366004)(199004)(189003)(33656002)(6506007)(186003)(43066004)(7696005)(6916009)(9686003)(55016002)(71190400001)(81156014)(62860400002)(75432002)(3846002)(2860700004)(2906002)(14454004)(88552002)(6116002)(221733001)(2501003)(256004)(8936002)(8676002)(1730700003)(81166006)(6666004)(7116003)(8796002)(3480700005)(386003)(55236004)(102836004)(5640700003)(52116002)(26005)(305945005)(7736002)(6436002)(71200400001)(478600001)(74316002)(2351001)(99286004)(52536014)(5003540100004)(5660300002)(66806009)(316002)(786003)(64756008)(66476007)(66946007)(66556008)(25786009)(66446008)(558084003)(560234002)(19580200005);DIR:OUT;SFP:1501;SCL:1;SRVR:DM6PR11MB3386;H:DM6PR11MB3739.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wayne.edu does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kjC5mXwnQQWGPIvAyRe3xCaM1wlNID8pg6Wl9g4DLoj0G7IMZOVOYSQAYSvjCfbwOtSZbNRbjSmFQt92XS1z2OjUXuVAtYH5Shw10d6LBEVdKfI5Nh+d/M2sQpoQzWynFzSNn2yXcljOEZu4OuNqt+xym0yG75kGkWwZ3CeiSKwlpGuLjZb9VQPOR9rHSqKY1Qzgm/BaVjKld8Ep7FFYqqPwqjdVEJf0DYWULWlzRWmrscCPas4H+qJMvn1x1S9YOblG4FLGsmL4Iq0o6em771aD+0Xx0IRuJZMaKfy55MDlIWJFtWfXw5Ih+RTN6lP4sJS7ttmAU50ZefewjwklGUJyQqAPW2BYvWPMga9f5NYtFoxKH8+fuoVpGFHwPk1SwTIakUagyzwzo0bpSwhDCdA0KCf2IP3ivhKJJ0543ihL1+uXpu2++u1SLhQEUUV7
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <FCE03998264FC049A9C042642B46D2B1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wayne.edu
X-MS-Exchange-CrossTenant-Network-Message-Id: ed92f82d-3d60-49df-0615-08d777cd7d15
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2019 08:47:54.8004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e51cdec9-811d-471d-bbe6-dd3d8d54c28b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lxNfh8Ehgp7LYxpY+YdQO2BdNzaCXHppzFsUj5KMmh9C0131Kq4RWjwqLb2R8H23DTYNJSnQokvDM4L+vAKjig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3386
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Sir/Madam,
=20
Writing to let you know we are interested in your products.
=20
Please send your catalog so we can make a quick purchase.
=20
Best regards,
Mrs. Jane Cheng | Sales manager
SAH INDUSTRY&TRADE CO.,LTD
