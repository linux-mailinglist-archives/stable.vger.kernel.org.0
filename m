Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 346EF509DC9
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 12:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379782AbiDUKlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 06:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388468AbiDUKlE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 06:41:04 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233AE255BA
        for <stable@vger.kernel.org>; Thu, 21 Apr 2022 03:38:15 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23L9jIfD009597;
        Thu, 21 Apr 2022 10:38:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=wbuW/Nz3RY31bJFNvC9eGhp7ani8Zh7JRM3RUmQ5n/s=;
 b=ExNN+Yu2PlfsVBxKASuCklQeVXHbfbghnYx96mzo/wStBU4IXbVk05o7LiiL3ITl/Sdq
 lJGDS8lbi5DQSYX8Fj6QX4RtPfp3feZjFSeAc1iX/9BjcyqGw1KkslJdtXwoTMEJwtdm
 bIeUY1geUp3Df4aUjqde5F/XKiwwB7s5PzFc4f+W2L/rxcyNTmS1bIVfeAFL5fRjcoMf
 JEUKYzDFzkUgotknRH/wmlnl2N4IHODIl4/wOKaq0icDSgbgxFQLM2PwV/+DSPzizTTg
 lJKhAq+PYafY+odEHipt0wpGsqXixSeuTf2BrT3u62AXHKPLNq/pnxzm8lCJpMV5BG1m Hg== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3ffpj2uqba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Apr 2022 10:38:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1pHv4T3o9lxOYfOefGJNAvgWjWRoYW0y1FCEuCFMcCuAZuLuehrBaVOx+P4akZl3suxAg5V2gxRSSdL+vyBaFhyCpn9BMP0g7hj4EB1IDtFGKuZeTKrwfiyVvl+WWR6AZ/g2VSs3pqmb1/kU1HJyFdd+7GS3AiZwULNfK8NB8SUAfR2Yn1PeLi2xHeYWBg/+MELdXzhJFy8T0bAbEFOB1L3znIcwBj5sfpGn4TbF0Hpb3PYe6TviBO7pQE2JjYhapUQIjXZZi3sD0AdDJG+lF47+/dFUqHmZxrAolv19VlbK8GtI+VQnoU2ZqxBKPMjAWI+/S8uAkDXipJcsHeL1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbuW/Nz3RY31bJFNvC9eGhp7ani8Zh7JRM3RUmQ5n/s=;
 b=I8m4eM8DVlUpAA5n1IeTpTM/wTcl4QgDIFMI8DhRe0n34QHNTzgZ7dP3gfhM8ov/Sc5bSAO7xpfWvx4mL5hJw3I6gSQj9KUa+tDbMX8SPNHXv+cTg7k+dWGRFJjqdb667XnqIbrBMXO/kyQF2ku41qHCNME/epqwry20gi72rWH9xnQfdwZoK4aJG5ZV/PCoyRYdPzXfCc5Rs31YbxkJjx9hloShSLfg6Gyk0FO87chwfgpO4fK/slRM43i2nDTpaoANjI4C14CT/CprNK5XX/Lz2t/IWMyBTORSwUpIDab6+DXzp+1OAZo260nTZmc92R7+0jPAD5bDWiUHsCiF7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM4PR11MB5406.namprd11.prod.outlook.com (2603:10b6:5:395::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 21 Apr
 2022 10:38:05 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 10:38:05 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     Duoming Zhou <duoming@zju.edu.cn>,
        Thomas Osterried <thomas@osterried.de>,
        "David S . Miller" <davem@davemloft.net>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.14 4/8] ax25: Fix refcount leaks caused by ax25_cb_del()
Date:   Thu, 21 Apr 2022 13:37:35 +0300
Message-Id: <20220421103739.1274449-4-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220421103739.1274449-1-ovidiu.panait@windriver.com>
References: <20220421103739.1274449-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VE1PR03CA0024.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::36) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7c59b75-88d6-4aef-ada8-08da23830480
X-MS-TrafficTypeDiagnostic: DM4PR11MB5406:EE_
X-Microsoft-Antispam-PRVS: <DM4PR11MB540667CFF5CE116A746AD10BFEF49@DM4PR11MB5406.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dvKhaE+eWVaHRg6wdKE74oIlkiHITuHIBdLOcE35ngAiCk85/ZfXE498yDyV2KZvEAgyH4jsK+i6Pxq67gfHq/6MdG4oY+UvS+N06MN3dKN7BtU/uE+FfpuFZtys5x0TifHCfKRtGO+7vmzvK26qjb3VGx9PEEhVFconoPkFc5irKaIYnnLobc1Z3y2QaMD89gYpzmxq4lPBoq1sjuWCwLbbbInTVFak08VVnirvhmVdJO9hppN0cugAPkFJc+nWC2aYYdOHLRbza6MTDGfRW07WYjrMwB/lE9qmk/ehytpiit3qxpMFG3jM6jy6MNQncPUWqF1Btl3vMDyYRiAcMPnui3+2jGkoq1ea0SirAvZsYpLCwNaD8TuZE7Tp13K7M2Q8hRlbAiE3vKgk3ZBSgP9Kd3C+Y901hw2a7T8+Nrq6fyN0EntlU4PauSXer/ASv+p6jZ061nz07zMga6yatuS7Zugwwea6PYMXBbUmEdV/ZDd/lU5+dzd2O0hywPO46euRr8mk8LZPztaWVUpuZXm99AiwqG4gmRcnWSSSt61rTMz4hQmudehrpUAMaWvzZtzy4ppgFXKspYG9FOOiHXWP4QdnQc++SaAVQaXKfqHn30hrOVyKRXaDOxHn2scqmaxOlYlQTPDcG5kwn+OHpERC1lZvEDbgE0D3htSZYj59oanslVO5fZ29CIchjepUVOz7/j6MeHtw6hvA1aywZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(38350700002)(38100700002)(26005)(508600001)(8936002)(86362001)(6916009)(316002)(54906003)(52116002)(36756003)(186003)(107886003)(4326008)(44832011)(66556008)(83380400001)(2906002)(6506007)(66946007)(6512007)(5660300002)(1076003)(66476007)(6666004)(2616005)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?emCRNTPXo0zOjqFwUk7/cO999ubIkbPBbjJw+75+HEVrmpGyugU/KuFkuvmv?=
 =?us-ascii?Q?NE9aH5mhhxwgZ08l/lJX+6dgGyj/PEzFYzU3nkSJLajE7vYAkMdqLQkCGWiH?=
 =?us-ascii?Q?VvvoSlajawja9oLKp2m+uCjIJwdwXt5m37EceIfe0X1fWG8CRFw6s4GTPT0P?=
 =?us-ascii?Q?DND8LhMSGqizxYQTqDO0Kq3r9cLuMnXMXGyFmEmEQLjwf+VP8tdYPTI/yTrR?=
 =?us-ascii?Q?RFl0ieaBf3v3+eOI955uYcxGDpnh6uDOTN+U1Lr9qY1IBfsqHzQUosjavY/5?=
 =?us-ascii?Q?bLfCoBaz51aUoNHSocOwFU8LXYA3vh5xT/krQuO7csxL59P1X1Ybgam+LXYN?=
 =?us-ascii?Q?hlPo1XO718YP300KMAwdq5FlitDipFVyDNnMor3ioJqSN+pKI+gNbV6YiJqj?=
 =?us-ascii?Q?6Bp9yVHP4p+fTQK42Hn5E33guShZYbniHMpBDN92UsHxGsOrjZYfNRf0ORXp?=
 =?us-ascii?Q?P2MGR36EzZaOfIE+FR5Sb0gqy+td64zUa6JjvhKbu3GKyXqce6NKLJGhihr0?=
 =?us-ascii?Q?cITSTCl7cAbp2eGHb2fQxw4qcjSCuDaihFXE5Ur4PNUIWykmbJx+oclWYHhX?=
 =?us-ascii?Q?rIqGcfRkGpYNKUZLXta5xiSlGyqo87cgsFNtFUSOzBjEOj9d801uD8I2uYX/?=
 =?us-ascii?Q?eJD4v6NcWL8G58kY4/9RIl18U0Zi1twdYqzoDdt8dO/7m0VDsmlrxHmWkQBi?=
 =?us-ascii?Q?xtJBMaeBkZ4j21hMC05rm4laV5bUVGXQ0D/KVqkwdfbjwFz9Vacidn7tKCzE?=
 =?us-ascii?Q?LZI9Bw+T/0J5rkEup1AbivLgelMeW+l7qhnD4mx8Fn6Y2Hfw//YXnVU/3j6J?=
 =?us-ascii?Q?pFzT+HUIwrTYERslcrsaAwkA4b3y0Lw9iOXaQaMLlJFtwz/i/6Fn8bPIzhE8?=
 =?us-ascii?Q?uQaJzZYuAvZqd3qJHqvfmUqRL6CbSnrfdez/7fwVHtujK/CGIN3ZKE2zqWK1?=
 =?us-ascii?Q?X9mEyu6NPkPOIqKBLkY02Zf8QcDDkwzXhCs9R3KFTu2qcum4yN4oKrCj9pcJ?=
 =?us-ascii?Q?arnDlAvNcO73cg96WBXKMNaDU2UDk6MRejXIDsqeQR155IQ3kD9j0jaiqibs?=
 =?us-ascii?Q?qcqw5tqiy/5C7stgiTS0ceYPtXKhLtI15A7bzKKYilob56DP33rTjMxpXFFi?=
 =?us-ascii?Q?GEp4lKJBHGfupiJWyezNCQ4dEJADSG0jihpH+bOLt5ReeR3kM6EdBD/ywRcY?=
 =?us-ascii?Q?s+VQzzYCial9jHylWupvZblqVbCVWAd0vSDy59QeIcSHu1y5+MBJpVTTVuHg?=
 =?us-ascii?Q?pFyA7fzumIk5glHE0vtHiyj+B0QHgl3iTbeZ01qMbDLAom3UWhZLJdfEfPE1?=
 =?us-ascii?Q?esvgDMFBWibTK+dpGt3kwlYBVak7icA+4Ga44f1McCh2NVmBjCogWlnWHzMi?=
 =?us-ascii?Q?EQ9lENAJreYMHM8A8zOD5fOuG8Cegh9MuAm+z03ossWFR0HwEAFnvbALRz+z?=
 =?us-ascii?Q?uXlW6am8y9KnI97jc1ds4X6r1wXcLPea8anIHYf2S/8jjPBwjtVi5piIhJrH?=
 =?us-ascii?Q?jnEvUrI8i9dVYpVtdeLO42a0s28h+wIiAkS0YWutCnBvB58YQ6z7TnTVmsIP?=
 =?us-ascii?Q?pViL7REwSENddSXx8v9YVHhjvebQMJ4XuL82nxkp3kD0o0DK57nis1tk5H0o?=
 =?us-ascii?Q?PhPNdbWrsAjw1c67e+3uS+QjJ8CJ8yzqzjsib2pPF7ViKZpTYvDmP6LTnLsY?=
 =?us-ascii?Q?OcZEwM0ixgQ4TmElahlvlNCRN4MpYI2sHkeOuDLieQG+MCQ2sCaw7fQ3E6cd?=
 =?us-ascii?Q?vcE2w8FWxFZAZQysegXx2wpuaUTBzjQ=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c59b75-88d6-4aef-ada8-08da23830480
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 10:38:05.0982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AUH8+0HKKZVucgZU0HyJ6icak2BVwzu+8bcs7bUsvkvKzqwZqIQPXaropQIZZP62KzjaePnPzHenK7W0+c5jmYPo3bYS708evUdUpKKLODk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5406
X-Proofpoint-ORIG-GUID: a0Tc4BVH9-2J6FaEedV7gqTfX-BUSGiI
X-Proofpoint-GUID: a0Tc4BVH9-2J6FaEedV7gqTfX-BUSGiI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-20_06,2022-04-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 spamscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=947 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210059
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Duoming Zhou <duoming@zju.edu.cn>

commit 9fd75b66b8f68498454d685dc4ba13192ae069b0 upstream.

The previous commit d01ffb9eee4a ("ax25: add refcount in ax25_dev to
avoid UAF bugs") and commit feef318c855a ("ax25: fix UAF bugs of
net_device caused by rebinding operation") increase the refcounts of
ax25_dev and net_device in ax25_bind() and decrease the matching refcounts
in ax25_kill_by_device() in order to prevent UAF bugs, but there are
reference count leaks.

The root cause of refcount leaks is shown below:

     (Thread 1)                      |      (Thread 2)
ax25_bind()                          |
 ...                                 |
 ax25_addr_ax25dev()                 |
  ax25_dev_hold()   //(1)            |
  ...                                |
 dev_hold_track()   //(2)            |
 ...                                 | ax25_destroy_socket()
                                     |  ax25_cb_del()
                                     |   ...
                                     |   hlist_del_init() //(3)
                                     |
                                     |
     (Thread 3)                      |
ax25_kill_by_device()                |
 ...                                 |
 ax25_for_each(s, &ax25_list) {      |
  if (s->ax25_dev == ax25_dev) //(4) |
   ...                               |

Firstly, we use ax25_bind() to increase the refcount of ax25_dev in
position (1) and increase the refcount of net_device in position (2).
Then, we use ax25_cb_del() invoked by ax25_destroy_socket() to delete
ax25_cb in hlist in position (3) before calling ax25_kill_by_device().
Finally, the decrements of refcounts in ax25_kill_by_device() will not
be executed, because no s->ax25_dev equals to ax25_dev in position (4).

This patch adds decrements of refcounts in ax25_release() and use
lock_sock() to do synchronization. If refcounts decrease in ax25_release(),
the decrements of refcounts in ax25_kill_by_device() will not be
executed and vice versa.

Fixes: d01ffb9eee4a ("ax25: add refcount in ax25_dev to avoid UAF bugs")
Fixes: 87563a043cef ("ax25: fix reference count leaks of ax25_dev")
Fixes: feef318c855a ("ax25: fix UAF bugs of net_device caused by rebinding operation")
Reported-by: Thomas Osterried <thomas@osterried.de>
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: backport to 4.14: adjust dev_put_track()->dev_put()]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index d9b3f6222cec..43a69d0e8a71 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -101,8 +101,10 @@ static void ax25_kill_by_device(struct net_device *dev)
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
 			s->ax25_dev = NULL;
-			dev_put(ax25_dev->dev);
-			ax25_dev_put(ax25_dev);
+			if (sk->sk_socket) {
+				dev_put(ax25_dev->dev);
+				ax25_dev_put(ax25_dev);
+			}
 			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
 			spin_lock_bh(&ax25_list_lock);
@@ -982,14 +984,20 @@ static int ax25_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
 	ax25_cb *ax25;
+	ax25_dev *ax25_dev;
 
 	if (sk == NULL)
 		return 0;
 
 	sock_hold(sk);
-	sock_orphan(sk);
 	lock_sock(sk);
+	sock_orphan(sk);
 	ax25 = sk_to_ax25(sk);
+	ax25_dev = ax25->ax25_dev;
+	if (ax25_dev) {
+		dev_put(ax25_dev->dev);
+		ax25_dev_put(ax25_dev);
+	}
 
 	if (sk->sk_type == SOCK_SEQPACKET) {
 		switch (ax25->state) {
-- 
2.25.1

