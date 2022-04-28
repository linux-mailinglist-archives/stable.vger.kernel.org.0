Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 606775135D8
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 15:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbiD1OAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 10:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346899AbiD1OAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 10:00:36 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C538330566
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 06:57:21 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23SDIFVE023542;
        Thu, 28 Apr 2022 13:57:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=X5z+EGd0+KlYipEv0VJhiQsMzCfbtckeMj2AGTP0QfA=;
 b=LA/DSpFQjZ2H/oOtu7vpEJd0JD6qshSyzkZ16qo/3nlQUlIhrlxSpl2olxGQCphqj5NJ
 6qrIMBDzbwfEOzVXO0HVqpnSG8AVUhGLsa5cfSdXwM8/ds5tMp5oH0VZKBEcB6pvelo9
 /HwypoFONA1SlvpjYNKjkqoxfo183phAUIgUbeK4XwY6EWu6pSKwQGUf7vTyXk6LkuNn
 swKGUTQ4sAclZLvuWsotn1aJ57EGVj/BrWFO/E67Or82Q723tGdtPV22f7wiMzkn7sH/
 /aXi/JzjxPCCLcQw16ScLN8cqlLNas1XWRrv51cigb2uXDQDCvd+zfTLUEW1GZiao+5Z hA== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fpske9cv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Apr 2022 13:57:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gf7iN7T8rbF6pGy6JdO/xKBYcqJMOBZKq5NjZDNlpWibYoAUeAqKO51m9Fgcjl6rxldeNxLz1xh0Tn96doXD+tLcaV7DMT1/c1s7YDKWU3/CcVc3uGWAyF9jqAypL7ddJEqPXvgyHJbPomNZH2qBAusxGIFDplCpMcdwZ+XMRbaxlSP4nqGAgbV9Mqj5dWcZdfM18OiNM2NLdlp6jjb+Ti3M17JkwWB4KdxZkroSy8+UmvMTDsGzA8Z6eRVdqcPwGd8dUT38yA6dsuRKbdrAovbjdjcu8EDoMOICjcHz81NLJJ8YqynHHQDizHw23mdgt5RdbmtEndpCp/WQ26WVwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X5z+EGd0+KlYipEv0VJhiQsMzCfbtckeMj2AGTP0QfA=;
 b=ljUgbS4HNkRIib2CTwNgi41AIeEgdqOpWfduO9Zucg9dNwCckbPcNEus2hUljh2h/xnUbOiRHZd1Es0ndiKRwfg8I3PYxpmfsPHN2W9ELWtZkLZ4v0/8khLjmcTW9SvLP4R5p4gC5ba2hAeG33IRa2lzVj2yxFMoU/CEduCghjAlHu1VW201N3fXHyCWMFnFbc2XR+aVq1AphxBe6MmpFYmWWy6biWMdVlAid2u8BilnnseuQojYQ0VXG2BoWDTo/7kwfprDtvth+TIEsmwQCK+I7jle78SAfq/8vxCGe/be3nVkVSkMMtoq3wMNbnN3wmUg/LgH2qs8Ofnj+1W7mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by MN2PR11MB3743.namprd11.prod.outlook.com (2603:10b6:208:f4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 13:57:05 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::806f:3f7a:c1be:ff34%7]) with mapi id 15.20.5186.023; Thu, 28 Apr 2022
 13:57:05 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Xu Jia <xujia39@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 1/2] hamradio: defer 6pack kfree after unregister_netdev
Date:   Thu, 28 Apr 2022 16:56:47 +0300
Message-Id: <20220428135648.958508-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0051.eurprd04.prod.outlook.com
 (2603:10a6:802:2::22) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0745e101-6231-4c6f-4b80-08da291efa89
X-MS-TrafficTypeDiagnostic: MN2PR11MB3743:EE_
X-Microsoft-Antispam-PRVS: <MN2PR11MB3743FC71F07C360323A092B4FEFD9@MN2PR11MB3743.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WqyCyf7HDmVqEs2KRcYksS0vSrPTkvVRBrNnH9n2TGEkORJ2rw/cewvHHQhYJFuBAkgDmkDaEVHi+G8gkWVfFOktjtPcSV+/M8Tr4d+sok3xWeIFZ3tEBnk0h2LHy9bGy2GZEObIRPAQgCK5YUeeQ841uQ12M0zaMa5RhcMqnwQPj6bp6j4rhSMYrUC0tuffAi8qCW6N3cOVMwFBWuCgiJQBAI9fDe+NBZMELOkfnem+pw5fmeE+SOp/P+ucurdYbPW6FmWpHa+bs6hSNjKIHgJK1oKLIvq9mndgNfsenBYVRPCIsaM+bF04ayoYjw/Fb9YJBcWzIrCf9Ol2kPpEdcWwr1iE8HDLDBTlnZ8U3r+05AFamlSufMbJr+c/Ew0qmX2t7w737lG/wcKcZhLMpBiH4jEpxBN/Rw195zs8w9iF3rJEYQoR2KJSFsy3cTN64arwM/w2DS9gMc19hoyC+tPvrXPqguUexqf93FxImcKXdA7JfXYgDYOKw/Bm+9ezhIAsc7Ojt6ETAyTKOHImhwNbs7seCXyNbWhGKng5uDYbwzs2ltpfKDXmRqQ+QKZyYixp6ar2vtrtGvY0ts3hKksMc95yPzSF07TOv/u2bU9rOxfSjnMeGP5qK9xuw6djTu/9A/LtVaTuVmSsFh4luUew5GT1j89LIh8bkUcbPIMprcq+3imU3K46XYzHD5dkKQ8+kEoRfvwN4CUP5alEGdrzCmlzdd86QQfAjzdcTfda0O+22FeQAlcSeUVgqWNCYox8QE0EpIVrfj7PmdD3tYYIORwjBG4V9x9dG/qIfgQwfFuk4Yl3qDCEqsviMhyKNXZoi/MqmkjEzcN+a2itDQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(38350700002)(38100700002)(186003)(5660300002)(508600001)(1076003)(44832011)(2616005)(8936002)(107886003)(26005)(6666004)(52116002)(966005)(6506007)(8676002)(6512007)(4326008)(36756003)(2906002)(54906003)(83380400001)(316002)(6486002)(66946007)(6916009)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uVHUmZvRzLuj9LcMg4Nq8KSQVfQpLLMXXIFk7yg6NbgO49U2GXJhK9L+DNnY?=
 =?us-ascii?Q?qBQDYS1dgwTpBtAaFvWiG5XkZImRmjTokoEbFP74BiXxytDzVpAWaD05Tn6d?=
 =?us-ascii?Q?NSzp10GwEhsy5R4q3DydiAYw+RK0iioUMOjP9KD/4GMPHf33IeWLKMlgYT41?=
 =?us-ascii?Q?SK7Ktn8TkLfbVpAjBVuaCzfmn/fK3FHb3bqFS3f/7zhlMVhN17kmo8I9ep4e?=
 =?us-ascii?Q?ZQRBfWbvv8qxvgDmGC3EEZefyrF66dxLH9JM+5W73g0U8/iSeyHH5v/uA93F?=
 =?us-ascii?Q?0VntZhUNO7XaJJwQeN0GdJ5518ic62adFvMBAAFl2dcHqvFYKGIH7oHagtYh?=
 =?us-ascii?Q?N8UTYNtD7vMVzs5PjybOJ4G1/2COwTOuZy8nBSt+vFSYj7YX0zNwZ9XJ1IXd?=
 =?us-ascii?Q?mYeAsWby9YvFrBfmR8qGpcRrPH8CfXrvBr0hanj2dHQ5krME4w+mWemQaLBH?=
 =?us-ascii?Q?9XDMsYh9fvEc7mvml7XDuOpj+VAx5hD9679j+DUJ3s0ShldHnHslHoue4EHi?=
 =?us-ascii?Q?I4HAQ0Q5X+CyTMMfRlbSOJga1UuezgOgGl6lpP0/HoorFbBrBhN/n/gqslT2?=
 =?us-ascii?Q?StgM55Oo7qpzUb4v7chSy7wD60DV8O5iwRwxJylY4UnOH3d/IxKBWkVfNLxn?=
 =?us-ascii?Q?9w7GVQCn87x/x4SFNBBPWtdYjJgpR2USFmnpAs+N32edKuoS3ucA3aO8m2gW?=
 =?us-ascii?Q?urXw/MynhmW/wSDZnTBoijIR1tmAb1gtXZmsBllGntRJSPfM1rLadGTWe49j?=
 =?us-ascii?Q?XGWmoPmYwg4bobYsuB/Zo3YyJILJQ006nAkOuYO9Zl2ILtcK1dgrpiZ/pQD5?=
 =?us-ascii?Q?2CbM/KxGgw1HTyNOlWmuwDKdcP2HE2KG3pQPtX32eCYbSAE6ETaG+g5ZHLXM?=
 =?us-ascii?Q?jmgp4nrkSq9nIRqPrzYFipB5hniN+pTAh0KMg5fbg4Utl0yoXBzOhSlc+aCZ?=
 =?us-ascii?Q?CapeSohTbCSqDBuo0FBFX6zJMML0OFPrGmOoQRrPiWO0LHTMo47Oj9k+7QGM?=
 =?us-ascii?Q?yYZnK2j+VgaYXuDj7vlbaFwScLfU+gen7QV/khpYkt3nAsKGLzF/c2Zkmr+T?=
 =?us-ascii?Q?oMoJr4KU4g5SAHGnEP4Iuld7kqGhXlul7jsLR3W5ImJxxyA7MNpbE9Y0e5/D?=
 =?us-ascii?Q?jP9wAf8H0y2pHhDPc3CMrxha3nsw1acryHH5qoF0Yu5P38tZlV0U4n0/uqdl?=
 =?us-ascii?Q?LBgzuCMxmQZJqtKULSoPH8a/2pRm7dvnEM0X0XhJ9WI6/NmSiFalvJz0dg4Z?=
 =?us-ascii?Q?ZnZLtw+0svr/XmhSnIdsny8v9xNPvDWqgmqduWTGKSgjEaYZoHfUxeJqinBo?=
 =?us-ascii?Q?elNCV6l4tjhqujCMtsL+VRCt+emcubm9kvWL//4IJctz/6LiHke/+g1CZ2Av?=
 =?us-ascii?Q?y1v64HKLF6mdj9nqyoaMoVJVYLJl4JpnLywdCnABzkv/x38oW14KA02jbGGv?=
 =?us-ascii?Q?mTb+CF1EhSc5fnWgYQ6RvVF/L5thPqUczsyNcH4uAp6MYkbu3+XW0I1+U26h?=
 =?us-ascii?Q?0103OFwFS6OCmql88G3Z1zNz27C0a9Z/SU1v5vmc1gZOJTveGS+PmPNtZ4tX?=
 =?us-ascii?Q?FQl3QoEpSsR54Tq0lRwyyJtPKub4flhL56DTQAcl6y2fDgfKUtG+Att7HnBt?=
 =?us-ascii?Q?AwX6M0bfMoA0sJfqB/OkXR5bZqslOLcAx+Ovq3zx8K4EtOAIFR/jwjpCbD/C?=
 =?us-ascii?Q?Qs8J0Wt9ZRDYf/IslgqKngmUCm7weKTQDvNzRSdaUFIBr8vYHdKPuaDJH/Vl?=
 =?us-ascii?Q?hf2c14y+ETf6EYo6STiN4ifuHTp7R6g=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0745e101-6231-4c6f-4b80-08da291efa89
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 13:57:05.6655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: euDeYYwhvfXX8r1UdzFB2v8b+/+Ls6V3lJlQ9v0KLh0YlQ/TrpY5nUeSMSLaql0pHISSMoU7xnpElojIPLG6FB9oa9X+4R/3Uau2K9ZV9SU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3743
X-Proofpoint-ORIG-GUID: GosL_8cuTvxzqhNGxpgIqM4urP39i3R-
X-Proofpoint-GUID: GosL_8cuTvxzqhNGxpgIqM4urP39i3R-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-28_01,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxlogscore=764
 clxscore=1015 malwarescore=0 impostorscore=0 mlxscore=0 adultscore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204280086
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

commit 0b9111922b1f399aba6ed1e1b8f2079c3da1aed8 upstream.

There is a possible race condition (use-after-free) like below

 (USE)                       |  (FREE)
  dev_queue_xmit             |
   __dev_queue_xmit          |
    __dev_xmit_skb           |
     sch_direct_xmit         | ...
      xmit_one               |
       netdev_start_xmit     | tty_ldisc_kill
        __netdev_start_xmit  |  6pack_close
         sp_xmit             |   kfree
          sp_encaps          |
                             |

According to the patch "defer ax25 kfree after unregister_netdev", this
patch reorder the kfree after the unregister_netdev to avoid the possible
UAF as the unregister_netdev() is well synchronized and won't return if
there is a running routine.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Xu Jia <xujia39@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
These commits are part of CVE-2022-1195 patchset.
Reference: https://bugzilla.redhat.com/show_bug.cgi?id=2056381
[1] https://github.com/torvalds/linux/commit/3e0588c291d6ce225f2b891753ca41d45ba42469
[2] https://github.com/torvalds/linux/commit/b2f37aead1b82a770c48b5d583f35ec22aabb61e
[3] https://github.com/torvalds/linux/commit/0b9111922b1f399aba6ed1e1b8f2079c3da1aed8
[4] https://github.com/torvalds/linux/commit/81b1d548d00bcd028303c4f3150fa753b9b8aa71

Commits [1] and [2] are already present in 4.19-stable, this patchset includes
backports for [3] and [4] (clean cherry-picks from 5.10 stable).

 drivers/net/hamradio/6pack.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 29431e3eebee..381febb99bc3 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -679,9 +679,11 @@ static void sixpack_close(struct tty_struct *tty)
 	del_timer_sync(&sp->tx_t);
 	del_timer_sync(&sp->resync_t);
 
-	/* Free all 6pack frame buffers. */
+	/* Free all 6pack frame buffers after unreg. */
 	kfree(sp->rbuff);
 	kfree(sp->xbuff);
+
+	free_netdev(sp->dev);
 }
 
 /* Perform I/O control on an active 6pack channel. */
-- 
2.36.0

