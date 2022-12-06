Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75244644D6A
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 21:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiLFUns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 15:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLFUnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 15:43:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583454384D
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 12:43:46 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6IxR8O012449;
        Tue, 6 Dec 2022 20:43:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-transfer-encoding :
 content-type : mime-version; s=corp-2022-7-12;
 bh=gqOtWcYjjX2FETuzwhAMgws2Mg5nmUgYGi14q2zEVXM=;
 b=xctfSgUOJkjovrUxvPtuN+Do5X82tvhReokQUSpRbeg7vk6EIwCk8VUJeGrzorArzviT
 pfEl6XL1u1b8KbaCtZnxJ5Vl184XACpuV1tyKPAoEsk+ezpbAhy31ocOF7On11Vx/4fd
 x+8XkTfv1AIwo05EBtEg6+9dcDk9pivPvjDBbsZLyH0tKtddC43SPtrtcauhiOyWp+Vg
 EGnSSb2C0bJq0TrnZQBlqTiIP6aLir+X89k5NmiTubdMULagyhaynLe8HT9/BuPro39b
 Zoo5bgvAoJN3l2z/IQ9UdNmMteAOojyuk9gxfsusVfeWQoTWdHZ8AXt6ppJy7+gBbJ32 2w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ycf8udq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 20:43:45 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B6JETvk021789;
        Tue, 6 Dec 2022 20:43:43 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa5wg6ya-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Dec 2022 20:43:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8jmyTLI4qq1amfqIGUCiCoTwlHXPKUBMhUywA3HYEZxAMRUK0E/Uc9SPlZAxR7lO+vLuIs6HzkyXHKW68MEPDnzwYUJaI3ZQaO45YOa2nmFnAJ1R2IZayfyGtcfn/GJ7+Otu5LDe/4WK3xO6mFZbu0RLMlFxKXNT6SRy0qm1FWTfDt5F2HHnDzo/1/dD8BPFz1wRT5acXyWw0T4alRuQNb0ZtrmkKID6qaYOzIzbc485YuH7GABakQd37Q1NgIPjftcjYUqqd7R9j9hgV1+G2U6260Pycy3rSIKF3l/SQw5Bm1UDEOWC90wJ0H8mFX/ZfPl+OgdDuxjW0kLpZWcYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gqOtWcYjjX2FETuzwhAMgws2Mg5nmUgYGi14q2zEVXM=;
 b=dwklnF2JE0PHcL9r4lfn2Lw8qu8rZUSmwvfiARIi6rNYKwR8z9RbKndHHAKPinhSClfSiyPLvrVXiD/8RR3sgQsE97a3vdsRyhmASgKtqhRnaqOSbySqe1GcA0OqOknWIAyJb5RbzfuCnXXSsSCHj5jVdf4Euawru8XqV9WOLyZYXitm/d+IsKEmY3xgG6+8MTz8bwR+wLBJ2fjTdiDw7UWKJhubwtz4D8Nnxxk0zrQgffvsgSLo7zYCvh6cMHMvCxiajcTpRjcVeSnZNGIU0XsezANbmOOwhrLuafvbvYkWeMAgZYOGZYhYDQPhBeU1uYmoSNgX7PiH6LKIJLc1HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gqOtWcYjjX2FETuzwhAMgws2Mg5nmUgYGi14q2zEVXM=;
 b=STG5UpYvHM8TStBrHt7b5CnZBHn+JB8FXhvYY0vYXkpM5izSk6fKMw7pHA03DlDKCyonEeqCbFcg3lRh1fWl3Tx29jQrt0aCIdOidXPK0vruxu+3TkLmh0LP1nn1zrQhRmWrfHQEzvtUoYscW7jpeh5aFP+1O0Gl1sciyao37D8=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CH0PR10MB5178.namprd10.prod.outlook.com (2603:10b6:610:dd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 20:43:20 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0%6]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 20:43:20 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.15 5.10 5.4 1/1] arm64: fix Build ID if CONFIG_MODVERSIONS
Date:   Tue,  6 Dec 2022 13:43:08 -0700
Message-Id: <9e387b71ce45d8b7fe9f2b9c52694e3df33f0c7a.1670358255.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670358255.git.tom.saeger@oracle.com>
References: <cover.1670358255.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0096.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::37) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CH0PR10MB5178:EE_
X-MS-Office365-Filtering-Correlation-Id: d0ced6de-e2ad-4c61-a98b-08dad7ca82d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9nNcgX+17bU6bpFG08ibIKw8POdUrv/2Am6hoq2PZV6jOBfG1D/XC9qPdAfwlqnazoh3JXGmyDcYtcWKEnzOJBg/G3/KiRyFyZ8jBX/IrPcd3iL1Y8K5bZNEOskHaZOeu/tSanF5/Pko582FREiK/kylzq1eRuGDvilJp/Vr8/1+4aTgcotS4zc7hZ5OqZ6W0kBmnVpjCODIXl5PK6kjpvevz0z0RZAq+2tSyHScPGynRh1PZ2DFq58u9rgLWiCptlLCmaa9hO2ny8FCgKWrs9HLnvGmpiyfdSx/KtOszW26zVKjyU9yBFG+tSpS1DXzkt7lNO5wWnomFln1JtPDY4c6qWpg6/LQZBGBGgHAi2Jgl334pASKU+bId0wx6mdcG7MCZjAuQM6nYRw1/mYNJs6J7sL68Sm6H2n7hd5dcWmWp8akU9CYC1fPiLkAOFhNOskrDKeHyNw3BT6k2kdRL5A+Uc4Eu88gIm6LD8ee06jvI+bEaZVUnbyzWTg33mfP3/jLnMUfP1KFdlXcslAbi0DcNJsKyp3z2Up4EOT97PRQYR2vNc0IODVnD94CXY1UFdouecz5xXPVU005Gbf4vh0CL12O08ltIeKyFrZKlw02V02xsuUBOPCHq5WqRXrTwWNDf26qur1ueYePJSAW+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(376002)(39860400002)(366004)(346002)(451199015)(38100700002)(86362001)(8936002)(44832011)(41300700001)(66556008)(2906002)(66476007)(66946007)(8676002)(478600001)(5660300002)(6506007)(6512007)(186003)(6666004)(316002)(2616005)(6916009)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uRKb4e5gzVNIzAD/ps/8J+/JNk/aQ1NrNSJaBooaVqG/sDFgEv5mkDjR8o4N?=
 =?us-ascii?Q?cHpGCMg6lSgWq2duXT3NTDVpnO20E8rrXVdyf5WSlVXHaJca15TIQig8AbhX?=
 =?us-ascii?Q?L93JX9RY6kKeBz02FMH9UaLQop+I6G+w9VluUM2Iq1YGOw3VruSjIm4UUntt?=
 =?us-ascii?Q?Ws95tYEzbTX2HIgHHnyg4WBzrt7hmCPN7m2KjPiwXmqgoIVWtThC/4j0UEhm?=
 =?us-ascii?Q?f/F01cPI1v9CCT5LIYKuUq4Ht3fESeifCICZ1occEWkilYB+zTZb2/Xm6AoC?=
 =?us-ascii?Q?K/ZyPHOtKxS5zddkswGpEgplavccQj5ARGhjN2hflnPpgXgjmpOhzNifbAhs?=
 =?us-ascii?Q?z641SWMwB+E/0flNwewgngB/TbFNnX4UUnZGeGR8LWeQlN015DvkyyLHq4DH?=
 =?us-ascii?Q?N4TtYBHMmvhD8dQ2sDKUXpa5g4/oBjWebJPY7cc/rFFLldP6k4FAMltlhiMK?=
 =?us-ascii?Q?Fk5gZz0IiZLI6QMlqLlggS9khYIKBy+0RPpSBCTIhH0G9ctuLnl841eJ7YZ2?=
 =?us-ascii?Q?SLZHAgDZC3Kz4vBtWZz8B0sJjgigaY4pguv8HXMQFjUhKLRQgs0PQrwuo+cO?=
 =?us-ascii?Q?++Eyl82zafanBxhVX37yb3+WRI0f1NRS1mN6EEwUJJglSDspI8kyIw2wDHYh?=
 =?us-ascii?Q?HQm777W8wfgsW2wBZzB1DYyGaN+/rI6p/j0KDjZOLrg1jW9/Aj0PyxzE8Mpr?=
 =?us-ascii?Q?5JtTJBjibMBAqnPJmYPuafSzUntCNMTEJnwlitOUvqZKiIF5jh9HSvdH0lYQ?=
 =?us-ascii?Q?SLy4Cb9mt0tQ3T1V5CSCbwvqxp4GhhZB1FvURQPve5w+F3rE9/PnbI8uc25G?=
 =?us-ascii?Q?8rnWZyS86b1lUxzdNjlo4Ii8+piU7z6sjCH/LsYgW4OeRg9Uzpj/RZlScesT?=
 =?us-ascii?Q?X8P5RiX6j7T5FgEcAbkbBC/WPE+CDSK0Xwtcz8qlZkNHnhjG35tD2jwCTXBc?=
 =?us-ascii?Q?W3AeBMqi65A1SZ06uOXUAY2572kDSVf7fjJNfek3Jou2OKbi21zj4Ly4rwuy?=
 =?us-ascii?Q?fcm3kzkX7qI9aUyzYcsnHaVTlOivPnP/TSB2L6waHawrpZP5PYQf2LRXtppv?=
 =?us-ascii?Q?EaEKpuzQq7HSUuPvoOofVGi1SEAU/8tTm/tGB1ft5fqdwy2vOE9BpPpxOX38?=
 =?us-ascii?Q?11z6+7ZuW5Zi8qwpvHA1TZXKsk9rdoxiaOjenkENeRPAOnCUAMBlyxGJKwmy?=
 =?us-ascii?Q?UXVS0I1+35tftGEi0yYyw0cSDJiu39PnTzZClSaotGWz/8pVGmox1WwauJCP?=
 =?us-ascii?Q?8+zfzARmScdz1CgtYJ/oq2f1J6o2u+27Cdv5/0omh4lCtYqore0m5QOJGfas?=
 =?us-ascii?Q?KTyQyvnH6OWa0NKoSdZCDeSCGlDCl0hauszkGquznkHsfWq0ss4dZTw5DmrL?=
 =?us-ascii?Q?VqVLo2lxuRqs8hD3HA3WYKPUEMmxLs6TR8yCbw4czbIpH/57qTvSwRWktqgD?=
 =?us-ascii?Q?IdAZdqNxKj2+LQS7Fz4kKVi9BbJODmduIRwB30C3742hl6TuLoOEiS6xB7zo?=
 =?us-ascii?Q?33vQ5rFDOp8FfwIUTjYFFbK8YjZ6S24em2wUxECrFnScJKoPFHdSOdutTSJf?=
 =?us-ascii?Q?49geO2vk1v+A531CzVEDbLIdZ7XksbvomwaweL05BFYmvlY32UkttYflcHzl?=
 =?us-ascii?Q?Yw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +nG27u0Vzh40565ATWI4hg2wEN/2W/s8Ud5J9XVpa5V97ElSQwlL89WOozZ7+0banK4PBFLN8cF3QrfqEo8k2BlBg49b4FCF78WfYxvm+mykjjniPycwEkB28xqyiHduM5WgAFh7uYTRCY8/p/VDEfP/qvjXak9ec+5QK343spNyCFmgRi51iTTYYNTODxO1jj3EnyJNGqHQKJP7wR8wX6XGRb2U0myaKGF2Zmzlx2/s1aYY2NdGPlSlRzZcu8h/iZKOCcpGfLwS+tD68l8dnFavBUKsdM1JNNwftoV2XguKaaoi33eiSsLnqeOSrUnmvl6548C7EZEc0UCmv6OYVycDmc4kQ6SFOzdob+VFkndT1eU/I7Do7rYRcLDqrhyMsRRw06tI1U07fk1+X2jrb/3uDeTqY5HZIJ7i4VQK4NsL93NEWp6JFUEmZTeqLkZngMDRyNicc0lnVOx4QvQUki3fJOjOviCg7ziQBBGc3kCWK43/dWYZ8HlV7tIgzGhIVZFHJumJsV/7uG7VBr8dPk0hvNQcaYTciAk20vbpQOYbFMNWTgJoXtxut4gjxmBVODKFX1s/P2AVrPFpWGaUE+m7djJDsidwE70sBI8iNL53HcqTnJAHqRD2wUQGqTCDofO4J2Fny4fn8+FpV0cxKZkSXP4ehI00l8EhVz5kJuDednz/nF2Wad9zGoGiKiJEaIkyKsjUZe6q5s2trA2VlSYhOW8t2AuQqdKMQMfm3MbOLTobAl/jnX9VfhbUoQSw7/VJQu6/8zUDCl1OBqzfZNI2xLnant0KJDTpuV8a4+xciYzGt6bpcOCteUuwxOsn
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0ced6de-e2ad-4c61-a98b-08dad7ca82d5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 20:43:20.6783
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Dby8EbVEMQweA2E+SAMwAh4wjrPA5vr7fkjsyWcqPYDkhKiCSOML7oRnbpWAQiPn9Ni1CUsd1FM62IS20oN7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5178
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_11,2022-12-06_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212060174
X-Proofpoint-ORIG-GUID: 3i9il3nTyUTqfOnvq9vuRUbKgiroUQm4
X-Proofpoint-GUID: 3i9il3nTyUTqfOnvq9vuRUbKgiroUQm4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport of: 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
breaks arm64 Build ID when CONFIG_MODVERSIONS=y.

CONFIG_MODVERSIONS adds extra tooling to calculate symbol versions.
This kernel's KBUILD tooling uses both
relocatable (-r) and (-z noexecstack) to link head.o
which results in ld adding a .note.GNU-stack section.
Final linking of vmlinux should add a .NOTES segment containing the
Build ID, but does NOT if head.o has a .note.GNU-stack section.

Selectively remove -z noexecstack from head.o's KBUILD_LDFLAGS to
prevent .note.GNU-stack from being added to head.o.  Final link of
vmlinux then properly adds .NOTES segment containing Build ID that can
be read using tools like 'readelf -n'.

Cc: <stable@vger.kernel.org> # 5.15, 5.10, 5.4
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/arm64/kernel/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 749e31475e41..8bdee0f655e2 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -85,3 +85,8 @@ extra-y					+= $(head-y) vmlinux.lds
 ifeq ($(CONFIG_DEBUG_EFI),y)
 AFLAGS_head.o += -DVMLINUX_PATH="\"$(realpath $(objtree)/vmlinux)\""
 endif
+
+ifeq ($(CONFIG_MODVERSIONS),y)
+# filter-out -z noexecstack for head.S
+$(obj)/head.o: KBUILD_LDFLAGS := $(shell echo "$(KBUILD_LDFLAGS)" | sed -e 's/-z\s\+noexecstack//')
+endif
-- 
2.38.1

