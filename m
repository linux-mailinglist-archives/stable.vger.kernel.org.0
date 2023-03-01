Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2F56A7706
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 23:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjCAWrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 17:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjCAWrD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 17:47:03 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D204F1D901
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 14:47:02 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321LoCV7024370;
        Wed, 1 Mar 2023 14:46:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=uu9/gvtgTM7Le7LS3ElyzrM8K69JlxOnz7wt2k0yZ0Y=;
 b=ANg74jjSTl2btc4/kQDm+rKifHUXsmXy41N41xp4F4l+JMrwil1gcjo87qAey56WWdb0
 cmEKh/wbuxnizVTIYjA5Dq+PJeZQ5T7bYmnuruhuF5bjltrxQjBQBUcOc/vJpJD2qa3p
 poCvlv9Z/Tpan+s9GBrl+ZDvdG6F2dCK/OVTZTcme6gdmWN2KGmIwyfYt+QRSZsBW6b2
 cz8otIHyp5UWPLUA5J4X4X2KmzJFaHTeCMOwQHAenSHQ67f/DNxwqoKgrXF0ro14ujK8
 AqKGbTfhQf4sxeF6S2C34OOfjurN9SG392Z8p8fHaI8T2PukOrxMtLPqY7xOiPuRHgDl eQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nyjqrchtu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 14:46:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PMx6nuwLx8Asj/UAlOVXid4QNKnjNafKGSVsG9j+fqsqT/L+AFFNUATjUQ54Kx5MA+vZ1Ej+YyHazCNYJKeWI/DvH0Chr/S9DPTo7MczlJKtcUl6jtluBlfx5GW9BhdM7MyzvupzA+SM6qKMdvzNiEBzbPA8I/EVGY4SFO462iFbyfqN+8iycgGwPoVzcSORsqwLzyeFaFn5RhqhseX3Tsa3nwJzsx8lghsoI6q4XUUcohMlxPBio4FBhAMYRf8A9THjgg+MbNlYCcy8wVrElgYcDVhFZPSrZj/DNhDKLkMP1SS8F6WMm0X3o/R8Dm+w2p+hM1b0WBdpEEGcHW8KNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uu9/gvtgTM7Le7LS3ElyzrM8K69JlxOnz7wt2k0yZ0Y=;
 b=E0RE1Lc2XXDjn4MEvec9LUIBBBAeXEu8oUQ1cYxNfoM0MSubyTSaWGhOb1V1VD2EenAXfdejdBBf5O3iFltECzxu/PVXbAOea5TbtLMWlXLH/0z6UXL0ra1cABTrs+/66RwNuB6pgpNBTJp5eikvJ2uLnPQtE1FsZ1HtM1s3TKYh3Z1wl4wACS3gEwGbLS2JY/fK5q/S0kTNohe/O1Efm+VmTtP9qW6/7bmOigdHbAK5btzIHDjxkNAiN8n3zAvDve3OZQ7Dgq5j0mhPFjRN1FO4soGnamZDbt0PofgL06R317YWyMIJSmeFTy/lKMNzuIQPjorzD7ygW2AfWm0VWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by MN2PR11MB4760.namprd11.prod.outlook.com (2603:10b6:208:266::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Wed, 1 Mar
 2023 22:46:54 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3%9]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 22:46:53 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     "Luke D. Jones" <luke@ljones.dev>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 4.19 1/3] HID: asus: Remove check for same LED brightness on set
Date:   Thu,  2 Mar 2023 00:47:05 +0200
Message-Id: <20230301224707.29306-1-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0059.eurprd09.prod.outlook.com
 (2603:10a6:802:28::27) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|MN2PR11MB4760:EE_
X-MS-Office365-Filtering-Correlation-Id: 91998ffd-532b-45c0-44f1-08db1aa6da2b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TrGnIjPxyVR6EO8zwvCk1TSlrkBebvmWrzyJNrUEh8EGLmeWwwwjYK811qpAJGkGm11/nJwHWDoFY1EEed74Bw6lXKWwA4aYcT7BeQKEhF2Ly5CwITPKTzF1ImRwfQWdyuIekiSyJc3sv+6yIQ4zCe5h2hU1txMwRQTdSbnbhYpjNCGaENKULdZ3WlZLhAHgDXe/W0LXwIrgLqGFe/Bn/AvEXQxJAlWhxjGMTFI5/CU8N8BPRduJ2OOpam54J/gf49U5LrzUMJIc8mXL3qIuSbGPrqHmPyMBUxsgH1XFZ6161AS/7tzkMhWp7k59bz/9XeR6pilMu+TxN9XO2GLuDuigLx/o1ejEPMsO5+agQGyHZljZ3dDsB/wu7Wg1iGjzPObN3UL+QpThlrixiKhiaFCD4/1Ax/R1IpT7Yt36GhfyYdZMoQco5wqfIJyYojnHvEqkRRT39ob6EJFVppIjZbuUyDxVT7GXpyvtqbt3R+Wh7umjlW6wY1ZIv9HxrkmgT8kEzSrVph1o91phGqI019129r3R52jLnbva5p+b+dXH8gfM/ObeCr//9zmLLsoMaWEedTKUTHTFViEhplgVr5vR1IEZHFr+ySJJqfJcJPXTluvtQDm3NLkMz+zhC0T6yBIyHGjq6mCjoSVpDees75P2kIkhxh6TAgd7DEugf9ieye5UZmlO/lF6QlqEqBIJxf7/kdEXSSRYtdNByIufkg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39850400004)(376002)(346002)(136003)(396003)(366004)(451199018)(36756003)(66556008)(4326008)(86362001)(8676002)(66946007)(41300700001)(66476007)(2906002)(8936002)(6916009)(5660300002)(44832011)(6486002)(38350700002)(38100700002)(107886003)(316002)(478600001)(54906003)(6666004)(52116002)(83380400001)(26005)(2616005)(186003)(6512007)(1076003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EfClq0oBhNTMP9oN6h9sfDGaqoASAIAo5YS0sYsTdYZCANp9Xa4s0310mU53?=
 =?us-ascii?Q?QzIl1E+yEjyfuPB4dUs+dY9d5DMDBghDEcyVtDAiqsqaJpxQ++d0V4vPQwXg?=
 =?us-ascii?Q?gNr3Z7w4bw2BuZhtYjuQFO3V20pzzv/1Q5iL53B1xwF80hpfVPhdaIfjhopI?=
 =?us-ascii?Q?canR1u0/6RnWS90NRdUaPKVvgGJU6EpRiyYyFwE0l3+FRv1QUTrrQ1DSj7LZ?=
 =?us-ascii?Q?m+akOu2PvE7DJO9hftLN0h9yLdPIFNunX+eN5ZCLyk6AQ8IGwSvgmoqbG6yL?=
 =?us-ascii?Q?/1uEUZTAS5xsp8xIgqWltPmKWk66xrdOTZdfMopPqUFukzFR9CaxMzMq4oKu?=
 =?us-ascii?Q?UvJJWLm+XK3680P/wFyui5MnzraABO9Xsnp2b20aU7fOMe5WBEhhF2xeOJjp?=
 =?us-ascii?Q?MgxetXnECQqNEdrNHrwXl4HeHsvCTq0p8YtYhBwSWfqjMDmK/KnZCiY7o7Tb?=
 =?us-ascii?Q?Z6gqtvs6W7vlQ0YQFvKw6145LN0pwrqFsWqI3ZuqJKroaunzVx7z5Sb1+8B8?=
 =?us-ascii?Q?GgIN0J/IZphNODlpyBbncDbJh4BO9vZ5dvrm6y79z0wn4JJqvfZ2avbZR+IF?=
 =?us-ascii?Q?Ra9nKGlAWvrVxeoHb56fDPP2VxI45KOKlc5sI8/EhLfiQaT45s0BOKGfOHKL?=
 =?us-ascii?Q?Qo84u8J6GJrDth6pSYapcBD9WbXIiBD8fgi6Xj6ZYw2TD+zJXJPaCZSHnv0F?=
 =?us-ascii?Q?oywNjTPv/APk8mINsw1Fi9abFlzAb/TuJ48b+WWAkvq0+3KDkzJUhEXWECPB?=
 =?us-ascii?Q?493kaqvtOpQ2YM5T383RnjRSVKYugEejwU49UwDMWlSvahH07UJ9+ptccMkP?=
 =?us-ascii?Q?p+JpUBIzfggjuNfda48iE3GIeFusBckj/QjzE6DBVY041EhR1m47vRn11FqE?=
 =?us-ascii?Q?gqKNLZRLO8Zo/xobRs2j2UrfXSsKoUZ/dr9jUCyycE0KIdIM54ZLmq4ruiob?=
 =?us-ascii?Q?VIWA278i2jSJmuo+KH39u0PjuZvHjKp+ngbCjtu8rLVdx/khWTdpzzHmuMC8?=
 =?us-ascii?Q?RjQ2cA0Ez7MaQDx/fO5Ll12uShvSHpmuGSEkrU4rHYzz1WxPUEGyzEdIcaFJ?=
 =?us-ascii?Q?8jI1E2F/QS1wX5Q31DSVE+M8jGmq339wc4x1DkzesPVFrwTlyXdzVMuOdT3p?=
 =?us-ascii?Q?Kb4WH6BoSjYP98TFpV8Q3kiEemEk1Z8JHB/sNnM/apyMQahBudkSnbw4H97k?=
 =?us-ascii?Q?67zLsC53wP2wpyeSm+sgfpHqJo+5ymnEJvWHqbP0/J+omdHa46YRrozuCAsG?=
 =?us-ascii?Q?K8laszLMHzoeMyYPFaitBZG/itQZHAx0nrY8Cs5fv4gzQ3KAS90jlklYfPAP?=
 =?us-ascii?Q?QNdGYqkdSFsH8f8huMwMBl37naWwbn3wyV1JO8Liz0fALT9ErsR/BFfDf0RC?=
 =?us-ascii?Q?cyKBlWWzeQko2/AqSa1nWnI74LeMwOhHT9tqxXYYBgv5dS8M0U9DeyjqEb92?=
 =?us-ascii?Q?U8bX0oT9Xu764sIttW3CQoKCgkDZmnRG1ag7XY+pVel0QDz4llz2PDP1mNrm?=
 =?us-ascii?Q?Xo9h4HedsCbxIEyxwZhh7bDdrNLTo3+o1GZclL/aPl7VdycRc9E3cyER9pMt?=
 =?us-ascii?Q?8ea4uRL/6SOsXaKttpYACIdR5e/JfrRfFQoBsg2u1/7KIEkLyAKphmQxGEt/?=
 =?us-ascii?Q?Fw1kY2foE+v81LMkS87vcVk=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91998ffd-532b-45c0-44f1-08db1aa6da2b
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 22:46:53.3668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kvElRCq/L45+ADu8fl4RveapnOjMMrCvi2I7PRYB0maEtGrTSB4Kqv30f5nfe/q2BHzBOnukcR8tIQ07g9caaL0KDqqyXkLmeBt4LlFCHIs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4760
X-Proofpoint-GUID: ggDD-mm5OP-DumwUkQv-fMi_2Vj7zKAO
X-Proofpoint-ORIG-GUID: ggDD-mm5OP-DumwUkQv-fMi_2Vj7zKAO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_15,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=932 mlxscore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2303010183
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Luke D. Jones" <luke@ljones.dev>

commit 3fdcf7cdfc229346d028242e73562704ad644dd0 upstream

Remove the early return on LED brightness set so that any controller
application, daemon, or desktop may set the same brightness at any stage.

This is required because many ASUS ROG keyboards will default to max
brightness on laptop resume if the LEDs were set to off before sleep.

Signed-off-by: Luke D Jones <luke@ljones.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
---
 drivers/hid/hid-asus.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 800b2364e29e..9ae8e3d5edf1 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -318,9 +318,6 @@ static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
 {
 	struct asus_kbd_leds *led = container_of(led_cdev, struct asus_kbd_leds,
 						 cdev);
-	if (led->brightness == brightness)
-		return;
-
 	led->brightness = brightness;
 	schedule_work(&led->work);
 }
-- 
2.39.1

