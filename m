Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6131E6A76FC
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 23:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjCAWpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 17:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjCAWpj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 17:45:39 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 866F2305FD
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 14:45:33 -0800 (PST)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321MPglt032222;
        Wed, 1 Mar 2023 22:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=dilbmuHCTBJ9YjLuJwzIchxdX40s8FgEjkvKD61khUo=;
 b=AC4hzGqjgyUxfmJ2Cwg9kTbsJ/uOGmKQM/+WKDZvpX2pxNfY+SGC3FnuYkq0JiQpi30h
 f9gjR46zf9eaz+/015If3LD1M+iIS6wqpeA03usGHlmdU0QZ5wVp5RZPf8CFMp5mCfuP
 63ATjonpFRxZ2fdPlIAsY/eKnOgzDWYP2akY6KeyU6cTrhvr47KxpWr2VAbz+pc7SFUz
 depo+TlgBllv8gPTu064B8bhMM9m10CoU8MBr/5WRRySvmGsr1/G5eSTKUc4ROPaguX0
 u8WiKPrbT4aOs0HEhhg5TweGW4kXRun4h4DWRMTYgAfVQMqyhBoPqpRlrhQSzJ6py1bD wQ== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nybmkct4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 22:45:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EHTCIVigXMSZdVz8Q0x+3PQ+h1ObTPEPriHxOdMBWSNLkfmQr4Qo+66k6KcERla89N9GE+kB8D+TywPSGY4YXKoXpYn/0YfCi8cYiy4R2uE+mpOX0hKh7RkFlBBiJ4eH5u751Lhl7ENooF2mcM6eZmDIUO/007qJhnJHXK1fu0ktuElXOhPnz6j3C0iDrFxGjlqhvG6fg8lJ/pqbMA4cMObq5AQhKdfNaYjjQQZXhFQgJpjvGNE6g8R6jgX6lEMH+2AYF9sCREinbyR42uVQL0fOWxo+YVyqDvZDeRwahFdt3ISjwGTDxBMRLPIxTkmxlTcHbfUPjCJM08HKqDjXdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dilbmuHCTBJ9YjLuJwzIchxdX40s8FgEjkvKD61khUo=;
 b=RoCfDpTLkB2SDq1schCaO53mdjmGS7UBycfQ0U72YT4mHnvMKDsrnDFZ+Uo2t+S9bg6wRxHcUcnmmYU53c1ElGer7G8KeCT5CC98UNhvy424qnQnuGsBvaJm6oYXb6AGdFJ3XnDwpIEBdNE0tNq2SeUsHNAs1thFaZLONf4ObVPeJHKkIx/9+CQPlTqVZI4pQ3FxF0N1XVHY6Qm/Vns88ajvpVDnczHt80VArVVebKj6kEobdEjFOTZrRfgTL4ky3VPiDAvES+cli9AeTr+RXAJjnxzQhJ0jUYeASjLD47AhP7D0iRJ7x+frR1vJRbUu5Pj4/uaebT8dE2miKrQrkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by CY5PR11MB6535.namprd11.prod.outlook.com (2603:10b6:930:41::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Wed, 1 Mar
 2023 22:45:30 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3%9]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 22:45:30 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Pietro Borrello <borrello@diag.uniroma1.it>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.15 2/2] HID: asus: use spinlock to safely schedule workers
Date:   Thu,  2 Mar 2023 00:45:41 +0200
Message-Id: <20230301224541.29043-2-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230301224541.29043-1-stefan.ghinea@windriver.com>
References: <20230301224541.29043-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0187.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::44) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|CY5PR11MB6535:EE_
X-MS-Office365-Filtering-Correlation-Id: 02e835ee-47cc-4d0c-3660-08db1aa6a888
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: stMwke5uNJzNwCpyjeEskUuEXss/DrMVNiComwrWPCW2nONJ4GtWM4tMSGl1VFcX7e7B5yyogcf6r8n48OlidElzROEYglzHD1CvUwNxZQfnxUynT62iPfmIBXuHgv0k6HGgKoaXVYUI5ekYHb6/fWxxw3P0DiNguB66yqejuU+szK0Shbdv7Ta9fF3HE4GRhJiBvRXvW6LmAigm8+D2Auy+4cHTCixnvc87tvOQOj+F09U9Jpzw83xXSs81EXo6rfUuK/bbQrRLovS7RUdLh8w+Co0+bOM68ZWZEUZSDYy0lZPK/vD/zPxz96c54S0LZ6uE7udM8gvX+2F4e9MgmkNhIzR3z3xETvQUPqS8i7Zv1nYw59mbmCDG2q4N10k8j4A9ISd6/CzSpBDLca7DksA/o1cMxHbnAbR/DinLLpCWMDrVybSRlCxgpp5zGJjMInGWlnfvzfPcGmRBrM/NvqL04aYfnvhYRatk0e2mRrkNc0FLMYcCe8R7BEn+96DnXbhmhgzNNWKloZzUEr/bnW6WaCxA7Z7WfvboO8x+saDVF9Qt7JU1SMr3K97FZI7LtXxoRaHKZkLv7XQ5xvOAg8bKgA+dXW0Y5JGDh3uG33E/lkL+uyB1QlRgXoIZ3o4XwiA43pWGkHu7LBnDnHji0sLbqMBowBeS36+nMuRgzZSxnjuUnwSwWBtlepYIdijK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(346002)(39850400004)(366004)(451199018)(38350700002)(38100700002)(4326008)(36756003)(52116002)(86362001)(44832011)(2906002)(41300700001)(6916009)(66946007)(66556008)(66476007)(5660300002)(8936002)(8676002)(1076003)(6506007)(2616005)(6512007)(26005)(83380400001)(186003)(316002)(478600001)(54906003)(966005)(107886003)(6666004)(6486002)(66899018);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?98QM4QXowaWoiE6fgExRT7B1Dj+DvYHJyhNuceO/d2U4bDwwW0eZN4wZj8gu?=
 =?us-ascii?Q?rn+aPWjNxxhMXxPp5uAi5qBKTaEwJXVJ+BtMy7vkEUQgeboDBFU2a28ZVIwO?=
 =?us-ascii?Q?4VeHN2v3/SGramVJiUpUHhC/7ledDJeV/RO+b0lkDs9dpYhuTIIyYNPGEBtV?=
 =?us-ascii?Q?t6u/jOoPgbBwbcr9uaS+2THZRw2pLAFa78BUY5kkCCFPtLq3ld1geABvEO1Y?=
 =?us-ascii?Q?+ekv01dxoIyNcCMoca03y4oEVvlx5TI6l1ETOca3MA4FCVtEPeO+7LP2Wx8Y?=
 =?us-ascii?Q?cyczk7+EgSwUlGPxf5KfhqnRy71kK9b21EHMp2CU7KuGQbmkbMsJWesTaJNK?=
 =?us-ascii?Q?0ij++uvq9HKUG/tO294wsaHaGGgaLqiqqxR2kNTNlx+Wz6+/mM1WgrCwHjjG?=
 =?us-ascii?Q?V6rUbOzyqP4u+oqqZlu/8EECXHy/+Nm6ZCFmXs7wDQw9l7tBFddy90KecTDB?=
 =?us-ascii?Q?ceuvI5DCXtIZc9t0QfDtIcG8oLLRt8oPhzpUydNcQsu10BGq0TeAcPX3hUNr?=
 =?us-ascii?Q?m7CRLhOCAlK23st7RDqKl+0BkWM37TutNlTMTERTh9iAn5KxztMOHO4pZmck?=
 =?us-ascii?Q?5g6Rm1OATnl7A7Qb/+3rN4geAmIvY3hIYIlah9yZwndFMVHsCr7ecTsvZv/G?=
 =?us-ascii?Q?/U+D7PS5dWz0vv/c0Q/IZXdZqjokecOkEAvvJ/PBvVwhckRVGHVsZYRSseow?=
 =?us-ascii?Q?2VYUpTaWQWH5fDtVLBCArfOD41dvFeTxzRHVkTQBkohOdjsddYj5W0EclP9g?=
 =?us-ascii?Q?+NzM73tjmB39ALQs1fWiNTGrBxsjF4B5c+sRJ6KbM8e6TvR1GqknC92ZJnqn?=
 =?us-ascii?Q?2oPfhN8dj7M+7E7yxhB+ryhr50E8QA3+2crnq88zscsWH/FgpXOThAZxj03i?=
 =?us-ascii?Q?6Wbrj4JgMEpfU9tUrSwlA3I0blidczrRPTWlXm/1ALggI9p79oq7b8VjNje8?=
 =?us-ascii?Q?d5LGGm3Hqc9yESJRiem8FHlmJbVMw+obf4K/3uN6VkdsExa0nBm0CN2g4A0N?=
 =?us-ascii?Q?EricGkQxlDaSjyIt/6Fn+vVO78h4gMlMcs69Na9yfKDmKuifg4NIq6JJrcmb?=
 =?us-ascii?Q?0lrNs7Zkzfs1P0l6xXGJql/EeCaCaOWTdORb/6PsVaizeRkGzMMDuztuh0/l?=
 =?us-ascii?Q?rhnCf8DvM3MLAWQ62DQPQNH+rdqxb0zPuK0Cn9acvg8K9ylHEBuiT2ZFguK8?=
 =?us-ascii?Q?+SjgzYg5NxTTzBrsHy4Bvm71ve9jYyy6k8WDF2bUQD/WKxNzgOjU7kMDqxN3?=
 =?us-ascii?Q?03jaCV5PAtMRwshXMgS1ADVZcoyu6DXLxhir/3OUcgQwO4spHfTC+xnmlvZ7?=
 =?us-ascii?Q?gwDIdSyfC8RxozXQ5S9X43Gyt+MDJqfS1Ru0Jve0FDU5ONAppc/sZpQyUJv3?=
 =?us-ascii?Q?IJrodb7jdERWYQd+9qH0LBONbdt1HzP+Gtbx1Bh/4H6Oy732BZY5pVDhGf+U?=
 =?us-ascii?Q?dyjwmjPZLvHs6ycbvdCJjVUzXvdcksfS56ZntAVi/hJJV/zq7UZBjzP+YkPx?=
 =?us-ascii?Q?zUh+cPnUMb2U9Mo6as8WZ3EF4dcey9FYBjRj2pZGxvP2dcb8bI7s2xdrtbk/?=
 =?us-ascii?Q?IpzxGmbjUHO/kcKq2KPdrI+S1KmYPCz9pr9J9TbA5r27jd5NpEEnbk/dO6dk?=
 =?us-ascii?Q?ffhF0P/5RXE5AiM29700mYE=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02e835ee-47cc-4d0c-3660-08db1aa6a888
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 22:45:29.9324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5zn3MaRtOt8R5jtwOXt/GmaVUMWBp5gXnwp+kB1ca80qlXSjAb7EG5d/ZBIeHX/cpjlEKKiuxZcIJV23/OGMgheWptIbxW+S8EnuIqsgr3I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6535
X-Proofpoint-GUID: 9OBjNRMrv0Nrk0N8grLbICJBDWY-9smp
X-Proofpoint-ORIG-GUID: 9OBjNRMrv0Nrk0N8grLbICJBDWY-9smp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_15,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303010181
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
index 37500b645ec4..16832e79f6a8 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -493,6 +493,16 @@ static int rog_nkey_led_init(struct hid_device *hdev)
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
@@ -504,7 +514,7 @@ static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
 	led->brightness = brightness;
 	spin_unlock_irqrestore(&led->lock, flags);
 
-	schedule_work(&led->work);
+	asus_schedule_work(led);
 }
 
 static enum led_brightness asus_kbd_backlight_get(struct led_classdev *led_cdev)
@@ -528,9 +538,6 @@ static void asus_kbd_backlight_work(struct work_struct *work)
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

