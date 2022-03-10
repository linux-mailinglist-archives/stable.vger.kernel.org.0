Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9194D405C
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 05:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236959AbiCJElu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 23:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiCJElt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 23:41:49 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13A211C7C5;
        Wed,  9 Mar 2022 20:40:46 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22A1MOx1002638;
        Thu, 10 Mar 2022 04:40:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=Wn/CEA22Kpc0/cQmR/b41ohCjF1zIAY6NAM9PfvMAxs=;
 b=kVz/o6hXi/+Z9sdCzUnjnVbOAUduCk8fOqs26Lvgno7ojzDjqW5/2YlIBIH20eE/8ww7
 5UdOUJYJj29LSF7+QJbGK4JTaPyRQzK0WF0icPAYb6e2IEjwXbJkT4AK7svUU39lqwXd
 cAC9qjbskUvUp3Er0D/fJ7CvtRe2mBHeIR4u5hoZ3c5nlx/pb7jIrxg//03q+AMPfRVP
 2n+7vbToIIFUTMBAQSmbjr40Y4KNEEffCMxBr0D1tpaEdBWsEfe5VTLvJJU0863jHVSO
 Lh/J4t7gl0MWAPqpQ+tyA6EQVqFx18fzOE52PH8yRuhmIBYa7mu+1T/yBc6xzNQZZZ+Z eg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekx9ckv1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Mar 2022 04:40:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22A4Ziww110914;
        Thu, 10 Mar 2022 04:40:42 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by aserp3030.oracle.com with ESMTP id 3ekwwd6fma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Mar 2022 04:40:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZInSCMVc8FVEvLCTRfmhsaqScNICfovip/8CG5h3ysjXxe93u4cTZlzDAkwttMSEbMnW+irZKfGSzeD9TNgwc81/DkQ5qAT9ByiUHXfNCCZ3cHJCe2yBmSFXQdmjpXm0SfNTCHlDLZVQspIikK0n/FPvbG9rNrAYEqRcYS57FFLS3DoZpnSYow/xYBNyHSA8V8gUamKKA5nC36N1vyxWJFZ3UUGr8FdedhdT0zb16IhPgasg+NFDDgmM15OPP/ts1re4OIKv0LonW+OO3cL//sKVWL5gDGjYyZkmMIE/H3w8SrsT9Q5PoFRNUlAvbT3qwilzWmedXgxY4yN30Bq+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wn/CEA22Kpc0/cQmR/b41ohCjF1zIAY6NAM9PfvMAxs=;
 b=ev/WTqIoQQMhFJds5rTnTmULIh9VUNHLa9s9c3HkBSpRsXKAA6VIdJ95wfplpct1OtU43lSwvMmt1k06kFTp2fZRqaueM60W9X/xql/W58ZyzM5gjkTIelKwnA9/XMUapRM/FBDdjKAloRc9Bb8J3KaXXxGlMhWxpdVeoanURiKa6+tuXlu7jEKSQdJrc9fAGS0/cj83+ir5IFKtNd+gBXSoaCnpYMYxI+XBLI0iwcl/Z/15dFBZxdV5l8Gad39TZeayxx1WAPtny4MNzQKEcaIMmzFgeJQjAlR6N35i3uu5xNbkbjI5810CNwPnGfL45ptZQYl3ySnIMvpW1iGHlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wn/CEA22Kpc0/cQmR/b41ohCjF1zIAY6NAM9PfvMAxs=;
 b=rqIM8IB64qxWQfnMUJlqq9QT5UtQ5HIDrMQM8Y45MhO+BwMQUxyHmiJmaAq6o8s4tla+zuEFLbUMr7FTF2CECITht/ieeHQ9/V+Kvt81B4lgMsdIvnQYs6fGYPaYflt4WbB+65KQpVtQTHhht58z5GjYHenxhLLAOHssjJdvh4g=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by BN8PR10MB3411.namprd10.prod.outlook.com (2603:10b6:408:cb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Thu, 10 Mar
 2022 04:40:38 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d469:7ab:8ae2:1e6f]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d469:7ab:8ae2:1e6f%6]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 04:40:38 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH stable-5.15.y stable-5.16.y] btrfs: make send work with concurrent block group relocation
Date:   Thu, 10 Mar 2022 12:40:23 +0800
Message-Id: <bc51b8d12cfc0768a8e4965cce9814901bc5e0c9.1646885512.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0112.apcprd06.prod.outlook.com
 (2603:1096:1:1d::14) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d02b8e77-5459-42d4-b65a-08da02501fa7
X-MS-TrafficTypeDiagnostic: BN8PR10MB3411:EE_
X-Microsoft-Antispam-PRVS: <BN8PR10MB3411382D7F6966CAAB6A3D41E50B9@BN8PR10MB3411.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qq8lO+ZB0eJdnfDIi3sniSSDLg2WEAnnSTmdDWb4Fofj9IY7UBH9LFymRmyfyxRQyrCaq+yg1weS6T9LwdowU07Sbg5FqxUi9eMiQY3jGaJcHq486k5j0pXUNsK0wE7U9cn9Lqmh2XLj/hI5fdEyuPaB0dZavH183PSRo0ZQFGumMcHwVpXJdWZfZQQgFlbqNWdqY3xeRK7MgdHwAEdIqmI4ns6ILCGW+oP5Q9t6EEL5fFa+whDxJMprMVxFtxOwjyWlR+lAYvQ3mVne8xYdnXpIaKew7F7kmQq31wUkoL2q8tgZV4eydvt4cpJgnvmZcfgvn19ImIbzEQKpg64YxvmNJ0GT/FSDZuPf5O0vWrRYMf9k69Z30QYWhVJE6LcpTv8fSAsP0r5FWtfbSA0zNetp6oEkSdnnETCQlOs2kQu6zmX2K0g0AUwzmbIyUKJLV4DS265CaQ6QLXo2yTR8Gp5S8zvGMn1iAlOPScK1pU9C9PGKCyef8vVCAR57gf9610QNYRfSkIlURfSKi4ZpXvRJbW9OZF7DGBNzs1U/LZgGI2OQD33WKXV1Hl1grzgAFqNWGSEV4ajxbxglOYYWA8xG6BAWIlwHL2It7bngVBvffJxNaqNnr0jxJmyPsHMpJ8ZRtnBPmxpYoIusPx4Pqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(26005)(6666004)(107886003)(86362001)(186003)(6512007)(6486002)(38100700002)(83380400001)(2616005)(6506007)(5660300002)(8936002)(8676002)(4326008)(66946007)(66556008)(66476007)(30864003)(36756003)(44832011)(2906002)(54906003)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nxKDGSEQ6ho3eN8HuJj30oGfWv6zedANEsqj84lTR9ouM0Me2E8B9XodxU3M?=
 =?us-ascii?Q?Q+zpnZZeDwiTltchQnHpbR2wAOEkrh7NjpHd9TptipwIYfsGbHE/dby+odWn?=
 =?us-ascii?Q?I1IjJB0JoQNALBWbO1tKRA5OdLC9YafS66J5pyMiFDes6y2Tx21ghVvFnAJD?=
 =?us-ascii?Q?nTDvlqNDglCBFBWn4+gAsjs+0pp62RprN4HZWRwP7zzqXVhe6tlom7c0ewVn?=
 =?us-ascii?Q?wrHZUUWU7uIyGWbQ8y0Bpe9/5Gxr1i5xNv6LjK7ecVf9u7wnjuoPAPiKind5?=
 =?us-ascii?Q?EaiZYWZPEn7QdkN5Cx3k2ywh1s4P95jIdSY1RqwKm620BJ/yfr9HXmUByNwO?=
 =?us-ascii?Q?/h2KrCed59WWVazYnXOHO4T3s/xI476fJC1bIxd4fu6kiJfHdHNfwwqdQgNw?=
 =?us-ascii?Q?0MDrvzu+E+tHpsdoV/LE1YYp+ynaWX85/SzlVMUhoVGYJnjfwkDHCaD1wsOY?=
 =?us-ascii?Q?FOqgQ5Rjtu25tH0rAcqPV3h6al93uvmh1Y3Ufl/j/P6C/bFrfTizHaCOPmX8?=
 =?us-ascii?Q?s5psTKaDtTvcoUEeDhl+TQRR4p6LodfHNWMeMg/Jo1uVMogQme378uzxC3wU?=
 =?us-ascii?Q?Hpqi9FW42M2Y3lfCiETT+F1mNCdvlP+8HL39DXsZPN6UjxWnQAIwi4Yol68m?=
 =?us-ascii?Q?2CC98O261xTSnuoRdZAFLul72QF9DRk6mnOmzIWK1Zh7vDIxnOrp6879IvPA?=
 =?us-ascii?Q?TCgZdzQiXC4vLIKezNr29mFUgYwxbNmwhYYGBsV7hv4NNVRh7Y1zZDENxNJZ?=
 =?us-ascii?Q?X2EhXw4PNOb+LnBKGNOF2GppXcLz2TeMY9YRwfpkN1CwwfwP0e1ta/dqGhPp?=
 =?us-ascii?Q?kj/tX5/pAoybU6MIqGhMxnxaXy4nQeFqJ/arTHIZPXZm9+P5GYO6iPQJIJ+F?=
 =?us-ascii?Q?iqir26FIeZDPYjlA60KT5B7jHbD7sJtZhMxbpEj8zM94bLmiyxOCJK16CUvu?=
 =?us-ascii?Q?9kBJDrnVchqYzU01UY1azeI6mNeBpKl5Mdcadax+jBb8TEs2f8WFWnxLaRC8?=
 =?us-ascii?Q?2UgRnBZPOvQnEUtHnm0fskVbN2DTPogFbtoOKZL+cRyoRXc1LzQ0A17/x6jr?=
 =?us-ascii?Q?iqww/lY5c7OqHqvutYI7t0MoLkWo/twYlf+zSx+sqM6IvVdZ+GzGq1nRMRSL?=
 =?us-ascii?Q?wUs60vQSeVYVNpN1VSxFb+JJ9H/DNfNzfNCjIR5w4O6J2/BFVJBZ167Ky+/J?=
 =?us-ascii?Q?JnWo65MLr+Lwmnqr4Jev3YGFjkP8WGckYRdDZgylVBoUpjIXssPv2aUC7lyD?=
 =?us-ascii?Q?2o5XBZohYb/c79p9ezFH/KRuSVNEEI5iVgxDErVi8zEtl6EoVv+EPAIMhv7I?=
 =?us-ascii?Q?QQSE+Q39SWkmS30Vr3AD1gyv+HaUIkzdwlCrAA2gnC7W0gPgnpXsNIvWRaFK?=
 =?us-ascii?Q?EXPzmoDz+lweuyRBrk6EtZKZG/Q+S1bEAMsWHjgEz8xMfUinYGYxAyudXImV?=
 =?us-ascii?Q?USw1ntpzSmaz84urpCN1Va1afXHSw1YBoIzV0pt1zVM/wIYX4GRMW43dTlVN?=
 =?us-ascii?Q?5u8etPNcls9Y9KaJOv7XvbKHJK3t+1I5ejTsz9tJYWtqggwzA4lrWU7mm0Iq?=
 =?us-ascii?Q?wU3Ozpk8B/XOuCUmuEICP4yaBTgCqxHcPD/viL2Wmm/Kg9zL9c1d5hqXPlwc?=
 =?us-ascii?Q?MQvSIH6gvLagMziRVjblDKo=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d02b8e77-5459-42d4-b65a-08da02501fa7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 04:40:38.1038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +UHN5c8nILaEgrpdxoERA9dRUp9WSwj6ydQH/UkN0tN9VHe7SWoQ4ioJw6fDtX6aSmezgSgAqGEgF+5fi+v0Uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3411
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203100022
X-Proofpoint-ORIG-GUID: OD0LsehDpRLdMFD2nMljOUeCw9aWT44A
X-Proofpoint-GUID: OD0LsehDpRLdMFD2nMljOUeCw9aWT44A
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

Commit d96b34248c2f4ea8cd09286090f2f6f77102eaab upstream.

We don't allow send and balance/relocation to run in parallel in order
to prevent send failing or silently producing some bad stream. This is
because while send is using an extent (specially metadata) or about to
read a metadata extent and expecting it belongs to a specific parent
node, relocation can run, the transaction used for the relocation is
committed and the extent gets reallocated while send is still using the
extent, so it ends up with a different content than expected. This can
result in just failing to read a metadata extent due to failure of the
validation checks (parent transid, level, etc), failure to find a
backreference for a data extent, and other unexpected failures. Besides
reallocation, there's also a similar problem of an extent getting
discarded when it's unpinned after the transaction used for block group
relocation is committed.

The restriction between balance and send was added in commit 9e967495e0e0
("Btrfs: prevent send failures and crashes due to concurrent relocation"),
kernel 5.3, while the more general restriction between send and relocation
was added in commit 1cea5cf0e664 ("btrfs: ensure relocation never runs
while we have send operations running"), kernel 5.14.

Both send and relocation can be very long running operations. Relocation
because it has to do a lot of IO and expensive backreference lookups in
case there are many snapshots, and send due to read IO when operating on
very large trees. This makes it inconvenient for users and tools to deal
with scheduling both operations.

For zoned filesystem we also have automatic block group relocation, so
send can fail with -EAGAIN when users least expect it or send can end up
delaying the block group relocation for too long. In the future we might
also get the automatic block group relocation for non zoned filesystems.

This change makes it possible for send and relocation to run in parallel.
This is achieved the following way:

1) For all tree searches, send acquires a read lock on the commit root
   semaphore;

2) After each tree search, and before releasing the commit root semaphore,
   the leaf is cloned and placed in the search path (struct btrfs_path);

3) After releasing the commit root semaphore, the changed_cb() callback
   is invoked, which operates on the leaf and writes commands to the pipe
   (or file in case send/receive is not used with a pipe). It's important
   here to not hold a lock on the commit root semaphore, because if we did
   we could deadlock when sending and receiving to the same filesystem
   using a pipe - the send task blocks on the pipe because it's full, the
   receive task, which is the only consumer of the pipe, triggers a
   transaction commit when attempting to create a subvolume or reserve
   space for a write operation for example, but the transaction commit
   blocks trying to write lock the commit root semaphore, resulting in a
   deadlock;

4) Before moving to the next key, or advancing to the next change in case
   of an incremental send, check if a transaction used for relocation was
   committed (or is about to finish its commit). If so, release the search
   path(s) and restart the search, to where we were before, so that we
   don't operate on stale extent buffers. The search restarts are always
   possible because both the send and parent roots are RO, and no one can
   add, remove of update keys (change their offset) in RO trees - the
   only exception is deduplication, but that is still not allowed to run
   in parallel with send;

5) Periodically check if there is contention on the commit root semaphore,
   which means there is a transaction commit trying to write lock it, and
   release the semaphore and reschedule if there is contention, so as to
   avoid causing any significant delays to transaction commits.

This leaves some room for optimizations for send to have less path
releases and re searching the trees when there's relocation running, but
for now it's kept simple as it performs quite well (on very large trees
with resulting send streams in the order of a few hundred gigabytes).

Test case btrfs/187, from fstests, stresses relocation, send and
deduplication attempting to run in parallel, but without verifying if send
succeeds and if it produces correct streams. A new test case will be added
that exercises relocation happening in parallel with send and then checks
that send succeeds and the resulting streams are correct.

A final note is that for now this still leaves the mutual exclusion
between send operations and deduplication on files belonging to a root
used by send operations. A solution for that will be slightly more complex
but it will eventually be built on top of this change.

Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/block-group.c |   9 +-
 fs/btrfs/ctree.c       |  98 ++++++++---
 fs/btrfs/ctree.h       |  14 +-
 fs/btrfs/disk-io.c     |   4 +-
 fs/btrfs/relocation.c  |  13 --
 fs/btrfs/send.c        | 357 +++++++++++++++++++++++++++++++++++------
 fs/btrfs/transaction.c |   4 +
 7 files changed, 395 insertions(+), 104 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index d721c66d0b41..5edd07e0232d 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -1491,7 +1491,6 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 		container_of(work, struct btrfs_fs_info, reclaim_bgs_work);
 	struct btrfs_block_group *bg;
 	struct btrfs_space_info *space_info;
-	LIST_HEAD(again_list);
 
 	if (!test_bit(BTRFS_FS_OPEN, &fs_info->flags))
 		return;
@@ -1562,18 +1561,14 @@ void btrfs_reclaim_bgs_work(struct work_struct *work)
 				div64_u64(zone_unusable * 100, bg->length));
 		trace_btrfs_reclaim_block_group(bg);
 		ret = btrfs_relocate_chunk(fs_info, bg->start);
-		if (ret && ret != -EAGAIN)
+		if (ret)
 			btrfs_err(fs_info, "error relocating chunk %llu",
 				  bg->start);
 
 next:
+		btrfs_put_block_group(bg);
 		spin_lock(&fs_info->unused_bgs_lock);
-		if (ret == -EAGAIN && list_empty(&bg->bg_list))
-			list_add_tail(&bg->bg_list, &again_list);
-		else
-			btrfs_put_block_group(bg);
 	}
-	list_splice_tail(&again_list, &fs_info->reclaim_bgs);
 	spin_unlock(&fs_info->unused_bgs_lock);
 	mutex_unlock(&fs_info->reclaim_bgs_lock);
 	btrfs_exclop_finish(fs_info);
diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
index 95a6a63caf04..899f85445925 100644
--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -1566,32 +1566,13 @@ static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_root *root,
 							struct btrfs_path *p,
 							int write_lock_level)
 {
-	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *b;
 	int root_lock = 0;
 	int level = 0;
 
 	if (p->search_commit_root) {
-		/*
-		 * The commit roots are read only so we always do read locks,
-		 * and we always must hold the commit_root_sem when doing
-		 * searches on them, the only exception is send where we don't
-		 * want to block transaction commits for a long time, so
-		 * we need to clone the commit root in order to avoid races
-		 * with transaction commits that create a snapshot of one of
-		 * the roots used by a send operation.
-		 */
-		if (p->need_commit_sem) {
-			down_read(&fs_info->commit_root_sem);
-			b = btrfs_clone_extent_buffer(root->commit_root);
-			up_read(&fs_info->commit_root_sem);
-			if (!b)
-				return ERR_PTR(-ENOMEM);
-
-		} else {
-			b = root->commit_root;
-			atomic_inc(&b->refs);
-		}
+		b = root->commit_root;
+		atomic_inc(&b->refs);
 		level = btrfs_header_level(b);
 		/*
 		 * Ensure that all callers have set skip_locking when
@@ -1657,6 +1638,42 @@ static struct extent_buffer *btrfs_search_slot_get_root(struct btrfs_root *root,
 	return b;
 }
 
+/*
+ * Replace the extent buffer at the lowest level of the path with a cloned
+ * version. The purpose is to be able to use it safely, after releasing the
+ * commit root semaphore, even if relocation is happening in parallel, the
+ * transaction used for relocation is committed and the extent buffer is
+ * reallocated in the next transaction.
+ *
+ * This is used in a context where the caller does not prevent transaction
+ * commits from happening, either by holding a transaction handle or holding
+ * some lock, while it's doing searches through a commit root.
+ * At the moment it's only used for send operations.
+ */
+static int finish_need_commit_sem_search(struct btrfs_path *path)
+{
+	const int i = path->lowest_level;
+	const int slot = path->slots[i];
+	struct extent_buffer *lowest = path->nodes[i];
+	struct extent_buffer *clone;
+
+	ASSERT(path->need_commit_sem);
+
+	if (!lowest)
+		return 0;
+
+	lockdep_assert_held_read(&lowest->fs_info->commit_root_sem);
+
+	clone = btrfs_clone_extent_buffer(lowest);
+	if (!clone)
+		return -ENOMEM;
+
+	btrfs_release_path(path);
+	path->nodes[i] = clone;
+	path->slots[i] = slot;
+
+	return 0;
+}
 
 /*
  * btrfs_search_slot - look for a key in a tree and perform necessary
@@ -1693,6 +1710,7 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 		      const struct btrfs_key *key, struct btrfs_path *p,
 		      int ins_len, int cow)
 {
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct extent_buffer *b;
 	int slot;
 	int ret;
@@ -1734,6 +1752,11 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 
 	min_write_lock_level = write_lock_level;
 
+	if (p->need_commit_sem) {
+		ASSERT(p->search_commit_root);
+		down_read(&fs_info->commit_root_sem);
+	}
+
 again:
 	prev_cmp = -1;
 	b = btrfs_search_slot_get_root(root, p, write_lock_level);
@@ -1928,6 +1951,16 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
 done:
 	if (ret < 0 && !p->skip_release_on_error)
 		btrfs_release_path(p);
+
+	if (p->need_commit_sem) {
+		int ret2;
+
+		ret2 = finish_need_commit_sem_search(p);
+		up_read(&fs_info->commit_root_sem);
+		if (ret2)
+			ret = ret2;
+	}
+
 	return ret;
 }
 ALLOW_ERROR_INJECTION(btrfs_search_slot, ERRNO);
@@ -4396,7 +4429,9 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
 	int level;
 	struct extent_buffer *c;
 	struct extent_buffer *next;
+	struct btrfs_fs_info *fs_info = root->fs_info;
 	struct btrfs_key key;
+	bool need_commit_sem = false;
 	u32 nritems;
 	int ret;
 	int i;
@@ -4413,14 +4448,20 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
 
 	path->keep_locks = 1;
 
-	if (time_seq)
+	if (time_seq) {
 		ret = btrfs_search_old_slot(root, &key, path, time_seq);
-	else
+	} else {
+		if (path->need_commit_sem) {
+			path->need_commit_sem = 0;
+			need_commit_sem = true;
+			down_read(&fs_info->commit_root_sem);
+		}
 		ret = btrfs_search_slot(NULL, root, &key, path, 0, 0);
+	}
 	path->keep_locks = 0;
 
 	if (ret < 0)
-		return ret;
+		goto done;
 
 	nritems = btrfs_header_nritems(path->nodes[0]);
 	/*
@@ -4543,6 +4584,15 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
 	ret = 0;
 done:
 	unlock_up(path, 0, 1, 0, NULL);
+	if (need_commit_sem) {
+		int ret2;
+
+		path->need_commit_sem = 1;
+		ret2 = finish_need_commit_sem_search(path);
+		up_read(&fs_info->commit_root_sem);
+		if (ret2)
+			ret = ret2;
+	}
 
 	return ret;
 }
diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index b46409801647..e89f814cc8f5 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -568,7 +568,6 @@ enum {
 	/*
 	 * Indicate that relocation of a chunk has started, it's set per chunk
 	 * and is toggled between chunks.
-	 * Set, tested and cleared while holding fs_info::send_reloc_lock.
 	 */
 	BTRFS_FS_RELOC_RUNNING,
 
@@ -668,6 +667,12 @@ struct btrfs_fs_info {
 
 	u64 generation;
 	u64 last_trans_committed;
+	/*
+	 * Generation of the last transaction used for block group relocation
+	 * since the filesystem was last mounted (or 0 if none happened yet).
+	 * Must be written and read while holding btrfs_fs_info::commit_root_sem.
+	 */
+	u64 last_reloc_trans;
 	u64 avg_delayed_ref_runtime;
 
 	/*
@@ -997,13 +1002,6 @@ struct btrfs_fs_info {
 
 	struct crypto_shash *csum_shash;
 
-	spinlock_t send_reloc_lock;
-	/*
-	 * Number of send operations in progress.
-	 * Updated while holding fs_info::send_reloc_lock.
-	 */
-	int send_in_progress;
-
 	/* Type of exclusive operation running, protected by super_lock */
 	enum btrfs_exclusive_operation exclusive_operation;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2180fcef56ca..d5a590b11be5 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2859,6 +2859,7 @@ static int __cold init_tree_roots(struct btrfs_fs_info *fs_info)
 		/* All successful */
 		fs_info->generation = generation;
 		fs_info->last_trans_committed = generation;
+		fs_info->last_reloc_trans = 0;
 
 		/* Always begin writing backup roots after the one being used */
 		if (backup_index < 0) {
@@ -2992,9 +2993,6 @@ void btrfs_init_fs_info(struct btrfs_fs_info *fs_info)
 	spin_lock_init(&fs_info->swapfile_pins_lock);
 	fs_info->swapfile_pins = RB_ROOT;
 
-	spin_lock_init(&fs_info->send_reloc_lock);
-	fs_info->send_in_progress = 0;
-
 	fs_info->bg_reclaim_threshold = BTRFS_DEFAULT_RECLAIM_THRESH;
 	INIT_WORK(&fs_info->reclaim_bgs_work, btrfs_reclaim_bgs_work);
 }
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index a050f9748fa7..a6661f2ad2c0 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -3854,25 +3854,14 @@ struct inode *create_reloc_inode(struct btrfs_fs_info *fs_info,
  *   0             success
  *   -EINPROGRESS  operation is already in progress, that's probably a bug
  *   -ECANCELED    cancellation request was set before the operation started
- *   -EAGAIN       can not start because there are ongoing send operations
  */
 static int reloc_chunk_start(struct btrfs_fs_info *fs_info)
 {
-	spin_lock(&fs_info->send_reloc_lock);
-	if (fs_info->send_in_progress) {
-		btrfs_warn_rl(fs_info,
-"cannot run relocation while send operations are in progress (%d in progress)",
-			      fs_info->send_in_progress);
-		spin_unlock(&fs_info->send_reloc_lock);
-		return -EAGAIN;
-	}
 	if (test_and_set_bit(BTRFS_FS_RELOC_RUNNING, &fs_info->flags)) {
 		/* This should not happen */
-		spin_unlock(&fs_info->send_reloc_lock);
 		btrfs_err(fs_info, "reloc already running, cannot start");
 		return -EINPROGRESS;
 	}
-	spin_unlock(&fs_info->send_reloc_lock);
 
 	if (atomic_read(&fs_info->reloc_cancel_req) > 0) {
 		btrfs_info(fs_info, "chunk relocation canceled on start");
@@ -3894,9 +3883,7 @@ static void reloc_chunk_end(struct btrfs_fs_info *fs_info)
 	/* Requested after start, clear bit first so any waiters can continue */
 	if (atomic_read(&fs_info->reloc_cancel_req) > 0)
 		btrfs_info(fs_info, "chunk relocation canceled during operation");
-	spin_lock(&fs_info->send_reloc_lock);
 	clear_and_wake_up_bit(BTRFS_FS_RELOC_RUNNING, &fs_info->flags);
-	spin_unlock(&fs_info->send_reloc_lock);
 	atomic_set(&fs_info->reloc_cancel_req, 0);
 }
 
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 5612e8bf2ace..4d2c6ce29fe5 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -24,6 +24,7 @@
 #include "transaction.h"
 #include "compression.h"
 #include "xattr.h"
+#include "print-tree.h"
 
 /*
  * Maximum number of references an extent can have in order for us to attempt to
@@ -95,6 +96,15 @@ struct send_ctx {
 	struct btrfs_path *right_path;
 	struct btrfs_key *cmp_key;
 
+	/*
+	 * Keep track of the generation of the last transaction that was used
+	 * for relocating a block group. This is periodically checked in order
+	 * to detect if a relocation happened since the last check, so that we
+	 * don't operate on stale extent buffers for nodes (level >= 1) or on
+	 * stale disk_bytenr values of file extent items.
+	 */
+	u64 last_reloc_trans;
+
 	/*
 	 * infos of the currently processed inode. In case of deleted inodes,
 	 * these are the values from the deleted inode.
@@ -1415,6 +1425,26 @@ static int find_extent_clone(struct send_ctx *sctx,
 	if (ret < 0)
 		goto out;
 
+	down_read(&fs_info->commit_root_sem);
+	if (fs_info->last_reloc_trans > sctx->last_reloc_trans) {
+		/*
+		 * A transaction commit for a transaction in which block group
+		 * relocation was done just happened.
+		 * The disk_bytenr of the file extent item we processed is
+		 * possibly stale, referring to the extent's location before
+		 * relocation. So act as if we haven't found any clone sources
+		 * and fallback to write commands, which will read the correct
+		 * data from the new extent location. Otherwise we will fail
+		 * below because we haven't found our own back reference or we
+		 * could be getting incorrect sources in case the old extent
+		 * was already reallocated after the relocation.
+		 */
+		up_read(&fs_info->commit_root_sem);
+		ret = -ENOENT;
+		goto out;
+	}
+	up_read(&fs_info->commit_root_sem);
+
 	if (!backref_ctx.found_itself) {
 		/* found a bug in backref code? */
 		ret = -EIO;
@@ -6596,6 +6626,50 @@ static int changed_cb(struct btrfs_path *left_path,
 {
 	int ret = 0;
 
+	/*
+	 * We can not hold the commit root semaphore here. This is because in
+	 * the case of sending and receiving to the same filesystem, using a
+	 * pipe, could result in a deadlock:
+	 *
+	 * 1) The task running send blocks on the pipe because it's full;
+	 *
+	 * 2) The task running receive, which is the only consumer of the pipe,
+	 *    is waiting for a transaction commit (for example due to a space
+	 *    reservation when doing a write or triggering a transaction commit
+	 *    when creating a subvolume);
+	 *
+	 * 3) The transaction is waiting to write lock the commit root semaphore,
+	 *    but can not acquire it since it's being held at 1).
+	 *
+	 * Down this call chain we write to the pipe through kernel_write().
+	 * The same type of problem can also happen when sending to a file that
+	 * is stored in the same filesystem - when reserving space for a write
+	 * into the file, we can trigger a transaction commit.
+	 *
+	 * Our caller has supplied us with clones of leaves from the send and
+	 * parent roots, so we're safe here from a concurrent relocation and
+	 * further reallocation of metadata extents while we are here. Below we
+	 * also assert that the leaves are clones.
+	 */
+	lockdep_assert_not_held(&sctx->send_root->fs_info->commit_root_sem);
+
+	/*
+	 * We always have a send root, so left_path is never NULL. We will not
+	 * have a leaf when we have reached the end of the send root but have
+	 * not yet reached the end of the parent root.
+	 */
+	if (left_path->nodes[0])
+		ASSERT(test_bit(EXTENT_BUFFER_UNMAPPED,
+				&left_path->nodes[0]->bflags));
+	/*
+	 * When doing a full send we don't have a parent root, so right_path is
+	 * NULL. When doing an incremental send, we may have reached the end of
+	 * the parent root already, so we don't have a leaf at right_path.
+	 */
+	if (right_path && right_path->nodes[0])
+		ASSERT(test_bit(EXTENT_BUFFER_UNMAPPED,
+				&right_path->nodes[0]->bflags));
+
 	if (result == BTRFS_COMPARE_TREE_SAME) {
 		if (key->type == BTRFS_INODE_REF_KEY ||
 		    key->type == BTRFS_INODE_EXTREF_KEY) {
@@ -6642,14 +6716,46 @@ static int changed_cb(struct btrfs_path *left_path,
 	return ret;
 }
 
+static int search_key_again(const struct send_ctx *sctx,
+			    struct btrfs_root *root,
+			    struct btrfs_path *path,
+			    const struct btrfs_key *key)
+{
+	int ret;
+
+	if (!path->need_commit_sem)
+		lockdep_assert_held_read(&root->fs_info->commit_root_sem);
+
+	/*
+	 * Roots used for send operations are readonly and no one can add,
+	 * update or remove keys from them, so we should be able to find our
+	 * key again. The only exception is deduplication, which can operate on
+	 * readonly roots and add, update or remove keys to/from them - but at
+	 * the moment we don't allow it to run in parallel with send.
+	 */
+	ret = btrfs_search_slot(NULL, root, key, path, 0, 0);
+	ASSERT(ret <= 0);
+	if (ret > 0) {
+		btrfs_print_tree(path->nodes[path->lowest_level], false);
+		btrfs_err(root->fs_info,
+"send: key (%llu %u %llu) not found in %s root %llu, lowest_level %d, slot %d",
+			  key->objectid, key->type, key->offset,
+			  (root == sctx->parent_root ? "parent" : "send"),
+			  root->root_key.objectid, path->lowest_level,
+			  path->slots[path->lowest_level]);
+		return -EUCLEAN;
+	}
+
+	return ret;
+}
+
 static int full_send_tree(struct send_ctx *sctx)
 {
 	int ret;
 	struct btrfs_root *send_root = sctx->send_root;
 	struct btrfs_key key;
+	struct btrfs_fs_info *fs_info = send_root->fs_info;
 	struct btrfs_path *path;
-	struct extent_buffer *eb;
-	int slot;
 
 	path = alloc_path_for_send();
 	if (!path)
@@ -6660,6 +6766,10 @@ static int full_send_tree(struct send_ctx *sctx)
 	key.type = BTRFS_INODE_ITEM_KEY;
 	key.offset = 0;
 
+	down_read(&fs_info->commit_root_sem);
+	sctx->last_reloc_trans = fs_info->last_reloc_trans;
+	up_read(&fs_info->commit_root_sem);
+
 	ret = btrfs_search_slot_for_read(send_root, &key, path, 1, 0);
 	if (ret < 0)
 		goto out;
@@ -6667,15 +6777,35 @@ static int full_send_tree(struct send_ctx *sctx)
 		goto out_finish;
 
 	while (1) {
-		eb = path->nodes[0];
-		slot = path->slots[0];
-		btrfs_item_key_to_cpu(eb, &key, slot);
+		btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
 
 		ret = changed_cb(path, NULL, &key,
 				 BTRFS_COMPARE_TREE_NEW, sctx);
 		if (ret < 0)
 			goto out;
 
+		down_read(&fs_info->commit_root_sem);
+		if (fs_info->last_reloc_trans > sctx->last_reloc_trans) {
+			sctx->last_reloc_trans = fs_info->last_reloc_trans;
+			up_read(&fs_info->commit_root_sem);
+			/*
+			 * A transaction used for relocating a block group was
+			 * committed or is about to finish its commit. Release
+			 * our path (leaf) and restart the search, so that we
+			 * avoid operating on any file extent items that are
+			 * stale, with a disk_bytenr that reflects a pre
+			 * relocation value. This way we avoid as much as
+			 * possible to fallback to regular writes when checking
+			 * if we can clone file ranges.
+			 */
+			btrfs_release_path(path);
+			ret = search_key_again(sctx, send_root, path, &key);
+			if (ret < 0)
+				goto out;
+		} else {
+			up_read(&fs_info->commit_root_sem);
+		}
+
 		ret = btrfs_next_item(send_root, path);
 		if (ret < 0)
 			goto out;
@@ -6693,6 +6823,20 @@ static int full_send_tree(struct send_ctx *sctx)
 	return ret;
 }
 
+static int replace_node_with_clone(struct btrfs_path *path, int level)
+{
+	struct extent_buffer *clone;
+
+	clone = btrfs_clone_extent_buffer(path->nodes[level]);
+	if (!clone)
+		return -ENOMEM;
+
+	free_extent_buffer(path->nodes[level]);
+	path->nodes[level] = clone;
+
+	return 0;
+}
+
 static int tree_move_down(struct btrfs_path *path, int *level, u64 reada_min_gen)
 {
 	struct extent_buffer *eb;
@@ -6702,6 +6846,8 @@ static int tree_move_down(struct btrfs_path *path, int *level, u64 reada_min_gen
 	u64 reada_max;
 	u64 reada_done = 0;
 
+	lockdep_assert_held_read(&parent->fs_info->commit_root_sem);
+
 	BUG_ON(*level == 0);
 	eb = btrfs_read_node_slot(parent, slot);
 	if (IS_ERR(eb))
@@ -6725,6 +6871,10 @@ static int tree_move_down(struct btrfs_path *path, int *level, u64 reada_min_gen
 	path->nodes[*level - 1] = eb;
 	path->slots[*level - 1] = 0;
 	(*level)--;
+
+	if (*level == 0)
+		return replace_node_with_clone(path, 0);
+
 	return 0;
 }
 
@@ -6738,8 +6888,10 @@ static int tree_move_next_or_upnext(struct btrfs_path *path,
 	path->slots[*level]++;
 
 	while (path->slots[*level] >= nritems) {
-		if (*level == root_level)
+		if (*level == root_level) {
+			path->slots[*level] = nritems - 1;
 			return -1;
+		}
 
 		/* move upnext */
 		path->slots[*level] = 0;
@@ -6771,14 +6923,20 @@ static int tree_advance(struct btrfs_path *path,
 	} else {
 		ret = tree_move_down(path, level, reada_min_gen);
 	}
-	if (ret >= 0) {
-		if (*level == 0)
-			btrfs_item_key_to_cpu(path->nodes[*level], key,
-					path->slots[*level]);
-		else
-			btrfs_node_key_to_cpu(path->nodes[*level], key,
-					path->slots[*level]);
-	}
+
+	/*
+	 * Even if we have reached the end of a tree, ret is -1, update the key
+	 * anyway, so that in case we need to restart due to a block group
+	 * relocation, we can assert that the last key of the root node still
+	 * exists in the tree.
+	 */
+	if (*level == 0)
+		btrfs_item_key_to_cpu(path->nodes[*level], key,
+				      path->slots[*level]);
+	else
+		btrfs_node_key_to_cpu(path->nodes[*level], key,
+				      path->slots[*level]);
+
 	return ret;
 }
 
@@ -6807,6 +6965,97 @@ static int tree_compare_item(struct btrfs_path *left_path,
 	return 0;
 }
 
+/*
+ * A transaction used for relocating a block group was committed or is about to
+ * finish its commit. Release our paths and restart the search, so that we are
+ * not using stale extent buffers:
+ *
+ * 1) For levels > 0, we are only holding references of extent buffers, without
+ *    any locks on them, which does not prevent them from having been relocated
+ *    and reallocated after the last time we released the commit root semaphore.
+ *    The exception are the root nodes, for which we always have a clone, see
+ *    the comment at btrfs_compare_trees();
+ *
+ * 2) For leaves, level 0, we are holding copies (clones) of extent buffers, so
+ *    we are safe from the concurrent relocation and reallocation. However they
+ *    can have file extent items with a pre relocation disk_bytenr value, so we
+ *    restart the start from the current commit roots and clone the new leaves so
+ *    that we get the post relocation disk_bytenr values. Not doing so, could
+ *    make us clone the wrong data in case there are new extents using the old
+ *    disk_bytenr that happen to be shared.
+ */
+static int restart_after_relocation(struct btrfs_path *left_path,
+				    struct btrfs_path *right_path,
+				    const struct btrfs_key *left_key,
+				    const struct btrfs_key *right_key,
+				    int left_level,
+				    int right_level,
+				    const struct send_ctx *sctx)
+{
+	int root_level;
+	int ret;
+
+	lockdep_assert_held_read(&sctx->send_root->fs_info->commit_root_sem);
+
+	btrfs_release_path(left_path);
+	btrfs_release_path(right_path);
+
+	/*
+	 * Since keys can not be added or removed to/from our roots because they
+	 * are readonly and we do not allow deduplication to run in parallel
+	 * (which can add, remove or change keys), the layout of the trees should
+	 * not change.
+	 */
+	left_path->lowest_level = left_level;
+	ret = search_key_again(sctx, sctx->send_root, left_path, left_key);
+	if (ret < 0)
+		return ret;
+
+	right_path->lowest_level = right_level;
+	ret = search_key_again(sctx, sctx->parent_root, right_path, right_key);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * If the lowest level nodes are leaves, clone them so that they can be
+	 * safely used by changed_cb() while not under the protection of the
+	 * commit root semaphore, even if relocation and reallocation happens in
+	 * parallel.
+	 */
+	if (left_level == 0) {
+		ret = replace_node_with_clone(left_path, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (right_level == 0) {
+		ret = replace_node_with_clone(right_path, 0);
+		if (ret < 0)
+			return ret;
+	}
+
+	/*
+	 * Now clone the root nodes (unless they happen to be the leaves we have
+	 * already cloned). This is to protect against concurrent snapshotting of
+	 * the send and parent roots (see the comment at btrfs_compare_trees()).
+	 */
+	root_level = btrfs_header_level(sctx->send_root->commit_root);
+	if (root_level > 0) {
+		ret = replace_node_with_clone(left_path, root_level);
+		if (ret < 0)
+			return ret;
+	}
+
+	root_level = btrfs_header_level(sctx->parent_root->commit_root);
+	if (root_level > 0) {
+		ret = replace_node_with_clone(right_path, root_level);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
 /*
  * This function compares two trees and calls the provided callback for
  * every changed/new/deleted item it finds.
@@ -6835,10 +7084,10 @@ static int btrfs_compare_trees(struct btrfs_root *left_root,
 	int right_root_level;
 	int left_level;
 	int right_level;
-	int left_end_reached;
-	int right_end_reached;
-	int advance_left;
-	int advance_right;
+	int left_end_reached = 0;
+	int right_end_reached = 0;
+	int advance_left = 0;
+	int advance_right = 0;
 	u64 left_blockptr;
 	u64 right_blockptr;
 	u64 left_gen;
@@ -6906,12 +7155,18 @@ static int btrfs_compare_trees(struct btrfs_root *left_root,
 	down_read(&fs_info->commit_root_sem);
 	left_level = btrfs_header_level(left_root->commit_root);
 	left_root_level = left_level;
+	/*
+	 * We clone the root node of the send and parent roots to prevent races
+	 * with snapshot creation of these roots. Snapshot creation COWs the
+	 * root node of a tree, so after the transaction is committed the old
+	 * extent can be reallocated while this send operation is still ongoing.
+	 * So we clone them, under the commit root semaphore, to be race free.
+	 */
 	left_path->nodes[left_level] =
 			btrfs_clone_extent_buffer(left_root->commit_root);
 	if (!left_path->nodes[left_level]) {
-		up_read(&fs_info->commit_root_sem);
 		ret = -ENOMEM;
-		goto out;
+		goto out_unlock;
 	}
 
 	right_level = btrfs_header_level(right_root->commit_root);
@@ -6919,9 +7174,8 @@ static int btrfs_compare_trees(struct btrfs_root *left_root,
 	right_path->nodes[right_level] =
 			btrfs_clone_extent_buffer(right_root->commit_root);
 	if (!right_path->nodes[right_level]) {
-		up_read(&fs_info->commit_root_sem);
 		ret = -ENOMEM;
-		goto out;
+		goto out_unlock;
 	}
 	/*
 	 * Our right root is the parent root, while the left root is the "send"
@@ -6931,7 +7185,6 @@ static int btrfs_compare_trees(struct btrfs_root *left_root,
 	 * will need to read them at some point.
 	 */
 	reada_min_gen = btrfs_header_generation(right_root->commit_root);
-	up_read(&fs_info->commit_root_sem);
 
 	if (left_level == 0)
 		btrfs_item_key_to_cpu(left_path->nodes[left_level],
@@ -6946,11 +7199,26 @@ static int btrfs_compare_trees(struct btrfs_root *left_root,
 		btrfs_node_key_to_cpu(right_path->nodes[right_level],
 				&right_key, right_path->slots[right_level]);
 
-	left_end_reached = right_end_reached = 0;
-	advance_left = advance_right = 0;
+	sctx->last_reloc_trans = fs_info->last_reloc_trans;
 
 	while (1) {
-		cond_resched();
+		if (need_resched() ||
+		    rwsem_is_contended(&fs_info->commit_root_sem)) {
+			up_read(&fs_info->commit_root_sem);
+			cond_resched();
+			down_read(&fs_info->commit_root_sem);
+		}
+
+		if (fs_info->last_reloc_trans > sctx->last_reloc_trans) {
+			ret = restart_after_relocation(left_path, right_path,
+						       &left_key, &right_key,
+						       left_level, right_level,
+						       sctx);
+			if (ret < 0)
+				goto out_unlock;
+			sctx->last_reloc_trans = fs_info->last_reloc_trans;
+		}
+
 		if (advance_left && !left_end_reached) {
 			ret = tree_advance(left_path, &left_level,
 					left_root_level,
@@ -6959,7 +7227,7 @@ static int btrfs_compare_trees(struct btrfs_root *left_root,
 			if (ret == -1)
 				left_end_reached = ADVANCE;
 			else if (ret < 0)
-				goto out;
+				goto out_unlock;
 			advance_left = 0;
 		}
 		if (advance_right && !right_end_reached) {
@@ -6970,54 +7238,55 @@ static int btrfs_compare_trees(struct btrfs_root *left_root,
 			if (ret == -1)
 				right_end_reached = ADVANCE;
 			else if (ret < 0)
-				goto out;
+				goto out_unlock;
 			advance_right = 0;
 		}
 
 		if (left_end_reached && right_end_reached) {
 			ret = 0;
-			goto out;
+			goto out_unlock;
 		} else if (left_end_reached) {
 			if (right_level == 0) {
+				up_read(&fs_info->commit_root_sem);
 				ret = changed_cb(left_path, right_path,
 						&right_key,
 						BTRFS_COMPARE_TREE_DELETED,
 						sctx);
 				if (ret < 0)
 					goto out;
+				down_read(&fs_info->commit_root_sem);
 			}
 			advance_right = ADVANCE;
 			continue;
 		} else if (right_end_reached) {
 			if (left_level == 0) {
+				up_read(&fs_info->commit_root_sem);
 				ret = changed_cb(left_path, right_path,
 						&left_key,
 						BTRFS_COMPARE_TREE_NEW,
 						sctx);
 				if (ret < 0)
 					goto out;
+				down_read(&fs_info->commit_root_sem);
 			}
 			advance_left = ADVANCE;
 			continue;
 		}
 
 		if (left_level == 0 && right_level == 0) {
+			up_read(&fs_info->commit_root_sem);
 			cmp = btrfs_comp_cpu_keys(&left_key, &right_key);
 			if (cmp < 0) {
 				ret = changed_cb(left_path, right_path,
 						&left_key,
 						BTRFS_COMPARE_TREE_NEW,
 						sctx);
-				if (ret < 0)
-					goto out;
 				advance_left = ADVANCE;
 			} else if (cmp > 0) {
 				ret = changed_cb(left_path, right_path,
 						&right_key,
 						BTRFS_COMPARE_TREE_DELETED,
 						sctx);
-				if (ret < 0)
-					goto out;
 				advance_right = ADVANCE;
 			} else {
 				enum btrfs_compare_tree_result result;
@@ -7031,11 +7300,13 @@ static int btrfs_compare_trees(struct btrfs_root *left_root,
 					result = BTRFS_COMPARE_TREE_SAME;
 				ret = changed_cb(left_path, right_path,
 						 &left_key, result, sctx);
-				if (ret < 0)
-					goto out;
 				advance_left = ADVANCE;
 				advance_right = ADVANCE;
 			}
+
+			if (ret < 0)
+				goto out;
+			down_read(&fs_info->commit_root_sem);
 		} else if (left_level == right_level) {
 			cmp = btrfs_comp_cpu_keys(&left_key, &right_key);
 			if (cmp < 0) {
@@ -7075,6 +7346,8 @@ static int btrfs_compare_trees(struct btrfs_root *left_root,
 		}
 	}
 
+out_unlock:
+	up_read(&fs_info->commit_root_sem);
 out:
 	btrfs_free_path(left_path);
 	btrfs_free_path(right_path);
@@ -7413,21 +7686,7 @@ long btrfs_ioctl_send(struct file *mnt_file, struct btrfs_ioctl_send_args *arg)
 	if (ret)
 		goto out;
 
-	spin_lock(&fs_info->send_reloc_lock);
-	if (test_bit(BTRFS_FS_RELOC_RUNNING, &fs_info->flags)) {
-		spin_unlock(&fs_info->send_reloc_lock);
-		btrfs_warn_rl(fs_info,
-		"cannot run send because a relocation operation is in progress");
-		ret = -EAGAIN;
-		goto out;
-	}
-	fs_info->send_in_progress++;
-	spin_unlock(&fs_info->send_reloc_lock);
-
 	ret = send_subvol(sctx);
-	spin_lock(&fs_info->send_reloc_lock);
-	fs_info->send_in_progress--;
-	spin_unlock(&fs_info->send_reloc_lock);
 	if (ret < 0)
 		goto out;
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 9a6009108ea5..642cd2b55fa0 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -163,6 +163,10 @@ static noinline void switch_commit_roots(struct btrfs_trans_handle *trans)
 	struct btrfs_caching_control *caching_ctl, *next;
 
 	down_write(&fs_info->commit_root_sem);
+
+	if (test_bit(BTRFS_FS_RELOC_RUNNING, &fs_info->flags))
+		fs_info->last_reloc_trans = trans->transid;
+
 	list_for_each_entry_safe(root, tmp, &cur_trans->switch_commits,
 				 dirty_list) {
 		list_del_init(&root->dirty_list);
-- 
2.33.1

