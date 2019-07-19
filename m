Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2756E3DD
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 12:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfGSKFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 06:05:33 -0400
Received: from mail-eopbgr40092.outbound.protection.outlook.com ([40.107.4.92]:10046
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725853AbfGSKFd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 06:05:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kmo6Bs4nauUzb4E90GgGWRuOIsROb6H3ApkmjB1PSukmBkenpDPkin+yNnKN1KDCBWzuNgzabBaVBKk71J7heoV19z/iiWrcONc8B4NMI8Zcno2fMUFi4Ce5dgKF//dP0pj0m9svzELNmd9XIC+URahDU/BtD3KKS79+6LJxq6BYLdWZDAIRz1CxhpOKRKGhBTHXOpctQuEIN5RaQpkXNVy1piVpHkp8tamTW6J1a755mfBBzbpvLrl3+7HvPIjvVBzfhZufY3hA19lA/+pmH8WRYf2AqPNt+ypGBHSq7mzq/20PFUN6FolYSW9oAxogk6akYD1c8/27yQJGAkZBnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPsVnqHFZK81v/Bc/tDRed1tDVUc/numTknDmN7z5yo=;
 b=HAb4rZkZ7TH4VLh/1zwYqF1FMLrNNmx/J1bwn6lWzUwNpd0rHJiJSKisJNOdHW/2pu8S3eH1ubolVDVw8GpZpUGFRY/qy3M+NYd6aIjelfl/lkSVFl5zk9s2y05W3Tu9NHtCgBY2J9Ubi7SBCStpTN/wy54QCuckD1Wp3D/undFBDmH1lThKdqR+NX3/lwV4L4C2Dm1n55noBNejwzv1DNcZCIDmSgUoLePvz4m8+t0GTe6CWV4S/cr/7JIII+m8fklZUACMwZL1Hqu4w2ZnAdwXSk6RqT565TdO96u6xpraL67OIE/vB/VXzVrFnQSSwktrwAqXRMImmQIx5VCMbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=toradex.com;dmarc=pass action=none
 header.from=toradex.com;dkim=pass header.d=toradex.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPsVnqHFZK81v/Bc/tDRed1tDVUc/numTknDmN7z5yo=;
 b=WeLQWT7hSGUHP/RHtqpPRQxYrQyrmDogAJ/DImlvqvIQgfhZKeG7WSTPe7wU6LuWLNYyiHHqweJ4YdmUjsKAv7SwER5BvhHpgTP9M6vOzAu0DuCoOuuRloIWcw+4xwX5QLHvPQZZgG9jk7x9g3kXQi+HFpGrSQHQ4dR8a3sA6rs=
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com (20.179.18.16) by
 AM6PR05MB5925.eurprd05.prod.outlook.com (20.179.0.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.14; Fri, 19 Jul 2019 10:05:29 +0000
Received: from AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c860:b386:22a:8ec9]) by AM6PR05MB6535.eurprd05.prod.outlook.com
 ([fe80::c860:b386:22a:8ec9%6]) with mapi id 15.20.2094.011; Fri, 19 Jul 2019
 10:05:28 +0000
From:   Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
To:     Fabio Estevam <festevam@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Igor Opaniuk <igor.opaniuk@toradex.com>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Sasha Levin <sashal@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Takashi Iwai <tiwai@suse.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Subject: [PATCH v6 0/6] VAG power control improvement for sgtl5000 codec
Thread-Topic: [PATCH v6 0/6] VAG power control improvement for sgtl5000 codec
Thread-Index: AQHVPhl+Nefui3iIiE+qTy/GdB4/Ug==
Date:   Fri, 19 Jul 2019 10:05:28 +0000
Message-ID: <20190719100524.23300-1-oleksandr.suvorov@toradex.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM3PR05CA0099.eurprd05.prod.outlook.com
 (2603:10a6:207:1::25) To AM6PR05MB6535.eurprd05.prod.outlook.com
 (2603:10a6:20b:71::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=oleksandr.suvorov@toradex.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.20.1
x-originating-ip: [194.105.145.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d524434a-fc1c-4a11-7f96-08d70c30a079
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:AM6PR05MB5925;
x-ms-traffictypediagnostic: AM6PR05MB5925:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <AM6PR05MB592584E53187682DBA7EC834F9CB0@AM6PR05MB5925.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:241;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39840400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(14454004)(68736007)(8676002)(50226002)(6486002)(8936002)(54906003)(305945005)(7736002)(71190400001)(71200400001)(6436002)(7416002)(81156014)(186003)(99286004)(66476007)(66446008)(66556008)(64756008)(1411001)(81166006)(2906002)(6306002)(476003)(36756003)(66946007)(14444005)(256004)(6512007)(86362001)(6916009)(26005)(966005)(478600001)(66066001)(52116002)(53936002)(486006)(2616005)(25786009)(1076003)(6506007)(4326008)(44832011)(3846002)(6116002)(316002)(5660300002)(102836004)(386003);DIR:OUT;SFP:1102;SCL:1;SRVR:AM6PR05MB5925;H:AM6PR05MB6535.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: toradex.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xfbN3YJzGyEw/1/LFvzyuQ+AWKa0G6Vf4zdA3g0bBkYoUPN4Ig7tAOmENPxQxb43Qx7xQjpccdfK53EhFwFGnsO81xCyl1rT0t24RCetXuZCvNz3+YhOZ7gwWBxgLG9tUldD/9GHLYqY8ZTUcNAWNprrqNjnOrC7CVipAdtZR9lrW4NmJjkTbyMaejEf1kluCPCvPCyNoXVN/Jj0IvRB69Wdg/X55KFjUBcxN7hIvl3419sqwkOQphgAUf9rBxWuJ8VfEhXJriGH8WXu+5eHncWbLBfnkVBGKIyPnclpVEjrJN7he0frMx1Pn4nZzDqoOAAW1YF+OPFpR4T+T4as+GEkIx0SeeXA5Z5N/JBjFZEG0apQJG4QaSdQvytrAVCp6evFSAuuY+TZc34dXrypZAGDIKzbmxR7qUyNJU5jQtU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d524434a-fc1c-4a11-7f96-08d70c30a079
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 10:05:28.8034
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oleksandr.suvorov@toradex.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5925
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


VAG power control is improved to fit the manual [1]. This patchset fixes as
minimum one bug: if customer muxes Headphone to Line-In right after boot,
the VAG power remains off that leads to poor sound quality from line-in.

I.e. after boot:
- Connect sound source to Line-In jack;
- Connect headphone to HP jack;
- Run following commands:
$ amixer set 'Headphone' 80%
$ amixer set 'Headphone Mux' LINE_IN

Also this series includes fixes of non-important bugs in sgtl5000 codec
driver.

[1] https://www.nxp.com/docs/en/data-sheet/SGTL5000.pdf

Changes in v6:
- Code optimization

Changes in v5:
- Add explicit stable tag
- Improve commit message

Changes in v4:
- CC the patch to kernel-stable
- Code optimization, simplify function signature
  (thanks to Cezary Rojewski <cezary.rojewski@intel.com> for an idea)
- Add a Fixes tag

Changes in v3:
- Add the reference to NXP SGTL5000 data sheet to commit message
- Fix multi-line comment format

Changes in v2:
- Fix patch formatting

Oleksandr Suvorov (6):
  ASoC: Define a set of DAPM pre/post-up events
  ASoC: sgtl5000: Improve VAG power and mute control
  ASoC: sgtl5000: Fix definition of VAG Ramp Control
  ASoC: sgtl5000: add ADC mute control
  ASoC: sgtl5000: Fix of unmute outputs on probe
  ASoC: sgtl5000: Fix charge pump source assignment

 include/sound/soc-dapm.h    |   2 +
 sound/soc/codecs/sgtl5000.c | 250 ++++++++++++++++++++++++++++++------
 sound/soc/codecs/sgtl5000.h |   2 +-
 3 files changed, 213 insertions(+), 41 deletions(-)

--=20
2.20.1

