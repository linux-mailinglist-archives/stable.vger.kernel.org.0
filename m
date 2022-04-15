Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0517A502D8A
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 18:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355741AbiDOQQI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 12:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244563AbiDOQQH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 12:16:07 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00119F396
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:13:37 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23FFHSC7016359
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 16:13:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=Cal+knZyMDYttTzlNNs2ka13zIPemWlkOhXZ9zXxmOs=;
 b=b7J1cSGRffFTIIDmMep3JRkJCaWC5qwhOxUq5DnXboN00p7ft2PIP5gFXdpXG5+QNwTB
 n60Dh3iEKFvCEIb2ur6J46vE/JlYpqNPj1P0QLVeB4MY8hZCFNPp/Gr3mtd0cdwz8P82
 E5qFN0W8/NuK1bjBSmcWYcMushUHYqsV+kirrGvd9CgREpo3zp/KopJGzRVMum7YtmCw
 Bj5jHqOA6EjHgYONVHYxaW69S62cuXj4hX5pPoF2co7JVmkPvnpiuGFXhh2ixhZkXaBB
 qXeI5oO0ncjafDZGxKEvifhzUJC7lNlTlQtRo4XsWr+Yz4tkwpkd8WQ59QzxEK/ojOCX tw== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb66evug6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 16:13:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UsJc2FYqwNdwJnS7Iu9xfuVjkMVAxMF7X/f9rWkaEK24UpVzD41lmVY/MXPY0UyoG/5yO2wDFG4Pvm4BNxVCSqIHtBFr1NS78oMtAnUIff2ieJWZIyUFzvnqDqoTaPyLRAbyZ10UM0xM0oXkC6NQx9Y+bnrqiGQc+lVZbFZ6a08vFGTQ+jptDTw8E9tmoWqSjTKFAwgz2yWuetD97eMHDxeNEX7OEnFnevsPSVVx4Cy+ZCYiXCX8Ef8yPvHdwIVWMKU95vJo9I4NsZINJ5s6xY2R6PpIUcRc6c4EkzHWQ9V3Lm3OrsS96/whLNKhmtOftc49i5rKfBArZ4P9kgsT5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cal+knZyMDYttTzlNNs2ka13zIPemWlkOhXZ9zXxmOs=;
 b=C+vPxYN+hdFV3ZKMYBUuXaa/vv+meqiD78UaC6HjrIb5gKowVrJVW5I6wZobG6+OGs1OJ3tishtqwM4Gie70kOF8a1AzS8bH+UvqIIJ+AcXiSiGW8X4wuDAkOTS8K/qqZ06kbUc3tDq+xbhjkcUc9IjJ5nx2P9fzSNPTyVGgCDqL4HCBZHCqOOKp7fh/qiagGYAGUTKsNXoAhzvglSawrJ2LVFCJuXfUpCYYlz25/9ZhFHhLVi7zuGWqWEOR4GN9xpwWwUiBM7ucVClAoz9Fn7B4rxftUmMk1SiZ/lEnnos8/p6NIOUWqKCrpg1b7zXUIgFMI8lz6JeN/IEVugnqNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MN2PR11MB3904.namprd11.prod.outlook.com (2603:10b6:208:13c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 16:13:34 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 16:13:34 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.17 1/1] ax25: Fix UAF bugs in ax25 timers
Date:   Fri, 15 Apr 2022 19:13:17 +0300
Message-Id: <20220415161317.1016672-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR09CA0136.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::20) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a78ca4d-89f1-42ca-f3ae-08da1efae3fc
X-MS-TrafficTypeDiagnostic: MN2PR11MB3904:EE_
X-Microsoft-Antispam-PRVS: <MN2PR11MB3904D42BC2843DFEA8D25AC7FEEE9@MN2PR11MB3904.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fZDGL+2XQ5/nQ8TENhMw4ajJ63LzIh2BAHJjxzXZmE0YgMVnJaIY7ihtViz/DeiYobwPpVtyCFYkWbK7nDthRtTNSnsxIgmNqvi8YTEhkWPFlCgFZHh6rYck6HnPkCx3wyFHgYuTExi2w/Qxydoda6vYK/o+OGDuoZ2XFIeaWlWJe7P1xSYC/7+1JbcPURh8K4N+Y5UyB26/ND62BmHgYibZGsFqo1uB7uWDEM99TTzmtuSOM9GySDf7iwOtmf14E7ma0Ccju4gNOVnXjuXhZU4TOeWzgrvJi3AMjHORZZ4NJBGmZ56SRl6TRKxVlAI5bQK5igN3Zqr1H4p63LKla7CIYPgRLOJvJ585W0keSwg/rgZ4lnHcpAR+tPO64LldoXshsP7lrf+kohjmCZmy7RlpyaeqeKXQEkxqYIQWKNPYGcvVAMQU+dpAPTKU76qeti0rGlrUBBRoLS8apn9KFOJmtaUbHvseFV8dNhbI2Ag9DGiBY0Uh/kncomA4qene0NW8s4hQHqQgJbWrVMfo1HigkfJ2f8DuPUGW+JbnQHYN1Ao2mubbcGBW90UEa6R4Y1DVjXfePGPbVKjKyRE08rVGCnjoHKNvCJ/G1zHy0ADTXUWgZllRGhiXkq4orvW3qPnIh+bkPic/2Q6Ejrm6+MJMDfLIMeGo99IUOZVzpxxVuBC5ih1cWePP8dzbMzFT6X/nrHF1I/251b5bkugwmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(66556008)(508600001)(6506007)(6666004)(66476007)(6512007)(6916009)(6486002)(316002)(86362001)(66946007)(36756003)(26005)(2906002)(8676002)(5660300002)(38100700002)(44832011)(8936002)(186003)(38350700002)(1076003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k2Q8+zFwxIsc1RFmXySvynyDFtlz8jtrEw2LALrLD8jVURUzHU5fcn+DMcs7?=
 =?us-ascii?Q?OqhbO7mMMJvyYwnbzWRB5cz6IZdXJm6luNyvmTGCgio/rXP+KUbHC7QAOo1x?=
 =?us-ascii?Q?aFeSf5IeVSFUQSWdS+8+AWGCUxRWPymSjbKzCPFVI6U71tnwORyynzUU4SCY?=
 =?us-ascii?Q?FCXO6zzy2wTjrwYDb/taUzP+0/TChaB7MmqLUa8VAJqEJmHs6hpnLqpPoWY6?=
 =?us-ascii?Q?5r6W267r9lU6FyFy0nRbRfZdNCAVthonhEZucgwG75VZr1gs67salzwmUm/V?=
 =?us-ascii?Q?ZrYm/KPjlm+0AiT/fOEFV7LaiWGsWN2Uz4bp7XmGwiZKhVX8LdLapSe4zJpS?=
 =?us-ascii?Q?gzyskDHu3PXTvHuN+8nGQFsERjYu7YdYJKZNQaHWbFBzwvbDpq0M/SWmts4K?=
 =?us-ascii?Q?E2SD+ItBXCLAMgxXXvd/EFIYF8T1eJkiXU7ofD6saN9YG4fbOXKSw3Trc42T?=
 =?us-ascii?Q?kZs3t90NnSteG+xoO5HnGZSGn6WLTqCjMySfewbqPNFR5YAXj2TKN0Q0tHnC?=
 =?us-ascii?Q?ItiuZ726SwEjkKkUyBrpKJrOgvVtSwZpy3pxoXzJPIlVHe65d8SjP5/AvZX3?=
 =?us-ascii?Q?LnSO2xschaBJlaoDhWyCAWj7Z7olxy6EkXWE7B9SNh3GMbp8xNma4EP5S4GB?=
 =?us-ascii?Q?3LQSsApw8My1cOs/wG9HCE1Nj1FyWp1hAqUXTq3fvQAeFBXxx6c7vpUIIITU?=
 =?us-ascii?Q?38V5BNBJYzyBxZLm27TvotEJIwppuJkw84KBTcjeyqOaS0x9QvX9XEMh2P2T?=
 =?us-ascii?Q?WTB4x3P5XKoFKuXAUNo8eGySxZubDB/f+OiadP44GBwhli0+dnBv8/sIpsAB?=
 =?us-ascii?Q?XgVqC+3W/hzqA7MTM6NUnVCzlU14CRcrMSCLH0OnZ3ns4t5Ifckrrg4I0bMC?=
 =?us-ascii?Q?GaRc/QUnAAapmipWSWZA3Z+0jIiGYGkuB0FfYRPe0b8lklWzspP01sPPvGbj?=
 =?us-ascii?Q?wDBy/4hnfZtqy8lbddZdL/8voUKGXBsYfnSdoX3370Qej6H2s1vzLx86r7tB?=
 =?us-ascii?Q?Cu5JwSHOfy9Y5rf+kVLNfLFGfEbXp8iqtpI3ldsKuawkAmUEljP2Vh3Jh4pC?=
 =?us-ascii?Q?XQed8oUXaiuAKyEQq4HyonMpw4tG66BybSGO65pi+XCO2EiGjwJAlMR+SIxh?=
 =?us-ascii?Q?DLLlvV8Q4ExI+2kdjt/5DrG7BInItKhpMSJ0iL+j07bMUZ8QQvzcF2ftURa5?=
 =?us-ascii?Q?Y5bgbaDK+37mMR/n/QMaFwoUrDjKkqbnbgqiUXIhFiIJt3C1TnNvtFLeCTjT?=
 =?us-ascii?Q?qTm1Tv8rLqUxjS34ggYgy/97Frbglel/fQv5O/x8xd4sKj/H+u0B6+6iUXPN?=
 =?us-ascii?Q?YnyRFfhET9e29c70+P7C6DZoXjBZ5INYfbePSJ/1yt9/l24RBkKFLGfbm8Ov?=
 =?us-ascii?Q?6GI23qevnRHdCvtYXRBwvs8qsKf2NJHZ6Kc+ReOb4B0yxZLG30EV2e39OSMh?=
 =?us-ascii?Q?LkxkAoe6euh6trDAUeus808+L6D4PMZ2IVxl3pwxLK2V7hEREfEZmjJSTrvb?=
 =?us-ascii?Q?NxklUewFevyNOdJVw6xsI/xk9iwMf+MTh8ZcEYUGPtsdjSyeZLK33dsTpVNU?=
 =?us-ascii?Q?e738tozSakbhvvz1Y/zwJ8o6LceRRYQFCs/F6OmZTq2Mtw6H9TQAv0Np4bl1?=
 =?us-ascii?Q?5nvrZGqAxp9wqVga0A5goJoK8piwSdbWbr0CnxNVxkdzqcOc1zmIbcK1unuj?=
 =?us-ascii?Q?FXBUEQfnMgscp33AMSEqLf7FthQmC/54j0wEp50qMKRLhnnr3zzGsw0PfCfQ?=
 =?us-ascii?Q?Gh7xs1jqexA7hqwzLjZ0JqJftXcpQkU=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a78ca4d-89f1-42ca-f3ae-08da1efae3fc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 16:13:34.4678
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TRX8k9z1Jt2YuZ4CkhRXcfnjmuC873IRnRIQqIM0XLAEzm/yZ8FGPg8hyrde3owh3lgoFjAsO3VdiDtYYb864lrJgz2viJhx7wURKED9V5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3904
X-Proofpoint-GUID: C6tYmpXETKxDZQqpow-rByKhgxlLwGqd
X-Proofpoint-ORIG-GUID: C6tYmpXETKxDZQqpow-rByKhgxlLwGqd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_06,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 suspectscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=567 impostorscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204150092
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

commit 82e31755e55fbcea6a9dfaae5fe4860ade17cbc0 upstream.

There are race conditions that may lead to UAF bugs in
ax25_heartbeat_expiry(), ax25_t1timer_expiry(), ax25_t2timer_expiry(),
ax25_t3timer_expiry() and ax25_idletimer_expiry(), when we call
ax25_release() to deallocate ax25_dev.

One of the UAF bugs caused by ax25_release() is shown below:

      (Thread 1)                    |      (Thread 2)
ax25_dev_device_up() //(1)          |
...                                 | ax25_kill_by_device()
ax25_bind()          //(2)          |
ax25_connect()                      | ...
 ax25_std_establish_data_link()     |
  ax25_start_t1timer()              | ax25_dev_device_down() //(3)
   mod_timer(&ax25->t1timer,..)     |
                                    | ax25_release()
   (wait a time)                    |  ...
                                    |  ax25_dev_put(ax25_dev) //(4)FREE
   ax25_t1timer_expiry()            |
    ax25->ax25_dev->values[..] //USE|  ...
     ...                            |

We increase the refcount of ax25_dev in position (1) and (2), and
decrease the refcount of ax25_dev in position (3) and (4).
The ax25_dev will be freed in position (4) and be used in
ax25_t1timer_expiry().

The fail log is shown below:
==============================================================

[  106.116942] BUG: KASAN: use-after-free in ax25_t1timer_expiry+0x1c/0x60
[  106.116942] Read of size 8 at addr ffff88800bda9028 by task swapper/0/0
[  106.116942] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.17.0-06123-g0905eec574
[  106.116942] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-14
[  106.116942] Call Trace:
...
[  106.116942]  ax25_t1timer_expiry+0x1c/0x60
[  106.116942]  call_timer_fn+0x122/0x3d0
[  106.116942]  __run_timers.part.0+0x3f6/0x520
[  106.116942]  run_timer_softirq+0x4f/0xb0
[  106.116942]  __do_softirq+0x1c2/0x651
...

This patch adds del_timer_sync() in ax25_release(), which could ensure
that all timers stop before we deallocate ax25_dev.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index f5686c463bc0..363d47f94532 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1053,6 +1053,11 @@ static int ax25_release(struct socket *sock)
 		ax25_destroy_socket(ax25);
 	}
 	if (ax25_dev) {
+		del_timer_sync(&ax25->timer);
+		del_timer_sync(&ax25->t1timer);
+		del_timer_sync(&ax25->t2timer);
+		del_timer_sync(&ax25->t3timer);
+		del_timer_sync(&ax25->idletimer);
 		dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
 		ax25_dev_put(ax25_dev);
 	}
-- 
2.25.1

