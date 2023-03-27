Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0E186CAE11
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 21:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbjC0TCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 15:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbjC0TC2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 15:02:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BEA2100;
        Mon, 27 Mar 2023 12:02:26 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32RIoLVa028778;
        Mon, 27 Mar 2023 19:02:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=rjfqf4t7uyCufquwqK3wKGn8LhXzB0cBxImqUhe0z4Q=;
 b=jt+IrPNMWOxOat8ZCC9worjF894WaX+YXy4zdLjMMkoJyEuU7MCGkg+qVfkco7kVnPOr
 qAQuIruGe1lVuGSWZK8ajU+4FZVdsLJ4i6nRgxp/XLV5V+sqvORwwFCsvRJUq4VpN+h6
 4wBXMlJX5uM0GsmDyt5MdKvhfQR1xyrU6XCM3NALquonpklMHibt3UaimtTnCJwNC/z/
 TM8Is2O/M8o3HckiI4iDs4Lvksq5zXh11NE+WpLmG+RKJA7NAy6jPR85rVhO8BXP99fS
 spsvH7weEwwBfrkxTNAd9Yc6y/bNJZY2HfDl6faC8ovSbig5BUVmJSjbMeGZyRwJIJ7E eA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pkgsa01m6-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 19:02:11 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32RHmK0O005430;
        Mon, 27 Mar 2023 18:55:49 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3phqd5cnr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 18:55:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Im/6roL+RwSZAGfiYpioVTA64PfFoGYubFepiym3r8C+SfEQnJwSQN09MtXZyaQUsqxJfyB8Q/D2P37fzr6HYyZcVPSFmkmmAk7Gnv23pfcwzpOoIveZ+4qFap58jZLTJxR4MFYRfnaVRjui4YPfj/ED7G9krwLRcRJ8KDGtx6Ny1cMKsTp54yWO/hCSgd2jd9hGZqHM6K3NNq9jSGKiO3krWGIXEjGRmr1NtPkVclyVfvom5G3tdsVsVOVpAzUTf+I94p9ctO5r+83NFVjUVK/QNNfSg0p+o35p6msyz++eXG+yQMrJXTTTEST2vx+6rieq1G+/PpQr/M0pQg3nSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rjfqf4t7uyCufquwqK3wKGn8LhXzB0cBxImqUhe0z4Q=;
 b=HsQAMIQ1ntPoL8h+tyOUTEzRBZKMgcORe/0KCZwiL47efYbG22KrN7Ylfw8UfuAwDK2WpMsMoUl4tMskv8obWqa+Xz4ZUagpDO9AKy5FLEvk6eM+G2D3BygfHmD8R0eVKHmGm/sk5C410YCKdch/KCmpTG5SdBlzPxmvNpEF/c98oi2KgwapuCyz9vA1FdNRlLIKkFCoQMTP7odN4uQKMcmqal2GajWPMExu0H/MRW7i1qqPV00Oftrcm0LNiNBuZZfnFI4hZ6sTqA57rlVgZEtbjDib2bSKZPPP1qasTQ9Kc0EfSd6zYY6rrFWvjaUWC2aS8BPO8vZQFuVYSWxU3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rjfqf4t7uyCufquwqK3wKGn8LhXzB0cBxImqUhe0z4Q=;
 b=mi1t0Q5x7Qv2/Bd2tlJ5ylQ9HlxSyUyo0XkI1NHHRXbgYfounl8KBZmJCmMOqyx8O1gWcG86D8FCVbv7y2GTBy988at1enj6v9rwOgUJvyqtZXJ8me4mAGF8pPY5UgJhYAvkGPuhI+LPrqnKDS7tNMqcVIb1EUldo/Ottb6gHBY=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by PH7PR10MB5722.namprd10.prod.outlook.com (2603:10b6:510:126::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Mon, 27 Mar
 2023 18:55:45 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::9fc8:73bb:cc29:9060]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::9fc8:73bb:cc29:9060%5]) with mapi id 15.20.6222.029; Mon, 27 Mar 2023
 18:55:45 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
        Suren Baghdasaryan <surenb@google.com>
Cc:     "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        stable@vger.kernel.org, Liam Howlett <Liam.Howlett@oracle.com>
Subject: [PATCH 4/8] maple_tree: remove extra smp_wmb() from mas_dead_leaves()
Date:   Mon, 27 Mar 2023 14:55:28 -0400
Message-Id: <20230327185532.2354250-5-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327185532.2354250-1-Liam.Howlett@oracle.com>
References: <20230327185532.2354250-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0343.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fc::15) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|PH7PR10MB5722:EE_
X-MS-Office365-Filtering-Correlation-Id: 39bcb855-def3-44f4-c474-08db2ef4df5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SoT9U2NSh9TZIFx6IE+K7PsaXkRVc+V11xyg7Ogn3raqP/k0X9M6crSXpSNl/Hjlurf4Q1G23iqLSnLZcAhTKXSa9zHrN7STUyytNVmT6qzXn42186y6QEiSbY+B52D5rCRj3oao+qBaEhDiQQganlYtLEkLkuLq9RrfMEnttOn6O1deEOdf5mQIzosR5J8ffTyTVAZeEj6S8/Htc9bzzHJdMXB8lxF0liFDumv9mgtRR6P+2xUdG8JJAYILUhqL46p/DlbreKrfuLRT59AfF7noMN7LXK640YZswsYU59h6Un8KiXmNqRZvmpgYyOcAArU9qdd0WHhcS1u+oLeBQu2iQzYfEVzscZvBr8t7pW39BLozZdV0Dfd/WjSiDMNX3CuSXn2iIyezME0KOVCazZc2yUZvlEPnLXcoAyVexd+m8MMsI8NEtUrGMmOH258mUsys9TD+ZEizhBl3a5vkQ8R8W2A0TszyPZQ0oAzelHxSvwAEp4g5Ep6B2Eghlw0q1OfRTBIKuRClg7Iyx2Ns+T+ScI5yOVC2YoWs6LzWpLM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(396003)(346002)(39860400002)(451199021)(2906002)(38100700002)(83380400001)(36756003)(5660300002)(41300700001)(4744005)(8936002)(86362001)(2616005)(6666004)(107886003)(110136005)(54906003)(6506007)(1076003)(6512007)(26005)(316002)(6486002)(966005)(478600001)(186003)(4326008)(8676002)(66556008)(66476007)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bn3UhfIR5QOLCQXOJkAi4UGlsY/5RHFvS1/pKbSf1QW0AV/bjnXdxD+SHfwl?=
 =?us-ascii?Q?Wd4xF3Hzw4XPZH1D1Vze8hpVqCK+yJudMsEW45UqlOhHEkt4wKoeoJpNeBXG?=
 =?us-ascii?Q?44p84yQCDv6CQCOs2HzSd8KAnLCJalxKI5efhmAfiI5cMc0rm+LRHNRAoVHu?=
 =?us-ascii?Q?B8PZRxj3N5qCXt8yaNS8qpQ/as/nIPI+L/LiDITLhTxSpMrNRFicl9BgEc2T?=
 =?us-ascii?Q?6kbamAYN29fsrFh/mL5hIB4/loGmtoZsvFm+qHx/5qK1vWgA7fnyjZdSMjKQ?=
 =?us-ascii?Q?8Jg1Ae08j+Snb8Gct/EGzyY/xZ9IUJzAJa8I3us82JQPHFitiokzVxysHhi3?=
 =?us-ascii?Q?sM6iLY9Ln3puUglwvBO/2ocIBt1/ltFbL199onXpu1ZpIQjW5/CXuPY3z1RH?=
 =?us-ascii?Q?D3LLnjYCzx4aoax5KcGUd5Mi1T3pb7CCp9zv9iOH46KOiKbLenvVz13vWQW5?=
 =?us-ascii?Q?2FOMXWH8wPhEL4Sajbt1BcUo3RTZ6hKaIz6f30oqXOqYiqQXchhzOMYQz/co?=
 =?us-ascii?Q?qmGy6cc+sdRztoL1byRX4l4Q1kK9VUHL9f4KSq2AMXj8A9TVA4NWFJm0O+5t?=
 =?us-ascii?Q?58X2tbZcWqk8pcS3tl6Ap2w/j8W1kc/JNfF//4EUTbnX1MMHVPlk3XE7h2IL?=
 =?us-ascii?Q?Vl+dlzYq/bmkQWo8OohFl7P+Y12rAZ+haWub+S7+zzlkyyDiH3HytSaPRvYS?=
 =?us-ascii?Q?JEG77bj8iu15ayxjpHgxZmlLRKYpiPNW4SLAMlgAB3FLT1iKJUGPGifMvvoc?=
 =?us-ascii?Q?OJCYz+esoCUEJ6VhHmjhbFVGSoyGua+k7c8c7DjS39cXpKnZqicMleAlVHUN?=
 =?us-ascii?Q?mQLDsn7O/sG4JN6QSItdzv8cE/v1rXAw2vT82AMnA0L3IAtWbbe5AIKtmuA3?=
 =?us-ascii?Q?YtJoJmW1VRapalcXoVsNjYHhxOM4OSRFMUiVA5tKxQZRAKjVcfERKypFxK1D?=
 =?us-ascii?Q?1DUHm3lMdkndoq0dX90ckMdi/ulcHmN0jWmVI7tyGJybrdjW7n5Tt11xpZZU?=
 =?us-ascii?Q?CHf8OzBZ+8+dGAn55UpwW2qYujbQbcVcpdqIo5TD8WsPu+uWXnXHsyrn//Dp?=
 =?us-ascii?Q?ZWDo9ziMLf2AQScdV4GxqCDB4aqUeO77tW61tJ0R3tg5cqcMDOJET0ZQSX1f?=
 =?us-ascii?Q?s/rRv+tUfwBwX2PSHakxRmKbjTjO5xffGZeFYBQsWJoPygzKQQ8VcOBCeoxc?=
 =?us-ascii?Q?NqisecDEDjc/fIvS0jxixI2oD1d69PhubGtTqTT8tIhyoxj/0MigPAK/1e9z?=
 =?us-ascii?Q?EkicSHdkSdgyZkAohXrky/5s9x3CSHu8KmO+QJzoEcjahfaRIqAWF090Sk5l?=
 =?us-ascii?Q?Ajn8SOcueQKbleKKcB3I6dVwSxI2LVweaK1fKidFlxYDZNpFys/RTjGMLr1Y?=
 =?us-ascii?Q?d8BOz3bTOE4yBSCRbyoe+HH7fP65yJXI3UXGdAlG8MQMvzAqyHdsoYBT2ouZ?=
 =?us-ascii?Q?9DbQni69BI4dl2PiHiFgksNbLXQTYREIwx/AMUcCiG7j2qIPeE5/6H3XGEXH?=
 =?us-ascii?Q?GZITSTFRAx2Ao++lu0blACyaHFodHyoPeyD/Rj/pbL2F6oGECkqEbhQEuZXq?=
 =?us-ascii?Q?k/uAkxwT2jV08rzEOa1o/L/TAUrKVvwNtMNxl0xIhwLEGtIkb8sbnahic21p?=
 =?us-ascii?Q?OQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?InXK1xskIPbbXDKHwWrrPBz+JPwz6UZxsDjBgyo+neh3LpwnHQBKvCYc0k0m?=
 =?us-ascii?Q?QA0c4804BEgLVrTm2/759NLj6Bo+7GzIERzH4dp87i4q0Kei4ngJXZLZ+nF/?=
 =?us-ascii?Q?QPYvoI5gEEv4Mfv3hJ+8ft9cM6n4MDEE2iW7y9jJmt3AQMRPfndpEMB7SFCs?=
 =?us-ascii?Q?HDqmBfDw0Vz4tGdK95GnpsaZtXWcuqgxTg2sHm27I/XsG60S6PuydyB7VS7j?=
 =?us-ascii?Q?Zn3CKS7aJ6Cw9Jm9lJ0U8UJjwFvYuehGusmaBl5k3eKTi6jtvXigP6cBy27/?=
 =?us-ascii?Q?E70q6LA66kARezveFq1X+AnAMexKsQeQKte3/30M1qeOIgaKyOi8BBwdqEYO?=
 =?us-ascii?Q?H9eVmFhSm14VP/xHk+EnO8rHzditTP25mKnvBsno/ikEosgObrVCj7cf5k9c?=
 =?us-ascii?Q?4Q828FSr4/hxd3LvC9HDMHtIEL/yd8zbPLE9CWamaaGv+cDvyacAHdtnldBw?=
 =?us-ascii?Q?9E6ZZrAOcSMCM3AvTsxlVCOKKEtBPxlSdhdAJbnOFZa/Ce6CdMBNaa7qn+Sa?=
 =?us-ascii?Q?uDfIPINVYPfouGSD5bnYh0Vc0BEy0zKkwvv3OhARoHNmYP5XF5lKTr/VwQbO?=
 =?us-ascii?Q?6KI/9qS/perV62ygNu8/9G1Byf84+a5J6ql00Q8Sfj/2DwZZqx26sFpcbjLY?=
 =?us-ascii?Q?DGWOUG3KTTjCzHuuZu640xBEpGFcUob7uA/4wRaNYEPDGoHaAid7F4vpJNaH?=
 =?us-ascii?Q?7z/HxHOKHJ8pNoulXzuVZjzNV76v00NFAqPnBjPzWTxmmautkQK5Dcvt8cRp?=
 =?us-ascii?Q?PY/rw0Az8fUJMk659Q+T6LrpAadUnOBJC5/W/zfXqPo8VYxHqpaq8oRAWDR4?=
 =?us-ascii?Q?RsH83owunedmUOSE7tZze84/nMOQbP99aSdqRZdVj5u6YhXURj33/2f6VaNY?=
 =?us-ascii?Q?1CtLLrwtd2XMZYa+2c7rb7MkALSn+bBFhhdJT27VC5UxAI/EJSAp2hkCLXnv?=
 =?us-ascii?Q?iC9T9i5m/uO9YXa0d//z/w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39bcb855-def3-44f4-c474-08db2ef4df5e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 18:55:45.8560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hnWTxAq+oxSD2M6UKHRdkPHW6LkQzQoWExOZhMcdhqZT/a0HFOMQ9l3/e9g47667Vi6Z4LdR7E0RfaI2jbnwiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5722
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-27_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303270155
X-Proofpoint-GUID: NqQ70RbxqBlrlFEjOuhCd11A5A7kOfcM
X-Proofpoint-ORIG-GUID: NqQ70RbxqBlrlFEjOuhCd11A5A7kOfcM
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

The call to mte_set_dead_node() before the smp_wmb() already calls
smp_wmb() so this is not needed.  This is an optimization for the RCU mode
of the maple tree.

Link: https://lkml.kernel.org/r/20230227173632.3292573-5-surenb@google.com
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Cc: stable@vger.kernel.org
Signed-off-by: Liam Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 44d6ce30b28e..3d5ab02f981a 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -5517,7 +5517,6 @@ unsigned char mas_dead_leaves(struct ma_state *mas, void __rcu **slots,
 			break;
 
 		mte_set_node_dead(entry);
-		smp_wmb(); /* Needed for RCU */
 		node->type = type;
 		rcu_assign_pointer(slots[offset], node);
 	}
-- 
2.39.2

