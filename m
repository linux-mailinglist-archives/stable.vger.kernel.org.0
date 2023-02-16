Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94228698CC1
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 07:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjBPGV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 01:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBPGV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 01:21:58 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AB627D77;
        Wed, 15 Feb 2023 22:21:57 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2IrRr011337;
        Thu, 16 Feb 2023 05:20:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=vHATsTuKVZl948YLrPDxCYpozwsm2+mh184WTT+0suk=;
 b=Tl9KANok+RAZyi9WG8AJsHpX2MzZPOeRDMER7MfzoXVmuMCBfZFtxQMykRLg9si78uvp
 T8I0XK7OLNljpo7n/vHr/dsfLzJuA0IXVlqLP+SBolRsucXWk9gYLiwewOB/m8Kv7QTS
 yjMpP2QzUds0Ht0ZFLt/GZe/EpfvhLFNcVN5wqDERCELYMgYjfhQjIHj6U4qDAGcYVDe
 mfOgq+Xn+HvM9Rg2uiSSPikEzj4FI28S4nb2cBIY4oIy5gFukm5WuBBwNjnI3vdsKbmP
 c0c70MH7U3DN3fr2pmeV1oh4+3ZFfnsh1rBgiexiZkYjlKMMF5uyvsrVSSgJ7rNDFfCR bw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1xba7yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:20:58 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G5E1Oi013560;
        Thu, 16 Feb 2023 05:20:57 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f7u1ub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:20:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=msu3dpsPLLF7BpUvIHaiyYHMKPF0iKtiY/VQauTxBNCEFDw78VVlVlwwkE09V4UURQWHfxEez/0uoAan7ZshX3NQtoowdl67R4Og3QaoTfiakHc/IusZJcqeuemE2MrwfoCACo3/dmYfJg4/bT30zEji8bIdtVVbUXb/+7Q0kk3kUItsj+yq38G7IsB2KOsnCh6hD60eIeFONGU9/dt5k8PpKR47lz+6fw7+CU8NDP8USHiATj6LKzezqnnU6qCqXuPEES5aU2O151sFZ2gLPRDk9sr9a28ZroXXrLgds4ffl88VmH9GP5vqF99ME4ybkruNXpI+wUD3KyoiM3af3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHATsTuKVZl948YLrPDxCYpozwsm2+mh184WTT+0suk=;
 b=RS3lXW3Lr8aRg28HUB0HyWFu1ifZAm/ev6a+3Op5pGySMyBjWRBjkKBIY/bFNjQBWJxGbmjSe1esKtV6zK+8NicJhuM49L93oqEoAJf3qSrDkdcHnkJs+chwFC9MdNWVffbS5BAYwLBTd8/bqrUsLU87mvpBbbB+4CwNdNTJ6oLrJHUcPUxcod/20qGlLoFbQOcEitx6OHD07J87ko4tXTvdPBmUZg93xwv9p5cl4yVR4lya2U8bsvjDLGKSVJJqJ5P0xBfybPIt70DMAkL0C9draf4w/PY3r9+yj1yr+ftLysO7cews2XwlSyLR/7rjj9iTrOTG7Bkmlv33/4pmFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHATsTuKVZl948YLrPDxCYpozwsm2+mh184WTT+0suk=;
 b=AmJ5OcdFLoWhvdMuEDegNa/hpNOmxc5s96EmoXcvZaVPrmDBEyBSw9ADdzceXUGk2O0AP6sif801uSyqs1CrY2Pa2/0R4FMxMwE2depONp/EcjKqeW82cFy+dfkij/x7qu7PGWZfojsNLzGoIpxwn6yUWeuAOy7fF8YgoSQ2ujk=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DM4PR10MB6789.namprd10.prod.outlook.com (2603:10b6:8:10b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 05:20:54 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:20:54 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 04/25] xfs: factor out a xfs_defer_create_intent helper
Date:   Thu, 16 Feb 2023 10:49:58 +0530
Message-Id: <20230216052019.368896-5-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0176.jpnprd01.prod.outlook.com
 (2603:1096:404:ba::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: d482a5a4-2434-4907-89ca-08db0fdd93c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DEDXNFtFBz8cwcPQfE86QWGLVWINAilA7Ixv/Lxjvh/zxNZYxmrJz+pZGDl6Urgasu48EWCmQE3UZdkXrPcojptMrgu2Qaws3yR76T349xTwBQOVnZAZmdAA2d6fQM0GzmIse8fAtgEpTp+m3yZ7L96aTrBFD6Cru+N7SnbQiD874hw/sJULuDAEpRCe7F8NgCzykemLMv8jowpGWgauAkqJyfTeWoZahcM+M65CxoEkIc/vvKxwES76Vq3lnvixGtgfpmZN90rhATRwg4wDLnUylGzY8cGo6nf+X3CUwr1iwvy8Uz0z6k+p65U1TbwC94+7lrGljISmpJ5c9R9+fy6dYzj9O6SE6JXammcjwXAvxZlFLu9P6K4kPtJxQeBT/ZELFWn51UJhBqHTz4uTrrBs2gaPC2Z2Q4fwZglSPXTi3J0bAiWtDZCzkRD4TRB/ZYRKuk+YFbe3FP6LoVtEW/q5grTnjcUTTXwzlYBLfAPlgWv+W5UUFK7cQ3x0xIoaS5NuKQXql7D2jONjD++h+RrUDJ6XiRMUFcD1c6RoFFbE9SHEyDd+cHa5/zFWr8SBo9V4P5SdQq9wuQsvbWfBJM5+reT74oWX7bzBZzDU7NPIvv3M4tPddXUSpSp39cnr6K92qfmb+S0iDYqTGZ/+gA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199018)(2616005)(5660300002)(38100700002)(316002)(6512007)(6486002)(2906002)(1076003)(6506007)(36756003)(26005)(478600001)(4326008)(66556008)(66476007)(8936002)(66946007)(86362001)(41300700001)(8676002)(83380400001)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v3+dJ+VzQPP1FJTT24XPMUG9E6hjof/Q1zxZJTtXUFkL5uigSWm27EmNU5Lr?=
 =?us-ascii?Q?PaRbX7fjGOYYa+6COI2xwOTZPy1I6/29V/bdLf3pl2JbJtDh6N6Horsx3kxa?=
 =?us-ascii?Q?rgTaqj2JP6bZXzEuFvkdE9urWl5tpp42YRNiDDaagN+c0g5u5410k0c1pAPe?=
 =?us-ascii?Q?lbGdcihBy8M5pBETR6N9V7coAXylxYjReRZwTTjYN8USfZAKKkVNrc9K4n9P?=
 =?us-ascii?Q?baDV/jQKfdq3NA4KoiLBU34Kv/1NzXNXl/vgKybZwrBUNbAPAG9DP+B3ehO1?=
 =?us-ascii?Q?FWLzA7vLRJIp0bwhvPchG5ONJ92QnI8LnosL9RpQ4LThxre1r+L4Ykc0SzR3?=
 =?us-ascii?Q?KFoLkObLf4DYun/3VdcsoapQrEuJ+A3dQwF0peV008eBKerN3rdPF5e8sRU2?=
 =?us-ascii?Q?BN2LbcGnUjK9jbZhfos0hZSxZ+qDV/d2FLhqP/7C4PTYlOiMhznwULI/EJhp?=
 =?us-ascii?Q?M+T2JZbpAtqup4YzqIs8yhP7QlncXDWTQfICESzNqvWx0HhuaX7hd0tJCqr8?=
 =?us-ascii?Q?Bi0ZfcLTaQ6t5vNhCLmC5f6sfZ6VxqrZ86aMITvaUCaErgkkBVWa+7inBdtO?=
 =?us-ascii?Q?uyyZ4OsniCCUz0/Uf9rEcAYAFcDIJ1u01tntd4ThTVbKFW83vQfeeRe+ODBy?=
 =?us-ascii?Q?spBb1TXTTas4iJtBEXx3TDTnZyvvMhN74GZccRkLBIYDXa3+xpn/Dt94agPH?=
 =?us-ascii?Q?9OABmdvWwlwL8M0NTOgd6T5+biVCxfglJFtXH3YUxtLraOBGku+tTYa7hytl?=
 =?us-ascii?Q?pWOA5mn/WPlnkUTzlfNtb8fHyv6HWs9PjxAbw/XRr++v+Wjtouj9m/3DfKRN?=
 =?us-ascii?Q?W7GsBEOE6rQfv10r4pG7j7WW3uRjbYYNh8Q07CQ5/V+G1RwW4mBuExo+MONG?=
 =?us-ascii?Q?kC1l4V1jarSCW7E8dBHrSEbCgmrEpS4r8VJtheMBZbcew3xcni8vXz7C0X0q?=
 =?us-ascii?Q?crO/KpzeBEVMc6MbeE9ANTDoDMSrn5f5xwEdwII1hfQ0ULSskQ0A2mQm9DSO?=
 =?us-ascii?Q?6zvHdimkDLiljXNa4QILfqH+dpFPdwIBME9ApdfoJUZuQh96GnPXl61wujAs?=
 =?us-ascii?Q?2ZdCi3yFLl9O+f6NH/erbrMvMBaAbjpP69mz+mS6tQ2sQXOsAdzFFHT+TwQa?=
 =?us-ascii?Q?JPoAuWmWoVHSbtFx/r0CAAg0mulyRtlG3MXkxps43w8IgAg0wcgrqycfhB5e?=
 =?us-ascii?Q?d9YXdy/zh+6IW40TVruGINp28ztIlBDWR9kxMGMVg6oNKxYpvJ+m1GXlVKhV?=
 =?us-ascii?Q?0MeCisMPlOslAKXsDavsim/qUvhs8sv1/Wk3n6qpDhC3vKmyXlPqehmriG/V?=
 =?us-ascii?Q?L7izTSwvX20Fu4Rbls62HRZb5WkJe4uq3gx+wGmuX7bbi0wx0wW1zVD5MN2I?=
 =?us-ascii?Q?KParQxPab6jEtwXyfyeNGfIeG9t+MOHwQbG/Rx03FSyeh6o0gNxfevihS00E?=
 =?us-ascii?Q?xPzi/J2rd54ZbOUy5SaLwkpHewWeCHmnq3QQXJGxC1Kbqax3y4DMSutk2JN9?=
 =?us-ascii?Q?+Ajr0Nr1Ywn6Z+nYvrjnFnu2XZc3zP00+/MywuPxgwGEbYQkMlKrns0uNQAX?=
 =?us-ascii?Q?K6ShIkPGeCXVoHDY/UVzjQwBF2QC6j/JJqDT519iGDweGh4farlvyi3YY/DI?=
 =?us-ascii?Q?iA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lOYEmEBMmyrLYEFPYhrGE4R5e37ZxKJooE8Tf48rMj/oM9J846fcvWn4fUGFzigF/OzhiwhY8aGSR2eL/NRV7tQ2mfsJkGp01ZaEH1RKkiUBjm3JklLqLk7vHBacx+mpCQyexk0TQuwutOoTNZGQFh1b7X0ESxJ2JccWKg01LvOvbMsxayLZeXA1bWs4M2iQwOYGXyvvwNKpzFaKvIEVAfPm06T/qRqVuFdrXvzP8+VBJuNTRwaN6iUgViCICTtFBeDmOO388gOXwDmtLiLnlbtkLb2RSKMdTSoUxON/g0vNZtL1k2t2/aJYTJzRWilVyls5CXQpgzbAExUJlohFZEqO7F/R+9mz0Fku+mtwWYqDmKfWsbqLyRoJElH0i0EktkvtaHfSWausVu9TwoUehFEPitXDWjzgeaD9HDOVLoBIpsT2clL3DFCXwtJ5XvKYiaoVPNjR2dW7YTxlFlQa4Vjt4Htn4e5Xkl3M7Cz6aIMnwI1oyU07NvuR3zDplDIxaiRNECLGbLbELTCaKkGDpqWzrJkFdQwAtSNzBP4EGQVXC/yQrw/Zhx5QLhIL0kZZiWWLKPWDBvx3jSk29mLmY9/QrL6x2QcChmCCqkNoV2dKal8qw1LWum6Kzc8qMLr/ee89cyGY3/k1bJY3MKWHal98Q+TS9Ool/aXDf1EGMFUL3wgS4jB0BYJbilk2PBWzwJ469ce1IiwV2lvA6Gx1ndHhYWqBNn607qPJvo0RNlHzW8t0RM5j2ZmWVEcbJGfJSM/qa7Cjt03lUeDI6IyMNTBCOq7OGthM0Zj7NKv7WStBKhtxjHy9FimQtMlZmJ5H0ZY032U/hAwl5FPISaZMLjLRG4gRxusxU2J5nO4a+5aqeCdlIR3ha4dEuYRKfdc1
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d482a5a4-2434-4907-89ca-08db0fdd93c9
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:20:54.6892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CBKfa/BJT+ntjVmwseZ81p2gOqbWm/DSUy7sp7lt5rO8P1+t38Ch+vg8FD98sAKSkTy+LXGrjbnCphjqEYdc4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160043
X-Proofpoint-ORIG-GUID: -YJ3R5NIt6ClWBOsMJa4FJlKBSvkAmU7
X-Proofpoint-GUID: -YJ3R5NIt6ClWBOsMJa4FJlKBSvkAmU7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit e046e949486ec92d83b2ccdf0e7e9144f74ef028 upstream.

Create a helper that encapsulates the whole logic to create a defer
intent.  This reorders some of the work that was done, but none of
that has an affect on the operation as only fields that don't directly
interact are affected.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_defer.c | 39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index 8cc3faa62404..a799cd61d85e 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -178,6 +178,23 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
 };
 
+static void
+xfs_defer_create_intent(
+	struct xfs_trans		*tp,
+	struct xfs_defer_pending	*dfp,
+	bool				sort)
+{
+	const struct xfs_defer_op_type	*ops = defer_op_types[dfp->dfp_type];
+	struct list_head		*li;
+
+	if (sort)
+		list_sort(tp->t_mountp, &dfp->dfp_work, ops->diff_items);
+
+	dfp->dfp_intent = ops->create_intent(tp, dfp->dfp_count);
+	list_for_each(li, &dfp->dfp_work)
+		ops->log_item(tp, dfp->dfp_intent, li);
+}
+
 /*
  * For each pending item in the intake list, log its intent item and the
  * associated extents, then add the entire intake list to the end of
@@ -187,17 +204,11 @@ STATIC void
 xfs_defer_create_intents(
 	struct xfs_trans		*tp)
 {
-	struct list_head		*li;
 	struct xfs_defer_pending	*dfp;
-	const struct xfs_defer_op_type	*ops;
 
 	list_for_each_entry(dfp, &tp->t_dfops, dfp_list) {
-		ops = defer_op_types[dfp->dfp_type];
-		dfp->dfp_intent = ops->create_intent(tp, dfp->dfp_count);
 		trace_xfs_defer_create_intent(tp->t_mountp, dfp);
-		list_sort(tp->t_mountp, &dfp->dfp_work, ops->diff_items);
-		list_for_each(li, &dfp->dfp_work)
-			ops->log_item(tp, dfp->dfp_intent, li);
+		xfs_defer_create_intent(tp, dfp, true);
 	}
 }
 
@@ -427,17 +438,13 @@ xfs_defer_finish_noroll(
 		}
 		if (error == -EAGAIN) {
 			/*
-			 * Caller wants a fresh transaction, so log a
-			 * new log intent item to replace the old one
-			 * and roll the transaction.  See "Requesting
-			 * a Fresh Transaction while Finishing
-			 * Deferred Work" above.
+			 * Caller wants a fresh transaction, so log a new log
+			 * intent item to replace the old one and roll the
+			 * transaction.  See "Requesting a Fresh Transaction
+			 * while Finishing Deferred Work" above.
 			 */
-			dfp->dfp_intent = ops->create_intent(*tp,
-					dfp->dfp_count);
 			dfp->dfp_done = NULL;
-			list_for_each(li, &dfp->dfp_work)
-				ops->log_item(*tp, dfp->dfp_intent, li);
+			xfs_defer_create_intent(*tp, dfp, false);
 		} else {
 			/* Done with the dfp, free it. */
 			list_del(&dfp->dfp_list);
-- 
2.35.1

