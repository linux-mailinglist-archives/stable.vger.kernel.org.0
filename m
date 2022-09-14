Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68655B8798
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 13:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiINLxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 07:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbiINLxc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 07:53:32 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B415F7D1EE
        for <stable@vger.kernel.org>; Wed, 14 Sep 2022 04:53:29 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28EBgllW000941;
        Wed, 14 Sep 2022 04:52:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=Jd6mh85AasK7L+BgIizWebriB9km6JW3KaLbjGjNVws=;
 b=PZQRULRb6CIU/uWW8zweocKprludEo9sbBqF+y1YBd3W+++1Iy+NY1d2Nf4SXweCxkl0
 l1ENo6wZwqLniWAKZy0aPZMjn+9oTdbtTJR3Cf6LcYwnJrjQ/j8h7aPKHzqHy+0mT+h/
 do0ap9WbtNagB3crrdb//PcMdOsE0D4M3GdIu3OsW1tnYd7BS8vHAzj2P6F/Y/t1k1zA
 Sb6uWSqNa27Ag27k5yaiNT9zkHv0u7iqsj7hQRRivrBceGJzhCG19U0WWlXdDv9vZbSj
 5DMAGXpiO8P2mBehXU1N+hojjUS9E/IwRZxhAFXVq/KdyRYf2wrg7zXUA/ai066vu8aV Jg== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3jk4sh0ery-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Sep 2022 04:52:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QmG9pPjnhjhbvB3Agu0R/dCeIacYiY57MHkN6DNC8vNOtD+NVsp54bAl/+rleMh7K0uws4RyGg7yC/98lmPse+7eJfHHUdKEh5mKt6Sx56mPDRFEHNPvqBj8DTs2so31bNcHd/h+nRsN5opi2r/4dO47svAoZYTHbBAkzLkWjL6A3IM5zCyNFCf37AQd150bevj8cPnL0PneNifSZk+ezTocULpigAg+Wqd8CP7WQbge7nlt50RvDgir5YDK3JsY32L21MSqdvYQSf5OH5HAfh+jJVoTAXocFjh2ByBMMSCc76dnd/f0d6mhZMtePAiXmJo265tfaKQov1YjZZUy6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jd6mh85AasK7L+BgIizWebriB9km6JW3KaLbjGjNVws=;
 b=fSeHKu9wof2F1R/QKof4Q14UYD90Va5bPGWwrs3wHLw06S/jt9aSm3eBHpAi7XR9ogEWjGEAjkQLSY3XYnijmIJZDmIARgZgjtOPEcJcDElDvIu+Yujjgh0BMliIpQ0aA66kCOwOnR16FHZNzNAt+2LKrwshJYAmxxC1bl50NcoAdVVa/OE4QudCN0uat1vhP7dmAF8697/JHPZEw4d0KXE871zMU9md5kYIHlQUO++P6pUkAdDdvLUxuY101vcbMm2jPzTco619BjR8IASPY/zzlR0HIO1zrbB/lgXn7avs1ry9+oHNfvJJNaOasu9PQhAY+8x5SHFqP45I2F64lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MN2PR11MB4711.namprd11.prod.outlook.com (2603:10b6:208:24e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.20; Wed, 14 Sep
 2022 11:52:55 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::b4a9:c48a:51c2:d3fd%5]) with mapi id 15.20.5612.022; Wed, 14 Sep 2022
 11:52:55 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     paul.gortmaker@windriver.com, gregkh@linuxfoundation.org,
        peterz@infradead.org, bp@suse.de, jpoimboe@kernel.org,
        cascardo@canonical.com, Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 1/3] Revert "x86/ftrace: Use alternative RET encoding"
Date:   Wed, 14 Sep 2022 14:52:36 +0300
Message-Id: <20220914115238.882630-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0801CA0083.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::27) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5327:EE_|MN2PR11MB4711:EE_
X-MS-Office365-Filtering-Correlation-Id: 399b097b-18ed-44d4-13b4-08da9647a938
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: c33Jy+NfA3rPeQGSV8WLIAbxGigNlm3Kn1PSKbTvv0k6dqk/8NvihtbE9DlqpSIfZq+5FfJzPlr7umRaPJ+DYGPcHxaR7W+dasJ49pbmjHn8NrFo6bI21RvpXB3y0MqCLI12xQlra9TnATVsPAko6wn6SvTPsP88IJ6LMuBN5LW9W4TWe+WRPMDZe0u7gPZ3SOdO6IeHnDdG9ptTpcq0RGo2EOUEoWHb7SGALsXHnqSGPHMHJm8DPg6R1/2Tum9tM+vO7TwXQc3h6aSiIEsK9dGqv9+TmJlHq0W5BtmFyk1UvHj5ONlzyl3d+dBSpI3/ArehA0KC1OA1cOYoIoiBUjKYux/DAMcf2GC41OZt48P364uUOfsh2VgnWdJwfB0uiaZNQy3PiOOkqNPpOI3uBXKvbfEP+/vqT+a0WcWQ/og5FyWdrVGZpkVDNoyGhYdINXY7TALUk8km4Ztg9LBtkf/ZvUm5NjvcWdwr6v+olUQ7e0QWc7161FMY1gZztlnG0+OSlyQATXafubaL3RqGRhwtp1h08wL+jJAlx2KVzk6mWx4lWQ8u9nGMeEa+6WJ3XyLihbb4qLtguhgo6M1g7tle4py5xKttA0dKP9q2VuiQW+UZbZlEGWuz+sR3MhBmaOk+cYGzZAMYLk89qUiaDUW+R/95kiwczpVsKHVv1kbJHPdnB6wj/f321c9d1v9sMX9HRnDr+WqcbO5FMnH0ONR8XKYiqgFw9VKhlKOSFMrGxNvV2KGuaDbm9Akq0aKwpW35a/BtREdPJdiYFheW/vt0hFgXldN498PgqvDsLjk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(39850400004)(376002)(366004)(451199015)(66476007)(86362001)(38100700002)(2906002)(8676002)(2616005)(83380400001)(4326008)(966005)(6916009)(26005)(478600001)(6506007)(186003)(8936002)(6512007)(107886003)(52116002)(36756003)(44832011)(38350700002)(66556008)(316002)(6486002)(6666004)(41300700001)(66946007)(5660300002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ea2WTr2Sl2X1T0qbUpjmx5WGDgQKQoGUwDkr+Yqqf7M0CEdz8mH0xgwCJ3I0?=
 =?us-ascii?Q?vs9jXADlKlly3L95T4N/POHoJhSZNwVnu2iP3ga5/Vzy21yzGa+geiJjyWcx?=
 =?us-ascii?Q?wQjkIbYDlOWTdIUop80IG7lWu1J90wXfOoBl3ZcCHXgQDKo5u7e4POHvy4c6?=
 =?us-ascii?Q?qL0vg3x1NIrSgNl2LN2m1hnIM6nHko+lAyy4ym9zu9y9xP+SGSxayHXniIB1?=
 =?us-ascii?Q?lip/m+7Xx870NiD1zTB7iCHfekoHpz8Qp8E7gk0yIItEshHeUtAKdbzcJAge?=
 =?us-ascii?Q?OQ3Dc6NEhYyfSpiERjFpVRoyEx/WJUBSn6uVO+qsc1u/cOGUrcIafEQhLR1S?=
 =?us-ascii?Q?c1ZuTRiy3Xrj/dxt6bNsMKo2hVxRxC7yuAuiQhqqFageHTfbTRtzUJ3X7+lV?=
 =?us-ascii?Q?7S2SdpSuNsjNA0mc8M+dPMdMMY73m1JbvY/YzCR2CmaoHUxtELrvKJvF8AUW?=
 =?us-ascii?Q?8yK5sblc65yzZbVRXA94Q+uDm+t1QEBRYibM4z8AS/GAHBvE/sex7UElR28J?=
 =?us-ascii?Q?aOyFyVVO30vegsjdQxTKUx4oj/xvuNEG1j7kxNyp7shPnky4vjqrFcaA43C1?=
 =?us-ascii?Q?7ZkL/+SaPAdz+/jr3KfIlyAXpdaZ2xEC+OS0lBlDv9vYdMIH/C+J+HFLtxSn?=
 =?us-ascii?Q?lEPlzWvK2bGBFoM9HDrc5tnyKCNK+w+/Bg9wHHSXaPbmYSdp4GixDP+ILmDI?=
 =?us-ascii?Q?hYhwDl53ao1LUHFquRhqKXQkSHvzLl4qoI2rUoiedAp5UpmKYQrDKJEigyz+?=
 =?us-ascii?Q?uc5z4NlXirBq0EcZ8eBcxCorJQUOgWL5g6v8Kwp8OJumF/W8M1A7hfVtnBuU?=
 =?us-ascii?Q?KtyKg6CicQIOZNWAXWeh3zPEluYm1q73MCKTDbw9UsprbUIuX8TLION4sfzj?=
 =?us-ascii?Q?zxzSFvrkz+VwBBx0VIZeWF+1k6jEUPbC+M8UJi8eC7z55e9IjilrQmzqWoYU?=
 =?us-ascii?Q?g9pqsrqK1NYipszssYPMqTKwTTiebFxQWK7YTbMP2S+2UFGdOmo3wQeiD7ho?=
 =?us-ascii?Q?uHcwx+QfwKa//XTeY1kP+iN1B3vFiRACph8S3aqv9ynTNCKv3zpAv7o2GX39?=
 =?us-ascii?Q?NDc6tHhrnGLrzFUVBXdP1cDWMz6DWGzIhRrTv1f049svM7P/NIFlNTRx8vsl?=
 =?us-ascii?Q?xXEsepwNcGWqq7xT5/vHcmxyzxtt3r0SEDVihveiLs3SRPfa9WlW6cgm3Tp7?=
 =?us-ascii?Q?v3csJWQ3xWEjlyF0lP5ml9VH1kWTqX0VjZqB/4jMi8+2DeZTHGalwEl1cuWv?=
 =?us-ascii?Q?dxoINSwfOTOWyZv88BZu/yg4pcKYYnAytNywDKyhgI5VMSmlzMBcKqQORoAW?=
 =?us-ascii?Q?/qo4vJoOB2NMllv9Ckhsr85fn9JmEoddpd5ebFG03XLBRXF6fPhnVIgAyR3P?=
 =?us-ascii?Q?k4BCTyLOPvROImSO2kCsJOLgo/AHkL/ANMWVuvZwoWuJdXFzcL42LC4YJ2u0?=
 =?us-ascii?Q?ebzF+ierDGe87esBAVieoC0GlO07nIMu0+Wj7rvUGsuTt4+fzrbLhER5dBv0?=
 =?us-ascii?Q?4v4PHHi+i3GC1s0ZxSTKUJNjCBjuJ6Lj3SDSIPt6OCIZt09Y0kPVk3oS60/0?=
 =?us-ascii?Q?05xjNpToMXvvZ2znB2nGU1jXgOaKufq15dPm+wyDEihbVy30jzvcoVxc13X3?=
 =?us-ascii?Q?pQ=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 399b097b-18ed-44d4-13b4-08da9647a938
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2022 11:52:55.4245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G0Mv7eDlqI4N4wuRgUzBfScSYEne0Cikymjx7zEDOBvgoFSxrWGjxSB0TGzb6arOTWawPAH+QfvpCbi8+Rmusvnk1NkdoYDBUpg1am55iQE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4711
X-Proofpoint-ORIG-GUID: Ra7eIa18-AULjvnwUG166WyNy8v4aVeK
X-Proofpoint-GUID: Ra7eIa18-AULjvnwUG166WyNy8v4aVeK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-14_05,2022-09-14_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=635 suspectscore=0 priorityscore=1501 bulkscore=0 phishscore=0
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 impostorscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209140058
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

This reverts commit 00b136bb6254e0abf6aaafe62c4da5f6c4fea4cb.

This temporarily reverts the backport of upstream commit
1f001e9da6bbf482311e45e48f53c2bd2179e59c. It was not correct to copy the
ftrace stub as it would contain a relative jump to the return thunk which
would not apply to the context where it was being copied to, leading to
ftrace support to be broken.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
This series fixes the CONFIG_KPROBES_SANITY_TEST=y boot panic reported here:
https://lore.kernel.org/stable/20220805200438.GC42579@windriver.com/

The fixes were backported from v5.15.62. Minor contextual adjustments were made
in arch/x86/kernel/ftrace_64.S for the backport of
e52fc2cf3f66 ("x86/ibt,ftrace: Make function-graph play nice").

 arch/x86/kernel/ftrace.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 9a8633a6506c..449e31a2f124 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -309,7 +309,7 @@ union ftrace_op_code_union {
 	} __attribute__((packed));
 };
 
-#define RET_SIZE		(IS_ENABLED(CONFIG_RETPOLINE) ? 5 : 1 + IS_ENABLED(CONFIG_SLS))
+#define RET_SIZE		1 + IS_ENABLED(CONFIG_SLS)
 
 static unsigned long
 create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
@@ -368,10 +368,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 
 	/* The trampoline ends with ret(q) */
 	retq = (unsigned long)ftrace_stub;
-	if (cpu_feature_enabled(X86_FEATURE_RETHUNK))
-		memcpy(ip, text_gen_insn(JMP32_INSN_OPCODE, ip, &__x86_return_thunk), JMP32_INSN_SIZE);
-	else
-		ret = copy_from_kernel_nofault(ip, (void *)retq, RET_SIZE);
+	ret = copy_from_kernel_nofault(ip, (void *)retq, RET_SIZE);
 	if (WARN_ON(ret < 0))
 		goto fail;
 
-- 
2.37.3

