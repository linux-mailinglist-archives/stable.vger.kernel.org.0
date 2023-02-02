Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C529468894A
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 22:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbjBBVyn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 16:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjBBVym (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 16:54:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184FE50860;
        Thu,  2 Feb 2023 13:54:41 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 312IDrjd023689;
        Thu, 2 Feb 2023 21:54:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=rOhEe4JTaeZT9oWRw1RQjWMYPfqNIPVK3y90FCX1rKg=;
 b=QrDZoTReY3NWqqDICci9WB6fp9wIdrfXcf2oyIRcNje04fr99jt9Qcr2gFTL4rDg5nhJ
 ccSXWgtW4dzmk0cgltrLSKnF69cjGo7Jy70uZqla//j+fdTc69QnkY5oX1F+6CLnPaB3
 P4a71Nbz1bJSHmZWvb3WdSo2sWnCU9fKNdE2lMUmNHQ4oJy6aSI1wqpTB47bbYZGYti5
 887uwEgb2nuJ0A+/qvLv+PrvOexIoVy8Yv90A3nTMsL2Ctcovh5IKr0BiEvcGmoll2tb
 rC8NBTsA8mWXDqKLfnYUCoWkd4ltHfbvBRQu/9IjSfdD6AU/AMnjx2ouZ8Qz0Gu2G4r0 4A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nfq28v1bn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Feb 2023 21:54:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 312LGT3o005046;
        Thu, 2 Feb 2023 21:54:29 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nct5gs803-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Feb 2023 21:54:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EyBNHl8UCq6GeWp/ZNkGzz8j0dntyqnX8q2XwV2fi5GEcrScRccY3lxoZDjuFdX1KtF75MW0AUdcaDhMnpP7VHm0+qUihaL8S5yhZ5WOEzch4L+3EwMprkK7iM0u8vCE8auKQ/iFpvJahdiU8+g4QV+e1LDAvbklRRVD6cavxbKVjWVmVtpJb1cAlHPwQwu2tYbbDDXmQGGAKyIybZA//dv0XsMzGDzDPr7vEr4nGdq6SRkhRSJUA6CotXkCkMp0k7xaWVmL0b7t72vioTn3bzgsZp75XgvxvRKK2eqQ/Od9qWf5yP9e2wFAjMuri6VuvROgxKCh2VAPbK8VjD6CHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rOhEe4JTaeZT9oWRw1RQjWMYPfqNIPVK3y90FCX1rKg=;
 b=ekWL0YSVSEEVatakGRF93/q0DXI2JJnmNJTJAfp30fITxkuscpJKlCSqztZmtdwY6/z+UHJRQMi7qOegZaDK4szInj+DlWaLkrInWiw5i8X0DZ7iUoem8/JY0dYoNiY9ChX/y8TkzyxLAQrD/FJEHueWi8AsbWu0kyHrkvDKgjBJEJvKLXuH9pOX0vnZl1S3W6sJAmOKdSZhxN9l1PdjFHZaQzIxVGFL8DNjpFzdUnZULkAHVWnRGPBXGExNrOsEXa0pjWv98FwP6fkk7z4yc4Rg65VTPF28AAsDkn9I3Sqnz0mA1w+/4PVwevHbbFEV7tRZPLPp7KoVWeY+Fa9qBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rOhEe4JTaeZT9oWRw1RQjWMYPfqNIPVK3y90FCX1rKg=;
 b=BQdtyUr8oly08TIuOSsKuHHBBeGKTV5xMZ11MDvGJGhtDX+tkYd77tWKGkHJcgy8uJ/4Zwgxm3DweegliUjPGnSSB3ikvAGuyO5+hCn6MfHHGpBBbV42bwz9d8wOrujxqkhHNZ4R+EoWVgkjQRoOmmDuPBzPPyqK+QiAFvSNrxU=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SA2PR10MB4810.namprd10.prod.outlook.com (2603:10b6:806:11c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Thu, 2 Feb
 2023 21:54:27 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14%8]) with mapi id 15.20.6086.007; Thu, 2 Feb 2023
 21:54:27 +0000
Date:   Thu, 2 Feb 2023 13:54:23 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>
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
Message-ID: <Y9wxD0ngdo832Az5@monkey>
References: <CA+G9fYuei_Tr-vN9GS7SfFyU1y9hNysnf=PB7kT0=yv4MiPgVg@mail.gmail.com>
 <Y9B4/pR5t2o51coY@monkey>
 <CA+G9fYtt_FR54zwStiTguiyS0QDHe-x5+2Py9_hvxKAbYHM_fg@mail.gmail.com>
 <CADYN=9+=p0cYu63feXfZVXZTGruJP_i5dA3AuP0G6Fh_rfQO0g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADYN=9+=p0cYu63feXfZVXZTGruJP_i5dA3AuP0G6Fh_rfQO0g@mail.gmail.com>
X-ClientProxiedBy: MW4PR03CA0106.namprd03.prod.outlook.com
 (2603:10b6:303:b7::21) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|SA2PR10MB4810:EE_
X-MS-Office365-Filtering-Correlation-Id: b1694972-0784-4609-f575-08db05680da7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EUvzmLqKBSOaQZiu3FMFVkHwnx1uaAa/dnrdRb+KlRlj/Zz0CUGxElfYs4wvvWjCI2RLSauqq9+QqGisWnKrIMdJ5F2jNdbsDsSC1op5oRFMEprayuXw/UwcpYCMsBH9U3+GBINs7a0ngp5eSwwzhuCB1R553WyJ3xWvWyFW52h6cZ69yMoQl84VvgzloFs55Y6qUpjbRGtZqAznG4k6sjiyIVj1XW6sYDTR32Q5UFCFdkzIX0gZ0UmGE+AiT60jZxN1pgKiy8fVnTG5Hwdn6aEgkX33aQNkGHjeYIF2AZywxmml8yp4UulxNO9pDR3klgF+WoDUT2HTpV/NFmXE9lNtFbAGJYzUrzHEAtKGAS0plmBLgUMdJao/XyvOpdfMfAUH1SrwhlrOxLYctcBr3GlJKeZv5Nho4VXYBSAvKdac0/Fg+NSiJ9rZk7VmbsjbjHEqk3yCDN3/8eRy5+d0rmNcikWIQN6M1t3/kmDUw0D3aHzSKhtdSJTmnYMbvr7pjjZLz/NFKg9jX3gBP3aYJqqdzHQY8EQE33C5ZSo4fW1l1jyfwYEMljOS8k7CkYl+sEqppw2upqGGmLLlR/NTlthpuUoUwa8eNJDz13zATk7c28lk/VsPtFScawOTJljXXlo8tGQCICNRO4RwviYvuH3BIMxEnhxJgebh1dEQ9gKDFSPCrDMRzXB6Qrjy+1zBw4PWX2L0ikasLyaa3ZXdk3eRRqqrtfUrp9ztBLsJdDPz2vLihb2imzdxiAxMTwmj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(366004)(396003)(376002)(136003)(39860400002)(346002)(451199018)(7416002)(2906002)(6666004)(186003)(478600001)(966005)(6486002)(110136005)(54906003)(33716001)(38100700002)(86362001)(4326008)(6506007)(26005)(53546011)(316002)(8676002)(41300700001)(44832011)(5660300002)(8936002)(66556008)(9686003)(6512007)(66946007)(83380400001)(66476007)(111480200002)(17413003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BxrlD3WgX8d+Aya0Y04LioZKumlHICWAZLHGT5vU6unQAHA/8lqGls3vZWv1?=
 =?us-ascii?Q?mybTUBD2jSwbdT13eK4RiHRtN0fhoVZaynI7tcOfGJU8Occh/MU5on925Ica?=
 =?us-ascii?Q?SrZfHDNaGjI6f8XS02/P8M69Se7UsWJvrGCZeRVQo9VBjpyXhWST28K/VpiR?=
 =?us-ascii?Q?P4CZiSbo7+7nGviWDinGn8UAYRJegU5HCl3htq2tLrnL21u7CFk6EJEJmhQO?=
 =?us-ascii?Q?uBa9A0G4S5gfLPLUOYKrHJKYQhvQ4cB+softvmXmSyB7KM6+izq5LK2vc6f4?=
 =?us-ascii?Q?F4CkiyyKXMl/NGwwFNoYkmOVyyei3lr6G1HQhXn9t8pw+vAARL5uF3V374dc?=
 =?us-ascii?Q?DQA3HkQleqo61WaDN/9HH8YFagyye+7tzlm4LovNxtap0YO7m1HdkyAKuuzy?=
 =?us-ascii?Q?kpHuv40/i0I7n+oJ5wrJwv+3Hv+XoQM4iCWa80zt3uIGN8Th7SynN/cNjvON?=
 =?us-ascii?Q?vbuwY+2iwrpu8B4kd1re7gF/4qpig0daDyTXoYXQVHX+wpezjGbY2n5UgQuZ?=
 =?us-ascii?Q?yFBF1CKJqhxy+fhq7uCiHtejQjqghYuTsIJ9Y4CCZWlKM62xfU7R4EnANiMR?=
 =?us-ascii?Q?wJr+aJwqIiLV2GJhhla47xPCwag8ffMvrG4tXnPYEJBmz4MDMssf42C41XKv?=
 =?us-ascii?Q?ytMvh/OeQG9/5JvFwZPdCZJmbytk6vI0H1B8AD22wkrqLcGspSiJtMNqVuEr?=
 =?us-ascii?Q?SIraUotkaB5BFnrmMYb1FMZfrzT45oIjNVkd3Xw9mwntMz2aw2COZpyBESVd?=
 =?us-ascii?Q?Un2AFWvHf8P/+IK8QvD9TuuE51DEPLM+qbP+PRCvTuJLA2kCRqW+99lSkYje?=
 =?us-ascii?Q?xJLuG842pzCN2ySuyyMchc9py5ttwRTsgLTCd5TEW3KoSXSfRSIDvGCiG6zh?=
 =?us-ascii?Q?SSjcPn+pgF/kon7TAU0DCbes7IgBQVNSj2BIOnt93yfx6CL4DUrcZE8n3SCu?=
 =?us-ascii?Q?xyBGBrc+jmDQOpHpTfrrdN06oRX7p9q8t9Emxl0hfvJU0mXqnZYpUTvS/6lb?=
 =?us-ascii?Q?NEkcJfZylbgEt+UNmBPh6PCX54gpLcZfKEOFcMHl8gMmsmtsvmkm+TBkmgOu?=
 =?us-ascii?Q?klNEAA+6Mlm+LeKW1I06dF/89f/TBytb3iCRjXJHq/WD0Dx1UlREagTyMO7t?=
 =?us-ascii?Q?n02ULItOEP88z1Hi3b2xH+FipM9rBarjsaxxWgoC4XLi4ok8YRWQPNeeSs5c?=
 =?us-ascii?Q?UuV7Sf99S9Gmh+Mu1bFP3jUP6aWPBGG6auBIv/v02BZwgTsJKGmqN0SY8jIx?=
 =?us-ascii?Q?t04o6pMc3+he9gitXWIUfEa3ZbR3Qnhq+xdZ0lvqXhh1uDqt2WsB5myQs3ZU?=
 =?us-ascii?Q?1JLWAueXJ0qz5PvMNZdmhcKhRZNuRlvakFYKUTuF7ZD5iEunJTc2ZBEhAHNz?=
 =?us-ascii?Q?j4bEPsFXvdZ1kNl729MHHAy90ECSNaLSLXmQ/PpLzUbY4GFEy5X+q409bI8S?=
 =?us-ascii?Q?yea3+qS+Ms5n2JZJTrEqcJf/z7WICJDs0WmGL2ghVxht2lIXJIUv4u/l3exX?=
 =?us-ascii?Q?Z0LQmp2n6jaYS/L68jkpjaUHU8bfayd4Y9SpezyCcUxJU8+ekexM3xwNpvvt?=
 =?us-ascii?Q?5kat6I1B5o7N1e71l4e/02yOGInx4pkvsnl4JbyzCYULIbcsAQxfqH2sFcYo?=
 =?us-ascii?Q?TQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?R+eoIX8l95QcvRoXFxEoCJe3SpI2YetpeoVGKqdR6+z5jdSVEC4P5upC9UbS?=
 =?us-ascii?Q?mCz8KU3gl6b/NHEbIerwlJV/bw9UsG86wgEpHe0LkPrxlWuOlUybbGXFXkLn?=
 =?us-ascii?Q?OzLhKh18Lme2qyvqACRSx/JAhxEa9rHlpdUoaWnSrK9kGlf1H51/65PUp+GV?=
 =?us-ascii?Q?+3Xq7/oGS4yJ5j1Ct+b020TezO79/Yf3WhMNoMWWhutMPRUD8kLDNJJj6bw9?=
 =?us-ascii?Q?OgjVmE4/AycnOhMr+YwXjIVaZR1KCmstVwLxTMQyOHeqdxKMSv1Cs+kZGgvR?=
 =?us-ascii?Q?Dx4It8zKxjwP9c4evbaRfJvdQg4srvN6F2EaiVDpluG3Qn4K2eSyQ92MMzo2?=
 =?us-ascii?Q?mKraDzawDnhMageW9A73g1tSN7zOG+fEOiUPhKI6dXNuI7jLBbG4vekadqt9?=
 =?us-ascii?Q?ESGLsLzo/1pZZENG+fU7862ejchu4HJSV2RONDLJgxAp6ho8bofQbaouqBnN?=
 =?us-ascii?Q?xhTo6tHonfUkPCyl0uCEGmg0IK6q2jU1K0WRPzgBc/9V+ThcCfCBh7BhqowQ?=
 =?us-ascii?Q?lHIqST3d5aw4qAozh1K+rFKXMTKOWUp6GaAXJIHfiVBmqryqFpYBYvLFq73q?=
 =?us-ascii?Q?7iJ5MaYXVgWITVNVWd6ChVgav0X+IhqlNtWPOKOPFvaZxVziBy3TbL8QcWTx?=
 =?us-ascii?Q?q2LJ2DBbyCpr7X1HIwBmP1zGFALB+SFVs26N+uUdHkGVl7P/dv6eWL6nCAF6?=
 =?us-ascii?Q?33QnxpcxkyBye67Gp4A8qrnBTEaKJMVQbdnsQQkvrxQNsAyEMFeN/Z+SaI1Q?=
 =?us-ascii?Q?zyyI4a/tPP4QeEaoJWRqj827cv/DCTg6nfQuzba5Lpm8lJIiTPFbjgUowXx1?=
 =?us-ascii?Q?KK/w2oHKSmyv3z4sCa8I3C6jAzT3APTGrLzwrnJFspwUzs509M2iSSOMzcyp?=
 =?us-ascii?Q?KrM+D9XTx2Rnxfc6szt503UqUhC/yKaZyQBYSoy/z3NIGK78oeEX4yJ+OTqi?=
 =?us-ascii?Q?mt7aQJ+JVI1XSbZb/s2Wk72GTPoomRPbt//QzwHnUYqMcOi9kU8Omzn848gM?=
 =?us-ascii?Q?gB639ox1ZlqNhxXmU06Bz81+5fHMfcS35lqLZ8iAoDscLan632KrahJHIwgw?=
 =?us-ascii?Q?8N9ddAva?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1694972-0784-4609-f575-08db05680da7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 21:54:26.8780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ae1CyJ7ewlI1ricTAPJBd1DlIPKPmRNSe5mWBSvsU2VlI2kCY0bQ7/Fvy/03YfelcJLcvSOWj4ZN5MH7SXxF5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4810
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-02_14,2023-02-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302020194
X-Proofpoint-GUID: n7f8-Wi7HFBCr2Z9bF0Mz6Zwa1UpELly
X-Proofpoint-ORIG-GUID: n7f8-Wi7HFBCr2Z9bF0Mz6Zwa1UpELly
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/02/23 16:29, Anders Roxell wrote:
> On Thu, 2 Feb 2023 at 15:54, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > Hi Mike,
> >
> > On Wed, 25 Jan 2023 at 06:04, Mike Kravetz <mike.kravetz@oracle.com> wrote:
> > >
> > > On 01/05/23 15:14, Naresh Kamboju wrote:
> > > > While running selftests: memfd: run_hugetlbfs_test.sh on qemu_i386 and i386 the
> > > > following invalid opcode was noticed on stable-rc 6.1 and  6.0.
> > > >
> > > > This is always reproducible on stable-rc 6.1 and  6.0 with qemu_i386 and i386.
> > > > Build, config and test log details provided in the below links [1].
> > >
> > > Hello Naresh,
> > >
> > > I have tried to create this issue a few times without success.  Since I
> > > do not have i386 HW, I am using qemu_i386.  If I use the supplied config,
> > > my kernel does not boot.  I then try to modify config options which I
> > > think are not relevant.  By the time I get to a config that will boot, I
> > > can not recreate the issue. :(
> > >
> > > Just curious if you have any suggestions?  Or, Wondering if anyone else has
> > > suggestions on how to proceed?
> >
> > Please install tuxmake and run attached script to reproduce reported issues,
> > $ pip3 install tuxmake
> 
> oops, a typo, should be 'tuxrun' not 'tuxmake'.
> 
> https://tuxrun.org/
> 
> Cheers,
> Anders
> 
> > $ ./memfd-crash-test-qemu-i386.sh
> >
> > This script downloads kernel Image and rootfs and runs run_hugetlbfs_test.sh.
> > If you have any questions please get back to me.
> > For your reference I have attached logs.txt

Sorry, I am still a bit confused.

Was the intention to attach the script 'memfd-crash-test-qemu-i386.sh'?
The only attachment I have seen is 'logs.txt' which is the output of the run.
-- 
Mike Kravetz
