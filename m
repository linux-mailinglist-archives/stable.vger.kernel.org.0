Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5105EB034
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 20:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiIZSjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 14:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbiIZSjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 14:39:23 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DF37EFD6;
        Mon, 26 Sep 2022 11:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664217517; x=1695753517;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=cY5LvUNpRynAYUx14rfYrhSbrkkEmFwyD1Nui6hax3w=;
  b=datHraDvtr4a22ToMF/NFn6Pm/YXsFLFBbL3HMgc/NDS6RlqZkm7xy5Y
   2SccwjS00kmag2u9SlL8iemyoyDffVihhl1AyXO1O/LKrlPCDf5bhfKbL
   O0S6PwQzy9nwM8fazV1Nqccs4zHcHbKnp/oteFgEa5k1o5sco13XyHKOW
   g5lnSYXeLn+kqDz+G0HVh+zFA8oOIu1mIjKxU2o1Q4BgCYghuBDclHDUu
   PgMV4XIv2E+n1FDVIBvVQOYwEIvoO5Ok0trt+A1ZUaInRT8ZaejMmHbfL
   nLP6UChU4aOtoWjTl5TeWB3OcFKxXQgRk5hkv94IK9kTaM13L+/7sCLTD
   g==;
X-IronPort-AV: E=Sophos;i="5.93,346,1654531200"; 
   d="scan'208";a="210678084"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2022 02:38:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RSCiyY5FcUXvRI2XKlT5pGk20SEqLQ3zUwz6ZjjFyoqbX0t869ryHnNssjNdBE3GtizTqOyISQW7M4+0OJzRT9a2LUe7pgEfrkZH8+453qe6C5Q6V5qEl99tOcsT5vqtJKi91crNE7ASZD8D3D8gas+z4L70EkUW6FejGy4Dyb0E4LynIocmCvnEYrbJF2Wc0IGRb8U66R3vuMrFgrFn3zUb4NH6uj5oqslm1m5/mFNfn3NYH2YzE9nm5w+c+xHLK42NQKIcnb79h2MgqossxL4+1WJxRNu3lZVGkHcq5fgOcEUu7BZtEtmzIkOhE4MJRmYR8BYg1OgCZCTtcQtKJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7rmoNPGBTOxBtmUysfA8WP1nUAfxX+SabgOECazJm1o=;
 b=C0DhaiQEjsAkH5pfRwZ9ZR0KUTpRdAP1xwZM9XJ5vQh4myzXpvNqCXD0jxZxoh+vScLbpKDH9fXSzV5huWMqcj2Z1vkUPw32dm5+4GCju6nQMfb5RPqQ81VjYXmKet0hMBU8V5q0KRKWKoPoDMlXlTxrvRY3yTAeVlqO9jm+F9zw55Hpk3VjgXWqdgdbf6qH3sNvZG+qGiFGbV/awybLRJRRAljgulTezVEyuaiB8YUnSn13prqVynjR9fieXN4o1iamAO6YN1Q4Y+rGAAFbY8XV6Xp7dJcghJcBIWY/uNdcU6+VeCkW7dR8qrwYJKK462LnxDah9Fw9LgbbYceGlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7rmoNPGBTOxBtmUysfA8WP1nUAfxX+SabgOECazJm1o=;
 b=nVbqhh3jWdVMQUKhuZHKdT72dPLIkhKo8Sr0pSDkZHa2W6sHHQnsQ+TPYRqfbg2sj7X4AUCFJ0rRgFuVEaNnRlZ50GKeTJB0MJF4pbK9UWscVqK0EpR275bgDNx5QSFALZb5g+QVOhK0haNXcVk7inzFgh8pK2na+qmyrvRkS1Y=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CO2PR04MB2248.namprd04.prod.outlook.com (2603:10b6:102:d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 18:38:09 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::c8bd:645f:364:f7aa]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::c8bd:645f:364:f7aa%5]) with mapi id 15.20.5654.025; Mon, 26 Sep 2022
 18:38:09 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mario Limonciello <mario.limonciello@amd.com>
CC:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jaap Berkhout <j.j.berkhout@staalenberk.nl>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: [PATCH] libata: add ATA_HORKAGE_NOLPM for Pioneer BDR-207M and
 BDR-205
Thread-Topic: [PATCH] libata: add ATA_HORKAGE_NOLPM for Pioneer BDR-207M and
 BDR-205
Thread-Index: AQHY0dcgm/L2xMbUg0yw4FSft6eyKw==
Date:   Mon, 26 Sep 2022 18:38:09 +0000
Message-ID: <20220926183718.480950-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.37.3
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CO2PR04MB2248:EE_
x-ms-office365-filtering-correlation-id: df0bc64f-5b06-429d-44b0-08da9fee42bf
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7WYGAIyZ0CLAkFQzUznr7FCWqngKQoqtDxkvsV4BNRHyz9Qjs8jhz4DAwqu20A5uMjSLiavV+yvKH6KLZJeg6oj0GXdhwR5Qzx3bTAqkg15xWEN+n9RDj6+vsufJQMGrS9tadnNBYC6LRM4Z+2kLJNkfhcVnQERNK+Dl4A74Eb0I1qoFfx9c+xEOQ1RdABnlLoi2ql5+9OGpU9+p76yaA4FkKYv5Q9ouFxXKS3We1wnVcDWtOyfxJJXF0g0W6e2C6VRdfutQSzMVagxWtIoULAcEfwfPGwnBT+TwflYR7kKzkmc2BimHa9Hrz7TWAIpq4TGnqmAGfsNlyBQphkXFi8V+Od10NxrUCAWR6KJLIFyhcIeyFf1DjZESf0mvvwcMNKNmKF5ConXbyFNEMCbK+D8HZWVpe65xMQpSTdPvpmbb/j/8QEK/9Mnz/tlDyOj4/5gw6cNPPYVsJBy+QmucYhvMCPDglmiagJXevd8sQMIkiUPT1nxnvzvzKEGfx3XLeqcnwT+pWsMYfmGNhW4S5TVL+5fryfCt06vr3xy9Lfv+yD1/SX7AD/td/oGpZ3s036nuxbZMLPkgZ2qEPMxJYdiQMJkinqfTGvgd5yBpXJQ7EGSHJaLdhMp6H/SX44wyhcDoJhOhZ77YHyi7btfuSsq2oTSHwRxKerAfDYK4oOayDop5sdviEaWtl3JfbcSo1I7IlukY7lSysbl49+1LjlqNHvXAahSWKR0fMyv1Y2CO93p171SNofhPwtxe8u1x41DOThhvPgHmBPfNyMB+kg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(136003)(39860400002)(396003)(451199015)(6506007)(6512007)(2906002)(71200400001)(26005)(82960400001)(38100700002)(122000001)(36756003)(1076003)(2616005)(186003)(38070700005)(83380400001)(66946007)(76116006)(64756008)(66476007)(66556008)(66446008)(4326008)(8676002)(5660300002)(478600001)(8936002)(41300700001)(316002)(6486002)(54906003)(110136005)(91956017)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?kBdzZKEbinMDOImYbXCQM0hsb+sRU5u3ROj0tBARrIUoYVZBsM7PjX9DUw?=
 =?iso-8859-1?Q?TwqVeOwg5AkZJECkuSJFWb+n6WvWX4PIOGioaTk4A4IrVnxtALBqSW+9KW?=
 =?iso-8859-1?Q?x6Va1XbkZaVR+g0CGMkTvtn9rcRz6KZ/KF8CVgURFMv8quvFQ8AywXlD6g?=
 =?iso-8859-1?Q?bvqpxWseqgC/oAQPB35UdOk6XaeFUEDv8bfvBWWZ3mD3N8JrCNscBMohaH?=
 =?iso-8859-1?Q?xWUF4GXnATL3eHeUKSJV5NE1dMHamqsfE2MPS3IQDk6OTEPptqe32kN5Y7?=
 =?iso-8859-1?Q?JWWF9giMWw0nK+2+peC/D4XMTBpOleCWgLDgm6eUf3bFFVsnOSxqFDhxGD?=
 =?iso-8859-1?Q?0USOWduYOeL2wK4r6d97E7mx1t6kUlnU3m8XfT1lm9t7H/R080e+aho0Rv?=
 =?iso-8859-1?Q?pR46INptDAcvos4Hnhte2F1RCaVLvknOW8RbV9HTtwOs8bZvWAbIRWTUrc?=
 =?iso-8859-1?Q?ZwDbp1JTFJA1luOK9bG9n2fqhMofVLPJNksWzCn74cK+FY9JH7mL6rAqo5?=
 =?iso-8859-1?Q?TnBTmCsc+170CnhBUMt/ZE+y6Qz29C3uA4xL7A32YUekrp3V4anBc9hFUr?=
 =?iso-8859-1?Q?Hx5x6JyJ/hGOG/7+iQ+FA5vcvxkRBSfqemCJQbHfBNbGPS0di2E8+s9aQm?=
 =?iso-8859-1?Q?7nu9Z4RWBVRLPLNTe6wiD38ArT6cFlIJBsmMS+ujk7jZOPj5rK/1t9KR/c?=
 =?iso-8859-1?Q?XHCBKYMt5n8MTB2KDPOKq9LyA3RqWUC35UTZY2EU6r5wAnaAuDcbzxYIn9?=
 =?iso-8859-1?Q?Z741X6pgIPP0VUV+5mqpY94FQI218nlOBcxo0syruXhNEFk69sSSasq/FA?=
 =?iso-8859-1?Q?8xjqh7qwzAc0jWVblu/buirzNPEM4SVCLXwAwm/u1bv+IstSbVLbl8E0Hn?=
 =?iso-8859-1?Q?oy6hegyTjga4NhHd2dmcsBrhXSL3Gfi2mZHB8gfbroUkxEEJmt86etWcVr?=
 =?iso-8859-1?Q?rETIkeIAdp22EgF05s/a+3Zd6DsVlPJ84t+W4LsGkZQSv5fw0ajsOYSLJn?=
 =?iso-8859-1?Q?pVGaJfs4hn/1o5yaDSX5sDyx7hiEgL1xFRi/Jt2p+9qN4P6IHo6rRQ+z3q?=
 =?iso-8859-1?Q?uZKUvkF8kFQkpppAqKz7syFrq+vcTXuJUHoFNbUHI3mon7ZuTQ+TMTslw4?=
 =?iso-8859-1?Q?VpoXGa8W0C/ZUyhNehpCGS3MrodJ1mbuPMKYhvoh2hnqRX/rSS+zBhX+/P?=
 =?iso-8859-1?Q?k2GMsVy63EeK/WmRoRXf+jjxpKZ8ZS51nObGsE4cZGAZ71S9kb/CMJXWQj?=
 =?iso-8859-1?Q?gBqAxp4NygpDcpvNlZZT2uSigRTgAttBjq4tM+IFi6TrnKDhtHZrsmus8M?=
 =?iso-8859-1?Q?QuA/F/DzWvkIP3WYZ7JuARy2auIkTKIdvAtRZBVQG0i8lEtwpUzGFmjdCI?=
 =?iso-8859-1?Q?vGbXz5UD3dPPHjv9WrEWJKQR7jLYRgQMEyibXsY6VKYuL8yjwqujOo15fF?=
 =?iso-8859-1?Q?pxjDIEeZRufAOvUgjWGXgfnBXRffUcPY7Ru4jngH/8+AbG64lodBXBFocN?=
 =?iso-8859-1?Q?VGTCZA6T0fhQgL3SUW3Tk2A6o2RyuiBCA5c2xLyIDE10LisRoknuv/nK+Y?=
 =?iso-8859-1?Q?isH0AuNIJLRt2i8mpcNe0jxdU1EPS7yM6W4ZqHujpxTLOX7gEmrlpk/abn?=
 =?iso-8859-1?Q?C0h3lWp35mPy/4LSzY2j3Bq2kLHsoYSi4N7JnzOdp6uQLjls/CnNdi2w?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df0bc64f-5b06-429d-44b0-08da9fee42bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2022 18:38:09.6585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FeiejHOOaVRtcyvfPLkIqDOpD7yUvuIHitLkZjVJ5mBhK+uWiw+dPXbXO+MByI4GHXF4EDPTUlt6TLRfG5zFcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO2PR04MB2248
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Commit 1527f69204fe ("ata: ahci: Add Green Sardine vendor ID as
board_ahci_mobile") added an explicit entry for AMD Green Sardine
AHCI controller using the board_ahci_mobile configuration (this
configuration has later been renamed to board_ahci_low_power).

The board_ahci_low_power configuration enables support for low power
modes.

This explicit entry takes precedence over the generic AHCI controller
entry, which does not enable support for low power modes.

Therefore, when commit 1527f69204fe ("ata: ahci: Add Green Sardine
vendor ID as board_ahci_mobile") was backported to stable kernels,
it make some Pioneer optical drives, which was working perfectly fine
before the commit was backported, stop working.

The real problem is that the Pioneer optical drives do not handle low
power modes correctly. If these optical drives would have been tested
on another AHCI controller using the board_ahci_low_power configuration,
this issue would have been detected earlier.

Unfortunately, the board_ahci_low_power configuration is only used in
less than 15% of the total AHCI controller entries, so many devices
have never been tested with an AHCI controller with low power modes.

Fixes: 1527f69204fe ("ata: ahci: Add Green Sardine vendor ID as board_ahci_=
mobile")
Cc: stable@vger.kernel.org
Reported-by: Jaap Berkhout <j.j.berkhout@staalenberk.nl>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 826d41f341e4..c9a9aa607b62 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3988,6 +3988,10 @@ static const struct ata_blacklist_entry ata_device_b=
lacklist [] =3D {
 	{ "PIONEER DVD-RW  DVR-212D",	NULL,	ATA_HORKAGE_NOSETXFER },
 	{ "PIONEER DVD-RW  DVR-216D",	NULL,	ATA_HORKAGE_NOSETXFER },
=20
+	/* These specific Pioneer models have LPM issues */
+	{ "PIONEER BD-RW   BDR-207M",	NULL,	ATA_HORKAGE_NOLPM },
+	{ "PIONEER BD-RW   BDR-205",	NULL,	ATA_HORKAGE_NOLPM },
+
 	/* Crucial BX100 SSD 500GB has broken LPM support */
 	{ "CT500BX100SSD1",		NULL,	ATA_HORKAGE_NOLPM },
=20
--=20
2.37.3
