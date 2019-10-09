Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33A62D1163
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 16:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730708AbfJIOiq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 10:38:46 -0400
Received: from mail-eopbgr60120.outbound.protection.outlook.com ([40.107.6.120]:11655
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728019AbfJIOiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 10:38:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ar79rxNhu3Lhy8l/8V9efWRu+HT05DHM/FKG5oDKMrSCNG3wlmunewGM2teWZUUHrDjne4pEEJ3FPn+IGjaToaUDrR3sIX00aiOV5xbIM5jMxp4kCzLZvjh/o5dKcVAkkjKVQtNQ+tNCuGdehqCo+Got3IKyI/Rdc0hVi6OnVM0LamR6ELP820OitcPMOh0AYmWvrzX1yH5n/nbuHzk+lCFA5S3uev8AhzQH6M0UWUgI4KbBHP6PqKp+W2mJOdV5hBjE7cEfdis3OIjVTMAMIoil3yC3Cg1p5W7b4kw8j4LId8XsYWrL5TH9/Yjdsr0CgxstrGRVuAl/10P/KkOSig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UutOp5mdKOhITYpJnZrTOI3olImI772sxBGFnnXkPF0=;
 b=W1jKORypR54FjIvN+0+KRBjjyveVFnQin2d3TRMg6nN30vLEGbgdaFsI33Y7J+BmbzzLMyjC/sF99CJanTDTZpxTmOJPfES8nqC6KyUJ5WEyFbtMHqINvf8KpeadngLg6kpALoUFKjQCj0osj2xZlPTIMcKZjAcyMFw2D32JQ2i7gjvF+4w2OeMm3JDg4NQX+Lx3hR8bwIB8rZWoCaZpSr9ccppC602I+rriJ7CTHpMro2Yu8nOiQYMt5uP5iohj1BoNwrUDDXdWqXHhn6C4OGpyuE0/1cdhLJDnf13y28Zc2nY0z7X6+Y+y7RDw7z99AM74VQBHovzpN6TtJ5IHEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UutOp5mdKOhITYpJnZrTOI3olImI772sxBGFnnXkPF0=;
 b=YaGf3iSqD/QHmFWbkKyKVUOoG9xzEPEVfiVLscm4V+RkSuNhO0HraX17SHsPoTY6XH0lR5M3/YXBLVyGkDlNaDhpJCf9sf/oTeBKuJiugwC7aRBkYT+s3RA3ThDPtsW32W8y36lQ5PK/sZ/nrofTN10/mrja/sq206TAHmn4IyY=
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com (20.179.18.212) by
 AM6PR05MB6038.eurprd05.prod.outlook.com (20.179.3.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 9 Oct 2019 14:38:40 +0000
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c9f9:f21d:d401:7f35]) by AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c9f9:f21d:d401:7f35%5]) with mapi id 15.20.2347.016; Wed, 9 Oct 2019
 14:38:40 +0000
From:   Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Fabio Estevam <festevam@gmail.com>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Jaroslav Kysela <perex@perex.cz>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH 0/1] [for 4.14] VAG power control improvement for sgtl5000
 codec
Thread-Topic: [PATCH 0/1] [for 4.14] VAG power control improvement for
 sgtl5000 codec
Thread-Index: AQHVfq8+DC2aQlM+cUC20NYe/JfBGA==
Date:   Wed, 9 Oct 2019 14:38:40 +0000
Message-ID: <20191009143836.16009-1-oleksandr.suvorov@toradex.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR0501CA0048.eurprd05.prod.outlook.com
 (2603:10a6:200:68::16) To AM6PR05MB6535.eurprd05.prod.outlook.com
 (2603:10a6:20b:74::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=oleksandr.suvorov@toradex.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [194.105.145.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 70305c85-e6c3-4468-37a7-08d74cc660a7
x-ms-traffictypediagnostic: AM6PR05MB6038:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB603877F7252B1638D3E6AA69F9950@AM6PR05MB6038.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-forefront-prvs: 018577E36E
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(366004)(396003)(376002)(39850400004)(199004)(189003)(71200400001)(14454004)(54906003)(558084003)(6512007)(25786009)(1076003)(5640700003)(256004)(2906002)(6486002)(66066001)(71190400001)(5660300002)(6436002)(478600001)(66946007)(66476007)(64756008)(66446008)(6116002)(186003)(316002)(50226002)(26005)(66556008)(8936002)(81166006)(7736002)(3846002)(44832011)(36756003)(4326008)(305945005)(486006)(2616005)(476003)(2351001)(2501003)(8676002)(86362001)(52116002)(6506007)(102836004)(99286004)(81156014)(1730700003)(6916009)(386003);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB6038;H:AM6PR05MB6535.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GQM0p+q+buV1o+AzDyaScT/vVv0E/iZ1vJH3OU+ALjJFSllO6EvYjhg10a0HLOfiipgiciyWDpWjhIQaub0mv/m8GcsxIAN8avLmdd+9pgArrnyhsJG+gyCZdOTnVjR/vsjq0qgsV2yVxBpjYFdCtJ5ywkkC9j3If9XI9OZN0+Qu+/z+logXGoPWVUOtGr5YICNuPWzu2ISjJ+COI7FAMvuHzyu3vK37D8Li6tsPyfvCvDEWeUCAQSrB4L1yfCzMG/tt7hy8FNIb6Ajl0s4fab9H4JkWJJQfZU4HCCmxvcd+JIsNb3u1SC2oAlsOTmEthUBZhUtVuDf8XrUu/r2ITs1NER9JEh+r9W1bE6gcYglkf2HpR7wjLMR/J9eDwdw/QzQDmsc032smPXQGCRr3xv34dGgg80QVjicAf/eZ4hY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70305c85-e6c3-4468-37a7-08d74cc660a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2019 14:38:40.6380
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Iz4Q3jOTkDgjTvNzwinkoRH/Yu400XBJxFAtlr0ie/yxXV+K8aRno7uspLqSw7cokaPP8Tztq1mT6CbVbGLpmhcYVK8WYXSp6A0LT2mE7SU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6038
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This backport is for 4.14-stable.


Oleksandr Suvorov (1):
  ASoC: sgtl5000: Improve VAG power and mute control

 sound/soc/codecs/sgtl5000.c | 234 +++++++++++++++++++++++++++++++-----
 1 file changed, 203 insertions(+), 31 deletions(-)

--=20
2.20.1

