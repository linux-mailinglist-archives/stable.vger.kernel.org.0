Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD63502E72
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 19:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344051AbiDORww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 13:52:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344245AbiDORw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 13:52:29 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6AE59A7D
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 10:50:00 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23FHURXe009386
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 17:49:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=cjkHAb1ElmUrpgyr0tX8csIZ+PLDpPfyyzFLs+fMl+k=;
 b=o9t9WuRKqlusKVUOsgqAAbdelCgRglJ5aJOTIDueldkeTXJC+ikM8bMjqqOlwmM2zssU
 +vRHWN/lIVD1aiWiZRY9FvXhG5/ju1gnsUlxVIJS/lohgtinP0Tquir2DDmeeFIFes3F
 2VpAyxXJ0BaPYWfvQcx4CeSKyxqLESBapICDbuGozgVF5MxANnqY9ZIKbtXVIHBovhmY
 dyYj3OPzJs5NVcaKmQUhCEV/otBWQDYpM+1/ta86QDbR7Ba35kRD2GJfkbvpVmGSQqcl
 zLqCk71fd/MW9M4YyDl1Fh/J2bMNaOmqkb5ELDzyAGMqJgzXQxruZCnEKBEnh+sok9YT kg== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb6fwcvuj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 17:49:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CHRRQYxMR600y3hN3Z+TauHCgUU5b/f1mu7eFsI47dfx5couMBhieG1DED9Y8nfoknwT0MOWgqhwj8Y4+ZJU+R4ccWyBhTnXmzyGelpqwR8iO+TKxBJhvyZ02j7wvayyW+PEx56Lpjc62CF/6sEwiAaVj46QDBCNjDzUgEab5WlzgGLCmnj1tzPIMsv4+a1c/ZcisDMzYUGD9mbl+o6GlYqN4zfbu6xvlh7cvTvkWNqYv9ok4ySGUSS925WlYLu2kpJdBhNhnwgZWSLY3535dVBzTYyI75TnQmkM+jEavQ5L+BooxdCCWSkM8Nfw7mkra47ZZHikHBqNxNTlpjneqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cjkHAb1ElmUrpgyr0tX8csIZ+PLDpPfyyzFLs+fMl+k=;
 b=W3vFjQqRkJl1xgfbd7a0a+gy8tDkufIlhkPLZDFvM4urbFnBYUlV95z+K96h6pqH5HE+RTuL+dZgZ197Nj/9QX8C0pVMU9vfoXCLUXZwofHebJNhtgPrahagsqCusyc6FciiRQIZNoVtrqG7cB2mqBXS3pbf893jLUzMZ5x8/LugbUmxQ9KRQlXZAh+nbeTB3awezUABa+Q9xm+teuRt38Hh11OeNXLpqc5FmWFDiFP9YjuFPfIQ/xtyz4xQNqp+sWR/ceBWqQH/+Q7BmCSLPZ0hb484Oj/QdNXzThH3uUZxbBVbfvSZjdQ0Nkd2lqpKI6L7m/3JnxHClIxe8gn+Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB2697.namprd11.prod.outlook.com (2603:10b6:5:c3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 17:49:56 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 17:49:56 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.10 7/8] ax25: Fix NULL pointer dereferences in ax25 timers
Date:   Fri, 15 Apr 2022 20:49:32 +0300
Message-Id: <20220415174933.1076972-7-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220415174933.1076972-1-ovidiu.panait@windriver.com>
References: <20220415174933.1076972-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0217.eurprd08.prod.outlook.com
 (2603:10a6:802:15::26) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bffc9544-70e2-46d7-a81c-08da1f085a5a
X-MS-TrafficTypeDiagnostic: DM6PR11MB2697:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB2697AF70C6C099495BC43545FEEE9@DM6PR11MB2697.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KlH0aklKAQCWw404sNDQYtLWJCBo7QnHLR7wjrfkk4RBphe+92iQQ1e3YkGdu7nk6orVrDC9yuJAe7ycEz+Mftl3DY834eQCl1ypzNmG2yY8hZ6FyleBqn7dGzXa46M8Y4utzRduJZeTlUk4dmAxWveE5P4iEHqsJsJEvjmzLeHmdq9j8SBi8fgMJKnaCWZeNwlyNba90qpI/cmcRB6His19EpOq6Mhj3Ox7o+veB0Ox5tj5n7y+l8AykLaWYumc/l4YYiFyALm2uSm0rQ0VaTLCExAr7rKDiQniT7uiOov2aYs1hyBzauXatBQvO8YViOj7QlFHKuyiOgAZHF8G7cq/md+ZVUDGplRpOlGdT3HvGuur3+EjuqSIXkTjeonElPfBXvl9IwOhlo+7sZkMirI+0/eiwgGjfrix2aS5lQXxS+drk9D+HBnzXssXvDu9gPfh4ZsrDEaon3S5iTQBS5lO04Rb+I0ARRT27J1i40j3cTta00+GF+nOXVzL2QQ+Y2RTre7AapT7clxdfuxf2UNre6t7gjR/TffglFrwT1eKDGDCzJyy9h57x+XDbMs3oJlUtwMxBVJJmVlUpDitgPRlPqsFxr0X53MNoV58dBOU6aryzkBJfv2tjV0uG0Tt3tnvPE+7ziYhdaVeLigBwqasIMLv84SuS9RGorxzMBZiqO1xhOi2vwy/kilF/iAYZwhodu+DrN2g38D6pUomlg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6666004)(6512007)(52116002)(6506007)(36756003)(6916009)(316002)(6486002)(86362001)(66946007)(508600001)(8676002)(66476007)(26005)(2906002)(5660300002)(66556008)(38350700002)(38100700002)(8936002)(44832011)(1076003)(186003)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vdfBbGqGdXe/BbsdludSlRDbjd7g4/YDhCszRyoEbQfB0i0ZZALm8r1gcTdw?=
 =?us-ascii?Q?faYrvrfWF+w9RhsvT5mH6ZqMZxVJDERN3VKlaL61mnMIAr6xU2l8MUPFhnud?=
 =?us-ascii?Q?/wC65uMUzzbrOkDrxo4qjoc7DlF2lL38iC2SKMHaLLeo8SmcnqJzka23jBiF?=
 =?us-ascii?Q?CshPdwgs+D3frDPDURyNVqVsS8lJQwYX/auDN73wKIoI0trwNd0ZP837jdCX?=
 =?us-ascii?Q?JK8oujBre4oNTcwrirs31Na//27qwaMEUnoAq8n9qtKdhCSz3C0/spsDYXfG?=
 =?us-ascii?Q?C6jVCJnrRF5ZE/yN8+83gkqjZvow9YDoZPr+JgKlnZ2/5L0rS/QWwxgAdz9r?=
 =?us-ascii?Q?Oj9RLKH7Z04ecYCUNu5/324VbNMOMvuHgDBWCBs69eOZJK93CP4D4mDxd+Ox?=
 =?us-ascii?Q?+LV3F6/QP0LGM8SLJ76s6MxbSPsZw9SepDCHiHITof96bwC078+BuSiCnsYO?=
 =?us-ascii?Q?84KSGR6oVatJkdk71lRk53CScYAEsiuHlRBJeq/wkiEWSy2dKVRDLMuOqsKa?=
 =?us-ascii?Q?ip5p+klqiSI9TmqZXTdf5TldjieYMkUps24XKRXA0KnnNyfMgR8eQ+N7o8ZR?=
 =?us-ascii?Q?/W/32PfFEpWABOqhmdeKHCX3zv4JA2GqWlxc4acsw409e4+2LfqBHaGE/u1J?=
 =?us-ascii?Q?2ClJVpK38tWbFZc98k7RD3yzcbr/Flc3AszxcOeKXasuJCb0CaRtE+kRcmzm?=
 =?us-ascii?Q?qvwr6ZNPLpkSLaPNRGL2U+k1fHUuU8qmJXDDyJgiGyICLATqWVBBqkaw6Npw?=
 =?us-ascii?Q?v6oxw5FYDJ8TLiTg+uCmXt/EHrGdOZNE8aGnbmHrgg6gnZAKi1WWHxyjfS1g?=
 =?us-ascii?Q?sakihYuK7qOixfhFMdgG8qUblWOk8aqzjpvrDCr8nZ3xi2NxB+rHwv+iAXZG?=
 =?us-ascii?Q?kU9QekvHszKDElYuII+ii9akAoXrzf+Om/FZGFGdX2pSI/I/92JNEaCndYj5?=
 =?us-ascii?Q?IRUrUvFTucDyJtqbjQcznPT6F1HTv/hAAgi0lD02FT00MGJ45wCgnvk/XMOE?=
 =?us-ascii?Q?NMrRQ5sbZ+Cb9TXTFcP5+rkIaPAP38wGsF3cHuRr04ptLvOCGqPouOrsmpN1?=
 =?us-ascii?Q?bFqj4oemtefdEqLDXZJ6LmHn/GimGQsXdDCrbdX9N/UrTmtlBdjYEd4mOQMb?=
 =?us-ascii?Q?hDqSXeYa4IRYkwVGd+r147UoPE44Rsfpp5tGffPx7mM0UPoJGxLM9189xBFt?=
 =?us-ascii?Q?lDtj+IkxkZcyR8w7KexDdfecNdrAhckISurQDsBLNjCIWqoRb5CuA4r8ve+e?=
 =?us-ascii?Q?VEWAzHeoNHftPLMCqSgfKpHiZF78N1L6BgR8xVJJ4DAfn/eDl4PG/UeYYCV0?=
 =?us-ascii?Q?keilXnMMRYgQW4MA5HT5DbtZ3E7AK7VozdAXYmTNAi/gLUO/byyu89djlWBZ?=
 =?us-ascii?Q?WfQKDgz03U1rWmdMOLwYPLmouu3LRDHYf5GnnDu2I07T5QHjifbzJ1nhFgSx?=
 =?us-ascii?Q?5rr5PuzQ/uzMjxqU+3pwig0o1177S/PmrPd69JivRmPdTKPzye6x+Rr6lgzZ?=
 =?us-ascii?Q?9k7hQw6qFQ1qyjvAYrwvP2PFrJmJJV2zCxFuwryAZS8jIwi6Tklz+BudiJWt?=
 =?us-ascii?Q?h5LizwlYHYVEDRG8gfwppSIbdGyEKE9/vCgYVOo+Oce+VgaS651b9xGYS3KB?=
 =?us-ascii?Q?MI9wyOPbfQBXPCWQhpQH5Sgoy4JKv7aSan8zTzOtve6y1FtL5D1I0NBbpg/L?=
 =?us-ascii?Q?7WgFe/QMnECUa3v9/Y6h9ExCLAGIjkh5YHQla4quwGJTGm/BOl67WWfjg+6g?=
 =?us-ascii?Q?E5NCKgnvNscMoil6KCbXImFtdigAO8Y=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bffc9544-70e2-46d7-a81c-08da1f085a5a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 17:49:56.3842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rOzNVRc9suZTRo9j+wbJ9GuwGjl9ZIjOuB/P6e8B2BSGFF6UFpXk9QhO2ZbzMAKh0JUOmQ5sQxf5K9Gz0JqHUWNaK7i5WhiopHrV0y/p5iQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2697
X-Proofpoint-ORIG-GUID: -fOFRsJnLWiR3Ff12XgWIou1d4j6sVTh
X-Proofpoint-GUID: -fOFRsJnLWiR3Ff12XgWIou1d4j6sVTh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-15_06,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=752
 malwarescore=0 spamscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxscore=0 phishscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

commit fc6d01ff9ef03b66d4a3a23b46fc3c3d8cf92009 upstream.

The previous commit 7ec02f5ac8a5 ("ax25: fix NPD bug in ax25_disconnect")
move ax25_disconnect into lock_sock() in order to prevent NPD bugs. But
there are race conditions that may lead to null pointer dereferences in
ax25_heartbeat_expiry(), ax25_t1timer_expiry(), ax25_t2timer_expiry(),
ax25_t3timer_expiry() and ax25_idletimer_expiry(), when we use
ax25_kill_by_device() to detach the ax25 device.

One of the race conditions that cause null pointer dereferences can be
shown as below:

      (Thread 1)                    |      (Thread 2)
ax25_connect()                      |
 ax25_std_establish_data_link()     |
  ax25_start_t1timer()              |
   mod_timer(&ax25->t1timer,..)     |
                                    | ax25_kill_by_device()
   (wait a time)                    |  ...
                                    |  s->ax25_dev = NULL; //(1)
   ax25_t1timer_expiry()            |
    ax25->ax25_dev->values[..] //(2)|  ...
     ...                            |

We set null to ax25_cb->ax25_dev in position (1) and dereference
the null pointer in position (2).

The corresponding fail log is shown below:
===============================================================
BUG: kernel NULL pointer dereference, address: 0000000000000050
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.17.0-rc6-00794-g45690b7d0
RIP: 0010:ax25_t1timer_expiry+0x12/0x40
...
Call Trace:
 call_timer_fn+0x21/0x120
 __run_timers.part.0+0x1ca/0x250
 run_timer_softirq+0x2c/0x60
 __do_softirq+0xef/0x2f3
 irq_exit_rcu+0xb6/0x100
 sysvec_apic_timer_interrupt+0xa2/0xd0
...

This patch moves ax25_disconnect() before s->ax25_dev = NULL
and uses del_timer_sync() to delete timers in ax25_disconnect().
If ax25_disconnect() is called by ax25_kill_by_device() or
ax25->ax25_dev is NULL, the reason in ax25_disconnect() will be
equal to ENETUNREACH, it will wait all timers to stop before we
set null to s->ax25_dev in ax25_kill_by_device().

Fixes: 7ec02f5ac8a5 ("ax25: fix NPD bug in ax25_disconnect")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
[OP: backport to 5.10: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/ax25/af_ax25.c   |  4 ++--
 net/ax25/ax25_subr.c | 20 ++++++++++++++------
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index b1e36d48b07c..a665454d6770 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -89,20 +89,20 @@ static void ax25_kill_by_device(struct net_device *dev)
 			sk = s->sk;
 			if (!sk) {
 				spin_unlock_bh(&ax25_list_lock);
-				s->ax25_dev = NULL;
 				ax25_disconnect(s, ENETUNREACH);
+				s->ax25_dev = NULL;
 				spin_lock_bh(&ax25_list_lock);
 				goto again;
 			}
 			sock_hold(sk);
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
+			ax25_disconnect(s, ENETUNREACH);
 			s->ax25_dev = NULL;
 			if (sk->sk_socket) {
 				dev_put(ax25_dev->dev);
 				ax25_dev_put(ax25_dev);
 			}
-			ax25_disconnect(s, ENETUNREACH);
 			release_sock(sk);
 			spin_lock_bh(&ax25_list_lock);
 			sock_put(sk);
diff --git a/net/ax25/ax25_subr.c b/net/ax25/ax25_subr.c
index 15ab812c4fe4..3a476e4f6cd0 100644
--- a/net/ax25/ax25_subr.c
+++ b/net/ax25/ax25_subr.c
@@ -261,12 +261,20 @@ void ax25_disconnect(ax25_cb *ax25, int reason)
 {
 	ax25_clear_queues(ax25);
 
-	if (!ax25->sk || !sock_flag(ax25->sk, SOCK_DESTROY))
-		ax25_stop_heartbeat(ax25);
-	ax25_stop_t1timer(ax25);
-	ax25_stop_t2timer(ax25);
-	ax25_stop_t3timer(ax25);
-	ax25_stop_idletimer(ax25);
+	if (reason == ENETUNREACH) {
+		del_timer_sync(&ax25->timer);
+		del_timer_sync(&ax25->t1timer);
+		del_timer_sync(&ax25->t2timer);
+		del_timer_sync(&ax25->t3timer);
+		del_timer_sync(&ax25->idletimer);
+	} else {
+		if (!ax25->sk || !sock_flag(ax25->sk, SOCK_DESTROY))
+			ax25_stop_heartbeat(ax25);
+		ax25_stop_t1timer(ax25);
+		ax25_stop_t2timer(ax25);
+		ax25_stop_t3timer(ax25);
+		ax25_stop_idletimer(ax25);
+	}
 
 	ax25->state = AX25_STATE_0;
 
-- 
2.25.1

