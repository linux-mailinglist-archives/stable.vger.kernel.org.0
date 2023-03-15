Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC4C6BB60D
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 15:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbjCOObJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 10:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233171AbjCOObG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 10:31:06 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56A221288
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 07:30:41 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FDjYbH011436;
        Wed, 15 Mar 2023 14:30:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=Xt3xzRpmH4lR6xZ9Ng/gvVlOtbzP+8CC/xYBVWjxebA=;
 b=lt0mdNBTbEDv+gbelbRs28HtiCiITooXh06/w8rraZ/ggSqUKPSQhzV/77au8GAyBk+m
 gK0RdFqaK3ezakmiEen+eeiQg0Afn07kDaRYvnPDHEGycNp4N6H020x+LdXeUJ0lMZw1
 kx8CM1MXzOVtj/M389tqQWL7km9/DB4M63mduGfUYGV+nNuqZofw1PfYErXDuGzJCJUm
 7u3tUvu3xX7/GD3evps8GQR4yxFNXQy7t9g0K1G8zLePivHVbYj021lPGV8bCvnZuQ8v
 o+ey7rDyiQrzO+QQ0TP3a2Cxrp4FKUU0pGVMH/x2zGw/2UTpvIsZwcduwkkKdf9TzZHv jw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pb2c1sj8v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 14:30:34 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32FDRcue001387;
        Wed, 15 Mar 2023 14:30:34 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pb2m3e08w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 14:30:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XX1UCQrnr8YC8kHMR4sGXAUeBheB0g/8OojO9qABCaPBkOXME/T32ENxAbTkt+cWlCAQjcVvNCg/mlQZ/B7bdzyHAXmY3wxMxFVmTsI7M7c+Yw9RwsqjZhXC9GA7b01VOzRl25rn0ghk2+PUc5FSubg274E/BLCKFMBlXujH2QNvuG96m8id84t4oGRL9WUsi80jtTEi275+e3vYq4pX/JmYPGS3JC26FrhFbZui6sHtzxJug5uEAWEVKQGS9y3gixLc6ijEALunyQ48R7/9b+G6FdgwdVh3P1yQ6c7krbCCblxdgve0/bxNcOx01WZ2kwZV2jIicFrGD43JYzUr2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xt3xzRpmH4lR6xZ9Ng/gvVlOtbzP+8CC/xYBVWjxebA=;
 b=EaOt3UFsQUt/4Jc2mkBKnqmkR7QbDXMcI4rtPvjKjlDJEeiM4JIrbPfJ/OQm0oHWB6kwlA5NR9vL6qpQ+tE1pOh2W6EjKamfOtu1zgV8kODQxhbEw/yqVcCrhBmVODCZn58Cm8zXF9Oi7E2iQ1Ow+ePZ9a+SyEq3c3siQQN7Zgtit+H92eBFu0KB//P/1pZYTlv4NPptDW9pMbxdKzgM69vvykTY0ZgUsMjbxITjVoGOkwgiPhLuHWlRlRet2Vhi4656nWVDjkJjsFsk0aD2dQ8cR4enT3MRwgiO9JoGtbsleg25vi8GBEsKnfjoZHd5y/PfYv6ZqOFKI2ODhZ96QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xt3xzRpmH4lR6xZ9Ng/gvVlOtbzP+8CC/xYBVWjxebA=;
 b=FHupnv5QmKSaACQ2jPrtnOxOQOT5EOKNT1nQQxvCESPxPdZg7a5i8PMeXuMBrD3n/bcZPP+lhcm3FBYc7HgRdsMsYoBIWikxkjF9sXmuyIObLvfHkMrhDV3Fl7LhUf2z5YVhQ2D9BkD0Vu0RPeSS1CILZ2tf1tcMDv9S68XvGOc=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by IA0PR10MB7667.namprd10.prod.outlook.com (2603:10b6:208:48a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 14:30:31 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 14:30:31 +0000
Date:   Wed, 15 Mar 2023 09:30:18 -0500
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        "H.J. Lu" <hjl.tools@gmail.com>, Kees Cook <keescook@chromium.org>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        konstantin@linuxfoundation.org, robh@kernel.org
Subject: Re: [PATCH 5.4 v3 1/6] x86, vmlinux.lds: Add RUNTIME_DISCARD_EXIT to
 generic DISCARDS
Message-ID: <20230315143018.fnhhvhm3gvyfozcg@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-4-v3-0-122fc5440d4c@oracle.com>
 <20230210-tsaeger-upstream-linux-stable-5-4-v3-1-122fc5440d4c@oracle.com>
 <ZBGER4HqDnvotSNg@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBGER4HqDnvotSNg@kroah.com>
X-ClientProxiedBy: LO4P123CA0362.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::7) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|IA0PR10MB7667:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c1d31af-2a67-41ca-e60d-08db2561d43c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sU8L2HQOzbHSRoyO2egyysNVTUWWwtgsPpFWL8pijh/x4xCxfVK+PsBpZYlj9Jk/+N0wSOxpGgfHT7cXrL5vqjk5KPJwb7AgCm1Rllq87MkIh1x/pu6J5mRNzBndp5a+FlMjjwBSIz+Am4Wcll9OSN9JNWfVrK3EZ8oRYCseHGXZegX7EQeeNAwc0Hw4wuvbIifFgw4WMcOoD6buTU8UI8d+zwKPust2jh9J+tFO378MBtdO0XTUKz0ig8fyo8Q3c2xfRGdVxL20Ib0Hoh4+l3sm52GPf/cQ5XGV4Rpj/2UrRsrLF0ZFUI08bmktRMvTeQ2ZSElj5YLDNP2mlAnVSpEipbdyDs1IfNamGnXWLA8QaE+nX4G3+0WY2fl0Dq9gybd0NlJkfBLeBfE5sTMgPwTGZtn4Xh7W1zsDoW0LGESJH3/AJj9uZZCXi8ejl/GZekwra1PnqUSBfDzV87F/MFwzhRO0byfWax1DRw8C0IcmUk3hOuSCOteDtKK2G105oxwQxl5SPxm67G1pHDVGUQ2zbqXV14A+8zv0yPZ5Ot2+je8lVKeRgXsSTSj7duAHH9FXxmKH+vWKrjhx2nfy4FWJ9ZfK3Ayu3I0DoAjggn5OwQLEeMimFN52W5aGguZ9ExKGGzfaJrlKqOOlSeXGsFOC3LzrmUw4cLiPsTd3+i7DVnq6HPMArFrynTHSlBbBrEn4HuljMZ+uD7Dxpz2mmESzjUOdsPiM9sn/7dFdA3Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199018)(44832011)(36756003)(5660300002)(66556008)(83380400001)(6666004)(186003)(478600001)(6486002)(26005)(1076003)(6512007)(6506007)(2616005)(966005)(4326008)(316002)(41300700001)(8676002)(66946007)(8936002)(6916009)(54906003)(86362001)(66476007)(38100700002)(2906002)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVZ4SEdYRm1SNmkzK3dPL2JWY1hlSjN3TkVWYnRuQlFZendvQWFqUGd5WUM0?=
 =?utf-8?B?b0lhYjZySkJ4RzFKcTNieHRhMWRia2JYaTRlYmpSN3NBYW5MUEp4Vkg1dzd0?=
 =?utf-8?B?LzZlaXo4QlY2Rk1KbkpySWF0RlJ2anRDVk5tNjA1TU9XZWluYVcvM1huSU5N?=
 =?utf-8?B?c3hlTnYwTlRaRVJsZHpLMENLSERwYXBGYjhBMTRSU3RBU2M1RW50a3hCa1F6?=
 =?utf-8?B?OVRZUG0vMi83aGh6WllhMTZIS0NYdjg4UXkxelNKT0Q1YVdqbnpPZS9oTi9v?=
 =?utf-8?B?Mk1OcThLR1pCdzNYVVpxZ09iN1ZCTTdsOFdWbWhkWWgva0pIQ3JmQloxMlBF?=
 =?utf-8?B?WXRHQThvSmlhS2kya0Fxb2VmbFJwUmVSRTlGaGJSR1dRWUk5cmpPc1hLcHBu?=
 =?utf-8?B?ZHowZ2QzdWZiWThaZTg1V1V1cnRQaWJZVVU3dGJVY0pTdytpb1Ayb0NFbjhq?=
 =?utf-8?B?TVVJb1FuZDJTR0JGc3R3bjZtMHh5NmJuTXVaaGh2M1V6cFNsdGVqak1WRUta?=
 =?utf-8?B?WU9YQ1BPTnZDZEtOVUt1am9ISnhMQnNVWEd3cys3R3F2YlNIZFE1SnhrTWtF?=
 =?utf-8?B?cjRBUFlyNmZPUEZvY0ZpbEwwNUZFenZVVWUwRXlDd2Frd3dlVXNOVVgwakRG?=
 =?utf-8?B?aC9XMFQvemJoY2kvRFhUSnU2T2x5aWIrYnF1RHFKZTR5N3JtN1FIZU1RVkFE?=
 =?utf-8?B?RmJJUGRSekliVHZFb2tBSFhLOFhPQlA3cFVFL3UwZnFsd2dzbUplVjB2Qkll?=
 =?utf-8?B?SmF4V0ZTYURyZ1VrUDdrWXppTXM4M1dVWTliY3Bud1AweEtBdkRlT0dvZjU1?=
 =?utf-8?B?bnVNcGFDNzlFVDhuSllkc2lMREZVRVFURG1xWTdyTXcxZmVoSXZJNkEyQUl4?=
 =?utf-8?B?NE5HQkJOblV0Q1RqMlluZFBxR0NHNWFhdzhaaXlUMDBReUxsRWpuTDVjMXZW?=
 =?utf-8?B?eXhpc1JJSCt2eXY5L0tCYlU0Z2ljOGJ2b3F2ejN5N1gxRURLWm1mNk05YUtI?=
 =?utf-8?B?S2tRSWQ3cFE4Q0hLcVBNNHR0SmVyUTBUbW5HSWdBK0dJTjNmSEZ0V0lEMXFO?=
 =?utf-8?B?Z25RWE9LSG1BMlg0S1VHZU1iQk51QkcvTkd3K1NnNWpPL0swY2ZCRFNra1ZE?=
 =?utf-8?B?bWRtVkZHRk5MdG9IZHEzYXlZbGlVRFFQVXUwNmNPOTdCTnp3cnlIRUp2UzVG?=
 =?utf-8?B?NSt5V0dBcjJYb2YzbFczalFTdlp1aHNlNmNSRUcrWWVzODNZSTYydGVRR3Fy?=
 =?utf-8?B?MzBEMlh4VDdOZmNuZm1nTXpmRlZhMkdIS3RGMzdzV1JGMGhrOEtVWE1qcHNV?=
 =?utf-8?B?SnA3Z1VuN3gyQ3BZNFhKa1pkVGpFQUE5R2FFclF4dVdHaUZwbVA2WkZITEpO?=
 =?utf-8?B?ek9aUEhMcVBlRjg5MS9MUko4T2RES0RYNE5NNlQ3OUswblg0UWxuZ1pKdEJ3?=
 =?utf-8?B?MkNkeGxidXpUVU8yZnArbkxDeXlMaUNFbG13cktvbFh2ZFpxZmJwQmFXVmIz?=
 =?utf-8?B?d01oaXpJTlMzcUloT1JNTzdMYlNLbzV5OXZGSm03OHo5UVdiMVdRUmllRGdS?=
 =?utf-8?B?QmNURjV0WCtoaWlDUnlQV3U0R3FQYkJPQzU3WExQZ3cyc1R6cmZUVHBsTnlT?=
 =?utf-8?B?S1FyME1EV0h2V2o1aGRKZXl6NGIyb1ZVVmI1WG5uWEI4RS9MUGQ5SGxiQXlS?=
 =?utf-8?B?TytqS3ArNm90SVdqYnNHMTZ3Q1ZUUWJNVEVzN3pzYTdEZ0c1NllqQ0RCQ2hO?=
 =?utf-8?B?L0FqTm1QUXhOWlZaT0wwUVhzUVR3b3ZXYnZETCtSTFJrVjc0YnUyUnZzbzFk?=
 =?utf-8?B?OHhqVEE3OUNseThXeUxiMVNVSjZsTVFvaFYwV0tCek10eXNyVnJxUnEwS09t?=
 =?utf-8?B?SkZVR2t6Y29GUHh0cGhXQTU4dVo0N2kvRHpSd1ZkRE9rS2N3cTl6dFlROFli?=
 =?utf-8?B?RU84UjlSdDY1dUp4M01maHpLamkwd2o5VmNwczRuZXlaK0RoT09MNktOWko0?=
 =?utf-8?B?OFd4VmJxenBIdFRBOWVJdDZzUWFtbTV0WHoxSEpUVFRBTHRDeHlIQkFobFh4?=
 =?utf-8?B?TzRtb0hPaSt0Z2xreXBlWGxwS2RoUlhQdlhTL203ZFNoN2l5aHd4TmZUMjJu?=
 =?utf-8?Q?NQbcULRnJTKlgyUjDB7MWrER9?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: czZGOZJTwPIoIjfxnI2bb0IMAynXGpKyySJ3sX+QuOWgbUfhfthPr/djR+4KXfIwD/H1ZJzbCxHtepRHpXzUJM2MY+T29FSer7pciDZEUdwEWT36KFLptz0QL6NJ9zBAHEIpnlQe902Ee+mqycj0Lax0F+WAt/3G+U4nPbBSGKDjF/3tKOg2FIkJ2i1BRhdKggeyrHXTFHDZJGBGI9dg3lz1SOGRESWQJ1O0J5jTVSj3li+7wAVmcL8jsN+5rsWppnUnkWcghsi67Aql8TiBu6fzUxZ4HAoUSyVVCCYfMWh8aJYEQs8bw20ZUocKdE51SYIOgL/lbisZh3Z1BctXvVOoPszfZiwYz3MLwyyN52rVND7gIU2wmpjgyJYVZUCNbOmujiUfVT2zDQifrTkGTOeubJV+pcsYqWA7vMoPBPDjK3cpdw2gyZ0Kn83kxzzEMjDct0BIUipLbGUu4SC4sSVRItdykE+wUru94aXtYe3lfjN2RVAlrhvc+VavU5aq/soJwuWF2RLjErLKu52ES7Alex9QWutPpcBRT1ayFhAaBHyD+3linm/KB5yRdZWvMStcNGLx5daMsFuQbgh+aH7CgOlH2F3xaLrvZelRc6n4H5ashLiX4Ylg0STnFZSssN5cj4hc3OOQkoDebcPEeI7+IKDz+izegaMssvxBVnNEHtTJVTcoZuR81eSGUYM5nyB6rnxcNs5XJ7t8LhqQpXRvltH6iQ8Z8gZXG54kHWpIXPEGOAoKwdSQZogkrvLcqRtiZD89CKUbU9hxX8XStNDOHJhCpvducIGuoRHXeynYJQ4hYkrD+2u4FBMVX+45PaNKIMqFVWwz1VLAZZj/7SRpTdPliAs9su1lyrx3HJgKB2e2uYhg9hj5UY0ihvCgC++h1rpPQmsBql/zO7Z+2w==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c1d31af-2a67-41ca-e60d-08db2561d43c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 14:30:31.1810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KXqyFtkyqLaiGTNmxvSC6erQTzw61As4C8b8jJ7YadzzevBUpvMJ5Kf0lv/Skct08cYPn5FqUi4LneaO/ZqMig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7667
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_08,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2302240000
 definitions=main-2303150121
X-Proofpoint-GUID: YY8ppLOUVS1iavSdFqX1UpVfUHZCTo80
X-Proofpoint-ORIG-GUID: YY8ppLOUVS1iavSdFqX1UpVfUHZCTo80
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 09:39:35AM +0100, Greg Kroah-Hartman wrote:
> On Wed, Mar 01, 2023 at 07:06:59PM -0700, Tom Saeger wrote:
> > From: "H.J. Lu" <hjl.tools@gmail.com>
> > 
> > commit 84d5f77fc2ee4e010c2c037750e32f06e55224b0 upstream.
> > 
> > In the x86 kernel, .exit.text and .exit.data sections are discarded at
> > runtime, not by the linker. Add RUNTIME_DISCARD_EXIT to generic DISCARDS
> > and define it in the x86 kernel linker script to keep them.
> > 
> > The sections are added before the DISCARD directive so document here
> > only the situation explicitly as this change doesn't have any effect on
> > the generated kernel. Also, other architectures like ARM64 will use it
> > too so generalize the approach with the RUNTIME_DISCARD_EXIT define.
> > 
> >  [ bp: Massage and extend commit message. ]
> > 
> > Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
> > Signed-off-by: Borislav Petkov <bp@suse.de>
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > Link: https://lkml.kernel.org/r/20200326193021.255002-1-hjl.tools@gmail.com
> > Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
> 
> The encoding of this email was very odd, with dos line-ends?  Something
> was odd on your side, all the others were fine.  I've fixed it up...
> 
> strange,
> 
> greg k-h

Thanks for pointing this out, and for fixing-up patch.

My first thought was to blame `b4 prep`.

Vegard helped me track this down:

Rob already reported here: https://lore.kernel.org/all/CAL_JsqJHGUMsLUpH=s8Xa46NU9dbBuvPMCPJyRwQdvFr3WK9tw@mail.gmail.com/
Konstantin already fixed: https://git.kernel.org/pub/scm/utils/b4/b4.git/commit/?id=ebd05d6210e3421af2918dc178985789cc5fc390

Verified this locally.

# b4 version == 0.12.0
❯ file tmp-20230301_1858/*
tmp-20230301_1858/0000-fix-build-id-on-arm64-if-config_modversions-y.eml:                       news or mail, ASCII text, with CRLF line terminators
tmp-20230301_1858/0001-x86-vmlinux-lds-add-runtime_discard_exit-to-generic-discards.eml:        unified diff output, ASCII text, with CRLF line terminators
tmp-20230301_1858/0002-arch-fix-broken-buildid-for-arm64-and-riscv.eml:                         unified diff output, ASCII text
tmp-20230301_1858/0003-powerpc-vmlinux-lds-define-runtime_discard_exit.eml:                     unified diff output, ASCII text
tmp-20230301_1858/0004-powerpc-vmlinux-lds-don-t-discard-rela-for-relocatable-builds.eml:       unified diff output, ASCII text
tmp-20230301_1858/0005-s390-define-runtime_discard_exit-to-fix-link-error-with-gnu-ld-2-36.eml: unified diff output, ASCII text
tmp-20230301_1858/0006-sh-define-runtime_discard_exit.eml:                                      unified diff output, ASCII text

# b4 version >= 0.12.2
❯ file tmp-20230315_0806/*
tmp-20230315_0806/0000-fix-build-id-on-arm64-if-config_modversions-y.eml:                       news or mail, ASCII text
tmp-20230315_0806/0001-x86-vmlinux-lds-add-runtime_discard_exit-to-generic-discards.eml:        unified diff output, ASCII text
tmp-20230315_0806/0002-arch-fix-broken-buildid-for-arm64-and-riscv.eml:                         unified diff output, ASCII text
tmp-20230315_0806/0003-powerpc-vmlinux-lds-define-runtime_discard_exit.eml:                     unified diff output, ASCII text
tmp-20230315_0806/0004-powerpc-vmlinux-lds-don-t-discard-rela-for-relocatable-builds.eml:       unified diff output, ASCII text
tmp-20230315_0806/0005-s390-define-runtime_discard_exit-to-fix-link-error-with-gnu-ld-2-36.eml: unified diff output, ASCII text
tmp-20230315_0806/0006-sh-define-runtime_discard_exit.eml:                                      unified diff output, ASCII text

Regards,

--Tom
