Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E708A61EA0A
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 05:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiKGEEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Nov 2022 23:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiKGEEH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Nov 2022 23:04:07 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6E69FDD;
        Sun,  6 Nov 2022 20:04:06 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A6M2wIY011512;
        Mon, 7 Nov 2022 04:04:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=FBuMlmG8Vrbp6z277EX7IEcyIeJiUVqHwxMKanM35lI=;
 b=OJVP3XmYXTYQyPU4hcJM9o3eIOtJeraTKXffzqqsO6Nxe3eoDm/xgUK/cE9ntWahwyG+
 //YA1bagOzigJ6ngQ319vDPIhMxAzONXG7R9sK8uOmx+nbHxB8s9q0DpHxDnhr+E2TFx
 0R/5b59OEqPdcXU3/fSIpuM+WCBLjOOX0sfI5CnAoTVPeSaP/+hKkOHLtrB9+P/Fjlcc
 6RqPMhFT6IXfaJfYJ9tQKZGymlzExyVy1X0wnb/GsZZgnuS/GVB+lWxYNXtjtUxuZxwc
 /qzNnItZQFC/o3U3a2Be95Z9kFd+QoshB8gccYZUgPYvte2Xq2OpkiDBgopsr2x5yN9N Wg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngkw2g36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 04:04:03 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A743xlg022925;
        Mon, 7 Nov 2022 04:04:02 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcthv082-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 04:04:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RQcZuain76tgqU3WrPMrucaExKbaehR1NgulBRxXyoamUzw3TWcND6l1nR1bWNGHpY13XgBpMfNzuWrQ0P+S0ePNA4yMe53FdnJzNDWs+0SEVe1Hk1CFm0X3Psd0Yuv/DYK54eUDxxnPA1hxSlEwWxhF+ce9q9DSfAJSJP5y/eqmWoAXdDQ6c685/VGlAWj793IGK9DrAQy3adc2NFv4ykYZYjQTDh9ofeVmk5neqLwRErdMJfU6uCMw+e6ZFLE2QTql+4V+aguBrzGL0U+DKUSIgJtmY481uPvOxczIoCFxrMY/XdROzDZk2w2MEbz/4ehPzto4+Wp/jjr6Yk/CXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FBuMlmG8Vrbp6z277EX7IEcyIeJiUVqHwxMKanM35lI=;
 b=dtqwJIT6GJgVfOrVyraDZd/wnUT3Mr0vfLS1+ELIOldipMy6kwqa3KVJOfSmKUtQYa/KH8r53/YfCkeFVFqAvMUKoKH17QK2/hMCapgUjJJZIginZJ3u4qcPa6l5MuJOGdnY330NTrYO1BYGf2oD11ZinSikNhNOyUkqwVg9i9Qrgsbu1Udj2f/tQiYALfGU8UE1bRL4aTBW+5XmXxSsTpcf45N8d6MikmcSMU/rAVcUpqrQW67gbXET4prt50dzM8JXFdICuCqxbxjB7+mkoj157tA3MuVSLvmXPql6BRCLFlnYktK5QdEnEBLWMHcYpqIGogRJPZv4egRNkY0jIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FBuMlmG8Vrbp6z277EX7IEcyIeJiUVqHwxMKanM35lI=;
 b=bqYHYVn2QE8Fs6tpXh+sY7C41uh3Qmao9aaKAfLUUOE/JhFt4QzOD9cUw1LB1VnlLW2kRPZ68GqQNR3r8qznw4WsNzCUfLWPsk7Cby4mqWiMCy/9JTmmPEoiH4nvlhundFu9ejo/eNZXAqFNnVRaRNIDl3u+czNcz8yUPkrb4yg=
Received: from PH0PR10MB5872.namprd10.prod.outlook.com (2603:10b6:510:146::15)
 by BN0PR10MB5077.namprd10.prod.outlook.com (2603:10b6:408:12e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 04:04:00 +0000
Received: from PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b]) by PH0PR10MB5872.namprd10.prod.outlook.com
 ([fe80::3523:c039:eec9:c78b%4]) with mapi id 15.20.5791.025; Mon, 7 Nov 2022
 04:04:00 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 4/6] xfs: group quota should return EDQUOT when prj quota enabled
Date:   Mon,  7 Nov 2022 09:33:25 +0530
Message-Id: <20221107040327.132719-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221107040327.132719-1-chandan.babu@oracle.com>
References: <20221107040327.132719-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0029.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::20) To PH0PR10MB5872.namprd10.prod.outlook.com
 (2603:10b6:510:146::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5872:EE_|BN0PR10MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b9b6bc4-9452-4c90-f469-08dac075199f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KJl5NU9UAqSnsU+T07nRBLezPw3rSsm1Ii7dEJj8Leo24e7H+VRHfdPStOUBlG3GEOXAg9dHm2XUsqMF38bZbwHQ8J5Fwuv/+Apbd68ixXLZ+LdnhdeKJkvqpr5MJYwYz3E3jzWwDC5+qiBpW0qD9q6qv039zRoLhA5YtMRnrzTbFfFGPcduiqTiN0H+Epf0vnN3v0Z+M3ioBECZbeCtumjKPgsw/iSddkBnNNXJSpE7xlvuEwVk/sHdbVwuu8WUKxXaIRlLskuABqutGunhOvV/2QdWCt/qqZfJCzGVQeYjCzv4twKtLhTDLFH4/6KsMtRewgJc/hwTm6c6LVSSUyE9Kn2zr2iKabuO1YTHjokmKd+xShKOLQUe8vC6OJUnynmUNjdy77Tx+E+fD6lZtSCJkfOACAthGr4Rxv34kRIvnZT+i6EKgdsE44tQ6gCZ2OzUPj8QYCN/ysgWFrWC/Euvig1+tcO/eTigE22n2ORSu/GzJbEk3Jt4+VUt54q6KohP6VGkl8ZIw8qHNdef5KL8ZaYFmH0q31mPVBUWXwKF9e29yV0nzgfxt7yEGKFOhWc967DzY5yRk/O6zHsEyYkXo8HfNPk6EzuP/i6x53XO6yVW5U0HqcOBuZZ8Djta4CYBV0kfhAt2lxTqLHUri35O4q0RWueCA2481eeRZ+49D6WdEBcDhr9o4oC5CU9B0Mzv7KdAuPLmrvgxFYF0tQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5872.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(346002)(376002)(39860400002)(396003)(451199015)(1076003)(186003)(6512007)(26005)(6666004)(6506007)(2616005)(83380400001)(15650500001)(2906002)(478600001)(6916009)(6486002)(38100700002)(5660300002)(41300700001)(8936002)(316002)(8676002)(66476007)(66556008)(4326008)(66946007)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4mqAC60WgvrBhuF8hx5u917w11qQ8HSgl4YlpPgdZ7orK0XslWKOGEcHIGcU?=
 =?us-ascii?Q?xgQXQ5XJK9sFg0FgPvg1grPqrz0ptUD21k1Uxwp0/HHCqZ2OZaioKMo7nHNV?=
 =?us-ascii?Q?iPjxL0tUOX5FCPorqzm5at6n3acKANuTuiX3nnsvTOxRSgMioLrP1yFdqsjJ?=
 =?us-ascii?Q?GT4UcMqjm+Oeluuyg3L3zfC+75VuxgaLeAwnmAt+qfZGSIHs3hEX+gMBgjKf?=
 =?us-ascii?Q?WKUt4pEt1qQ53wVTW4nAfNS0YWOBrx1hjDIJ+vq1D9h8buIdyZiB2m3cNQsE?=
 =?us-ascii?Q?Sa1/68QIxOnaKIeVuzmgRyMMcKS4GCWobTodv25JD2iLnYqiirKExxtDTGe/?=
 =?us-ascii?Q?mOJAYj1kxloFr5hjOx7fn1q6OITDxvWzQ2j/W/KRnUHsf7mUph2I0QEEua4b?=
 =?us-ascii?Q?059nUPvevvVGybF09S8VkhpabEY44cQ+cgErAx6bEZ2Z57vhDQk4DRhfMNA8?=
 =?us-ascii?Q?38Xos2irxiNKakD6zx3MJg5PWMj9lZZL1DyyOYDgczCgQqOFJNnxYY6JADKY?=
 =?us-ascii?Q?TUfc7rbjTjblaRejfS9CrVhrmiyQFgeRYydwu3/XaX7Duid9tO+F2zJp4Woe?=
 =?us-ascii?Q?zhkNfXWWCdDwQT7S6sEFJLOeaWihHGdEeqtzLDLL15sdz9xx5FCVbNl4saGD?=
 =?us-ascii?Q?Dmux0Pyp9ZN4p6+k+OaEdZ1xI+8NXqiS7GWbNn8d5OyrVcRMlPvLCfQ1AGb2?=
 =?us-ascii?Q?nQmdCDFvJSM/vBCmfBG60rkEzWgfyPe2s4djyqC8x64ClH4MwoCPL8E5tDwo?=
 =?us-ascii?Q?ao14KALlX2akU3FUhN1j7HVH8UvIlyDQpgJWgJJzmKwlYI8pYwliCWLLHI5Y?=
 =?us-ascii?Q?SPnPMj642GhRTvsCCUi/v+H5nPmtm53qmLH/btvUoOi+dYQDGT2v6NI7flpM?=
 =?us-ascii?Q?L6790ZC6ECU0tQGvV+ENnFiKjY0U8sJI9nuudso/Qgvd/mDU2oc7o1IxRq7l?=
 =?us-ascii?Q?9vj/p+1QZUEPHsqcaSKCvYM/EFU1/ZmOlg+fdsjDdFPBIvhVh/WchTIoAHuW?=
 =?us-ascii?Q?2/2eTg7I0H4fXoQZwmJz0eQv6OYhf4gR/1kHLPcEz9dIArSfHGzxk3s/R8op?=
 =?us-ascii?Q?VsQV8ZKmx2wA98zZQdaOnp7KzYHwh89Ao/AOQW4BEBC3h00nGYGefhhk00cQ?=
 =?us-ascii?Q?xGSe+vSyrYND82gVTcUqFbHLzZuYrXsCcKfjqRiGwl/WGcJ7w8qH6uQeGq0G?=
 =?us-ascii?Q?fPg+3KyaKE6ExERHShxcvKSQAXJuqvVH9nZdZpHQp0PCPGsmVZeQ/Knc/X6s?=
 =?us-ascii?Q?Kc3hRE0n1i4V5BEBerlHCS0jIHQhpLtlrX6Fn9RPYn765n8tsCH+LAIqGrXS?=
 =?us-ascii?Q?9beyVPOZ+sDYgvlpcexAfP5RULSAsQqjirnJTAlwvCqspRGcsLayvfn+NRBL?=
 =?us-ascii?Q?0FSkSVdhFg8k7Oj4CiRnw9qWTl6qBNRCjh1ojsukZU7GCU5b4ZbQIFSlFj+r?=
 =?us-ascii?Q?B9dItQ25iBEgt8JaO5qRsNhJ+kno9KUG4bVyiGHyGmWKv5Qf29PCspXBTlLw?=
 =?us-ascii?Q?8fTanAaueVqw14spn1TDSL9A2fHFNfvu6xNJfFMXKhWU9gNmEKQJuUXFz7k0?=
 =?us-ascii?Q?O6URpPEaiDJD5Apv6WdE086owHXHMazQLd03jY14?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b9b6bc4-9452-4c90-f469-08dac075199f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5872.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 04:04:00.2778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +kkCHMFQfxmrxucEdEgbBDnNILg7WHpZck7nReivU51S/kOLbhKizHDH5/3qyufiZ9y6swuJWTLvx7HiX+TtcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-06_16,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070032
X-Proofpoint-GUID: EVjqXYFbse8E7iAEV7NmBU1GVfPkmx3R
X-Proofpoint-ORIG-GUID: EVjqXYFbse8E7iAEV7NmBU1GVfPkmx3R
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

commit c8d329f311c4d3d8f8e6dc5897ec235e37f48ae8 upstream.

Long ago, group & project quota were mutually exclusive, and so
when we turned on XFS_QMOPT_ENOSPC ("return ENOSPC if project quota
is exceeded") when project quota was enabled, we only needed to
disable it again for user quota.

When group & project quota got separated, this got missed, and as a
result if project quota is enabled and group quota is exceeded, the
error code returned is incorrectly returned as ENOSPC not EDQUOT.

Fix this by stripping XFS_QMOPT_ENOSPC out of flags for group
quota when we try to reserve the space.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_trans_dquot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
index 2a85c393cb71..c1238a2dbd6a 100644
--- a/fs/xfs/xfs_trans_dquot.c
+++ b/fs/xfs/xfs_trans_dquot.c
@@ -756,7 +756,8 @@ xfs_trans_reserve_quota_bydquots(
 	}
 
 	if (gdqp) {
-		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos, flags);
+		error = xfs_trans_dqresv(tp, mp, gdqp, nblks, ninos,
+					(flags & ~XFS_QMOPT_ENOSPC));
 		if (error)
 			goto unwind_usr;
 	}
-- 
2.35.1

