Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883376A7948
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjCBCFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:05:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjCBCFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:05:32 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93D448E33
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:05:31 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321NJkUY012653;
        Thu, 2 Mar 2023 02:05:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=0g2R/9nNFR+Ah5yarbqxRrWQ3g+e+05gj2j7RKJB3nY=;
 b=mwtJwSSVpaOE5gc1dpGRn5wwMpha+/Y7RaFKuYYuP/L3eMnvFebvf74zbRJu04atsJsr
 IXqnUnpAOIE44DOgdxetQDhWgQkRhpnjf/xsyIjNpvDvNRuDsOjrnNYtQQzQfBGxddS1
 aWohPZ9rOLSEQiaKExZIdqhdMGYBF/FcyKsvZr9NgXMZRTiWIu/bNGNeB//e2QPOdYBI
 yTp776dW5uZLAM6vu1jfEKtsYN+lCHnf76VYIpQsAW1NRCkGnkazEBTNbW6BlpqBBns/
 kEpbqaqz+mzQyjCOwPjvdUK8KXK79dpbm8cJaJ+32SUwPQcPKEiNBrfS210ojWjxtOAm mw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyba7jd9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:05:26 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 321NeEoY032919;
        Thu, 2 Mar 2023 02:05:25 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8s9c802-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:05:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJyeNCRBdJXcMIOMUTmMrX7y5ClkvgM+FNTnjZoclr8zxfSj+YUaRc1Tiqpe5hQrqyY05KKiAvfgSKvM4gmM1CBILPDR7PxlKwhXyHGNdAgfTR7Eh9EPhildzXpbgM9n1UxGcchWnwTi9lWBhYXFHYbqIPwIMs+Vyt84hwdd5ISaCVkj2SY/2CZE1Zrp9ApBuG7NIstuarUT1XKOQR1dG/YB/jRQeW+ffC+2WjDQ9XhJP7IJbuykuG1uKjW5fBnq23C5/T0o3CITnZb8mV9XmbvPQDj+dYZLDKblPWPmk77gTCqowmX7LR+KsbXjrFCBxwTFT/vIXOOajdsevFW5/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0g2R/9nNFR+Ah5yarbqxRrWQ3g+e+05gj2j7RKJB3nY=;
 b=hv7xqFx9alBhB00jX2ShvSVD39vS+h0768X9OogUWdH9xewe6tH7pVS/hpm2sGYMpZzhQGIULzVx3eMSe9VaiI2jcD1sxmM1Hf9nM37MvpJTBN5YqMB4+r7O4np82bYgkIQo8Te+LT9TV3neHu1ylJLB9phfCzWdBaJWOEAAtte/Tk0KFjGNkSgHZ6+dsbrZFNqNSpPifbu64PrmHuLle1d7RCEw+2SRN4wKIzFrNno51CDttB0IFxkTJUQ5ZOQKz/jSXThSGBRWATLhxXAV/AzmAMh28cEoib3cCzixKV1QVm4rMs+Aph+9CIxcuaBfwzwUER8N26ULzZydBLqblg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0g2R/9nNFR+Ah5yarbqxRrWQ3g+e+05gj2j7RKJB3nY=;
 b=biumIjENgh3j0wx+5lCMigq1S8upbPabA6hqxO+b45DBeu4dgw5j4n/TgzB0qEtU/71uuyTbww5X61LQxDOdKTj79oPA1v849f+4gnMZjV/lMA2sGsZa6NcczuU/3lVj+F426cl8ZSRwY3QsfZ2Hhka7VoyLoYDznakUOueUooQ=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DS0PR10MB6872.namprd10.prod.outlook.com (2603:10b6:8:131::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Thu, 2 Mar
 2023 02:05:23 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 02:05:23 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Ard Biesheuvel <ardb@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.10 v3 1/5] arch: fix broken BuildID for arm64 and riscv
Date:   Wed,  1 Mar 2023 19:04:52 -0700
Message-Id: <20230210-tsaeger-upstream-linux-5-10-y-v3-1-f7f1b9e2196c@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230210-tsaeger-upstream-linux-5-10-y-v3-0-f7f1b9e2196c@oracle.com>
References: <20230210-tsaeger-upstream-linux-5-10-y-v3-0-f7f1b9e2196c@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0153.namprd03.prod.outlook.com
 (2603:10b6:a03:338::8) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DS0PR10MB6872:EE_
X-MS-Office365-Filtering-Correlation-Id: ee52be01-7a99-4b47-caf6-08db1ac2954d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KPue2Yq/PiDXEYtUFOSMOEFqN8DDiIbblOUJ9TyiMrJHYp20dQQqYC7QvvkeYRfOD8EVbSKGMSBBLjagEDflgIAHZaOkCkQABwLTaYS/V6FBMWs+8jsMs0b11WnyksgIsDcdO8aeHw//9ujXEYlD/di0AildEPMHRQyzRSThlSXhIDDYrvAMXR8Kbp7IXHv+2wiP5hVVyzRROrolcnIxwIk6fCyW2AYoPIYnV9mgNKDH96NDgKmVX1TdGSl7SSYEjkZaCi+5i+XIuSC1YBKVtx4Y5U88/XerBWZ4UqPqHFQT7qf2s0wS/t+JISwVKqNhhu83D68N3BE/BH9hGZg2y19dPL1nJgvbdR1b1Z/HoLElwUOag6XpLDFrSz+L7zOpZaz5YdcrqkgSQCs+LEC781FHGmcLyBr86rA44kQ5Ddv7Vx2yKr9o9sQLKZZfIU8poGiyjIjleicpWoUHQSmlbfPfdkikp2iA9mDJhKKDXexS4t6wlypVHS97lbeRE3x5BG+H0Bh8MtSVuvOaibD4ViUzl7THq+GoSQrr8OX/1Xw5MIXF1ghpO45/9oHcG02lWSHs01HFAp030XAU8tW76I+gkg6EwHe+/mRC0arFe4U67X+sohA+NHaFt0FMmohAC7M0Wg4WzbqQe63Ocp+yemYwTSjPMv7HaJemr11c8wk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199018)(5660300002)(44832011)(83380400001)(41300700001)(4326008)(6916009)(8676002)(8936002)(66476007)(66556008)(66946007)(966005)(316002)(54906003)(38100700002)(36756003)(2906002)(6486002)(6512007)(478600001)(6506007)(86362001)(26005)(186003)(6666004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YW9Uc0RIdlIxSTZ4MnN2WUtxdm1RVFBKZlhYcVp4TUN4SmNYVkZNYnAwc05R?=
 =?utf-8?B?QkRoWm1zbU5QZVJYbm9aMjhpV0h0L1l0SXRSM2FZK3pENmVOSkFMVENENDhO?=
 =?utf-8?B?K0NBanY0SWo4MUxtblVKRE5lOGtFellDbGNuWFUrV0xiNjkyQ3lNZ05vanZR?=
 =?utf-8?B?Z0htYXhOMWViYktnZjN4NmhpL1J1Q2k2d1hIVGhlYlEybWNpWWRWOUpQeEp6?=
 =?utf-8?B?Uml2NkZoRDRSQTg0RUtyUmdua0RNQk1jb1ZlUVBUYUN4dXpxU1VRZU5YZDgr?=
 =?utf-8?B?Unc3T05FUUZRcFFEYk9nRVo1elNzbnIvWmoybElQVk5Hd2RoZno5Z1lNRE1F?=
 =?utf-8?B?ZEUwYmJ4ZlBXVnpwanl3ZEQ3NEtPL0EzckxzMGduVFA2d2h2UlFrQXAxUU80?=
 =?utf-8?B?K1dwbndRMkRVc0thRFNBcUxNMHBlcmJONGVnaHNWTUtUZ0Q2Zm1QNEdBK2Jk?=
 =?utf-8?B?WUNkS3B2ZXVmQlRvd2lXT2RzbkQ4NVhwL2VwRmVKS2pPSkovWVhWSFRUVSto?=
 =?utf-8?B?ZWVXeEhscUVjc21aaGFQbHVoOGwzaE5GV3NDWEwyakM2Ukg4WUxKeExaMFQ2?=
 =?utf-8?B?cUExMzJKZ0V0cXNxTzBqNFVBMERPcmZkWHRoVG1ka2NBMnBXcXZtOFB6V20y?=
 =?utf-8?B?aC9WdmpmMnpDWFU1TUEzbk5HSlV6bjZJU0E0Z1prY1hWVnhPcHNVRWdEU2t0?=
 =?utf-8?B?d3U2MU9CMjNxUVpEMUNkWkR0N3p0SnBoNWZCVGFhMzdiZENwVGhJdXlsN2Rx?=
 =?utf-8?B?VmM2Q1AyeDZab3kxSW54Zlh6ejZZL2JEM3pxSklmYzJUNTVSZCt6Yy96Vk04?=
 =?utf-8?B?OWtVaUM4aEFZbUFYcHdXRndKMVpRTGM4dW5DeGVHL0w0QWFMb29RKzF1R2tz?=
 =?utf-8?B?QjlPQnVULytJRUdBU1ZDbUx0cXlwVGxRSVJSd3FvMUQ2a1M4aG9YT3NCWCs3?=
 =?utf-8?B?U2xITnByanJsWlp6akRWcWMxbUdpSmFYTExjTVFJQU0yUTZvRXJFc2YyTTIy?=
 =?utf-8?B?eVpEUFVCMzhMcWVDZGtuWWptRDhycWJFSDVBVzlydlpnay9oeUVqWElMeDJE?=
 =?utf-8?B?Ynhia2ZsZHBIWjRmSHdyZjVWeVFhckZEc1JTQk41N2lMSlBUWktvV2hJYXB1?=
 =?utf-8?B?aWpkNzBSS1o0WTdURkxyaklyVnVvMXNWRHNlb3g0RkhPNW1IMXRPNUxLN1A4?=
 =?utf-8?B?MHphc2ZvUkJoL1BIOWRWQ3FiR1IvMWVuOHhVWUVXM3BVWGdXOFVocUFJdk15?=
 =?utf-8?B?N3ZRajY4UmcrM1JlZFVTL1N1REpVT01TU21UUWVBNG1oZ3ZTMWlYQ2MyMmpN?=
 =?utf-8?B?bzZyeXprUEJtV3RjbHBFMlU5bWVWN3NNbS9vVU1GOWxiUTV2akc2akxuZ3Bt?=
 =?utf-8?B?TVJyZmpROEdqbENFaUdLcitmU0VUc3RuZFR5UXNDUGswd3pKbmdXYnQ3TmR0?=
 =?utf-8?B?KzN2WmExYVZXaVhOMFlRemg0cWt1eVJmdU04dTl6d1ZRWGRRWWNlcXFnbWpM?=
 =?utf-8?B?bS9OcFkwLzJtNmdyNEhYaSszTkszcytBUmpiaGZBL3dhZ0JETjBwZm8vcDg5?=
 =?utf-8?B?bG85aFkyTGlmRnR1QTFhQk44Zlpzci9lSktkTStCTENoRG4vaExlN3RsNEE5?=
 =?utf-8?B?bGFPdGtkdVhOM25PYUNHdk1tS2RIRXVQUm8vWGxJOUxVU3FGZG80K0xWcGVC?=
 =?utf-8?B?L0UrQkROd094OXFVa1grcDcwTlp2Z3ZWek9RVk8xUGFZSVZlOElnaTAxWHpx?=
 =?utf-8?B?Mis2RE9YVElDR3RkdTRHdlRIV1Y1NW1JTnNFRDd2dCs2UTM2ampzZGs3SXZL?=
 =?utf-8?B?NWY4VmJxK0xMdlFmSmNIZVdFclVQbStBZEVMYkZVT0xHa1licnFnVUtkNVhK?=
 =?utf-8?B?OFZzaFZMTlpQSFozZHZnaEpVOGNjMmxrczRmZGJUU2NsNGpsY2NWM2pGR0Uz?=
 =?utf-8?B?alZVejNUVGtNSzMwZCsyOTBoNmxlQXhZUkphVzR2YVkvMXVnSndzR2lmbkt0?=
 =?utf-8?B?cEVPeDI4Vmg0SUNpM0hrWlVlWVlLWFVCVUhQYkY2VzNsQjc2Wm44aFlqVjF4?=
 =?utf-8?B?azBjWWdScGQyUlFPMExMcGVQSEZqSHVpZmQ5eW9KVFduNmJHTjE0cWJqOFdC?=
 =?utf-8?B?VUtEMWxHOUM5WGRFY0luRlQwMVlLdEZvSkw2Y2IwNEx6L2J3ZlBDWHpRZUFG?=
 =?utf-8?B?SGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: UDWc+98FcrOvUj01tVfBNWXM1a+f3NPnk078eyVLexZpsSosvR4xZhAXjxvRdUDdcnysjIeWmZ0+23WCKzVo48Fx3PvIUUxiam+RZIlOHq/zcfhKkNbSF+HaD3yx7wcE4Toms0JlLMz/v6rzL+/Stsjro/noA4Q9rIwrSDJO0I2MIeSKqbOTEIGeWGIW3sR6oAgdmHc7VH3WfnviaHLpxFFq8eKxmYIJoqLOYdxtPhP1Dcr38lbcZ/TUoiqTc1NXTnNffJfh+7+JAk9XHf3ca+qSVtXT39/7hq5R4X3ZTB3AclCPAKiFrQeZ0UXo1o6tje+VwxtlEdGc+Xtcwdk0z8vkaS6Any10q8VyUTZzeFGO4IGr65P3jlhEszYSb0U89Vpl0T2zIE6hkOAG77tYKl+vv0H51Azzz2CZZBJQPifW2fKzwFwK5hbK6CH4T+UbPSKOX0atKlccKF6Ogtehv3t234sDrRmqYn73EMIjTYelZpy/zUAajsBhH4OJQdzSTRNiYlsVUjBV7eWv5GvJadSw4Jbq1lc3QwNiQMeW9dwOBYNPLOVmYUAgXgca0LeV3hnLmLRqf2ZKxlteunHrL+4guVOBoqY8t4OwyhM4Wr7FT6m1QAfJcqjp8hSNji3bBKK9PNzJKkmt33apjVJsfqH9dQ495TTG8eWJad5QJilfIIye8KPvqAs3SCL/8bR9V9as8xx8CgNcB6yq5BajF0XSXJ8uwSpt+QRuKsuetH/fyOQ69OHlb/aPJ1AxkLjCmuWTf8ewwMG8bs5hWRMlKrr0vERfVysdSBW2J7XOukHUzFjB6Ftfb3uONW/r9y/E9zkl2ZglbqPE0MPGRY/zInkVcIixGR6woNmvTkPJUvLu8NJ9nIg2Et/TYAtuJyfazJf3r6s6uc0Gq69K4G58sg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee52be01-7a99-4b47-caf6-08db1ac2954d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 02:05:23.5500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +wChQ5xftFSWg2SmtSYvVN1h1DgJsOOVY8ZVvK+MEYYgfQx+W9RfAj/08nEbgecIRGtHw79fESWru2I+hQNIOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_17,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303020015
X-Proofpoint-ORIG-GUID: FJ86IG5l6cdXkq1QXC7iJlMiN9gVUoYQ
X-Proofpoint-GUID: FJ86IG5l6cdXkq1QXC7iJlMiN9gVUoYQ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.

Dennis Gilmore reports that the BuildID is missing in the arm64 vmlinux
since commit 994b7ac1697b ("arm64: remove special treatment for the
link order of head.o").

The issue is that the type of .notes section, which contains the BuildID,
changed from NOTES to PROGBITS.

Ard Biesheuvel figured out that whichever object gets linked first gets
to decide the type of a section. The PROGBITS type is the result of the
compiler emitting .note.GNU-stack as PROGBITS rather than NOTE.

While Ard provided a fix for arm64, I want to fix this globally because
the same issue is happening on riscv since commit 2348e6bf4421 ("riscv:
remove special treatment for the link order of head.o"). This problem
will happen in general for other architectures if they start to drop
unneeded entries from scripts/head-object-list.txt.

Discard .note.GNU-stack in include/asm-generic/vmlinux.lds.h.

Link: https://lore.kernel.org/lkml/CAABkxwuQoz1CTbyb57n0ZX65eSYiTonFCU8-LCQc=74D=xE=rA@mail.gmail.com/
Fixes: 994b7ac1697b ("arm64: remove special treatment for the link order of head.o")
Fixes: 2348e6bf4421 ("riscv: remove special treatment for the link order of head.o")
Reported-by: Dennis Gilmore <dennis@ausil.us>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
[Tom: stable backport 5.15.y, 5.10.y, 5.4.y]

Though the above "Fixes:" commits are not in this kernel, the conditions
which lead to a missing Build ID in arm64 vmlinux are similar.

Evidence points to these conditions:
1. ld version > 2.36 (exact binutils commit documented in a494398bde27)
2. first object which gets linked (head.o) has a PROGBITS .note.GNU-stack segment

These conditions can be observed when:
- 5.15.60+ OR 5.10.136+ OR 5.4.210+
- AND ld version > 2.36
- AND arch=arm64
- AND CONFIG_MODVERSIONS=y

There are notable differences in the vmlinux elf files produced
before(bad) and after(good) applying this series.

Good: p_type:PT_NOTE segment exists.
 Bad: p_type:PT_NOTE segment is missing.

Good: sh_name_str:.notes section has sh_type:SHT_NOTE
 Bad: sh_name_str:.notes section has sh_type:SHT_PROGBITS

`readelf -n` (as of v2.40) searches for Build Id
by processing only the very first note in sh_type:SHT_NOTE sections.

This was previously bisected to the stable backport of 0d362be5b142.
Follow-up experiments were discussed here: https://lore.kernel.org/all/20221221235413.xaisboqmr7dkqwn6@oracle.com/
which strongly hints at condition 2.
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 include/asm-generic/vmlinux.lds.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index d233f9e4b9c6..44103f9487c9 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -906,7 +906,12 @@
 #define TRACEDATA
 #endif
 
+/*
+ * Discard .note.GNU-stack, which is emitted as PROGBITS by the compiler.
+ * Otherwise, the type of .notes section would become PROGBITS instead of NOTES.
+ */
 #define NOTES								\
+	/DISCARD/ : { *(.note.GNU-stack) }				\
 	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
 		__start_notes = .;					\
 		KEEP(*(.note.*))					\

-- 
2.39.2

