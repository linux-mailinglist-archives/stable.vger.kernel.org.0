Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB526539FE
	for <lists+stable@lfdr.de>; Thu, 22 Dec 2022 01:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbiLVAD6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 19:03:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234634AbiLVAD5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 19:03:57 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DD73167D7;
        Wed, 21 Dec 2022 16:03:56 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BLMiYeH016809;
        Thu, 22 Dec 2022 00:03:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=JsGp41KO5CeO3NDIRE0vIPqxkVmPwe2feN2r57LG9PY=;
 b=vMyHqHadZOpENq8ZZVjN6cPBxoJqzoUAsMrglmWfU2TrkMh0GSHCCzIIg1DQOC9ehqMi
 7SRK/p/jp/txIi7WyKULK07/6bw1Hr97z57uTxetK2dBDXwcBkiSjxru0olIEiCcZcS9
 M0S/zmjtgjZxDTr+RQwmpKTOfs7SBKnr0dZ72ny5WZKvDjDSwlcAxv35KaaWJPZYCzgG
 okG33buyYuzJ2SmMrELh20tPzLlDo/THsp0XKtpFwmzdjzpGXssTiMoXlgmXw7iI50uC
 /g/tAI3RUcQ7SVJjXtl0vGp+Fid1Rr/GZ8kgSLkUr92tmG/AlCPPHzKCE8JsUwIo5z5b XQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mh6tna0bb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Dec 2022 00:03:43 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BLMrZW4003499;
        Thu, 22 Dec 2022 00:03:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mh477a4q0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Dec 2022 00:03:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IdaJpLHcsvlWkhCI+QHbKEZXiu5xXxA8cc3ZKmvIlNMDDkdjyYt0enwxuYkxZsz4nltLYFreNrTDrBzPMt3kSZqHT/iRiMpgJ+3f4eLRhKntF8bcImrnJd6GFotbQIRmKbGwfqPA/SgNS2dY9swjbwckjBVmGqOncK+7emllWkr8RcAD3NVBZXvQ98A9jLqVCtXLbRhASA1nzAuc1Glxz+BYt+PwdH9XVoIBTqY8ETRhqpn59GXTbCwMQhZj9hCEqaCjd3q0F7Ok9W3YR30iYYV5s1tMevZ1522NCKGBJNNjOAjBACIh1Yyd7KhOstNMI6cX6q4Qu6kbkvFFlq86ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JsGp41KO5CeO3NDIRE0vIPqxkVmPwe2feN2r57LG9PY=;
 b=YOtAxdDqENK3xKjkuxT9Ve9SHxzCOlfmw5L8xMhCjL9I8bQRAVFo5vMRqaiCAP9aph63gkNi8I+QMpDdsdQLWpir0ZnzNHpUSpZGI3ptpzfKBRxwB7J6cYR9rEEZGtDzoa3ofScaSgP+p7WzeQoBQPHvJEwSOSHyiGQMTzVzy5veGT+6y9SfwZlJK7G005LPsHcvhFK9ANxkoGUUNbfGXfXUU5fmDBK3ZYhhiz8e6Qa/FeMwCf3TYOgmsiVda5c7VRoZwVXRCGeIH2Y4hXp6Df8Xh4vQWJNCfGZHL3bW9rPuDk7F78/Bi3/HMFghz2q0kmNWTsRdrZ/8vCUb+2sTcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JsGp41KO5CeO3NDIRE0vIPqxkVmPwe2feN2r57LG9PY=;
 b=td3FMMe2WLw0FNuOSJPSO3cKy2BRLrZQit/94gjb027UDkFqcSG5qSMfm8f0lyx3T3sTSElmcKi125DQ7pM7OKouZu3B08M60H5O8T40u7l3GiPJ4vi7r7C9t+xmYQc/urXreyHytafq2iIzF9Jr9wQyuDwVG24qPRnz/umupHA=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by IA1PR10MB6146.namprd10.prod.outlook.com (2603:10b6:208:3aa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Thu, 22 Dec
 2022 00:03:35 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0%6]) with mapi id 15.20.5924.016; Thu, 22 Dec 2022
 00:03:35 +0000
Date:   Wed, 21 Dec 2022 18:03:30 -0600
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
Message-ID: <20221222000330.57vazcv6blclpe6o@oracle.com>
References: <3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com>
 <CAKwvOdnu6KAgFrwmcn9qhjd+WDyW0ZTSyOzOnSsWhQ1rj0Y-6A@mail.gmail.com>
 <20221221204240.fa3ufl3twepj7357@oracle.com>
 <CAKwvOdkdPNqPQUOqBLqW7m7i-WB0fJLSSpYTPFXnaitBNatoMw@mail.gmail.com>
 <20221221235413.xaisboqmr7dkqwn6@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221221235413.xaisboqmr7dkqwn6@oracle.com>
X-ClientProxiedBy: SA1PR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::17) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|IA1PR10MB6146:EE_
X-MS-Office365-Filtering-Correlation-Id: e100ef20-651c-4d80-986b-08dae3aff83e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IVUnnwozykkLoZoHHW2FhaIgYsRv58sQd9gk6VDhNSp64D3xQE48l22Uv0wFnCAr5/vjf6KPADVeP+q0v8KlUw78BA2n2i8JTr/3lszmcbtSWZ2X0+6SST303NVVFnD1EnqMukGlNNiw07Amk9CWFGBZ70ZTYb9fxgxCpuroES3lD9xLp9ZmtX5igFZHj6lirjnAEUUquB8AYK1dyWJrPy6mY8i18S0WQ9MUPs3sYGp4eGaxvsL9Rd3W1kugSL3NI5zoPxYnftyRaDjbvpP+OSrdsJMSmt92CShy/g3xu7s9HDKac+AcqnQnOKog5BTRrXg0sB1XCUAOiKQ0Jt3O0kN8USbtodFcHLzm9JtLL7toM1smE8TSiZNg6z3wTwM1Q1K6D2gdcHMBFmwxzjLV2Lf3Yb0ZDBPDH82V71zy9+b098HqoBlz/04bu6bqUz5Etmu80FWTC7ATPcra9kS3ILttF/HIS/TD2Fr/r0GXLg3n2AiIZzMjZpdtx4+bgjUY1K0irkqyMVGtLA+YPj8kLQhrzgg/FI0XfUvvsCei6xAJjaUWoB/ib9IJykcx1iV5S2FWbjHOVF7BOndf3MZ1Fj+TMnmcBeL4tKiEqGIPPnk+en1tgW+R9CmkgWnPLd/24eHbONsJJ6NTK8kWNM6nmzvW3YY2KJ3IqJh98gPYDNQM5lRMUZwgMc/CiU14bs4nay1IrVCOdzMimst6syaboQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(396003)(376002)(366004)(39860400002)(451199015)(53546011)(26005)(2616005)(186003)(1076003)(6666004)(6486002)(2906002)(86362001)(478600001)(966005)(6506007)(6512007)(5660300002)(316002)(54906003)(6916009)(66476007)(41300700001)(36756003)(66556008)(66946007)(83380400001)(4326008)(8676002)(8936002)(38100700002)(44832011)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G5Ic8oQb/QSo+sHYTny/DFqUQrP2Q9KjAMycHbnXXNzLfaBP21EqsaiIsDLL?=
 =?us-ascii?Q?xX3jhwqaDvqP63q6LkwZa829AEQtv/C+N7ZSjmDdYfZly8iKM7SP35x11DU3?=
 =?us-ascii?Q?WShIOcAGrgzOwLmQ1FVcK81uItVI0Zq23XYqifF8JZ6+HDRbW53hG/yxCNph?=
 =?us-ascii?Q?d+RAJFMM4a1dEYbCj9yHBZR3FR5uVGTRHNXw7OXTPEgYk66Zna5Whg6r6kPA?=
 =?us-ascii?Q?GDOPaMXdRVx1epCHsQeWb7QUAxznHY5pX7FPP0yp2cja19a/gJJH+MfLzBCN?=
 =?us-ascii?Q?FcCBZXcLw2bILaJ8sHBpiEAfZBdoupyBg7tCp3YWDM4AmeSWnpvwQ2n2cGAk?=
 =?us-ascii?Q?ZvomdnnUNl5sUFbKIJCQ2ZoGww39S9yA71JWUCugDhiwidq0x6ZXaqo1UC+A?=
 =?us-ascii?Q?TuvqKlz9dqRvSvVuWEjn0BYgvpE4nABwHZ5EoNYa/RYPxmKJ1aGP2eBRlUxu?=
 =?us-ascii?Q?a+REfpwR1AeJvvKHLo6FZRtrx1iB6SiMok9UdDbE6/SbJKYXdKXtPHoQ86e4?=
 =?us-ascii?Q?DRlXSxRMBb0hjWGzPXIUZSdNnfb9UYzjQJP04CbfMfLXPvQOIF2k+hgPvfB6?=
 =?us-ascii?Q?Hl88gmcYyxEE5tYIP8Dh9NWpNKWmGTaNUlEM7PwVvV2J8/W6/FGSzOpbreyK?=
 =?us-ascii?Q?NdOspYR/RHg0TPwp16C1EV2PzPbWIG5phV1V4JH7a6cdh+xUwlS660aeWGOi?=
 =?us-ascii?Q?PjlcPUsmf5dLilCu9/b2t6AZLgfmGgbwtAD+vowEqrInv19oXUk0RApNj9YL?=
 =?us-ascii?Q?7zqucfZ4lOTmbD1/HvWax2DUs6adgoGWkgCCDLEts1+Q9TbOxUL45APrDk15?=
 =?us-ascii?Q?o7aPJDdBbmy4Yd+2WqcrgNVRyN6D0Eag+x18VbDF+5FdJtrsYwEN4Y2RlEbB?=
 =?us-ascii?Q?KRePIztfNcPbFjy9dHzPwA6aFPCZFEUDpeg+Grx1iprSuyrf8HwpVyABuS4Y?=
 =?us-ascii?Q?qNO8xdA4sVi/p6vJifxAlNQN6dxkzU0I3Q9KnZ5EbtQF2YRN8ihkFKPxPRgB?=
 =?us-ascii?Q?8aPzb5C/zumhyxlC4s5KYI4evwwcxr0ALackjgYMBpKwjv4jz8We9wVj5wEu?=
 =?us-ascii?Q?8zDFz/bkdGLdExlfFTBmesa1/CmzMn4aBV3V7sHnhAK4DoilaRog3lMtwIPT?=
 =?us-ascii?Q?GXm8aJK1k7eHayNMKNNDM6OmFo/lsdnmMByAkksg97XfwO65ANpVQn/0RBMV?=
 =?us-ascii?Q?Y4SyP2gqcEE7d9u9vQP1rCGzgyJGC42N+j19nr5sNwPWTOEt4NWYbQRlOWPk?=
 =?us-ascii?Q?YQWSzNGlI15dH6wtLIXGLDt++Kk3a4bgr111teZ3jxBcIsr87CJpqdMrMc+m?=
 =?us-ascii?Q?/FFF+jcQXYk8R8XY2Xkahts/JqRoTSZSmcTxQrgOhO/tUKLyJIneB56FrA43?=
 =?us-ascii?Q?1V0TYq7jJhfaIDw+FyeC/Al4S0QMcBUMbn5+41Kjxrb4qfy+Vvk7FJtxHhRe?=
 =?us-ascii?Q?q8W7eH8fFYEUn1PprSjm7ZXhsTxE4asJOGxSiNmnAeoQbcx8Qa0LEW/hywAG?=
 =?us-ascii?Q?v45DZtK0T0UYrOFZjp3TcG6GDPafmbKYFNADHf/PM2vXspX/2XQslWUS6uy2?=
 =?us-ascii?Q?jHUl5uVnc6HSDZlAb6K9iqBxKSRRvDXUT8EEp0zY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e100ef20-651c-4d80-986b-08dae3aff83e
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2022 00:03:35.2480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ajlJrcYIruXdXYhtqaIKv6hiD1fBQ5L+I1XlIiJ2007lA0TzyyDJFo5OczMHDeW9S+X57Qo12e4Ipl55YRvuvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6146
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-21_13,2022-12-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212210205
X-Proofpoint-ORIG-GUID: WVTiVGA9uvTGHV6VuP8Hag3arpwsmwtH
X-Proofpoint-GUID: WVTiVGA9uvTGHV6VuP8Hag3arpwsmwtH
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 21, 2022 at 05:54:24PM -0600, Tom Saeger wrote:
> On Wed, Dec 21, 2022 at 01:23:40PM -0800, Nick Desaulniers wrote:
> > On Wed, Dec 21, 2022 at 12:42 PM Tom Saeger <tom.saeger@oracle.com> wrote:
> > >
> > > On Wed, Dec 21, 2022 at 11:56:33AM -0800, Nick Desaulniers wrote:
> > > > On Thu, Dec 15, 2022 at 3:18 PM Tom Saeger <tom.saeger@oracle.com> wrote:
> > > > >
> > > v1 cover has a simple example if someone has capability/time to adapt to
> > > another architecture.
> > >
> > > - enable CONFIG_MODVERSIONS
> > > - build
> > > - readelf -n vmlinux
> > 
> > Keep this info in the commit message.
> 
> Ok.
> 
> > 
> > >
> > > >
> > > > >
> > > > > Linus's tree doesn't have this issue since 0d362be5b142 was merged
> > > > > after df202b452fe6 which included:
> > > > > commit 7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")
> > > > >
> > > > > This kernel's KBUILD CONFIG_MODVERSIONS tooling compiles and links .S targets
> > > > > with relocatable (-r) and now (-z noexecstack)
> > > > > which results in ld adding a .note.GNU-stack section to .o files.
> > > > > Final linking of vmlinux should add a .NOTES segment containing the
> > > > > Build ID, but does NOT (on some architectures like arm64) if a
> > > > > .note.GNU-stack section is found in .o's supplied during link
> > > > > of vmlinux.
> > > >
> > > > Is that a bug in BFD?  That the behavior differs per target
> > > > architecture is subtle.  If it's not documented behavior that you can
> > > > link to, can you file a bug about your findings and cc me?
> > > > https://sourceware.org/bugzilla/enter_bug.cgi?product=binutils
> > >
> > > I've found:
> > > https://sourceware.org/bugzilla/show_bug.cgi?id=16744
> > > Comment 1: https://sourceware.org/bugzilla/show_bug.cgi?id=16744#c1
> > >
> > > "the semantics of a .note.GNU-stack presence is target-dependent."
> > 
> > I wonder if that's an observation, or a statement of intended design.
> > A comment in a bug tracker is perhaps less normative than explicit
> > documentation.
> > 
> > Probably doesn't hurt to include that link in the commit message as well.
> > 
> > >
> > > corresponding to this commit:
> > > https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=76f0cad6f4e0fdfc4cfeee135b44b6a090919c60
> > 
> > Seems x86 specific...
> > 
> > >
> > > So - I'm not entirely sure if this is a bug or expected behavior.
> > 
> > Nick Clifton is cc'ed and might be able to provide more details
> > (holiday timing permitting; no rush).
> > 
> > >
> > > >
> > > > If it is a bug in BFD, then I'm not opposed to working around it, but
> > > > it would be good to have as precise a report as possible in the commit
> > > > message if we're going to do hijinks in a stable-only patch for
> > > > existing tooling.
> > > >
> > > > If it's a feature, having some explanation _why_ we get per-arch
> > > > behavior like this may be helpful for us to link to in the future
> > > > should this come up again.
> > >
> > > While I agree - *I* don't have an explanation (despite digging), only
> > > work-arounds.
> > 
> > That's fine. That's why I'd rather have a bug on file that we link to
> > stating we're working around this until we have a more definitive
> > review of this surprising behavior.  Please file a bug wrt. this
> > behavior.
> > https://sourceware.org/bugzilla/enter_bug.cgi?product=binutils
> > 
> > >
> > > >
> > > > >
> > > > > DISCARD .note.GNU-stack sections of .S targets.  Final link of
> > > >
> > > > That's going to give them an executable stack again.
> > > > https://www.redhat.com/en/blog/linkers-warnings-about-executable-stacks-and-segments
> > > > >> missing .note.GNU-stack section implies executable stack
> > > > The intent of 0d362be5b142 is that we don't want translation units to
> > > > have executable stacks, though I do note that assembler sources need
> > > > to opt in.
> > > >
> > > > Is it possible to force a build-id via linker flag `--build-id=sha1`?
> > > That's an idea - I'll see if this works.
> > 
> > Yes, please try this first.
> 
> --build-id=sha1 is already being supplied during link of vmlinux
> 
> > 
> > >
> > > >
> > > > If not, can we just use `-z execstack` rather than concatenating a
> > > > DISCARD section into a linker script?
> > >
> > > so... something like v1 patch, but replace `-z noexecstack` with `-z
> > > execstack`?  And for arm64 only?  I'll try this.
> > 
> > If --build-id doesn't work, then I'd try this. Doesn't have to be
> > arm64 only if it's difficult to express that.
> 
> I went back to only trying this on arch/arm64/kernel/head.S
> 
> -z noexecstack doesn't work
> -z execstack   also doesn't work
> but removing both does work.
> 
> The flow is roughly:
> 
> gcc head.S -> head.o
> ld -z noexecstack head.o -> .tmp_head.o
> mv -f .tmp_head.o head.o
> ld -o vmlinux --whole-archive arch/arm64/kernel/head.o ...
> 
> If I supply just the compiled head.o, not .tmp_head.o everything works.
Sorry, this is incorrect.  ld of vmlinux actually failed.

relocation R_AARCH64_ABS32 against `__crc_kimage_vaddr' can not be used when making a shared object
arch/arm64/kernel/head.o.orig: in function `__primary_switch':
.../arch/arm64/kernel/head.S:897:(.idmap.text+0x458): dangerous relocation: unsupported relocation
.../arch/arm64/kernel/head.S:897:(.idmap.text+0x460): dangerous relocation: unsupported relocation


> 
> ld of head.o with either {-z noexecstack or -z execstack}
> adds ".note.GNU-stack" section to the .o
> 
> This seems to be the difference.
> 
> Ideas on how to proceed?
> 
> > 
> > >
> > >
> > > > Either command line flags feel
> > > > cleaner than modifying a linker script at build time, if they work
> > > > that is.
> > >
> > > well... that entire linker script is generated at build-time.
> > 
> > Fair, but yuck!
> > -- 
> > Thanks,
> > ~Nick Desaulniers
