Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDA96A76FF
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 23:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjCAWqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 17:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjCAWqQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 17:46:16 -0500
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB8119F13
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 14:46:14 -0800 (PST)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321LCjcn017728;
        Wed, 1 Mar 2023 14:46:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=PPS06212021;
 bh=9VX2WFOoLQ168HO+kljjhQUYKT23chwkisu4Gnc9sLY=;
 b=qRZZE/r8RCAicX0wpFrX5mnuup1Qo4x9ZDu7JS3g0XEvWcwa57clKSP5I5E4J5lbipzq
 RFHvn81AEy2jrZpq411o4UJLy5G9/GckqwiDytHKE4l/3fP27GfJJ/xxzGOvcQ8RCSWO
 qSNlZtrW/Q5Zai6/GyC3FWZQkaIKmMfkENOmM2qQrhIdBv/V3WsGOSVnkQzWwW5jQSdw
 EcdrgED4kZh0/9MjH+quHvystHdvgCdFE5097dVT2HQYpnfrtzyGmhxJQGXwnJLZ8Cte
 7ChFYbEDc6hqNA9PLAHGI03kXYChlIZuXEEl0XEaLuGvyFWCQwC9IAEqPvvyAL26exRE xg== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3nyeg8cqe9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Mar 2023 14:46:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FknJOuYgOh5cSqUovWQ8X7As7YUAjlG9r6O6onDFwZWIcqUnrlSxzwq5vLqW75x1lL3xvPwrk0VAJDrWwe66MJWdgxyorLLOItN+WX1umuIbml1ocMt6Jqikp7u8nbde6/jgc1CYQII6K7Psuv0F+3fpFgT8eH3aQpVtmPaHpv7jDxvAU8eTpx8vHCAwi50sBwamKfC10fG3SK1CT8X9ZeiK/J2JqjSRpyf18MB4lYZUSJ1DwrhNkT1kyRtYPiKgo1WYdBz6U+8E9uwOcVXEAiH9gSCXRLj3i2MnbmtX7VPUT+EInf5EHMMieuida3DMSfiYuSSFnlofCI8+lfT2hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9VX2WFOoLQ168HO+kljjhQUYKT23chwkisu4Gnc9sLY=;
 b=jSuwUX19wN1PsJ5CSJe3L2IHhbuzm5hlK/B4u8gK5VJ3QjOImKRiSJD1f8z6GXm6fn3X4AHbtjt6Z/WRmC3TG7W69A012pCtMv0vdcmFUA665Sn7miuQYDJrV2hc39dAa31IRNB8ty1jAvc0A9xbIDQUD0jEeelDR/HpLRhbxrLwkQmgIvAO1pQIJMRsCdDDOkhLlfqbae8djP1KZNxlc9IsiiwN6rt9TMvfVVYMiC1u66PQq/IOoU2ouHmQeIql0HZf+OTZQZAONbqhd3jYVRBk8QbJTdMsNthIMOD3EdWGRZTedVVTKhd2M9dyuAvV2ae/9hcAvR4rj0xRVEtRSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by DS0PR11MB7285.namprd11.prod.outlook.com (2603:10b6:8:13d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.26; Wed, 1 Mar
 2023 22:45:58 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::fc79:efda:317e:62a3%9]) with mapi id 15.20.6134.030; Wed, 1 Mar 2023
 22:45:58 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     "Luke D. Jones" <luke@ljones.dev>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.10 1/3] HID: asus: Remove check for same LED brightness on set
Date:   Thu,  2 Mar 2023 00:46:04 +0200
Message-Id: <20230301224606.29116-1-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: VI1PR02CA0056.eurprd02.prod.outlook.com
 (2603:10a6:802:14::27) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4989:EE_|DS0PR11MB7285:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f24ddcc-7512-4331-1b73-08db1aa6b981
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JD9U8cPVCiyiQyK5Wi9/0rlJfyH62x/RhdkRoSCyl+0e5aSJtv2q/5JruaQcT8tTPT7Doqf8AbjjEgGzBp/lq1xEq5uQ23YfYCthn1woI0tCGzCJnaJQEu9EsffdDv2YqvTsnaTTjmfCb6Yrpkm4EmFk4HSKZkKaFrdoTnBMS15j14VNDLsEmNmgVKc0pqbs0/nBxMJZYiDw39ARbbWgZZ7tZbrf4dvdrAPFupyDwEmk3MgZRaNriWDJzXb4yg/EuGqIc4syuyYuBZxaLycWpm0UI9SFs5QDA8sZaxGNsao60DS3WkYMAo8lAefX5QqIi3/e7T7jiRfTahyZUWf5rww+m7EAnCNKYlPMHfdnoQEgz7MZcHdL7P+EPxjvyaEFL4O0pUdQvKre0YWWrdUFUXo4j3fRcuY7A75IIdsIPBHhG0oRCs9sUjixcgG0YpFPuVwfY6u/vIxNw/JIScgD5HDqoiJ3vQXLNcxVpgUgAM8gVS/RavtJW5XLjyz+fm/3MMZ2FlWKc8BGDcDHUTQHuONchzMddka0oNAeEfRM10BQstBG9g4aj9/ysnWNyTVWPtRaL/lZRhK2h8YPNq40GplDfALLHWIWrMk1WodgazF6emhLwDP2S9tztIV7SCFOlA5ZP/JBIhnMP7nVdGxn1KxMKrvPIqesoc5kHyygoukgP255B7RIOLa50cTBhZSikjBWA1BX9pFi3q/O50FoLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(39850400004)(396003)(136003)(376002)(451199018)(26005)(54906003)(36756003)(83380400001)(316002)(86362001)(6486002)(2906002)(4326008)(44832011)(8676002)(6512007)(186003)(52116002)(107886003)(8936002)(66946007)(41300700001)(6916009)(66476007)(66556008)(5660300002)(6506007)(6666004)(478600001)(2616005)(1076003)(38350700002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h4HHaA+739BpI99iG8uRbKMnqvyGKrz287hYYSFhMLNzB9ynvbhjGT+Xtb0i?=
 =?us-ascii?Q?CrzjPVKHIae4XV8j81saCLtx0Z+JgWC3CtHOwXDJoletSIVB30DRhWoSUbih?=
 =?us-ascii?Q?iljVNLTBatxNjJksgpGXF7Ax8/juY0W0eaz8CYZAdYY7lhzsRurRqIcFCaaB?=
 =?us-ascii?Q?9/P//tWf76yNubeYUc1+LvZpwFvfUox6SPCoKZGtBmY/2qemM+EpyAqajFjb?=
 =?us-ascii?Q?0qTr7QRutEltgoMMniahrAQwTqaOX683lMkcTsEiuH8olLxvlVGTtaU7vddT?=
 =?us-ascii?Q?yUKVkzkL/oCd/eEOGr204j2B5PrsgY9cVSgY31j7c7ALC7GausxeVV2rGJ9r?=
 =?us-ascii?Q?URvFcw/12o7NvD2dk+bQG2i3Sbrq4X3ZOixQXDvFr5UBZCGP/l5LMwZvKoNW?=
 =?us-ascii?Q?NMQtTB0fvWmCz4/2kKIREX+KB+hVGx9pFD0ykqivZw4IdLwHLqRwImDtkVwE?=
 =?us-ascii?Q?6pM1gZIijUt92EUXqoZNSa6xAXcBMWtv2X+mvmaldR6QN4z/WYgaIiVeGBbQ?=
 =?us-ascii?Q?VBNddsGeUEnZvkdR7l8gyaDJ/b7lBcKjC17W2RRLXluMcfjYAVi2yfbn+VoS?=
 =?us-ascii?Q?Ds1Dz2VWOYUTXepfamivPDkpIrYYoinzweGSfbLVKjyvDtRLl4BDEDWImJah?=
 =?us-ascii?Q?kq35P8HkjHyk2PKZ+frl3itsts97UPPY65g14ck4LBBOPkgfjLOYWnPOZBa2?=
 =?us-ascii?Q?V5sjgHe9Y9YRF0E4RPj1nPD0wWK3n8UCe9jlumVUtIM6uuMXIq+e2tmoW0R2?=
 =?us-ascii?Q?Y+3IKW+1fqgcy14lGdDBku4Ydxl1c0yYS7ygK3hjfATe86KXK8iC7wmdV+77?=
 =?us-ascii?Q?F0jS6j+vQwealFQNCGsm6UbiImBbgh2ce/p9PUugh7QhEnyJbvhqPT6QmEjC?=
 =?us-ascii?Q?II5NbJ3FrP6TVJsUggRSiuPYtu5iFZ25u7qled0nbacY5qg/MH0qnXH1xP5Y?=
 =?us-ascii?Q?4SasakUTCnBqu9FwlusfqI/jNDWgNNwhJApK64ipxq6grUH0FGmKZD4donaS?=
 =?us-ascii?Q?dn6sCXI7MMtsgo0CKHSY/LMj/xARJaHff6Km4STjon/UrvhE4hcxwPX8mF9V?=
 =?us-ascii?Q?NkWFoZlauMkz5wELehaVV6meSsG5w/VC4us3QuBUdIMFAriMzGncnF43foX3?=
 =?us-ascii?Q?wfOzzDK5KC2HMBhXhJHuOQjCmRFPyPlAgn9+NTiRXpb1Yt49G/LwwBy4Piff?=
 =?us-ascii?Q?NMaRq1IH/XYILjl5MdBrchTGdYZDU6wqolQkoPRfyYCxh2t9lIAHywisy0jQ?=
 =?us-ascii?Q?bwyBdKeTbAtL0noGQH4NczGR/eFbamXK6e/ZU5t2O9Rv9L3LgAbyX6o0UTL9?=
 =?us-ascii?Q?frU+jjqU9wQfVmwuX3X6izGxzsRfLe0zUMBBKCClNkaaakMWSM1V6XZNQrUb?=
 =?us-ascii?Q?rJfiOVFESnzSLOsKLSWRfd6RQMtxHMOdsSL1qs7BX7UoWSY2ohrlY7u8TVsT?=
 =?us-ascii?Q?K3mf8JpQDpqnCd+XVwQzKSQDMA5uTAdqhvEmGoMYlgYKT4FD2Dsx3dDFNRJn?=
 =?us-ascii?Q?wCuOR7pLdTjJfuOK5f5iRT6+n//xr7PL16+icZqKzRA41Nl6nJYNVk32Tjfs?=
 =?us-ascii?Q?+0472OPbUlTPQo239fURsOAfr3oWf36OKCFi9nNfkEg27lR9BhnNHeOvH65h?=
 =?us-ascii?Q?bbA/U3Lg0A0hxbsZCRkduZ8=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f24ddcc-7512-4331-1b73-08db1aa6b981
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2023 22:45:58.5477
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Fv8dto7nJQZCFdLNRyMJV1Lq2jhZhBJ/xoM84IFHm46mAQV9RqfoRnnwTwLeN0GovczjYisjMXJfm1r8BX4S5/vxI/3byOXWvKkWmXxeGw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7285
X-Proofpoint-GUID: S4Ub_tcVQf98mb-UVZmmDOKA5CL4PQr_
X-Proofpoint-ORIG-GUID: S4Ub_tcVQf98mb-UVZmmDOKA5CL4PQr_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_15,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 adultscore=0 mlxscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 clxscore=1011 malwarescore=0 mlxlogscore=932
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303010183
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
index f85c6e3309a0..9a6b63828634 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -402,9 +402,6 @@ static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
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

