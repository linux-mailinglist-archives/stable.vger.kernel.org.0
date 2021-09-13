Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456FF40977A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 17:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbhIMPhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 11:37:36 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:63766 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241401AbhIMPh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 11:37:29 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DFWc6Q015211;
        Mon, 13 Sep 2021 08:36:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=syNRd9duDpPeKklJdbnxwr+32+jRVPBqI+cME300f6w=;
 b=UARm6ea2u7i7G+46sy1ckxv6Zdqd8FV6GevVB2RpSgn6tf4TNLdyr/YUJZ2CoGIUyWTg
 DiuK6SH7v709sBqlhLqB6Dr5+NYKkZHfm+CF8T+oxmGorSurwwu1CU5Nq877P0w0uKnc
 BlKNlwAaQubLQpn4tw5LRiwGd0E+w9It+t+W7ITar+lmyxtEkjJA6w0WoBXro0sc5WVH
 d0yn7AKPFOW7cfLGTAGWL+LsFq1i4oR9YHwRyjgQ5Bc3t6XRxfIdtO89ErWncbnbviTv
 Kh3DJahcTMRjcp909aCMBPPBXv5s6CWGWcEInC4KI+rA913vZkYTZ8oh3Cj8t7//186C Yg== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by mx0a-0064b401.pphosted.com with ESMTP id 3b1kfn0pm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 13 Sep 2021 08:36:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2xJrElYesSfZJyc8tnjfEk4wzVGT7PkAdqSi6f6jONRaAynXsa48Yba8oKN8g7JUziXUWnZkChr/tNS0+jlwAqc231Ee9IrtDcOsvJFaLzfbjXE/GbRGGvovW74HGYnoPff620S0UHW4JbRHX0z3aMHySHl0zhX6emClodz0IpIPfIsP8FHwXM0iMB+rRUFvkRoq6ZE3O6bQepUVeaM+zcmWubimkar5YIm/PfHwj88llBNEDPwEyfVAEDb7CBnN3FWxIPgmT402OBeZkgxhK/fLSkMYBCRcuG+ohSD4ZOkLQv1t88/4WWEGP43tcTgd+2nAc3Qfiiuxp9iehPcEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=syNRd9duDpPeKklJdbnxwr+32+jRVPBqI+cME300f6w=;
 b=nct2RnkL7y61DDR7r4uWMlPeorIIHpbel33JpjRd8Bljg9Uc4CFLde9r4ZEA5/mg7MtsDRfqexLidbEx2a7CnTlt3PWjgQbkYnEDUAox4LfcFPVC4YnUJS2avsLqsJEAIny/dvDCqB03YGglPDzsoHMVFkYSyhOZPjn6EmTXSW0Yc6PYg4PnqVRCKjVzbJkZC4OwtNbqCQotMilEQ5CVNbHyo5uUh6n6SXH/TZ8pI3Z9fZ8KWDmOz7qxwua3PD4PA/1h30++Mkp/YYah3qBceoCOi6akomPtXP2jFMrzGmBtBQs4Njvjj2zDmwh6iS68bwqz75DcVw3mNyYwJM1jMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM4PR11MB5549.namprd11.prod.outlook.com (2603:10b6:5:388::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Mon, 13 Sep
 2021 15:36:01 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::952a:bdc6:20c3:94cb%7]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 15:36:01 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 4.19 04/13] bpf: Reject indirect var_off stack access in raw mode
Date:   Mon, 13 Sep 2021 18:35:28 +0300
Message-Id: <20210913153537.2162465-5-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
References: <20210913153537.2162465-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:28::24) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR10CA0095.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:803:28::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 15:36:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33722b57-f84f-4b80-695b-08d976cc3077
X-MS-TrafficTypeDiagnostic: DM4PR11MB5549:
X-Microsoft-Antispam-PRVS: <DM4PR11MB554925A22B86E4D98C791D7CFED99@DM4PR11MB5549.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:480;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: er7tCke17f6D8EiGJdny3o5tlf3m8P8kA58aKvuJ3LhpqzO+pnJ0aTwjn6u4NiIzOri3vLd422Sl2XW7s+7i+6Kj0apGs2OwplgEusgr2gQZjdLhf/jrIpUfvLDGBxY9c5zFqF2BcWaAP+aKIcbSN1Xg4hj0id7t6s6rpj7pfwOkXx83GbJQKXxECdA2IkmEHzbu8s8+cdwYUH3Sf7+xX/w54CnfUZTd2vp/nd30+lemo0c5pLMNw4l52twGFhT1ziHZ8JEGxNg9cJOJ9putO+7YxvWHtYAxh8R+Yk8Fn4qC5aGpmE+y+NVTouvBUtVXaX0fjoDq1T9OLpMTEGwWJPAjl9XMwyGCaPwBrHsxVUz1nqL+/UuA5hfKrXfIhfc8akfOqXBK6zYWuT6RzUR8AtnaXivhqmsc1NMquergbfkYB9TOLpGmXb3gQlAyV64cNsZRmNzUvnpfkwQmIJfaeX4Q0oVTaEPK1kFPtzy+QygXfmuY2XP5ayglllpyYshp337FlcTcAfSOf0raWpG+xdbdg0h1U5Z89h7kq1aYc6KaFAdVayAW113mLk+G6Dg1dNFa3QBgOOZyjrSSwN5qA/EdquGcUiBrSRIK0ygMJRr0ofcJYeAfoXWwUbegHR9BRD8oyjnJF+jF4r/eoa+rcGlzWQd8WVaioiwu24OqRYf3+uTV8qFSmysnzomm+ISOC7mQR8ZIrlMVKl4Gfs17aA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(39850400004)(136003)(376002)(478600001)(26005)(83380400001)(186003)(38350700002)(2616005)(8936002)(38100700002)(44832011)(52116002)(8676002)(6916009)(5660300002)(6506007)(956004)(86362001)(316002)(36756003)(2906002)(4326008)(1076003)(66946007)(6666004)(66476007)(66556008)(6512007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EPQHizXPfO+PLp5jdsptm1q38PX5QpwzCDdklt+Oz6m3V6z9nxknUiIhZbbS?=
 =?us-ascii?Q?E5XZhBn4aUhEcTLWx4lBwYWKWxrfKxtLuseudKFZzrqS1GWMCW1t+8MHZXhx?=
 =?us-ascii?Q?SJAB+SdD6KCbSC8AQ7TDphJlp+f2iVl87VL2RU6pvyvLAUpIFRBBCcxa8c/8?=
 =?us-ascii?Q?tL1CZb0RpdXke7q4mBboQDytkFgt9E1PIKb4a/B2FnYSdsvuMErD8GtvIv1W?=
 =?us-ascii?Q?X5noyNDVz4TgE8GUgV5pBxaHKOzJa505dmwcY2VPO70hVuQbFeQvKU5AArOZ?=
 =?us-ascii?Q?J7/B2dz8M/X2eVhzAkxm/RuLr4mVg51lPLwUV6/vtiXZT8EJMmpMyiKNqPLi?=
 =?us-ascii?Q?EnuJPZOhMKXrEWpvwfLuZAHoddB4jQCqjnpNo3qBt3etIgzzIC/5FBIgM8+x?=
 =?us-ascii?Q?CijKKVLyMLwK4zRzgDeMKF5z5jdcNfykxynPe+JxmBNwczLp+s/uJbAx1Z4S?=
 =?us-ascii?Q?MWnpb8OfgWN158Zgsl+5AxTXT6ZpLFyBIp5iY4cxnQNMWtEA0/9bguPaYQoJ?=
 =?us-ascii?Q?rJ3KqsUJ0FaFK5zcY4uwRuFydaZ5wbuT0oC+7QyDoph2vOaUlHu7nWjM1Kuu?=
 =?us-ascii?Q?8iYRo9eYf9MfrHwg/dbOdY2D+xN5lkgXUq7Y/h1w+AQ3VKZjdZCMSGmAtYGC?=
 =?us-ascii?Q?Jyx64n7h1KkuTBBwHKswHcG0EVDVDSFTSPe9m4eTvGrBHRAp7XnYTojC/HLh?=
 =?us-ascii?Q?3K8CXZQcmUFwhnCmRP7++W3DHIUQ1hUqyGDqyRdqTpe3VTmP2HMQCFSWn9Um?=
 =?us-ascii?Q?jiZtPAZEjPjjwzGhDBN9B/ogjeN8MpvdkAZp9mq3VCc36M9xmkRXQgUQz4Mh?=
 =?us-ascii?Q?KBJLGW2So1Wkdpg+XL7i/3/T7S34vXihCsgeegfHc1LyzcgSnoXA+13Fh4i+?=
 =?us-ascii?Q?GtrPFybOa0EAWvlWaOu8xkkjZUDxY+/wTyxKwPjwOa1CO02x7zjgYB5NlIQe?=
 =?us-ascii?Q?KBSH5hYaGKVc52jtx1EsJ9owis8BXdIxgMntyi9Vceek5sf/74IhtdNtaVVT?=
 =?us-ascii?Q?xCuaVru1HBfrBiWoAXBV+PxkXO7OrPh5ts4M30sQ5Ul+OjUxZLXRZ0Hwh+8S?=
 =?us-ascii?Q?ZkWpjph9yGD13REAczJZihSCbRVWw/703MhqNeB1cjQoEOVcax3uW85NzN1W?=
 =?us-ascii?Q?wdghj+VVdV6tuXM+dvvAXQLb1G4ynBNUR4GatdoUVmEiY2zolVxvJJYOYiIy?=
 =?us-ascii?Q?UI9L854MgMkncPwiZveIDCx9eQbUZv5DkJo0sTf7DAXiVa/lK2DEkqu5AOCc?=
 =?us-ascii?Q?GYejfx/UytCM0hNZURdLp4yBBsmH1K9ag1vjmw+PpjLjcabWz+RnOkW2I5ed?=
 =?us-ascii?Q?bY5k9jIH+BhTsSwoIF7dZeiG?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33722b57-f84f-4b80-695b-08d976cc3077
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 15:36:00.9508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NOPECfbi+Tw1+E33GIawttz/3XNiVew7QrroodRnT9CTtmQzHxzaLun+o3pFUPxAZEvlSdtYwBLzyuMt+qkyiGJQMLz9rRJ3I3nyZjrz9oM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5549
X-Proofpoint-ORIG-GUID: Wj4NHe_pVUp7AMOvdCUGgmZ9BpvFVBqL
X-Proofpoint-GUID: Wj4NHe_pVUp7AMOvdCUGgmZ9BpvFVBqL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-13_07,2021-09-09_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 clxscore=1015 phishscore=0 suspectscore=0
 adultscore=0 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109130103
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrey Ignatov <rdna@fb.com>

commit f2bcd05ec7b839ff826d2008506ad2d2dff46a59 upstream.

It's hard to guarantee that whole memory is marked as initialized on
helper return if uninitialized stack is accessed with variable offset
since specific bounds are unknown to verifier. This may cause
uninitialized stack leaking.

Reject such an access in check_stack_boundary to prevent possible
leaking.

There are no known use-cases for indirect uninitialized stack access
with variable offset so it shouldn't break anything.

Fixes: 2011fccfb61b ("bpf: Support variable offset stack access from helpers")
Reported-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/bpf/verifier.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 47395fa40219..a5360b603e4c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1811,6 +1811,15 @@ static int check_stack_boundary(struct bpf_verifier_env *env, int regno,
 		if (err)
 			return err;
 	} else {
+		/* Only initialized buffer on stack is allowed to be accessed
+		 * with variable offset. With uninitialized buffer it's hard to
+		 * guarantee that whole memory is marked as initialized on
+		 * helper return since specific bounds are unknown what may
+		 * cause uninitialized stack leaking.
+		 */
+		if (meta && meta->raw_mode)
+			meta = NULL;
+
 		min_off = reg->smin_value + reg->off;
 		max_off = reg->umax_value + reg->off;
 		err = __check_stack_boundary(env, regno, min_off, access_size,
-- 
2.25.1

