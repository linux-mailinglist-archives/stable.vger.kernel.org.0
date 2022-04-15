Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E98B502E6F
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 19:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343671AbiDORws (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 13:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343900AbiDORwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 13:52:25 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31E15575B
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 10:49:55 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23FHmi5D009434
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 17:49:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=jR3UYk3LFNCqnZzGMIu06KF81R1/ARZcfCfpGQXguJQ=;
 b=WvqNrSD9T/QtsBHKFMCi2cG21UrFBkyiZvjqqh1lgQSSCYkuqNJ2DMoxuJDeI3FpdTwc
 4PzN3QqHmKgccHZ1PGnj2YQPf2vFoEC+CIv3CHLBKUyejN7sGc43vIYzxKqapdEVF7De
 rSjOd78ooiX4Dey03TwBeNUAppM+ALcohMr3/FnL9pA85b25cG61d9pVwlUw7niWQwU4
 3KgOHrWyqH98hP0IAbY7khXzXtX2KKccAFrG1FlKjSMvY5UlH7Db+8Tzj7H9DJP9Lb5V
 5egZJDug0Gp0plTPoD+Ik0kaOSZYvmRsyAvVkAxE8i26yZiTQ5Q2MGhLH/J09KgdZf6a JA== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb66evw4d-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 17:49:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HcqEcZHXaZBOQTQxZlLa+vTGMqLazfGANk6R2tvf9uIkv9pfxEeO3DPiOy+AALdW/OJjbtF3B+7SBv8gEUmxIeZhEe9aHCEokFGKbEcf2C3kzfkujwmkh+sJae1iXr+ECTLp3UGwqB/b0XsWzY+8gVpjspTLC0D7TXBMlEtXszZ9Q3DlfBq8XiP1D0/ZTzyVdWpY43vin0yJdgV3bhI3SX9Z9lzMhk+oQqVMoqx0pXj6xRkMxSOGIj7ClgVyezvOIJlfqz+AoNPP/avTyb2yMrwhWeRMuZXyORY7aHC/PQ9fnCBrEu8iiZFV/yubrFHkSgcMGOXgtfDX8QZnbHKR5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jR3UYk3LFNCqnZzGMIu06KF81R1/ARZcfCfpGQXguJQ=;
 b=biEZxlaq/THUCt8IwdMJ/ZjnbQ+yi5btUHAkkqJR5t/f9iFoWklCDgaqDgurQ6G9P2OyPDG/25y9hwPGUahlfg0+lHamHuR8/dfs6pt2xECLmtwyixX4aK26j+zo/u3Wz/sAaSvxXqcICo97Ety62jzTlFTSeZnoL+z/l27nzuoON2g8orG5r1I2n7+yBehEY+aP/RiOaf+dRUo7bveZNxsEYubcRmAV33wqIG+L4rckAqSpJWSHG5itH8/KWGTvcGA7GloFkUFb41m8+DH6dZPE++jSCKCNtN/ywStqMX2hlyn70/8N3kM80bYKGJV9/1tuxmSJiTkzg4YebY+yKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BN6PR1101MB2290.namprd11.prod.outlook.com (2603:10b6:405:4e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 17:49:51 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 17:49:51 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10 1/8] ax25: add refcount in ax25_dev to avoid UAF bugs
Date:   Fri, 15 Apr 2022 20:49:26 +0300
Message-Id: <20220415174933.1076972-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0217.eurprd08.prod.outlook.com
 (2603:10a6:802:15::26) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbb37616-e657-4bbe-05ed-08da1f08572b
X-MS-TrafficTypeDiagnostic: BN6PR1101MB2290:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1101MB2290A04A00B9750FE14AFB19FEEE9@BN6PR1101MB2290.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /WcLpJ98HkkR+d9mqSOWBA5sBQizs1lC70myiDxMsylpgcEk5yN4H4L7U7SVA/C9XjeMtND1XSWa8Xzno/EEn4GSPDEr2fLGb2EGOSHw6TyzdkrnMU+VaefYp3L1iaia6Of9xPPyk7NNP7RvAO1eIYKMAlp974pDQ2dYD7vMR6wk+nkxHw9UoR3pakaU2jvuczhZLtuv/t9gz7fGhAWiCiRv0GFuuHUl/CpGjratqoWwbkeqeTYtp9Z3gV5LH+iMswKURnChTUHQZkvrKMBNibHl04USg6lcvs9SqTEKbX1qWlJIunF9YzwEedAyFO/lP4FVnmjiwVne+M31TMe46IotCPikYU2El+aWJK/L4bWyVsaY+n96b5lbBJ+oGKxLCQRtE7kCZJt4ZFc4EeGvZpUHNp3xEDncWIRtA3M4H8mxBBNkR7VDNrceUa1Dk4a7pFtx+sD4pfZaOlzJdmk/hJAeh/AkizTlE6/rRI3nYQwAFkN1RBdJnZTR5Tb22KVZOJ97mrhlUbOPmFWU4I2jh9f/VAwpNwrI8CMhbtclHOi/gJZ4vpFmuASA6uUdkPrE0ZQJXADQ7O5FrJRleZoO6BkqfPvQN7BGn85ryqDsYWVRcaD+JGcZ4nIcwOncHjIUJ9BnKXZuyB4I1abFNZOiMC1m6bVxWqQl0e7oRmPN9yL+X5TAE5fCUlo4HftBSkZ9W1oB2d1WYDg5HB+TpBhSnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(38100700002)(6916009)(186003)(5660300002)(83380400001)(1076003)(26005)(66946007)(66556008)(8676002)(38350700002)(66476007)(6506007)(6666004)(52116002)(6512007)(508600001)(316002)(86362001)(2616005)(8936002)(44832011)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O60R7om0PKziXrvKf2zRd2KlV2N6q49lBGJj3nDE9UmE3GkeXs6c0wWHvTHG?=
 =?us-ascii?Q?7IpqdXSXQO69nd7MF4o3mzDL2YDuIJPpQMIBd2cIh0BA8wWb8SsGjhLel5Ai?=
 =?us-ascii?Q?nELiZpw4/7v61EiRzPlCEPhF0cij166jXIKlxmk0eFsBJir+w8CY3BEqmXjo?=
 =?us-ascii?Q?gal1O5/B/gdkmzJ2cZK5krBwAgEB/x6c7HN3u6acELYl3Bz6y1V3ZFXIFrNh?=
 =?us-ascii?Q?10anOK9o5FAybcujOTeyTl/EckR8VgIrzDkZbWI7gohlDjZKgWIR2Ggt8SH5?=
 =?us-ascii?Q?6SZdGsdnE9hvBH4C/U7Sf/sPQBkmdLwKjkKOM93TeO2hev6983YTmI8quPoE?=
 =?us-ascii?Q?bzsWnz/Ohtjs3cJGWxW7n4c+eo2PRKqsJojJQzjeWqtRERrGfSPEzVLRx1XR?=
 =?us-ascii?Q?tQfgFwHHpKMVoyxnvXpJj7dcvEpSJOnyeWdZrslia1NOB8O9M4lByzk21cFy?=
 =?us-ascii?Q?wIghmYx7lRz9flC8vzTdeU3hw3PYkVnNMGOTWbpQG6IF7KoAV43nkaBmwWhM?=
 =?us-ascii?Q?8/L8tg21aWmA8ExfzbG6pdpx6xD70boCpd2mOe92GlIsIqEMop0sZF2oAzTy?=
 =?us-ascii?Q?Vsbbrycyjq3GGEr+kK0var10MwoVIqjLCeff4YvZTfbqhUS65vTp5MVgOfiM?=
 =?us-ascii?Q?juKmWrGul2/s+J+SN81j9CHg+tG+rSHhDrpe3G4/CJU3mmLcLAdyJX1uVXje?=
 =?us-ascii?Q?ckLpUJoT5h1Y8zkbwOrazVeMUe01U5c1sveKeNh4D1Vld4t9FoJZH/iPcJ+d?=
 =?us-ascii?Q?cEEWMcDaNVksDRv6ly298OuEoUiG16As27/q8ahwNtgEe1EtjbRb5X6vKG1g?=
 =?us-ascii?Q?BtBV7Iaa1zsUlFzDZj8lASNgxP/t9b8N5aywrlVX1hoc+7z64kOAok+V0JGz?=
 =?us-ascii?Q?bEL7SNoX0uaN0OZAq0VDz88kyArra0hPFR9CHbKtDvDaHaeWrOqjTrq1L6ZI?=
 =?us-ascii?Q?Fq9WBdwv24Z63hj0jU0fhiVQUuEe9nHE9Ts3se/bZ5DzBL/MvLfsbnqt1ztq?=
 =?us-ascii?Q?9+F/bGKzBErRdBV1/t9QaxAVimxXn962y+RVZWf9ZMKJTvs7CM8wtaneyUc3?=
 =?us-ascii?Q?+SwtIzWGdsZM3MSIBkPkuvFHAeItIiaUYp9YYDOtE0jDRRTSEh/1hfBbNwak?=
 =?us-ascii?Q?VQs80KIt5DQzwXYEOnAOhE5dPbW4YaVIdtxNeWbj2EIsyewpI15BoUy11d7s?=
 =?us-ascii?Q?++VuCxgxiXxrVP57KnsRMZYtugVRA3P2aryGXvNHSrW2gbz9ZwkYTABbcorH?=
 =?us-ascii?Q?HSP5c02xcF0baB0SP/KWqaOKAeJRH7P0d2e7mUqAjgg3nemOVPiQQyAAmlbW?=
 =?us-ascii?Q?lMQNz+FHTiZUaFlj0JajZstzxUYcZognWv89YNzNDD/esg8T0WWFOW5clo/8?=
 =?us-ascii?Q?G1hdLZu7zInDiKM4tYo1OB69lrG3h1zJFMb6FnPuiX0ZzpJYigHLZicxviSj?=
 =?us-ascii?Q?CtwrH8TbweYzIqrLH0In1PouT+FocBCQlOyNoZN4ZUKPJ318fupfMdotAzQo?=
 =?us-ascii?Q?gNZud9yv16j9TK/3A7Idath61nE+R8a6knADusMGJ0DrMPNjph2I5L0eUJwF?=
 =?us-ascii?Q?fQZj8c8LIie0NmFqZCcpaD51zaGGQbjyAb6E4Vd4faa3SA0aReQJC5nwzZdB?=
 =?us-ascii?Q?QbfkTjrOSCViCeri4rHDYMnPMHtn4KDqZ7we+ZMMfOkA4aZUIWyycng5yi26?=
 =?us-ascii?Q?IP1bdN1rp1qvviu+UbwPl4lkwdlOaOvd8VQkAVOl7Nf5g3f68WlL/FPP834I?=
 =?us-ascii?Q?SLS5knLoRdwc5UwVoDbbxxNXBPX4m/E=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbb37616-e657-4bbe-05ed-08da1f08572b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 17:49:51.0389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D8ozvvrYyLMmEc9YdRr2mu7KxtGLCc63VeZWONfMPMLDA1dXaBu7ixUTv5xmbzlJcsYoF8/LpnX3zouV06S6hCecqtYQl0ObqN/qPuU/+XM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2290
X-Proofpoint-GUID: Rs_yUKpEgSu90TINV65UICuuTUwW63df
X-Proofpoint-ORIG-GUID: Rs_yUKpEgSu90TINV65UICuuTUwW63df
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_06,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 suspectscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 mlxlogscore=786 impostorscore=0 phishscore=0
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
[OP: backport to 5.10: adjusted context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 include/net/ax25.h    | 10 ++++++++++
 net/ax25/af_ax25.c    |  2 ++
 net/ax25/ax25_dev.c   | 12 ++++++++++--
 net/ax25/ax25_route.c |  3 +++
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index 8b7eb46ad72d..d81bfb674906 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -236,6 +236,7 @@ typedef struct ax25_dev {
 #if defined(CONFIG_AX25_DAMA_SLAVE) || defined(CONFIG_AX25_DAMA_MASTER)
 	ax25_dama_info		dama;
 #endif
+	refcount_t		refcount;
 } ax25_dev;
 
 typedef struct ax25_cb {
@@ -290,6 +291,15 @@ static __inline__ void ax25_cb_put(ax25_cb *ax25)
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
index 9e0eef7fe9ad..7da36517d4f3 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -98,6 +98,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
 			s->ax25_dev = NULL;
+			ax25_dev_put(ax25_dev);
 			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
 			spin_lock_bh(&ax25_list_lock);
@@ -446,6 +447,7 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
 	  }
 
 out_put:
+	ax25_dev_put(ax25_dev);
 	ax25_cb_put(ax25);
 	return ret;
 
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index 4ac2e0847652..2c845ff1d036 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -37,6 +37,7 @@ ax25_dev *ax25_addr_ax25dev(ax25_address *addr)
 	for (ax25_dev = ax25_dev_list; ax25_dev != NULL; ax25_dev = ax25_dev->next)
 		if (ax25cmp(addr, (ax25_address *)ax25_dev->dev->dev_addr) == 0) {
 			res = ax25_dev;
+			ax25_dev_hold(ax25_dev);
 		}
 	spin_unlock_bh(&ax25_dev_lock);
 
@@ -56,6 +57,7 @@ void ax25_dev_device_up(struct net_device *dev)
 		return;
 	}
 
+	refcount_set(&ax25_dev->refcount, 1);
 	dev->ax25_ptr     = ax25_dev;
 	ax25_dev->dev     = dev;
 	dev_hold(dev);
@@ -83,6 +85,7 @@ void ax25_dev_device_up(struct net_device *dev)
 	spin_lock_bh(&ax25_dev_lock);
 	ax25_dev->next = ax25_dev_list;
 	ax25_dev_list  = ax25_dev;
+	ax25_dev_hold(ax25_dev);
 	spin_unlock_bh(&ax25_dev_lock);
 
 	ax25_register_dev_sysctl(ax25_dev);
@@ -112,20 +115,22 @@ void ax25_dev_device_down(struct net_device *dev)
 
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
 
@@ -133,6 +138,7 @@ void ax25_dev_device_down(struct net_device *dev)
 	}
 	spin_unlock_bh(&ax25_dev_lock);
 	dev->ax25_ptr = NULL;
+	ax25_dev_put(ax25_dev);
 }
 
 int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
@@ -149,6 +155,7 @@ int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
 		if (ax25_dev->forward != NULL)
 			return -EINVAL;
 		ax25_dev->forward = fwd_dev->dev;
+		ax25_dev_put(fwd_dev);
 		break;
 
 	case SIOCAX25DELFWD:
@@ -161,6 +168,7 @@ int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
 		return -EINVAL;
 	}
 
+	ax25_dev_put(ax25_dev);
 	return 0;
 }
 
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index b40e0bce67ea..ed8cf2983f8a 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -116,6 +116,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_rt->dev          = ax25_dev->dev;
 	ax25_rt->digipeat     = NULL;
 	ax25_rt->ip_mode      = ' ';
+	ax25_dev_put(ax25_dev);
 	if (route->digi_count != 0) {
 		if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 			write_unlock_bh(&ax25_route_lock);
@@ -172,6 +173,7 @@ static int ax25_rt_del(struct ax25_routes_struct *route)
 			}
 		}
 	}
+	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
 
 	return 0;
@@ -214,6 +216,7 @@ static int ax25_rt_opt(struct ax25_route_opt_struct *rt_option)
 	}
 
 out:
+	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
 	return err;
 }
-- 
2.25.1

