Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D6C698DC9
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 08:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjBPH3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 02:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjBPH3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 02:29:03 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3673F392A1;
        Wed, 15 Feb 2023 23:29:01 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2J7YU022256;
        Thu, 16 Feb 2023 05:22:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=eMgu65+45W68Z1hG+lFuRTpW2i3+bXz9sDT/jXWJ5tY=;
 b=EXR1tRntbfvyBIjmoLbkx2v7K4/h+4I0Nu3gdBKBQboy4neyaOUCJlacJzdVSbPjv32d
 81JCygneihR1Ko/606uOmeYANWRc3Ih+9zEdPrSXfE629R4IG7Vr+uEj2u9lLH7Hk8XJ
 gRG23RqkITmrgVJUre1FGZ/XRUQYAh+ikYjJqZ1LLzudNQbsp57RU5aKjJgljSSPBo+t
 t94l8fcvoL7Cht6nWkTePiBDq98V3w6P2sbZrdFxP2qPSTbmIKuK4nsY5iJ3HqcNTo/S
 NK81UQSK5CD1FXw9MBJ8LN7f8Dtm69zDEOpwR/CSoUPwribNAWG4epHVMY7jDH8wKxgR IQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1m12aph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:22:58 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G30k4i015064;
        Thu, 16 Feb 2023 05:22:57 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f84bpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:22:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZWSOgC/Co0tZz4MweoYwZHI7lDmrQm3YTgRrrt0aQLvTWdnJJ6SRFA7rnTM71+C0+D08ysc8JSwG+WhswIjkRRsZFJB/3Esw8UgEvPtvs5lfolUnKSp92jCVbpu45PZ2xq3iQa+DYmrzi3Smfg+hCAAGJgVIH+bTCkJeRNVI8R01nR6E9jZF4PU0/QYwtftCPmlzzcnJfCxT/BCFQ7SHSE9IAgpyVJt7apfJ0Mzp898v3GHdKJqzDLn2uqlyXOhhY4DY8S5BQ5LS9x9VHmnHsaEnBcjdMsMbt/wiZlzgbdP0C36tC1GjtJOW6oajOFo6zLDEUtPDcuov5TNK6gIDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eMgu65+45W68Z1hG+lFuRTpW2i3+bXz9sDT/jXWJ5tY=;
 b=SZjbfNGZSrxoqn0+GPB2ltjsQJG6j1Fm3G9dCaRxonvDXEshE6C0xALbmlx31fx/KXQaEDtBtqbc2ncuUQNPhhPnSnChpSFsioTn1ktZA6UGfeK3Yy9gGzskUloYLChOHLK8V3EHWDS8rgWO/RiUE1vL8SV5bETnB7u5TuC4NcGT+iZofIP19KCq3qBCEDkHL6MRr34kgVOv2mCDP1oPiwqbDQSdjEYr5C8wrGxwuzUFCm7a+y8UwyPCbVQrIzSeHR5duLFo2Zu/Hp7mXoJXekE2mHABSJIjFFr+btQ2qjqkOvb3uGbdx3m1lQQsllpQA/dZs21ZvxsstsoIv3YZHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eMgu65+45W68Z1hG+lFuRTpW2i3+bXz9sDT/jXWJ5tY=;
 b=mWR4qb6hTHw4omryIOaLyVZln/MU+DXht5Ifad0MfZ89k6HQBGW4kiqWhpi+9dRyWl3zgaYfupfI+vciEWese6x7y5XjqvL2Wt/oxhttN052ZwxcQncawNDFrdv3m1gA/VKrhjTbwEkx/wHS3fmF6zqYMGFGF7+kXZ6VYWjKK/I=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MW4PR10MB6631.namprd10.prod.outlook.com (2603:10b6:303:22c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.8; Thu, 16 Feb
 2023 05:22:55 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:22:55 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 20/25] xfs: only relog deferred intent items if free space in the log gets low
Date:   Thu, 16 Feb 2023 10:50:14 +0530
Message-Id: <20230216052019.368896-21-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0092.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::32) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW4PR10MB6631:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e2eb9f8-38c2-41cd-67d1-08db0fdddb99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WEHbkpIBi4fo+9memfhOH+tzuxpzJ3+USyexAMhWVrzAdqtzIGWNC9DRyswj63OEUoG5nuZAXle4iXl8kdSAzYOdctOMNFibpecnhw3A17DNxY/Ay7nIBeTKrcPkzf1krs1vrPlxqzWVFdGNSAjKyBViyIR7j9mTmaBFSyRn/5WTUPfLNnHMeRJkFuwG1WovJnlABNkVW/8nDAEyVNN1dJO2s76rjGKmyv798+XRTTo59sXU4JFfyFJPgdgZG/Uddgt7or2fsZv3cTIBKOr/6uEiyWa8vbtP4W6SLBfYhXKteLUVlIeVAZcS4M18tQ8pkS4nDeYVPpT6riNHoo1bpRInKfVUsI8yzChF0QKbxyuPe9+B98SVq1JCRO5s1Dx0ip+k1waAPFuASrr+cYkb0Db3gPmocKOz/w0OUR+njCYOnoyGQ7Twu6hAJJK4bCP4+OLl4ZnTgl2YB4WsnXOlycj4dVBMzdc0hOZY0HKbD7VshtBQURdZRbV7TPfmX+N+hA2bpyKnZKNJBU61dkEoh7ARFIog2ZYl5tLrox5ckGp9eRpWspMtd4cIU3AqU/dS2wTAXcLt8UNktrLavpEDKPEnCJcuqcCjqO8F7kS30mnrMCbQiXoJj5mB8+aKbvqCxUaDe+09KxIxuaEbnanjlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(396003)(376002)(366004)(136003)(451199018)(26005)(186003)(6666004)(1076003)(478600001)(38100700002)(5660300002)(2616005)(2906002)(6486002)(6506007)(86362001)(36756003)(8936002)(66556008)(83380400001)(6512007)(66476007)(41300700001)(316002)(6916009)(66946007)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S5f5Uf6R67Tc+lSF2js40vdQvkN9SXzjnDCukHN2gMrgrRKIKgCowpOMqcPU?=
 =?us-ascii?Q?EC9+PlxuFg0rUBff/p2Uqlt2+J3NnaOsYuYBaQXR4aBShzowWQGVAx92b/be?=
 =?us-ascii?Q?plFwcjjNo1HVqto1wiwbWYaGHd4QNa9XS21w/94th92wCmq1VIi5mNQwiVFZ?=
 =?us-ascii?Q?ciCdtQU34DgXJhJ4wGUD+qK454yKHXxFggZUHLYeBnIbuv8cNzKGY545bLM4?=
 =?us-ascii?Q?A5W0tfz+4BeAol6zwjZjDwA5flGUDVIhKa8pJJGhhmipD2A6KpmlMfnPUWn9?=
 =?us-ascii?Q?zP1APkiv+Mdt7LEAmE5snjf5gGcupN0HqQ3h7I4H+wxhcTxZNkrhEfFWHUX2?=
 =?us-ascii?Q?dxbiT2RXo5FGZtaPT6C8iUkPh62pDbNnMN21LBfKmOkr87K8CddWHT6c4Gcr?=
 =?us-ascii?Q?xGAmDHSRVJb01aAGgpTME8O+9uovrSo4K5wXPkVt8isgMKVPAV7akbuiMQ6X?=
 =?us-ascii?Q?SrtCPgrR72rhvQpdsCMteRaxayxeIVbcmzrZ8z7qASW69SoUiUmEbPO5424P?=
 =?us-ascii?Q?LypUUafuK6maD7yiiza4PVS0UecSKk3/b1AnG4mGA/VkVtHri5ZSmbLXj5QO?=
 =?us-ascii?Q?GBa8zP18BzNhgJZ9UI//0kS020LYzcXkHEqMcYL9q5Uvw75O20hILPfAe0GT?=
 =?us-ascii?Q?co6IFFLfT+DBGMdmfQ9BLQN/1VRW3PkV58FScct3XDg3ufJ/dQOX3rbf2IXv?=
 =?us-ascii?Q?8MAw0atl0zpiaWgW8a8WDxkl/570LxeBdq9s3IzxhjRp9ayo3Zlah4WHWYD+?=
 =?us-ascii?Q?7qLuV0lJ9A4Zjce7WDOvhvbopx0d68b012cCVc8wVfAYfznePAsSWKomMzeP?=
 =?us-ascii?Q?vopYdY53GAXvXrXDF+Uosan3QLGFQLtcfeLAi47QjPjvB5X0wuy/FNFxnV9N?=
 =?us-ascii?Q?gI6H6xiyNwJQF+y2OVT80fOpLzfdxtrg3P13Svof1W5100xg03TN6jFAq2Ci?=
 =?us-ascii?Q?hWrB1+RxkRuVGuyn6rXabH++rdgLgAk2Wa50Vd/pDA/FvfcSC2adzZpS0J8/?=
 =?us-ascii?Q?3pw4xub9ccwK8udjkz0Au+6258n/UPKRHO5MvN+fKqjsLnlOTdbhnGKzdq4y?=
 =?us-ascii?Q?2BwnKGxXAyFOPxsslpV0inedQIEFEp+fhpyOqM3ZAfO5tFSpZdJlX2QsqBMf?=
 =?us-ascii?Q?pIu9umiZ/AeULGz5FoHuTogP1Dt90F7S2rcRWqiNgX/MRgmDTdbg5KzkN4mv?=
 =?us-ascii?Q?7cHtvIriZvxLn9xpNhQi5OKLZaj2A0W/TSsu1C/2OU2PODZv3DSe0PrevKtL?=
 =?us-ascii?Q?n6PExpwQAJXAyQXMfZ1UQepeCZlyewAdNPcNY/GD1YYe1FvdljpY9G5nM1vH?=
 =?us-ascii?Q?q7OnCqx04RLLgM8Ol6VzTm5z0vaUyVg6OT5pyO75x8Ewl4MwzZQtDYiiycCh?=
 =?us-ascii?Q?F2WfayxHrzAZkOmQltRzSpcFFnkkAyOxjAb6ulCJAu+4jF780Z6xUlywMgCC?=
 =?us-ascii?Q?smCy8xevoYODGg9UAmxaR5kuHPf+uHZCqu4CVat+JrE7RJrdcwJSFaUy9t4L?=
 =?us-ascii?Q?1rEda/cequ2DcUEsBRWXjbuIREKQnMq8yoCNna4pJC22++PLbNmZJEctbxYf?=
 =?us-ascii?Q?QetuBQQQYnjmTPCfpO6SgnuaAPDEUAc9mdHt7BIwou/j5zJclYU9JujSYlr8?=
 =?us-ascii?Q?aw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: hW7mWeIhf8deEum8qSmtga60KZTSHlInmyPLe1k2I4NmYFTNZehMFU5oTwGIXBL90npTjDUEkqbb6w3UbbXrmZJe7ikblo6JzWq6GbfBjKzw9At/qki+50bzzC3oJXqlOiNF6CCUwjQaWqCZhE4OH+YdZsS+JPOW68YIryHN9ssGEoXVIaDT7iczejoz4hy1MtZ4EEOXiU7VLOBB1OgNNqSx+/H8mydsYnZjXcE8NKYozRtucldolx84y4GF6jGLuyDhPQE4T/rLbBDtq8MwuE1Kso6D1Ju9FzB8Xp4gQPpabbIWLJF/ywHel9J0cb/jWC9hhn5tDn2VaMhXKiefmBfXRlcv7zM6e2sgZstVcrVFpaF3jYxvNjnVcRjVS45i04aklQES+D/s+eZSyh0nMyTtQLSCZSdE4FZVC5NQ9ethXH3609YR+VodkLCO/9FD4rf6tLM2VgxEUwCfeTMc2RANm9qtFPf4YYJwCNbwkOlq1C5osPxJZI1ghS60rPTsvVW3NFcXDNWooPE8MWDT4yU+d14T+JQ907RI+AjDyp31GP7dU6uLcyHhbZPtw+w8IHHJzR9zookCTOnwqns82ltmJGi5QIOS9JlL9I5mXewxJ+Hg02MoLVgxqp5QgoFbr80DnKu8P8Nq3Jh3QYoV164ONH0kjG2RgvXQO/N4BJcjTiFY4SCuvp0BPjut/T6hhc8mAGHOH2oYpwVdw2hUE0q1nHnGBH8Ay5OGes8jqvfEo4+nAlF8NPzvS4RggoSAFbvJ8Qt/+LEAmHQ8iKhqo0DHgbdSjxXYLV6qHuP39no1vYc9JpqIG7RTodcl9sNW/0fgZWP7nc6WJmtA+qjZrfHFb/Ecdlb/1Gj/RhlCZRqaXEOUfP94hUG2LMRDCJSj
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e2eb9f8-38c2-41cd-67d1-08db0fdddb99
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:22:55.1697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e31vAW9XSppGKHhi7AZa2oMQJw5JIelEARGIQH8LQfFAIOudce7R9mwr80mqRguVT5ggjqJsVrFmrmMqVojBOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6631
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302160044
X-Proofpoint-GUID: MTF8bBQAI4AvGvcyLdJx6-VUxidfmX7H
X-Proofpoint-ORIG-GUID: MTF8bBQAI4AvGvcyLdJx6-VUxidfmX7H
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

commit 74f4d6a1e065c92428c5b588099e307a582d79d9 upstream.

Now that we have the ability to ask the log how far the tail needs to be
pushed to maintain its free space targets, augment the decision to relog
an intent item so that we only do it if the log has hit the 75% full
threshold.  There's no point in relogging an intent into the same
checkpoint, and there's no need to relog if there's plenty of free space
in the log.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index b0b382323413..3a78a189ea01 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -372,7 +372,10 @@ xfs_defer_relog(
 	struct xfs_trans		**tpp,
 	struct list_head		*dfops)
 {
+	struct xlog			*log = (*tpp)->t_mountp->m_log;
 	struct xfs_defer_pending	*dfp;
+	xfs_lsn_t			threshold_lsn = NULLCOMMITLSN;
+
 
 	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
 
@@ -388,6 +391,19 @@ xfs_defer_relog(
 		    xfs_log_item_in_current_chkpt(dfp->dfp_intent))
 			continue;
 
+		/*
+		 * Figure out where we need the tail to be in order to maintain
+		 * the minimum required free space in the log.  Only sample
+		 * the log threshold once per call.
+		 */
+		if (threshold_lsn == NULLCOMMITLSN) {
+			threshold_lsn = xlog_grant_push_threshold(log, 0);
+			if (threshold_lsn == NULLCOMMITLSN)
+				break;
+		}
+		if (XFS_LSN_CMP(dfp->dfp_intent->li_lsn, threshold_lsn) >= 0)
+			continue;
+
 		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
 		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
 		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
-- 
2.35.1

