Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08C223F0746
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 16:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238721AbhHRO7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 10:59:40 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:37610 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238483AbhHRO7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 10:59:39 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17IEvw7A026948;
        Wed, 18 Aug 2021 14:58:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2021-07-09;
 bh=1lkpkF6yY9rRwzmpvwEUN1VkZu8CbMHBRG1VVuuB2s8=;
 b=kMbFJ5g544DvpYyw9eC32t1MkRRdlqd3yBu+ajM0alEi7FB28ak/iHY7nbBBxxcYdD+b
 unYqu2ZXhwwyyzYMcq37Gbb5nWpnq0U2YPahi7WhUuWcYzyeC/Ds+Df3DHc8dl6AUquS
 A+uQzA6PGGAWNNwN5a0Rv0w3HtIjPz/cYn1uuikSLvHVdz5Eu+L3TVJtLpx72JAeUGMC
 vWAkYyW1mAXRJNPIgA6DhzTy5olNkWKfVKiSIV3c1xxwNnYfzXGOFNPrT11PiSK2QDLl
 jj3IjOWDLXvOLYkpUWMKkfnaaUvqmWdJuOzX1MZ/6HwJueEgmRhDCWjPvVjppU1cOyG2 pQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=1lkpkF6yY9rRwzmpvwEUN1VkZu8CbMHBRG1VVuuB2s8=;
 b=SpDXST5bgW+v1V04y/exZArxP9B0SlZAhMw4iRZR2l+/HYMsMeVeMX9CV3dfU4w77MxW
 ib0skaJmy+eeDnLUQe5yJuZUCAiyfhWztDEcHiNN0gW7LZ1LPCEnLfJj266XhT8UmMV/
 C0fTBX/vad6G13u1d9h2J6AWDH1LyUBMpbBynALjr1OEOmg+RyxB3OF7OjhOKCLbVoan
 TAq8glnvDFP5Owfw8ytli5g/NUOMLQQInsHDAa/k6y8Kjo1VMonmudS4oBwn+/nt5Cs/
 H/jhZ6JHfyIfdwMiJFMfrIxpWFwVga5lh78jgjth/BJFNn5IpqGVgoOKZUTAEVmkWnvG 3w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3age7day3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 14:58:54 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17IEp5c8116198;
        Wed, 18 Aug 2021 14:58:52 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by userp3020.oracle.com with ESMTP id 3aeqkwdtqs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 14:58:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fe51+0oY44jMLE2K1A1L64AnCAJxlDvPxV8ZuVyMK4qXpa4/xn8ZVo6DWuvHtakwf/RMQYUg3brnJ3265T5trFSTJKcOaWfhSAcjPEJeAHAEVvG4OFWoUNHhul5qcnGMADKErlgxcQxMPpjGeLKL7koU2OSlsa3VqKXKom/gwZ6VQW8M//Uc4A6hM+yyg/895J3kuhzVko4Q95dPda5sJeO7hI+K28ayOZexhh3mUFPZDh5LyJ3taTM6YBqb8V5s7gtH/aHUNGCJszCx1nmEzQrPZmBE3z9kBDJrtHy64YHjqCoi2OUc27W2mxW9+0sjBuCxk/R3v3bm4ZP2MzCcgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1lkpkF6yY9rRwzmpvwEUN1VkZu8CbMHBRG1VVuuB2s8=;
 b=hpg3Ky9b4nVGbEEhAxAWAHv0tK8a1dy8IKLsyoPBgGNh2eaBbeMR9BkEBFJnI6JMKkGKOXcFVtLM1YAC/sqfpxKq2r7MPtbaGqaoOr0iP/lwsfFlmrZkbwsnU7BG1I+yNSwplvQ2l/YVToNuiT2i6kBYUv/wJD08oyRwy02Bgt8StOZ1iTF0m1TBS2Xo5869CxnbF4VwlxtSyhUsGXYfoPGZdRQFwbqdbH5ZnE5FS3KxucRbAhc8+y8nYgepyevbczni5yfrfs4ATBvH7hXlb/HzAbH5LTN/srx4DpVxgbtTigHRNDm5kXqiUM6XQ1tDHKg1pc5IBOa6lG2txLet9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1lkpkF6yY9rRwzmpvwEUN1VkZu8CbMHBRG1VVuuB2s8=;
 b=UVP91GDWvD18x2HwjcgCxHzYIRxj+bUSWNguwC5BuAuKoUmqTp0J3ALNK0VlW00ytBEhsueOWK+oFC/387Z0lSGnEjfjaUHhxOKzpNTVP0fbUerJwMfaUYBNsegLev4phFHAoWKkrRjacZW4J/6AzL2uNPzZx45+1aEDKr4RO2E=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
 by BN0PR10MB5382.namprd10.prod.outlook.com (2603:10b6:408:117::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Wed, 18 Aug
 2021 14:58:50 +0000
Received: from BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4551:a5b4:f2ec:daf]) by BN0PR10MB5192.namprd10.prod.outlook.com
 ([fe80::4551:a5b4:f2ec:daf%7]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 14:58:50 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     gregkh@linuxfoundation.org, laoar.shao@gmail.com
Cc:     george.kennedy@oracle.com, akpm@linux-foundation.org,
        surenb@google.com, stable@vger.kernel.org, christian@brauner.io,
        keescook@chromium.org, dhaval.giani@oracle.com
Subject: [PATCH 5.4.y 1/1] mm, oom: make the calculation of oom badness more accurate
Date:   Wed, 18 Aug 2021 09:59:07 -0500
Message-Id: <1629298747-19233-2-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.9.4
In-Reply-To: <1629298747-19233-1-git-send-email-george.kennedy@oracle.com>
References: <1629298747-19233-1-git-send-email-george.kennedy@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SN2PR01CA0020.prod.exchangelabs.com (2603:10b6:804:2::30)
 To BN0PR10MB5192.namprd10.prod.outlook.com (2603:10b6:408:115::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-152-13-169.usdhcp.oraclecorp.com.com (209.17.40.42) by SN2PR01CA0020.prod.exchangelabs.com (2603:10b6:804:2::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 14:58:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31ffd8cb-2e34-4ec2-e7b2-08d96258b025
X-MS-TrafficTypeDiagnostic: BN0PR10MB5382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN0PR10MB5382AEE32E562B3E38459150E6FF9@BN0PR10MB5382.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ItgHQgtjx91jaD14bm1yA1U9ntHJ8FtYkd9wkbY+iBPgylKmXbnDv84xhoz8dBfgojrxPwsOX2LH+iH8e/xBMcDsU5Kji1e7LKsx90E318wus6GnFQi8gBGi5F8Lq66+Zr/gx1b1wEYAA2G4JmbzF7FWkd8GzAYL6fR98/YQlIHp/z4dYAGhgy63V8vE7OokS40TaoLmgpXdgHDYbBaXJHdSxbYmOuFW8QnScOEGsVQHnZIl8jPPf6uNSjXqHRdbJqYoqTi6vGOtmN1ldJ3XacaBRxALElWCMHGQMS7dQBCFl0sjdyg/tLBF6YoGMc5DjoANZ9mLwDva9POjhsgplmBy2qNFaY6QFh37LG/VxZ+jblRsbruJdoy3RT1qvhE7Ta0i01wIImJLpPOxcChOcyQB425fC7lRlPnLqHbYtq0CgTN78h565eBcygmSl6wsskfgLv5Z861dgwMaDfz0kjO0rv7cqE4/ZsOxe+uFQ7gy5JBcQX6JqIQQlIVeA5D4E4JNxS7/X77Ie4iaIfLwXcR7Je31nRTsjkPd32ZP5jjoAyT6IFAUmyT89iIDTUQ6l1BmbuYc9lrGtitGkVa+rjGs2z2KBDbkLkpPkqcCKqvLpCM7taewrRWjueFc+CWK1Q3kPjWNTHmmtFEtwosNqJSw+xs0tj4g0zBQmnu/EnABHRDMYBZQ2mEb68FZjrVL9z3jsyG23lNgxTgnP/zgFw9FAy7fwtSMihISX9ctanhMz6iTk2EOGSw5Wnm/cHrezBYFdVl6LfwGSxPEVlVPvXQljYK/QEMfV3ZN/WqyrVSj+gY95E6ZW8WT3kSMfokScuWNAHRZegVQy5ugLnzN7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5192.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(396003)(136003)(366004)(83380400001)(38100700002)(38350700002)(36756003)(107886003)(8676002)(8936002)(2616005)(86362001)(956004)(44832011)(2906002)(966005)(478600001)(4326008)(6486002)(186003)(6666004)(6512007)(66946007)(5660300002)(66556008)(52116002)(66476007)(26005)(316002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ngpH5GDtHIXAijUe3SbcPNSTUtQMe0EHKug48bCWaYhXMrZ0hDOsujkkiblG?=
 =?us-ascii?Q?Drt/8i+ZoiMb1QTddML0e+CUDK8CDqwfgLey2uUTudrSYdBarDohRYtMAYlP?=
 =?us-ascii?Q?4CvBHBbmjbQuQbEzaUZqUurQd4G95fk7ajtAioef58/SHiuy58UDn0bmmaeS?=
 =?us-ascii?Q?lPMKeBlJaNPOoBMbgCVgOvGTKEcs0+Lb+Qb4W7iYmbaSKv8nxwhC1kwN3uXG?=
 =?us-ascii?Q?Hm3cAhLr+dnMgrn60HKminymisMgo4d7wCDLYv56Fgr2GIxi2JASP8MZB8DQ?=
 =?us-ascii?Q?5M5Bmy8Z7DyXszfk/3ChoXJegiEO4R0+EJ5g2tSYCDhAnKTIFF6ah4UoF2UY?=
 =?us-ascii?Q?SufAOEfSH4YugBhG4+PO3olHqR24WOmazTobKkKcLhjYlLN60Yo74P0uJQNO?=
 =?us-ascii?Q?sPWPYFt4A/g3Az7FrMOnibQGuVR3oIAkkCf2t3L2dTGcpO5NhnZD8Er6naQz?=
 =?us-ascii?Q?qBnfiyc5k7ZTVqvHpJh5PgtOH72nwgBdpRcp5Kp8j/JV3Pc7e8hlxbwABAUG?=
 =?us-ascii?Q?7e2tGo3mYKzWfMgFfnfWZxRexsb6LUj4TV3rmI429qfzwXFtZctOR6FcwL5Y?=
 =?us-ascii?Q?+HN3pCZ6SzAYoiHgtxiCy+s8vO7FZF6tyDhSZHXGL1MR2MjH3WnuKSkzCUyQ?=
 =?us-ascii?Q?OI8FtAiegyseGpJZgGikRJ5cMpKtoUj/ghPca1WuSQAqNtDOm+nklcYng8wE?=
 =?us-ascii?Q?5gqCsXzxbGj3YrWq7MrbpTI00go8EvWYyYtb5sKIgXBE73gOrIJnN6Mm7wBm?=
 =?us-ascii?Q?a517iMRZ5Iz7W7R+MmSCLPGZ5GYKmvXvijAUUWRoBmkWEbbOreY4DmIaPu6R?=
 =?us-ascii?Q?U0wbLF/G5sn1f80crI1Dm8vUxT27NWsAmAwKTRdTNAtDI0KaSnI7HlY+KbFX?=
 =?us-ascii?Q?0vpbeXwiDFk8qreguuAHZDI+dx078hM/7aFr4dALQsCx2h3VbcK+i5n9UW3m?=
 =?us-ascii?Q?T5HT6vVEnW5h13ZxRkM9SzMYrekiND6uT+CgClQBcIKUSm8qNkJ91myC0fP8?=
 =?us-ascii?Q?LEg466LaL0+PWF1QISR+7KGViZVHgnwDUbtQ5KTworW5j4FzYxAk2/6NkHZd?=
 =?us-ascii?Q?JqnsrLffPYGDGJ3nWOS3TA3bQ/Tqz5am7OKVwGC5t5YoTdCBGYT/JfG6/Dte?=
 =?us-ascii?Q?sDIC5rt2IjwEusp6aiz3GHhe4FDN5VVX569YVMjZWy+wXtCr3GhA09b9hacn?=
 =?us-ascii?Q?LK2mZ0/WSbAqtWCl3TLmYwM85ds3gqKFsYUHKicSibn5+xY8pvs/M2kusIJd?=
 =?us-ascii?Q?2hDUqdx+fVKVY/5o7o/kROEFeOB6mayCVaKn+cfdPLtZBoNSW8sjLOCHr3+w?=
 =?us-ascii?Q?uml+60ycMoaysyYg9JRgkORc?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31ffd8cb-2e34-4ec2-e7b2-08d96258b025
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5192.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 14:58:50.2201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0J7gcA+dM2uT7/nmfcpwvAoaC0P5GJOdtV7qRnL+RBuX5Jppd3sXf3PEkYZ7v/4SKHtl4iavlJftv7R80uj8rOWLRvyDTns30byb/xxJJxM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5382
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10080 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108180093
X-Proofpoint-GUID: ssr1-7GNRQYmXUq_3SOgiDR7ga8GAHNg
X-Proofpoint-ORIG-GUID: ssr1-7GNRQYmXUq_3SOgiDR7ga8GAHNg
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>

Recently we found an issue on our production environment that when memcg
oom is triggered the oom killer doesn't chose the process with largest
resident memory but chose the first scanned process.  Note that all
processes in this memcg have the same oom_score_adj, so the oom killer
should chose the process with largest resident memory.

Bellow is part of the oom info, which is enough to analyze this issue.
[7516987.983223] memory: usage 16777216kB, limit 16777216kB, failcnt 52843037
[7516987.983224] memory+swap: usage 16777216kB, limit 9007199254740988kB, failcnt 0
[7516987.983225] kmem: usage 301464kB, limit 9007199254740988kB, failcnt 0
[...]
[7516987.983293] [ pid ]   uid  tgid total_vm      rss pgtables_bytes swapents oom_score_adj name
[7516987.983510] [ 5740]     0  5740      257        1    32768        0          -998 pause
[7516987.983574] [58804]     0 58804     4594      771    81920        0          -998 entry_point.bas
[7516987.983577] [58908]     0 58908     7089      689    98304        0          -998 cron
[7516987.983580] [58910]     0 58910    16235     5576   163840        0          -998 supervisord
[7516987.983590] [59620]     0 59620    18074     1395   188416        0          -998 sshd
[7516987.983594] [59622]     0 59622    18680     6679   188416        0          -998 python
[7516987.983598] [59624]     0 59624  1859266     5161   548864        0          -998 odin-agent
[7516987.983600] [59625]     0 59625   707223     9248   983040        0          -998 filebeat
[7516987.983604] [59627]     0 59627   416433    64239   774144        0          -998 odin-log-agent
[7516987.983607] [59631]     0 59631   180671    15012   385024        0          -998 python3
[7516987.983612] [61396]     0 61396   791287     3189   352256        0          -998 client
[7516987.983615] [61641]     0 61641  1844642    29089   946176        0          -998 client
[7516987.983765] [ 9236]     0  9236     2642      467    53248        0          -998 php_scanner
[7516987.983911] [42898]     0 42898    15543      838   167936        0          -998 su
[7516987.983915] [42900]  1000 42900     3673      867    77824        0          -998 exec_script_vr2
[7516987.983918] [42925]  1000 42925    36475    19033   335872        0          -998 python
[7516987.983921] [57146]  1000 57146     3673      848    73728        0          -998 exec_script_J2p
[7516987.983925] [57195]  1000 57195   186359    22958   491520        0          -998 python2
[7516987.983928] [58376]  1000 58376   275764    14402   290816        0          -998 rosmaster
[7516987.983931] [58395]  1000 58395   155166     4449   245760        0          -998 rosout
[7516987.983935] [58406]  1000 58406 18285584  3967322 37101568        0          -998 data_sim
[7516987.984221] oom-kill:constraint=CONSTRAINT_MEMCG,nodemask=(null),cpuset=3aa16c9482ae3a6f6b78bda68a55d32c87c99b985e0f11331cddf05af6c4d753,mems_allowed=0-1,oom_memcg=/kubepods/podf1c273d3-9b36-11ea-b3df-246e9693c184,task_memcg=/kubepods/podf1c273d3-9b36-11ea-b3df-246e9693c184/1f246a3eeea8f70bf91141eeaf1805346a666e225f823906485ea0b6c37dfc3d,task=pause,pid=5740,uid=0
[7516987.984254] Memory cgroup out of memory: Killed process 5740 (pause) total-vm:1028kB, anon-rss:4kB, file-rss:0kB, shmem-rss:0kB
[7516988.092344] oom_reaper: reaped process 5740 (pause), now anon-rss:0kB, file-rss:0kB, shmem-rss:0kB

We can find that the first scanned process 5740 (pause) was killed, but
its rss is only one page.  That is because, when we calculate the oom
badness in oom_badness(), we always ignore the negtive point and convert
all of these negtive points to 1.  Now as oom_score_adj of all the
processes in this targeted memcg have the same value -998, the points of
these processes are all negtive value.  As a result, the first scanned
process will be killed.

The oom_socre_adj (-998) in this memcg is set by kubelet, because it is a
a Guaranteed pod, which has higher priority to prevent from being killed
by system oom.

To fix this issue, we should make the calculation of oom point more
accurate.  We can achieve it by convert the chosen_point from 'unsigned
long' to 'long'.

[cai@lca.pw: reported a issue in the previous version]
[mhocko@suse.com: fixed the issue reported by Cai]
[mhocko@suse.com: add the comment in proc_oom_score()]
[laoar.shao@gmail.com: v3]
  Link: http://lkml.kernel.org/r/1594396651-9931-1-git-send-email-laoar.shao@gmail.com

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Qian Cai <cai@lca.pw>
Link: http://lkml.kernel.org/r/1594309987-9919-1-git-send-email-laoar.shao@gmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(cherry picked from commit 9066e5cfb73cdbcdbb49e87999482ab615e9fc76)
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
---
 fs/proc/base.c      | 11 ++++++++++-
 include/linux/oom.h |  4 ++--
 mm/oom_kill.c       | 22 ++++++++++------------
 3 files changed, 22 insertions(+), 15 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 90d2f62..5a187e9 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -549,8 +549,17 @@ static int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
 {
 	unsigned long totalpages = totalram_pages() + total_swap_pages;
 	unsigned long points = 0;
+	long badness;
+
+	badness = oom_badness(task, totalpages);
+	/*
+	 * Special case OOM_SCORE_ADJ_MIN for all others scale the
+	 * badness value into [0, 2000] range which we have been
+	 * exporting for a long time so userspace might depend on it.
+	 */
+	if (badness != LONG_MIN)
+		points = (1000 + badness * 1000 / (long)totalpages) * 2 / 3;
 
-	points = oom_badness(task, totalpages) * 1000 / totalpages;
 	seq_printf(m, "%lu\n", points);
 
 	return 0;
diff --git a/include/linux/oom.h b/include/linux/oom.h
index b9df343..2db9a14 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -48,7 +48,7 @@ struct oom_control {
 	/* Used by oom implementation, do not set */
 	unsigned long totalpages;
 	struct task_struct *chosen;
-	unsigned long chosen_points;
+	long chosen_points;
 
 	/* Used to print the constraint info. */
 	enum oom_constraint constraint;
@@ -108,7 +108,7 @@ static inline vm_fault_t check_stable_address_space(struct mm_struct *mm)
 
 bool __oom_reap_task_mm(struct mm_struct *mm);
 
-extern unsigned long oom_badness(struct task_struct *p,
+long oom_badness(struct task_struct *p,
 		unsigned long totalpages);
 
 extern bool out_of_memory(struct oom_control *oc);
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 212e718..f1b810d 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -197,17 +197,17 @@ static bool is_dump_unreclaim_slabs(void)
  * predictable as possible.  The goal is to return the highest value for the
  * task consuming the most memory to avoid subsequent oom failures.
  */
-unsigned long oom_badness(struct task_struct *p, unsigned long totalpages)
+long oom_badness(struct task_struct *p, unsigned long totalpages)
 {
 	long points;
 	long adj;
 
 	if (oom_unkillable_task(p))
-		return 0;
+		return LONG_MIN;
 
 	p = find_lock_task_mm(p);
 	if (!p)
-		return 0;
+		return LONG_MIN;
 
 	/*
 	 * Do not even consider tasks which are explicitly marked oom
@@ -219,7 +219,7 @@ unsigned long oom_badness(struct task_struct *p, unsigned long totalpages)
 			test_bit(MMF_OOM_SKIP, &p->mm->flags) ||
 			in_vfork(p)) {
 		task_unlock(p);
-		return 0;
+		return LONG_MIN;
 	}
 
 	/*
@@ -234,11 +234,7 @@ unsigned long oom_badness(struct task_struct *p, unsigned long totalpages)
 	adj *= totalpages / 1000;
 	points += adj;
 
-	/*
-	 * Never return 0 for an eligible task regardless of the root bonus and
-	 * oom_score_adj (oom_score_adj can't be OOM_SCORE_ADJ_MIN here).
-	 */
-	return points > 0 ? points : 1;
+	return points;
 }
 
 static const char * const oom_constraint_text[] = {
@@ -311,7 +307,7 @@ static enum oom_constraint constrained_alloc(struct oom_control *oc)
 static int oom_evaluate_task(struct task_struct *task, void *arg)
 {
 	struct oom_control *oc = arg;
-	unsigned long points;
+	long points;
 
 	if (oom_unkillable_task(task))
 		goto next;
@@ -337,12 +333,12 @@ static int oom_evaluate_task(struct task_struct *task, void *arg)
 	 * killed first if it triggers an oom, then select it.
 	 */
 	if (oom_task_origin(task)) {
-		points = ULONG_MAX;
+		points = LONG_MAX;
 		goto select;
 	}
 
 	points = oom_badness(task, oc->totalpages);
-	if (!points || points < oc->chosen_points)
+	if (points == LONG_MIN || points < oc->chosen_points)
 		goto next;
 
 select:
@@ -366,6 +362,8 @@ static int oom_evaluate_task(struct task_struct *task, void *arg)
  */
 static void select_bad_process(struct oom_control *oc)
 {
+	oc->chosen_points = LONG_MIN;
+
 	if (is_memcg_oom(oc))
 		mem_cgroup_scan_tasks(oc->memcg, oom_evaluate_task, oc);
 	else {
-- 
1.8.3.1

