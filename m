Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35467D1138
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 16:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731397AbfJIO2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 10:28:40 -0400
Received: from mail-eopbgr30099.outbound.protection.outlook.com ([40.107.3.99]:36216
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730546AbfJIO2k (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 10:28:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q/HcL4uKJJmOVfgwNvWA/dk65hWSj09SDKm7B0IKb7N6Gex9QseR6b7u/lDKt/XJTb8UrjC78Ll9bVyTgxIkXbT8IXrAUv+boBda/vdtx4CDIsVQmQoHsNeHuf+71C2kxusrcaMoQ4RoBqmUQ4NJqN+TWN7S9+GG1EMRxr3ll7jqdWnEyt4KG4/fUphmGehbqI2XVTFFNWOH6qmTvrjWfs/RM6Qz7ie08WSNK4FUOIj1xojf769fhPUWfnKjin8yAIJxesmcvXLU7guI/VOPyxg6X4mEVSd4SWthheUowLVll5LT6M9FhbHwJC5wR68oxBDkXLBoffbTX2O+h8uW3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UrD69piIq4Bn04MqSuhVHNBiiZq28QlR6iycYkJ3sqU=;
 b=kTrMmEAURmtiLtrvzrWeejbCQakiWD5/jdBoJPVEHFAqtWWMSB1hO9vQBA9lbp810Zs+n+0PjY7SedjqAgaBRrmqQgjgsfYwhzZtV0D7r5oF5TrrTlzTU1PiRmSi/vnOFW8///rOaLmQhloLqeh2tONqhwjf+KtqZtazYzHJStNKMTMezLIfOWu9qjBhjst9qGQUaOf8e5MRPfeIGpcQCpcc+6NyAFkufUZ3Ln0lBnmNFY7ncUgP0UUUrdzN1a4UJ5epHUwhktTG32/a7uRuZJ2BQ8NqYVI33FMwzE0KcB7FlP2/MFXVRw4/UmOaoiGGz8BzDbs4c8vPBriwxzl2uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UrD69piIq4Bn04MqSuhVHNBiiZq28QlR6iycYkJ3sqU=;
 b=ItyJ0r9PgaTo6icA/o/vL394Pk3F/r//eiyz2S6ksf4MGvbnGNZS0BcadGOGebCKLlm+GHkoovitomv7CA8kVIrr5/sYZibAr92imrjvzFYB3pEE7D6Pa3GLFuYTEFoCUPBtcNuv1HruD0+fcKT1fvXLfRtfjd8MvUm0cUntsLc=
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com (20.179.18.212) by
 AM6PR05MB6582.eurprd05.prod.outlook.com (20.179.7.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 9 Oct 2019 14:28:36 +0000
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c9f9:f21d:d401:7f35]) by AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c9f9:f21d:d401:7f35%5]) with mapi id 15.20.2347.016; Wed, 9 Oct 2019
 14:28:36 +0000
From:   Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Fabio Estevam <festevam@gmail.com>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Jaroslav Kysela <perex@perex.cz>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Sasha Levin <sashal@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH 0/1] [for 4.4/4.9] VAG power control improvement for sgtl5000
 codec
Thread-Topic: [PATCH 0/1] [for 4.4/4.9] VAG power control improvement for
 sgtl5000 codec
Thread-Index: AQHVfq3WATxnFgRN2ki7elTKWYg1Dw==
Date:   Wed, 9 Oct 2019 14:28:36 +0000
Message-ID: <20191009142822.14808-1-oleksandr.suvorov@toradex.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR08CA0062.eurprd08.prod.outlook.com
 (2603:10a6:205:2::33) To AM6PR05MB6535.eurprd05.prod.outlook.com
 (2603:10a6:20b:74::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=oleksandr.suvorov@toradex.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [194.105.145.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45bad5a5-d5cb-4404-7233-08d74cc4f88e
x-ms-traffictypediagnostic: AM6PR05MB6582:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB65821D82B51873E3190DC639F9950@AM6PR05MB6582.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(376002)(396003)(366004)(39850400004)(136003)(199004)(189003)(2501003)(54906003)(316002)(36756003)(3846002)(6116002)(478600001)(256004)(6436002)(66556008)(64756008)(4326008)(66476007)(66446008)(25786009)(66946007)(5640700003)(6486002)(558084003)(66066001)(14454004)(6512007)(8936002)(2906002)(6506007)(1730700003)(386003)(81156014)(305945005)(5660300002)(476003)(2351001)(7736002)(6916009)(71200400001)(26005)(102836004)(8676002)(2616005)(44832011)(71190400001)(186003)(52116002)(86362001)(1076003)(99286004)(81166006)(486006)(50226002);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB6582;H:AM6PR05MB6535.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5htMwHyfWrw4FvBFMhQB0CtN3qvqf9K4zhR8TCq8Nb5tkU7qAI1KaXX8jkQOoDla1HweBvrknkyCIAmIXTUglDVqSoF3os7eTvEJ1LIno4kuzv34AKNBFoQNVchJEzqyHDXMdDT7oEK8fJjr2yCSFWpI1kkmZggg/ffxZxXI711adaSVHRS/Wem3qbgce+2/WBSy5HciC3PkMYb8x7XHqeO3RmygymsPiI8kNQ5SJqAc/Z+PCzei2xVYkzQsROvBDaUPoM8ze6WVf2xdelLH3SuKiEEcFYRCthSOoLZyfB8NAi3iKXsllB5rea4V4Z8odPYtRJoL9OF9BchUjLkyDMYEHxxdKn8YZudhsjOFcIoWv1G6QFjnnHSfH/T1VOyU1KAH0BukHCWC1+jZW3LPki0p+1ZUcwEfFYbZCfrOEk8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45bad5a5-d5cb-4404-7233-08d74cc4f88e
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 14:28:36.7058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hn8eKEXJyyPTZ8SNbqOOWodovpEDKpRA3ZkXO3/5lnXpX0F6z5ogGLacJQCddbsf/JFXaS5qm86a/97ljSnhau65l402xDcop/z2mhuJYaw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6582
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a backport to stable kernel versions 4.4 and 4.9.


Oleksandr Suvorov (1):
  ASoC: sgtl5000: Improve VAG power and mute control

 sound/soc/codecs/sgtl5000.c | 234 +++++++++++++++++++++++++++++++-----
 1 file changed, 203 insertions(+), 31 deletions(-)

--=20
2.20.1

