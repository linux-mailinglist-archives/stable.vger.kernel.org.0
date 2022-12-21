Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5056537B5
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 21:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234611AbiLUUnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 15:43:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbiLUUnH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 15:43:07 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FE6B64;
        Wed, 21 Dec 2022 12:43:06 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BLKcndR026787;
        Wed, 21 Dec 2022 20:42:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=AuTzNIyv8hTAGaXnuaJJqBDdUt0a3M+9sD3V32HQCLo=;
 b=R1s+gIDLpew3tsquGMVlKWksx0G5Kp4B+DNmjETWGeCTtz2i5VyoTNK4+E1sEiuOmQTf
 2Ph3+4rDUro7aw4aKY/PpVJ4WCPvRVqTACwVK03YQDEn0oph1PneuxTcTwgtU+ycSJwT
 PRzFRqLxjXPo6boEqOGu1OLZVq7FvJEOUtdVBgIBvSfjvK6Z3qOmWEbXwNCpLtFuE+B/
 +AkIGfgdSWHBM0vMWZC4m9KYqXFrY6xs1U6zBT2z2x39lWs3mjTmCV0YVbNcW7789kqX
 sr0GI/G3xmQ5M9PlU0Ua03hj6IZBXRkGDedo4FJAc0fMyyfqOHEI+EaXovkSvP5slfWv 2A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tn9q0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 20:42:49 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BLJZjvO004707;
        Wed, 21 Dec 2022 20:42:48 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3mh47dej70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Dec 2022 20:42:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lXqBbPnhfKZekhuzZJtwvsFQY4KPq5MD71wHhof2N2To+cyMdbqNo6nRrcJN+HeFXVV2XrVxKrBTLwoTVwgby4v1ARvh400Z2OKZ8HVh3i55kF5/VNRr5dv/JJNnorCIrmBMWG3y2iYmS3KKA3Q5A9olZyEWvY1M3RM5c/jk7x/0gexs/s9iBRNLKPmcChcUMC+gcHx8tDNXYlV3EsS3rX4e+jdS8Ls8djsErriYIeFuXUDuvpr+E3zUmlczspqD+X8/S5FNqVd9GPwcECPpcICqOH1pWVxPRzMyLi8G82s8lbwOnr/skevuNqPY34h6AYqZMqihhiIyvO9s8RSR2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AuTzNIyv8hTAGaXnuaJJqBDdUt0a3M+9sD3V32HQCLo=;
 b=EIlkjV3FL4kncX1HJfRx+e/qqZEVVI61rS7UHjFIioac0PO+H2z4zbCiIYoSvwHZmgvrOewvZsoOcHNfAi1BGK10eBtu70K0cUSSgzQ/AsuLg+rMiFS8n0mrQpuKKy6yXotOU3oimIU4syiLK5HBgRsYyVSNt95jw0MiBicXlphVLzw8VQuzfSP0ozwvnZQCCXh3mHYciOkddcXkzCXfo++fbaRNYjMOwSkYrGVWST61TCe4QPTan91XmI5vrBoWqQxysXqi2w8oFmzOs6IvrG0aiy2c1E7PrHAafQZEyLk2boAfU02yQ8u6E70o5TTTagYiCkAsY0d1wf7sY1my6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AuTzNIyv8hTAGaXnuaJJqBDdUt0a3M+9sD3V32HQCLo=;
 b=iFDMEZyN8QF7zegFMm8gCi/rjMRY3t3jOXzoIOyg/LNfEuzCO7muRyTNyEBDYUw8Er7uh89I5zP5F/wcxr7JbANAVkPrP1mS0quu7O6Qi2mtkruBlhk2gqF+9LgVKM+x5PJ1HBrzTswFRf0FEtGjPxCzA7Zbw3tTLIcoakH02DQ=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by BL3PR10MB6210.namprd10.prod.outlook.com (2603:10b6:208:3be::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Wed, 21 Dec
 2022 20:42:44 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0%6]) with mapi id 15.20.5924.016; Wed, 21 Dec 2022
 20:42:44 +0000
Date:   Wed, 21 Dec 2022 14:42:40 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Clifton <nickc@redhat.com>,
        Fangrui Song <maskray@google.com>
Subject: Re: [PATCH 5.15 5.10 5.4 v2] kbuild: fix Build ID if
 CONFIG_MODVERSIONS
Message-ID: <20221221204240.fa3ufl3twepj7357@oracle.com>
References: <3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com>
 <CAKwvOdnu6KAgFrwmcn9qhjd+WDyW0ZTSyOzOnSsWhQ1rj0Y-6A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdnu6KAgFrwmcn9qhjd+WDyW0ZTSyOzOnSsWhQ1rj0Y-6A@mail.gmail.com>
X-ClientProxiedBy: SJ0PR13CA0144.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::29) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|BL3PR10MB6210:EE_
X-MS-Office365-Filtering-Correlation-Id: bf901733-11e0-4e1e-9202-08dae393e91f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TpY7rKfcJPw3oifi6ktsXlK7ZXmfYFHvFcMABn13mfgmmWB9HIyHeTpmO4ESDcch4wNG6u2QJjXc8c+Gdwmb8HilYI1Ove5bTn6y0e7LQiAAysCMNZfpXPDwD16DTBq7DektS82IN/AJx/e2wAKFgEY+5wqP4z/KbrVU7kK3j4/Uq+3Hs2trM8R0Aalc6h5K+h0BHxNAQVPl00OKLT4W6Hmvkwpy+mVzliWueq4TPpAQgMyWVDd4Q2YOABp3sBiwPYl0pu9WOhbUViNrGs2RmqBMPDdWIP17P2NH6WwRUwzHvvDSIOmu1SuHUdFvOYm4GmT9+VI3/PVV/iXqSWmLzMkBU597E6YhXxlv6KylbhAQvPO6bsezzVVvBvXvsl2ROrWxdSPOcncBY822trWWJjapwwJXFpln2LmrFcKWa8BLzxaMGJnUmDKb8yFELi8ONE2mnzIRpY+lerSnMOZaN5smVr+YELsrQj/z6z4ZS/RI8kA58SCmyPaKqe+jVOKKG9Yp1JFqMoj6b6phYtvD7COo3ckbge3oFMgP2FJ9JDfF9x0EBX3V5eyjhBY4YZ+vOyIYlxYeG+o538bhQNVIzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199015)(6506007)(83380400001)(4326008)(8676002)(5660300002)(66946007)(41300700001)(53546011)(8936002)(66476007)(66556008)(6666004)(7416002)(36756003)(186003)(26005)(478600001)(6512007)(44832011)(38100700002)(2906002)(6916009)(966005)(54906003)(316002)(6486002)(86362001)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jgUU93IbJ/8Q6BR2YalxA1wLwneYjU0+9+eQy6jfcMwBZ352KxvI9grW+dtu?=
 =?us-ascii?Q?b7ubbYvnA7GnvlupMe1Njdc7tvLpyDmdPYfNSNIA28BNHlLZ7/lt7Euqe9Is?=
 =?us-ascii?Q?ifRJcAQM4hZ50qRZTsMc/swZ4tMPDesvycBJomL927DYZPk5mSqfZ0ElueyI?=
 =?us-ascii?Q?W/HjCv3mnxyKKI3qPgQc7serKmI/iU/iRLjW4CNuqsGwGPzEck8ZYnLFShAJ?=
 =?us-ascii?Q?EFw/ITpNqg2sieLVc8IchCABrXzCQzvD7LcTvJJCVJubzg5ca6S07ZWS9DFk?=
 =?us-ascii?Q?c3wcDsN0bRHtpsJzA1dCFSJinlU4TybiGzGE1uy0rIN6XLbVNlTRX9yXJPaD?=
 =?us-ascii?Q?W7z3tn1YlK2lremfo08tn1xzk27zRaiSzY5//BzUIcYkyjUBdDmkgw3VMliK?=
 =?us-ascii?Q?6R55Qf7k8kbsC7PGjA/LejxfF8fVXWiV7j8zGd2uTT3+MMsasp+UhF7v9LF/?=
 =?us-ascii?Q?LDC9rkt2Z3Ce1YY/tbSvsbREv+B23d3+3CAw0fD6puDgpgqPNuAfQKDrJJHB?=
 =?us-ascii?Q?dATev6yCsZ5HwaczSZYb1VL3C7HTEYSzq/Ibiz4+MPU0iE6WZq1EUoIvw5T/?=
 =?us-ascii?Q?xKh77DRFvM4Pr/dQhXLz4nuXrqRleG/b9ca7uqbmEbsan/s+BWXssBi4dXoM?=
 =?us-ascii?Q?q++BKjAHmZZ4KtuyxjETOrC4CGhjhpM+915/538r+ZGrSRW13QR3eMOoXSD9?=
 =?us-ascii?Q?Wc5sodXzwoRCJpC/mr9LcMZ/fuAzHd2RtJPsCuBQkY5mLJU4MiXBteOjgqZd?=
 =?us-ascii?Q?4VNszgQaR6GVWQtHWlIJiu5DzWLEfE2TmyhhDeW62C1QJmZpPox77rY2iq2Q?=
 =?us-ascii?Q?1P6Iy3b5k4uR4C4jVIt/KuZwmbWaUHLCk9Qxn1AiToUxpj4HrWH/O5CRFNx2?=
 =?us-ascii?Q?TZfhIs7k3Rg5g2XNrrzLz/lkLNs2QPEIGUSTwC6dcHxCepxQ1Znrp9fRTUL/?=
 =?us-ascii?Q?Pt97BQtdU8IyWJ0b74dD3OFkxthfHJ4a1/vDHZddiMt49fzQxsmTAPRTURzC?=
 =?us-ascii?Q?wATqjleetED21MovWg2H8EpU5cJg7htJczmcujqv5iePe3z8Q9gRmoazTDtF?=
 =?us-ascii?Q?t80NmU9cnJctjhI9fg8cqVNylKiJtVXAv5ampz6+zgt8wrO8bCAfVvrZRB2/?=
 =?us-ascii?Q?l3PRaZftsknh5HUQusakq+UgyvghKEV9tUP+rSleeCwzvpD0PEB5sRGY1Vxw?=
 =?us-ascii?Q?3PEo4tG2lOR4UGtNj6tE3IB+kfApwyGNfYU/A9D+jjwjtjVGiMmjtgQ3jSV8?=
 =?us-ascii?Q?79YShXHFcWhsdOmyC1jxbnfn+rOaHgu6QZ+/sNxxUFzC6sA3YjDmRoOFPDC+?=
 =?us-ascii?Q?i5XYsljAR7MI8864ciHLCFSV+kLZ5VNWgJ2yN0iGM1D4Gts/bBfg9S64RW/9?=
 =?us-ascii?Q?9Cke5fokYAS1AxKcKUznJMHw3q8bT+6hGwhjXFYXRj07JRRsaa76z5Djm0IO?=
 =?us-ascii?Q?TTlRxEtWmK3EewBw93ptOzF5lv3GcvPr6nhjh/3jZxH80GRPKFTsvvOAUlU9?=
 =?us-ascii?Q?S0CBTvzqy4yJRjyKpfgr1ftVpXZ1uoGnSsoOVgwFTLhHgOt/EGcwD07GrtMT?=
 =?us-ascii?Q?xJgtf9rsMW/WyxfUyhCW51i5+NHtbi7uka908gTG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf901733-11e0-4e1e-9202-08dae393e91f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2022 20:42:43.9860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UtEYxfHt5JmQvci2E8jt421ag0OB2OJYxV4jf9MmsuuMKvC8OqsfbU3IWcIXCm8rkCJcVMlU36fTvUtuLYyUmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6210
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-21_11,2022-12-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212210175
X-Proofpoint-ORIG-GUID: GQ6AkGM0GpsVyWySbHtP9d0h9RuT9YUf
X-Proofpoint-GUID: GQ6AkGM0GpsVyWySbHtP9d0h9RuT9YUf
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 21, 2022 at 11:56:33AM -0800, Nick Desaulniers wrote:
> Tom, thanks for pursuing this. Sorry I'm falling behind in reviews
> (going offline soon for the holidays).

Same :)

> Some additional questions:
> 
> 
> On Thu, Dec 15, 2022 at 3:18 PM Tom Saeger <tom.saeger@oracle.com> wrote:
> >
> > Backport of:
> > commit 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
> > breaks arm64 Build ID when CONFIG_MODVERSIONS=y for all kernels
> > from: commit e4484a495586 ("Merge tag 'kbuild-fixes-v5.0' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> > until: commit df202b452fe6 ("Merge tag 'kbuild-v5.19' of git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild")
> 
> Just arm64? Why not other architectures?

I've only encountered this with arm64 and specifically NOT with x86.
I suspect other architectures may encounter this, but I haven't tried.

v1 cover has a simple example if someone has capability/time to adapt to
another architecture.

- enable CONFIG_MODVERSIONS
- build
- readelf -n vmlinux

> 
> >
> > Linus's tree doesn't have this issue since 0d362be5b142 was merged
> > after df202b452fe6 which included:
> > commit 7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")
> >
> > This kernel's KBUILD CONFIG_MODVERSIONS tooling compiles and links .S targets
> > with relocatable (-r) and now (-z noexecstack)
> > which results in ld adding a .note.GNU-stack section to .o files.
> > Final linking of vmlinux should add a .NOTES segment containing the
> > Build ID, but does NOT (on some architectures like arm64) if a
> > .note.GNU-stack section is found in .o's supplied during link
> > of vmlinux.
> 
> Is that a bug in BFD?  That the behavior differs per target
> architecture is subtle.  If it's not documented behavior that you can
> link to, can you file a bug about your findings and cc me?
> https://sourceware.org/bugzilla/enter_bug.cgi?product=binutils

I've found:
https://sourceware.org/bugzilla/show_bug.cgi?id=16744
Comment 1: https://sourceware.org/bugzilla/show_bug.cgi?id=16744#c1

"the semantics of a .note.GNU-stack presence is target-dependent."

corresponding to this commit:
https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=76f0cad6f4e0fdfc4cfeee135b44b6a090919c60

So - I'm not entirely sure if this is a bug or expected behavior.

> 
> If it is a bug in BFD, then I'm not opposed to working around it, but
> it would be good to have as precise a report as possible in the commit
> message if we're going to do hijinks in a stable-only patch for
> existing tooling.
> 
> If it's a feature, having some explanation _why_ we get per-arch
> behavior like this may be helpful for us to link to in the future
> should this come up again.

While I agree - *I* don't have an explanation (despite digging), only
work-arounds.

> 
> >
> > DISCARD .note.GNU-stack sections of .S targets.  Final link of
> 
> That's going to give them an executable stack again.
> https://www.redhat.com/en/blog/linkers-warnings-about-executable-stacks-and-segments
> >> missing .note.GNU-stack section implies executable stack
> The intent of 0d362be5b142 is that we don't want translation units to
> have executable stacks, though I do note that assembler sources need
> to opt in.
> 
> Is it possible to force a build-id via linker flag `--build-id=sha1`?
That's an idea - I'll see if this works.

> 
> If not, can we just use `-z execstack` rather than concatenating a
> DISCARD section into a linker script?

so... something like v1 patch, but replace `-z noexecstack` with `-z
execstack`?  And for arm64 only?  I'll try this.


> Either command line flags feel
> cleaner than modifying a linker script at build time, if they work
> that is.

well... that entire linker script is generated at build-time.

> 
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
> > @@ -379,6 +379,8 @@ cmd_modversions_S =                                                         \
> >         if $(OBJDUMP) -h $@ | grep -q __ksymtab; then                           \
> >                 $(call cmd_gensymtypes_S,$(KBUILD_SYMTYPES),$(@:.o=.symtypes))  \
> >                     > $(@D)/.tmp_$(@F:.o=.ver);                                 \
> > +               echo "SECTIONS { /DISCARD/ : { *(.note.GNU-stack) } }"          \
> > +               >> $(@D)/.tmp_$(@F:.o=.ver);                                    \
> >                                                                                 \
> >                 $(LD) $(KBUILD_LDFLAGS) -r -o $(@D)/.tmp_$(@F) $@               \
> >                         -T $(@D)/.tmp_$(@F:.o=.ver);                            \
> >
> > base-commit: fd6d66840b4269da4e90e1ea807ae3197433bc66
> > --
> > 2.38.1
> >
> 
> 
> -- 
> Thanks,
> ~Nick Desaulniers
