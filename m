Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D979B6537D9
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 21:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234805AbiLUUwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 15:52:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234858AbiLUUwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 15:52:30 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69EA52189F;
        Wed, 21 Dec 2022 12:52:27 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BLKckj1011862;
        Wed, 21 Dec 2022 20:52:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=rgLtBc1jChkoSmxOGvJiGZb3/CWEs1UTpse/u1aeUKI=;
 b=KPeAOcCQRpidqvJ5rcsihNLZso8WADZBWzOGeQxyPdgDYIiWm3+YpdotqcVQkfuIcBc2
 wdI1/fBs/ARYpZll4TGJrZmtNnruE81oTRc3WpYNXr5dg4D/am7YkyvvZBgCfj5XpNgO
 eKwDwm6K8YiM3bsZ+zmUhHiXss24Ebb5rhPQJkxiN05oK9mJ8THcI69DQVd6zUIPVRdc
 V16Jwf40TS6mxdy2u7IdGcMN7jNE3L++QtGsfunGihOlm8rEeeJVlktMpL+iY2BKDIxs
 aow3cuHTV0Mx0aGBQjwMrwsDJFdEkT595BPCRIIsLHSh5sz5eKJ6atEKGGlqThNrdY+i qA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tn1uh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 20:52:16 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BLJJUZ2027656;
        Wed, 21 Dec 2022 20:52:15 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh4773u3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 20:52:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L2tV2wi6fCxrb7SqzfamWAIOEtba1YLOQil0p+bG9t8PSgtkU3vHSuRsoIwcBPmQUdvRwsse+q042h4XfMk0VPZwARsqdVgmAS2fcpHCnQ55stSIbXxWgD1WcGZOpo72rth86tpA3lANiKrZLOZkA1fSfBGG+fnGblVFfn586wU8EsPhp3/BY2kNAVDd2tkViUEk5WoibHpWsKyv+ZneUFW6GvwoLN2vnke2acjjXZn4tiqHxIoRYM/c2U6tK9z6aYkbNN4QGfyO7usSpcoTo9/xt1VYfuYIpZ31/po3UF28sCqs8QoQK/FTqqgNt8nMPWQFSMwdfKJF2TPsduxtIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rgLtBc1jChkoSmxOGvJiGZb3/CWEs1UTpse/u1aeUKI=;
 b=W3tApmWYKIHoEPbZM3mAWUXF/WjpCoQfq06NExLHq2EQPUckiebilNDXqhSaAhPqJFccO+3Sc6UeU2QGBHEzVgZvCMZJXb6ARuoAlEBACh/sp7uKf6XY2PnAIFtuDrywK1UrkdjsfDXPoYwHbRVmUOpqEPBpF5jHhu96qszqk3ro5wDyKJNbqXjFAnQrRXxjZRLgooEX+7XMNo+lzzv7R4k/QJzHzHDlaUdthnJRhayKqXflk2Ua/H8yF8X+seM8zuBYI+zkxma1VoeSLnTPylHQ56tTaQ0Q0dO3oqX5uUAQJ5BSFAoYNhBefQMfqGK6eVMhsSss+Qx8KB53jxBaOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rgLtBc1jChkoSmxOGvJiGZb3/CWEs1UTpse/u1aeUKI=;
 b=k2a50zcY9PL4Gh7OmPdynhZ3V+JnnQS4RUdxjzDm7H2KnBAIWorC8jf+kBusUWGvw/8dBkq/R6GbgQT6HsjJprtexb3sSimjjuC9H7ZhuJi2I3lvCdUl9uilgiXA00RHkXw9vaVh5nybIjai/PYnKmWsyw/e5jwaozDYJB9dIsw=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CH3PR10MB6883.namprd10.prod.outlook.com (2603:10b6:610:151::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 20:52:13 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0%6]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 20:52:13 +0000
Date:   Wed, 21 Dec 2022 14:52:10 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH 5.15 5.10 5.4 v2] kbuild: fix Build ID if
 CONFIG_MODVERSIONS
Message-ID: <20221221205210.6oolnwkzqo2d6q5h@oracle.com>
References: <3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com>
 <Y6M090tsVRIBNlNG@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6M090tsVRIBNlNG@kroah.com>
X-ClientProxiedBy: SJ0P220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::27) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CH3PR10MB6883:EE_
X-MS-Office365-Filtering-Correlation-Id: b550bffc-76de-4c65-421d-08dae3953c68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L1RizwU4Ry8+nhcLXjsl9Ql2CKUF5696bI34RocvoMnAOCTqcgnTFogrh0+FeyGAYT+KHSvKfsdH0CUjKYo29tHy+eqbdW51PsrJj4CK+XHEcu67sEKbNRH4t/1a/laSzQZcGIbToGWrqt4vBKD/kvxOXYxcHaFhtUcNbaoR3SXb6rwFqTdJlS+l26t00JJo0kx+Byqgajil2vTlI4SoSDkGugmdNVEja+UKLyM0THAj0l8evhlsoM41kFtaosg2oqtDIuwFD3nmxyqtPXfKE78c6Sny3SVU8OUujN0UVR5s1JLBqzBeqS441tjAqqnf94nPqd33jsZ0TWTFrHpP76RLT6xxw0KxWrFLKtbvAGhAB75E7dhDRxTmZHW/pnrk3OPqXy30HDCYutAtOwxeCiEgzFGlbL9QHx+6EG7FqPijFVqD9nvZQDAfhUp0rc+nXcj/OQy2Dbmc/3rVytxLdZWXvARJl8yi9gS77sIrGc4KENul1ftSm4hDss6YjxaStqaVpHVr/7teycPKv5VICBP1Uwzvr16h7RXU/kzg3fMVyhOFUIT/GZYZ5LpQGdl4EujHopvj6De2nE1c9lQ6LhWyXe6KyH+Hg9VLgmYgm32cdpKMMSAwq2RF3iCrK845vXAnR2zkmmXDToRRUmiTIB803WYHsXR7dTJfhCGEf68=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(39860400002)(376002)(136003)(451199015)(2616005)(1076003)(44832011)(6486002)(966005)(6512007)(86362001)(316002)(54906003)(6506007)(2906002)(26005)(186003)(478600001)(36756003)(6916009)(41300700001)(38100700002)(8676002)(66946007)(66556008)(66476007)(5660300002)(4326008)(83380400001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4YRHLXxQVZxsb4Gi/2CP5peNRYF7TqayAL1595qi73Qqjc2LPaZEL6yiEeFZ?=
 =?us-ascii?Q?WTdgIG5kyPvJmb6YlNMyHUbjDQHQ88rg1YtQ7iPF6pdCHgGPj4jl2T+GDtED?=
 =?us-ascii?Q?WaKT7rLj/QUvxaAKWFx0R/Yolgtmzi2PGXEIp7dVHxdfspZF6HJEAkJQPUU+?=
 =?us-ascii?Q?ky43qClmnWZuon+1vwBIZ1tdVroBOZTuRGRJWLqkd3ZqEmPV0QGKX5rdOQ/z?=
 =?us-ascii?Q?z7jdmEGYWbNxgMnXcPVrwACdhdY9jb1uIUOjLfYTHtb2pm880uSpQuSV0+zo?=
 =?us-ascii?Q?cUF+ISIh5bGwSGYl1Nm6m4X+S+B5veJ98c6NDUmd0q1an5lADMtVs+JwlSid?=
 =?us-ascii?Q?/DlAMIgu7/w8Ew+tVcLIgouHOWPu8BlSXcm9LjTXPdZIbwUyIsEJSJPDAaWP?=
 =?us-ascii?Q?5JLVsmzfXFDgaWnvUEaDx9hBuiG3MEDpcJmtMdWRtZMiwyXtymfzlBu59bPg?=
 =?us-ascii?Q?pnRPP+gZpgJiFP3+JAL1S4UcAUqLR564dUM0xgTkFX4dAZA7P22xhyIdlMxb?=
 =?us-ascii?Q?Owz9TygiaDN4/R1mwXVKdOawkontJ9ztZ7ARUu8aKDftlXR/999sOUnU0g4/?=
 =?us-ascii?Q?NgzUZQaSV3M1/TfDILljG0BZaZLOjk4zG0WJL5+zGkwDuJ//dv//TxaHXuW1?=
 =?us-ascii?Q?G4iZQ/wPwSZFUSZY2gx0JKyTUK4P1jYvuzI1halACbaggvuFikhaVYXpkZ/3?=
 =?us-ascii?Q?o2HDi8Pp3VNT8xdPLTIq992Z9oooX6/OrB7TIm7rSsSEVSeiDkHNgViV5+si?=
 =?us-ascii?Q?A0GlG8eZAFT4LwcPxOhgTaM8dcJX8ZB/BuLuO8esEbmqqu0HNsvgAWgA0v2m?=
 =?us-ascii?Q?0aeD86HR0qAW10PnfC1ghOn36uZv4ZraTFcXEAqpPqbgc60gC6XFN7euBphF?=
 =?us-ascii?Q?RHhMsX12y4pljOWFJzamuOr0bCD2J9R47mIyJi4r0/9XbYIK1rN8wJJY9WUU?=
 =?us-ascii?Q?EJW9wQ+dT3y703aTHun+GwgcbEdrK8m1meXtgrr4AZP2HJqIrcyOIZ1uCALF?=
 =?us-ascii?Q?VvczTOsiclsq73qVr6KljDFkJGdMwZq8HcMCrD5C8GoaqI31xGqtNsUSKt7I?=
 =?us-ascii?Q?Vup7rbnKgZoQCJJQi253a74fzLEj38+OTZPQydPvXjY/0w7CI6fgh4UAP/hj?=
 =?us-ascii?Q?wwtQYKHma9evXXNLblPzF64JjuA9aU8WedYdwjq3Zb/aehDS1h8QLS4+9cqv?=
 =?us-ascii?Q?lvX/RzuOwdMsZjrwLyy75g4qVbdh9Te7HC+Rsl4n7s9rB4D3jw+zS+x6P/ud?=
 =?us-ascii?Q?0zDADr0+g0Z/oGVGnWzTNSYU0Cph5BLR1QKjwwdPqEPng7KZ5hkczerbIcWg?=
 =?us-ascii?Q?4RL9Lh/DD8Nmm5wFUjnQ8oIwIKVdF2Dv1FQr2XTNII//fkYHyNA0bow02Jve?=
 =?us-ascii?Q?u9e2opY59JTfBpVgTmrZISGlGukdJ+9XRtamHViqyk1/KLfrHD1n37B20+dZ?=
 =?us-ascii?Q?KQF6HsSfpSDx5CG87HvaGMhcsZUR34P1YrTpf5qnU0tkFpTIMj95qgM0spcs?=
 =?us-ascii?Q?Uloqn1huWdMPWwEFfp6hwh3iVL2XEic6ToQw5qEPCvZb0pwITkSKhsruZy++?=
 =?us-ascii?Q?LIptb0Glpyh4bf8cQX60B547Xb0UIf+WS02+1oB+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b550bffc-76de-4c65-421d-08dae3953c68
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2022 20:52:13.1944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jac2ppqeoSuGq0ZT9FLr9pqra4hgo8TQr5t1/CO6TyPF/oBa1/mEADyirjpCOpBTj1NXRpPsSH7PsINpkNNrww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6883
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-21_11,2022-12-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212210175
X-Proofpoint-ORIG-GUID: 9fPlzJ16uO-kk0FoTaXnw2AMKyQY9taB
X-Proofpoint-GUID: 9fPlzJ16uO-kk0FoTaXnw2AMKyQY9taB
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 21, 2022 at 05:31:51PM +0100, Greg Kroah-Hartman wrote:
> On Thu, Dec 15, 2022 at 04:18:18PM -0700, Tom Saeger wrote:
> > Backport of:
> > commit 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
> > breaks arm64 Build ID when CONFIG_MODVERSIONS=y for all kernels
> > from: commit e4484a495586 ("Merge tag 'kbuild-fixes-v5.0' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> > until: commit df202b452fe6 ("Merge tag 'kbuild-v5.19' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> > 
> > Linus's tree doesn't have this issue since 0d362be5b142 was merged
> > after df202b452fe6 which included:
> > commit 7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")
> 
> Why can't we add this one instead of a custom change?

I quickly abandoned that route - there are too many dependencies.
> 
> > 
> > This kernel's KBUILD CONFIG_MODVERSIONS tooling compiles and links .S targets
> > with relocatable (-r) and now (-z noexecstack)
> > which results in ld adding a .note.GNU-stack section to .o files.
> > Final linking of vmlinux should add a .NOTES segment containing the
> > Build ID, but does NOT (on some architectures like arm64) if a
> > .note.GNU-stack section is found in .o's supplied during link
> > of vmlinux.
> > 
> > DISCARD .note.GNU-stack sections of .S targets.  Final link of
> > vmlinux then properly adds .NOTES segment containing Build ID that can
> > be read using tools like 'readelf -n'.
> > 
> > Fixes: 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
> > Cc: <stable@vger.kernel.org> # 5.15, 5.10, 5.4
> > Cc: <linux-kbuild@vger.kernel.org>
> > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > Cc: Masahiro Yamada <masahiroy@kernel.org>
> > Cc: Nicholas Piggin <npiggin@gmail.com>
> > Cc: Michal Marek <michal.lkml@markovi.net>
> > Cc: Nathan Chancellor <nathan@kernel.org>
> > Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
> > ---
> > 
> > v2:
> >   - Changed approach to append DISCARD section to generated linker script.
> >     - ld no longer emits warning (which was intent of 0d362b35b142) this
> >       addresses Nick's v1 feedback.
> >     - this is applied to all arches, not just arm64
> >   - added commit refs and notes why this doesn't occur in Linus's tree
> >     to address Greg's v1 feedback.
> >   - added Fixes: 0d362b35b142 requested by Nick
> >   - added note to changelog for 7b4537199a4a requested by Nick
> >   - build tested on arm64 and x86
> >    
> >    version           works(vmlinux contains Build ID)
> >    v4.14.302         x86, arm64
> >    v4.14.302.patched x86, arm64
> >    v4.19.269         x86, arm64
> >    v4.19.269.patched x86, arm64
> >    v5.4.227          x86
> >    v5.4.227.patched  x86, arm64
> >    v5.10.159         x86
> >    v5.10.159.patched x86, arm64
> >    v5.15.83          x86
> >    v5.15.83.patched  x86, arm64
> > 
> > v1: https://lore.kernel.org/all/cover.1670358255.git.tom.saeger@oracle.com/
> > 
> > 
> >  scripts/Makefile.build | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> > index 17aa8ef2d52a..e3939676eeb5 100644
> > --- a/scripts/Makefile.build
> > +++ b/scripts/Makefile.build
> > @@ -379,6 +379,8 @@ cmd_modversions_S =								\
> >  	if $(OBJDUMP) -h $@ | grep -q __ksymtab; then				\
> >  		$(call cmd_gensymtypes_S,$(KBUILD_SYMTYPES),$(@:.o=.symtypes))	\
> >  		    > $(@D)/.tmp_$(@F:.o=.ver);					\
> > +		echo "SECTIONS { /DISCARD/ : { *(.note.GNU-stack) } }"		\
> > +		>> $(@D)/.tmp_$(@F:.o=.ver); 					\
> >  										\
> >  		$(LD) $(KBUILD_LDFLAGS) -r -o $(@D)/.tmp_$(@F) $@ 		\
> >  			-T $(@D)/.tmp_$(@F:.o=.ver);				\
> > 
> > base-commit: fd6d66840b4269da4e90e1ea807ae3197433bc66
> > -- 
> > 2.38.1
> > 
> 
> 
> I need some acks from some developers/maintainers before I can take
> this... {hint}
> 
> thanks,
> 
> greg k-h
