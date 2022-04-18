Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA799504CBC
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 08:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236422AbiDRGgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 02:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236796AbiDRGgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 02:36:11 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6726C18E3C
        for <stable@vger.kernel.org>; Sun, 17 Apr 2022 23:33:32 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23I6Ug8X028999
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:33:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=ttG0Rh8ucIcTPX8kkMfnzd/DOTlFBfK2x5cVAIwFLzU=;
 b=b9Vgl+LROcflpPFU5b2Wvls0FnYEWjNXP3AgjUF8wUK1AyRDh8QKnYE20HNUmJNBYhX9
 ovfPSs7tChpGwNJNxv7hDk1+XezYo8l71l8aX6ttQoASLoDnvskDXANNXfEWfohuiL53
 H0hvddE3teYtST4HvUOiR+PpPlirrYvf0/9GXE4TzxY16Ah4JtAAkyfSp5bs20V21lDk
 ToUIMsHK++h+0AE+TYqXTrSUSEt5VXMjFMd1irW6LhXX5hgG7D+60w12tgw3/WbxdGlf
 C5ebM/vRkOegL/vj9fXhElq6AX9zA+Ei/FgFX1bmFhEWstAr9l7tSyuNiherLHLpVN0V HA== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ffpj2s45r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:33:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tan4jrVdovKw6wlLLtmeF1jAc0OC3aXutIZUn0lQbVicw1w61AZ4eJeZw2+uLlo4ErusFGYlJ2qdnUVkVLT5jijV3LYgHIQJahwPKRt8BNCRwodOo2NkEwMa5K6wkxyV+iX1uP6YEYMhffivjwfJAeW6MKJRmOA0S0ARvazYqcCXwMEKrbYsWa2S6GxHB25dno/Kh4kYeTy8pSy177TglVpDIsu7HYHvJnBfPa5sgNHRNRl2Z6IySoSUT2d7VndMoSyAyB36k8M7OpDCdrDw6LSMswXIQ3w/5ZvVCQez9vcNrD/CVibRJ9D7zgtgLTNgaQwIJrotNqVdJLbF3tmQrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ttG0Rh8ucIcTPX8kkMfnzd/DOTlFBfK2x5cVAIwFLzU=;
 b=kSu9yasqOkmlI6HmLrkJ0jzGAudfs+eKsIhbZF+E2Z4meYnyJjpX3xzAGN+bTwqzMwKuvGJWhAQD3WuGUjviIBxBsDRkcScf/XpwFp0iEmF80m5JQeMxKyUfxh1FwpIeJkBciywBqQwFV6NTEGnsKZlEjyZcD2Z4ses3Xd6mcrZQW3FX5lsMknVHmzf/LLLGlHo68TKdLH+9ZXgJaFqTX1sQmFQH+jvomN3YwprFQVBnFmmfOxXgibfPpXyshIxlemBN9C9XMJvrMR09jf9I9YaXlYcYH24BoVPKC5bca31k883I5rDQ9J5oPOtWMqt0WFB1Hj8lr4QdnaNyzH8pWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY4PR1101MB2135.namprd11.prod.outlook.com (2603:10b6:910:1d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:33:29 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:33:29 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4 2/8] ax25: fix reference count leaks of ax25_dev
Date:   Mon, 18 Apr 2022 09:33:06 +0300
Message-Id: <20220418063312.1628871-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220418063312.1628871-1-ovidiu.panait@windriver.com>
References: <20220418063312.1628871-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0042.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::19) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3a7dcd4-d36f-4470-19e2-08da210559de
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2135:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1101MB21352FD08B5F5C4450EC3D46FEF39@CY4PR1101MB2135.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /0GD6M4pjv5rv9LW62hdSks4yu4Vor44nWusdBXPuTNZTP7apx+quuaB0MjFSlIoLhV6yD/IWFayGub5ZAvEYdrhyJEXtPTNjYVkS88v2VlRaO0M6XWskUi4rTjicQXY6WzkkI4at741RYiTF8ypgUm0mlfIQ4Y1UUQ9h+T3WgARrWyxzKd1ww2Ra+eR1jkEIMBCXLs10vzmAEHJYLoB8CNGLLImlFgqqRk5HBSu7khhDKOwZ1XiCoXASki2g5osvyo61wDHujwttc0KwM/jMriNuCQI4t7OwkdB531BLBkZFzzqL3qCyU6Huj8ThQxzO1P+jTtjqJ87bWLSvU5okGM/6yXjt48MDD/BpfvbfRGhzUE/kwPSIBeG4mJwi/pdpnzCE5GvftZie/DqpUG2AazaZibyr6zzVNVzpO5cYicds99TQlTqvY5xnGE/NsAbG4XNntL1NcI//EnbZ5NmTfY+AlJcPIZNaxljUb3wKi7ZyeZKAmTPSC9NNO+FdMXOOyPaSY5LpMHcgh0uJLFVKgH+KOHmADZBugIIOU2cDEjabZ5fVvwI3HFi5hx/dc3LdAdqavDvQ5bY/gbj4Qa2gkGQ3artXqXmqtufJl6NgT2X1x+D6DJRuVThi51l/CNspkAdL3BjH48J/rX+rM2uIYplukJY+AkAtdmD/s9xbL2f1eDhwZwXAy+QtiaMFfdGbAU73XsJoYZZscuwsCZF5LlhKCFPH2oNcaaezIDGWXHY8L9CceaH9hAC1vShtTlF9ZE7LaynywTjRbPwMebpY9bdJjYBbnAkyoQ+uhgp71w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(5660300002)(316002)(36756003)(66946007)(8676002)(66556008)(86362001)(83380400001)(186003)(26005)(6506007)(2906002)(6666004)(1076003)(2616005)(52116002)(38100700002)(38350700002)(6512007)(6916009)(66476007)(8936002)(6486002)(508600001)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ht7f9Ts4qd5zf7wVleC8Fo9hbUOTlcHvZzhWWChdU1BBPAID+DOVCES/Fmbn?=
 =?us-ascii?Q?lLnDSp2Rv+kSEWrsnA42a6c8o7kgk+UoNoW2p6PbafFt0+w+dsKAT1o4gAlD?=
 =?us-ascii?Q?a1v7iikEcDeYvtEbA4cY+/e/XHFkTQqQshiy1q3679tnKuKz+cScOM8oi/A/?=
 =?us-ascii?Q?2kP/2UJQ6eN3RAL6dNK9xaXHBETbj3vsiv5vKDmKbCehVnGnjQ0LR0kyAAZX?=
 =?us-ascii?Q?BNq2v263O/IVUeSYGxolBHI4rLASWFhXzR6gFz+atuAV2TlVN7oOox6rmuvT?=
 =?us-ascii?Q?ZAQOqRXRJ3JYukYDwW/s6XkWsGBDxPgBMRZr7XwX6L8hZ8QHEKB+JGMEbhIs?=
 =?us-ascii?Q?KNwtY+EPcjlCtV6xRzEDACT1wSSSoXjvwH5eyU/IYyE/PR8t+ho9csEWopb4?=
 =?us-ascii?Q?peuOsV5+yBji3QPrenF1Kcn9sBuAULLDWOYAZpDG64d5zbD8mzHNYii67Y6S?=
 =?us-ascii?Q?Y18qyDT9Wxg2as7/I8fdk6WAD468fM0WfwBnXrwq4y7hPk0gmlQsqRIO4azd?=
 =?us-ascii?Q?51d7VmXGVqCctutFntkyXe4b5rFoy2Ghqz3+XY9c9wKv/QpKMDPj265qkUH6?=
 =?us-ascii?Q?6Bo8rrJeenkKDXNUlbWPDld9fXJZRdYFzA0DZYZbAV9PeJAbQM338Yjbe341?=
 =?us-ascii?Q?EBZ++NugeF4U4O+AKYCF08lNUwJh9Ct7JRFzeqxdEbtFm+nIwXcGAdCaFyfG?=
 =?us-ascii?Q?4LHdotxmIMmFtREjfYqklvr4zno/+lpZ7SkUp6Aa2vr+o9DhRwuLv2lFN/1h?=
 =?us-ascii?Q?H4HRBTxbU5FAx0ZbkumDJZ969CGmn/0w0VVKfHgJriGC83FtESY8bEx8Q1QB?=
 =?us-ascii?Q?F4j3HePjP38kBmY1Wf3V/SJsoRFeq+s5mfZU6f38Ju5c7Pxx4AhvPlB0Dyjp?=
 =?us-ascii?Q?J0ExXgQ9KIab/Rdk7AsWurpndy2x9We1JKZZbpUgyXc9CY0Tp3UkaA6Vk5mb?=
 =?us-ascii?Q?lEkJOsoxZbxDK15MiNL5lf0FvjOJY3Eors/H28zXqV1nhZZ80ez+bAuQLNKK?=
 =?us-ascii?Q?tKjWEdyXejGr2uGsdVCzr3qhM4Nm/ToE/ehzwZzO18WAuotOrB0eUpbYCDWZ?=
 =?us-ascii?Q?SWQzdtiOeWcD+liiYTIUVzugEaXAuDdGDegp6N+JGVL4JZAIBozU7HlVXq0I?=
 =?us-ascii?Q?ZezaAT8roZ6ZPMlUkA51+4vaEh3H2P6dEfQ/UUglETVSXUqA/UPLHpApgFuU?=
 =?us-ascii?Q?Ztek0rXU4ay4A7YL8FYu5zw6HmZxcNe1IZGNO3WYTn1v1430EeW6My0xUqGD?=
 =?us-ascii?Q?ycbrZSETNB15MU+E65PzxkEgUO3UwTUTl3KkeQVLoL6+frLCNyBWt0t31GY6?=
 =?us-ascii?Q?wmYU4kcj2OQmWJQG7wn8jtPXWFglokOPRpkPD/7gdNXWd3e32tuv8ajkaVew?=
 =?us-ascii?Q?IcYNhcUWN7aogPbz0hVahbrlsiKTVnG29CHjoWFvIArlcjDrvGaRqFAevoEd?=
 =?us-ascii?Q?RtcQOi3XgjNmD9y2K7bky5uS/VJFP//WXR74yUkg/k8KGaC2OdOnGPlpWK5E?=
 =?us-ascii?Q?ijtzBVXRWfU1tNUbVYk2j8ZMP43YNuvYLvjC6JF7ua9KCv6syRvNtsVcPhVP?=
 =?us-ascii?Q?PR8r5JmV3BY53NX8FlX8ZV0iChtjFjYUkYlds2e/VYval8t3TB1SCFnXE0YH?=
 =?us-ascii?Q?TWCw+Fc1CZt4QNBBYJgVTH/dV+WZeoHcOtcB42CdkSFoNLwau5Krl7nLq0xv?=
 =?us-ascii?Q?PbQmnQuUeUpOF4FJ0DG60aJ2fd0LXgD0datbl+JxuM11qtPFsGNpxNlMTfb/?=
 =?us-ascii?Q?TJG/yQfZ34wlQNzeudjTmfWa+i1mJwY=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3a7dcd4-d36f-4470-19e2-08da210559de
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:33:29.3721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jO81ZzppKefTbnjtvUR0UPXr2+lnJkuxDKwi2aGlqRwUygODwGPpg8INnTfz/3kzCns5qSY/FGZuJ/joDkDkce+6pBU4J61kn0cddWcJ6do=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2135
X-Proofpoint-ORIG-GUID: _wietHz2UPClcMht4eFhy_E3seM-8mov
X-Proofpoint-GUID: _wietHz2UPClcMht4eFhy_E3seM-8mov
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 spamscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204180037
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
[OP: backport to 5.4: adjust context]
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
index 211a997784e1..997866ed9cd0 100644
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

