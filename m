Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC7E698C7D
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 06:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbjBPF7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 00:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjBPF7f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 00:59:35 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58123305D3;
        Wed, 15 Feb 2023 21:59:34 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G2IoYi031820;
        Thu, 16 Feb 2023 05:21:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=TCuDF9HHe/LtbtWqau5OaDKm1HsrKOZvCC/dWWil5u8=;
 b=a+IUz+DVnj9suUW8Vk+G0Zo34Uq133KNBgA+qGT6TzQi5upJheT1ZTDKQHA+P6R35HZi
 /TFx8DzzhQBGyoYkxTYAmjxBOdIA/WiQpXXGNj1yTbWbGyv8Z3IohRuuRpy9CfBOO0BJ
 hNaYxjkU1GUf+OG7PbVYzioD1Hoe41Y/NnyetcrFrHNxXHjGcyMNoSbxmkhWlw3Whki0
 vq94K2Zsg34X6m417O+GFY8JtnBYz2vZPpXIbYSHWUjoA+jPpv/HakK+E/p+SFaAk0XO
 2kxs8SKHKvMRrZkG1TnUluj+yRah+4MsJaHVO+p8CByYBNzMdAe9DNApg/xeIfQSRnYH 2g== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np2mtj6m6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:21:40 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G2FGGT013510;
        Thu, 16 Feb 2023 05:21:39 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f7u2j4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 05:21:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OuKL5TNs7UVf+t8K8gOqnK01pD5+xyAWgTcBFRbjbudUFpJLNFECFpz6670tj56rtfcQdEGgDM8FEcBNy8FXvsdif+EXevYca2Mql1Mdcgu/2b1uM7zXLGM6lhDfsP66zSYnzzYifkvNO2u/4FDugNKBwobUPKAoEruG2v3aBzFYKgLFaUXGb14k09bt6UMXW7nglwGQicyhWMT+85gtj0jlpSDqfe1Q53KDO3cS2KreWuEK6JkJmleGB4a5TImJBIgogzXpdcNnivvibRAgE5oP9oMCJ0z3muGjSlbivz8rG6rB85OTzCBQoPG+OgrVkK7h3/sELKfo0oDZwIqKAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TCuDF9HHe/LtbtWqau5OaDKm1HsrKOZvCC/dWWil5u8=;
 b=W9o3HsSV6+msXrdHGWr3C1jsg3eDjGriiK9U89NYsFAF4tooG01T+hkLKfUE0c4S6lZ6hKc0KpoZS09cUUU6qwsAKmgc/tFtvZaVhRQP2Sybv9DwRWCti89QQdCrt4WBQFln/EzOixrAUNZy8FUZD5Lh6euyw4jIqtq+/Glm+WdDOvcO6OzUUud3BrG0L49Ku6XdCjJF3p6RWZ8ZVCSDxniMLtuELl499/ef8SIoC9IoEHnZCtIWoqeUxd05AfxuYx3555UfQ8EDUNF9Fl0+EJXqnX5LRjjaTm/WAV2RiLhc5hH8NWy78IUxOEiZzText5ocnMH8/ySphihjPFmy1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TCuDF9HHe/LtbtWqau5OaDKm1HsrKOZvCC/dWWil5u8=;
 b=yIcKrct7nK/g1IHOgF2ViG6J5lB1GpMRlmb6Owrgs/w6z8J2gAyXUZAu7Nzi070dvV+TA8CXEng3yWx73eGwsAJK3C5w3Rje8CQYQyiijRiYxfwFL0xJiXeIkEP8DGoX6q3uv4U+xJk+go9B3TqBlUjt9e0lwr5Jj64/Awqj1oM=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DM4PR10MB6789.namprd10.prod.outlook.com (2603:10b6:8:10b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Thu, 16 Feb
 2023 05:21:36 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::6d82:720d:3596:839c%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 05:21:36 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 10/25] xfs: fix finobt btree block recovery ordering
Date:   Thu, 16 Feb 2023 10:50:04 +0530
Message-Id: <20230216052019.368896-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230216052019.368896-1-chandan.babu@oracle.com>
References: <20230216052019.368896-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCP286CA0117.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:29c::15) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DM4PR10MB6789:EE_
X-MS-Office365-Filtering-Correlation-Id: ae7c98ed-aa9c-41b9-ac0f-08db0fddacd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QFJu+OK3Pk64mRGLpmXgzSnbZKHhG0PCkoEm7bpiLAnbvq+/xPlzNEkySFS6faWdZdL3BRl+hxITitVZesJLP1/j1tyQRVKUyovhi+IKiCsPb0lhLALTFJpV2ELj06qk7OTGm24WO3QeRmqqEl4KDR65Cv09e0093XwajL1wF3M6RV58H/NXTW8JZ1yGhlQkWn5ufquXOj/A8bONV1nLs2rOsinSKfYkWmGiQUtva8isDo5j5H0X+Th2PVBEeGYqKpTRQk4Qhk0wN7p509WIBUXVRWXQNngDKHbJvUHP9jTA4HRVrOtQHd9tMqJWq5THOqx5khdAeNgmG6rhmVeRQ6RG6FqcNDe5ZWQyK0G+jqtYpiKU1TF99YlSeR90DPljRLV9o4S1n9YLlH8ykCGXW6ceDYv4irIapr2yMP5VBAiAnLQpqW7J6wKtcUQEL6xInX1KUWmp9t6EILHnJPnxwd2Q49o6dejHGxFxb5HqvHLUiDWGeXpy6Ch4R+WqtjbPEzgL/hOJL4kpagJhJDe3c3nanw+hpMtIQ7nJ9OW1rvOtoBOTgEp6vu/NYZhE8WnspWyMTv3BbavELm3N/+PRJDaMcFJ/LKNMrkZRowa3RxPAhS6jYAXORF9Uzi2CQoZb3249YdAwUCwRCqWMLdpURg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(366004)(396003)(376002)(136003)(451199018)(2616005)(5660300002)(38100700002)(316002)(6512007)(6486002)(2906002)(1076003)(6506007)(36756003)(26005)(478600001)(4326008)(66556008)(66476007)(8936002)(66946007)(86362001)(41300700001)(8676002)(83380400001)(6666004)(186003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VYB1aieSq0ivW/3rvuinu1bJj3AyfS3bn7s3Vm1XHCcHEeuuXhkCnoKTW9Py?=
 =?us-ascii?Q?QjvsSV+vRT8gfKbOFKLVuVN5X3YmZMDZNoYsqCxfJMrzwjR+xr+4AkGHT7s5?=
 =?us-ascii?Q?Sn9lbsSAvpNJQ0OmEEOA+caSrv/i46ahCidAikat+JkIgfPl1Fg2YBo++i2f?=
 =?us-ascii?Q?c14IdPOA8fC7wDaO+QmkJjZsFjYAPZ2vyLWJuw8PukTOxFCtxX0YRO3Rgk9g?=
 =?us-ascii?Q?uGmvHlCjKCv5WAak7dDejUdqEbgk/cm1u+hLEENx9K1QqzXfnfmQhUaL/Ap/?=
 =?us-ascii?Q?gKW3M24qOyIeqSSWo49xDbjFd4QNW8ZuF7a7DsiJ7JXh5fUw4QtiA0cCpL41?=
 =?us-ascii?Q?ndsrIrA5UtD/isOkDrEeuSwwChTyLKcaXdvHAQiGfAVcYqGBTgVOeS+M62bX?=
 =?us-ascii?Q?SfB0L6k2D3EZy0SInPasbAsp7pHEWWC5c3owLnHOA3u7BTzmJx3tUJzeNfAC?=
 =?us-ascii?Q?S3Bv87EfFoIS8ClpEi8+iTiw0Ra5p28ErCILzB2rmQMUTFjOwECX8yRYFgnD?=
 =?us-ascii?Q?Vx8U+ue9s5Of+oykhXqayy1gWFsFRYMYqG2wXfOOAszFB/na/LyPmQVrj3zJ?=
 =?us-ascii?Q?hoYIO/pLAJesIEoveaj38gpxNBqopfd8oV5Hv7o5XrbP/1ZuXcoCCVSFqP+P?=
 =?us-ascii?Q?0FxOJfBYKpJikfw3M/2rpb2fVi9/k8oAJNG7A+5tO/90gr1MpypOqb49gK1b?=
 =?us-ascii?Q?fR3piRTQg64+ulfj7eTnGlZbVERIm5yEN9LOiWWNLoTFYfKtj1BUIZ+ug5zE?=
 =?us-ascii?Q?OGlaCgzhS7+USRA3sycT8aMowv/2321fh1mmMcYl7/7xnO3BX5jrDet/iHAQ?=
 =?us-ascii?Q?oG5FhuZB1aGpcNWdxNkuMxph/4ycqTPRT91+quIP0uHdo2auEWRfO8RxkX0Y?=
 =?us-ascii?Q?H/FKiBJHOns5ZzdkoLLRcxkyrG5WqR++MTwYsqlCNgI3R0xOaY9UxpibC3LU?=
 =?us-ascii?Q?KaDtoI8H9Y0Wqw2/17sXc+icP5SmOfxDMwDwj9Bd0q9VSiHgXkEQ0VtZnIV3?=
 =?us-ascii?Q?ERt4JIJBWjFMX1QF+u6V8LLCWEM3Xq5xDFqYiPqxHLSTIKtZNUVxySN1r0Zl?=
 =?us-ascii?Q?JUvhxN3lYIT0jTkagp+VqyzddEuysGkg9HHOEBcg8VPHMfxpc1V/PWm+Lodm?=
 =?us-ascii?Q?aoEa5obZ/552HsxJBcvTLWSgotKXEH0uT9vfqIWljhClDdLUKOG7/pjhZhS2?=
 =?us-ascii?Q?oBLInRn4MJU3OLd2YQgyD9ivd583+3N7k8pGYu0Lq3G59YgpclKerOLKz3Fd?=
 =?us-ascii?Q?FmsvqIQ0hDRU/JzA7ojUQU5qlCHCBJzi2+Lf8foNaN9estcdyWCrIjcSAv8N?=
 =?us-ascii?Q?/idL+0oXbbzgqbfx3IrtNlkbuEummjFJqUtlPQk0c/fvkqnj6tIyvhvvMi4R?=
 =?us-ascii?Q?+i2jVASD0/Z06Z+/OSxSwDhoMeULNkhlfjrEXmW+OhndT/bsplXW1qNWOcJ6?=
 =?us-ascii?Q?5jCy17zvxEvW3uYV34tROQRu20vofQt38ypmHukUgOYMnxso6HYPavMTic0H?=
 =?us-ascii?Q?SNVv3ZHeNcK458E9CdhNgif86fj6ggDNDANNh5czerMtE3dkEPlVJunz4Mpl?=
 =?us-ascii?Q?uzDK0Vw/3I6kG0tYdBB484s5+eRNZwJSrB8Ah4jt1NMKoV2/HAMkH3vv7x0L?=
 =?us-ascii?Q?qg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: hu/ZWe2CrzWbG9hURGIAO1IrvlA58vVgK2PnUdWxYIjN/kJOzywFX9GEPK7KyllTaH3nnuUyO4O/DQmHUw62a/qnyfLbI2UF2z0LB/vQK3ljahjUHEfOoRVxOYZWbyXfGivQH8+0xISeOpj0mDmGdMwqg2ebog2iRYcPsU/Ujbyx62mDnhm97hnFLVvHca2yBKBFg96enkGFYt96vnYbqo44/5R6qDuCjhJn/D6dwiQh9NR4m9vYT25c47Q5LuB7jTA5qv+zsVIaCflaPtdXgdJ/whimisH2P3Y9oPLK8Hcs05XOS0bfqXhgG0zo2oEUCpux4YJrsFLyjqbzjNNdNGxUZfnYyefZ6mONWjPYBuBwqYMCoFZjhssxZS/DpzxYBoYgT5sQRhaC9hA4Jtf0rpeq7m/8EWB3OlsXdDY2ULDUimKRajVGj7akmfO+NQ8Dqv25G7wSN1YXlN6zAa32QtA+lW5wbX7l2uT7GY2KuKSEApHECjp9jwOx4gsAgGB1DKfgrryGZMWUYNh4wBvrYoT7GgbELndQNQUyQ7Hi3NZxZHFB09H6ileqoX67guAQ3aLeDchahujNLmxosQYFlCo4avWaYeky4ziGH064MwfmKVZ8Q4p7eOQ7gvWpJBOAUltVRX63KvRo5n6J+HKGjNcAsmZAlFgmFGlaAhtrfwGRvLl26Hk4QcrE8n053nr/eRAua13lPftEvhgrt9hHN3fyhvfwkwumlN9K+ToUU5mEszwaLciO6gr0VTqldTM/dYEwcGWAm0RSfaS3P2Wy/7gYZv4vAWamKmNiEttX2X3iBLMjxBvYfLgbxLtu6iPKJJ9tDIpdmk0mDKfFKVfnMb//dSkzssMzbEZPXL26nzuP5ishR81B1OtFe4jq0nbh
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae7c98ed-aa9c-41b9-ac0f-08db0fddacd7
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 05:21:36.7405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ESb3YuTBDa0cS9DIBn/Fk/q4A0oxXjLqKzJt+KB5onlM9xWqkKglQLDTV6qqxcyixRCElI1eW2A7xMjsPDAwig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_03,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160043
X-Proofpoint-GUID: qmYp_NC8CyAFMtzOQW3Cuo1iLJi6dqyN
X-Proofpoint-ORIG-GUID: qmYp_NC8CyAFMtzOQW3Cuo1iLJi6dqyN
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

commit 671459676ab0e1d371c8d6b184ad1faa05b6941e upstream.

[ In 5.4.y, xlog_recover_get_buf_lsn() is defined inside
  fs/xfs/xfs_log_recover.c ]

Nathan popped up on #xfs and pointed out that we fail to handle
finobt btree blocks in xlog_recover_get_buf_lsn(). This means they
always fall through the entire magic number matching code to "recover
immediately". Whilst most of the time this is the correct behaviour,
occasionally it will be incorrect and could potentially overwrite
more recent metadata because we don't check the LSN in the on disk
metadata at all.

This bug has been present since the finobt was first introduced, and
is a potential cause of the occasional xfs_iget_check_free_state()
failures we see that indicate that the inode btree state does not
match the on disk inode state.

Fixes: aafc3c246529 ("xfs: support the XFS_BTNUM_FINOBT free inode btree type")
Reported-by: Nathan Scott <nathans@redhat.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index cffa9b695de8..0d920c363939 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2206,6 +2206,8 @@ xlog_recover_get_buf_lsn(
 	case XFS_ABTC_MAGIC:
 	case XFS_RMAP_CRC_MAGIC:
 	case XFS_REFC_CRC_MAGIC:
+	case XFS_FIBT_CRC_MAGIC:
+	case XFS_FIBT_MAGIC:
 	case XFS_IBT_CRC_MAGIC:
 	case XFS_IBT_MAGIC: {
 		struct xfs_btree_block *btb = blk;
-- 
2.35.1

