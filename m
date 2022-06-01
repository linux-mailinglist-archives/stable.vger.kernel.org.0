Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32EF153AF4C
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 00:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbiFAWA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 18:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbiFAWAE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 18:00:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95789AE6B;
        Wed,  1 Jun 2022 15:00:02 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251KCgMr024213;
        Wed, 1 Jun 2022 21:59:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : content-type :
 mime-version; s=corp-2021-07-09;
 bh=IoAe1lf4dENRWX+DMSHRFsbMT8f6nPQ6XzMSWFlo1SY=;
 b=f7871M1DOrZiZAbR5qmgeDcNIQLna5Z2HDbypvohJkUJiiZGDwvGFm+z1fMhq8qzCAFJ
 5GhfOQBDM57OTFIfj8SUsQelbRlV8i/LQtsM1RqVilnWqqxJjfr4UTFDaIvwgeneLvp6
 yyK4V6RChimvD7zCtteJOllkRZT11/FYRsF8gI1uJdb11G8b2qlfp2Sojuab/eGqH3Z7
 6X0DNmUleCXKzKHV0emmtmftF9gocaSiixjgSvmj87Z707todDg2zgUkC6Y3oxAObbVA
 AhUx3Rln5kcajWzEsGQBULbn2BGdqEvbprtPWXfeL8EU2s+Vjl7jHgmFUbWlZX5t79rl MQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbc6x8yb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jun 2022 21:59:56 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 251Lu92h029622;
        Wed, 1 Jun 2022 21:59:55 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2046.outbound.protection.outlook.com [104.47.51.46])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gc8p49mj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Jun 2022 21:59:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGXM5KzD+OLOJin/C+p0RPdky7s90gc2s4M8PQFYKWRKdx7z6+fr6M6xnVGSPo6moMyBOG5ffdO2A/bJS1fY1dfxSBzIjf0Xx1y4v0jc2VVwI19zGWaPpUHEy1PhCSiYfjNBI4GRc33Dz/O2ev6SgkSDITNOud44LRpZydOMSXRg9Xq5BLBsFxdA6U10BuXdDz9aBjmdW7wslkdkKRFKf//EdWKLzahkIIRbc5AIecCkQAKPznZwJ5Ekhw8+o/iSLQcb2PMO1uT/cUFiH3ls1AO/esOQZSEUirJEbnge4RfYeaZw2TnQ6f3y1kcQgQHWmOQRB3GSbI6/JH6zY8sHfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IoAe1lf4dENRWX+DMSHRFsbMT8f6nPQ6XzMSWFlo1SY=;
 b=E4r3CWqjE5BKWb1x0GyJ3JLnAFDQrrEohm7DQWMs9rpuHvE+WM20nFPaf0V3XlHLblfiKRL216X/6SGEvYqJLHpkDGRYOkJQrNyDel8G4lV97vam4QvOZ/OwazDy3NtU3hpLEUNzffwPbNC+worRG/MZP73ks1BcSiD0OIxFzG/8Fk1FVXmp7w+OdzpflfqeVg5o+7yVdsyhSzXsHzHjHlhtj3PkLvPyrXI8XO/GEW++UNdS2OmDk4fa8j+q3krUkTiTXAb+TSXkQO7gQXoMyEMfQm80g9qbN80PqpMYukJwIBDL6LnEXl/pigz5r0iZwyHh80+c9a7jGgGbPllBIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IoAe1lf4dENRWX+DMSHRFsbMT8f6nPQ6XzMSWFlo1SY=;
 b=yijfYLF3jCfZAyQgcjMXccNhLr343yod/ywMKY80fdA2tWG67YjEyKdI5olTgTgz3TUZpqMZlZvuX6/SYGS/M5rCnfqO2fkIJQUiF8tNy02vssbZc91QnI4ZVeuxCnM0PDAXqhR5IIypkATVbUY5ZEOjnrLqSTO/rskvAHRIlxM=
Received: from MN2PR10MB4173.namprd10.prod.outlook.com (2603:10b6:208:1d1::19)
 by CY5PR10MB6012.namprd10.prod.outlook.com (2603:10b6:930:27::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.18; Wed, 1 Jun
 2022 21:59:50 +0000
Received: from MN2PR10MB4173.namprd10.prod.outlook.com
 ([fe80::1869:f3c4:f33a:916d]) by MN2PR10MB4173.namprd10.prod.outlook.com
 ([fe80::1869:f3c4:f33a:916d%7]) with mapi id 15.20.5314.013; Wed, 1 Jun 2022
 21:59:50 +0000
From:   Stephen Brennan <stephen.s.brennan@oracle.com>
To:     David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org
Cc:     stable@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        keyrings@vger.kernel.org, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] assoc_array: Fix BUG_ON during garbage collect
In-Reply-To: <165295023086.3361286.8662079860706628540.stgit@warthog.procyon.org.uk>
References: <165295023086.3361286.8662079860706628540.stgit@warthog.procyon.org.uk>
Date:   Wed, 01 Jun 2022 14:59:47 -0700
Message-ID: <8735go11v0.fsf@stepbren-lnx.us.oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0039.namprd08.prod.outlook.com
 (2603:10b6:a03:117::16) To MN2PR10MB4173.namprd10.prod.outlook.com
 (2603:10b6:208:1d1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7444b9c1-bb33-4088-81fb-08da441a0cad
X-MS-TrafficTypeDiagnostic: CY5PR10MB6012:EE_
X-Microsoft-Antispam-PRVS: <CY5PR10MB6012CE34285287E8C49CFBEBDBDF9@CY5PR10MB6012.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5R6LmMAwG04aBRDIKL+rIRKqYXzsE87LTfcvaXttQgt8F/VR9WJsJWqoLRDO366dWRodetemsR3tNMKBCUcBYcXIJA4n7i4dJ6Zq+PURIJhceOuNL0jrjqO1eEKAi530eRWgmVDKkedi7Z3x9t1GBaVlcjx0nRm2qQj3Xe14AgMtUx3gAtao0U3jZvlVKf+G3x/V7brWUJaoL42/R6Fx9iQCVnpTPe3JIn3U822gYNkOHtbIOfxLb7VcuCWBF+B927XOAIP05tYBXTa83qS+3k2aplRY8R9Z4p/PzEh2C7mFgiKKuJg8moJ8fi554PKe0G0PE1Od4yh+gJtgvQLr6RMR9WsVaJ8IdkhUTiqzjG2YVSEDPS0HUSuCtczar7lhyHqmXLNikd6SCFSqFGDvQT4eVNVJqiTrCMfuGBE1rg9O46/bK/XhQPIRrS6FFsYu+n9X8Flrrc6trL0xQ8o8c3bVvT2GKqkkfN2pR7Yv8pC5fh47mGUN+W3iqYbFJrqyLyqkQYOCjsqZUr3Do1eTqswp0uJvUy6eJL/Q+YCGtNOyZqAyRzwhhTDAbkUyWNuQnVutuTq6OYVq92bqOe8SF/JPnAvkHrCMaw4BNxVX00FBMsa2d+Tt9GtEDT+DbjzTa6KKPOnS92Mb/s0BT/aWiSwVs95dqNW9KJ91MW9Hy0gXnpekAfYQUavccDdCAW3z3rsB/7njwNOker1wADDz4512Z8Uq1rA6LPJtdwIhC+xiD43Lmlhmf76uznXjhTgV9sq+uPNnpoVWgimPA/vmsa6DnuunGfUawvx3RG6Jb9UhIu8rADc15dpM6HIahZID
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4173.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(52116002)(86362001)(66946007)(66556008)(4326008)(8676002)(66476007)(5660300002)(6506007)(966005)(6486002)(508600001)(186003)(83380400001)(6666004)(8936002)(316002)(38100700002)(2906002)(26005)(6512007)(54906003)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z7tigjCRxFvXy6prxpWWqzHdHlVZMDrKeiP1EOV239PjbEVM/oCsvBrPyOXY?=
 =?us-ascii?Q?yfhY79O2r/jg2knJ0X9sGdapmQ8U9whtuQIMiCPEGjE/iBZ/GCdSabyiBV36?=
 =?us-ascii?Q?WjuFVSbdg+Y2FuXXD54CHCST1tOQKtJfLKT70R9IiS8ZkTPikXaqMU87UYjE?=
 =?us-ascii?Q?w87VNhMUCHyxrkHV6e+EYla9/6lg8eILehQqqVcnBDEUQEblyMgaZxqs0yE4?=
 =?us-ascii?Q?X096DwY6jizQAbfBR3E/Zpc/GqNSXt3FdGG0mCUBAJwAseMhgSmGOcsOXOa+?=
 =?us-ascii?Q?lMMvPngzma/oyMORUJZ7vLzrQNmDPbYqCdA6sJ66Hx+MokpsGP+ELVxU8I9Z?=
 =?us-ascii?Q?GmQRIpGKG2GTsIjEQYAupxQy9m7+RMgnNfS9cwPhhBgdkPGLfk3TS56o9oE2?=
 =?us-ascii?Q?4kF8ZrK2OmEIHkScoPw8ICqQ23i0u+RpaICYGHcdEd1KXThq/u9oJCDSSXqq?=
 =?us-ascii?Q?1f0NKelRTqf3OFcEQgDTqmuF6Ywu8vMEOifiMKIS7SuT6Xiq4XFfEByG38HR?=
 =?us-ascii?Q?2i480bA7DLdZ3zo1hrSNpIq0nq9excGsiLZm3bt6KPdlXjcD/UkFnsAqLuJO?=
 =?us-ascii?Q?g4vOa3iFFxa/TE94NYLt0pHuMVIQrJ8OV2UIIaLPnjbNuQ/DijRzrtHEHQ2C?=
 =?us-ascii?Q?udueLNBFy2RSfp4xIU3Pd625j6wL3ymt15LHvQnLqVe1gOTL15C7RouqSD0w?=
 =?us-ascii?Q?hIxidCzQ/9tWEW07dcV20Q3PejRjOGsEIcrnkQLmafXyLShlHn20VlN0YLZ4?=
 =?us-ascii?Q?U52/8QaSvZFbMeqFQYp1EmNksN5kwIhKYT8VOAqePe7nvL/iXMIus0t9FkR0?=
 =?us-ascii?Q?sR+YZhmcnwlRLWzdRoS+/v2S1ahywtCJtrkJmVFhXAlpjtX+EuMOp0KAssuX?=
 =?us-ascii?Q?j4/hxlN6saCPR+B+/Nvx7pXpRTgnqLz7zxLKBScfzj4YKxtauuHmOwNyDkk0?=
 =?us-ascii?Q?9SGdL5RPp46nq2RzDCFUsr8+m26y4Mckeu7v8+wtFrB6YURQHtJKlC9Z7BPx?=
 =?us-ascii?Q?nUDPEF2hvhcdaeVjP10PSXoe1a/hcAKYRq20Q4PitdFRDpS2hTAzvAgaLIEN?=
 =?us-ascii?Q?dvH8M9vHrUawI0QzL9yfmwSTVPp/2MPkvtm5IClm4jFd0Wvh/c8joYyf4Xfe?=
 =?us-ascii?Q?ejSNsoJ08szSggs4qo9M59o1tHyhme9PXCq+J5Y/6G6gYxoSJQ3YDGh1Pp1E?=
 =?us-ascii?Q?jW8Dcx5qTeiX8SzdxUttVARV+lCQnwpDyLSzweJC9C1HmvBM883dxkHu4D7V?=
 =?us-ascii?Q?AC4tvk5bpm6eOHSwgllnJaaQaj/4/nwwBZn8vkoN9LOgXCwYmvjVxZ2CeeOU?=
 =?us-ascii?Q?3lGkgTiJ7VUfC3YAjyIta9fCEeaNKs7y+a7h7iUw8hHDPZQWl+d9ASl2gyuq?=
 =?us-ascii?Q?8VXHFIBgClWMYki+zZ3Xi9kQLh1V/wHIQ83Ugi2gyhEZGyIm8Ik71NlDEJFB?=
 =?us-ascii?Q?PQtIqaJNFgkzYIa4EstWWJW2HXPrb959QjuktyuzzcdbO6siYRzlja49Z8NA?=
 =?us-ascii?Q?dANYe2O+Nhwp6jv/YRO8rBPDCZy5BtzDKsDIqXCK26c08LmsdMx+tMDnUEwQ?=
 =?us-ascii?Q?6Bf6/0K5zJqEJoDbqbOtQJgm3+A65/UtG7kKqX3js3vGYNGJcW3yJuniPi37?=
 =?us-ascii?Q?DBnvPuHRLfZn4uonUGAZYJ54p4nozodUIspuNaFYY7m3+/8cqLLqQ58eVYOg?=
 =?us-ascii?Q?e62LN6OcItIs3fKX3mYcwPT1sl8vA/Sm7KfPoOmrP0ZyUsOmp7YulQymqUTC?=
 =?us-ascii?Q?UpfDKnvZY9UL5w8pdzx5uCgPFKCijEk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7444b9c1-bb33-4088-81fb-08da441a0cad
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4173.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2022 21:59:50.1694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M/M7NH85RR9jYI6eXoiuUadwgyU3+5ziL3jkXnC7orVswUW68o6Nr5WZX8dYHbdj03H4Te1QtPM0GILjH90zPW9yYtD/hqCiZ695RbMtP/4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6012
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-01_08:2022-06-01,2022-06-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206010087
X-Proofpoint-GUID: 5YlPiVfY1QwXo06vp1PmO9ZUv_GVlZ-h
X-Proofpoint-ORIG-GUID: 5YlPiVfY1QwXo06vp1PmO9ZUv_GVlZ-h
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

David Howells <dhowells@redhat.com> writes:
> From: Stephen Brennan <stephen.s.brennan@oracle.com>
>
> A rare BUG_ON triggered in assoc_array_gc:
>
>     [3430308.818153] kernel BUG at lib/assoc_array.c:1609!
>
> Which corresponded to the statement currently at line 1593 upstream:
>
>     BUG_ON(assoc_array_ptr_is_meta(p));
>
> Using the data from the core dump, I was able to generate a userspace
> reproducer[1] and determine the cause of the bug.
>
> [1]: https://github.com/brenns10/kernel_stuff/tree/master/assoc_array_gc
>
> After running the iterator on the entire branch, an internal tree node
> looked like the following:
>
>     NODE (nr_leaves_on_branch: 3)
>       SLOT [0] NODE (2 leaves)
>       SLOT [1] NODE (1 leaf)
>       SLOT [2..f] NODE (empty)
>
> In the userspace reproducer, the pr_devel output when compressing this
> node was:
>
>     -- compress node 0x5607cc089380 --
>     free=0, leaves=0
>     [0] retain node 2/1 [nx 0]
>     [1] fold node 1/1 [nx 0]
>     [2] fold node 0/1 [nx 2]
>     [3] fold node 0/2 [nx 2]
>     [4] fold node 0/3 [nx 2]
>     [5] fold node 0/4 [nx 2]
>     [6] fold node 0/5 [nx 2]
>     [7] fold node 0/6 [nx 2]
>     [8] fold node 0/7 [nx 2]
>     [9] fold node 0/8 [nx 2]
>     [10] fold node 0/9 [nx 2]
>     [11] fold node 0/10 [nx 2]
>     [12] fold node 0/11 [nx 2]
>     [13] fold node 0/12 [nx 2]
>     [14] fold node 0/13 [nx 2]
>     [15] fold node 0/14 [nx 2]
>     after: 3
>
> At slot 0, an internal node with 2 leaves could not be folded into the
> node, because there was only one available slot (slot 0). Thus, the
> internal node was retained. At slot 1, the node had one leaf, and was
> able to be folded in successfully. The remaining nodes had no leaves,
> and so were removed. By the end of the compression stage, there were 14
> free slots, and only 3 leaf nodes. The tree was ascended and then its
> parent node was compressed. When this node was seen, it could not be
> folded, due to the internal node it contained.
>
> The invariant for compression in this function is: whenever
> nr_leaves_on_branch < ASSOC_ARRAY_FAN_OUT, the node should contain all
> leaf nodes. The compression step currently cannot guarantee this, given
> the corner case shown above.
>
> To fix this issue, retry compression whenever we have retained a node,
> and yet nr_leaves_on_branch < ASSOC_ARRAY_FAN_OUT. This second
> compression will then allow the node in slot 1 to be folded in,
> satisfying the invariant. Below is the output of the reproducer once the
> fix is applied:
>
>     -- compress node 0x560e9c562380 --
>     free=0, leaves=0
>     [0] retain node 2/1 [nx 0]
>     [1] fold node 1/1 [nx 0]
>     [2] fold node 0/1 [nx 2]
>     [3] fold node 0/2 [nx 2]
>     [4] fold node 0/3 [nx 2]
>     [5] fold node 0/4 [nx 2]
>     [6] fold node 0/5 [nx 2]
>     [7] fold node 0/6 [nx 2]
>     [8] fold node 0/7 [nx 2]
>     [9] fold node 0/8 [nx 2]
>     [10] fold node 0/9 [nx 2]
>     [11] fold node 0/10 [nx 2]
>     [12] fold node 0/11 [nx 2]
>     [13] fold node 0/12 [nx 2]
>     [14] fold node 0/13 [nx 2]
>     [15] fold node 0/14 [nx 2]
>     internal nodes remain despite enough space, retrying
>     -- compress node 0x560e9c562380 --
>     free=14, leaves=1
>     [0] fold node 2/15 [nx 0]
>     after: 3
>
> Changes
> =======
> DH:
>  - Use false instead of 0.
>  - Reorder the inserted lines in a couple of places to put retained before
>    next_slot.
>
> ver #2)
>  - Fix typo in pr_devel, correct comparison to "<="
>
>
> Fixes: 3cb989501c26 ("Add a generic associative array implementation.")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Jarkko Sakkinen <jarkko@kernel.org>
> cc: Andrew Morton <akpm@linux-foundation.org>
> cc: keyrings@vger.kernel.org
> Link: https://lore.kernel.org/r/20220511225517.407935-1-stephen.s.brennan@oracle.com/ # v1
> Link: https://lore.kernel.org/r/20220512215045.489140-1-stephen.s.brennan@oracle.com/ # v2
> ---
>
>  lib/assoc_array.c |    8 ++++++++
>  1 file changed, 8 insertions(+)

Hi,

Just wanted to check on this patch as the 5.19 window closes. David, are
you planning on taking this through a particular tree, or is the ask for
Linus to pick it directly?

Thanks,
Stephen

>
> diff --git a/lib/assoc_array.c b/lib/assoc_array.c
> index 079c72e26493..ca0b4f360c1a 100644
> --- a/lib/assoc_array.c
> +++ b/lib/assoc_array.c
> @@ -1461,6 +1461,7 @@ int assoc_array_gc(struct assoc_array *array,
>  	struct assoc_array_ptr *cursor, *ptr;
>  	struct assoc_array_ptr *new_root, *new_parent, **new_ptr_pp;
>  	unsigned long nr_leaves_on_tree;
> +	bool retained;
>  	int keylen, slot, nr_free, next_slot, i;
>  
>  	pr_devel("-->%s()\n", __func__);
> @@ -1536,6 +1537,7 @@ int assoc_array_gc(struct assoc_array *array,
>  		goto descend;
>  	}
>  
> +retry_compress:
>  	pr_devel("-- compress node %p --\n", new_n);
>  
>  	/* Count up the number of empty slots in this node and work out the
> @@ -1553,6 +1555,7 @@ int assoc_array_gc(struct assoc_array *array,
>  	pr_devel("free=%d, leaves=%lu\n", nr_free, new_n->nr_leaves_on_branch);
>  
>  	/* See what we can fold in */
> +	retained = false;
>  	next_slot = 0;
>  	for (slot = 0; slot < ASSOC_ARRAY_FAN_OUT; slot++) {
>  		struct assoc_array_shortcut *s;
> @@ -1602,9 +1605,14 @@ int assoc_array_gc(struct assoc_array *array,
>  			pr_devel("[%d] retain node %lu/%d [nx %d]\n",
>  				 slot, child->nr_leaves_on_branch, nr_free + 1,
>  				 next_slot);
> +			retained = true;
>  		}
>  	}
>  
> +	if (retained && new_n->nr_leaves_on_branch <= ASSOC_ARRAY_FAN_OUT) {
> +		pr_devel("internal nodes remain despite enough space, retrying\n");
> +		goto retry_compress;
> +	}
>  	pr_devel("after: %lu\n", new_n->nr_leaves_on_branch);
>  
>  	nr_leaves_on_tree = new_n->nr_leaves_on_branch;
