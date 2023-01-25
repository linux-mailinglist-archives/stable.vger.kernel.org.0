Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 993B067A7C9
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 01:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbjAYAea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 19:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234144AbjAYAeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 19:34:25 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E559D41B53;
        Tue, 24 Jan 2023 16:34:23 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30OKx48C032339;
        Wed, 25 Jan 2023 00:34:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=uVK+5uBQas/vc25y0Trga0MveyrTjfPrK9DtJQ+L+4Y=;
 b=009DS2Gl3t6KlBAIn6brxKJQ0xg2v61JVEBUHtg35tpkukE4JceISSVGWajxUfTyU/hG
 KgL1Gv/sq9y1sXt8qM0F+ufrXGKcl/GTeqOijQVUUg7rSJYFReUYI0hgotdRFQ/tJ/hO
 491J2TWGwaqzEKPw7tNik8ot6iN3YxqhaOAkwyWRL2A6vLK6GxLPHetSsr59xIG5os+/
 uIGq+8Q1ZBM7Pu5ibxZfmFDZ86K48pUTu0G8SYg7G196+JXompWXP95SDLMECagVt7H+
 fXQMd1OsAwGf9ijmXcrelkgYuZOgth6yjwEcweFXWcBhl9HuS+bF8Atwaayc9YeBX5as Kw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86ybetbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 00:34:12 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30OMRiZb029364;
        Wed, 25 Jan 2023 00:34:11 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gc1xbd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 00:34:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ihgmbXnYDtxdY+gXs5dBxdIe7/mXR95XujrC6ebV5wLFl+TlCW/XFyWtrTz/gX/ZAu+RNmp5fP37J/LZ8czqPfp1EdQ59+v/HUZZoluwUEG3tPguN4ZZjbD0ONBesK7ujWf/oGWmkpdDCSbjhRyup2gDvTnpvA87ZWJlzfgDb2XHVv0GmsLNSSEmjBIV8pO8TkUpp+td2gBT04Ud1sI8TTlZn+cXWJxWCrtftUHEGOtqO4EF5DIHf0JNmNgGABhTJPCuAyFzWRiONLDvqu5amRrP4NQDAiC7wMb7fHap1Xrfj6DrwVh287x5oqd946soqnqH25wjFBuTj/ftYSmMCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uVK+5uBQas/vc25y0Trga0MveyrTjfPrK9DtJQ+L+4Y=;
 b=TQNT+KRAXFTlwaoQZtPk2YQ0M6Ni4sYNuOduZFjiAKY77bm1aNPbVCOvUXHdfMqmEccpONKIwRiVxZg+WsqEJBSEYxmeB1EKV3SOFx01swHmchc1R/44iRG809CDIUYCrR9V3Dqm97m2xqZyDfLCYHm+PnwypO/9eACrSRL3qfVgwJN5zryof0PkXcL3ObgdRcoGSQr7M+Joi6OPnhVe43rCM4cF9sH5RSgL+i9wSRk1xwEYi3mqBwVbszofKPeht0ORfU1C1IHN4gN+QxgjldMt1n9kRCu4PyU67BmOrikaEbzZVTHTgfSF1ad69ZuK63jCIWkf03E1wkxocGxeNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uVK+5uBQas/vc25y0Trga0MveyrTjfPrK9DtJQ+L+4Y=;
 b=R+yh9z49Cz5qQo/LUwSuopqEX4XmxBj08PMNWQ9lCLnrdx6AyNnQGU8nFnHFQoNc29rpRZ4k8LeEImeMogOCT1rfJMZtmck1PfaNXfM916WtrtWSu+fTlyNS7X/tQlwSnwvXz4uYdRCEtUP0ldElkwozQpTOypggcQUyLVZEJNs=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by CH0PR10MB4988.namprd10.prod.outlook.com (2603:10b6:610:c8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17; Wed, 25 Jan
 2023 00:34:09 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14%8]) with mapi id 15.20.6043.020; Wed, 25 Jan 2023
 00:34:09 +0000
Date:   Tue, 24 Jan 2023 16:34:06 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, Jeff Xu <jeffxu@google.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Pranith Kumar <bobby.prani@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: Re: selftests: memfd: run_hugetlbfs_test.sh - invalid opcode: 0000
 [#1] PREEMPT SMP
Message-ID: <Y9B4/pR5t2o51coY@monkey>
References: <CA+G9fYuei_Tr-vN9GS7SfFyU1y9hNysnf=PB7kT0=yv4MiPgVg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuei_Tr-vN9GS7SfFyU1y9hNysnf=PB7kT0=yv4MiPgVg@mail.gmail.com>
X-ClientProxiedBy: MW4PR04CA0237.namprd04.prod.outlook.com
 (2603:10b6:303:87::32) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|CH0PR10MB4988:EE_
X-MS-Office365-Filtering-Correlation-Id: b5d493a3-5d76-41cf-aee2-08dafe6bdf5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 66jViMhv4AwI+Dl27a7xAaSNz0h9sZzGkKTpAz5UlDpjYgXs9dUWNKPI2zY/93Vyp16dRM2X8TegdvXEUNHY2dG9YCvGJVSgJNrYdx54MuwjBYWHXDi0KMDnWjIXo7he2QOfxMSYZva5JOHu0NyYyMEvT9PaG1xzGth+GsR+z2VzSU/5PepCcsVDIME4Ci+TAoyLFMgpj+e4yiUVFrTZfeQSP6CsrWAvqCuESMfCVa3Vkiu4StSX+Hna75Kw8NVl9xYxK9gVKNqUgTfKl9waGv/nylm6NEOin+tsQovYAmuKQMh1NUGiT/d9fBsgkXXn5O/Ji91yZ2WFIFUaqRqAnpQ+OU3W3YTd7HaNoZfpMGW96uKv0mWBLg7clkBt8f7IlavNUorFPkoJK7LO4c6okCCWuuTwspIlgTA4NT6Wr9MIFmqMbRS3opItmx6y9wEDDGoBVkF4ik3yiE6hDQ2dlJJjIPqbo8phqJ3SFrRaRgno/m13UrHGDSv8zahZjmwRNZ3F16lXtBJx0xbUbaq2XrZtNOMBt0SZdcmhdQqR1i9sKtPTCLGJCXE3KUkaM2SNSApY9FnsPRhN9a4xIPulUTdxoHRyCc00y/uqCZTjZDYA4wWuRWWI/dHqiy22XN9WUuEOgeFHdrq48uGA5Xfo9VhG1zVjGiIpGFCcIyQW6lcSspEy2TX3+fqKj+eQSs93y1PxizIT7midwz4IakClMjO834iFNHemFeVpBTV5k0gZdx1qA8M1Ig/C5ryWqQUF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(396003)(39860400002)(366004)(376002)(136003)(451199018)(478600001)(66946007)(5660300002)(8936002)(44832011)(186003)(7416002)(966005)(6666004)(9686003)(6512007)(26005)(83380400001)(6506007)(66556008)(6486002)(53546011)(4326008)(6916009)(8676002)(66476007)(38100700002)(86362001)(45080400002)(41300700001)(54906003)(316002)(2906002)(33716001)(17413003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ywS9Erq8E/y789nFGWKY+DiLmK31okQzizYzB2f0a6ZCSQNhomw8wI2c/01S?=
 =?us-ascii?Q?2qZ4PfKX4CMmficBDRQSHrQRXW4qJoSZcTcQIhP6DoEYNJOPU3doovBrSwHK?=
 =?us-ascii?Q?Erm6trVI2uuRIvPqqxp9unJS+b18Q62l7WD0VRsQb6lAMaUz2n8VlcQuBjw9?=
 =?us-ascii?Q?TtDdoYaDFIV/TBTuJlnyd/4ZUjyjjI5do0CtPNBuJDM4eKMsjk4F97nehE8n?=
 =?us-ascii?Q?EtgAke+rdmxfTEnD5PUv4JUgN/7UZZ30AgtrccIzX0/XOkb0bjrTpg5DIEDF?=
 =?us-ascii?Q?rKrnGfNYCToh3bgRjbVTlKJTgf/GPB4clsvBWPE69vqM1VHLo+wkvDQ5MywX?=
 =?us-ascii?Q?DdZtgHObLb7dy07ggSlCMqxQ/G/wcCuZ76QL9eVBLkTfxuTtvL9/AmYfSVrO?=
 =?us-ascii?Q?SqJodceLedG7tvsdoSLqo5fING0XenkRHg6j8j2aoR1OqR690IOuhgiW/kW8?=
 =?us-ascii?Q?vcHU9vKd8RreW/dRoA9AlDlS/wo2JoahxpD17p8qYLJetFc7n6biBsLGanvW?=
 =?us-ascii?Q?+rprW/9YhjhquxgRU/Qh6Ps+RUT5E4iYnl6I/u9jyt0Rq9JHXreDv0MfJQOY?=
 =?us-ascii?Q?ldXfhAkUrnYNbgqDzh1wpo6Ps/bIdjC+S/9o1gCVDSEBCQVYPntLRMcUmMDG?=
 =?us-ascii?Q?7XqXcol4jzoNaYBbhgf4yRnAVYZLAyGvjrR6UzGwXBk7P8UeRKCQ/79PKXD9?=
 =?us-ascii?Q?h8xRIKkhlbeFXD0saQW4RKdru/rAk/X4aP7PbHtWOfKaNLMRHO2QWbY2y+To?=
 =?us-ascii?Q?0gAKg7EemrMVvytRY0JYbgyFs5Ef45pqVJRskQkizTqSysyAj8F8JY1uJdBc?=
 =?us-ascii?Q?nZ1TA9f1IGU7MWNJ/BZQw/YUmvXCZjL6sMi4l0AP3L48tlCGJs76P1m4CNlJ?=
 =?us-ascii?Q?HUJqcooohj9jN22fbNgF9UBGRIrj3TpPtXQU+o07Df9TzYtrEQWNsa4yeIwh?=
 =?us-ascii?Q?naFZs1bhGkWLfTxltzqnPThniQqHivp0+doYYJ5sIiq6yn2z0R4OWvZdQ6y5?=
 =?us-ascii?Q?9kq69Jp5qscZxf3FbixlW2w8Fnp8t+Zi/t42hX6Nq9XRqPdU3ynH6PMuzigL?=
 =?us-ascii?Q?ZH8o1hs0JLASSlojpSPnDQWYSoEUahptb7DcWJA7D2nLXJ7utmMH73zuDl/L?=
 =?us-ascii?Q?/sMLAK6ZPkg9+odUt2HwgWvAG4qf2BmXHtpa9+9kLTYgexWLiM+0p5NFMaFi?=
 =?us-ascii?Q?bAeq+9600R5iR5GyWhRdgmy8z4xQwQmyKD4Wm32hdEJtiTeMXvkplC72rzw+?=
 =?us-ascii?Q?EgPeonB8KdkTlrUFQ1ZTtkeQBU0BdyaXORssZryCNLfdkE5cn5TM0VVG0Q6n?=
 =?us-ascii?Q?RqXU5zhKVkCrETOCrTgnQlrtqt/XkI6WsB8snosp7GadMUuOckLHP0FpiNyD?=
 =?us-ascii?Q?8OqiskGX4TUCbUanXa7u3acZBECV/Urak7Nk/lT4CDikWcwjceJ+ItIT9CB0?=
 =?us-ascii?Q?2m7yP+BPyCyjJdmpx89LCa5ppmOcG/30fEEX70vmuWuLdo1Z/01OVoz6khoz?=
 =?us-ascii?Q?UpHj80CXbXWLaGGU5l5EAG1WooRqxz5GGt7orz/cGoeoPwFXfNnEoz38Yqi0?=
 =?us-ascii?Q?HWXZSgDu9mxVYrZDioAXq0BrNAG93C/n8Rz4cDEvcKrYmDNBJtlVzeIVR0W4?=
 =?us-ascii?Q?lA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?Z+0KFYbxUCZrOZJZAzVzYcIoT7vObLCKxiVRX7B3m16weKYzQrtRsBQjyUNV?=
 =?us-ascii?Q?0UItxWOOGNFDXiFWXdqgqeKlr/HoCeaYZo9L1zoab57sQP3jAqCJqRr+88x3?=
 =?us-ascii?Q?43nhW6EIj8mBYrqccIfDKn8cN2ahxJMPvhyMk24vdSQ1Zc5pNSfndp+Ltkee?=
 =?us-ascii?Q?rhVURCXssN3dNErfTxMSZYb6RLt4SQsJPAM+9FslYteQIe30AtDnkK0hReCm?=
 =?us-ascii?Q?kx4xslObDYew+vPYQJs/YDuJfnh+pxqU7ZjLqxuj1B/4vAc4aXULloZAfkBj?=
 =?us-ascii?Q?pSeNC3h7uK7362tZ1l3jT90S6MliNphkULF4YgYa+9uoZrbWX4a796nN7Knn?=
 =?us-ascii?Q?GXO+1keF+ptbE/p8Jfwxz2Qim9QAxt9XOf1PJm9RMIuuUC6OUN8MImk+Ssf7?=
 =?us-ascii?Q?vWWqPPTprmq8FZHoBlh8yXw8hkeRdENCqVb6L8dVnHFQjh5C6B+u8Jbd/I3B?=
 =?us-ascii?Q?jQdzHKYM+6Cr7unMo00u4irsZwG9KIqecrR1mFbD6OHdYQwMXjXeX/WGtprn?=
 =?us-ascii?Q?PfCMTKda0ZsWmGJilJ1gGG85bmOURK3hFrfI9mqTWtV2Ewhx+I1/MtgClCMh?=
 =?us-ascii?Q?IPLFARtXN9/vu1noL0osKR3/I5Do9mY0Bcs0rgbL+nkabqUmIHKbFi0+38BL?=
 =?us-ascii?Q?DlSigP1s6ckE0gk6ynCEsJyuYgOsoCGG+WCJmY5zT4W7dpBj5gbkk+ovE6FB?=
 =?us-ascii?Q?P2+Hi5X/8EYPNcsTEVIf3zatgHfjuOxnTkrhy9BeGhG7fIk4oT1ru90gFQUp?=
 =?us-ascii?Q?Vq2Mfpz9iiO4SFmynDTK89kqveFEUVn0bt/shHECwIaW5kIcBZRvEJsDWvcE?=
 =?us-ascii?Q?7Pi2s2vCS5QIHqaqJrVJ+MBwpo2ByUocOtRUpvTHIRYJfv8fSDmOXlI3EeUw?=
 =?us-ascii?Q?G4Fsh/Z9h+BnaSBrT8GArsAz6jSayEEDZ1BRvyiXxaGwKBYQ99wY2BD6Su5z?=
 =?us-ascii?Q?/2/a3VAUFES6wr4yqMdFMLMVwUHx4M3d9j2nUq/J1fftAYsXNUVR5R8ekED6?=
 =?us-ascii?Q?WMGAKdwOUMkqOrLZi+VFfrik39H8pjJEUDwTPobNErXLgqru4VVbkPZjoGKo?=
 =?us-ascii?Q?kQG3h2xD+z+RirT/11x7rsLLzWXkhg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5d493a3-5d76-41cf-aee2-08dafe6bdf5f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 00:34:09.3124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ph7sa7bep1BTGpjUfss53RYIc/dEJytJVJ2c5KQsvn+YhHmUdx/uBbc5wvmElApxcSGX8zxZRaMPEANDWinD4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4988
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-24_17,2023-01-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301250001
X-Proofpoint-GUID: ZTAnSg3KV3M6Wo13CfaplfIbRWv1cfCE
X-Proofpoint-ORIG-GUID: ZTAnSg3KV3M6Wo13CfaplfIbRWv1cfCE
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01/05/23 15:14, Naresh Kamboju wrote:
> While running selftests: memfd: run_hugetlbfs_test.sh on qemu_i386 and i386 the
> following invalid opcode was noticed on stable-rc 6.1 and  6.0.
> 
> This is always reproducible on stable-rc 6.1 and  6.0 with qemu_i386 and i386.
> Build, config and test log details provided in the below links [1].

Hello Naresh,

I have tried to create this issue a few times without success.  Since I
do not have i386 HW, I am using qemu_i386.  If I use the supplied config,
my kernel does not boot.  I then try to modify config options which I
think are not relevant.  By the time I get to a config that will boot, I
can not recreate the issue. :(

Just curious if you have any suggestions?  Or, Wondering if anyone else has
suggestions on how to proceed?
-- 
Mike Kravetz

> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> # selftests: memfd: run_hugetlbfs_test.sh
> [  111.866742] run_hugetlbfs_t (1023): drop_caches: 3
> [  111.892484] invalid opcode: 0000 [#1] PREEMPT SMP
> [  111.893089] CPU: 2 PID: 1026 Comm: memfd_test Tainted: G
>      N 6.1.4-rc1 #1
> [  111.894015] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.12.0-1 04/01/2014
> [  111.895048] EIP: hugetlb_file_setup.cold+0x0/0x33
> [  111.895597] Code: ff e9 07 f3 26 ff 0f 0b c7 04 24 c8 ee dd c9 e8
> 25 47 ff ff b8 ea ff ff ff e9 ac f8 26 ff 0f 0b 0f 0b 0f 0b 0f 0b 0f
> 0b 0f 0b <0f> 0b 64 a1 98 48 3a ca c6 05 f3 42 22 ca 01 8b 90 d4 03 00
> 00 05
> [  111.897716] EAX: c4957128 EBX: 00000000 ECX: 00000020 EDX: 00000000
> [  111.898431] ESI: 80000004 EDI: 00000005 EBP: c552bf04 ESP: c552bee4
> [  111.899218] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 EFLAGS: 00010212
> [  111.899991] CR0: 80050033 CR2: 00000000 CR3: 0528b000 CR4: 003506d0
> [  111.900774] Call Trace:
> [  111.901072]  __ia32_sys_memfd_create+0x196/0x220
> [  111.901616]  __do_fast_syscall_32+0x77/0xd0
> [  111.902119]  do_fast_syscall_32+0x32/0x70
> [  111.902620]  do_SYSENTER_32+0x15/0x20
> [  111.903134]  entry_SYSENTER_32+0x98/0xf6
> [  111.903701] EIP: 0xb7ef1549
> [  111.904034] Code: 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01
> 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 51 52 55 89 e5 0f
> 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d 76 00 58 b8 77 00 00 00 cd 80 90
> 8d 76
> [  111.906124] EAX: ffffffda EBX: 0804b486 ECX: 80000004 EDX: 080493de
> [  111.906902] ESI: b7ccf220 EDI: b7dc58e0 EBP: bfe56cf8 ESP: bfe56c8c
> [  111.907637] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00000292
> [  111.908502] Modules linked in: sch_fq_codel fuse configfs [last
> unloaded: test_strscpy(N)]
> [  111.909502] ---[ end trace 0000000000000000 ]---
> [  111.910064] EIP: hugetlb_file_setup.cold+0x0/0x33
> [  111.910638] Code: ff e9 07 f3 26 ff 0f 0b c7 04 24 c8 ee dd c9 e8
> 25 47 ff ff b8 ea ff ff ff e9 ac f8 26 ff 0f 0b 0f 0b 0f 0b 0f 0b 0f
> 0b 0f 0b <0f> 0b 64 a1 98 48 3a ca c6 05 f3 42 22 ca 01 8b 90 d4 03 00
> 00 05
> [  111.912785] EAX: c4957128 EBX: 00000000 ECX: 00000020 EDX: 00000000
> [  111.913518] ESI: 80000004 EDI: 00000005 EBP: c552bf04 ESP: c552bee4
> [  111.914259] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 EFLAGS: 00010212
> [  111.915104] CR0: 80050033 CR2: 00000000 CR3: 0528b000 CR4: 003506d0
> # ./run_hugetlbfs_test.sh: line 60:  1026 Segmentation fault
> ./memfd_test hugetlbfs
> # opening: ./mnt/memfd
> # fuse: DONE
> ok 3 selftests: memfd: run_hugetlbfs_test.sh
> 
> [1]
> https://lkft.validation.linaro.org/scheduler/job/6022150#L2079
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.3-208-ga31425cbf493/testrun/13974189/suite/log-parser-test/tests/
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.3-208-ga31425cbf493/testrun/13974189/suite/log-parser-test/test/check-kernel-invalid-opcode/details/
> 
> metadata:
>   git_ref: linux-6.1.y
>   git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
>   git_sha: a31425cbf493ef8bc7f7ce775a1028b1e0612f32
>   git_describe: v6.1.3-208-ga31425cbf493
>   kernel_version: 6.1.4-rc1
>   kernel-config:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2JrzvZc223pctlAxVhCIebJ8q0w/config
>   build-url: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/pipelines/738268273
>   artifact-location:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2JrzvZc223pctlAxVhCIebJ8q0w
>   toolchain: gcc-11
>   vmlinux: https://storage.tuxsuite.com/public/linaro/lkft/builds/2JrzvZc223pctlAxVhCIebJ8q0w/vmlinux.xz
>   System.map: https://storage.tuxsuite.com/public/linaro/lkft/builds/2JrzvZc223pctlAxVhCIebJ8q0w/System.map
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
