Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2CF492B46
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243885AbiARQdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:33:23 -0500
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:34542 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243997AbiARQdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:33:07 -0500
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20IGU2kP001583
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 08:33:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=O5tB4Mvbj7i4lmAvGatN6bF6Eb5QlUqmyDLFS4cesps=;
 b=KGA6Llo3ZIBGSp1pew3sY18m+qCBdSFSOyeaquThJq8pp/4YcwFoE5Xqjlq5jjt1OH84
 eAJf9BGz1LOCjxYPb0IK4hhXgVCNUGTN1rv2mLOFUkhgvY+ASFK2zGMF+pw+c2DwY/C+
 LZlIC7fCm6/C2yDcblYU6Dk949D57lBlH6Rb6rs99c2UFJSVXa72EZeMZxBYvMEDrrsx
 zhslj78qsw39jaZ7glgFcVYBIrT5ANq9WhP6naWAB8As6pw2ZyR98FrHdtZF9cQ3UUl6
 imqKFsvHzMn/1aQ7Xy54viK5AjtuvhGMmyBBrnvI8qFveIkSs8qRheALxzOzYV8EHgPQ zA== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3dn5v1rxrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 08:33:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HDF+Cqg0OgIrh54C0tmfhkwNYpt1KGK8KiteA10Tda3+92guvyV+K9P2fzrdbtj8aWd9Qg73zawQCsKFKKIKTpD7Asi+mrK0VgpU3h2roJD85okm7MSRLyijXPKu+8zFZzR/EoOrKA4R5+SCV0E8tPY2nepWwqyLddhmielHVBnWRzATmAnWVk5bGW18WZaYEum3iWxNXMs1jn5dqQh5U8WXoSCvS52CMo95XmZd7NH9hCZYFVgj2avvYt6NcgKAjt0tziNGIaUljUad0xjV11sOfn2cPOTLRu/gBiyMIEQesgohQ9bb9MFUOQswr0ImMQCVoMQXAWoztfqMHHB8pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O5tB4Mvbj7i4lmAvGatN6bF6Eb5QlUqmyDLFS4cesps=;
 b=mBsyS+KrfjdByamrjbR2TUayTGJ9bqY2dl1v8fzcIsE1DpdZRbvyh2Am4i7UNa97JNSus/SwBjAxMhCfSvP3onjGqTGHArMHuQGJ/aAo9y7m/kinuy5XwntGYykfbLLfGW7qpJVeNrd6HtdTtpoi8MurhxsZKpG+OWlt5ZVd6y+Zhx5GgbtlWbiiK4ACV+ah2+PY6okqZaVrWx7Dnh35KksLvg1tJ8bdM+pTVzYlnxopG8EPorPKqah0IuEqaQRpL5j/T0TwsBUEhVUj/Tq60IIC/k3nBsyuWpsV5gDvxA3v8/9qowiI8gapgu0Pwgh1w5Vh3Q+9R61i4hE0b9VwTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CH0PR11MB5394.namprd11.prod.outlook.com (2603:10b6:610:b9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Tue, 18 Jan
 2022 16:33:04 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7d5a:c35:1ddb:11f3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7d5a:c35:1ddb:11f3%8]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 16:33:04 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 1/2] Bluetooth: schedule SCO timeouts with delayed_work
Date:   Tue, 18 Jan 2022 18:32:39 +0200
Message-Id: <20220118163240.2892168-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0242.eurprd07.prod.outlook.com
 (2603:10a6:802:58::45) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 152f4e64-be55-42e4-c3aa-08d9daa0333a
X-MS-TrafficTypeDiagnostic: CH0PR11MB5394:EE_
X-Microsoft-Antispam-PRVS: <CH0PR11MB539420D352F634220F3CCAD8FE589@CH0PR11MB5394.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HFKQnM6cym00Xuro0Go4JYJownXGfd+L6m2bOcXZ6Q+iQxFy5nvdpeyaGA/NiLeJg61xwULe3NxJSI0zOY2h6UQkLRSdjZzDpwgP5pli/miAHlj0oHLKrBYHcjowu3JZzYfyb4RFiENG4JNzZc50zUs6tJovzvtWLfw5JaAfRvX6cnc0fyG+Rr98GMjRROKmD5NM4JZumbtk8d5JX/z5MernY2uzMss3+45eTmL47tFOsvn0vfB3jzEtZwsMdknp9IjKyw04+h456BGpYdjGVvnIdmKBLuyOAimRCNcXrN11sRMova/KNo1bEwhpqFJZ0Kb/ejbSSqi3gKiUXrmDMwUWzykAaY2voqNcF+mZG9WkfQ6QCIr8mOoG13sqwd7PK/96oegcjtwQzh2DvJETknrZ+0pQTU7jhmAqVU8/v/0MktZXg4KEOckXNeHc4T34MPjjOtkhH3gynJ/Ox0Nn2gPaxYuUPiEq3RVt3X/KjEgif0J2x5g0gYSAT/FQOCp9zbRyfGYll9nMWoiQhlwttuDvQitDXxW+WGbNP/iCpF32s9iykJfQeuEclLuGQKmhww+v7H17OJhlFJpPNUCg0CiX0KLQ576XgUNV55EExaXcGiSdR9qkRY30Pj0KOX9f8Pjsg/D093A4CxJWxkUqOW5e+mijTo7YX/evsAGYBpyHR1c8WlH+YcZ6rsrblzTMDDx+vJFK4kxSauLpwH5WpvgFCQGgL3DirC9tzhUJAWbgfRummEHY+ZDYjWU4OSwI1/t2yOVx/wdbxldcoTrMGaELF73+ZfuWiiX6G+zomEw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(86362001)(38350700002)(1076003)(26005)(508600001)(66556008)(66476007)(2616005)(38100700002)(8936002)(66946007)(83380400001)(8676002)(44832011)(6512007)(2906002)(6486002)(316002)(6916009)(6666004)(6506007)(186003)(966005)(5660300002)(36756003)(99710200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Em1tyEdQIzr2rjqL763o3lQky76jXpIcL9c3zZ5HuJExeY/b9DchshGtjesY?=
 =?us-ascii?Q?W/WGG8NSXAhDEOCcIROujZetC1GSEd/HIyLnulSb+EpJ8/aRHUYWcj6ImU/A?=
 =?us-ascii?Q?Yq4BTEHCC4ekhkSGL+IFUeqilNIPI7bewLZG9XYYTjFwtSYR1cFqeK0cJnJ0?=
 =?us-ascii?Q?5DB5o21CZ3wZU5X6CPIUeFOl7jsTA+742ZR212O3WV6u31Xc6kJZcN5gmEhC?=
 =?us-ascii?Q?vmIx8w5C97h34WAo3g6i+s+HgTYxxCSl8zZ+nJDjDBlTaC+G2USlK9w8SwSF?=
 =?us-ascii?Q?O4w6VIrHH9VcadriT8JE7Ce2ApVhyG/PrAXefRhUhgWxTSV4f7zrkeq6OIbo?=
 =?us-ascii?Q?gWcxzqPi2pIbIFHZMc72orpO+KZfvfzGROK8eq82L15h57TlSgCr6XvXbyCp?=
 =?us-ascii?Q?H/YLX4TKKz71k9h1FYvsc2r93N8rGRfrp5jnL4UGyWPS/pcjmKzpyTIJLp5t?=
 =?us-ascii?Q?hL5yc8scMfQTLLUyqoxiAMveDQaFSpo9sG4lnzfKmU5LmBGSONoiq5XmPbk4?=
 =?us-ascii?Q?z2qW7Fb09+VK9qS5q2goIakYvqdxBtj9wmQS0d8shv+WfOHjjnP+zUCmuJ/Z?=
 =?us-ascii?Q?cWq1cexwvJOUrMakEv2HVlBawD7/aVzJj5SSRSuRbrdiavxDKq4/WgKzVY7a?=
 =?us-ascii?Q?EPtznE9eWfCkgQrpGyytRqVoO8qyQRkOs2YlTRy50DvKcqx8FeXoE2odX6ot?=
 =?us-ascii?Q?TZcYzxTzyjlJAi9ksF+TyWzWwH6o/mlgd4VL3TDTrkVe1PBkiMRUxqbwOuUQ?=
 =?us-ascii?Q?zw57Iv7pWqhdfdMn3Qf9XTFCuX1wac8bVntL0BQD/9aaltbFvjcTEZrmmgn5?=
 =?us-ascii?Q?JQB8N+dN1nwY1l9cHUJEipMfvPeGAC/xRpg7G6IQZ11FcxOHt88OaeGB/JQB?=
 =?us-ascii?Q?CTH9gYLV3XwqBzHU4nJos3suUoV5azc1SW9scbq0tUWhWsDFo0XAo0qiCU5M?=
 =?us-ascii?Q?8D8ojwURaFTtmdb0EAn4PRXHrQk+EHwG6/EZntRHQrboR5/Or7ARN/aiBZhy?=
 =?us-ascii?Q?flMW5RY79Ck/mIQYmHQBRTyytJBWhUKhVZmnyOnMcMyBGEWrjbrbpQ9HfXD/?=
 =?us-ascii?Q?G4CHNX0yMFgmyNsjtzwGU907SH6f3ntNJvdvMORJA7bGSJ1Qx4vr40K5WURc?=
 =?us-ascii?Q?lIsOXvCMJG55lD/RA02gaPnaXQgVDny5mISM4bki9C8f1xDzvSvJCRj81iAJ?=
 =?us-ascii?Q?vE0Re/N8k6u2ndK5j2A8Zj4T2dlsOME5+ormuH0T1doFPwrQpg4Dd0RY2mLj?=
 =?us-ascii?Q?nKk++S3ENBIzEch61MzrOOjhx6qG9LGpde0pIs2kS7JwufbCfkx1A+ffrpqS?=
 =?us-ascii?Q?vgLHMLO72iUStQGvI8maoSTJI/fO16IJY2DuegzpcHo8ilhT/toO3f5ak6PB?=
 =?us-ascii?Q?7nYUD5FLm/Sp23QIHZkEo+ochvhWmAANr4oXQRCqage8TJhOg3VlrLdGWYq0?=
 =?us-ascii?Q?Q6A8rIYZW4pGKuk4uaJfD35xjDjHdYTkNtRwwgn/XxdgH9HpoTJJFKJBpkPf?=
 =?us-ascii?Q?9NcuZAdExasSh96eSoAr01ob0tSEvIEpw+Y184FkGvQ8bjKwEXPsSBukADl+?=
 =?us-ascii?Q?3VQPXXOvzqpEKI8IOxK97NbN/NAG7EgPrmiIvBPGQyQ73hP4PwhqojDZBJYu?=
 =?us-ascii?Q?xSbkfNfxy57uxgZkQ8jwPHPY6M9HjMWnPhKO5A34sWAwSArpd2620vswNNQI?=
 =?us-ascii?Q?n6rW4Q=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 152f4e64-be55-42e4-c3aa-08d9daa0333a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 16:33:04.1872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 72faYQK+DKsLVx6WPrVcbONhpV0Df1ow56K6JSAw7E7aamxHuESOdKgyCw5aA+A8LJdT2vsHD3DMEi9clwIgVDp+SvyU8cVxpYwkjDX1dRk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5394
X-Proofpoint-ORIG-GUID: dUD_3atTdLPwNbBAAVFl9WI3woUzvFxi
X-Proofpoint-GUID: dUD_3atTdLPwNbBAAVFl9WI3woUzvFxi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_04,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0 impostorscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1011 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180101
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

commit ba316be1b6a00db7126ed9a39f9bee434a508043 upstream.

struct sock.sk_timer should be used as a sock cleanup timer. However,
SCO uses it to implement sock timeouts.

This causes issues because struct sock.sk_timer's callback is run in
an IRQ context, and the timer callback function sco_sock_timeout takes
a spin lock on the socket. However, other functions such as
sco_conn_del and sco_conn_ready take the spin lock with interrupts
enabled.

This inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} lock usage could
lead to deadlocks as reported by Syzbot [1]:
       CPU0
       ----
  lock(slock-AF_BLUETOOTH-BTPROTO_SCO);
  <Interrupt>
    lock(slock-AF_BLUETOOTH-BTPROTO_SCO);

To fix this, we use delayed work to implement SCO sock timouts
instead. This allows us to avoid taking the spin lock on the socket in
an IRQ context, and corrects the misuse of struct sock.sk_timer.

As a note, cancel_delayed_work is used instead of
cancel_delayed_work_sync in sco_sock_set_timer and
sco_sock_clear_timer to avoid a deadlock. In the future, the call to
bh_lock_sock inside sco_sock_timeout should be changed to lock_sock to
synchronize with other functions using lock_sock. However, since
sco_sock_set_timer and sco_sock_clear_timer are sometimes called under
the locked socket (in sco_connect and __sco_sock_close),
cancel_delayed_work_sync might cause them to sleep until an
sco_sock_timeout that has started finishes running. But
sco_sock_timeout would also sleep until it can grab the lock_sock.

Using cancel_delayed_work is fine because sco_sock_timeout does not
change from run to run, hence there is no functional difference
between:
1. waiting for a timeout to finish running before scheduling another
timeout
2. scheduling another timeout while a timeout is running.

Link: https://syzkaller.appspot.com/bug?id=9089d89de0502e120f234ca0fc8a703f7368b31e [1]
Reported-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
Tested-by: syzbot+2f6d7c28bb4bf7e82060@syzkaller.appspotmail.com
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[OP: adjusted context for 4.14]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
Note: these 2 fixes are part of CVE-2021-3640 patchset and are already present
in 4.14+ stable branches. For this backport, small contextual adjustments
were done to account for the old setup_timer() API usage.

 net/bluetooth/sco.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index a5cc8942fc3f..69d489f1f363 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -48,6 +48,8 @@ struct sco_conn {
 	spinlock_t	lock;
 	struct sock	*sk;
 
+	struct delayed_work	timeout_work;
+
 	unsigned int    mtu;
 };
 
@@ -73,9 +75,20 @@ struct sco_pinfo {
 #define SCO_CONN_TIMEOUT	(HZ * 40)
 #define SCO_DISCONN_TIMEOUT	(HZ * 2)
 
-static void sco_sock_timeout(unsigned long arg)
+static void sco_sock_timeout(struct work_struct *work)
 {
-	struct sock *sk = (struct sock *)arg;
+	struct sco_conn *conn = container_of(work, struct sco_conn,
+					     timeout_work.work);
+	struct sock *sk;
+
+	sco_conn_lock(conn);
+	sk = conn->sk;
+	if (sk)
+		sock_hold(sk);
+	sco_conn_unlock(conn);
+
+	if (!sk)
+		return;
 
 	BT_DBG("sock %p state %d", sk, sk->sk_state);
 
@@ -89,14 +102,21 @@ static void sco_sock_timeout(unsigned long arg)
 
 static void sco_sock_set_timer(struct sock *sk, long timeout)
 {
+	if (!sco_pi(sk)->conn)
+		return;
+
 	BT_DBG("sock %p state %d timeout %ld", sk, sk->sk_state, timeout);
-	sk_reset_timer(sk, &sk->sk_timer, jiffies + timeout);
+	cancel_delayed_work(&sco_pi(sk)->conn->timeout_work);
+	schedule_delayed_work(&sco_pi(sk)->conn->timeout_work, timeout);
 }
 
 static void sco_sock_clear_timer(struct sock *sk)
 {
+	if (!sco_pi(sk)->conn)
+		return;
+
 	BT_DBG("sock %p state %d", sk, sk->sk_state);
-	sk_stop_timer(sk, &sk->sk_timer);
+	cancel_delayed_work(&sco_pi(sk)->conn->timeout_work);
 }
 
 /* ---- SCO connections ---- */
@@ -176,6 +196,9 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 		sco_chan_del(sk, err);
 		bh_unlock_sock(sk);
 		sock_put(sk);
+
+		/* Ensure no more work items will run before freeing conn. */
+		cancel_delayed_work_sync(&conn->timeout_work);
 	}
 
 	hcon->sco_data = NULL;
@@ -190,6 +213,8 @@ static void __sco_chan_add(struct sco_conn *conn, struct sock *sk,
 	sco_pi(sk)->conn = conn;
 	conn->sk = sk;
 
+	INIT_DELAYED_WORK(&conn->timeout_work, sco_sock_timeout);
+
 	if (parent)
 		bt_accept_enqueue(parent, sk, true);
 }
@@ -466,8 +491,6 @@ static struct sock *sco_sock_alloc(struct net *net, struct socket *sock,
 
 	sco_pi(sk)->setting = BT_VOICE_CVSD_16BIT;
 
-	setup_timer(&sk->sk_timer, sco_sock_timeout, (unsigned long)sk);
-
 	bt_sock_link(&sco_sk_list, sk);
 	return sk;
 }
-- 
2.25.1

