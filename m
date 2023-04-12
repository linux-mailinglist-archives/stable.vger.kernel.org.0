Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD386DEA7D
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjDLE3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDLE31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:29:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF5CE66;
        Tue, 11 Apr 2023 21:29:26 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLSLUD023156;
        Wed, 12 Apr 2023 04:29:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=mw4GMOKoYHsBv/z3HF1GmgoCc/o0/Poy266MLlJc8iw=;
 b=Ne3f40k4N4/eQcjHdTXg/+wT68cS3qu+CrehFQMY0vthUiwIOxFazkEX3yFepBgZ30ne
 1dcyMZYFJIJ2fzYa/zwAPDylDWWnlDZLw/h4s2lVHwS1E+qUtWUJGFX3FAr1/u7YHyxK
 YKhh/ec/NcowxNKczkS4vbWGZk4E7LhVRchpnu5MUcQTVBMIDwIFqWyg5X7OWQY9ydli
 22U9rJ4Sf1o2CLp7al3t01EFuoN77iHZoZFxZ1HKPH2X2SdDG//0RO2uEb1UcSHeZt4U
 5tIEZdhT/AyYEzpOyohm4yjbozQuG6umhCu5tYAjmD4on59GsyqqdneEhaaaUNfcfb0Y 3g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0eq72bh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:29:22 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C2R7uB030958;
        Wed, 12 Apr 2023 04:29:21 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puwbp83x3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:29:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZGRQpxPOaia82JX3WRBonT9DM0h6ALCyuCHP/BPIO4HTlwERgNGmaNwwSaLX9FT6RNFZ/OnePZGFlKCfatSneZGm+DBa9GiyznPXSJoMxm4Ma/wbd4fIhJZv13tut/C3My4cEeJyq360Y6/3TU3aNakpizd5+fKqWD3ECdjXXtMnrt3RZjUmFmd0jisbTpnLvPTusCDIiXBlZD6h2ILlK4JOzeZu2Ol5k2MsvZeaGX8O2E8/0jQKbaVRcTAUOdjZB9upiAdnrRebAkHg/tYR3Q0vQlA3FHRsDPfnQG8rBpWQ8TN8clNO3iP/RXX8XluO/vDOIOBSOWEvNTfwKUIjWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mw4GMOKoYHsBv/z3HF1GmgoCc/o0/Poy266MLlJc8iw=;
 b=HHhwfzFwXonxVtvkOV/KZyUH1nIilmDcd0Dg1gNcCZP/2shmz6djxCJvs44JZBRIWDDVF4G4qdH4eMC5FfQbEVHgFxOKCA/HlDNaaX5x0YvkxvGHe+PUF3aEHCHsAzW0J/jGZxLxOvWZyZ9VgCiAF79wjFNKuI7Wo6SmysjBzK+b6X/Uyp/NqgsRs9lFEg2GlaXBtYZQlMCqMEE158uXuJnYdNYGIzrjxfmGKnI/pwa1QBZp9e53xmlMElf7Ir/bph0S+g0EUmG5iZwAX4eyEnOej0LE4qkjw6WkpF0R3S8Bjl1E6+h2dDUMunTB2uLPDCMiz7pm4sXKyREwWx7O/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mw4GMOKoYHsBv/z3HF1GmgoCc/o0/Poy266MLlJc8iw=;
 b=pt/tTkBiyTvzn5izkefDepvPXmuzAurgc2ihkBq9JN26fRVlWPGiRL9be0TQf2lB6NcyoKDgLwxzTVN/mTUul9VNxxos1E8XzCod5PSJQ7AE2kP9Gk1fRuGRFG9Ir8eL0ly25mgLRMDsAKu3Ps1Pgeo/POo869uA12uUaD5u7k4=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by SJ0PR10MB4559.namprd10.prod.outlook.com (2603:10b6:a03:2d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 04:29:19 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 04:29:19 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 16/17] xfs: don't reuse busy extents on extent trim
Date:   Wed, 12 Apr 2023 09:56:23 +0530
Message-Id: <20230412042624.600511-17-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230412042624.600511-1-chandan.babu@oracle.com>
References: <20230412042624.600511-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP301CA0004.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:400:386::12) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|SJ0PR10MB4559:EE_
X-MS-Office365-Filtering-Correlation-Id: 88f8d41c-757e-4dbc-1e87-08db3b0e7b72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Giwd4JC0FUZp69d1r6MpGtRK/9GqIlIhcQUzf/uicu78l28YpolNnZZZgeFj2fs6vPFuVAjSbHUL84e8aO+yDCeBJJUMP+rMxT/7TENR4GqEz81oJD7nhddix/P17d51MzHR+J23TvWU3sQeMZhOKRWYQEcVn8N6sqdzHKwUo63vpy45FyMXlRwgKHIX3MKvKFTAhO3H622msQJhPnH4mSAmwkXEs3AhtLs3uI9D+XgLCbik2pnauGkpmArw7KTMU2UlNzJFWHfmbeLS8/0Y+gFc7U4mEnT6ZISuqfRY3Ol4RHvBmTIGC5tq0jFcNO1pYyFfOIz/x/SbwfJVnQBs4OwgGB+e6P1hUfX9GWbCDL0Q5jitVDFSKAuQDsyrgZqVhuTQX3+H7ud1iYBt9wCpx0tPe08h6fXsnDQ6Lu1iktHm0zr/I485TAfh8ql9YXNp8PiW8CT7i4m+niU/aVxh3ZVzMXsNvKRTURy0mvjhZxrMsOXE6k1j9bz7JjSr5RD2bSRbUWVpo+IASE8RcBv6pPqwi3BqC6CeR9lKIuxIusCVfqNTGFZeRyrSfJ7uDALG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199021)(6666004)(8936002)(6486002)(5660300002)(86362001)(6916009)(66476007)(66946007)(8676002)(4326008)(66556008)(478600001)(38100700002)(2906002)(83380400001)(1076003)(6506007)(6512007)(186003)(2616005)(41300700001)(316002)(36756003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PB36vvrNhDCkHMEyr2v6GPIBjux8dkXWd/JJ785+1d/3R1PVd3Ld9EnNkdUE?=
 =?us-ascii?Q?vRBp0bOuSBtcuTEvPHyeNhrBAZppOozwOPhOTObRbbMora+nyzK8OMk8oWFK?=
 =?us-ascii?Q?LOmNl/Nc/647UtCRXb5jb0pd7/fP850gsy53CvvPu5yBptOSbbPKqk5nnSgx?=
 =?us-ascii?Q?e0irtWZjY9XJGk4Op8TRyHrMWB0dMTJZqeSRfa061Qe4GLdyVn/NoOp10MRz?=
 =?us-ascii?Q?FScPR+hTSEQEsGJbCi5ARsiEvXUExJ6oZwEg8rXgf4lB8eab0xmPlEBYxUpi?=
 =?us-ascii?Q?PbxFR7DanB7eCL/sPolr0QibqkotCZkBRXMIAV3WV7yfFLfJMSnTLHA/Y9H2?=
 =?us-ascii?Q?jzMGKJUdnDr3RBhZwaub/gp9+XWAKM2/fHQW4fl0BeCck5htNrCYNyKWYBQI?=
 =?us-ascii?Q?ih0B8G4p3DI4HeLVaDhiN8nFgLAvF9J8wqdLGNtxyOqbvR/ymIyIzGGDpCMC?=
 =?us-ascii?Q?oVoIgr5zUN/9OzR2M8R2wCmHv5whw8Vo29QFRulaWTfu4bfaqdx3t1Py5TfC?=
 =?us-ascii?Q?x8J8BCTmKctXSt0hX2YBGE6zrBIOVL4iQ3uAtS4CUqkLABsIewvXnUfLeKuO?=
 =?us-ascii?Q?ybuqZxjJgwg2+Av4vFp7mOkY4SzSZUrpqrmy0SQ/uJ9VSdcjNAyUetGVoEhs?=
 =?us-ascii?Q?1nyusKUI3KT920hpf6aClL4H+6rHHYq0LHHTNIRODnEkC+gceQ6beVnXttgO?=
 =?us-ascii?Q?nlQYajyXwLymd5MM4XsGJHCXzh6fggonRrK1RUXJ9jGz3KV2b9LrjcbHxW4i?=
 =?us-ascii?Q?BnV0Xm5Zg69EdjXVO3o9dMFgfpmFstUqJWtF/nxvirXAdAtAxf+kB9irpSVg?=
 =?us-ascii?Q?VR2ApIaMiJ9+iZEtbx71zkKATmQGOGOdEoG4gPJH1bgQtPo3y5Y+JwquGam7?=
 =?us-ascii?Q?QDrqqiyCHHz1E/a0dCPkvSiq0znWFjZ4EaC3hxICE9LRGxvLo0lcNznl2Dtk?=
 =?us-ascii?Q?soerWDoka6QyTU2rdAnhJ9DTPmx26VYX3Fz8zUQAIiL1KBJ0vewwS1OxgrFZ?=
 =?us-ascii?Q?XPSm9fPMUhYKOViqkuMj0ZYh1CRcSl1roQpc4QocsxfluEFO5MvTDZ2+B0zf?=
 =?us-ascii?Q?uaZTyHqGY+N8tddd/tHvIpnJ1lB0lOGQ4/rRZ2MXRkFaZfxMvSnHIwjaqyf3?=
 =?us-ascii?Q?j1CeAGq0rQwLu/dFj93IxsHyd57bgpPiJF2vplZl+x6IRz/OdDqDEcEpI85t?=
 =?us-ascii?Q?gtTVBDNLyg4ni8ht16MJsbKUeI+C3pko7HtU8pbpHMMgZSs6eiCJP0o8C9F9?=
 =?us-ascii?Q?49VzkT5cG7RBLhjHafAiHs3KWZWhQoABiKgB8jkTyQwrBp2H1v91ZpdX3L13?=
 =?us-ascii?Q?WShNwh1e+PklRIk5lkgl5DNRGxeki1ofc7hdykd4m3RGYfVVULd1ZQIFL7Pc?=
 =?us-ascii?Q?kGbU+7yoxUQPJHf4mzg0Na3UJM2J3VJQhILlfMBGevNrVc1Hei5/IqCdIVPV?=
 =?us-ascii?Q?DrevGvW4Cu6zzxNpdqavtosn0O683Ah5+53XXjOcdiJ3xFiWzg/1xVBhqjFc?=
 =?us-ascii?Q?+9SGmA+gjD6JHDNO6DfAxfmU0347cESRpp8zR9IOV6huyK99F81W0dnj3eFj?=
 =?us-ascii?Q?R759g2BysG7e0HDQik4iYu3sQb4yM96SUq68T9RNB8MPQP0esw9ZcdiS1+eI?=
 =?us-ascii?Q?8w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: H5svUv9B8Ds/ev0k8SmrvtOCDlVoBytJumhEUcP3I+AhCP7VOS6r0w1Rak+dbwiMicdWBe1UL/IrKg1uGaaF+AkTu/c8EvNWRhvpUkbA7caP7t66nwUfQghJ5rlUXvFGyIS2IZovoZ/1cmwK72wJxJmwd6Ne6JlqbeodmGOUcXlSMsv0BCmvz4M+T+dJ9aqpvqsRM0GnOYDUfm3gbbrOE1LHXzD4VqOIVTKX7Segl8YJRFUdhrPtjKC3m0eBayZMKJTNCzRB3JZb6z9VwRO++ROxB09+hGM6ldtVUrSiRA+Ckn9YLirRiX1mUf5kcFYhA7qutK9cNsQumSkdKiF5wbyh8AtkkL6+VB8ENBcfLwvmEE3fZNceNEwi5GLpRpNkpfQnbBWKYEYRH2qUq7KQ0smrdfbL5SDf3e6qZvqHGb4sgLFcx7IOAsoG+InReitHNZiGyWwjm7HbmWZkHCfhz22kcmhB13dQ5MtkuGaBctjypUtdXNT7ArGg6bElEXo7m+l/LTI412XXQqKM8xcUqCc3HbovEKZYNFnhKttuR34qiTZ98ePgs69XDoxgbiH5YkIFfw7hEu+xd0806KVp14RGHQKM+NowvmU18PKDks2ki3c6kBZkmwOd8GzHMFLs6fddqbtkVRPTRH8ede3SaKH7PjR47oSqPObX6Se9obPcrBfL3jm0FVS+Xb2yA2nUE+PIOrmvvHqE7bNY/xJeaDm1QwNMkt2GYNijgimWwhdIUDQYadPZqmckpKP6pUpG2P10rNWJugjcxNk415dP5zzhLYoANf2AVF7CVuLi9CHvXBYsc4MaC7O9IL5WozJCu8zFd8uqi+VWRW3pz6DdBMZ98AuMTT3PYKrlJyZC/Du5UhPhoIzE07nCHaO1QLeb
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88f8d41c-757e-4dbc-1e87-08db3b0e7b72
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:29:19.2064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3BhsG7vQBaDon3Qv+M4JYLIjPXEuejFE9rDpybdPGA71R1C8o7KP+Nw5dTR2Vay9JAoOAV2IjUm4DgY0EaXXDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120038
X-Proofpoint-GUID: u0hT-gOwXup7jPwXX4__ZdonZ7ilHoVn
X-Proofpoint-ORIG-GUID: u0hT-gOwXup7jPwXX4__ZdonZ7ilHoVn
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Foster <bfoster@redhat.com>

commit 06058bc40534530e617e5623775c53bb24f032cb upstream.

Freed extents are marked busy from the point the freeing transaction
commits until the associated CIL context is checkpointed to the log.
This prevents reuse and overwrite of recently freed blocks before
the changes are committed to disk, which can lead to corruption
after a crash. The exception to this rule is that metadata
allocation is allowed to reuse busy extents because metadata changes
are also logged.

As of commit 97d3ac75e5e0 ("xfs: exact busy extent tracking"), XFS
has allowed modification or complete invalidation of outstanding
busy extents for metadata allocations. This implementation assumes
that use of the associated extent is imminent, which is not always
the case. For example, the trimmed extent might not satisfy the
minimum length of the allocation request, or the allocation
algorithm might be involved in a search for the optimal result based
on locality.

generic/019 reproduces a corruption caused by this scenario. First,
a metadata block (usually a bmbt or symlink block) is freed from an
inode. A subsequent bmbt split on an unrelated inode attempts a near
mode allocation request that invalidates the busy block during the
search, but does not ultimately allocate it. Due to the busy state
invalidation, the block is no longer considered busy to subsequent
allocation. A direct I/O write request immediately allocates the
block and writes to it. Finally, the filesystem crashes while in a
state where the initial metadata block free had not committed to the
on-disk log. After recovery, the original metadata block is in its
original location as expected, but has been corrupted by the
aforementioned dio.

This demonstrates that it is fundamentally unsafe to modify busy
extent state for extents that are not guaranteed to be allocated.
This applies to pretty much all of the code paths that currently
trim busy extents for one reason or another. Therefore to address
this problem, drop the reuse mechanism from the busy extent trim
path. This code already knows how to return partial non-busy ranges
of the targeted free extent and higher level code tracks the busy
state of the allocation attempt. If a block allocation fails where
one or more candidate extents is busy, we force the log and retry
the allocation.

Signed-off-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_extent_busy.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
index 2183d87be4cf..ef17c1f6db32 100644
--- a/fs/xfs/xfs_extent_busy.c
+++ b/fs/xfs/xfs_extent_busy.c
@@ -344,7 +344,6 @@ xfs_extent_busy_trim(
 	ASSERT(*len > 0);
 
 	spin_lock(&args->pag->pagb_lock);
-restart:
 	fbno = *bno;
 	flen = *len;
 	rbp = args->pag->pagb_tree.rb_node;
@@ -363,19 +362,6 @@ xfs_extent_busy_trim(
 			continue;
 		}
 
-		/*
-		 * If this is a metadata allocation, try to reuse the busy
-		 * extent instead of trimming the allocation.
-		 */
-		if (!xfs_alloc_is_userdata(args->datatype) &&
-		    !(busyp->flags & XFS_EXTENT_BUSY_DISCARDED)) {
-			if (!xfs_extent_busy_update_extent(args->mp, args->pag,
-							  busyp, fbno, flen,
-							  false))
-				goto restart;
-			continue;
-		}
-
 		if (bbno <= fbno) {
 			/* start overlap */
 
-- 
2.39.1

