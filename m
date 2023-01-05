Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8F4A65F53A
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 21:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbjAEUbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 15:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbjAEUa6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 15:30:58 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD76631BD;
        Thu,  5 Jan 2023 12:30:56 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305ITxsY029133;
        Thu, 5 Jan 2023 20:30:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=l4/jX+UrJRZBWeVj01ScBTLp2ExSp5x4B+mLY0gn5As=;
 b=wdjk8iFCEmzGr+HlyI9LjvMfgoAajxf7ix+8lK6N/zERnNLkL5p+9NL5O2y1VQ65XwSq
 l/8Ec3CITYNgUMepQha0MvQYv23ezr9up7toyIWmY7dRN0cawNDn7JD56WMiiZMcAGWE
 wqx/377sM7FIo22og5lGPcCMZFvvFJxAuZ9hZeTbhex52KgyyP+Jzx9Hq8bX7nTsrPuy
 c/r31pXNKaEFoyIlwDEhJVtEiZnrmOCnIbBz+iqWhOZ3MObEtOYZxpgqBv+zGch37JCk
 Y/YvpnNjal4Ek/6tyS77KLIE8zxnRHmhBVgB9sjrirIAk3JQzLTpb9tFX4oE2su6N9Bk dA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mtc0asx0y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Jan 2023 20:30:35 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 305JRZhf023292;
        Thu, 5 Jan 2023 20:30:34 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mwept9gtd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Jan 2023 20:30:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SurO/A68ytalOywB6GLxFBin73dO9yWV6tfUiuA7rnb39DLl9cVZSDIZdj3rzS/tFzZ7sYOaK9h/4SlUC5q2Arr0E/0uVejFpyFVa++lt+XcYR/mpwh7ycCU0rnFWgeda0EgldAOvYfdfdKM6TBoF9/SpTUUFe+i47NbTNeiNsoSelJNQwtvwMXKZgO4tv69dSCuchGkQ1m1HyvVd2vjQT45gGzyeVVpq1I2yWc/lFR6eBxDp0LeZaWtTb91hhb79SFd+53TDdCqnETY+y/PiZuWOnaiK91iuUTbuec5wAhEp/ehAS3LohQ2GNgFF21wvyiYS4EdK2khc3s6pkvjcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l4/jX+UrJRZBWeVj01ScBTLp2ExSp5x4B+mLY0gn5As=;
 b=gMfYOfpcLVuXfkXim5WtcW7ezRQAp5o26KjmS+gKyadjmflHcy2L4zk7UK7BL/oT5ZlyP8E93ZKQPnXycXe/v4vTcrnrGE9wc1cygQy0z4M3HNvB9Bj9SJMxBOae3yhoYFG3+OyiE4kYa1q5dnzWYZipjelQnbEsTQNVfbZMN0Cik8tmjvoi2ZwODV9XiUZdYmoIb1CwsHc1Op9AtmAtcTnCvknehdb0YqNIZorVjqJd6zMMjwLP3EQwRk48FUwHxHT3MkPr6BBTK2EfcU+zv1tSdf2PpwlQ+GNVeick+NIZVj7LLZcGzizssEEO9qh6/6VdPunWphra3xgNUR+0OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l4/jX+UrJRZBWeVj01ScBTLp2ExSp5x4B+mLY0gn5As=;
 b=zgeuobCrrw5NU3Oh/6Y50C59XuCd/WLBzsLNZPBDS9/pG5O7blbqm5eB+VZ+aHFQvZ5TOgXnKE3XC50c66O70MGCceoXfp8XRdwPfPumDAAatgF4/JK1DOv0EhG91MsxlVfGHsQiNWQC1SW4ESdNy/PkpH4971ek0MfOMmGv5JA=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by PH7PR10MB5814.namprd10.prod.outlook.com (2603:10b6:510:125::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 20:30:32 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::cf51:e63a:8137:aae0%6]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 20:30:32 +0000
Date:   Thu, 5 Jan 2023 14:30:29 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>, stable@vger.kernel.org,
        linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Clifton <nickc@redhat.com>,
        Fangrui Song <maskray@google.com>
Subject: Re: [PATCH 5.15 5.10 5.4 v2] kbuild: fix Build ID if
 CONFIG_MODVERSIONS
Message-ID: <20230105203029.hnngbwe4vjmhjc3c@oracle.com>
References: <3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com>
 <CAKwvOdnu6KAgFrwmcn9qhjd+WDyW0ZTSyOzOnSsWhQ1rj0Y-6A@mail.gmail.com>
 <20221221204240.fa3ufl3twepj7357@oracle.com>
 <CAKwvOdkdPNqPQUOqBLqW7m7i-WB0fJLSSpYTPFXnaitBNatoMw@mail.gmail.com>
 <20221221235413.xaisboqmr7dkqwn6@oracle.com>
 <20221222000330.57vazcv6blclpe6o@oracle.com>
 <Y7Ain9pj5cfl49tI@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7Ain9pj5cfl49tI@kroah.com>
X-ClientProxiedBy: BYAPR07CA0065.namprd07.prod.outlook.com
 (2603:10b6:a03:60::42) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|PH7PR10MB5814:EE_
X-MS-Office365-Filtering-Correlation-Id: 0785dcf9-ec06-449c-04c4-08daef5bb125
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hhNAvDS+tsWYX4YW64hN9MQKv+sogcGjxLc+fCCECJiuOrPVStaqjyfQlwEOBMGgjNGrbQWPjAvmFPAsNFxbTB9upJ8l31uKCuIr/lkSeIs0fGMQUWAUv9IuDU04xh1h2iuzvXizFs0co7kegW6h9t9UIc6lKy+y7opjpYDPFmclqoEBt2m3nKNLEPKX44BcR1JF/pvbRB/M/Cd6eJv/Pqg0y1TbUXQEOURgSNGhTKDP+hDFiK/2OXW24wYN9W6phHkqvK1Gql95xoPczUAfcX5vdJGESk158wBzt1sxQMLL4c1aGC1pMnN49K9UtG3lw7xm3YHic+7aocatEASMT6SduSNRetHQEjSdF+Mw7fB3DNv7sn4J+Kx3WnZ8nzlR4rNYok4ESBIPBNHRgrzNHv++qqLXBnvVxwwf9rQGdBlH0Ft7DXe8zBbUW4XPwK2OVVMAiyNkPY2a3xP8py6r+CfH4NIn/OK1GEZcBglIUZlFVKMjWQzH17GI3wol3HMRHjFOrc7tv+uqh0ROUUPzkyhCEiN60odeHrZa2zFCmdPRV31gJoi//rMLsgkBQPCd93EGpOP2x8QhFGORVjx69c+ENYelJY2pZ9W6SI1fsz5mho+H57Zyd+89uKneXjYattzKpR6TjME8qPiY3lmsxoqx8OKIfONrnYa4+npXExG1YuEpXVUuNc049j5jsCdQpa0LqszAxmmqH16gpX76VQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(136003)(39860400002)(396003)(376002)(451199015)(478600001)(1076003)(316002)(966005)(6486002)(2616005)(86362001)(44832011)(186003)(6666004)(26005)(6916009)(2906002)(54906003)(6512007)(36756003)(6506007)(53546011)(38100700002)(41300700001)(7416002)(83380400001)(66946007)(5660300002)(8936002)(66476007)(8676002)(4326008)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CH/Pf9/WmFbck+gd6xJrb4k8f2uJa3ybiD2Z1d4cE+5Z0n9JC52uNeOhtrPX?=
 =?us-ascii?Q?eGKRo62+ZWUfD8sAmD3oSJ4v1sIZz4ybb3nTgKCgFMViIvLUVUfFdUi9KZPo?=
 =?us-ascii?Q?XWggNCL0gC4WV4lZSa/my4pvJE2tWgqbBOC3tn04eFU6cTe1gdNgR2AQk4+F?=
 =?us-ascii?Q?bXzAYJMqyprz9j2pHfn5qrP44ZtfNAc3mVyiqWJ1WvYurMT/eQX/s/20Su3d?=
 =?us-ascii?Q?cFqP19Aj6gegKsVTYuW9UQtUCDNqFdadXdM/xIN/vVLdyVGjz/oHcDv/tG0Q?=
 =?us-ascii?Q?DKL+bsj4hI4gN3MCznstSMBq92ahyhZFhP5WLn5laGd37pn/zw45hybhINWN?=
 =?us-ascii?Q?XcgXrTx5yLtThd8jpBw9GKtStv+apdRm8UQCSfZDwFHHcshdsEP2DrLxzYLc?=
 =?us-ascii?Q?KZwmEgtxkAKaDUthVGHtMQa7DLx24I8ueRTUEXIUFEZFr+A4gCnws4pnzD2m?=
 =?us-ascii?Q?zHcbOyzDPsisYv8J+eZs1NwBRdoBOpKSkvGLgh0xvGULIkuvNPctu32LBwMv?=
 =?us-ascii?Q?EOUYJ4o9tazW9v+fyekZTD/3cgKx+iurDNZksX0P/eGvVwaXlF3yVAYhfFw6?=
 =?us-ascii?Q?K5+cOQOY5HC5gNQbciGZbUoJQIjzFaMDaI2pFPHuVk4CPCu5qNUskR2AF7p6?=
 =?us-ascii?Q?uDd9IYOmyYx/CIiPx+8kuOsgUTRTPj8qr9ZZX0d8nHR7VGVDNQlfUNNiKqI0?=
 =?us-ascii?Q?WWnd8ZPBReCSP3Z+wea7uYa/3/BuWK72SR3UfiiiA5T2xx4jiD81YBMhv80r?=
 =?us-ascii?Q?HgAPIYNReRnt2hHteE9PK4+Fsybowbf6osUxo+TTq/ytYqDQ2IN3eap0Ml+4?=
 =?us-ascii?Q?zX76dM0pK6duBUmLbpdWNeSGK0oj2lZvyifteH4JSNPXWldnryo85Mge60Xp?=
 =?us-ascii?Q?bJZ7SaRtE29owAdkLrtaNqparz4pxvPfymmFHvD7i6ixYcIAAFpLGleJymGj?=
 =?us-ascii?Q?TgaL4ATNzthJOLMBJnrZV3Za5ICc8aLVcrLlZ2Feg2ErjyL+BGCDFqdoWyEX?=
 =?us-ascii?Q?EhEjj4SKWVvMmOOtmLqUUIltIO5B5Vqk21pyq2GFHhA5454e/8fMnG7jiky6?=
 =?us-ascii?Q?p7qrUb4DnJ9v6sVKAQejWzEq4VQCou0hL76uvclkzeyJsp2RYO5G59Nzbcnk?=
 =?us-ascii?Q?J8S7YYo0+4r3lO1t/kVGMvn8QkQPRbHCeqfaepxOj3km1TCilpxGwtkHF257?=
 =?us-ascii?Q?968iFPqS3Fg52gcOVLAG+/9tFE6gqhy6LhyBFSqeN1l/IMXh7BqzQ5bKeWDr?=
 =?us-ascii?Q?/TOlzeUiqGGGBJfsRsOZFIITidqKSfz4vMtHpmFtR5xinXF3BdjAsOoQfZub?=
 =?us-ascii?Q?E1PS2xwQ+/aLi3UgXLx9bq+xch2x+ONgoRniT8NaZTt02PVquaSE2TnBgCYq?=
 =?us-ascii?Q?PXF2ixxUQh3nqG5Lq7nJ3aotj33/qpgC5D8Gol09lIPtFEUT2F7L1J4G43jb?=
 =?us-ascii?Q?iYShBCATXtx5SDPbQpi1MzGLqJN6gIXIBZ5lPypJVsia9bNucWAhZHX4cyBm?=
 =?us-ascii?Q?IWSgC/GhCb7176wv7lu+KoNKr69iw8LvygU464D9KisOccII8BMEAYl5tXkl?=
 =?us-ascii?Q?fV3URWIazRs8rJWKrf1CJLCfCa5cTYy1hJOJDsiZ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?xz1ZGAHEwrb/bZ93tkD5dr7MuBd64A8SisqSWdF3V3Vp0txdFRtHPUGZ9OJA?=
 =?us-ascii?Q?lOtvak2PMbaL6BHLYeCX7eXSJhFQU1pNM+nl1cShcyvUn121RQvR5mEPn2cd?=
 =?us-ascii?Q?6WaMj3y26LJ0sBbuvJjn9bI18tqxKYKrP2FCkGEK7gBpLE2uvCBML6cqCs7x?=
 =?us-ascii?Q?aFwUAFQXb/mTNgwwRdK3Ln9JLyeuuHqNxxXP3pE3trE4r9wjm9BtNMTzcAro?=
 =?us-ascii?Q?DZANu5obC/dUQq7nHtT6A9dkLZpJuVXaC6ulBin4Abf0pilDBIFhQPWNGapm?=
 =?us-ascii?Q?mvmxAVkegJShCgundjUrAojUd6rcr7yM7JLqM7Wht8zPjGPV8WygW6NxikFF?=
 =?us-ascii?Q?V05d2Np15v1g7sFUxSwB1aSIftOROzsPiL10MGZ4nmM7oXTTgBoMR/yPTf3C?=
 =?us-ascii?Q?XJLaRZdoc8mwuSzXlTTEN2FOLOjD0maNEIU5cnzWjJleoNHoHLsiPAad6pgw?=
 =?us-ascii?Q?6K79fCRNtmcCaVLXXP0Qm82aWPjsTT4gwwogtS0VI//IGPEfap+hqWhPDzPK?=
 =?us-ascii?Q?J68bdSQOkZmR+CHmVithvMHmS0yObacE/RxdyvA/zLVgxtlO9jQbZLZ7DbJy?=
 =?us-ascii?Q?/2HGHOKwHo0U2+ok8vTvFZyMrkxsIGcRbD7sDNlY4EDvdMD+SdGJ/SGRDNac?=
 =?us-ascii?Q?VSBQGZCB4ECN0lvjOl/Yrh+TnoLtOJf01hcuAJ6AnzpGHqd/do8x3hmxrZah?=
 =?us-ascii?Q?isxLi7v0bN2kpPMtgPXYyYhUatlNgiVhicB1Hb9lUxuzCNmYu0qRWiqIeM5k?=
 =?us-ascii?Q?8n9geqdUQC7HMJm7MK/W81Yf9ut1ls8WvwNifDlZR7auYuKwI6x/yXKlj7yk?=
 =?us-ascii?Q?wT8NCX28RIVRiJdfKqRcsjS4AXJPId+s87lLCGTVKnDymTxjzbY3otD4l2KG?=
 =?us-ascii?Q?CtxRg2Cz5h/+gFwPCS6bk25MDnlg8kaKxaCTmEwLG5dFhafrmh99pSVW/OQ2?=
 =?us-ascii?Q?uNZ9ZjrmGXdWoFc/HVRmGCEBDgzrBsASx20wS2UfAnyGi1k13aTUNzDi6eFF?=
 =?us-ascii?Q?+ua9DUwLY+u2vTqcFjEIu3jI65+9U/YTYJlmbKB9v2SSf1/gLLHm06P3CWnR?=
 =?us-ascii?Q?fs7W0Pf5?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0785dcf9-ec06-449c-04c4-08daef5bb125
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 20:30:32.2370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XSC/qyxJ6uhJ/VXDclHP2SyeMe3EDdgvT8A3zh6/vy3+SedpZfrW+BTzfwsBx5MOr0ce+7mJuUo7uRfKfJzMdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5814
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_11,2023-01-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301050161
X-Proofpoint-GUID: La_N0be-tauBSza1x7iDtYoqdRy8nPb5
X-Proofpoint-ORIG-GUID: La_N0be-tauBSza1x7iDtYoqdRy8nPb5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 31, 2022 at 12:53:03PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Dec 21, 2022 at 06:03:30PM -0600, Tom Saeger wrote:
> > On Wed, Dec 21, 2022 at 05:54:24PM -0600, Tom Saeger wrote:
> > > On Wed, Dec 21, 2022 at 01:23:40PM -0800, Nick Desaulniers wrote:
> > > > On Wed, Dec 21, 2022 at 12:42 PM Tom Saeger <tom.saeger@oracle.com> wrote:
> > > > >
> > > > > On Wed, Dec 21, 2022 at 11:56:33AM -0800, Nick Desaulniers wrote:
> > > > > > On Thu, Dec 15, 2022 at 3:18 PM Tom Saeger <tom.saeger@oracle.com> wrote:
> > > > > > >
> > > > > v1 cover has a simple example if someone has capability/time to adapt to
> > > > > another architecture.
> > > > >
> > > > > - enable CONFIG_MODVERSIONS
> > > > > - build
> > > > > - readelf -n vmlinux
> > > > 
> > > > Keep this info in the commit message.
> > > 
> > > Ok.
> > > 
> > > > 
> > > > >
> > > > > >
> > > > > > >
> > > > > > > Linus's tree doesn't have this issue since 0d362be5b142 was merged
> > > > > > > after df202b452fe6 which included:
> > > > > > > commit 7b4537199a4a ("kbuild: link symbol CRCs at final link, removing CONFIG_MODULE_REL_CRCS")
> > > > > > >
> > > > > > > This kernel's KBUILD CONFIG_MODVERSIONS tooling compiles and links .S targets
> > > > > > > with relocatable (-r) and now (-z noexecstack)
> > > > > > > which results in ld adding a .note.GNU-stack section to .o files.
> > > > > > > Final linking of vmlinux should add a .NOTES segment containing the
> > > > > > > Build ID, but does NOT (on some architectures like arm64) if a
> > > > > > > .note.GNU-stack section is found in .o's supplied during link
> > > > > > > of vmlinux.
> > > > > >
> > > > > > Is that a bug in BFD?  That the behavior differs per target
> > > > > > architecture is subtle.  If it's not documented behavior that you can
> > > > > > link to, can you file a bug about your findings and cc me?
> > > > > > https://sourceware.org/bugzilla/enter_bug.cgi?product=binutils
> > > > >
> > > > > I've found:
> > > > > https://sourceware.org/bugzilla/show_bug.cgi?id=16744
> > > > > Comment 1: https://sourceware.org/bugzilla/show_bug.cgi?id=16744#c1
> > > > >
> > > > > "the semantics of a .note.GNU-stack presence is target-dependent."
> > > > 
> > > > I wonder if that's an observation, or a statement of intended design.
> > > > A comment in a bug tracker is perhaps less normative than explicit
> > > > documentation.
> > > > 
> > > > Probably doesn't hurt to include that link in the commit message as well.
> > > > 
> > > > >
> > > > > corresponding to this commit:
> > > > > https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=76f0cad6f4e0fdfc4cfeee135b44b6a090919c60
> > > > 
> > > > Seems x86 specific...
> > > > 
> > > > >
> > > > > So - I'm not entirely sure if this is a bug or expected behavior.
> > > > 
> > > > Nick Clifton is cc'ed and might be able to provide more details
> > > > (holiday timing permitting; no rush).
> > > > 
> > > > >
> > > > > >
> > > > > > If it is a bug in BFD, then I'm not opposed to working around it, but
> > > > > > it would be good to have as precise a report as possible in the commit
> > > > > > message if we're going to do hijinks in a stable-only patch for
> > > > > > existing tooling.
> > > > > >
> > > > > > If it's a feature, having some explanation _why_ we get per-arch
> > > > > > behavior like this may be helpful for us to link to in the future
> > > > > > should this come up again.
> > > > >
> > > > > While I agree - *I* don't have an explanation (despite digging), only
> > > > > work-arounds.
> > > > 
> > > > That's fine. That's why I'd rather have a bug on file that we link to
> > > > stating we're working around this until we have a more definitive
> > > > review of this surprising behavior.  Please file a bug wrt. this
> > > > behavior.
> > > > https://sourceware.org/bugzilla/enter_bug.cgi?product=binutils
> > > > 
> > > > >
> > > > > >
> > > > > > >
> > > > > > > DISCARD .note.GNU-stack sections of .S targets.  Final link of
> > > > > >
> > > > > > That's going to give them an executable stack again.
> > > > > > https://www.redhat.com/en/blog/linkers-warnings-about-executable-stacks-and-segments
> > > > > > >> missing .note.GNU-stack section implies executable stack
> > > > > > The intent of 0d362be5b142 is that we don't want translation units to
> > > > > > have executable stacks, though I do note that assembler sources need
> > > > > > to opt in.
> > > > > >
> > > > > > Is it possible to force a build-id via linker flag `--build-id=sha1`?
> > > > > That's an idea - I'll see if this works.
> > > > 
> > > > Yes, please try this first.
> > > 
> > > --build-id=sha1 is already being supplied during link of vmlinux
> > > 
> > > > 
> > > > >
> > > > > >
> > > > > > If not, can we just use `-z execstack` rather than concatenating a
> > > > > > DISCARD section into a linker script?
> > > > >
> > > > > so... something like v1 patch, but replace `-z noexecstack` with `-z
> > > > > execstack`?  And for arm64 only?  I'll try this.
> > > > 
> > > > If --build-id doesn't work, then I'd try this. Doesn't have to be
> > > > arm64 only if it's difficult to express that.
> > > 
> > > I went back to only trying this on arch/arm64/kernel/head.S
> > > 
> > > -z noexecstack doesn't work
> > > -z execstack   also doesn't work
> > > but removing both does work.
> > > 
> > > The flow is roughly:
> > > 
> > > gcc head.S -> head.o
> > > ld -z noexecstack head.o -> .tmp_head.o
> > > mv -f .tmp_head.o head.o
> > > ld -o vmlinux --whole-archive arch/arm64/kernel/head.o ...
> > > 
> > > If I supply just the compiled head.o, not .tmp_head.o everything works.
> > Sorry, this is incorrect.  ld of vmlinux actually failed.
> > 
> > relocation R_AARCH64_ABS32 against `__crc_kimage_vaddr' can not be used when making a shared object
> > arch/arm64/kernel/head.o.orig: in function `__primary_switch':
> > .../arch/arm64/kernel/head.S:897:(.idmap.text+0x458): dangerous relocation: unsupported relocation
> > .../arch/arm64/kernel/head.S:897:(.idmap.text+0x460): dangerous relocation: unsupported relocation
> 
> Ok, I'm confused and don't know what to do here.  I'll drop this from my
> mbox queue and wait for a revised fix to show up.

I'm actively looking at this, but running low on things to try next. 

--Tom

> 
> thanks,
> 
> greg k-h
