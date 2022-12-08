Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D806479F5
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 00:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiLHXbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 18:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiLHXbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 18:31:33 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770606ACEF;
        Thu,  8 Dec 2022 15:31:32 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B8MJEJ7029709;
        Thu, 8 Dec 2022 23:31:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=Ii9O/ysIq9oYJAgxUtKz5A25PUCvn6sBZ5B510OQosg=;
 b=PMiOC8DGI24AsY0mf9Z4mUzwnzb0P2coj2O3zDHJEIONeiRYC9e5//VmZ/N6B1OZkUe0
 8ncD9TJG30ZBgiq/qWHI63qPJXpHRjCxtbagrZHnPvcLHc9t84ufD8TUDcRg3NJg2Pj4
 /X2Gbbhmj2Vjc/5TwyDaeiixFQxaljJaIF0Jw2obOObiu2sOgfNyqBhrkhVglZmWl0c3
 Mf6HvlNr4KhlgScPXaaxVh/6lmi/ugBMZzSTugZC1PrS+6QT2laU0d9nV2Zt05VUXhoR
 7JCZlyT0nzaHQVCw8sPxVHL8VZra1nFaoZnh72KDqi2lBRYeuTjJdwnvMorlTilO4iU9 7A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mauf8m15n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 23:31:15 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B8MJe3H032685;
        Thu, 8 Dec 2022 23:31:14 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa7f213p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Dec 2022 23:31:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CGYHQM8/NrXVD7MeVKj/dycj+ClbAXzVskO33pg02072TfYeBnhV3p+1C9TuRSmdTzAFKAYAQRQxiOrcWavzHYG9EYEU8OYwZPQv3iEstNEt/lz3rr/TkFdtdOgizyUMJsf3XoTjPttdrBjXcl8xT185hV7Ow30XRfm5h5mYNZxTO3kHVRLOhmhzDR7eGLV6nmk9I8h+LLMfrAJnTzZzX9N2TKtZmprYLBH+Nxr7a6rRvnvcnbBhxIM2ZFBh9TTI4tv3M4AXm2sKY4bZuhPDGo4b1s5aeAG0PLnk1Ql1d+OVd/WvWPzYA+F0qB+OOa/9HDz4ljIXmBXKHWJZv6vS1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ii9O/ysIq9oYJAgxUtKz5A25PUCvn6sBZ5B510OQosg=;
 b=nlOSadLji0+ehu1iF13fIzPTX6UX01bsEusTDCRaAYKRzTzN//IT1XRVNWiIDyTrGl4FefgHXMhByIBgQYwnisUB1mab/bbsXzsbjaPSr/yz3BWshjzN4W2ueP2L9SsTtSl7g9fGhmrOdKMvTiR/B+Yrnq78PRSU8PsCnCmtOrTubGq2GVrMLe6gXGYpOvDDp6Ab1E+bT/pDEwpVNK2f9qotQbJzFzzjci5js54Fzzm7OcBqdrlT7mud2X4CGiWgv56h6ud/pc97da4rgEOKXKhYj8gv61enU9PeaoZIuu3Xoefnk8+rybKu+8c6nWB5x61t/IQx33t7cSNA1Dvg7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ii9O/ysIq9oYJAgxUtKz5A25PUCvn6sBZ5B510OQosg=;
 b=KmSl39HRyOwJtNgW1Crnx5y+ShmFfwbSIiJk9w4q8Yzc48hPTIwDVUbRD4rzDhhY6h+uVd0quOviVqUOKhLZHiIk5rEGgPv6KMUd3p53WIcMub2nNtx3RjZXlJPMFx+ESClPGCERhQEtmxuyKP3qiE6K4sA+qdaPQgYofNRXfOc=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by MW4PR10MB5883.namprd10.prod.outlook.com (2603:10b6:303:18f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 23:31:11 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0%6]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 23:31:11 +0000
Date:   Thu, 8 Dec 2022 17:31:06 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Clifton <nickc@redhat.com>,
        Jose Marchesi <jose.marchesi@oracle.com>
Cc:     stable@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 5.15 5.10 5.4 1/1] arm64: fix Build ID if
 CONFIG_MODVERSIONS
Message-ID: <20221208233106.jvss2x4unqvijhgg@oracle.com>
References: <cover.1670358255.git.tom.saeger@oracle.com>
 <9e387b71ce45d8b7fe9f2b9c52694e3df33f0c7a.1670358255.git.tom.saeger@oracle.com>
 <Y5JKYA53GnPrsr+f@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5JKYA53GnPrsr+f@kroah.com>
X-ClientProxiedBy: SA1PR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::29) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|MW4PR10MB5883:EE_
X-MS-Office365-Filtering-Correlation-Id: 3461284e-9518-4674-1855-08dad9744a35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kWZoZl1WLH+1cL26+TRbJFG6b3ge4MYqavsK0L5ctiDCMAYCM1EA6KodcEIpQ5msrsnGtYC8hNh7yLuV6Ihcnm0Xn6NwePYze5gl2K7CGFzqLSkqyvH3h1pVYvVkHVz63f6ONZ4VKc1ICa2KnSGQFZTimTt60A5Jx6eJu3AkBnHAo3pQWUzq9Pk9Yl3lQn2hI5teghLwGmvnKEHD6eNohSuYXJMRJNwDPtmWr7as1j5FinW4jXbHh2Ktr7PHj0XVFcXyNwURNKywczQyoplzdUSGM+U/qfWS4WFRa4NpndxYZTuovjvPeU+/jCTNa0+t0zyCaKtaFLq6NF/OsuqVRFRhLxlQJX/ZguTYBjOOl/Xzr5vXzPKeArS/KBGJEO2ZXdP6V25hLeGysfiC1fzAQMUibMkpVcNBwY7k3g+mf77yCwXXQ2I5u1jEU0n+tq6Yf2o84YeFdiYbz0N5h2mF1CQKvT6VIGwYLfciUIGPVLtEdcbijSHn/AsRqnu4r12mWr5RbrxgvZzuDDgg7pScFFoJ4KOcbqF7HNbSo3vwK/fLj1HTFAj6qYcisoY3rel/iGDZrwH+V/dyBfYXaWJ4GVFFjpWhrCQL4ZxIE2jJNjadyd7014jxd+P/LzLIQIkU7gRuz68Mgn2vMHaRvkzOMwhgtU23ZqztQKWc27MzR+o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(136003)(366004)(39860400002)(396003)(451199015)(5660300002)(6666004)(6506007)(6512007)(26005)(44832011)(41300700001)(66946007)(66476007)(36756003)(2906002)(8676002)(66556008)(8936002)(110136005)(966005)(38100700002)(4326008)(6636002)(478600001)(316002)(6486002)(86362001)(83380400001)(2616005)(186003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6SLKg1LfEby1dzYBtEMvryR9HaKEdkEuFnQAAowmbfEgvKU2gEL9n9NTSlRh?=
 =?us-ascii?Q?BEG28gav32E6lIFEb//DyJ4IZFGWk0Wt1Z41YIkoBMXdXe2mYvTgCyB7IcqH?=
 =?us-ascii?Q?Ni2bXTTDBvjwXIIMLA8JTfYt7LkLWDHGxfatXUk6LZJI6k6iZdSiZlw2CYzB?=
 =?us-ascii?Q?QKen6aUs4ehkkQByzjvCqRvY2VBfOgGz6Z/SViBzkRXgzD9ugA8ww1p5HD4s?=
 =?us-ascii?Q?kqOlNK3ch+KNl7L96HjM9dTD4EqXFedopDXWh5A8l5z0R1YUF8d+ar+USLr3?=
 =?us-ascii?Q?730+X08vK3SknjCemZGzWeNCUM0VR+XDjmVDBA/QMaev0rVlZvbUaGvcMotF?=
 =?us-ascii?Q?H80GmL6wFNyPVWp81II2v274gFVFV28rk7NHvt13yhD92B39bMygXWVAizuo?=
 =?us-ascii?Q?12oxbDLJRw9eH8WZDntQQdcCtUXct3RJ9Uj7vUQlMN6EUJn9eGsQwdrTngXA?=
 =?us-ascii?Q?9js4Z6nNGKVKYWnFK5CbIJmAKNvfiNLayPN5qCsGqUfgY8OgEwmxQCOCVUgj?=
 =?us-ascii?Q?GXBj8cbdPuJtOwLwT9Z4AZYMhzmDTDfG878X6qRAHE/43EPkEzWasWGEu9eY?=
 =?us-ascii?Q?tnkCdFNnznuchNL6TDsJoocwvZBRcH3+Y5CSFpfSXTE0POzv7HuI476LeKQO?=
 =?us-ascii?Q?7Fqe/66Z3pda132g4qv6ZMrDGL2stww8QcZtyAgwihWMat6pScvIi51ILDca?=
 =?us-ascii?Q?FqjzQBl+nfumlB7u9yYFqR24XzfKyCk1RP3LD6wHr2MNVWhlO+yUO5DueCdk?=
 =?us-ascii?Q?EC9CHFNyyDOSW5GDIqk3yrEmSc2USwjOmJGB4s7c1CokcTGqb5DoXVFV2nuy?=
 =?us-ascii?Q?loVCjjMwMUn4Oy+Wj9TP8IHPb/INRpuO2iB+2qZMantzxlETjrkRyC8tpf6b?=
 =?us-ascii?Q?1hplxDGBVTrW9+DRKcbqppYUs7ldev5uZ9l/x7wON1CIYG2S/JRU1u06a2L/?=
 =?us-ascii?Q?iaZhCZaBe2ACNMUo/wFYwJwYUctEG8evc/kNkUGBdKT+xkdBigft9xfmWYX4?=
 =?us-ascii?Q?LG4R3Vqi2LhW1v0QT72aDdpTOqBlLJl9f2PbZON3IBaG+e8UT9qtbGWU5OqV?=
 =?us-ascii?Q?xz2PC8J4zwt8Ezxkxx/tY3tfbeWM4RVvWR1zTO6t7Ljoth7deK2EuwcZqH08?=
 =?us-ascii?Q?92erP1Av9B4/fYEp69qO8bFpFF0rDmky+KRA2IC3bU3yh4bfXQ3fHZkHECoU?=
 =?us-ascii?Q?IsNcAVdyGbeplnSWOKZDl9LBY8e6U2YKc4G8Rpu176Be8Can2rd4KD2dcFGT?=
 =?us-ascii?Q?Ee6T7rMu2XtjAtD4bR52Ia3P5ldyGXdDSp2CwqERup3wSGHD7Npi7zGOhV7M?=
 =?us-ascii?Q?G1+QAGmXuJs16lHY7Q1W7QQSCX7dR3jkJh9DRg1CG+eQiCLLZHPb5ZWcd4p1?=
 =?us-ascii?Q?URN74BiBa362BSJTGmVU1Xg2TJMYrms65XIcYSBH/KPI4eQRRG3J2wRw1u6j?=
 =?us-ascii?Q?PtKOJXiaRmfRLjek7vjiczkXOYyqfbnyaUepLYq4TD0fH5biH4W8oz6U7rGL?=
 =?us-ascii?Q?o2KsHj9C511x0FWIOmyKoT3w4STGcv2vIFfanMGtNO2f5ykeRrSesQS1QJae?=
 =?us-ascii?Q?gHFDys+t2bXLTdpyge5/kmN88WNKNlsYRIAxKen+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3461284e-9518-4674-1855-08dad9744a35
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 23:31:11.4679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tl52UvRsXY3DVDduNeNXsrjMVBTVSiO140ptuPxjtQ2i8p4L3BTDMkrduylxSLqDvhDHJ50xwB9OPsY1mAEnfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5883
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-08_12,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212080193
X-Proofpoint-ORIG-GUID: 7U-l-aA4xL4cjxahW8rkbMykMi7Vfjzj
X-Proofpoint-GUID: 7U-l-aA4xL4cjxahW8rkbMykMi7Vfjzj
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 08, 2022 at 09:34:40PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Dec 06, 2022 at 01:43:08PM -0700, Tom Saeger wrote:
> > Backport of: 0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
> > breaks arm64 Build ID when CONFIG_MODVERSIONS=y.
> > 
> > CONFIG_MODVERSIONS adds extra tooling to calculate symbol versions.
> > This kernel's KBUILD tooling uses both
> > relocatable (-r) and (-z noexecstack) to link head.o
> > which results in ld adding a .note.GNU-stack section.
> > Final linking of vmlinux should add a .NOTES segment containing the
> > Build ID, but does NOT if head.o has a .note.GNU-stack section.
> > 
> > Selectively remove -z noexecstack from head.o's KBUILD_LDFLAGS to
> > prevent .note.GNU-stack from being added to head.o.  Final link of
> > vmlinux then properly adds .NOTES segment containing Build ID that can
> > be read using tools like 'readelf -n'.
> > 
> > Cc: <stable@vger.kernel.org> # 5.15, 5.10, 5.4
> > Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
> > ---
> >  arch/arm64/kernel/Makefile | 5 +++++
> >  1 file changed, 5 insertions(+)
> 
> Why isn't this needed in Linus's tree?

0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")

was merged after
7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")

Linus's tree never had -z noexecstack with these same KBUILD rules.

> 
> And why not cc: everyone involved in this, I would need acks from
> maintainers to be able to accept this...

Fair request.

Between ~5.3 and 5.19-rc1 cherry-picking 
0d362be5b142 ("Makefile: link with -z noexecstack --no-warn-rwx-segments")
and building arm64 with CONFIG_MODVERSIONS=y
results in vmlinux missing Build ID

head.S is compiled to head.o
head.o is linked (ld) with -r and -z noexecstack  which adds .note.GNU-stack section in head.o
head.o is then linked again with vmlinux (resulting vmlinux is missing .NOTE segment)


Can folks confirm/deny ld behavior is expected (arm64)?
And whether the above patch would be an acceptable fix for these kernel
versions?

repro test in cover letter: https://lore.kernel.org/all/cover.1670358255.git.tom.saeger@oracle.com/#r

Regards,
--Tom


> 
> thanks,
> 
> greg k-h
