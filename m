Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75DD5492B47
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244210AbiARQdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:33:25 -0500
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:35242 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244000AbiARQdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:33:07 -0500
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20IGU2kQ001583
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 08:33:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=cA88axY8DCvTXg0CPKwIqocFdqgbyRZKAIlEKY8QWbg=;
 b=fY9ZyLHXLxilALQ2mAUGXJ20kEd3kRcsZs2Rep4bfvKGyGmntM8divt6cOR8L0uAEORm
 UkZY0KEUup2tK+Azof404u+syWfbK7LdU4Ddr8pth96/ZMr0vQHRT1/7KeFy6jD996Kh
 YFoXOQj3AOysWhsZcpsy7bc0wEtqdqQzorS2UyWsNAUd+R/SJ/cEITrNYeUYNCH/HyWE
 6jS9al8FCK42FF3SNF597oJWgpi5M2UeFX4kjt+YbrrguB6+yu4HsraoGJ7JESfHmP2w
 DF5rML4ZpSQd/I/d71ND1RfXQ1vxvImD/VourWOPh7WhXRQXBtsJTkHy4DYfqJwcwVUJ Iw== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3dn5v1rxrs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 08:33:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jze39hJ5VzO6utGfJ/iXEvjBxrdsl2tbxRGbTEzVSXe07140lntvwOHoBdg84LUkvny9hX2anCVNR/gOjqifsyKvqOHsmJ+I6F53nhrLJrhzmPnpenfDkqW+zWeVVieviYqlcOvWFVEdw9NIusP5C3ui87wHjzWh4Ldx14OjPx7n3C0Y+CeZl8bY19eWZ2mmMOKdXH4DHvpjAb41bbDRJ6Gu8lOTMMbvMd2eZdhZAm2pE/yKVf7itgpUd7QSfuNMs0aNzN3k0nNEB5enPCvGeNyXg5y7tBnTh2OEcrCEOnnPLzfnL7jvlqrbCfCiinwPZO3Hbu9MZSFEq/hrvpOSsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cA88axY8DCvTXg0CPKwIqocFdqgbyRZKAIlEKY8QWbg=;
 b=Y7YgeZWdJVX9yK+17pa0zwc17ie/BZ+sf3vjqG7I0KWLHwR+Sb6h6soifBrjnvSy+wX5y8eV06IZZYv7tsBVdLQxUJyP7axzyzmcQ2FtORKGmoP+Il9tqnWwh0UHf/UpYjj948oIt41fUygmoFsW3uwFK4J1w7wJB239cPGF8h7XIP+bdUxBD0qcU4PXzdrdl9KHwM2ZhPmvU2/NHsVB59e00dDniFbD0AT0nVqyLbyghY9+AaTpFVuhdQ0aB0iy2VKVIFI+Bp+bGYZQOJ+vQ+pPhuCW6Gm14lH61pPtqdAU/q+m0AO8PQapc7XiqBHR7bZ/0taGO8gCNY2JfJPS4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CH0PR11MB5394.namprd11.prod.outlook.com (2603:10b6:610:b9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Tue, 18 Jan
 2022 16:33:05 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7d5a:c35:1ddb:11f3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::7d5a:c35:1ddb:11f3%8]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 16:33:05 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 2/2] Bluetooth: fix init and cleanup of sco_conn.timeout_work
Date:   Tue, 18 Jan 2022 18:32:40 +0200
Message-Id: <20220118163240.2892168-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220118163240.2892168-1-ovidiu.panait@windriver.com>
References: <20220118163240.2892168-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0242.eurprd07.prod.outlook.com
 (2603:10a6:802:58::45) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a16c714-5b5e-43f9-7087-08d9daa033df
X-MS-TrafficTypeDiagnostic: CH0PR11MB5394:EE_
X-Microsoft-Antispam-PRVS: <CH0PR11MB5394A5B680800F24A85DDA0DFE589@CH0PR11MB5394.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1122;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 83uZBRW2ZLxcVXqGJTccAL5LG9CzZWfCSdHqFMzSl5WpGf2+8Bt6hleQLHOI3XhopxhSutkpZeFZdSjSlBZ0MDt1R+a1BZVyyZaKsrSggkH/em9w6fKeH/C5fo760JJSvUB+0KdY5+d6hAW2IpGkitjnP7wYT76cOPfvKepVZUCIi4JcDbIfgd4rO5lXSLZIOKMDgu4Y4boHbPb2X0xhWLrIh5u/Rm2D6NOnCrG56mb+P35y91CY7tf1EUzapp/DIV0evtZZV+zSte4O3PTg2mJRd4XBCTsOcRoyVEcDRs8CiMM6p85qZbKS2eyft+yQvDw5uvugL9/oExHqYHfzXCbjjlCpHSYa7nTong6DWpMsdd9Yy3XdmOrlzofuyxiyzsd0Fy6ljJ1Z9u55iZq9LRCQx2KDdhqm1No4wWGs4vBvPvEconxiNCWhZ4LsEavEYjV7LavliJ4NRR9Rfa7MKZSApKT4nDCtg9rhOto19WwJKb+NJLMXUJI/XrXfyXZoC3C0zW2qTzktnQLEH59N5mF+qg7rH+VWRgnWxXpp/cKPdpC9i/hUIW9wTz+78PxD59eG8fK6x4RImE7RBP9ED5g8y0s0gmI0DPWu35luDq8J3y0L/jFUzfeCeTo0lKC5d+1KUuOVo8HuDQN59uU6kRpeLX6kVgTBsCRiQwpbx1jyHXOYAols/ZIdtnAf11WZC1CuY7QppCZXo8aVPJU3CQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(86362001)(38350700002)(1076003)(26005)(508600001)(66556008)(66476007)(2616005)(38100700002)(8936002)(66946007)(83380400001)(8676002)(44832011)(6512007)(2906002)(6486002)(316002)(6916009)(6666004)(6506007)(186003)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dmTmY0+GI8WDI+CrbNTAzw6ZLHxrsqvasZnml/t3RXJBc2ha3wRANUqpOhNr?=
 =?us-ascii?Q?OazVJIlQAQKZvv/akEdmzHkmHmX+h2OVxYWnkVx3ik6vfvNom1e2fNAxjAFT?=
 =?us-ascii?Q?+bRckg8J17n7JjiKoL8D4DxgY2+P4SmDKS2f2GHfFWcSJ05tAeKc970kUjTr?=
 =?us-ascii?Q?kiXiLsgwsiqFApsDvFOrsMczGEEEdbavFIDgGDpKLz9TXetNewIcuIa2FHOJ?=
 =?us-ascii?Q?X4eRvrlmd8fXWLo2ibaBciuxOQNT52QP4DwLS6n67v0k3rrMj4xflHAUKCFf?=
 =?us-ascii?Q?2NrpML6FLRH0uxZVsFBlaTqwGg+BV3MB1540phfCKLBGItF2og7myLri3fXi?=
 =?us-ascii?Q?bs3Mr2v00jJ+cqFkw2fpoxfr7VVUsxRvZ1fk0EO4QA5WhNenQC3JSEmlSKtJ?=
 =?us-ascii?Q?ZLiGwYCphbQB3eZA/ShJb7mEuyl++hOcTk3Ovh1N2X8CT2O1TmLbiTXtD3Rt?=
 =?us-ascii?Q?+6rNicQvhNYa2gPvJ8/3UB8eX3gSbglp+zWyOudQ5FPxaTrcCzHojXzpEjws?=
 =?us-ascii?Q?o2+JurtD2fRAXyXrJ3C26eESHueESzzSyhr6VudSYMMfQPvARcLYNsvwL8Qd?=
 =?us-ascii?Q?nbF5zfUHBkm0X7PYTeDGZvZ6gcD/ahzrDwWZLNHfOAYkdad6tW+vbp6AqPV3?=
 =?us-ascii?Q?c00OsY/PAx0ORJNXJRKPKl7/yZcBqYxMbaMp7IgwsmpdDAjZvfdTcJ0d2rxk?=
 =?us-ascii?Q?Qfz1SI3BQpnJH7qczIvF7B1sO51obN+1aVY2Q8MALyYec5S+EqME7LYNp4wy?=
 =?us-ascii?Q?nKH9Slp8xCrBR5/IH8nP7a9xw1spPLZtxqafkihX4yeD+OQt5Bvz9C5cdCE8?=
 =?us-ascii?Q?52KVx5D4gy/aLLg9v6tcfdcbCRD1TIeA7ZlPG8O52AG4Klvy4v8XTipT5BKY?=
 =?us-ascii?Q?WwlIWzmeSXe+yeWVxFJ4MeMTs35v/RyKkHkKdHbNdxallajYM37G0RwG1hdw?=
 =?us-ascii?Q?YM7F1Al/71oUGvx6P4QW+7S5/m6KGn27MUJsTzFAHcltZBAT/uAkcEDS4DSb?=
 =?us-ascii?Q?Fioa0JCkr5lIniApwK0QM3yuGr2tV5X/VtO9dgm90JTjD9Wl7Gblc7/v2vG5?=
 =?us-ascii?Q?FeIVXbUliRGelz5Q/n2eAwJsKSrvsQHYvp9d3QGmsA7WJjTaGHvBd+4egXTg?=
 =?us-ascii?Q?yayb9CZT6z37K9tA5swNziC2WJOhQQXgncbOw9umlfa9HVRMiZo1T9/iNQXQ?=
 =?us-ascii?Q?6eWvE44f8VjaucR87ZDobkqO4ybjQ3gJ8LgtPKjnvF/V+c8JBuxLC9ji/VEx?=
 =?us-ascii?Q?9ywbEk8neslfNzp1YnhW7dxFRJ/HLu0LvXSlTyPH2NC69EWlUjOcBcuQRwh1?=
 =?us-ascii?Q?Ck+UTrXvh8rKf6Hd1/ZVnoBMtehU9vHvtcihHZFJGpZKCqnlgbKbhsaKNw0A?=
 =?us-ascii?Q?lKW5fJ9GUKkAw4+xO0ecfMsvBmv6Jn+qTgY4Ny9jLt5nUQ8O1V3cq6qUYUW/?=
 =?us-ascii?Q?QDmH5lKO8E81fJGNgxwfjltz1ir8pKk9BBOVISv3kcN6mwublKXWuLcc5IR4?=
 =?us-ascii?Q?EmJlMyoQ6sBKZO/qVb7ATWvNfmyCKXWKeDzctxr/jsk/BDKj6NaGyTJ/Hz59?=
 =?us-ascii?Q?t/EWE/AIsXj4Ac7pLxcfjpuoVtfdZEzqpJMI2QJdgqJ7nNHbrD2nYShIJ482?=
 =?us-ascii?Q?znJ6SoP4zPMf6L+JiV8b4SIXTzDczZzRqJt4XnCDQkLC/jcOMLtDrm3cdj7i?=
 =?us-ascii?Q?C/N3qw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a16c714-5b5e-43f9-7087-08d9daa033df
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2022 16:33:05.2052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1D5NSIht2x+5IjlhwjthKTFRGY79KTZfncIRKVlFKVINeCZPGDV0ZYB+Lpr7tKRReWvAhxCoPbn01AoeukVAK0bENUv0kEnSUyvKqzo7XvY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5394
X-Proofpoint-ORIG-GUID: knizJQK3EjDaBws1SDIu4aUM42DUK2IF
X-Proofpoint-GUID: knizJQK3EjDaBws1SDIu4aUM42DUK2IF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_04,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 mlxscore=0 adultscore=0 impostorscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180101
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>

commit 49d8a5606428ca0962d09050a5af81461ff90fbb upstream.

Before freeing struct sco_conn, all delayed timeout work should be
cancelled. Otherwise, sco_sock_timeout could potentially use the
sco_conn after it has been freed.

Additionally, sco_conn.timeout_work should be initialized when the
connection is allocated, not when the channel is added. This is
because an sco_conn can create channels with multiple sockets over its
lifetime, which happens if sockets are released but the connection
isn't deleted.

Fixes: ba316be1b6a0 ("Bluetooth: schedule SCO timeouts with delayed_work")
Signed-off-by: Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[OP: adjusted context for 4.14]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 net/bluetooth/sco.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 69d489f1f363..5c411118b30d 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -133,6 +133,7 @@ static struct sco_conn *sco_conn_add(struct hci_conn *hcon)
 		return NULL;
 
 	spin_lock_init(&conn->lock);
+	INIT_DELAYED_WORK(&conn->timeout_work, sco_sock_timeout);
 
 	hcon->sco_data = conn;
 	conn->hcon = hcon;
@@ -196,11 +197,11 @@ static void sco_conn_del(struct hci_conn *hcon, int err)
 		sco_chan_del(sk, err);
 		bh_unlock_sock(sk);
 		sock_put(sk);
-
-		/* Ensure no more work items will run before freeing conn. */
-		cancel_delayed_work_sync(&conn->timeout_work);
 	}
 
+	/* Ensure no more work items will run before freeing conn. */
+	cancel_delayed_work_sync(&conn->timeout_work);
+
 	hcon->sco_data = NULL;
 	kfree(conn);
 }
@@ -213,8 +214,6 @@ static void __sco_chan_add(struct sco_conn *conn, struct sock *sk,
 	sco_pi(sk)->conn = conn;
 	conn->sk = sk;
 
-	INIT_DELAYED_WORK(&conn->timeout_work, sco_sock_timeout);
-
 	if (parent)
 		bt_accept_enqueue(parent, sk, true);
 }
-- 
2.25.1

