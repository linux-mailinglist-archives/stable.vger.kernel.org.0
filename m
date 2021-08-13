Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18213EB50A
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 14:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240145AbhHMMNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 08:13:13 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:8614 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234931AbhHMMNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 08:13:13 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17DC6AdD020282;
        Fri, 13 Aug 2021 12:12:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=BRsUMl67kfVfSq0z8anlnXmlBDD1vce1X7Qj9f/nEdM=;
 b=A8ZvtuthpslV+yrFs1SYBjGbkTO8yt2AmLdIV6Geu5X8iCftPlKTn4sl4ztyeXje9iOK
 IyRT4TnmkBx+q8k0NmlAfD2nz491SOFNfg2yjwLD5ELJd+xRlVRtk6IAWA+xoz6oTZ/o
 w4vnF2Q69eR+dSCpVSO+FC6cJ+rIeRCRGgXXqOOzAiKiA4G9vdv27LIkjfImzCqKbgsp
 eNQdPqY1RG6oFUm26jFDy4ul8FoVJqJnA/TeirlsclvYZHW2OVIlfUVAyykp794IuGZQ
 sd+UHy2LGYyYFVqCVm94oXfWFMvq1JPDuqBJXcCs9Ro74TAWVeCmXH2yN6GKYsNpDCU5 IQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=BRsUMl67kfVfSq0z8anlnXmlBDD1vce1X7Qj9f/nEdM=;
 b=dqYyDKzp1yn27N4oFzclO1Ho/tZiH9JooYnUvOFV/lOL05TlnONi6KvXXoOFtkXqaGHp
 sjqhInuRsWYitOKcLYWAxiOAXrbFbFVXIUwHAGx7JYI5BY8sUzCGzaqm6dPKcnTNyqbD
 Q5VyALXjvdj/PsBCk+m5JRqNRD3YJpJN4YeveVKiQLzzUaFnw9zKjldN3dUHO0MgU5dR
 WnJQLRi0h0cxI3aPr6mRZNAB+0Ym6o7iecRq4WpCJZtFTKS8ok5tCSooHcBswicyxdaF
 gG+v4TTXOiXuOlJjE4elbnYAmeBP8mBiUsqZU5s5qQVltPTGaf72vhsGEKyK92Yqkmcb 4A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ad2ajjpr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 12:12:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17DCAZNh038661;
        Fri, 13 Aug 2021 12:12:42 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 3accrdx851-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 12:12:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCK1ACVbpOaRoumf7DaCvxSjFjXdPo6CBXIDJViVUKWdhEr6LJ86VdJRqVZ1jIO1MBOtR8lylq4ffCh+Do/KM7P3uKNtbchHAnDaFkAjO24CCFhNNBETAyg3+F7h82ygaCspon3zzYLRPL/5s8UNGAHXCUqUrnz9AhQ3xnIs2CySKvzhxmtCApb03JLwKUpdhEixLDypJn7vMIVnBB5vZ96b2kWdITeU/J5XETjId6tQM6+LhCiZQCZoLdDVQgy1fQEeRGwTkkWFo4attTSS1D89JY3aDFngkDpc2aSsAdxkpt2syU/O6VHvmu7MoWV5rHW+WSHuFCEAIgd37loA/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRsUMl67kfVfSq0z8anlnXmlBDD1vce1X7Qj9f/nEdM=;
 b=UNr7KeCFUgLEFoF87nOwk3A3Vu4cNQelyIC4bcMhR6h3keGs4iwOCFPJU49KHjd4EFuyufmbFPG+QdLVSCLa+XNnvZwEahKE89TfCXfWFdtd+SMgdOU+3i4JtM0ELP0aONU3UxoRWsY2/3ZzCaPymXt76Ivuh9NHsP3UiBogUIF2mBDMzIQAIF1nLOjEJ0wcwo4/OH+u6Wc6YXpMbn964ydvxVJirwJhNUOI72qcDIoBjMgHZtknpsTAnWoalHWrwCW8Jur8MKbQp+l+VpI3ASMqtux6msCPGEqbysczgMiqOS7dBpv1Q7k0DJ18KViqokUk5cPy4y1AD+y35ao/Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BRsUMl67kfVfSq0z8anlnXmlBDD1vce1X7Qj9f/nEdM=;
 b=s7Fzy9DMBIAkA0KigvAVh01vurQOvDXY/lJBhe/fesyCycdwZWMvLU59XNVkkX9g8VNykObP/hVpRwEGbk/9aU09x4T5J2ms0GwotDm3ceBR75bXxlvP01O9CGa+CziE+KIRgt7TT8/44FAkFcyXZ9mg4q9uDnIoJjSr20oZGxc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by MN2PR10MB3789.namprd10.prod.outlook.com (2603:10b6:208:181::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Fri, 13 Aug
 2021 12:12:40 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::b813:4805:31e:d36a%5]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 12:12:40 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, fdmanana@suse.com,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH stable-5.4.y 0/3] btrfs: backport hang fixes due to commit c53e9653605d
Date:   Fri, 13 Aug 2021 20:12:22 +0800
Message-Id: <cover.1628854236.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0155.apcprd04.prod.outlook.com (2603:1096:4::17)
 To MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (39.109.186.25) by SG2PR04CA0155.apcprd04.prod.outlook.com (2603:1096:4::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17 via Frontend Transport; Fri, 13 Aug 2021 12:12:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c615999d-07b8-40fd-acb2-08d95e53a583
X-MS-TrafficTypeDiagnostic: MN2PR10MB3789:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB3789FA91AD41937DD8810781E5FA9@MN2PR10MB3789.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oygj/0fSVkD7M69p4XHlwbqB3jBWYa5pApj48m4+CcPp/o0d5I6fLVVrfdGSnuA5rEIcMiKftzhP60kVnTQTTy5s30EULeoMtl4xxKFn4n8ESXg5SbMYZanJ/RdAFSn6WsKVEfa6mGJ9LvtXDb5OGrrsV5KRxA2XsnqdL0Q+o5Mi5hRJXqE/MmJCuf4kpzsEzMncfVNVi7vqtUaIp+FOODOUo3bpS2MphHREymaiQFp1jmmo0GVEk3WgGcMbBySOHlQS6pTAD8N6u+wEp8El4Fp3xpuZAZJXLYqiyWXkyWLOfhcK8vt9DlCNAAmlJ9LhhnxyJRgx1ePTKZXdNCiGxRBSKalZBijz5CM+F+iKP4h332iePfFxv1aDnxPwphGRlwKRHxLTjkRumdf4gNCxa5QHoYxJ7wqhQmXkS+SD9DXdVvJqkE8plYPSpBfvdCQPQyih8nV5KOm3DKi5K1AP1Ao9piUT58QkPdmY8uQ5DaJQ3+RCwHw6kirvPgv4d/2o4eavVjoB0MUZ064PmFoYtdBxTa8o8L9xhOf8Zww9zL6pWUGUTBPreLe/Y50KLI2NTeaccaPUepM5Zwuih+9X7HGYLYDP9ljCsMNEJ6O+RN8eW+5OLGsTcUdLxGUxDacFZYuJkyUKFeVyHgrKoR/qlzl39Irbphf81CDfc82U7LrJcDAwVya9WOxUZzaVnmRD2YCE5URbGHViquw7Cv5McQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(366004)(376002)(39860400002)(26005)(44832011)(5660300002)(52116002)(107886003)(316002)(6506007)(83380400001)(36756003)(956004)(6666004)(8936002)(4326008)(2616005)(6512007)(38350700002)(38100700002)(86362001)(8676002)(66476007)(66556008)(66946007)(2906002)(6486002)(186003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MN72z8agpwHJ22Re7TJud2rqQOOE+GSsoBCl2S4/m4NOo9+WgwBmkHLC8TgA?=
 =?us-ascii?Q?I/Kc+ShqffoORaUZhn1z3Vr/cP/QiBQBRR1KALWX+eryz0NMLZ5cbkEBXBK1?=
 =?us-ascii?Q?hTcLZgjLK3xJg9NfhVLTiIvlV4n0tgTPjAjjrqzT3fAGR6Fvjz2R259Ecv1r?=
 =?us-ascii?Q?1lS0zyJSmfWItnGxkkQiklHrx5itWLl+iN3feVAzI6+QoWes6UKNrb0uzzyW?=
 =?us-ascii?Q?UYr1a0EIzJGoa155Vd14EFaSKIEg74v/ZioqJDfBx4BquKLmYkQClsPZvFuK?=
 =?us-ascii?Q?mMK3WzrXp/B03rajm9Atg8sGvEIU1hRDF+G4DHTDTum4GZgsdVI7xVM8q7I7?=
 =?us-ascii?Q?dO6C2z5iEh3ggDNBFi+CVb0vxvZj6k8LOPN+IJqPVy55E06pUaggTl+SNeQD?=
 =?us-ascii?Q?/Wi9By+6klcY7U8+uYODdJFPCGjxUWJ9nr7xb84kliCHd5vy+/NPX2WU7Nhe?=
 =?us-ascii?Q?/VWuMcZyzcknNqEGKIFtNrEBnuk06DS3BbgM4d1H7k0XdRAG3yxytyhiH6oN?=
 =?us-ascii?Q?PbE0ZfffcEuzh8kBFohPSTYgln3tshtJItTzT8Ri6JxCZgbeWbnAezYFmqQ7?=
 =?us-ascii?Q?M14yQn+D73Hb+BX+ovgRn0o5TClsYRKPNlfS3PIgnkSlvRV6VBHF2QA5RBhO?=
 =?us-ascii?Q?Slv0GjZD4tKz6yBBUZiST+t4YFJdb6+38juQ1GxgQAJkmZR0wVY3muPwjJpK?=
 =?us-ascii?Q?5YY3dz4DZV8mrhOeIU9q/plMzoWG8gnF/6GZl0HMAY0cWeWdqw5tH0d/Eftt?=
 =?us-ascii?Q?9UjZkmBMEaV5qcp0ZIwdrtLrKZ5EU6kfwl7SJrmy1fZt/h7EsSfCm3z0uMmh?=
 =?us-ascii?Q?jKrtxtI2HREj1VV05pJtmYv032BR0wrA3ZL4nSOSVnpbcZ6No5tYUhH9uelL?=
 =?us-ascii?Q?Q9y4QVIc1G/TCOCdtH3b+z7CwgYoKOM+kcWqYPowVUEhbaFKZQk8JafkoRfF?=
 =?us-ascii?Q?GjVStIn/uQxAqZljF1OB30z4KhCKzhTdy0Ydlw/s0jBzTyORC6Or5Yj85r7z?=
 =?us-ascii?Q?0wYCFXEdgQkzbJNhNcUKZGqsVtQwwyDcsyhian/udgA6hyn2Ld5QVPbuo7da?=
 =?us-ascii?Q?KSpJMfM8O/6rFTUBL8ZdMCfbKEYaDW60hkZl0BbDj4L+VvU3Dwb3/9gkbGSj?=
 =?us-ascii?Q?5PalfQY1zVaY61OqX5SO24cj4xpTCpC+QM7FeFnHc6WDQ+QDeiNLzE/YhrD5?=
 =?us-ascii?Q?7+KkK2w+qldZ+9PQvU98VD7NiirCMrTKYUNtSKF0gqz2qSR8zID9nNMQR50n?=
 =?us-ascii?Q?+AXWdi9X0bKZAv3e7cW82t2Lvff/1a7LealJ3ytFTS5MOSaG3ChlfdyMD5VX?=
 =?us-ascii?Q?1qPImfzLwfUM9fqnIyD4XhcS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c615999d-07b8-40fd-acb2-08d95e53a583
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2021 12:12:40.5436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i29UZry9DkNjSEm1yKtzyHkBpmkHGpsgs4eASsMFixmkHl9wI7Z5/IGE+zVrUg9us/0V+JVlyh8GGE8bXUa2/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3789
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10074 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108130074
X-Proofpoint-ORIG-GUID: isGxiwKdiNsDX1UhrTwCZCA_p51_7dGW
X-Proofpoint-GUID: isGxiwKdiNsDX1UhrTwCZCA_p51_7dGW
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Further to the commit c53e9653605d (btrfs: qgroup: try to flush qgroup 
space when we get -EDQUOT) there are three fixes as below.

6f23277a49e6 btrfs: qgroup: don't commit transaction when we already hold the handle
4d14c5cde5c2 btrfs: don't flush from btrfs_delayed_inode_reserve_metadata
f9baa501b4fd btrfs: fix deadlock when cloning inline extents and using qgroups

Commits 6f23277a49e6 and 4d14c5cde5c2 above are straightforward and are
part of this series.

However, commit f9baa501b4fd above is more complicated to backport.
Furthermore, the bug mentioned in the commit f9baa501b4fd might not
trigger on 5.4.y as its related commit 05a5a7621ce66c ("Btrfs: implement
full reflink support for inline extents") is not backported to 5.4.y.

Nikolay Borisov (2):
  btrfs: export and rename qgroup_reserve_meta
  btrfs: don't flush from btrfs_delayed_inode_reserve_metadata

Qu Wenruo (1):
  btrfs: qgroup: don't commit transaction when we already hold the
    handle

 fs/btrfs/delayed-inode.c |  3 ++-
 fs/btrfs/inode.c         |  2 +-
 fs/btrfs/qgroup.c        | 28 +++++++++++++++++++++++-----
 fs/btrfs/qgroup.h        |  3 ++-
 4 files changed, 28 insertions(+), 8 deletions(-)

-- 
2.31.1

