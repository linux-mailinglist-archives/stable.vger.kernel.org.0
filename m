Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500C26A770F
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 23:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjCAWrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 17:47:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjCAWra (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 17:47:30 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736D51A65E
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 14:47:29 -0800 (PST)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321Lb3lG025790;
        Wed, 1 Mar 2023 14:47:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=mKx/MK/ImeGGqqBF2h0GSU7W0XsJw5Ms+Ttnxf4AzsQ=;
 b=fT0Le3zp2/3izqYr11l7yHYs62cp1C0idQu3G9U02VIsPcluFYCNpNsgwy5UR5YXjCHK
 uyF5Suinh+Sqmu6bMeu0Fgp//WS0hfcPSma+4XYDHsGnHQGRevgHfKGju07IaCIA1/fN
 IqIlLNQBbAjmgZHIm4GEj6PpODEwBUX7LsxnITJKdR48e8pLJw/SswpLr3c2hFzhhFFX
 x4I9ZSU8qXsOvIB9bO5DsX6dIUQTYywF1fMWr3bCwuisQJwHKX9jHP1Bd2XenmUkCH3n
 bfU+yFFhBwYs97JBCtZex8vOK3RArI/GYnbxWooe3/WWYgwnHgaL6kjpZqvKHbo6F/vr Sw== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2041.outbound.protection.outlook.com [104.47.74.41])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nyjqrchu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 14:47:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CAMsuLpCC3tYG1czNupgmLpDntQsM2BdZDGf/7qQ7zgjSfQb9Z8uymFmZwFX9mwvs8nA+6kr3GO24S58g2uOQW2raMdQFdB1STlWMpLXCNdDm79iYMAqEX1RAqulG6SpNa+Tiul0CAc5OZsASycSeniJyCDuNJNxvtbDdgnHNsG6KX4XJRa2CfL06RhNMpUs87XZTc8+0BgYva4pkCcsmlDbK1oS0QN3NtCCrIqwCb3m7VPsqDgxuoX02YOkYJa7gtg3nFtSxsUt8rRerEnqK7okl73lI9oI/wV37ssA3SM8CPBljB11DhLRhdENN8k/w73xT9t9WIxmx89VQ5sXzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKx/MK/ImeGGqqBF2h0GSU7W0XsJw5Ms+Ttnxf4AzsQ=;
 b=RQG79oTPwXf2/C5CSj2dT2XlYb7wsdPI94huwYoURa7a/13zPPmrkIGY+kx9H9W8XabgoUfOLGtPCFwNtz8OUMSsdpfjVZyA5mh+wRoT0zFHPB+PcjPzN5+9C/NHAOfSAlo7sutES7KcMkQPAMUg5DPc1klKaIT2NMeDKHTkPWSvZ+V9QDd5/zQV6oAnAVcNcL3vj2DN/FQyW+OY+svl8l7duBQ8mBl/lRgb9cQ9lCoavAcMb7peU2dLEOpipGiLx4v8HfdNGKePSVPZ6v9vnOCNWWMmg9ewLy1vyPyDekFGe5BtbJN47RCiq6FgguUKiGDB7FpfWOPhdfwfK/ZhOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by PH0PR11MB4935.namprd11.prod.outlook.com (2603:10b6:510:35::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Wed, 1 Mar
 2023 22:47:24 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3%9]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 22:47:24 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Pietro Borrello <borrello@diag.uniroma1.it>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 4.14 3/3] HID: asus: use spinlock to safely schedule workers
Date:   Thu,  2 Mar 2023 00:47:34 +0200
Message-Id: <20230301224734.29357-3-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230301224734.29357-1-stefan.ghinea@windriver.com>
References: <20230301224734.29357-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0162.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::16) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|PH0PR11MB4935:EE_
X-MS-Office365-Filtering-Correlation-Id: 3df7ac64-ab23-4eaf-ca3b-08db1aa6ec85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zw2NBG/wSGdcvs0DO+UCCttl2a4j2g/f+5i/Wg2dHEYSO1UGNiA0Kw909HKX0PjqboKDYMO2eMF8UlzmEUh1+QwIU46cVJrw/LyKSd0k9zyrNJ52pZK6MdrsV1+Hv/yJ4zPcImbI/xJHzj6lOvWwshvXqd/coARZ8Y4gvwYmRBNReHDHgNiA0wTSE8OP+iYueows/4aOowbLeYofLZCtFA14xTP1GXfAJcXlcJdNm3heMRKlzyHv8eXAV0fCFoP48A8lwJkKfPx0dMXcfPug8lBf/077s0T37VrE4pxmj2sTTKG+ks3x7glyk3b+KPAxubx4Grr9BxG4YXGOKc7S93hMS1eA4mdyKjKRB4ergJWLPO4cZDfMsxIbkWeUBzm9FDxRjfOs8s+j2cwFY/vyWlGLczdcqy0UjvvtuWd2dnjYj8Sz/61IGVyC+GX1H6ElWoa5U8wQX21yxioHdPNCaWHYUlw9R3LV6nQrmA13leAGNpwh094AZYITvvbk79cJz8Ux8BzzvjHWLRTUvkMPJefhbGn6DaP4x4srDSfdG/SrGk80Bwv/Dj1HorNgNpPOv4ty2Xl65MoLvrUgvhsxLjUO9VwjPGLRGKQcsRMVbo9JbXStgYyAsLLD6NJ6Xk0HHyybtVE3q/yOSIYsi6b9GXZkgv/SMiaUoge7U8p9fnanjssHRO59EopExeGcygQN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(376002)(39850400004)(136003)(346002)(451199018)(83380400001)(66899018)(107886003)(6666004)(36756003)(38350700002)(38100700002)(8936002)(5660300002)(478600001)(66946007)(86362001)(2616005)(186003)(26005)(1076003)(6512007)(6486002)(6506007)(966005)(66476007)(66556008)(2906002)(8676002)(44832011)(52116002)(316002)(6916009)(4326008)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zFFT3RZcfWE7gTtjjFmnc70WaGL0U+IlC690qIaK0ZW3g3OSwdy/ewKM452w?=
 =?us-ascii?Q?Y9qRT5LBKT/s9G9bwcVzrc3KB8xN4GfITD5IAnbsWlF70LvmeoxakzjSO3sn?=
 =?us-ascii?Q?KHiFJIsmTpRVmmGa/jL0TIU1ak9LIeX3/xDz2J2YsZa3jYccthbflI5aJtka?=
 =?us-ascii?Q?Vglo1Y6dQsSzeqN4aCPJ+syEa2mqF0256MPtCQ/k4o2SxKy3Qc3BRyF5pBIO?=
 =?us-ascii?Q?JWryAc8O64D528/k8iYb+2qKKAZ1Kf5n6u7EI4+V/n1k80vsTUtsmdKOIUvg?=
 =?us-ascii?Q?AQ5pre2t1ZkyIeqtcN8ea8HsDFVvxGDHiG+u0KGt2e2DRLdUGG2dRO8tKKP0?=
 =?us-ascii?Q?fuAV5ze9xhr1DYTgoKkMHIkgcDcTYG8n/725F5sm1KaJJ1g4ELRYNttZ6x+y?=
 =?us-ascii?Q?Dmx9OY3eGuPSwzvOcRP9nQdTd11sle2nZ2uYSLxGvuvHNyXAFUoF/qAZJqY6?=
 =?us-ascii?Q?WfxNdJ33JWjX3DO6pRmxJ8sXYdOuK3NE3Az/rkK0e89qRv8uWUQWiHx0CRzC?=
 =?us-ascii?Q?/xbeAdtEKnGC/Yroy/6io6W+HHkpAj2PbfsTR6BPTuzz4No/qM46n6lun8+j?=
 =?us-ascii?Q?171nnrfIiqua/xtvB31k1MnKkGUvtBKBC3xTTy85sWfVampdPDkntnNTbZAC?=
 =?us-ascii?Q?BESO/39GIAfW+Rr8GuDCUzXvlnarkvTUIRHgQA8HO32NNZD2rKFkZ3jVjEf1?=
 =?us-ascii?Q?kLxDc0BWzj+VHfLLJwh+i4HHU8i8v6y6nF92goJCnYnRz0haASheTAgveyCd?=
 =?us-ascii?Q?l44xknSQCoYaZsTCa4eG7AD16RRWomfHK4OAUd9Q/xGNqyojpIia+FdIXdeT?=
 =?us-ascii?Q?wsJepLMuXwQZ9ytovj/oLIgMeNlDmhnVDiqre2uWdaSMszwTsrsFWyFkPho9?=
 =?us-ascii?Q?zpavvqw6INmV1MvQq/tWtd31NZ9p/9Vzhs8vG3ZBB0U8qdNA80qbDCo3ckAe?=
 =?us-ascii?Q?Wc0bdJdyN6hlUQ3mP7IG7UuyMgPEwi3Qa6eV+u5RYImdfRmkxkCheQ1ZeZ1X?=
 =?us-ascii?Q?I4VbNl2cjZVmhl29xAcolC227/GGwi2oH7b80MBs+TcSMV15fE4knOzoj1mM?=
 =?us-ascii?Q?VtGqmqIZsKPt2SbKntRdthGvOujuIFYaspKHmuH4CipgJum/zQ+MASccLG71?=
 =?us-ascii?Q?dqN1FWPVjhs1Fi6d5DfGZ42EIRfr/OzvIhfa63jjc9L//ORHxDrcoXAPlvGZ?=
 =?us-ascii?Q?RxR13fDEkAAc0tsme9bk15BMXNCyIxzkKqmU2huVWEYgvQH/gi+AskJjv7lz?=
 =?us-ascii?Q?ORWhQP8Le3+OcMB1V6bfUoViOCE9liDcBut7+Cwu3yUtpW4ZsTpNDYE8Y8qZ?=
 =?us-ascii?Q?sYkfFO8PYEAD9FvF8HAzfIMoZ4uaFhISWdAXAk/tuuBJSf1bzLfcO9cigS8Z?=
 =?us-ascii?Q?1fWSb3TaBAlZlLduMC+WdxKwSlP4QuBM/fEJAPBgLSVN7oi3PbWY473QY4RU?=
 =?us-ascii?Q?RMXglSGTFK2qlmP3hbmJVYqbHnYq8QyrT4gUblVqy2USbeC24zaBwvQ4bKhB?=
 =?us-ascii?Q?oklGB7QcWsOUcZcy173Hm1Id5UfTld56f2vZLXD4kkuFDve+jBXJz+mPavmF?=
 =?us-ascii?Q?kO5TsMK+XvmW3UChWEYb9aCxtXggtdfPgBaAjI8FOcf+D097fu4h1J0yst9p?=
 =?us-ascii?Q?atLkJtILh8jPcU/wn5QCTps=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3df7ac64-ab23-4eaf-ca3b-08db1aa6ec85
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 22:47:24.1109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jMB5xUeNp93Z2l0TklmJRXKHt+mQU3IsZd2qE2kB01WE5Yy+Wx7LY7nTM4ZbEcBlz2G6gkhXg9u271FxZXGJQQWedaW8WmxXx3VITopqXVA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4935
X-Proofpoint-GUID: 7Tshg2__wADSctXfbgoSbvLIdat23_FI
X-Proofpoint-ORIG-GUID: 7Tshg2__wADSctXfbgoSbvLIdat23_FI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_15,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015
 malwarescore=0 impostorscore=0 mlxlogscore=891 mlxscore=0
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

From: Pietro Borrello <borrello@diag.uniroma1.it>

commit 4ab3a086d10eeec1424f2e8a968827a6336203df upstream

Use spinlocks to deal with workers introducing a wrapper
asus_schedule_work(), and several spinlock checks.
Otherwise, asus_kbd_backlight_set() may schedule led->work after the
structure has been freed, causing a use-after-free.

Fixes: af22a610bc38 ("HID: asus: support backlight on USB keyboards")
Signed-off-by: Pietro Borrello <borrello@diag.uniroma1.it>
Link: https://lore.kernel.org/r/20230125-hid-unregister-leds-v4-5-7860c5763c38@diag.uniroma1.it
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
---
 drivers/hid/hid-asus.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index a4bcf18ab18a..7cdbde2b114b 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -294,6 +294,16 @@ static int asus_kbd_get_functions(struct hid_device *hdev,
 	return ret;
 }
 
+static void asus_schedule_work(struct asus_kbd_leds *led)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&led->lock, flags);
+	if (!led->removed)
+		schedule_work(&led->work);
+	spin_unlock_irqrestore(&led->lock, flags);
+}
+
 static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
 				   enum led_brightness brightness)
 {
@@ -305,7 +315,7 @@ static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
 	led->brightness = brightness;
 	spin_unlock_irqrestore(&led->lock, flags);
 
-	schedule_work(&led->work);
+	asus_schedule_work(led);
 }
 
 static enum led_brightness asus_kbd_backlight_get(struct led_classdev *led_cdev)
@@ -329,9 +339,6 @@ static void asus_kbd_backlight_work(struct work_struct *work)
 	int ret;
 	unsigned long flags;
 
-	if (led->removed)
-		return;
-
 	spin_lock_irqsave(&led->lock, flags);
 	buf[4] = led->brightness;
 	spin_unlock_irqrestore(&led->lock, flags);
-- 
2.39.1

