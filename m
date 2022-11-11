Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 430A762522F
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 05:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbiKKELK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 23:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiKKELH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 23:11:07 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438361BEB7;
        Thu, 10 Nov 2022 20:10:59 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB43ojm027645;
        Fri, 11 Nov 2022 04:10:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=9LEhY2WIUQLIusznqSrNpzP7G1B53xHPtxwW7FjWbf0=;
 b=QnxCWcxfmDKxN7cRRasPdGroqTPht7AoN4ZaBzRBrr9tvrnVOqmdGbD+m8zUJDPRVDKC
 nbJeY2/xes799scpwu4YZEgLt7p+sSFN+lbgfqADRjOTurrpV18IlGFqMeKCQZiHVQFc
 P9LRYVsnhApayamznZMdsVqUa1B4XzojyWfyuRUC+UbV+xEP6gDAGJUAjTrSsSKpxi2u
 nzEeth8enhV6cnoYqTkHrpOibI+9Ex50sDTQhPHbXDh0gJy6QNQlLm83DqmwpL4Lmk7+
 UP9MOamBcwbUCj/2ifVlJ2Bl7DN4xiCp+ZlB36RbicggtRRJAeuXEOyf3SA7Lyuy3Nnw Qw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ksf0wr0d8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 04:10:53 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AB3gQrT038089;
        Fri, 11 Nov 2022 04:10:52 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2047.outbound.protection.outlook.com [104.47.56.47])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcshgw26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Nov 2022 04:10:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dpxbtINcz930FK3KJm9ZRHMgLSDyy6y+02yUpd466kReUx6DbWPFfAQjv58imrtT20a9uFZeVlxHOn6vncJsg8uIB7rIkADO9c66GfWWWysBz3s/JpxmsCwDOpXtpKgJS9pOP6Hd3ISYmX1CMljIrlLTuP5TvLs0i8YCZE6E0DaCF9lYmtPzh1bRjaU1ANcETO1pkHZBJr9PSyG32jeM8MqMk4Kmix4Ey6RXIjr+ENtddYZLT4biylbainiDYCtI5EC/jQvc2IyGDUC4EdnDFV+t7rxpC80axnuRylKqwEu5b7lnA+y9BnbnYej0m4lbs+R44lRKJpcRT9lAidTQwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9LEhY2WIUQLIusznqSrNpzP7G1B53xHPtxwW7FjWbf0=;
 b=XRrp3/rqY0FnxYDD/AZDeA4CURxbEzmhk0m2BL4tQ9Xpcseh30pOBatGZ1WbbpEMJypkn1yxATkcFKB6e7tZskYAnkSEuZMS6O+ys76RcTaJHcxjwzkKKMa124wEVl9961B/PwhAQG+pH5S9/280fGH+aVhUAOD+WSZV/5dFYq3kwYGynphTG4TiRRenGHT3a0tfZZ/Bj/HJ1/iO0YM69txRCi7ICp4k6M/ihhjuovRpk2BwUvo23ODDSSo+w4t6ABndr4aI2bSIhUazuh2+xwIYHjNgMECNNYqH3QOdluaeJ2BSjgWxEN3tCeetko71B6pQD2Fzpzp7cu8SfKKEMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9LEhY2WIUQLIusznqSrNpzP7G1B53xHPtxwW7FjWbf0=;
 b=OoAeE9gjiP1HYOH/uIkIqiLS+AyTTQ+TEahe1TWV1SrMXbuWJW3PcKRNQK82QeBXF1ShpiAEfLrjHcnPeRiRGtKF+dxND75oIvZag0/36Ks65Jtqa+84Yv2y8hDIF+1hGPfFlLUj0KIkzIcChnm32GnGpYs55oTrdOUcIKZGpuU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SA2PR10MB4730.namprd10.prod.outlook.com (2603:10b6:806:117::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Fri, 11 Nov
 2022 04:10:50 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::a671:8bae:5830:6fd]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::a671:8bae:5830:6fd%3]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 04:10:50 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 3/6] xfs: redesign the reflink remap loop to fix blkres depletion crash
Date:   Fri, 11 Nov 2022 09:40:22 +0530
Message-Id: <20221111041025.87704-4-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111041025.87704-1-chandan.babu@oracle.com>
References: <20221111041025.87704-1-chandan.babu@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TY2PR0101CA0032.apcprd01.prod.exchangelabs.com
 (2603:1096:404:8000::18) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SA2PR10MB4730:EE_
X-MS-Office365-Filtering-Correlation-Id: ad0e35a8-e73a-4a63-4d7f-08dac39ab7ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IPDGx1jtWjV93OtSS+GymRyKnTBJ04EkkYJBGtoDsAYYUmCK+KeJdx93Isrycv/2Vk2sZaL1FSVanZnTalA3JM/0ZMERkED27iW63Rsto939whi6onAZdcBmCUarIt5btpM9wC1SneiTKCowAt5nPp2h3Fo9GAuALj3WTPW/YerFvgGNcyVmY2GPJ24UZwYvhPF//y0K3K/uakhNpwa+qBPy6hUrgdP9BXW91rE8fwdrHnrIQn/TWuD/Q3ZbuPHwOrUHoasprMTkykSOEBePq9EMMNUqSQc6+sO5H5I2aHVqAIkxnjyJ+ZHjljRAakoVMjarPr4sr/S/EdJlKWDSbOYv6lBDE4eYXssUgJ13fZaBGuxLHPv8tnFBMJ4fgb0F2nP+xK+OrNdxeMbYaPDMqOFgcmEYIk/Od5SwFLumV3DpNjDmPxGmE+kgD9BhQu8Zq3Iqr+vIk7728gQxG1SaLkGAaENrGZxLrs3Q+n/HvotcmEvL/XHholVJ8YC1DC4XV6RqUz3eM9IFVeYxaK43I47VGSTnIwqqZDdMLG+ksvsZ735cqCnb/B0f9goTH1qCL6+Mg3BlWGVtDLhCJDZyShsjsGFiqiWNzxzj/uhflNgkq8VHsSzUtKv9dD6htCunszKf94FhmAlqk8n7Z3qjCsHZ35hROYCWT3nGnM0LftT6/Be2qPqG1vnpwvcnW3N/THVHlq8VjfT2WZwQ8u+EJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199015)(36756003)(66899015)(66574015)(66556008)(6916009)(38100700002)(8936002)(66476007)(5660300002)(6506007)(66946007)(8676002)(30864003)(316002)(2906002)(41300700001)(4326008)(6486002)(6666004)(86362001)(2616005)(186003)(6512007)(83380400001)(478600001)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V1RaVWt1LzdUcXZXYmtMVURDVUlGVzJuR3N1MzFrWWJhV1N6dFhISEZXdUl3?=
 =?utf-8?B?SzA2M2EzZHpLaDdsVWs1TXROVm9XaUVFYy9BaXFGWldqR0FWblQ5SS9TMi9F?=
 =?utf-8?B?dEp1dlBVYk03d29UOXkyYWlhb256RWk3eGpucnBLWkYyS0hrdDJPK2pkSHNo?=
 =?utf-8?B?NElpMUM3UzhpV3ZuVngra1JVUTR1TklSN0pKRTFRQXhIQng0cEdyWEt6U0Nm?=
 =?utf-8?B?QnBwTG01dTJJdWdvRUhsamg4YW5ERVd6UmNVWUNSbmVPUDlWd2xVWDVkNTlD?=
 =?utf-8?B?OERYcHp1VVhDSmpuRWJjcmpGb2tJdFlsb0pSbkJ5MFlCZGN5dTlXOUhUWGFs?=
 =?utf-8?B?MlF0N2hwejM3aXNFRmQ1cVlva0NFMGdteEFUTUNWT1JldWlNODFUUTFjS0Uw?=
 =?utf-8?B?VFBaZUVWQWNYa2IvdytxTWIydFJBcFdxN2tOTlo4UnpOOUlEd0NTNDhQRlRC?=
 =?utf-8?B?cllRM0U1eU9QdVZQbjlOMjBSTGR0WGJzK2h4Zm9GeFhBc2x6WVI4dC9rSTdP?=
 =?utf-8?B?YUhpQ1R2R0RUL1I5YitsYUZWcDVMazJTN1B5SnZpOVVsU2JyQ3lwV0VHWDJy?=
 =?utf-8?B?cDRSMFlldlVnVFJXNjlDZXNBTE54bDlpa0dMY3FIaDNLc2M4Uk85cm5UOG0w?=
 =?utf-8?B?eit6dDBmc3RtREE3eXhrTmJvaU8rTkZXRUFaK0xPUUk4ZFRhLzMwNFA4aVNW?=
 =?utf-8?B?eFZNUXZuSXp3S1dGUW1iaXNqMG5MbUo0eVRrUi8rSFdhV3NRR3dGUlBlSmFG?=
 =?utf-8?B?WFhxQUk0SDVnQSswSVhxWktSRFZjREVOaHRVQTRjZ1FnbVhCTzZOWHE3dEho?=
 =?utf-8?B?R240MGhKZHZWMFlYQjBsMUYwSDRZU09lVzZkdGVKM3AwUXFDUDVVLzlxZHQ1?=
 =?utf-8?B?ZjlQS050R3JnSFQ0elVIUEwxYjFGMEFSMUVEdE4zVHRPTE94K0RrZWU0aS9O?=
 =?utf-8?B?a2c2Q1phTzBPQ1o4R1pMSWIwUitLOWNPV1l5NXozNThWMmptUkYyK1ZzN3Az?=
 =?utf-8?B?MmRPWDEwVDJDRlhieUVIVndwcnBVWFNDN2gzalRFS2FuY3pqZHlXWjM5UWpQ?=
 =?utf-8?B?V3hNNm11Yk02QzFLbWFiaFJwOUpLK2U2a0p4N1hOL2xiZWY1WDNzNklERzM5?=
 =?utf-8?B?KzJzR3JSZnB1NUNwblhQVzRaVWdqdXJ0TlJiS1ZLb1IzZCtrYWxtQlQ1NXNQ?=
 =?utf-8?B?ck9heFpNVDh0NHlycCsxNG0yWUo5V0dJTFQxZ3lDWlZKMWpQOE51UWQxUjZX?=
 =?utf-8?B?UCtXSGo1ZGNGSFdMRDBZT2VGTmhMeUtnWWhBcEZSVGZvWElJOXZkYm9LTnQ1?=
 =?utf-8?B?ODVOa0RmRzBxbEJjZ2orejNNR2RRNzFlUkpvTDczVnMya3VSMG5IbGh1MkNs?=
 =?utf-8?B?b0Vxby8vVmRPaXorbGNVMU9ua280aWdBWURuYkYyc1hwaUFpUlEyOS9rR2Jl?=
 =?utf-8?B?QmcrWUE3NCtpSGhKUSt3YjFyVExaOUIzdTNQeE1WT2hLQWkzTFY0bFVNQUcy?=
 =?utf-8?B?RnhyNVNyRVFRV0Ztbmx4NkxISko3UVUwem9mVm03TFRyTGpLK3B6MXRTWTF2?=
 =?utf-8?B?K1ZhV08vM1l6NzBWTGJMTXdEUFJyejlnUUtJV2FwMHF2c0ZiOUoxc3A2WEFq?=
 =?utf-8?B?Z3JINmxKWlllV2MvV3M3Ymg4eVlMT0pxaUVmcGU3cE9BMy84UnpGQTBHZndR?=
 =?utf-8?B?cnRIc1NSMEV6WWdWazYzZUhCcjBlR0wzd3BZZklNRW9waElWUVJmLzRjY3cv?=
 =?utf-8?B?djVQdTIxaE55M1g5dmxJS2YwNjZTcTFBa3QzYldGWTFoNGd4dVNXK2V5Qzh0?=
 =?utf-8?B?dDZmSlE0bm85aUs5Z2lmM2l2eS9IVXdweFpYY21kcDZkU1h5eHNOTzFLVGZ6?=
 =?utf-8?B?M1N5VjgydldZdmNvNjZRekJCZ0wreVkyY0tUMzRWNUxVQ09Td1ltOTNWK2Z5?=
 =?utf-8?B?bFVXVm9LVnE5MTQ1OU9zSFB6R2NsT1cwb05VTm1jdTZqMk1nYW1ZYnRZQlRr?=
 =?utf-8?B?ZDR3S1oyVGlUUXVBdFZCYktNVllYazR1c1FQMUZ1YnByeVJHTXMzZzdQOGpa?=
 =?utf-8?B?dlhCNHd1angwVTJyOEJ0aGQ2SzJhckZvWlBrbWRxNFgyMnRDdCs5N2dUeHIy?=
 =?utf-8?B?NzZNU2JsTUxGMWFuclR3WjBSTzQzOEFFbXdZd1ZUOWxkYW01SjdHcE5aN3dW?=
 =?utf-8?B?VXc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad0e35a8-e73a-4a63-4d7f-08dac39ab7ad
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 04:10:50.4064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XJm4i1A4vUwCphWutagNyrz3C2lKpGHtbXDCPfVY4i4Y7irakjSPoO3dQBhp4jrGC/M6HQmeALWLMLRM2V8fUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4730
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-11_01,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211110026
X-Proofpoint-GUID: 31HslOIS2qvwe-ouXgdOPkxtHXHgF7tA
X-Proofpoint-ORIG-GUID: 31HslOIS2qvwe-ouXgdOPkxtHXHgF7tA
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 00fd1d56dd08a8ceaa9e4ee1a41fefd9f6c6bc7d upstream.

The existing reflink remapping loop has some structural problems that
need addressing:

The biggest problem is that we create one transaction for each extent in
the source file without accounting for the number of mappings there are
for the same range in the destination file.  In other words, we don't
know the number of remap operations that will be necessary and we
therefore cannot guess the block reservation required.  On highly
fragmented filesystems (e.g. ones with active dedupe) we guess wrong,
run out of block reservation, and fail.

The second problem is that we don't actually use the bmap intents to
their full potential -- instead of calling bunmapi directly and having
to deal with its backwards operation, we could call the deferred ops
xfs_bmap_unmap_extent and xfs_refcount_decrease_extent instead.  This
makes the frontend loop much simpler.

Solve all of these problems by refactoring the remapping loops so that
we only perform one remapping operation per transaction, and each
operation only tries to remap a single extent from source to dest.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reported-by: Edwin Török <edwin@etorok.net>
Tested-by: Edwin Török <edwin@etorok.net>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.h |  13 ++-
 fs/xfs/xfs_reflink.c     | 238 +++++++++++++++++++++------------------
 fs/xfs/xfs_trace.h       |  52 +--------
 3 files changed, 141 insertions(+), 162 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index b5363c6c88af..a51c2b13a51a 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -158,6 +158,13 @@ static inline int xfs_bmapi_whichfork(int bmapi_flags)
 	{ BMAP_ATTRFORK,	"ATTR" }, \
 	{ BMAP_COWFORK,		"COW" }
 
+/* Return true if the extent is an allocated extent, written or not. */
+static inline bool xfs_bmap_is_real_extent(struct xfs_bmbt_irec *irec)
+{
+	return irec->br_startblock != HOLESTARTBLOCK &&
+		irec->br_startblock != DELAYSTARTBLOCK &&
+		!isnullstartblock(irec->br_startblock);
+}
 
 /*
  * Return true if the extent is a real, allocated extent, or false if it is  a
@@ -165,10 +172,8 @@ static inline int xfs_bmapi_whichfork(int bmapi_flags)
  */
 static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
 {
-	return irec->br_state != XFS_EXT_UNWRITTEN &&
-		irec->br_startblock != HOLESTARTBLOCK &&
-		irec->br_startblock != DELAYSTARTBLOCK &&
-		!isnullstartblock(irec->br_startblock);
+	return xfs_bmap_is_real_extent(irec) &&
+	       irec->br_state != XFS_EXT_UNWRITTEN;
 }
 
 /*
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 77b7ace04ffd..01191ff46647 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -986,41 +986,28 @@ xfs_reflink_ag_has_free_space(
 }
 
 /*
- * Unmap a range of blocks from a file, then map other blocks into the hole.
- * The range to unmap is (destoff : destoff + srcioff + irec->br_blockcount).
- * The extent irec is mapped into dest at irec->br_startoff.
+ * Remap the given extent into the file.  The dmap blockcount will be set to
+ * the number of blocks that were actually remapped.
  */
 STATIC int
 xfs_reflink_remap_extent(
 	struct xfs_inode	*ip,
-	struct xfs_bmbt_irec	*irec,
-	xfs_fileoff_t		destoff,
+	struct xfs_bmbt_irec	*dmap,
 	xfs_off_t		new_isize)
 {
+	struct xfs_bmbt_irec	smap;
 	struct xfs_mount	*mp = ip->i_mount;
-	bool			real_extent = xfs_bmap_is_written_extent(irec);
 	struct xfs_trans	*tp;
-	unsigned int		resblks;
-	struct xfs_bmbt_irec	uirec;
-	xfs_filblks_t		rlen;
-	xfs_filblks_t		unmap_len;
 	xfs_off_t		newlen;
-	int64_t			qres;
+	int64_t			qres, qdelta;
+	unsigned int		resblks;
+	bool			smap_real;
+	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
+	int			nimaps;
 	int			error;
 
-	unmap_len = irec->br_startoff + irec->br_blockcount - destoff;
-	trace_xfs_reflink_punch_range(ip, destoff, unmap_len);
-
-	/* No reflinking if we're low on space */
-	if (real_extent) {
-		error = xfs_reflink_ag_has_free_space(mp,
-				XFS_FSB_TO_AGNO(mp, irec->br_startblock));
-		if (error)
-			goto out;
-	}
-
 	/* Start a rolling transaction to switch the mappings */
-	resblks = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
+	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
 	if (error)
 		goto out;
@@ -1029,92 +1016,121 @@ xfs_reflink_remap_extent(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	/*
-	 * Reserve quota for this operation.  We don't know if the first unmap
-	 * in the dest file will cause a bmap btree split, so we always reserve
-	 * at least enough blocks for that split.  If the extent being mapped
-	 * in is written, we need to reserve quota for that too.
+	 * Read what's currently mapped in the destination file into smap.
+	 * If smap isn't a hole, we will have to remove it before we can add
+	 * dmap to the destination file.
 	 */
-	qres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
-	if (real_extent)
-		qres += irec->br_blockcount;
-	error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0,
-			XFS_QMOPT_RES_REGBLKS);
+	nimaps = 1;
+	error = xfs_bmapi_read(ip, dmap->br_startoff, dmap->br_blockcount,
+			&smap, &nimaps, 0);
 	if (error)
 		goto out_cancel;
+	ASSERT(nimaps == 1 && smap.br_startoff == dmap->br_startoff);
+	smap_real = xfs_bmap_is_real_extent(&smap);
 
-	trace_xfs_reflink_remap(ip, irec->br_startoff,
-				irec->br_blockcount, irec->br_startblock);
+	/*
+	 * We can only remap as many blocks as the smaller of the two extent
+	 * maps, because we can only remap one extent at a time.
+	 */
+	dmap->br_blockcount = min(dmap->br_blockcount, smap.br_blockcount);
+	ASSERT(dmap->br_blockcount == smap.br_blockcount);
 
-	/* Unmap the old blocks in the data fork. */
-	rlen = unmap_len;
-	while (rlen) {
-		ASSERT(tp->t_firstblock == NULLFSBLOCK);
-		error = __xfs_bunmapi(tp, ip, destoff, &rlen, 0, 1);
+	trace_xfs_reflink_remap_extent_dest(ip, &smap);
+
+	/* No reflinking if the AG of the dest mapping is low on space. */
+	if (dmap_written) {
+		error = xfs_reflink_ag_has_free_space(mp,
+				XFS_FSB_TO_AGNO(mp, dmap->br_startblock));
 		if (error)
 			goto out_cancel;
+	}
 
+	/*
+	 * Compute quota reservation if we think the quota block counter for
+	 * this file could increase.
+	 *
+	 * We start by reserving enough blocks to handle a bmbt split.
+	 *
+	 * If we are mapping a written extent into the file, we need to have
+	 * enough quota block count reservation to handle the blocks in that
+	 * extent.
+	 *
+	 * Note that if we're replacing a delalloc reservation with a written
+	 * extent, we have to take the full quota reservation because removing
+	 * the delalloc reservation gives the block count back to the quota
+	 * count.  This is suboptimal, but the VFS flushed the dest range
+	 * before we started.  That should have removed all the delalloc
+	 * reservations, but we code defensively.
+	 */
+	qdelta = 0;
+	qres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
+	if (dmap_written)
+		qres += dmap->br_blockcount;
+	error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0,
+			XFS_QMOPT_RES_REGBLKS);
+	if (error)
+		goto out_cancel;
+
+	if (smap_real) {
 		/*
-		 * Trim the extent to whatever got unmapped.
-		 * Remember, bunmapi works backwards.
+		 * If the extent we're unmapping is backed by storage (written
+		 * or not), unmap the extent and drop its refcount.
 		 */
-		uirec.br_startblock = irec->br_startblock + rlen;
-		uirec.br_startoff = irec->br_startoff + rlen;
-		uirec.br_blockcount = unmap_len - rlen;
-		uirec.br_state = irec->br_state;
-		unmap_len = rlen;
-
-		/* If this isn't a real mapping, we're done. */
-		if (!real_extent || uirec.br_blockcount == 0)
-			goto next_extent;
-
-		trace_xfs_reflink_remap(ip, uirec.br_startoff,
-				uirec.br_blockcount, uirec.br_startblock);
+		xfs_bmap_unmap_extent(tp, ip, &smap);
+		xfs_refcount_decrease_extent(tp, &smap);
+		qdelta -= smap.br_blockcount;
+	} else if (smap.br_startblock == DELAYSTARTBLOCK) {
+		xfs_filblks_t	len = smap.br_blockcount;
 
-		/* Update the refcount tree */
-		xfs_refcount_increase_extent(tp, &uirec);
-
-		/* Map the new blocks into the data fork. */
-		xfs_bmap_map_extent(tp, ip, &uirec);
+		/*
+		 * If the extent we're unmapping is a delalloc reservation,
+		 * we can use the regular bunmapi function to release the
+		 * incore state.  Dropping the delalloc reservation takes care
+		 * of the quota reservation for us.
+		 */
+		error = __xfs_bunmapi(NULL, ip, smap.br_startoff, &len, 0, 1);
+		if (error)
+			goto out_cancel;
+		ASSERT(len == 0);
+	}
 
-		/* Update quota accounting. */
-		xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT,
-				uirec.br_blockcount);
+	/*
+	 * If the extent we're sharing is backed by written storage, increase
+	 * its refcount and map it into the file.
+	 */
+	if (dmap_written) {
+		xfs_refcount_increase_extent(tp, dmap);
+		xfs_bmap_map_extent(tp, ip, dmap);
+		qdelta += dmap->br_blockcount;
+	}
 
-		/* Update dest isize if needed. */
-		newlen = XFS_FSB_TO_B(mp,
-				uirec.br_startoff + uirec.br_blockcount);
-		newlen = min_t(xfs_off_t, newlen, new_isize);
-		if (newlen > i_size_read(VFS_I(ip))) {
-			trace_xfs_reflink_update_inode_size(ip, newlen);
-			i_size_write(VFS_I(ip), newlen);
-			ip->i_d.di_size = newlen;
-			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-		}
+	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, qdelta);
 
-next_extent:
-		/* Process all the deferred stuff. */
-		error = xfs_defer_finish(&tp);
-		if (error)
-			goto out_cancel;
+	/* Update dest isize if needed. */
+	newlen = XFS_FSB_TO_B(mp, dmap->br_startoff + dmap->br_blockcount);
+	newlen = min_t(xfs_off_t, newlen, new_isize);
+	if (newlen > i_size_read(VFS_I(ip))) {
+		trace_xfs_reflink_update_inode_size(ip, newlen);
+		i_size_write(VFS_I(ip), newlen);
+		ip->i_d.di_size = newlen;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	}
 
+	/* Commit everything and unlock. */
 	error = xfs_trans_commit(tp);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	if (error)
-		goto out;
-	return 0;
+	goto out_unlock;
 
 out_cancel:
 	xfs_trans_cancel(tp);
+out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 out:
-	trace_xfs_reflink_remap_extent_error(ip, error, _RET_IP_);
+	if (error)
+		trace_xfs_reflink_remap_extent_error(ip, error, _RET_IP_);
 	return error;
 }
 
-/*
- * Iteratively remap one file's extents (and holes) to another's.
- */
+/* Remap a range of one file to the other. */
 int
 xfs_reflink_remap_blocks(
 	struct xfs_inode	*src,
@@ -1125,25 +1141,22 @@ xfs_reflink_remap_blocks(
 	loff_t			*remapped)
 {
 	struct xfs_bmbt_irec	imap;
-	xfs_fileoff_t		srcoff;
-	xfs_fileoff_t		destoff;
+	struct xfs_mount	*mp = src->i_mount;
+	xfs_fileoff_t		srcoff = XFS_B_TO_FSBT(mp, pos_in);
+	xfs_fileoff_t		destoff = XFS_B_TO_FSBT(mp, pos_out);
 	xfs_filblks_t		len;
-	xfs_filblks_t		range_len;
 	xfs_filblks_t		remapped_len = 0;
 	xfs_off_t		new_isize = pos_out + remap_len;
 	int			nimaps;
 	int			error = 0;
 
-	destoff = XFS_B_TO_FSBT(src->i_mount, pos_out);
-	srcoff = XFS_B_TO_FSBT(src->i_mount, pos_in);
-	len = XFS_B_TO_FSB(src->i_mount, remap_len);
+	len = min_t(xfs_filblks_t, XFS_B_TO_FSB(mp, remap_len),
+			XFS_MAX_FILEOFF);
 
-	/* drange = (destoff, destoff + len); srange = (srcoff, srcoff + len) */
-	while (len) {
-		uint		lock_mode;
+	trace_xfs_reflink_remap_blocks(src, srcoff, len, dest, destoff);
 
-		trace_xfs_reflink_remap_blocks_loop(src, srcoff, len,
-				dest, destoff);
+	while (len > 0) {
+		unsigned int	lock_mode;
 
 		/* Read extent from the source file */
 		nimaps = 1;
@@ -1152,18 +1165,25 @@ xfs_reflink_remap_blocks(
 		xfs_iunlock(src, lock_mode);
 		if (error)
 			break;
-		ASSERT(nimaps == 1);
-
-		trace_xfs_reflink_remap_imap(src, srcoff, len, XFS_DATA_FORK,
-				&imap);
+		/*
+		 * The caller supposedly flushed all dirty pages in the source
+		 * file range, which means that writeback should have allocated
+		 * or deleted all delalloc reservations in that range.  If we
+		 * find one, that's a good sign that something is seriously
+		 * wrong here.
+		 */
+		ASSERT(nimaps == 1 && imap.br_startoff == srcoff);
+		if (imap.br_startblock == DELAYSTARTBLOCK) {
+			ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
+			error = -EFSCORRUPTED;
+			break;
+		}
 
-		/* Translate imap into the destination file. */
-		range_len = imap.br_startoff + imap.br_blockcount - srcoff;
-		imap.br_startoff += destoff - srcoff;
+		trace_xfs_reflink_remap_extent_src(src, &imap);
 
-		/* Clear dest from destoff to the end of imap and map it in. */
-		error = xfs_reflink_remap_extent(dest, &imap, destoff,
-				new_isize);
+		/* Remap into the destination file at the given offset. */
+		imap.br_startoff = destoff;
+		error = xfs_reflink_remap_extent(dest, &imap, new_isize);
 		if (error)
 			break;
 
@@ -1173,10 +1193,10 @@ xfs_reflink_remap_blocks(
 		}
 
 		/* Advance drange/srange */
-		srcoff += range_len;
-		destoff += range_len;
-		len -= range_len;
-		remapped_len += range_len;
+		srcoff += imap.br_blockcount;
+		destoff += imap.br_blockcount;
+		len -= imap.br_blockcount;
+		remapped_len += imap.br_blockcount;
 	}
 
 	if (error)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index b5d4ca60145a..f94908125e8f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3078,8 +3078,7 @@ DEFINE_EVENT(xfs_inode_irec_class, name, \
 DEFINE_INODE_EVENT(xfs_reflink_set_inode_flag);
 DEFINE_INODE_EVENT(xfs_reflink_unset_inode_flag);
 DEFINE_ITRUNC_EVENT(xfs_reflink_update_inode_size);
-DEFINE_IMAP_EVENT(xfs_reflink_remap_imap);
-TRACE_EVENT(xfs_reflink_remap_blocks_loop,
+TRACE_EVENT(xfs_reflink_remap_blocks,
 	TP_PROTO(struct xfs_inode *src, xfs_fileoff_t soffset,
 		 xfs_filblks_t len, struct xfs_inode *dest,
 		 xfs_fileoff_t doffset),
@@ -3110,59 +3109,14 @@ TRACE_EVENT(xfs_reflink_remap_blocks_loop,
 		  __entry->dest_ino,
 		  __entry->dest_lblk)
 );
-TRACE_EVENT(xfs_reflink_punch_range,
-	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t lblk,
-		 xfs_extlen_t len),
-	TP_ARGS(ip, lblk, len),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(xfs_fileoff_t, lblk)
-		__field(xfs_extlen_t, len)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->lblk = lblk;
-		__entry->len = len;
-	),
-	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->lblk,
-		  __entry->len)
-);
-TRACE_EVENT(xfs_reflink_remap,
-	TP_PROTO(struct xfs_inode *ip, xfs_fileoff_t lblk,
-		 xfs_extlen_t len, xfs_fsblock_t new_pblk),
-	TP_ARGS(ip, lblk, len, new_pblk),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_ino_t, ino)
-		__field(xfs_fileoff_t, lblk)
-		__field(xfs_extlen_t, len)
-		__field(xfs_fsblock_t, new_pblk)
-	),
-	TP_fast_assign(
-		__entry->dev = VFS_I(ip)->i_sb->s_dev;
-		__entry->ino = ip->i_ino;
-		__entry->lblk = lblk;
-		__entry->len = len;
-		__entry->new_pblk = new_pblk;
-	),
-	TP_printk("dev %d:%d ino 0x%llx lblk 0x%llx len 0x%x new_pblk %llu",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->ino,
-		  __entry->lblk,
-		  __entry->len,
-		  __entry->new_pblk)
-);
 DEFINE_DOUBLE_IO_EVENT(xfs_reflink_remap_range);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_range_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_set_inode_flag_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_update_inode_size_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_blocks_error);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_remap_extent_error);
+DEFINE_INODE_IREC_EVENT(xfs_reflink_remap_extent_src);
+DEFINE_INODE_IREC_EVENT(xfs_reflink_remap_extent_dest);
 
 /* dedupe tracepoints */
 DEFINE_DOUBLE_IO_EVENT(xfs_reflink_compare_extents);
-- 
2.35.1

