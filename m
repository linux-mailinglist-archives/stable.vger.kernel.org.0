Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E30502E73
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 19:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343622AbiDORws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 13:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343707AbiDORwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 13:52:25 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F483506C0
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 10:49:55 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23FHmi5C009434
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 17:49:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=r59l6xMtmKc0sQnNX+Eacm3FpYJTT/wNXyCEk5kNOVc=;
 b=UZeSb6PsMTaF+jTHdWp3mYsrXhfeZuEWQQXwjAuGlSD+6XGqpGwEwFJDXUOXBVV57hCq
 +zq2yQ8FjDIzp5KJPWKr2qZfzSxCuiUT1SpsmLt7mTVwnkrKukX6XvKdO4bDNqWTQPct
 NxEOuLpPzIZPbKgLGAVb8VOLtdGLtlodTDTiosuMrqCuLSREKLz10suvvBFM7H3MFRto
 HxAlRLZPjmYJ0m0p1QcMKy2gkwNh3DFQIWsXCM0rB/4pkFOaENXZ22X6+0VPLFM3alnS
 MbCoqXljX6VGThvdeIiURLLcB9bLYmeJRe4bk7zLoH3XDIjAzXMSL9Zg7oTHb9XTy6aP 9A== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb66evw4d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 17:49:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l3wThVzx+eBC7hLsv+9dgUZlR3G0PkN4TAxa83L9wHkcWX7fyl6seBxsu0dl1MqdqvKPTjmsf0yOxruCxfOXRYS5dZ40cTlGn34hxe3KKoEk7CYk9z9A5xzY5bBA/mcdRSWnBofIF6jX8FPOxgQfxQs+cMYQua4YBSHwSCAM0oqzWuTgy1f4TTbhxIWx7LeifagwV6hl2vcCa+19a3sTkZpm50Ai9VwkvC1LyVc+sVTqG60pvxiKxhM2tHT1jYFBcPUQfrTzpQWfGOaPUgYZWqninM1T8lPxu6mjQLZy/HQHkVQWBvVhSvjNE0Muni4Fyjh9evwp0CQbi67bPFuxTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r59l6xMtmKc0sQnNX+Eacm3FpYJTT/wNXyCEk5kNOVc=;
 b=gEb9vVLZwM90iVagTBUGP0PsULkryuAW5/iMik2hJdNCrfL57Pwvvq+CUqDc1xfvCDqE/hy6coYWssgWJOvkFqejoRmbbLW7IifiMiVTxj6WFkrPzEaOqHM/oJOqrIvjxtlXRg2xbuZa+98Ox0Rf4bvUjDWRR6UWUOa2uzlgdp4nFBE5dDhhxHynfCEyigW5P6cphhXjm9IIOfLNxpZeMebh5R5NyJF8erZOsdMan6D48+NbK3qdVzLUS2/+J3JwcaGcC8lxZeX63lPLz4wDtZGTbyPYaGY1/uZ2uwYjg9ItC+s70fYvS0jX55k4G0PyPKRCfhLQl8ajUE8i6yYAqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BN6PR1101MB2290.namprd11.prod.outlook.com (2603:10b6:405:4e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 17:49:52 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 17:49:51 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10 2/8] ax25: fix reference count leaks of ax25_dev
Date:   Fri, 15 Apr 2022 20:49:27 +0300
Message-Id: <20220415174933.1076972-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415174933.1076972-1-ovidiu.panait@windriver.com>
References: <20220415174933.1076972-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0217.eurprd08.prod.outlook.com
 (2603:10a6:802:15::26) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d2a8c5d-1b29-42a1-b18b-08da1f0857b0
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2290:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1101MB229070B87B98F1730CF148D5FEEE9@BN6PR1101MB2290.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4YS6QwO59LlK6JuIY1ElAilFLBSlQwCbY/m6UcLiv2Nn083QaYwV33MZBQ5g+An9pVsRnzW03d4CBGx6oeBiRmdEurYiJ0j+enFi0b+yvbjYROHOKmHDppDwsq17K+iUoRj9RQbub5II4V6+fxqEwN06FfQ7YhBTJ+09mC87IQGdPsD+HKTNTVjIV2y8hyfzENKuMFL6dCc8nC1pSrCTlViQuEkKjWcX5SgRtyjr1QeggN6m1X8fwYieZhTZV8XejUWXV91iQjjkzYcPnqqvDXcCU7IsMUjyEBgRIuLGy/dv/mttDge659j4PI1ZGnYSwkhgFFhRJaKkicRKjsMbMdesXf5ancxaTaQqG4N3lrZgeW/MVDWrAnROkxNQauxSCwwHDiScHQ1xdCsEDFnnfx7Z+a665ryKwtRrtvfrPiWJ01lrDMJ7cOtGKUbsFvxz1zq6+8cHEDeKFuBeE+bMn7z0CulrR2X+vhfq+Byw6/sCzNM5RXcJRjg0xUirJXqHUYlu7w1bJBZz5L6naRz+dKLlFih7cj6qC54fQbdBxtYajGsryUYyiSVeKGu9rdwcQ2wZpH4GJmfqnwMsrFZfrMhSmKX8CoRF6fBcmnUisaWVVCj3qPIp/HNMuQ1/hxOptpgBJxffaHWJ9bI7Ca/6ZeR4RdaDN+xxFtT71joQo+qLZwi+2O5H4SN3vRSlQ8SFduDsHek/qqFfCuxyqYtPFgAq8Fscy+51Af4yqiUgtW9qCF/jnP5OdHXCSoGPt2G4uouMlwKnyBOpGf94kVHSQ1gjWtAWVHE2yXxo97G8Gw0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(38100700002)(6916009)(186003)(5660300002)(83380400001)(1076003)(26005)(66946007)(66556008)(8676002)(38350700002)(66476007)(6506007)(6666004)(52116002)(6512007)(508600001)(316002)(86362001)(2616005)(8936002)(44832011)(966005)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iZw8W8sf12N318GjPj5W6Pcae+rbUheFvOqCSYbG+D17nahfidaK4Dq0GxcI?=
 =?us-ascii?Q?R6nVpFSP1RA8w4JvGDWpLHjUgC+Iw7g/Dqy0YIUHppzLIqjUeMBkCoxWb5Ou?=
 =?us-ascii?Q?Fk0jC26yCD3pqeJpcCD4ZsgWnyHX7D1uuRJGKELW40k6mWct8leGimorAhFw?=
 =?us-ascii?Q?K6YnNg1Fxt/sZdVs8HstuN8nCzW3lS1eUxrMO/CdwILINOo8YU2yrNuBXb0f?=
 =?us-ascii?Q?1CrZ9LyYAM+PbxyoazsCPb7Ynr10KaQLqvHyQFyHNw8jJwB8u+b0kpostlzL?=
 =?us-ascii?Q?cUQ3MlijCrPgOHarzf1tQG4EuqQWg8gDU14JvU+77cxYK2h79VO56cnQTXqZ?=
 =?us-ascii?Q?+HPhqA2VIx14W7N66f9BbqSWNOdJF4gjVw+N5W7fRJmkDTEiHtnIN6b/Y/8x?=
 =?us-ascii?Q?JbzyWKc/2Ip9qfjqG5bEuzTJxFltXgyOl4RpCba/tFHsBAg+GdZM8l87rLCO?=
 =?us-ascii?Q?AJ1MaCb107dQjgnYOPB++G/Zpsqpi82h3TyUHZ4k6uCzUaZVmw3Vm/emJ5js?=
 =?us-ascii?Q?e5eHAiHgjNooIcDin1AQfVGu7EZdGfyogVPtPcZmS5an8rrG5BckcADVwgbU?=
 =?us-ascii?Q?IhskH522xgBisUxDjwtg3QvlvucFMfUDNhxImm1cq291cb3zlt0nMKl/WmUg?=
 =?us-ascii?Q?J9jE2OV0pYtynVOHeqAtQcvBsAH5dyq+vY7m2w2MX5YU8uOiZZpV3JIZyQYi?=
 =?us-ascii?Q?8LjtGlkyduUtOkvRFEfREx8V4oAjSt6Hyu9pg5t1epvFFpNJzSPYNzjX+f/F?=
 =?us-ascii?Q?t8f/Z5dHe7qdg46yaj8L+unoDRIFH02kjJOUSGSCGFEvnGGSS6NW0hiMWoM0?=
 =?us-ascii?Q?GjYwR92WTQwEmxIb0MUYASSZgN6DSgp7Lq5ujjAAS04K4jEHhRBxBvH9StGz?=
 =?us-ascii?Q?VSp2w5xNAuopY2w6nQq4LOYwS2kHB1AxNqjRMLFWW+pHuobHvXAONLpH6mJ1?=
 =?us-ascii?Q?4l1UTpGqjc9AUznzBmACIpJAhDeINh/VfS+SVChhkNlsKRyqQYzJuA49Jxmr?=
 =?us-ascii?Q?h/NK5zY3UvaIjJK5yLaCWcasaukXpTsBNPcVmjN9/qxa2aZMgN77Tm9pOVy5?=
 =?us-ascii?Q?hh2SoHqWxe94RnANFRiSSx/PuQdJsXmE1VDjgPDmk3XYzHrI/qYiIYSq/ll6?=
 =?us-ascii?Q?DfgXjQafJFfxCLTYzWY2kBTmN7/X4KimRx15rQF0bmk9ZM71/7/USwaVRbWd?=
 =?us-ascii?Q?FcfTjGWxe/ekBQyOkwSdADbDIoNKojbSvp35Q5Ts+f3FlgQXfSjzkHgFB2is?=
 =?us-ascii?Q?lWSch4IyauIBDmZJRMlg/R7Rk18MxaitW5ORY7nfhdsLvFmjlGLFZCtZaC3l?=
 =?us-ascii?Q?JWyvPiJ4/PjfMxUw3qOjakMR5BaP4tVPc2OPG9PaABTGHevXlup2+4I9G+V6?=
 =?us-ascii?Q?h1jyY1GZHABH+fn37J8lnT1baQNlKiGRnaMR7Mc4twizgUJ03JhDhWMTUSsy?=
 =?us-ascii?Q?PAltFGZ/b7kH/4W1Hnpl1z0ngcwEMne+2Phna7ieqKksqxCmpQvsbtNWPPsM?=
 =?us-ascii?Q?8trRmWWxMCH4zPcrzpLOEm2fGe/EJeo9NoZ9HIQkShWJPF5yIwaAcddpvIks?=
 =?us-ascii?Q?QV4O34lgrEHZaNhAGeGiSXAmfsJF+pchxsPPdltUKQJX1IfuTVjaU4bbUu1M?=
 =?us-ascii?Q?mz2Q9LV+5xjLwos9UU5ckTJms8D4WonLXoQ1IQi4DFLQfWiaOjP5UupgqdZ0?=
 =?us-ascii?Q?vAPHws19X+/eug3tlUMwX/nVjnnl6ZO/RkNeVHcXPGXSrVy1ckCkBBp7elUL?=
 =?us-ascii?Q?LvwVfkoYrTft62BRnwYAcCYS0RG8Q54=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d2a8c5d-1b29-42a1-b18b-08da1f0857b0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 17:49:51.9305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DQZ+TkGeqYA74QYpC83bpmVAGfCrW4kxcmOahCzMdZwVm4PFFOdnRty8iC+kPz99AlCYfQ5SvH2BoW8z5XpzkyabzOh3Av3hW1XXCbzBGFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2290
X-Proofpoint-GUID: _4RoYBsDp-Y1v4NQx-JD_MG9PwwMhxEc
X-Proofpoint-ORIG-GUID: _4RoYBsDp-Y1v4NQx-JD_MG9PwwMhxEc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_06,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 suspectscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=999 impostorscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204150100
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit 87563a043cef044fed5db7967a75741cc16ad2b1 upstream.

The previous commit d01ffb9eee4a ("ax25: add refcount in ax25_dev
to avoid UAF bugs") introduces refcount into ax25_dev, but there
are reference leak paths in ax25_ctl_ioctl(), ax25_fwd_ioctl(),
ax25_rt_add(), ax25_rt_del() and ax25_rt_opt().

This patch uses ax25_dev_put() and adjusts the position of
ax25_addr_ax25dev() to fix reference cout leaks of ax25_dev.

Fixes: d01ffb9eee4a ("ax25: add refcount in ax25_dev to avoid UAF bugs")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20220203150811.42256-1-duoming@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[OP: backport to 5.10: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/net/ax25.h    |  8 +++++---
 net/ax25/af_ax25.c    | 12 ++++++++----
 net/ax25/ax25_dev.c   | 24 +++++++++++++++++-------
 net/ax25/ax25_route.c | 16 +++++++++++-----
 4 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index d81bfb674906..aadff553e4b7 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -291,10 +291,12 @@ static __inline__ void ax25_cb_put(ax25_cb *ax25)
 	}
 }
 
-#define ax25_dev_hold(__ax25_dev) \
-	refcount_inc(&((__ax25_dev)->refcount))
+static inline void ax25_dev_hold(ax25_dev *ax25_dev)
+{
+	refcount_inc(&ax25_dev->refcount);
+}
 
-static __inline__ void ax25_dev_put(ax25_dev *ax25_dev)
+static inline void ax25_dev_put(ax25_dev *ax25_dev)
 {
 	if (refcount_dec_and_test(&ax25_dev->refcount)) {
 		kfree(ax25_dev);
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 7da36517d4f3..c1ea187f56e8 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -366,21 +366,25 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
 	if (copy_from_user(&ax25_ctl, arg, sizeof(ax25_ctl)))
 		return -EFAULT;
 
-	if ((ax25_dev = ax25_addr_ax25dev(&ax25_ctl.port_addr)) == NULL)
-		return -ENODEV;
-
 	if (ax25_ctl.digi_count > AX25_MAX_DIGIS)
 		return -EINVAL;
 
 	if (ax25_ctl.arg > ULONG_MAX / HZ && ax25_ctl.cmd != AX25_KILL)
 		return -EINVAL;
 
+	ax25_dev = ax25_addr_ax25dev(&ax25_ctl.port_addr);
+	if (!ax25_dev)
+		return -ENODEV;
+
 	digi.ndigi = ax25_ctl.digi_count;
 	for (k = 0; k < digi.ndigi; k++)
 		digi.calls[k] = ax25_ctl.digi_addr[k];
 
-	if ((ax25 = ax25_find_cb(&ax25_ctl.source_addr, &ax25_ctl.dest_addr, &digi, ax25_dev->dev)) == NULL)
+	ax25 = ax25_find_cb(&ax25_ctl.source_addr, &ax25_ctl.dest_addr, &digi, ax25_dev->dev);
+	if (!ax25) {
+		ax25_dev_put(ax25_dev);
 		return -ENOTCONN;
+	}
 
 	switch (ax25_ctl.cmd) {
 	case AX25_KILL:
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index 2c845ff1d036..d2e0cc67d91a 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -85,8 +85,8 @@ void ax25_dev_device_up(struct net_device *dev)
 	spin_lock_bh(&ax25_dev_lock);
 	ax25_dev->next = ax25_dev_list;
 	ax25_dev_list  = ax25_dev;
-	ax25_dev_hold(ax25_dev);
 	spin_unlock_bh(&ax25_dev_lock);
+	ax25_dev_hold(ax25_dev);
 
 	ax25_register_dev_sysctl(ax25_dev);
 }
@@ -115,8 +115,8 @@ void ax25_dev_device_down(struct net_device *dev)
 
 	if ((s = ax25_dev_list) == ax25_dev) {
 		ax25_dev_list = s->next;
-		ax25_dev_put(ax25_dev);
 		spin_unlock_bh(&ax25_dev_lock);
+		ax25_dev_put(ax25_dev);
 		dev->ax25_ptr = NULL;
 		dev_put(dev);
 		ax25_dev_put(ax25_dev);
@@ -126,8 +126,8 @@ void ax25_dev_device_down(struct net_device *dev)
 	while (s != NULL && s->next != NULL) {
 		if (s->next == ax25_dev) {
 			s->next = ax25_dev->next;
-			ax25_dev_put(ax25_dev);
 			spin_unlock_bh(&ax25_dev_lock);
+			ax25_dev_put(ax25_dev);
 			dev->ax25_ptr = NULL;
 			dev_put(dev);
 			ax25_dev_put(ax25_dev);
@@ -150,25 +150,35 @@ int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
 
 	switch (cmd) {
 	case SIOCAX25ADDFWD:
-		if ((fwd_dev = ax25_addr_ax25dev(&fwd->port_to)) == NULL)
+		fwd_dev = ax25_addr_ax25dev(&fwd->port_to);
+		if (!fwd_dev) {
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
-		if (ax25_dev->forward != NULL)
+		}
+		if (ax25_dev->forward) {
+			ax25_dev_put(fwd_dev);
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
+		}
 		ax25_dev->forward = fwd_dev->dev;
 		ax25_dev_put(fwd_dev);
+		ax25_dev_put(ax25_dev);
 		break;
 
 	case SIOCAX25DELFWD:
-		if (ax25_dev->forward == NULL)
+		if (!ax25_dev->forward) {
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
+		}
 		ax25_dev->forward = NULL;
+		ax25_dev_put(ax25_dev);
 		break;
 
 	default:
+		ax25_dev_put(ax25_dev);
 		return -EINVAL;
 	}
 
-	ax25_dev_put(ax25_dev);
 	return 0;
 }
 
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index ed8cf2983f8a..dc2168d2a32a 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -75,11 +75,13 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_dev *ax25_dev;
 	int i;
 
-	if ((ax25_dev = ax25_addr_ax25dev(&route->port_addr)) == NULL)
-		return -EINVAL;
 	if (route->digi_count > AX25_MAX_DIGIS)
 		return -EINVAL;
 
+	ax25_dev = ax25_addr_ax25dev(&route->port_addr);
+	if (!ax25_dev)
+		return -EINVAL;
+
 	write_lock_bh(&ax25_route_lock);
 
 	ax25_rt = ax25_route_list;
@@ -91,6 +93,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 			if (route->digi_count != 0) {
 				if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 					write_unlock_bh(&ax25_route_lock);
+					ax25_dev_put(ax25_dev);
 					return -ENOMEM;
 				}
 				ax25_rt->digipeat->lastrepeat = -1;
@@ -101,6 +104,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 				}
 			}
 			write_unlock_bh(&ax25_route_lock);
+			ax25_dev_put(ax25_dev);
 			return 0;
 		}
 		ax25_rt = ax25_rt->next;
@@ -108,6 +112,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 
 	if ((ax25_rt = kmalloc(sizeof(ax25_route), GFP_ATOMIC)) == NULL) {
 		write_unlock_bh(&ax25_route_lock);
+		ax25_dev_put(ax25_dev);
 		return -ENOMEM;
 	}
 
@@ -116,11 +121,11 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_rt->dev          = ax25_dev->dev;
 	ax25_rt->digipeat     = NULL;
 	ax25_rt->ip_mode      = ' ';
-	ax25_dev_put(ax25_dev);
 	if (route->digi_count != 0) {
 		if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 			write_unlock_bh(&ax25_route_lock);
 			kfree(ax25_rt);
+			ax25_dev_put(ax25_dev);
 			return -ENOMEM;
 		}
 		ax25_rt->digipeat->lastrepeat = -1;
@@ -133,6 +138,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_rt->next   = ax25_route_list;
 	ax25_route_list = ax25_rt;
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 
 	return 0;
 }
@@ -173,8 +179,8 @@ static int ax25_rt_del(struct ax25_routes_struct *route)
 			}
 		}
 	}
-	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 
 	return 0;
 }
@@ -216,8 +222,8 @@ static int ax25_rt_opt(struct ax25_route_opt_struct *rt_option)
 	}
 
 out:
-	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 	return err;
 }
 
-- 
2.25.1

