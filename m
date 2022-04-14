Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6A8501E4D
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347031AbiDNWbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347025AbiDNWbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:31:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550872BEE;
        Thu, 14 Apr 2022 15:29:22 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EKFdKH031973;
        Thu, 14 Apr 2022 22:29:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=VXhvYgHCI8teKTC0JpwFjQ0ZxEBrqYZP/5krj2OwKvc=;
 b=Q36nmzmqI1qxu1Jw41yILPRh1Kq+3ZnXh4Ku9JynwmWxbB6MZaOVyBBsuNfJaFVI4Up4
 6MIgFwpTapi+f+cAgb3m/BZqbYX0kKVlhDludReiXxDd3DiH8chehGG40Hz4KAXoPEKu
 rxfrNGhOZrajlj3+VHg0aJ02kvDGFj9GHDJf1KE/bcBvxZnspIbrPjZA1x96ZM0KY7gi
 vxcHaL/DYGg2KyqE6SXP5hfBKf8ltFrJCqClow2u3evmguDvs10jsTCmrlKIE4OagY0Y
 eLEz3swSncxBCs8SYP1kr3VLMoSGU3c3Arlf0p4BhrkwJWtiXyX1F5QeWH4cS10GsG/w rQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0jddp1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:29:20 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23EMHW6x014857;
        Thu, 14 Apr 2022 22:29:19 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k5uc46-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:29:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGQZHDK5zWGY9bellHuyHNLL/+urLn3i+4GIbxBm6u7Ef/V3S2CEILidLazPrGIEc7KKEd9PuF8WXRdDH1wXyfc/Fk/EL3KsaVqVMwHJci8yawtLD6a65GDVdbVATAs5zJ2GPyrrvtWSfYZQqy93DpCemJGn7b/qjd5C1DLGqsdnNqbs92lrUfIJDEpRn3Zb6MDQ2UQZPpjGOJ7aDsq4PvDAKXmdyIsz1coeBUGzMdGqT26gU1VFCwirQRzY81YAaPOpNmnNRBp+Cfi5OeFCk32Za20RAkhmfeDzHKm9bnCfE+tpXJ1ATOWsdpl5e6EyoyFVX0/D+Z5y1oRJzcrXvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VXhvYgHCI8teKTC0JpwFjQ0ZxEBrqYZP/5krj2OwKvc=;
 b=X7UwtBxkycRJFtWHj2nyeGA+bY4v1W9TJw4+DdeLm+c4mkNhDOcRI82fUt/o89TB3prUX57MVwow8JGVoch1C01qdAOSGi0DKxkGh6KJ4PKx2FLMwdBSlM3iFL9/kqBffLsz1SBikPPMLD5AtZjLXRlLNBSMYoEq+REDK+wFooA76Kn5Xp34lCoH1iIUPDGqc4sGc4dxibZt5+g0+eH4HEQiEDQhVhVMvcLvezOi83tQqtuKzmVN1pHXk8U1DpoSmkF36MDFwitK40XaejC5be8awKzp91hygwjlal/UELdFRwpfS8xqBkPMVyLuOLlF7/LH/Cbo21BdpWlHZbNU9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VXhvYgHCI8teKTC0JpwFjQ0ZxEBrqYZP/5krj2OwKvc=;
 b=X30shtu4ZyNvlaIY9S/mpfvTd0pWosim+CzgRkeJgjPuaAqHtMcZH7jhoaQxsF3NFj2Bhy4lCCZBA3TQbThmHboAki4gyi9Dx1Vt7Pk1s+McjAX2tABMtxSE48wwyoelYMstupfIX7M3kzzgRMT9jKNjLpCOoUc5E2WJ0AKSn3k=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by MWHPR1001MB2094.namprd10.prod.outlook.com (2603:10b6:301:2b::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 22:29:17 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:29:17 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v3 02/18 stable-5.15.y] iov_iter: Turn iov_iter_fault_in_readable into fault_in_iov_iter_readable
Date:   Fri, 15 Apr 2022 06:28:40 +0800
Message-Id: <2f18cef5634943c5bcd007b3753c3839feee9bd9.1649951733.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649951733.git.anand.jain@oracle.com>
References: <cover.1649951733.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR01CA0018.jpnprd01.prod.outlook.com
 (2603:1096:404:a::30) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1973e846-b578-47ad-cb2b-08da1e66362d
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2094:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2094C41A281AB46E79E2D366E5EF9@MWHPR1001MB2094.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uEqHMYWi2VxifOcm85KhbJKqGaqxlSMNPzFND8Eb234sBHJGr0lCwRaNoJNA9jWM6Ebpvu/gNyDVhRXVeIQI71qGGYkKKG8OHKcjP3SWEG59aOUxmv4vWgA/meVzTtGJo+xGBxfzUs6/VkCdItMI+gRcrSyFfGaL0Bkb2NAjMriW4hjZRDTRWeEcbzEtpN87dIkIogRkYUSj0TGgW4kbrz136K17dpbK3KhJpz2VHJFPY/HPBFGO1FayCvzSH7JYpOqX8zAWwNsXv++A4jNFtG/afQIjOnHglcxenRaMWTinPT7S8t+zBMNS/MasncQ8p3z4tjY9EuT42srBrYVrFHGHoe2+qkFEF7u4GMp7pp4BHnuDe4rW2LwUGU8l+wHAadi0MwXYBVpTyr+MdhTOsq4HwzLYsbbq4Jaa2EuzwiG8Jr/dpGbBNi3zfZb9RKopar9/eiUNezuyWqnMDlM6z5+o0JMQRn+tysPiUAB27hCoSX13lDxjs7W0L6N9ntfWxHO7E86+1r7xiOgNPTLMk7kox9u5bvL35AFx+AZEZFOKG2Zu0d8NXB9KlyjUH0ADG95jz5gfP+fwyKAttJ73nwG7rEIEUTwnbGwzTmOHLRkkk+x58dpMd4Uuki1/OGtrA0dCpUE2zCcjvz0yXtuHCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(6486002)(2906002)(86362001)(44832011)(508600001)(6666004)(6506007)(6512007)(5660300002)(8936002)(54906003)(316002)(186003)(6916009)(66476007)(83380400001)(66946007)(66556008)(4326008)(38100700002)(2616005)(107886003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lqn+tZVBck7wNjXXtQ8xAKysJIjceLZiUNa37o7jOue7fCSlOJFlNMmJh6Vm?=
 =?us-ascii?Q?iZ4sNn9fgYLyRtUY7khnoShOMsYmDUvHzI2NWPcV0mRF6bp6ZML7u7kw3YdI?=
 =?us-ascii?Q?hbdrtRLIM43lo4tnsS0Cs4VdAFi2hgqeUEhGUlcOJuExWPHMt9gjJ2Q/1dMK?=
 =?us-ascii?Q?H/3d5qn5SCd5Wo3Meaho4/GPqfse4jeQFFRLtv7tmLM2N8ZKshGYcF5rKu5b?=
 =?us-ascii?Q?AgUZEZrnl+9qP1Up+sylP0FwBed3CMgiOHefucbehH0OuSjwTOBcB4gJ6IyX?=
 =?us-ascii?Q?io/9KIfTY2rWzkKshtA23VRFtEcnSHMAei169ZPQ2Nr9j9352mxDY91px272?=
 =?us-ascii?Q?u/eH2T2xbmmDh6pdfH80cWUy3VG+aChv7hyUzhQebOu32fTs2HyxD16Zfcr+?=
 =?us-ascii?Q?knJpiRpc2WMJcmXz5UNGUoqJCEuIWCC0JVJ+yyAUGenkSvmhmnerI7e7DaUG?=
 =?us-ascii?Q?quFXlUmNEZUbH1mdm4oyBuoZt3MCcGy7moYISjrVXOXeErjXigSRMSOMLSGI?=
 =?us-ascii?Q?V7UTayzwSftkI5spcpLmOvs6vLJfRLNDPdJ5L35ey6vjDlK0n3Vh6EeEKOzB?=
 =?us-ascii?Q?csS23Av8fU2vVpz1ejcnZEwBBkQLmhZEpLQSTqrchd0jx3BzgyetPK0kIVMS?=
 =?us-ascii?Q?d5MxAtw43YjWJwjNxQzE3XXszgPOKy49vDwhnnDdTARffdd/QDM4euddRg5c?=
 =?us-ascii?Q?1t8eI+f5fold2UHnBxc4gtkb0e2tuF/Xp5sh29D9ULXcWPfVAewdgvxbEq6R?=
 =?us-ascii?Q?LPgCT7HwXablBtOq2kbfqtY+WLfRVecmwafAF6f6zopxayWckBOQJhtIv1kg?=
 =?us-ascii?Q?ExE9RjiXc+smw7zxde3Ikt/jXolt+GPzm0MpqgQCantbWHLf0byK9I7TC2MZ?=
 =?us-ascii?Q?Fbg3QzHDoKDi4DlgLjaTiwzCOXN9eG+p+7vRRa60qGcAXincfaSLxW1WCcIH?=
 =?us-ascii?Q?VbPtWO2FZqL1JTs5joKYNxLNdeT6ELPm8kfi3PemZCq7h8Hagu7l0RJtFIa4?=
 =?us-ascii?Q?BxggHT2+HcTIeLtsgoh3+NDUMxbgdZykGy1hgXmisCBmkAko0f/Z+SA16N2m?=
 =?us-ascii?Q?ISwgmNUJqRgAe1UvwpR34BcTtdZSXeVIhljEBTq9rr5VFWbZJhiWD3aCdk3p?=
 =?us-ascii?Q?79htfBILAgbhTQjbo5KgDgc2DDnFoKfSoJHhuLwlA6pXhNYIl0ocmMNKK1u5?=
 =?us-ascii?Q?2flvO9a60IAxqyY7FWzPOPX/ls4IBHDtzeOXZh2tz6jCiSwZ5eEta5ahQrs2?=
 =?us-ascii?Q?R9qS1Ii5KrxT+Vx6587qwlFHDLVE5XIpXu4HrqfwjoS9gadNFeaCndD2hFIB?=
 =?us-ascii?Q?3oYEgqQjrm0s2/tip7WFTJ5yI0y3oMZogVffHSZ14cxQghSTFjbK4JHAiEqM?=
 =?us-ascii?Q?TqeK1InCbbbEuI80ElfrB4fyXeb9qwYH6WXdSUpLjGKfSUiZYRHATB0qwqic?=
 =?us-ascii?Q?4GrkjNkf8kDw2345DKHHbhwD2Tj1eryAGc8IZ61kpI+TsDnTzCbqo7s1TFSf?=
 =?us-ascii?Q?fTb0oIN4iWWcREcSA+S7ZvgMqqe4tkLTBa/N2Bxrr/ltbtYz2goG15bzLqHP?=
 =?us-ascii?Q?CkJW7w7KsAF1MnAuou9emWNL+7a1DinpwOwkPPs6DyAzwHa+7DuhmVCOwcui?=
 =?us-ascii?Q?2MboAaP6Rsfx9Y1rFskqGuyeolrRA8+jx0iqjrZAxKEm6Sg/3CeiBwyWnjUb?=
 =?us-ascii?Q?Cy8iwG/d0rGqfuXdFfYIBmWAEnec4SipifaB52njtmCxwZo3WPB7+zI626/S?=
 =?us-ascii?Q?lhQVLZXEKK6EINYmv/PgrZTkyDBlY5i4Ki0wL7JRAlXn4X0O52Br?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1973e846-b578-47ad-cb2b-08da1e66362d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 22:29:17.2533
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E6VTCrn3pk3BO9xMNW7bunZHGBnDxYCCcu1UfOSdYOAU783/NFfApLVpCYM16rNtEUd0up5j57Nfg+EO1BsvMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2094
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_07:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140116
X-Proofpoint-ORIG-GUID: DSJ13krJ9h6NiGKMuaM4MKtdcbI0il08
X-Proofpoint-GUID: DSJ13krJ9h6NiGKMuaM4MKtdcbI0il08
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit a6294593e8a1290091d0b078d5d33da5e0cd3dfe upstream

Turn iov_iter_fault_in_readable into a function that returns the number
of bytes not faulted in, similar to copy_to_user, instead of returning a
non-zero value when any of the requested pages couldn't be faulted in.
This supports the existing users that require all pages to be faulted in
as well as new users that are happy if any pages can be faulted in.

Rename iov_iter_fault_in_readable to fault_in_iov_iter_readable to make
sure this change doesn't silently break things.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/file.c        |  2 +-
 fs/f2fs/file.c         |  2 +-
 fs/fuse/file.c         |  2 +-
 fs/iomap/buffered-io.c |  2 +-
 fs/ntfs/file.c         |  2 +-
 fs/ntfs3/file.c        |  2 +-
 include/linux/uio.h    |  2 +-
 lib/iov_iter.c         | 33 +++++++++++++++++++++------------
 mm/filemap.c           |  2 +-
 9 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index a1762363f61f..5bf4304366e9 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1709,7 +1709,7 @@ static noinline ssize_t btrfs_buffered_write(struct kiocb *iocb,
 		 * Fault pages before locking them in prepare_pages
 		 * to avoid recursive lock
 		 */
-		if (unlikely(iov_iter_fault_in_readable(i, write_bytes))) {
+		if (unlikely(fault_in_iov_iter_readable(i, write_bytes))) {
 			ret = -EFAULT;
 			break;
 		}
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 0e14dc41ed4e..8ef92719c679 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4279,7 +4279,7 @@ static ssize_t f2fs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		size_t target_size = 0;
 		int err;
 
-		if (iov_iter_fault_in_readable(from, iov_iter_count(from)))
+		if (fault_in_iov_iter_readable(from, iov_iter_count(from)))
 			set_inode_flag(inode, FI_NO_PREALLOC);
 
 		if ((iocb->ki_flags & IOCB_NOWAIT)) {
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index bc50a9fa84a0..71e9e301e569 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1164,7 +1164,7 @@ static ssize_t fuse_fill_write_pages(struct fuse_io_args *ia,
 
  again:
 		err = -EFAULT;
-		if (iov_iter_fault_in_readable(ii, bytes))
+		if (fault_in_iov_iter_readable(ii, bytes))
 			break;
 
 		err = -ENOMEM;
diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 97119ec3b850..fe10d8a30f6b 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -757,7 +757,7 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 		 * same page as we're writing to, without it being marked
 		 * up-to-date.
 		 */
-		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
+		if (unlikely(fault_in_iov_iter_readable(i, bytes))) {
 			status = -EFAULT;
 			break;
 		}
diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index ab4f3362466d..a43adeacd930 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -1829,7 +1829,7 @@ static ssize_t ntfs_perform_write(struct file *file, struct iov_iter *i,
 		 * pages being swapped out between us bringing them into memory
 		 * and doing the actual copying.
 		 */
-		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
+		if (unlikely(fault_in_iov_iter_readable(i, bytes))) {
 			status = -EFAULT;
 			break;
 		}
diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 43b1451bff53..54b9599640ef 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -989,7 +989,7 @@ static ssize_t ntfs_compress_write(struct kiocb *iocb, struct iov_iter *from)
 		frame_vbo = pos & ~(frame_size - 1);
 		index = frame_vbo >> PAGE_SHIFT;
 
-		if (unlikely(iov_iter_fault_in_readable(from, bytes))) {
+		if (unlikely(fault_in_iov_iter_readable(from, bytes))) {
 			err = -EFAULT;
 			goto out;
 		}
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 207101a9c5c3..d18458af6681 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -133,7 +133,7 @@ size_t copy_page_from_iter_atomic(struct page *page, unsigned offset,
 				  size_t bytes, struct iov_iter *i);
 void iov_iter_advance(struct iov_iter *i, size_t bytes);
 void iov_iter_revert(struct iov_iter *i, size_t bytes);
-int iov_iter_fault_in_readable(const struct iov_iter *i, size_t bytes);
+size_t fault_in_iov_iter_readable(const struct iov_iter *i, size_t bytes);
 size_t iov_iter_single_seg_count(const struct iov_iter *i);
 size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
 			 struct iov_iter *i);
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 2e07a4b083ed..b8de180420c7 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -431,33 +431,42 @@ static size_t copy_page_to_iter_pipe(struct page *page, size_t offset, size_t by
 }
 
 /*
+ * fault_in_iov_iter_readable - fault in iov iterator for reading
+ * @i: iterator
+ * @size: maximum length
+ *
  * Fault in one or more iovecs of the given iov_iter, to a maximum length of
- * bytes.  For each iovec, fault in each page that constitutes the iovec.
+ * @size.  For each iovec, fault in each page that constitutes the iovec.
+ *
+ * Returns the number of bytes not faulted in (like copy_to_user() and
+ * copy_from_user()).
  *
- * Return 0 on success, or non-zero if the memory could not be accessed (i.e.
- * because it is an invalid address).
+ * Always returns 0 for non-userspace iterators.
  */
-int iov_iter_fault_in_readable(const struct iov_iter *i, size_t bytes)
+size_t fault_in_iov_iter_readable(const struct iov_iter *i, size_t size)
 {
 	if (iter_is_iovec(i)) {
+		size_t count = min(size, iov_iter_count(i));
 		const struct iovec *p;
 		size_t skip;
 
-		if (bytes > i->count)
-			bytes = i->count;
-		for (p = i->iov, skip = i->iov_offset; bytes; p++, skip = 0) {
-			size_t len = min(bytes, p->iov_len - skip);
+		size -= count;
+		for (p = i->iov, skip = i->iov_offset; count; p++, skip = 0) {
+			size_t len = min(count, p->iov_len - skip);
+			size_t ret;
 
 			if (unlikely(!len))
 				continue;
-			if (fault_in_readable(p->iov_base + skip, len))
-				return -EFAULT;
-			bytes -= len;
+			ret = fault_in_readable(p->iov_base + skip, len);
+			count -= len - ret;
+			if (ret)
+				break;
 		}
+		return count + size;
 	}
 	return 0;
 }
-EXPORT_SYMBOL(iov_iter_fault_in_readable);
+EXPORT_SYMBOL(fault_in_iov_iter_readable);
 
 void iov_iter_init(struct iov_iter *i, unsigned int direction,
 			const struct iovec *iov, unsigned long nr_segs,
diff --git a/mm/filemap.c b/mm/filemap.c
index d697b3446a4a..00e391e75880 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3760,7 +3760,7 @@ ssize_t generic_perform_write(struct file *file,
 		 * same page as we're writing to, without it being marked
 		 * up-to-date.
 		 */
-		if (unlikely(iov_iter_fault_in_readable(i, bytes))) {
+		if (unlikely(fault_in_iov_iter_readable(i, bytes))) {
 			status = -EFAULT;
 			break;
 		}
-- 
2.33.1

