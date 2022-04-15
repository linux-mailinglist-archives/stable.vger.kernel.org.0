Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E11502D9A
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 18:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355751AbiDOQRP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 12:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355760AbiDOQRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 12:17:12 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 206351D0E5
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:14:41 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23FFwNBG025644
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:14:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=TMeFXh4swRAo0AkCXnyNFqKLfvIuezw4vSjpEZi/vDk=;
 b=aJqCsQCXedjVAvZBof4vaoy2q/17O0N0wE0HGFdQ74m4PgwHaSXxPXv+668oR4pU75i9
 HfX6e0st3vZGIPsF1a6nAiLm+po8otQz9V6Etf5oVMh+Ao2LR8GU9AWQ/kpIOgAjysur
 PbfhtZ8bdDDo6omHSTlBUMqWSsi/M13FS8glSUg3C9Z8CX25zdaUK/LAw0qaQ1NCVRN6
 vFBbndOKE+N3vI7jBX/OuB3Hq5rTdWaUYsgUKbelrZ1SPF2G2rh+BPiB0elGEQiR9/AY
 XL09s9dr21xUbNFLDGEwLl0HPL7UINgSuYwyEwE5OY9kogNsRRjpL8ktkwu/fP+z8/Wy 6Q== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fc0jec5h7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:14:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dJMdo0XmqHwLDMsHqXb25Wm9woD2TwTwXi2h62khEo9jsv+nGqwg3EMQdHULwkuek8t//mUUajOyw7eAXL1pI3jwNPN9t0xEa//2YAusUgvwtrEUdR4Fw5r+U95eN/Tn5b52UU0WDiRHcxtJdIkPHO6e4Xy9b6mJ/m2ILrOt0A561eBYAEg0NJIDPMgzNZ4hYV57QMaQ9dhRofVSJOrgBCe27gFhvz5yvknqhILmhZjBaiMiIhrgFyepy7F9gKdVpJzqcDBFgR+Llw2JHmadsyfPmoBJFg8isOzzxOu/p183mtPYphowW7+mz7T2d8hPFqkIQdHEAP6k42nWO6uSbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TMeFXh4swRAo0AkCXnyNFqKLfvIuezw4vSjpEZi/vDk=;
 b=F12KpwdTPEWvFCEpBOsTjApNF5P6Q94sN3LkyhmGq+yKU2VeAf/6zerB2z2oNLPNTn4C7yGRlGklYdtiZJxglA/1WGkmP9iR0STQkkJmpKs/6UaqikIqv/braf4QGyz5ZUFy3aerCyzbDctXsWKSx3pqPjxOiHNK78v9F9gd77Oky2uR950l7SImFYUORwFlDcLbclQyXwSIxCYlXeeazre9g9UVF9d84+jX3mqxaGU+OPxZvd2VffcquVS83HxWhPGMhStZxh96qW23rE3P45YojKO0mRNLzPBwCHHiQBX2SlR2Lj/CjUgWkSHEzziX6sJZw3jTr4a9a2luo24Oog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3626.namprd11.prod.outlook.com (2603:10b6:5:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 16:14:39 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 16:14:39 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.15 3/8] ax25: fix UAF bugs of net_device caused by rebinding operation
Date:   Fri, 15 Apr 2022 19:14:17 +0300
Message-Id: <20220415161422.1016735-4-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415161422.1016735-1-ovidiu.panait@windriver.com>
References: <20220415161422.1016735-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0202CA0009.eurprd02.prod.outlook.com
 (2603:10a6:803:14::22) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec3cf394-45cb-4a62-b687-08da1efb0af3
X-MS-TrafficTypeDiagnostic: DM6PR11MB3626:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB362674B46EE6EE1692ADA447FEEE9@DM6PR11MB3626.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: exQPSLrcBQJJC4D6H5DTJEthf3vHN+9KIWbFK+O864eX1sOkhYXMlbzF/+z2aRYmhza/44lVHUlyd+Tu/9ceQmDQDGBAiDAJfdS08C7uWxIy/KkCBs13FaE27ptlPk2/M8Yv8AGn0wVKcbFH6LrzGYqh9ZZJQ8QC2UbPlYfodzQ/BC+qJf62BkiUzM96w2ClEsajl/VuORCGuDxfVloRCXBYUIjKrie2jQSk2xoWx5METDz0xgsGHirnNN4V9h0qgaAW8z+RufniYy9TyDx9d/dfP+yIWHjnW8BzfwE+3mZhPP01Rl3dX42yAoLTdM0R6dsf9iPGKRwoYQbQCOgDeBjev/VIbEUAj/wPTha95jfqrX0MmMWi5p7DlcYTxz2evA4VmyJFbxzg1pgDMH8BbtR/YDvesWAdr7dm3o7L0uVojmE5oJa3HDn95TpPN6DoLEjgwLwlAlQESNkQW0758brHkB3Nvc55JLiASNtIC8GCpj1n7a0QXdfpeRH7iTTagKMNVlU6oc+kcZh1wh2jGzCF2yH05Su5urKlN1RR7Oj5OIDlkvNSqyfOBDXMakQgvd7i+Czn1oBLu0vExUCaMSEL+1MyKHL4l3tdJ6ieQrIwJkQRofYALetAgD7RGkbwCnHG4PsiSoJVZHYbTPsfCFgl2dkG/Wrubk/GzDafKgawnIFdk7Sd9ax9qhgoGvFa3jKQ7ki+42dnBzj1W8euHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(38100700002)(8936002)(38350700002)(1076003)(6506007)(26005)(186003)(2616005)(6916009)(52116002)(6666004)(508600001)(6486002)(6512007)(316002)(66556008)(66476007)(66946007)(8676002)(83380400001)(36756003)(2906002)(44832011)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zIYHqrKB9AirIv3wvD08ttaSov8ciNGN/pAXvBWyzLulWfRcq85/t68Zfrwv?=
 =?us-ascii?Q?ffcsW49dcTJ3dzsNrNHuVUvB/u2ZAZLjoPzQM8Wmpx+2NjTKDVAQkBafK4wC?=
 =?us-ascii?Q?KcvBMgbMInKKOteRsngh1SDY1SHowx7BQDhOmzdEeATY//SaBAMW+7HnMiWI?=
 =?us-ascii?Q?qh4fLzpGqq9lbohMQQimDSS/1dp6ZvxU7IN2iqpHiV+O5ijA5HmstV2iyOaP?=
 =?us-ascii?Q?aX7bqhJUarYIgg8gD5w7d3p9mTvvrseBYXqbPLEH2NmmW04C+hODnf1YD5NT?=
 =?us-ascii?Q?v1I2dXLhX+dQDE9nLnlA5WVo0dZjAkpmETOCfobtr0TMKdbABd2FXUmXghcV?=
 =?us-ascii?Q?1g7Jl2Jt1FDIyguZabOWepZPEohlYM0NY44pjzCvY7/Lz0r8hxELrMmVlDtB?=
 =?us-ascii?Q?Koxp3QVsesAooOuorpJ9pUssqgL1P2tjtjNWHWtK+7YhOMPwZ6Uq9xlwyIA5?=
 =?us-ascii?Q?NcoIwjWaxs88bOI3k8fAiXSGowckvCKmcIOkRvK1PdkSb3CKwcDpsQyd5JRD?=
 =?us-ascii?Q?KoOlP4SfO1UaLKhrX6h+6DPf+sPszlN4yh3a+v0Lb7m6adE6Rg6jiBCqBAnb?=
 =?us-ascii?Q?DCa8zRJHzpzSYbFVR+rg1mC4evRLE3l534NsEbaGarDkCz72xfO3Ziy8OFDy?=
 =?us-ascii?Q?QPdrrKgAU0353+tfRctd59/fW/27CY1rUISy01PoMO+lWVyd6iLEVpCJdzHz?=
 =?us-ascii?Q?DuStK++rs7rtlLA2yDQVknWRniOvPMrAHwjKVmxr93vre+5LgvaNKnnowXyC?=
 =?us-ascii?Q?QDt5zFeuWjZYrPDBbjPGB0PDNLzzCMbv0k8GNF1DaywNJsXzoYEJkfSBKAkA?=
 =?us-ascii?Q?Pemu7cb64Xo2W6QIBki1EYXojVVQjxyu/JaQEhHsjZuisFGm7eWdxYfEkmV3?=
 =?us-ascii?Q?JtbFyzUk69+jbes/wH8hDMUlXHyI8weYo4IYaGpzbWHdg6IixLht4uXNptGl?=
 =?us-ascii?Q?RZ7vFiK+RH9Ii3QsATWKECj2EDGwEeebmZ17hnOhNGUT/Ek9CF2X8CtDbQ1Q?=
 =?us-ascii?Q?fKSUt+sI/itGnCBlQ+y968CeL6Q6uz0nC4Z6sH5+mJ7EyqwuPS1dOcLRvXKm?=
 =?us-ascii?Q?Tsht+xX6rbtOGGIazZk3voWMbHtksEqOE84NA0k8VoSS8TsrgP0h4945wE12?=
 =?us-ascii?Q?GHxuRftPRchmyFZR8v5uqPs+E6I4O1xVoEcKhk6M58ALMA0E7UWt1jgbQlgg?=
 =?us-ascii?Q?emrp+URfi2EY62wIc3G4HqDHs0ug7q1hTXMxdR7H2/xq5KcSdhVYTjcg0SWN?=
 =?us-ascii?Q?RVHQzd/BD/nzGNbnDs4XePGd2k0qNxDNi7WKqhrvtxc/sEcp3KxN//eI9lkw?=
 =?us-ascii?Q?6SQVOjIHmraKkOyupJ0yNnqOcvGqIJWHOh7ocbIZ5QULUxq5QzOXTPw5Lz51?=
 =?us-ascii?Q?ETGuEPP0oF5ukShfntZFwDs+hGUy14lWlfm2wM3aIM7e8WOM56E62FEYLSu8?=
 =?us-ascii?Q?pA08Ql/KS9aZRANn128dP6YK4xf78NM1gH2dNVZsUpchV9Nt0F8zYoAylsXB?=
 =?us-ascii?Q?Ae3A1wQcHHck3dqbq676WCbsYpXKFADr4GDMuYnvx6FqJPKbkpmqGsV6oLLp?=
 =?us-ascii?Q?SCSwiY2ZIksWUxll0mqd4bxevoUbprjJHr/e/OMM3HVqyF0B9FuuZfJBgdRI?=
 =?us-ascii?Q?Ua3RovDSLmTICqp9kQrekD+wLW+MmOH5aE3clE7Ul9UOSeqCu4jHs7cdzMtA?=
 =?us-ascii?Q?GrZX49MU+PoYBetM1Vt9eR6jBiPMCWYPbSHoU7FQyRmaZ9QJ/pMreRY+dzw1?=
 =?us-ascii?Q?WoyW/OMmR5AXGve0S+Woj0q+jF7aLQA=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec3cf394-45cb-4a62-b687-08da1efb0af3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 16:14:39.6652
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s81Pb/8l9ef4h4C4jZuPk+0rS7DqfXIxyUPulTypDEjDsbJvyNo4/sb6LbHmFVYb7pgdh8WGD+hJjDV1+2xB5V+aMUE+1N0KYYnfroGDnvU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3626
X-Proofpoint-ORIG-GUID: Zq5h00MxIQ2MSnP2UbRux5zt1-pCxJnI
X-Proofpoint-GUID: Zq5h00MxIQ2MSnP2UbRux5zt1-pCxJnI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_06,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=596
 priorityscore=1501 lowpriorityscore=0 adultscore=0 impostorscore=0
 phishscore=0 malwarescore=0 clxscore=1015 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

commit feef318c855a361a1eccd880f33e88c460eb63b4 upstream.

The ax25_kill_by_device() will set s->ax25_dev = NULL and
call ax25_disconnect() to change states of ax25_cb and
sock, if we call ax25_bind() before ax25_kill_by_device().

However, if we call ax25_bind() again between the window of
ax25_kill_by_device() and ax25_dev_device_down(), the values
and states changed by ax25_kill_by_device() will be reassigned.

Finally, ax25_dev_device_down() will deallocate net_device.
If we dereference net_device in syscall functions such as
ax25_release(), ax25_sendmsg(), ax25_getsockopt(), ax25_getname()
and ax25_info_show(), a UAF bug will occur.

One of the possible race conditions is shown below:

      (USE)                   |      (FREE)
ax25_bind()                   |
                              |  ax25_kill_by_device()
ax25_bind()                   |
ax25_connect()                |    ...
                              |  ax25_dev_device_down()
                              |    ...
                              |    dev_put_track(dev, ...) //FREE
ax25_release()                |    ...
  ax25_send_control()         |
    alloc_skb()      //USE    |

the corresponding fail log is shown below:
===============================================================
BUG: KASAN: use-after-free in ax25_send_control+0x43/0x210
...
Call Trace:
  ...
  ax25_send_control+0x43/0x210
  ax25_release+0x2db/0x3b0
  __sock_release+0x6d/0x120
  sock_close+0xf/0x20
  __fput+0x11f/0x420
  ...
Allocated by task 1283:
  ...
  __kasan_kmalloc+0x81/0xa0
  alloc_netdev_mqs+0x5a/0x680
  mkiss_open+0x6c/0x380
  tty_ldisc_open+0x55/0x90
  ...
Freed by task 1969:
  ...
  kfree+0xa3/0x2c0
  device_release+0x54/0xe0
  kobject_put+0xa5/0x120
  tty_ldisc_kill+0x3e/0x80
  ...

In order to fix these UAF bugs caused by rebinding operation,
this patch adds dev_hold_track() into ax25_bind() and
corresponding dev_put_track() into ax25_kill_by_device().

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: backport to 5.15: adjust dev_put_track()->dev_put() and
dev_hold_track()->dev_hold()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index f8c39ccd03bb..1235bbcc7953 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -98,6 +98,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
 			s->ax25_dev = NULL;
+			dev_put(ax25_dev->dev);
 			ax25_dev_put(ax25_dev);
 			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
@@ -1123,8 +1124,10 @@ static int ax25_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 		}
 	}
 
-	if (ax25_dev != NULL)
+	if (ax25_dev) {
 		ax25_fillin_cb(ax25, ax25_dev);
+		dev_hold(ax25_dev->dev);
+	}
 
 done:
 	ax25_cb_add(ax25);
-- 
2.25.1

