Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7490868A774
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 02:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233068AbjBDBLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 20:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbjBDBLk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 20:11:40 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85125677B4;
        Fri,  3 Feb 2023 17:11:38 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 313NOKak008412;
        Sat, 4 Feb 2023 01:11:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=yz598C2v0oU23l6VGGum3U+KIcimirGdrctB/TN9IH4=;
 b=TZdDoTwASODUdEgIRs4aYUEg+ZhB4ixaNIPZ1HzLeGCBKZCAsedJmN+eTOHD8kDXRlUD
 hSe9mlYNxR30zUWzf+zf1LfyXGfg+mRdJ6vytwBA0gfdHfoYS2M61TGLtVMKdCeKv8NK
 t0nwvtSaWeBsJ8ZsEM60e5yEc8uCUcqY8pw1uz9nRaW2eWswVrfnwX+jq396UvOIkkIo
 wh8wvf546bEPId3t94EPh2YuYwjzmSXMEpKQVlkJo/OwHU5pfVaGzr7fgG2fpJlINgEB
 Msp83BhNen5QqBEH8eIRdRk+BOg0m0bdB+DCfg9PSZqoyxo+8GH8IVvLSmODIpFustEl Cw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nfk64fd3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Feb 2023 01:11:28 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3140ea9I027946;
        Sat, 4 Feb 2023 01:11:27 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct5barrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Feb 2023 01:11:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NDxUGSVWWUrTMziiKTYIEJzPggZNAHzp3uwmcWD5/KIKQ2NCwxFKt37jSraQZgagqQEr92va6xBXDvsExqFITuFHhKxWmCr6GyxVdrE3pU0aq0JsYzS3Cp5w3gYq9TsZ222xS6u1IVYJTJRZutuO1OdoeRAt1/px3/rm4/EeFAx0Ma8i0Lcap6jG+v128vQsJp+XUITePZtZqb7lBLM+H6WeoHqXSBe2WYEjknkjTn4IWlBd2GvNEBRzVsLdnd2vjhFjiilFX7HYGvOb24DiB0atq1d9kVyj6grNpgWMfjKwBZ5LSYySVfZNGtJExX6bG4dRuUkVcpEmwnUON4q1Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yz598C2v0oU23l6VGGum3U+KIcimirGdrctB/TN9IH4=;
 b=j4Ic7KLJPReRphkkMxILqz0XaXTj18HFWbes8SrN1vcGFgn9r3M8NAEeOdI2n/pThoFHKQZDCCEjDaEVBc6apbvKzwXPLP6Klig/4IAmN5+5uUA8KgJkj8Vstg2jxKk/seTwYu9XHWtxwpbeInbnh7WN3fvYLDFqAhntXNHkrbMB6eYO8eJbMjWSWS5BR2EgRLMlcnritInBqMslvHAKhAb4livALQ0jZEacS00AceZsWEjYYa8R6bKQz0CbCblZlCcx9j1j/6TqdlHMqg/DKtTTBavb6b/xOhCZfgp4xnS/+NTMYUFBOH63V0wK4b52whBABWNndD3z43EcSmxdBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yz598C2v0oU23l6VGGum3U+KIcimirGdrctB/TN9IH4=;
 b=vOLqcxk2/JPvBvUqJFVWFf5JTxbYCeirMVMGbPr8FTrjqI7pwybKyKGwirKOeS3cZJoewkdNfcg8GASwkLwSVHX9hzgJqBADYc8B0RaFEt1GpnrXe6A79n1EuEwWvee/ZDzxHBP4++/SYj5NHfW8gqrEcsh+IOpc8/2/K1zdRFw=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SN7PR10MB6287.namprd10.prod.outlook.com (2603:10b6:806:26d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.7; Sat, 4 Feb
 2023 01:11:25 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3a1:b634:7903:9d14%8]) with mapi id 15.20.6086.007; Sat, 4 Feb 2023
 01:11:25 +0000
Date:   Fri, 3 Feb 2023 17:11:22 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
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
Message-ID: <Y92wupl9Bw+PO2/Z@monkey>
References: <CA+G9fYuei_Tr-vN9GS7SfFyU1y9hNysnf=PB7kT0=yv4MiPgVg@mail.gmail.com>
 <Y9B4/pR5t2o51coY@monkey>
 <CA+G9fYtt_FR54zwStiTguiyS0QDHe-x5+2Py9_hvxKAbYHM_fg@mail.gmail.com>
 <CADYN=9+=p0cYu63feXfZVXZTGruJP_i5dA3AuP0G6Fh_rfQO0g@mail.gmail.com>
 <Y9wxD0ngdo832Az5@monkey>
 <CA+G9fYs92bgdfYGj7uudnnnUA7hm82sggpWmSjwdKA9qjZvW7A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYs92bgdfYGj7uudnnnUA7hm82sggpWmSjwdKA9qjZvW7A@mail.gmail.com>
X-ClientProxiedBy: MW4PR04CA0132.namprd04.prod.outlook.com
 (2603:10b6:303:84::17) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|SN7PR10MB6287:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a26d7f5-80bd-4632-8384-08db064cbc45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yRjH9cPsf6h8RtGi6cYdzrXVZXjc+kL0qrYtzzwHtg5XBDhUkxF4TlR7P19U5cJTqoac1DjxoARy9SFp/YK6tqzZbkYXGDRwM03j5Qw6Ff6Me9aHOkTeQj1BbaLBp30Yj+dnTPHKT78GMOv2XyNjW7HAV3F94hedbotQvIgcKw799NBT83ygUfAxOZ58FIpg4LbjB0CtK5kTtepmjU1NNoI0XL2W1YjGg1q+lf9GzFDH3jS3C/cw7c2j2wrB6q5Jv9BMwbTui9hoFPuTk5sxXP0Y2CIdoVMeUdFOL5Fzx7rSZKJP7vlTLXyfIWz/tX0xdlkFvYCIqyl4/mYdyskRQirCUzcF7hBairh6aQjgUoV9zPxxUCyJ+hLLwyDjVNn0Q13pfTGVy56YxNmGExTJkNc8F80zUBGQyv0NqOw1XewtxcmGR2Cxag+/GjNCOY5CQqGdBEHq6mKxqaKjY0+4tgqE0M2vYmhGm2a7GFtGk93z9x1SSdbjkifaYvDgbvB4+8P/IEzJ28OupxhE81aPXEG8VXsq4QR2vVXC7Ak25CZzqq92aKh8Q5iB3D9rvPcMJ0bJOhLchs3CYEXGq6apcFbi/9GC6g7EwrWqDrybDZ9xhckjbbb+r3TQuiIyAGywfi0gMBCrVtg1a9nr1ORdTvijZcZP8P6BEMrbi3+2RNsa6wKW2PN58QkrVLHpZh24
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(39860400002)(136003)(376002)(396003)(366004)(346002)(451199018)(6506007)(8936002)(316002)(44832011)(53546011)(86362001)(6666004)(6486002)(38100700002)(26005)(4744005)(7416002)(5660300002)(186003)(9686003)(33716001)(6512007)(478600001)(54906003)(2906002)(6916009)(4326008)(8676002)(41300700001)(66476007)(66556008)(66946007)(17413003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CMO8W0DC2LkPIbHmI4xl1WBJecX1XUc5Q0+8PDBtxNZ1CE9me4EyGMl5h4VI?=
 =?us-ascii?Q?JntEF0aTz0OW5KehK0+77S1djWZx+BFUPFSTvqh/+ZAg8id97d7Sz+WUCX8w?=
 =?us-ascii?Q?rfi/L3gDtP5ysc9Q+E2JNbkPRCd3gJBS2PhlAkpA0aAXYPCLIkTBHCgyvJMo?=
 =?us-ascii?Q?psDVcINsjqLmhrTLy/QgDXz8mV5nuqz8wkbUxKe/I8kDqajJ3EyvfwQyvYLO?=
 =?us-ascii?Q?2znYGMrnV1TMBRzP6cxoLzBp08NM2l4XzBmGqCJj6EnIvYJgbHZivWX+bdYo?=
 =?us-ascii?Q?+yFKKuSWD6EQO835B+q30eP11gTq8ULpuD1bReo8s6uae+fAyAjzHKJT8dKD?=
 =?us-ascii?Q?UzcF/qOVVteL0mVC9lm+LADMBKw1XiVDo+jIFHx8OsTMHFiYSBS3qbif29ml?=
 =?us-ascii?Q?31NWPOgDIyMSZJKgQ2pvyFgUx2eW7meKDFwU7zc8lLyto5P0WtRpK8ap4xGC?=
 =?us-ascii?Q?v+hv6FmKwzLGOffb841BDVusSTg89x1eNy2CXNQM2YT0pcYOLiuNjSobpvfD?=
 =?us-ascii?Q?2yK+CtIK/th5TGlke3qnH3GoVMmhkfg89XAi5EAvZd+NXYh5SEr4SEQEAcqa?=
 =?us-ascii?Q?3JjvrVBhOUOXniCsiilF9EKKPNZCS6okDCVRsYNRH0zyO5uyaOweQRCzPeRY?=
 =?us-ascii?Q?nF5GYwLXekUWH9n5h7DVrc6IwcxMBf6FWI7up2dEotiMpi2Xc57vTpyhrxhW?=
 =?us-ascii?Q?LtL1AvDMRoCisiC+WBDxJ2V7uCzvvqrmIcJwlkG0GyQkqLM1dASUOhxSguyL?=
 =?us-ascii?Q?rkaVkDS6zhFw6iz/7lDKfvU8T5J87AA8Dr4enrzySfKqU8CNMVMoM+2U+dsa?=
 =?us-ascii?Q?/9b9+40nVnE0uv6LFQQWRi4X2P4iMI5LFihlrOEo1LwasPjLmKUqdncHxjll?=
 =?us-ascii?Q?VRjnN6zufWoVmIUEmwghYsUsdZ8M73SfnCJb9XLRSHTw/929aVU/XEouMrQu?=
 =?us-ascii?Q?3ToM7TMt9uIa6+cqwBkSWSq0S9o4vZ+GVMPcshRlAA6zeYpdcVpUcJ1HjAQs?=
 =?us-ascii?Q?YeM6yUUOGfv4ECHRhC8gsTPz8zNursosqJntLlx3waWtKRSJPOzBKKCIR3EO?=
 =?us-ascii?Q?cOlQLwlWDzxlWS3oo5rh3FRJT2nZQuHcbGhBxOC5Zgmvj/Kw5NdoMaOW5Llz?=
 =?us-ascii?Q?V3VBxJli1udkVFs9eBQzxzN+bvvNhEk6e3XfMkcmcsnlwiFBE2fKZCXAtX7G?=
 =?us-ascii?Q?22ZLjOZehvY8BqCURFrEKc9j71gVwrOP9gIf3l8/0Kaj5voI0bnIObNpUWBe?=
 =?us-ascii?Q?XMz4L/h5ZWk8GrhGxvPEspW6Jho9Fgb3p6fL+3HY2skZc22YB8CGf3rNxla6?=
 =?us-ascii?Q?AkMx1bAPrgGoVM0DCfJjpVL47uYuSqxw+s1FFyyEpizMOxc6G6AahjcWnAI4?=
 =?us-ascii?Q?bnwgTfzt34L8Chgq1FEdPvu9Yrhla6BO2rOSNE40xVGqgxFanA8ypoCbvMmC?=
 =?us-ascii?Q?DhLRZLc7NqIG1FsBvyPYZRIzHawIeawOrTBkUlJbHjDhhKTQjx7m9Dxo5zxP?=
 =?us-ascii?Q?IUQKvhk2BlfHVii3t6ylH2IwQZNi/p0kdjjF9samUXgB4SGDfZKbVKwJG4LF?=
 =?us-ascii?Q?Tk/fgl6olnXdzbB8Qhjbv1+e516SJFlRCFWlYsj5ZlJ1VOlnZ5mq26kZ8ep/?=
 =?us-ascii?Q?yQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?OXXOztFbdXvplfWWqSmqcnKR8LBA6PYUQCaVjD8pJLw0dINlSKlvJ4uDwgIt?=
 =?us-ascii?Q?a0m8r6XNWnVTHBRIee2kon2KY8QxIgK7zbJg5tRBNHmYkcY0WKGqDHPWyJ+X?=
 =?us-ascii?Q?IIzftr33Zx8/q+qdr220BmUL2q7PITgSc+Ihd1h/ROQT8gW+lzX7mGXJBqaY?=
 =?us-ascii?Q?U0B6R73XgDsIDUE3V/ekA6v/L5O8jNh0kd4ffZHmDRe/r/e6w9yM6YY4+eb7?=
 =?us-ascii?Q?dsKk/V2IyZlbh5GPYoZkJ0ReiaLH1sGjV2irUvg5NWengP2WHWPOkqQwdnV4?=
 =?us-ascii?Q?k/JuCjnNn2dj2zyVXN+5GYWAmDm9JqeW0NIJKx7D8TJa517syyG7R4vQaCQ8?=
 =?us-ascii?Q?uG3ra1JvkSqx6IBYmzkguVX13O4A+RiqNarFn8CNngFlbUewbhPzSuunNZyg?=
 =?us-ascii?Q?160FzwpfTnOygvrYbG0EhsNDcG7YGfp8vgm1DyaxIlQTYFEb9QV9FC/TBXb6?=
 =?us-ascii?Q?l8pKEs0tvIGNeS4p8EuMlqzhQQdw3XR4GJv5BrHNZLfV7Zqe366JKsLJKXVf?=
 =?us-ascii?Q?mUqWDSnqxSXCbiUIruK+Uu2TYEQCpg5p/5TrPqCA/J3kFufoJikAP+ti6n5H?=
 =?us-ascii?Q?5G1dfjTdKbUaDXQR9CQomYrPZOkwOkzLxkDS3/B7IeGD7Od6+fwHct8rdzqE?=
 =?us-ascii?Q?tMxTeo70IDYPQyEbGsOVvqA4KKupU2q1Mgh8sMa9hAHbIS30ytm/WZPknNda?=
 =?us-ascii?Q?anMMdaCWQjsH2y8EneR9DauEwHJnbFh+6nX6Xe9DCIjU04VtbopMvBs9rW/y?=
 =?us-ascii?Q?hs0NpYrY29u6il2HoqyHfSUAJRrW0f90+psEFEE6s/XBWKEoaTZNb3R7Luzz?=
 =?us-ascii?Q?EIuBJaxAc3S+N5vEowCqmcg+RLCox6r2P5qwnGKMHXrq7VwMNmBMwK1zEIHc?=
 =?us-ascii?Q?HIx0NSOz5hPFDh3peRRkaEsY4mBKU4c/iP8H36gfXbsOPOPqoScRnsONmQzC?=
 =?us-ascii?Q?PsqDeW1vjGcmJ7/cKmgrN7DfPlMzURGftWX5upTA9wjry1a7+MXpTKYXtxPg?=
 =?us-ascii?Q?y3gNCP/U5VTHZiwYIoc2SDHmhQnD6e0ixdZlca1W/WY3SOrPn0tzjm5iZnT8?=
 =?us-ascii?Q?p+AFlURi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a26d7f5-80bd-4632-8384-08db064cbc45
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2023 01:11:25.1041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iLK1jI7MDl/4DB5VzyhYJOD25E/Bg4nM8UrN1YDv171HXZ9bb+GRi6wmwn4PvXHozxTn+wVCRDDUO3SLSFuMqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6287
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-03_21,2023-02-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=902 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302040009
X-Proofpoint-ORIG-GUID: UL213Dfeu9QJrqf7w5W24hGo3py_aDw-
X-Proofpoint-GUID: UL213Dfeu9QJrqf7w5W24hGo3py_aDw-
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/03/23 12:30, Naresh Kamboju wrote:
> On Fri, 3 Feb 2023 at 03:24, Mike Kravetz <mike.kravetz@oracle.com> wrote:
> > On 02/02/23 16:29, Anders Roxell wrote:
> > > On Thu, 2 Feb 2023 at 15:54, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> 
> I have sent you a private email with a reproducer script.
> 

Thanks!  I can reproduce with the script.

Not as good as being able to build (and modify) my own kernel, but it
may provide more clues.
-- 
Mike Kravetz
