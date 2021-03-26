Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24C034B10C
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 22:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhCZVDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 17:03:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42314 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhCZVDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Mar 2021 17:03:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12QKxONe051985;
        Fri, 26 Mar 2021 21:03:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2020-01-29;
 bh=SPAQc8Bpmn1TO+ORAZujMPD6OWEiDkFUDHAoYnUhRh0=;
 b=Friu13FHw3Fm/20IyO+eVHxZCSmKefQTFB2bNjrjx/1COeVl+2dDjTaJ/QyR6R0iZvVl
 SrLP3rs4SvlCfNyWKk4g8FC5o+39OmZTvzSPbwaLRqYtEx//oc/+2oNVd7rIjMOo9RYS
 slVY8Em6QaJ71EbkzFA79Vjd1zp4+2rWW0HmzPTr6Ofulb2GXG2HyEIo9pmRbSJhXU1F
 vmV2NmrHLtiYQWRlL8nF94g7RCWeevyCLOu9FUNw9xBd68iO80BPDdJgu62VSh15qez+
 4KCAGVs1UdPhYVd/ujW0TBDSf82g1Ni49uS9iT4ftFLKhgI8IOdWRu4qJfzWN9FKmpjD Xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37h13rucrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 21:03:40 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12QL0aRs167409;
        Fri, 26 Mar 2021 21:03:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by aserp3020.oracle.com with ESMTP id 37h14nkgvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Mar 2021 21:03:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVO52WAsX0NidZETuF8pLLKFmkqFvJHSe0wiHi1NebJJjDcWTuIYrUNYxQJ53fRY+y+2pb5Ti/gM55IXilKyIAre1JNPHfL89RmiD/ZDisYAA/QeeTGfoHkcJ6Gxy6aYbxR/8xR02gch6ernDl8MYIVkdIXuQpAlZaHpdLCE9VbrEBFj4sq2VBhttcj7OePCUzsZeOMx22yNF4jLuaK7sdDiDiph2IPzV5BgbhHxExgXhGN+MTMMzTV1a9dhBD1cNSAq/avv+kqw59++vq+Q7bb7SqpRv5vUG5kpZ4bVjz1QagdSTXeg0afny2RRAX8ecEQzsrK6pQTMdrTyJSBpDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPAQc8Bpmn1TO+ORAZujMPD6OWEiDkFUDHAoYnUhRh0=;
 b=D8e136M2v40K/fh3yj94iPXRF7i2TIz9PAxsfs1SZ+AWurwl7OIFcIfX8eI2wlIxzufhM0ASG6fPrt3l08PgMbjA3f9q2oWNq6ouGsL12ftUuL06l+1xV+vBGaZyUy+LHLNiHbjEMbmqVCNGtt0cgEAGa13gJVCEmNwJvXcqgEMGoQvHPHEshrKiSBjNnB7rQ6zhlYFCE72v6HMwqlU+fvL4LRT3xQMhHgzB3P+e6jy9nY4tha2Su0wZH1LSNdExFmM2OzmrBqx8EXwoUnZniemfPxEB3OybBlJlSyBolSdblfeHuqIevzCbSI3hi4mpzulFFnKBuEKZoDR7CbsXPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPAQc8Bpmn1TO+ORAZujMPD6OWEiDkFUDHAoYnUhRh0=;
 b=khKMo+jL6p4vl0+Gooffm/K1vKKudMG6D93prUuDuTSw+Sppc9FH2JMEqMzB7nfoPhBgKHBjuZxhK9csWAcmbPiUVSnurnAydGnoZ8y4TSOxvRd/5Hy9uvTGodguRLLs7PBOX6UmCt9R0bxSR71UWbZ80w6ojZDxJ3cAgf/pn5U=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by BY5PR10MB4180.namprd10.prod.outlook.com (2603:10b6:a03:211::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Fri, 26 Mar
 2021 21:03:37 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::21a6:5c60:cd6e:1902]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::21a6:5c60:cd6e:1902%7]) with mapi id 15.20.3955.031; Fri, 26 Mar 2021
 21:03:37 +0000
Date:   Fri, 26 Mar 2021 15:03:35 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Sasha Levin <sashal@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: [PATCH] scripts: stable: add script to validate backports
Message-ID: <20210326210335.e6m3cchks32oyzz2@brm-x62-17.us.oracle.com>
References: <20210316213136.1866983-1-ndesaulniers@google.com>
 <YFnyHaVyvgYl/qWg@kroah.com>
 <CAKwvOd=9HwLcTD8GaMsbEWiTPfZ+fj=vgFOefqBxDYkFiv_6YQ@mail.gmail.com>
 <YFo78StZ6Tq82hHJ@kroah.com>
 <CAKwvOdmL4cF7ConV8841BX+Pey571KDWM8CBt8NnYY47vJ_Gfg@mail.gmail.com>
 <YFsMj3kL5Rl/Dc5R@kroah.com>
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YFsMj3kL5Rl/Dc5R@kroah.com>
X-Originating-IP: [129.157.69.47]
X-ClientProxiedBy: BY3PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::22) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from brm-x62-17.us.oracle.com (129.157.69.47) by BY3PR03CA0017.namprd03.prod.outlook.com (2603:10b6:a03:39a::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Fri, 26 Mar 2021 21:03:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bfbf0b62-7b9e-4e2d-d933-08d8f09a9fac
X-MS-TrafficTypeDiagnostic: BY5PR10MB4180:
X-Microsoft-Antispam-PRVS: <BY5PR10MB41805FB6F020B6A2A306CC4BFC619@BY5PR10MB4180.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:525;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6jWyOPaeqTZ3WQDHjpFC2GEzWBYqGBrOMDhEqQVH03oTvO1kio5AyZb3gDAONsT6cz9rE/Z0r7fwuffSBIwQ7p3/x1gpGt2/IoeK4wYR3k+KntZLEjfnl7Sf1+fS/MsGlIGmGvGDeHtVQQjveJZrUcTwIDSKv5H7IW40yWJRLO7Hcv6ZT53PHhjwtGPnjF1dd4o59kvL/MM8Iwx8t3Vvs6nzjfrE9o8oK1FrqY2YiTolW5PAgJnCV55pdXGPOrz58eJzU06m8ktaBcmPvFvey5KPSVzwzP8K4zYD8o8yL/2qbbqTV3SRn9trJqBJwNRs83ntK54c71eviySJli4GAEQMbSlVbTodtInjl3JbpmgtM/P4Jo2HENJnYYy0o3vq+F+17A3/9CrWSGCJ5qXRu59BnucvkpBPcDOcwOGDjNZigu4Juoq25v7j1+XsknpEtb7a9wwKXXzxJhPCVG0Kyoja5UF9IyEvMl2NgrIOem4a0/fTpLbw0aL3+Vbouyd1EWpmOlXWgC5Fe1w4LIvx2TrD7t58CYam4cvaOX5nBoJEiZe/nk/PPhPWo7F3plB9mFTFFIye+2CFAkmLEh2BbpsFwPbHSEYyJlBcAIlmTidiSzUx6ml2RJiQYvy/hqxzm045Qx/oT999QT4N8IQ5nbDiTy27Blk1EZAOnghXryJymhiKQnyD3ZiP7WnmKMM/FhLhft2Y8/r4PmUXC7gsJJtwxVRMOe2zFwse9bJqWIw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(136003)(366004)(396003)(2906002)(4326008)(316002)(8936002)(186003)(54906003)(44832011)(478600001)(7696005)(26005)(55016002)(966005)(52116002)(16526019)(8676002)(6916009)(15650500001)(53546011)(66946007)(956004)(66476007)(66556008)(1076003)(5660300002)(83380400001)(38100700001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NusxecpIGzFqi95Tx988qFi6f37PYDASKLIDeqL49XpSaH/3lQpK3PT8OZWk?=
 =?us-ascii?Q?dEMgVEkJ/gfFVOZgONm/u0Lj4FcvD2QMX1W1WpxPUJoqx5NDr7BppmB/SltF?=
 =?us-ascii?Q?SuJc/uV9WQlz1d3h8SiN/CnjHqOyDalmbU1spPsNB5OprsF7LgOMQv+uWiR0?=
 =?us-ascii?Q?ODqW6SKhqcK8aW5sgg9nPtJiYQitwO0/ndqq2qlOL0ENWz9Hxa968YJeM080?=
 =?us-ascii?Q?BjPYTCvr/pLj8y8QEcvC7ePqwl/uHeP74CGiwiUz9rAuBCdd6KZnev4GWpCf?=
 =?us-ascii?Q?BbDYgscr1qpsB6Xk3tcIM6Kchua0fQ2GIpWRgNdSxenr5o4gytIVQsINDCf8?=
 =?us-ascii?Q?ol1pjX6uakPAH6NLoaKDwrFm1rpwHw6ui8nTDyT+kSd9AZWU+6QB9yLkV4+d?=
 =?us-ascii?Q?JoZbMncj6AjM7uqVvzB4r2Yd9jeSDHgJ4fylwyA8Zb2m9w1eRJKqYvrPRBLP?=
 =?us-ascii?Q?IQnuecSuUx2HdwqRQu2n9OgiFnHxHQy3rrl1wfb6AcQH+Tg1N6q4AjQnjntk?=
 =?us-ascii?Q?irQcqb00QluA+MBF0/rKnUFVlP2I3S+ba+rAJ/unHK/wrrWmJVHim8H2GBEp?=
 =?us-ascii?Q?IkZVdG6SX40EhpEYd1OSRMo5UTfaDmPMeBAIfuevq9pcTaR7PKHLImrbat2h?=
 =?us-ascii?Q?2VSX+dPe1uMUIBCOzlnFMrbg8I4KXAZv+VeMqJLFuyl2po4dCqbCpmTg8+L9?=
 =?us-ascii?Q?0b1WQgsM7nxp9R0e5X4W1k9TlgfeXBHiI6/rior1tSNR9EQen63T5fk1T/ZV?=
 =?us-ascii?Q?mCha8BGUuwTMBFAQZXpiC/8Amd04DSe+HxvvO7TmzEMh/RZECA5hzCquryYC?=
 =?us-ascii?Q?MX7IkpBNtzdm8j+BszACKZm8cIZg/xhU7bryouzcMm8JlW4/WW9fZT3Uieat?=
 =?us-ascii?Q?lW1igsYz2lgQQ9zx6w5yp+ew6W8CHn8o8quqE3wrk1Iqsnigkc2kLvLnP5gg?=
 =?us-ascii?Q?YutZZp/zOY8Jj1UhFfQyWzKJ6/u5PTtaxFq9j7+rh/GIO0xaX61j+/uDfCCf?=
 =?us-ascii?Q?P9UV5zB/yIcMHYfh6RdbYxMwd52ebuUDJDrAHJs+eKSECMHZ5FYORWYQNH/N?=
 =?us-ascii?Q?a9lOtwIvOhyARaeMvjF5TrVr97WaOTPtDey8NnzXrVyec0X0nGXITnyr/p2N?=
 =?us-ascii?Q?8ogf4CnSvfBZUx4beSEg/oD0JEiNxA0pMdRh2WtJqEhsnfwoSQ3yxqfkCBCO?=
 =?us-ascii?Q?jZBAP/tJhaIX/+fWdt/I5qHR9+sYeNjaZPAE8Y4ieb2lj6oHYY4dQm7Y0aKc?=
 =?us-ascii?Q?bk5prbdEIhDaM+2HOtfJappufH8z3CW+tN3zfytp4mnTjqx47VcjqhLNL2VN?=
 =?us-ascii?Q?fUoniBlGZP5kFsV2u1Dz1u9k?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfbf0b62-7b9e-4e2d-d933-08d8f09a9fac
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2021 21:03:37.0628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tYbPEVyH5rLBc/Dfrx4cCa6tmJZI6gWkXM7uKSFwOwh8dsopz2LJvh6HtYb7u3FtG7+89p4CHiMNyaunAGi1mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4180
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9935 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103260156
X-Proofpoint-ORIG-GUID: LamD3KLmMI5j_31-EH2-15iOZ-UqGPLH
X-Proofpoint-GUID: LamD3KLmMI5j_31-EH2-15iOZ-UqGPLH
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9935 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 adultscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 priorityscore=1501 clxscore=1011 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103260156
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 24, 2021 at 10:55:27AM +0100, Greg Kroah-Hartman wrote:
> On Tue, Mar 23, 2021 at 01:28:38PM -0700, Nick Desaulniers wrote:
> > On Tue, Mar 23, 2021 at 12:05 PM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > The only time git gets involved is when we do a -rc release or when we
> > > do a "real" release, and then we use 'git quiltimport' on the whole
> > > stack.
> > >
> > > Here's a script that I use (much too slow, I know), for checking this
> > > type of thing and I try to remember to run it before every cycle of -rc
> > > releases:
> > >         https://github.com/gregkh/commit_tree/blob/master/find_fixes_in_queue
> > >
> > > It's a hack, and picks up more things than is really needed, but I would
> > > rather it error on that side than the other.
> > 
> > Yes, my script is similar.  Looks like yours also runs on a git tree.
> > 
> > I noticed that id_fixed_in runs `git grep -l --threads=3 <sha>` to
> > find fixes; that's neat, I didn't know about `--threads=`.  I tried it
> > with ae46578b963f manually:
> > 
> > $ git grep -l --threads=3 ae46578b963f
> > $
> > 
> > Should it have found a7889c6320b9 and 773e0c402534?  Perhaps `git log
> > --grep=<sha>` should be used instead?  I thought `git grep` only greps
> > files in the archive, not commit history?
> 
> Yes, it does only grep the files in the archive.
> 
> But look closer at the archive that this script lives in :)
> 
> This archive is a "blown up" copy of the Linux kernel tree, with one
> file per commit.  The name of the file is the commit id, and the content
> of the file is the changelog of the commit itself.
> 
> So it's a hack that I use to be able to simply search the changelogs of
> all commits to find out if they have a "Fixes:" tag with a specific
> commit id in it.
> 
> So in your example above, in the repo I run it and get:
> 
> ~/linux/stable/commit_tree $ git grep -l --threads=3 ae46578b963f
> changes/5.2/773e0c40253443e0ce5491cb0e414b62f7cc45ed
> ids/5.2
> 
> Which shows me that in commit 773e0c402534 ("afs: Fix
> afs_xattr_get_yfs() to not try freeing an error value") in the kernel
> tree, it has a "Fixes:" tag that references "ae46578b963f".
> 
> It also shows me that commit ae46578b963f was contained in the 5.2
> kernel release, as I use the "ids/" subdirectory here for other fast
> lookups (it's a tiny bit faster than 'git describe --contains').
> 
> I don't know how your script is walking through all possible commits to
> see if they are fixing a specific one, maybe I should look and see if
> it's doing it better than my "git tree/directory as a database hack"
> does :)

FWIW,

I had a need for something similar and found `git rev-list --grep` provided fastest
results.  Does not provide for the "ids/" hack though...

❯ N="ae46578b963f"; git rev-list --grep="${N}" "${N}..upstream/master" | while read -r hid ; do git log -n1 "${hid}" | grep -F "${N}" | sed "s#^#${hid} #"; done
a7889c6320b9200e3fe415238f546db677310fa9     Fixes: ae46578b963f ("afs: Get YFS ACLs and information through xattrs")
773e0c40253443e0ce5491cb0e414b62f7cc45ed     Fixes: ae46578b963f ("afs: Get YFS ACLs and information through xattrs")

❯ N="a7889c6320b9"; git rev-list --grep="${N}" "${N}..stable/linux-5.4.y" | while read -r hid ; do git log -n1 "${hid}" | grep -F "${N}" | sed "s#^#${hid} #"; done
6712b7fcef9d1092e99733645cf52cfb3d482555     commit a7889c6320b9200e3fe415238f546db677310fa9 upstream.

❯ N="ae46578b963f"; git rev-list --grep="${N}" "${N}..stable/linux-5.4.y" | while read -r hid ; do git log -n1 "${hid}" | grep -F "${N}" | sed "s#^#${hid} #"; done
6712b7fcef9d1092e99733645cf52cfb3d482555     Fixes: ae46578b963f ("afs: Get YFS ACLs and information through xattrs")
773e0c40253443e0ce5491cb0e414b62f7cc45ed     Fixes: ae46578b963f ("afs: Get YFS ACLs and information through xattrs")



> 
> thanks,
> 
> greg k-h
