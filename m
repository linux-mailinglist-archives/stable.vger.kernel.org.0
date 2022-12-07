Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C421C645263
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 04:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiLGDFs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 22:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbiLGDFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 22:05:47 -0500
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2069.outbound.protection.outlook.com [40.92.103.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F68D537D0;
        Tue,  6 Dec 2022 19:05:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FW0JtyLMwkASaNF9u25WjZ13obXd4FMZs8KCP+4qjuQQSp1ch5yzPTihlYos34I6/tlcb/i1nWMXwMcBjgUwYo7I1+j0LOKl51fB8JI3JOJuiFKv9hTSJO5AVeqQc/9NoJJ2pKjXSpKgFrvKXR+AQOOe+He6fapYPlUgWe/EZn+v+goIFCGqMPAPhyGOgavYZwJIcEBmS1kBl36FTnZdDZcyz3cmd7TpH+2slPKbATiT4e7bTb0uTUkSSUIE5uBe6t+XrfL3Gb66AlWkq5WhW+9NmkYg7nXYSvWoyka1yWbN8tzGP+Dq/rZM6cLD07yvGW+ufyXSDw+jb6S4qfbxvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yBZqd97XlB19KWL/nC59Tqv+Za36KpH38qQZDrr13fg=;
 b=kXKJSKQyd15wKTzL8oLdlPRSP+J5P4Rq+lSKAkhYTOCbNgdeDdkx1C561VkcGZHGNCgCRk86X8OROx1uzRe+ptIL8bPkv/kvpTU+B6AH1wVR20Zq5rcjVjm0N8clOy8EYUVIH5868Gwrt3VNLfIcd5GNDQ9is2u/DX3bjg9i29uOfDNWAt5ZH3i3Nye9BupNv//O83Ak/myPyT2ZAXKny0YGM5TrZ051EEWs5pmslgcrhFwK+M4uQlJuhbH77UPkeFVswPW9c2dcgqUxeKP5xrtpx3UW3oIk0cjjEi/CHHmAJ5s89XDlqUbyGsN5Bx0KYcJSDxHhCPzPGhshALbkiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yBZqd97XlB19KWL/nC59Tqv+Za36KpH38qQZDrr13fg=;
 b=YIopbJVSAcOUZJW4WoaS0+ucDyeXkNQTVoioglxa8mbHhEoy8XOXLfx3g53GSMg+8twS+AbEMfkmi4Rq/rSNF0dXX8r1XGYwtWDLoXLso7gJG/Z1dVIUrXUAVE+LBmboJr0W83xtmXSoSZZH23D2bPQYkS9F99wRWe+LkTzHfGp1sW7KLCSDuwPCqlSMzqQgFaZFhM/hXiUEo8o/U91hnqxci/bsMGcMl10/bjvebacgZ7G0l2EIzDhHCZ0lfCtYKwqUiX/DpNhOxQKKGig9bX1RWGg3gWMP+itD+oFM1aO/aJ/5pKoXA3NpxjstXlGvUvltn4NlvlUYdM4jYUv1fg==
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:2::9) by
 PN2PR01MB8896.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:115::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.13; Wed, 7 Dec 2022 03:05:40 +0000
Received: from BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::68ba:5320:b72:4b1]) by BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::68ba:5320:b72:4b1%4]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 03:05:40 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     "willy@infradead.org" <willy@infradead.org>,
        "ira.weiny@intel.com" <ira.weiny@intel.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "songmuchun@bytedance.com" <songmuchun@bytedance.com>,
        "slava@dubeyko.com" <slava@dubeyko.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH v2] hfsplus: Fix bug causing custom uid and gid being unable
 to be assigned with mount
Thread-Topic: [PATCH v2] hfsplus: Fix bug causing custom uid and gid being
 unable to be assigned with mount
Thread-Index: AQHZCejJlmiHexwDakaNkSkAkua99g==
Date:   Wed, 7 Dec 2022 03:05:40 +0000
Message-ID: <C0264BF5-059C-45CF-B8DA-3A3BD2C803A2@live.com>
References: <93F5197D-2B61-4129-B5D4-771934F70577@live.com>
In-Reply-To: <93F5197D-2B61-4129-B5D4-771934F70577@live.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [2FX15KG/udpB6oHqPI64CcVIQXyAA36W]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BM1PR01MB0931:EE_|PN2PR01MB8896:EE_
x-ms-office365-filtering-correlation-id: c90fc2b9-1899-4e0c-c3ff-08dad7ffec41
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LmDYvvOkibVtpqUYwZuJ6pGMe4+wJGGeApLkh1URmcPFGwoEPGE9y+XqUwNxgOpPHPRIuI2/xRHknX8EHKcV+hgcdI/6OnSvho+2U8CYyvKs3AiM0z6ZcAx1tIjNOH2/c8b3HnC/YldNykdoPeYeAQcYt4v46vWWNjPOIZdVCEAJIoRxl8obC5hcK40YaXe5cTmD+lNmXjZy5Pb/P+V+dOb9MtYa4fGVhezxAMcoZ8onfwS6oNnvO5mvSsgDIOMEEzKh5kToojPKpirHe5VmxeXDy96um/OR+ryLwGDexdjq1TBE3w+dLBiMPoWXaqoY0MCQjiM4gCN+JjHaJKiPpXiIosm39QFViV7TPSSKzmIRgUNf3qgrm8niSvGg6NxSFtI/b2SYw+T6PEah2gJ+8G5msqwx9j6xqRSQafEe5LWvVT+DR3UUTyXa/eZg4o5csGGeIuzOQ/bQjSBH0xjbM2MyeY0NbpsV6nqQoVZ6fTtolatasRcYdJ0jzrwLHT73JHAUKL/IL0Hyl8y6tbUDkzxwtFTr+bw+P7Yh8iirLN47i8AepO3QOVjCa6pAeXtw2P5px1EPuIB1Xi6glZuaNA==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mUeoj/cv8oAlhiqhx6gkOqkpUZm+WsJ+BV7MzeUdteyICwJn9hMKzeBTphV7?=
 =?us-ascii?Q?eSVPxwcCs/D0T2zxnosSJKDmxF/dFDIdAkTd+J0+jjPXNp5bKqScPV9MvyOD?=
 =?us-ascii?Q?Q6AQk8QtHDmx4xMbsJAyZsjkEdZ1WU3ny6hqOIu9BmqLB5EHNFKvAbhJGJEw?=
 =?us-ascii?Q?p0bP6MzpplUNbD0LDdPUTYKo4jJfbk5OnCMXwJhmeetZPCE5UdqsHcJDvzuM?=
 =?us-ascii?Q?Pe60lICuEFrouew8VzTyr90sPgb3nahP0drNbIDebHlxS0hHUJI6lqY6h3IZ?=
 =?us-ascii?Q?YT60fZipmeFYzLmzBUOqbWnP0cVUa3M+sYO0jzU6RD0V3xzgJz3hmW5DrdmR?=
 =?us-ascii?Q?AMY8PZFoQqIk6l5IHnCwJcoq/dc82o0df1of9gbEevgcm1fedXNEC9PeFmLc?=
 =?us-ascii?Q?guH7ncFo3BGn1qSI86+fJ6XD0IZNYgfspt5Ioes2TkLuYtC2M9SDNg3KEP5a?=
 =?us-ascii?Q?QWmKHUFeyjzfyLMgVClX2go+d9eJyCXBrqY0/bXD/nW9Amfc+Xm6zw+i5nTZ?=
 =?us-ascii?Q?tXUmec4EcNow6dROXxcNTxkGZZOicf0WQrTmJnM+hMm2E+dBB++hLvOPepW0?=
 =?us-ascii?Q?Gwzrqeue2eLCMAdbPFHCmdTy4X8zjTnEuOYB0gCF2E2jYVjjtSMZwokwGJB0?=
 =?us-ascii?Q?FgnSXXen01UOvIZoSt9CAt1FGijKHyK0CQIyj8eTjgXTHsQSjIX7U+AtGvOL?=
 =?us-ascii?Q?W5sQ3DoDygW5WK+EbCpRNsQNWbQXcXtqIN1lPjC++bmeDUvM+tImgURMg3g8?=
 =?us-ascii?Q?tkuQgDX9kpBVAO55KB2aPOXdNO48YkMSCFEiMR4QQ2STnyBp8PSwC2qdiAai?=
 =?us-ascii?Q?X9+JuxDaU8Pov3wDff7x7eWw2VKZ+zrdJCsrvHUwc1osUzncGEw3pdYHiv4R?=
 =?us-ascii?Q?IYOWc6TTpH38i2iO7O77eqiElulRF74accQ5r9UT2Ukgd3xDyCYcl1/NnkY/?=
 =?us-ascii?Q?XCxA+Oajr2RnW62FxDQCvTIA5HVcY0XxXgh0UVZv51DiJytgmubQV2/gdY0Z?=
 =?us-ascii?Q?ES8W2JPFn7AMobLY0vrX8f7J+gPzME2jvvOVK5qY/DKmZ/ggm+MQQz2y5frc?=
 =?us-ascii?Q?S8RXYCUxbobOsXfX+mWrbJFjl4Vu1Tsj8r38PWUGa04AT3i/K8YBunQrpoZl?=
 =?us-ascii?Q?mbsR6Ui7OCI8lpxu3+AehU8z+IVtR/JrDi8PXo5L6u11zpCavt+E8y44TJU0?=
 =?us-ascii?Q?scxSf/dZyQDV1rIAGvH3sTC26glHNXv5f/UMP3pEdXtIoVq04K6vh7fIxxRM?=
 =?us-ascii?Q?ZeCNmEP+0TsZftaLDpb5eNy3KNGBjLYxhqeIwLFWeQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C7A295AD8ECD84439825A6ECCF8C100A@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BM1PR01MB0931.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: c90fc2b9-1899-4e0c-c3ff-08dad7ffec41
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2022 03:05:40.6399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN2PR01MB8896
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg <gargaditya08@live.com>

Despite specifying UID and GID in mount command, the specified UID and GID
were not being assigned. This patch fixes this issue.

Cc: stable@vger.kernel.org
Signed-off-by: Aditya Garg <gargaditya08@live.com>
---
 fs/hfsplus/hfsplus_fs.h | 2 ++
 fs/hfsplus/inode.c      | 4 ++--
 fs/hfsplus/options.c    | 4 ++++
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/hfsplus/hfsplus_fs.h b/fs/hfsplus/hfsplus_fs.h
index a5db2e3b2..6aa919e59 100644
--- a/fs/hfsplus/hfsplus_fs.h
+++ b/fs/hfsplus/hfsplus_fs.h
@@ -198,6 +198,8 @@ struct hfsplus_sb_info {
 #define HFSPLUS_SB_HFSX		3
 #define HFSPLUS_SB_CASEFOLD	4
 #define HFSPLUS_SB_NOBARRIER	5
+#define HFSPLUS_SB_UID		6
+#define HFSPLUS_SB_GID		7
=20
 static inline struct hfsplus_sb_info *HFSPLUS_SB(struct super_block *sb)
 {
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index aeab83ed1..b675581aa 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -192,11 +192,11 @@ static void hfsplus_get_perms(struct inode *inode,
 	mode =3D be16_to_cpu(perms->mode);
=20
 	i_uid_write(inode, be32_to_cpu(perms->owner));
-	if (!i_uid_read(inode) && !mode)
+	if ((test_bit(HFSPLUS_SB_UID, &sbi->flags)) || (!i_uid_read(inode) && !mo=
de))
 		inode->i_uid =3D sbi->uid;
=20
 	i_gid_write(inode, be32_to_cpu(perms->group));
-	if (!i_gid_read(inode) && !mode)
+	if ((test_bit(HFSPLUS_SB_GID, &sbi->flags)) || (!i_gid_read(inode) && !mo=
de))
 		inode->i_gid =3D sbi->gid;
=20
 	if (dir) {
diff --git a/fs/hfsplus/options.c b/fs/hfsplus/options.c
index 047e05c57..c94a58762 100644
--- a/fs/hfsplus/options.c
+++ b/fs/hfsplus/options.c
@@ -140,6 +140,8 @@ int hfsplus_parse_options(char *input, struct hfsplus_s=
b_info *sbi)
 			if (!uid_valid(sbi->uid)) {
 				pr_err("invalid uid specified\n");
 				return 0;
+			} else {
+				set_bit(HFSPLUS_SB_UID, &sbi->flags);
 			}
 			break;
 		case opt_gid:
@@ -151,6 +153,8 @@ int hfsplus_parse_options(char *input, struct hfsplus_s=
b_info *sbi)
 			if (!gid_valid(sbi->gid)) {
 				pr_err("invalid gid specified\n");
 				return 0;
+			} else {
+				set_bit(HFSPLUS_SB_GID, &sbi->flags);
 			}
 			break;
 		case opt_part:
--=20
2.38.1

