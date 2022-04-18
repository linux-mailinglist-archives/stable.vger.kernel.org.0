Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE17504CB5
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 08:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236805AbiDRGg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 02:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236803AbiDRGgO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 02:36:14 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EE319002
        for <stable@vger.kernel.org>; Sun, 17 Apr 2022 23:33:35 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23I6A5q7022712
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:33:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=gV5vmw/6yiVOIpWWdSl7w2y/5u6WOLg7JY+RHMiWrUA=;
 b=HYAgUgPjUsq/9dMIHTQ105K8RrrNCu7T8C4xsMU0EJCmDNTyAM70FNeagTdMOa1rJoQR
 AVBqRcLJgWupDpESJG/TUwmlRiXIF5qHCD0DmChSYVepUPebOAoRffNelpcCjxQC0n92
 PSbsNFh2369oVNZivdr08ca5q2oEclv6WhJbiucvsIYq1rCrU8bvIPtk9RVniE+r+2+a
 m9Cfar6V6Yl6lYglY4wXD3/ltmYwPlO8aGp08CGvWGRhj1p8i/he4PhU+nXJhfizHe9X
 n1pRbsEyPRnB3UFfLK0WAOWCw7WyOP0GZycdF0UB1XVXBOL6hNwPzdeiy4a48A9EBZd5 Gw== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ffpj2s45t-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 06:33:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jTSIxenkxGF4mBtIlsBKbf60H6rbrMS1R73UNcSEQ4MjVU1yOuOYBBjNcRkC9BgcK2+zoZ+SOEKEeWuaKpjMOOnl8q9yAGTuZUJIIjY2sdeaZjW7Xvb0ROUHpEUm51KtmkJQBNouxI65cVVvElcuv28IEJwMkOKdmQivKXxJiBQ2W0ozW5+LFc8BJ8T8lvK5/QFK11IftEBOGJUt6AxAng87bOlZJyr5/2sn6hzFfhiulJWedHM9gps5QnbefBtO8YpGPeP6l4WcOu6OpLPhtO3imyGN5/fuu1398JcDjo9PRN6wumcSoJo2QnLLDaXnQNBkzqDS0b2ZPypJIQ6vCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gV5vmw/6yiVOIpWWdSl7w2y/5u6WOLg7JY+RHMiWrUA=;
 b=oYzMdztETkPEcTHm18iKIuEEOOWwzwbLVMj5zs6JwddngDkP6jXzvjBDxrh77I5HCJD44EuLqyeC27FD9OC6aCr+bSs9b4m9+es5PE8eAdu1rcD9Cv0qkP836+JrQhIQBbzFWn146qg8k5yoLn+BngwYPSCo+Pmnf7GGpzf8TputqlAmrfeNIOUhpz9PTT7Z/X06boOQrXMkk17LJRc5wV6wCka0SancMvq9t0FN6zlt+4VjzJrzoBHCwlQym+iIMwhyGbWlUl10yTiUN71vV1KRbWZaI9NJdTomLyipdf9l2+Iy+Cg2HE9MEEv9lFoqNnbpFa60oayiK6iEo1RUug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY4PR1101MB2135.namprd11.prod.outlook.com (2603:10b6:910:1d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Mon, 18 Apr
 2022 06:33:34 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 06:33:34 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.4 8/8] ax25: Fix UAF bugs in ax25 timers
Date:   Mon, 18 Apr 2022 09:33:12 +0300
Message-Id: <20220418063312.1628871-8-ovidiu.panait@windriver.com>
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
X-MS-Office365-Filtering-Correlation-Id: a874cc48-580e-4e3d-ef65-08da21055cb0
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2135:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1101MB2135CADCA80FE46BB0172CFDFEF39@CY4PR1101MB2135.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wRKFKAIWVzmPRWSFjnCi+SJ0LHM90xUbRLghWBvXJb3ZUdWdLht2wm6OWesaxWN2/81wMwQqtFb6fzOobmsCTvWGc+Kn05Zpl9kzYKNzEkp1qb9Eyk10Gck26HeJbt1tl715fJdcrb8Dl2mU4a8p2w30xyUm01j79peFPSqvlsuRbxx0gcQ4edTkZ0hLiVOLdoeSWqOdA9KtwYrrJ8lJoagXBGB9EZanpCFfeKicwNo8v1Fo80AYfVOyoO3ZoCUouNbkzr99TID3i1B6PcR/9d8Fa3EYkESKedDYrY39PF73TGRMnslux+hYU2zrcP5iWbiGkbgL9GbZylsT7q0HcT7U/f7oB+T18zpdDsIWl/KmyLGRjN8UOmeyKfJLMGFmLPjOX4kGisHH4u93hovHArBpQP9PkV5NMaleNESXI8SaDEhZiTA2Pdhn1soe+I5FgPQCJc5B1bV3lg+/slSeDVUCkgcATep/EydZ+q4NHwxNqtq/saYaR4U3qtJ7g0k6hVXgjCLaCoGrAStjZ86Ph2QAt6Q85HIUGGP+EascmBjwZydXBBQtn6YTdEPaf3vZwMk99oUUKkWtTE/YvHibQvrBoZnEvkMbRb6uqjuX2sfbWMBA24ojXzfny3DqPbDRyfZOyyoLNB8vf9k9hmQf7qm2AHD85tw4G8Cig36FQh3zVchaGtT4Z5lu4JH2WyWZx2oeHOUeyV4OWUDTye2x4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(5660300002)(316002)(36756003)(66946007)(8676002)(66556008)(86362001)(186003)(26005)(6506007)(2906002)(6666004)(1076003)(2616005)(52116002)(38100700002)(38350700002)(6512007)(6916009)(66476007)(8936002)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?NPRXcJ3Kc+hvt7Py72tevpKqGNEE3ZRJ7oVtRnv+rUKGgtnweRJHAEVNu4rf?=
 =?us-ascii?Q?w/km1Wzvn/zC76fzto8lgV04jetOYQbxQjXlfEkdyG6AKyOzpOFW2YCcD4Qj?=
 =?us-ascii?Q?EQVYjbk8yqu0HbPfyC3a99qz2bjtzgQzWZHzrw9KtpjtAYEIqbUuonCR9zGG?=
 =?us-ascii?Q?TToE51fJXMEZZ6xMRZtokmmgpS9EOAT5ZnlMIo7Wihon+QL5aX0M31A5W9sE?=
 =?us-ascii?Q?1x3zGwmjhNtGdLCFOumr5bGi2lTzRHdmojs2s8xa3F4tE5JH5NV/cJ+/m1ZU?=
 =?us-ascii?Q?Ht3QRMpF1kSucyapcrHznzrSZFmIKGj2Dh/JKgzcmJ2bjLMCG2l03KXdnPkX?=
 =?us-ascii?Q?cg0FQKvjED7fAhKBnUhhO/1nlmFhOIJ+CvPkwfHNlIpYrdXZ2TaJaAmQDCFw?=
 =?us-ascii?Q?CSYoGxSEkAwKePrlpAWi+CYfgKuH3n9aQpTv5abVHbK18uHLHIswsLjUhJAc?=
 =?us-ascii?Q?vwqv9/3J2qd3TzKtrcIZDMP4pH+b+aGkj+4wC+v5mpKaccU+VauvqroN9009?=
 =?us-ascii?Q?g9C3zB01qa++Rwd4OISlkJ2B9vmdlsC2c/XXyKnQHjTaSX8xAobMWIgB3B9V?=
 =?us-ascii?Q?DKp1LPOpbPGdvRMqAuk6jDMXNtpZbkHMEIfbPpcuA/zNgKvz9TAB9aRchnSp?=
 =?us-ascii?Q?ml6HhluGOjwRCT6gujYMNbcq2RDMMdgPH/5q2cB/FuCfIQ8bAixNr0LjUI1T?=
 =?us-ascii?Q?baxh968I2FR2aQ3vhV3bw9cSHQKgPGeV9gubuBbgJHGF8fU4xXCkfTZR9vNz?=
 =?us-ascii?Q?woQDcmlZ4E7IQuofGBUeDbNgDsw26rFeMEmBMxW1ZfFi4SdvddTnTMTjAcLX?=
 =?us-ascii?Q?Sq/ITp67MkwfDmklyrIeoXDv5j77NBFucYSUArLqpsqR7baYAkAqyH9mvwFN?=
 =?us-ascii?Q?xcjblGNcZHJ21FgK1pdkd1qFF+GbupSCuUyQr1R4uE5D7DVWE/x5AeUPPrbz?=
 =?us-ascii?Q?wo8Qw6tczP6S3akbfqS8I/SmfMOtslVWh5LQGVBsA2Ep0IIGmYLb86CeZaIz?=
 =?us-ascii?Q?hRhrwiwR8T5IHxZFOWVQlgUKRzBpK7HOyMp1hhxn3gUYLQGKqq9aYQKPK7j1?=
 =?us-ascii?Q?85iTtjqPmGkgbFc3gF7S4iFLehshfX66UHg5Daa4k6MufL0GxTlWoMBKIIX8?=
 =?us-ascii?Q?K8AAyiDaVl7Tifr0rWXIimgeiAoF7NUYEo7fdjWbiRUqrkx5gJUBGQ1SVnIT?=
 =?us-ascii?Q?s1gSUFJOlqBpcpjgj+jVvLkrfHAe1Pn/9Kt8lpEvKqkHpLmkEcCciYgo4SMq?=
 =?us-ascii?Q?9BtKqipveKJyGUWJ8i1T5mZojbBdnvyBB7/5hK68Ybn7hmrBeq+yJbvIJysW?=
 =?us-ascii?Q?lgx1QXUvjVGXQyAjgyCjxUPDKLyKyEt5OrvtUa49ObzZ+j1UfmtbKwb7VOa7?=
 =?us-ascii?Q?D+B1Dzvn0rAqoIf+VVLiKA3DKIPFzShYHNIB09qQHzL6V4hM78ETzp+PbNL5?=
 =?us-ascii?Q?YavSWifxExTHVVJuD1zhZ1WiMoBD4qs/sDkDB6ZDwmolGfnINNxHm2cqi5uV?=
 =?us-ascii?Q?FSWRttwkqMKk+FKdod73HhNeTSOfkJ5oIiRmcDLcl4sNrOOnGhAFDOeUT0vJ?=
 =?us-ascii?Q?lNoEZww0tGlr9xScViKCEH82WKQNRzR3i5S4dpsLgAwY4+cvBE8HeEali9P+?=
 =?us-ascii?Q?BZRl9Ix7dOzGyLPlde1iHeA17Wa6llnH8R+MzoDGux2SM7L/AUhMkkfCFCgw?=
 =?us-ascii?Q?/Y7RI2j83g3kyom16unEUX8iKcZS7DL7VYxKuz5Z6z3IrkBMMt8nAiAI7Cn3?=
 =?us-ascii?Q?3dplfVwu4Gg/ij+kH/BlmOxb71emEcE=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a874cc48-580e-4e3d-ef65-08da21055cb0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2022 06:33:34.1405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nErlXskLDwP+GSBbFYO2XNEpYM4GK79v+rT0qizLlLCi6+7kUSkBRBfbf3vfy17RDjxRhJ96J3NozWkoxFAfWUYnuz6v+PZBMZ8vzyn14rA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2135
X-Proofpoint-ORIG-GUID: QWgTdvyZHOqZbEOA1BbNg7mPK30bvgMF
X-Proofpoint-GUID: QWgTdvyZHOqZbEOA1BbNg7mPK30bvgMF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-18_02,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 spamscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=632 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0
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
[OP: backport to 5.4: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 659a52ff92dc..aff991ca0e4a 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1052,6 +1052,11 @@ static int ax25_release(struct socket *sock)
 		ax25_destroy_socket(ax25);
 	}
 	if (ax25_dev) {
+		del_timer_sync(&ax25->timer);
+		del_timer_sync(&ax25->t1timer);
+		del_timer_sync(&ax25->t2timer);
+		del_timer_sync(&ax25->t3timer);
+		del_timer_sync(&ax25->idletimer);
 		dev_put(ax25_dev->dev);
 		ax25_dev_put(ax25_dev);
 	}
-- 
2.25.1

