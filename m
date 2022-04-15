Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E3A502D8C
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 18:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355764AbiDOQRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 12:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355815AbiDOQRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 12:17:43 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FBC36B60
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:15:14 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23FFwNBH025644
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:15:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=hpMAhMdyZKcVu89I7/rQv1Sd7X53j97dUwN0OiS+DTk=;
 b=ICOynKd0pQwvZZXImxST9nC4QAACAc+viHHlGBxbfxj0StyENzPmL4cOHKeFUQNPgVL4
 8SYZotOZGzsShEmoIMxETb3CUVj3IuknuD3jfDlYWP4kfgcgVo49a/vMcqE4syDwO7bA
 2+1PR8HMt23JChBa4AxFZsSBZlyS1N3oK/iUjJjdu09E3UBcJcEEVI2tEuZckR3Dd3P9
 yqgi447yIMeBvXGJk5/LB4mPCwLF8AqLTSfgiQGMMPpLgZMUtbALi/kDKix1RBTiZWk2
 YeMgScQhhGWvF/LCG5q1Sb2daVte46V1nKN8P6ks6p0cXWMOJSIo70vZwrXk6Djg+NuD Ag== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2040.outbound.protection.outlook.com [104.47.56.40])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fc0jec5hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 09:15:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YC3cG7tesr8nzB4YGorM7H/Lj63qh0P1y48PVE7mbiSs2nisnnKJxgfNtDF8ToaPmfvLqYNEvWu9vS+IpmLaZuPE+01fV9RfmOoqNj069mo1typ88icZw8Wv4ya+P4CWwWkyyD1l7bCtI61wJGV9w7F4asdBSWVd8RxUQ1JyDq+c2K8De44reoSrnr2c8LpBLX1VOPhfNEeZ9mJE1xs72FAAtP/ITBDTSKSfeYF+PPLuwUE02+o1/ucg1ImBjyk5FvNARbCLXSN61Nn6AqZfZRZXNsTwHfty0nEd8/7badRfjav/hDNIMtpVEl3dtxBYyBLamvhfWKgUwkzLml3q7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hpMAhMdyZKcVu89I7/rQv1Sd7X53j97dUwN0OiS+DTk=;
 b=OUJDEg1Ns54/tO2AFCWzd2/qh5HsT8+hroL+9xM/bjGB/24aopCL6xipfDF1dKJthwPhCFZ+RDOuX5Tg4y8nEUkzmZvIcDC6gCF8sLPUeMo9WHvQKgx0wCuf24qAru2cT+gS+tUnMaZFA9sRKzEOUwvgrPS5RmHWPwkWbcac71Obx1JdC622ONvSA8+VAjvGR0+x0I39QIhm9bSfza3i0Zm8tcwooZKOeAtgKkRTJlQvAJKeeZtO2f2ikmXk4LIer90VvoVzbW55Yde8HbYY2TOXz7mGmFPFbKni6pCLrt4YsUJ4Rzv9kB/+TTvq8WN+wX92VPa+qjuw7+6hchVj1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3626.namprd11.prod.outlook.com (2603:10b6:5:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 16:14:42 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 16:14:42 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.15 6/8] ax25: fix NPD bug in ax25_disconnect
Date:   Fri, 15 Apr 2022 19:14:20 +0300
Message-Id: <20220415161422.1016735-7-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: aa4e6fbb-02ca-44c8-1e15-08da1efb0c6a
X-MS-TrafficTypeDiagnostic: DM6PR11MB3626:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB3626A94D1245F5E5CD58BE5CFEEE9@DM6PR11MB3626.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pLPzFkFbzIttlH+kAzoMiUIdry92qaONVske6Pdsp8PsUQngZ8fNhMlRLh/HO6UspbYgWpDh8vVFetvISjfxJQZ9Dx0ZKBXpVAuYP10orWduN7JCDBl7+8fih8iUiOl8djTWfmjwVQ/6HCHgh/fS8aIJfxNVMJ+x7ldaS5O/egjJkUnprjZ0DKDBnE59fzyoHXeZuRmv5If819csSEtzCeRNY7pXKFNZS4jWW9XH7y8lQtKeC+IQ9MHTgIP7H0H+ayPSc7YbDAlLlrcmCdFwfv756kLNmM58har+npzOI8Y4gEn2M+a1JpiGCoD2EKiJgVt5Cjj+lQCAo5nXHaewB9ElopJzwvX94gZPmCmGw557rCgahLr5atsMe2zo0GfKbZgdPHy3p0Ed8eEvJ88wApCLykbX2mDINNIIvAlbYLgJMp/vcZ4cudM/Ad5HNGQkPHGYP7r8Iyit5ATGlceK4ZzU6HvBDA0mPkKl8aRzoAf6JT9Ww2hsoFt1j0IBspMx1AwVfE4i5tJVQ8IDARFT8CjQGSB6HvFn1QRrfCf2lVC/gLSdfzkElqK5t2LqO64NscjdfhLr72gVXpFbMp/T8jj+n+7gwbpPaxOpfaPTGonSbmY6VuWI/XfjwEQsUB3ltYxLA54Uw+eeHvHKGvGKQxZlUUhsCg8LdzfZhG+U6CKy9DRr/fXNS31OJxPFzbhlQ4dJ0w3e/cS6tN0C8AlQ9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(38100700002)(8936002)(38350700002)(1076003)(6506007)(26005)(186003)(2616005)(6916009)(52116002)(6666004)(508600001)(6486002)(6512007)(316002)(66556008)(66476007)(66946007)(8676002)(83380400001)(36756003)(2906002)(44832011)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lSxi4erlPGxqYRm1Qb0dAXq2V9hr2itzQmQkaDJXHn0uHaKIT2TdeLUQW2sV?=
 =?us-ascii?Q?zWA++FwitjegAbJ8f7S/J8nWysE10leSlypiCYB6u6o2Av3910ibwDjjnJrr?=
 =?us-ascii?Q?7Co2peAgrnNF7c0tRMkbP+Xc2C+Pb+uLlbUzrkG4cj5XvtAPAXFDVeb8D4J+?=
 =?us-ascii?Q?bx8t/8vR+y65srxxLTGm0gMKWOoaHlhNpfZbtiZRoGJrwxxMZMoFBXikgaKX?=
 =?us-ascii?Q?fX2q3Oks9PsdTdg7l4FxoJJcYM7GpHYISzDdCd2YhTGkH/6y6z5S1X+WZEPn?=
 =?us-ascii?Q?vdivq82+Mpqs/grsh2ixJ/SC8UU86OMYWRg4lAMTwPA4WE7jEGbofllBeIeG?=
 =?us-ascii?Q?uwAE4HuxTK+j8UwOGYj2se2oFRdDMF6sTwQBOmElYmUDpQhL616VuDDws382?=
 =?us-ascii?Q?Ot/St166+kCL1JcRs83yIGA+4DmkkyeV7+dheqmHxb8oD9mmG/VSR4UK8t6/?=
 =?us-ascii?Q?a0Z54NKSq0d7N1XiACoMn0UJO2M7NKFXzpJe3eQcPasVcnPegnmSGyFtlCqC?=
 =?us-ascii?Q?8t9J+FinCBeAY2jK0MD8mH4mRsVuTLaHgaY8sLHlTm/PbpHnto7+6rNcn3+4?=
 =?us-ascii?Q?VyrBIXihAfrQdLao67ANB85tTxHPyRSgr+8YGYynJZbtZ8iDf3IsJFyJ5Kbs?=
 =?us-ascii?Q?d74drXCjbLy6hhlgTo/FXRCq3ZsFdctjRT9x2W/VHBbuQMYbuqOi52s+x+bN?=
 =?us-ascii?Q?ZFqQFfM0md5+9U9lojeU7+Lhsiwio9dNor3K8Su1cZPRqm9vDhK7jkwf9FIc?=
 =?us-ascii?Q?S39FiIRjsb9E/puc2jUswfDKlTRE/rQy/+wi46U32MVzskpnwukElZUtEI6F?=
 =?us-ascii?Q?weJKWDeh2kkEPkOoHaWQ4znVqBaYv5X5ZA69c+J1GAEbbvYv1LE8OX9T6Ctu?=
 =?us-ascii?Q?8Ct/QVsmvINg1NucQA0VLcgFyABSXGcA8bhtJU+DGeUmPRvyIYVV6twee3Nb?=
 =?us-ascii?Q?WoTc+hp+h17+koIqHjI9RQhlMvfsUDX7rUkhYkA3zigL83hn8gW/1bxZIxvG?=
 =?us-ascii?Q?pMxi7uaxKIzp6iRI1CV/X6mBfi/4cDZd3GD0Kn0fEmcIzEHn8A/5Zq+9hke5?=
 =?us-ascii?Q?2Rp9et2b4qvZQ6VtAutJhfKYnRUAJJEdtWnAbB5vNJyJez9+iHnBFwRY3qrS?=
 =?us-ascii?Q?/qgPmvOzmYCUUJZJNiWdLuQ6qWpHRTK/WyeTr4rzs+ojfeZxHllcYS9LCt4W?=
 =?us-ascii?Q?sOrNHcQWDvFxnnYIbuskyu3IWLkhhoj2XrcC9gKiEAOmXFhYS9dhizDXWaMs?=
 =?us-ascii?Q?zSXnqP9aYxcsSG6Sok13pdUVLudbaCG/RkS3wWBsoAbKe4N777BtoaocP0bg?=
 =?us-ascii?Q?tJuF3XkjsY0+NJ/wcPswNCOHl1AHyV//qgkiVG8zoqITplCYN4QJtce21LDq?=
 =?us-ascii?Q?1COko1lMuTepx95Zeuzg67yCtg0bk5yUKAArmtmVmiZmqA7VJMAO1k1T1wIG?=
 =?us-ascii?Q?UctlvOUQRZq6OgO/44ORDdhQG/6WzUL8yMDD5Qq6OcAiLsMoQZ4MgFoPU7gq?=
 =?us-ascii?Q?T7A6denSwyhyXmIdugo2yF8K8qg3VUpbQOEhYNj44Xgki4b8l1D2TB1vMABq?=
 =?us-ascii?Q?ZrryN3w6SaJOyI2wyjbAqNA02v0WEgONp9C/mFZxPQ4WHLML1DMKwbZYUwQc?=
 =?us-ascii?Q?FSWpoMNMDcCevgCuBVVmUkkya61yUeke2Hse5nGmgOsnJlXFPVJebNPDCfHy?=
 =?us-ascii?Q?iASDYmRYz87TFjUizS+8b4KLuF1827pF+ByrhE1BTxQb3hY1v9p2w5g9ehSN?=
 =?us-ascii?Q?M39Hof5bvjtcYbPYdklFuO74QaHDXQs=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa4e6fbb-02ca-44c8-1e15-08da1efb0c6a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 16:14:42.1189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7sdAj37xRuPKAKiMvx/kGDmJdkK571z8ZNwQXVhB4U7vCr6VX1qSs71CfUMm3Pdt/9cUuGV5y5eT/7yColRVjH9tcfSBq/U3NYD1EwD8EXg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3626
X-Proofpoint-ORIG-GUID: ArOSEuy1zYo7tdzNFYL3FYksJazzKJrK
X-Proofpoint-GUID: ArOSEuy1zYo7tdzNFYL3FYksJazzKJrK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_06,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=883
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

commit 7ec02f5ac8a5be5a3f20611731243dc5e1d9ba10 upstream.

The ax25_disconnect() in ax25_kill_by_device() is not
protected by any locks, thus there is a race condition
between ax25_disconnect() and ax25_destroy_socket().
when ax25->sk is assigned as NULL by ax25_destroy_socket(),
a NULL pointer dereference bug will occur if site (1) or (2)
dereferences ax25->sk.

ax25_kill_by_device()                | ax25_release()
  ax25_disconnect()                  |   ax25_destroy_socket()
    ...                              |
    if(ax25->sk != NULL)             |     ...
      ...                            |     ax25->sk = NULL;
      bh_lock_sock(ax25->sk); //(1)  |     ...
      ...                            |
      bh_unlock_sock(ax25->sk); //(2)|

This patch moves ax25_disconnect() into lock_sock(), which can
synchronize with ax25_destroy_socket() in ax25_release().

Fail log:
===============================================================
BUG: kernel NULL pointer dereference, address: 0000000000000088
...
RIP: 0010:_raw_spin_lock+0x7e/0xd0
...
Call Trace:
ax25_disconnect+0xf6/0x220
ax25_device_event+0x187/0x250
raw_notifier_call_chain+0x5e/0x70
dev_close_many+0x17d/0x230
rollback_registered_many+0x1f1/0x950
unregister_netdevice_queue+0x133/0x200
unregister_netdev+0x13/0x20
...

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: backport to 5.15: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 7968696d78ee..df01f790a34c 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -102,8 +102,8 @@ static void ax25_kill_by_device(struct net_device *dev)
 				dev_put(ax25_dev->dev);
 				ax25_dev_put(ax25_dev);
 			}
-			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
+			release_sock(sk);
 			spin_lock_bh(&ax25_list_lock);
 			sock_put(sk);
 			/* The entry could have been deleted from the
-- 
2.25.1

