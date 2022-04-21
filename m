Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15CDA509DC6
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 12:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236262AbiDUKk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 06:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388461AbiDUKky (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 06:40:54 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9597325580
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 03:38:04 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23L9rOWT020967;
        Thu, 21 Apr 2022 03:38:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=GvM3eilFC3Z7gdhCZ3UVBtt8GfL3PEGZtZAf8MmfGT4=;
 b=EYAES55BH5H20Thb8FxWRuKz0ZOFowOEEcEphqv0xAeNcL52yZGzCsjoRx+TOv3S+cnp
 13kXgTEt/eoFTazeZeo0JkQq5Rn1FM2jTOSvxl4+ciRxGszxfgVXojyBV+wEK+mGtGKY
 93Q5zuuj6uzwJMK10FBpwxCq7hLUs0wkqFLjDZszcm7+3xFhxfjmY6NDyR/ngN474VV6
 +Iu+oh1OHqJRg/YLWjTQGf1XHcEr9dm4Tth7FthP7HtuBqyIx+ZNv3VD0j/TT/vfyWxa
 ljN3RrwqlS0bG4Mf+goGo3LR/kbi7NuCwj6bdY9ZK1jD2ekbw7sqwoBPPs8RlL/0VNcG bg== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ffs313nqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 03:38:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Il+4K/cSbPoyVqbao8NscCOC1F5dLDahzz36PvEnjeFdJ35m62uMOWu22xVbPDYPd/nIgQdt4gxAvVlC3sGvmrsZl7RCKS44X2n/H5Ri2AmPN+qO7/+xUcD/XMY9QFr9nX2oUdv+TEghEScTK8h8Ak4WA+wtqkA+lUfXUo5kMAOrwz6Ljs4z9mhbM5OSOrPHw34sF+mcPtULeyAMKMO7BPmaBUgeSMVhta4e2+StlBiZ9eEbE12NFphJmx4+k1MmCnrPCBzDw3H98j6dP8lLdxkIsBKAAfPeLIxq3wKSHGLJCG8eP06zSOVZbIJpJTNwr6KgKegAB8AGumBgBK8tzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GvM3eilFC3Z7gdhCZ3UVBtt8GfL3PEGZtZAf8MmfGT4=;
 b=S/I3sYcgSZ5+WO708dKBFErhnXmcyUXAdHOeu9J3rYzHt/nhP5toukzbu8kquuMNImAyt1O9vAUZLUC1T/MNoWM1qDAClzo8wDTgbLbkTr4qvoIUyyIf1MxMGy0YQTLcufNUUfllaljvvWyWUGRjpX4qIwSrh11htG4DScbB5My64QZ6izewQA9ryzlW3fG52330R+mTxs+Q2Y4KOPgDHW5sYscUkP12+6YCS4VyZjnBQxtYS0f8uzf/DYLzpZO3F3f21QqyQftQ4euQ4E7L5SNa7CtnFDwwCVSVXDntNHbMi7g+5d37a7O1efn6H7GzRKMR8Q+ePMDw1zrTVyPptw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM4PR11MB5406.namprd11.prod.outlook.com (2603:10b6:5:395::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 21 Apr
 2022 10:38:00 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 10:38:00 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 1/8] ax25: add refcount in ax25_dev to avoid UAF bugs
Date:   Thu, 21 Apr 2022 13:37:32 +0300
Message-Id: <20220421103739.1274449-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0024.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::36) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9003f0c2-2837-4af6-75e2-08da238301fa
X-MS-TrafficTypeDiagnostic: DM4PR11MB5406:EE_
X-Microsoft-Antispam-PRVS: <DM4PR11MB5406EEF73CAF9DE27C077C26FEF49@DM4PR11MB5406.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S9kTnUSjgWsIoKm5oer9e6Z9hc4sAxAl9U0cf6hAttFwCptxWFN/tl//EJHru0iMVndHWIp0qp/VFqQBb1wr/sbBJexy40s8fXUnrenBXYZenyYYAD3qW3gJH+sMEDvBP6K+VREjmzzhfuPnGffhQv9ghEaOKLbOFevoma/+WURfbe2hdX5MLnvqmlxMoOJLJy+JMFhI2YiMLb0TAfs1cFeuGYG7YB+VXCplaAiKX5up+gICa31XNZTwy2wbpCPFysMM6fZW3p2vcezGz+XSaaW0ZkrWlI0t0CEZxQs3d69JIa1HFT5L+xmmh2rBtN84k55JNqNbEU41/M2uaXoYrucb5ROIzPoXH4ConPw88koY7NP6epYh2udJgyOtLhcsJGO9qndL6N91kXKd+7fhGD8jIk2Mv6LbSOn5OmubwDqewAvAgk8M+b8vdmMz3xwa8ulSmS8cVkuZolb8orKKLAPBf6wkV0CeO+0COsFZiHeoFruidQacXebS/nBrRWCw0E87nOIpD7Ovdsrtcy6DFMWVZZ5p1n6NsejnNQyPZYlayDICN81UCByeJDfNas+2+xU5gjmD6/98C7i1xoGoXke4o+ZA6k0hrNCwLAzymO0vskk97OtRuTnCnyI06APMKoUUi3Tp8NwvcbTzRkROHf/7koaaSJZzY0MTcPwQt5dYsNfibGmUE2m0DL0yRR3aY2OjeKLL9DlnlVa3gGHtVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38350700002)(38100700002)(26005)(508600001)(8936002)(86362001)(6916009)(316002)(54906003)(52116002)(36756003)(186003)(107886003)(4326008)(44832011)(66556008)(83380400001)(2906002)(6506007)(66946007)(6512007)(5660300002)(1076003)(66476007)(6666004)(2616005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a+Leqri0jW/n0djP7sQmBrQBHFI4fB6II18gjEgs8Y2bJSBBAcpcTIkbDtWf?=
 =?us-ascii?Q?OF/XAtTmBnA6Ugk10jsvzo13FHt3akICae+hwVCust7e+e9DXai/0nEe3BxS?=
 =?us-ascii?Q?XSGdhdo7tGRU40Gx+2fPVsTd0v1PxlPCqKh28Fp8b/cHJTo9XKHKmUc6S/B5?=
 =?us-ascii?Q?1gzs/7AFRJMYExb/1ISIuTkZqFzn1dmLG7XZsHzk7XQPQ9Rh+KClGuBqP6tQ?=
 =?us-ascii?Q?9E7bs6AJppKpw5HMeluJhguRr7qjn9Gg2oGPbWbWR+sA/8ru4hHBeUpy8h2w?=
 =?us-ascii?Q?bM6Vj/oPKZ0gu6HsOcHy9KdgibSqpAVnVLFE9asHg+Y9caOlrITdemXaYL2c?=
 =?us-ascii?Q?8XNcmCJhZMrv5zNzbuh7JOlxs0IJS19yxYlRM9RSDdSs+ozxXsFQzL1x8JGr?=
 =?us-ascii?Q?89PWC+wDou/2P7rKMD62PMMQwEebOE6Zfe4g5rZWmaqpUwzhpdGCHSUoN2p9?=
 =?us-ascii?Q?6DpL/UftGszX2Uia60RuLm6i4GX1sPeRgNFge+VaAI65DDrkil8kRXBAyzcl?=
 =?us-ascii?Q?IAcsDTQXbcVMTJYdX0nvGi1Z2CjppDfBe36IMPa1K412XQpPwGo0hqpBcFzS?=
 =?us-ascii?Q?EJ5ysKfPaPboV/BgNUNl3T7kyudIwKDn4OXiNLk+hU4t1F+o4dSmhBKLrI1w?=
 =?us-ascii?Q?F62P3QPDlB0LLEifsm/81Jg7cPZMYmap2dhYOZjdpCqGVJlcZ6P53OLhKsnM?=
 =?us-ascii?Q?38QSa+TuGlal/60mdBoFaNGV6Ws1rjxqrgmi60iz734X0UpSAfxkDom4xLN5?=
 =?us-ascii?Q?BYehu/NY14o95wmb2jUs/uMk76evv49s4t4wouLQVsP6CCmrMxLktY56O37T?=
 =?us-ascii?Q?4sj/kuyE9FK+1TiGdTGSxi5qAXiztz7Twh+RIV6lxcJ7aQSl1ZHgtUKSom19?=
 =?us-ascii?Q?X8oU+bpZGwqsf9ygtTcsKjF3PDrpciQ0ejfCBGoY09Nf/FlkvBI8liBghVDB?=
 =?us-ascii?Q?iEF1zwcNHlhcIzKf60bJuiu5EMF2hekrEsKPhS4YBDNOTXmv2/TGCqNI1OPk?=
 =?us-ascii?Q?LAbuwxlg9o8ymKCmKzBpZggtpeguOKYMSXuzM1GKcgcJRuo8orUEkomqKlJu?=
 =?us-ascii?Q?D/089Qrn/qBtA6eP31F76WWyjT8nsqZbX5hXNhqEkirrdD56PKi0WfUpzzLA?=
 =?us-ascii?Q?XRcOxADKmPXHZ18Trnjtw4cLML2IdAGOhAQa+neD7FIYqQlSztUl/X6J8K1q?=
 =?us-ascii?Q?5pyf6MnKmFWJsvDt4vU/AS1uOLUPd28kDlJeJJRKNksXEtbk0AI8Uz4M961j?=
 =?us-ascii?Q?UqiBwllcBytEgGYAZ/HEvddoX+agKakGPqfxYVZfC8Ha64ubtv/cHGDwzBnL?=
 =?us-ascii?Q?cCE1LVxRXy6bgBRVkeqK82TUtXL+qMpmY+XS25B+cOwEfQh3DYedzIfjLtHj?=
 =?us-ascii?Q?EEDTivBrVpbFUEFhr/VpN3izCFg8S6299KyjiwyrG7Pp4u/QPOL//bjBU4wz?=
 =?us-ascii?Q?msJK2c6BXIuHfrtmul0nuRcG76oPQ5AhULmg8upx05VEn+2vUdlEHfRH5z2w?=
 =?us-ascii?Q?L65QtF+YjATCPpU5Ug4658uiF/ok9fgIVgU4wBNCZBvqS+wv2SgoVnksKCnI?=
 =?us-ascii?Q?uOC3EuMVr5Krpq9/gKz0hnt9XkKtJZZF4OOeTfxhx6jSLqvWRRdIoEE/qi9Y?=
 =?us-ascii?Q?9TiD2BqVJ/713Z2o8J57V8MCU5TpIUmc6/fOz68N8gWYZhKKMqMLRW4OyV8U?=
 =?us-ascii?Q?zcrDmtSDZPPKpS2oFd1Q30fZwrgIYW8RC49NPjIVsTsiv+2oW4iuZiSZqLx6?=
 =?us-ascii?Q?zU/rOMqmKGjNSUii/iPj5sW7+teDHU4=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9003f0c2-2837-4af6-75e2-08da238301fa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 10:38:00.8475
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p8KpcYrmaIHV7gvLPgZxzfBJi9neZfjYJ2OO7ePCbxDhQUPwpEdAnOQt2hhzoO0cDaXFBwCpLy+ra+pcPsCo++1RRwGvLKTLulwy962lYqo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5406
X-Proofpoint-ORIG-GUID: 1DpZOiaD2HYhw62_KL2MWa8Ry8LV41dc
X-Proofpoint-GUID: 1DpZOiaD2HYhw62_KL2MWa8Ry8LV41dc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=785 mlxscore=0
 adultscore=0 clxscore=1015 spamscore=0 bulkscore=0 malwarescore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204210059
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit d01ffb9eee4af165d83b08dd73ebdf9fe94a519b upstream.

If we dereference ax25_dev after we call kfree(ax25_dev) in
ax25_dev_device_down(), it will lead to concurrency UAF bugs.
There are eight syscall functions suffer from UAF bugs, include
ax25_bind(), ax25_release(), ax25_connect(), ax25_ioctl(),
ax25_getname(), ax25_sendmsg(), ax25_getsockopt() and
ax25_info_show().

One of the concurrency UAF can be shown as below:

  (USE)                       |    (FREE)
                              |  ax25_device_event
                              |    ax25_dev_device_down
ax25_bind                     |    ...
  ...                         |      kfree(ax25_dev)
  ax25_fillin_cb()            |    ...
    ax25_fillin_cb_from_dev() |
  ...                         |

The root cause of UAF bugs is that kfree(ax25_dev) in
ax25_dev_device_down() is not protected by any locks.
When ax25_dev, which there are still pointers point to,
is released, the concurrency UAF bug will happen.

This patch introduces refcount into ax25_dev in order to
guarantee that there are no pointers point to it when ax25_dev
is released.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: backport to 4.14: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/net/ax25.h    | 10 ++++++++++
 net/ax25/af_ax25.c    |  2 ++
 net/ax25/ax25_dev.c   | 12 ++++++++++--
 net/ax25/ax25_route.c |  3 +++
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index e667bca42ca4..390e32103a6e 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -235,6 +235,7 @@ typedef struct ax25_dev {
 #if defined(CONFIG_AX25_DAMA_SLAVE) || defined(CONFIG_AX25_DAMA_MASTER)
 	ax25_dama_info		dama;
 #endif
+	refcount_t		refcount;
 } ax25_dev;
 
 typedef struct ax25_cb {
@@ -289,6 +290,15 @@ static __inline__ void ax25_cb_put(ax25_cb *ax25)
 	}
 }
 
+#define ax25_dev_hold(__ax25_dev) \
+	refcount_inc(&((__ax25_dev)->refcount))
+
+static __inline__ void ax25_dev_put(ax25_dev *ax25_dev)
+{
+	if (refcount_dec_and_test(&ax25_dev->refcount)) {
+		kfree(ax25_dev);
+	}
+}
 static inline __be16 ax25_type_trans(struct sk_buff *skb, struct net_device *dev)
 {
 	skb->dev      = dev;
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 466f9e3883c8..3f13c619824b 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -101,6 +101,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
 			s->ax25_dev = NULL;
+			ax25_dev_put(ax25_dev);
 			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
 			spin_lock_bh(&ax25_list_lock);
@@ -450,6 +451,7 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
 	  }
 
 out_put:
+	ax25_dev_put(ax25_dev);
 	ax25_cb_put(ax25);
 	return ret;
 
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index d92195cd7834..76d105390706 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -40,6 +40,7 @@ ax25_dev *ax25_addr_ax25dev(ax25_address *addr)
 	for (ax25_dev = ax25_dev_list; ax25_dev != NULL; ax25_dev = ax25_dev->next)
 		if (ax25cmp(addr, (ax25_address *)ax25_dev->dev->dev_addr) == 0) {
 			res = ax25_dev;
+			ax25_dev_hold(ax25_dev);
 		}
 	spin_unlock_bh(&ax25_dev_lock);
 
@@ -59,6 +60,7 @@ void ax25_dev_device_up(struct net_device *dev)
 		return;
 	}
 
+	refcount_set(&ax25_dev->refcount, 1);
 	dev->ax25_ptr     = ax25_dev;
 	ax25_dev->dev     = dev;
 	dev_hold(dev);
@@ -86,6 +88,7 @@ void ax25_dev_device_up(struct net_device *dev)
 	spin_lock_bh(&ax25_dev_lock);
 	ax25_dev->next = ax25_dev_list;
 	ax25_dev_list  = ax25_dev;
+	ax25_dev_hold(ax25_dev);
 	spin_unlock_bh(&ax25_dev_lock);
 
 	ax25_register_dev_sysctl(ax25_dev);
@@ -115,20 +118,22 @@ void ax25_dev_device_down(struct net_device *dev)
 
 	if ((s = ax25_dev_list) == ax25_dev) {
 		ax25_dev_list = s->next;
+		ax25_dev_put(ax25_dev);
 		spin_unlock_bh(&ax25_dev_lock);
 		dev->ax25_ptr = NULL;
 		dev_put(dev);
-		kfree(ax25_dev);
+		ax25_dev_put(ax25_dev);
 		return;
 	}
 
 	while (s != NULL && s->next != NULL) {
 		if (s->next == ax25_dev) {
 			s->next = ax25_dev->next;
+			ax25_dev_put(ax25_dev);
 			spin_unlock_bh(&ax25_dev_lock);
 			dev->ax25_ptr = NULL;
 			dev_put(dev);
-			kfree(ax25_dev);
+			ax25_dev_put(ax25_dev);
 			return;
 		}
 
@@ -136,6 +141,7 @@ void ax25_dev_device_down(struct net_device *dev)
 	}
 	spin_unlock_bh(&ax25_dev_lock);
 	dev->ax25_ptr = NULL;
+	ax25_dev_put(ax25_dev);
 }
 
 int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
@@ -152,6 +158,7 @@ int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
 		if (ax25_dev->forward != NULL)
 			return -EINVAL;
 		ax25_dev->forward = fwd_dev->dev;
+		ax25_dev_put(fwd_dev);
 		break;
 
 	case SIOCAX25DELFWD:
@@ -164,6 +171,7 @@ int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
 		return -EINVAL;
 	}
 
+	ax25_dev_put(ax25_dev);
 	return 0;
 }
 
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index b8e1a5e6a9d3..c13f1e897b39 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -119,6 +119,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_rt->dev          = ax25_dev->dev;
 	ax25_rt->digipeat     = NULL;
 	ax25_rt->ip_mode      = ' ';
+	ax25_dev_put(ax25_dev);
 	if (route->digi_count != 0) {
 		if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 			write_unlock_bh(&ax25_route_lock);
@@ -175,6 +176,7 @@ static int ax25_rt_del(struct ax25_routes_struct *route)
 			}
 		}
 	}
+	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
 
 	return 0;
@@ -217,6 +219,7 @@ static int ax25_rt_opt(struct ax25_route_opt_struct *rt_option)
 	}
 
 out:
+	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
 	return err;
 }
-- 
2.25.1

