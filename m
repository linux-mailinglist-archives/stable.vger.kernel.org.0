Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2B3C50094E
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 11:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241267AbiDNJJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 05:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240800AbiDNJJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 05:09:55 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2A46D949
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 02:07:31 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23E8MBtn008671;
        Thu, 14 Apr 2022 02:07:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=kajK0/T//T1Wuk0/KmY0XELtSJKSpY+Ap+ZTtliB9uA=;
 b=fYLPnib8v0zxvhn1KZZH6Pf9VzOKqqDk1hX46a2I9OyApo4LZQv43CtogETr/RVYy3lv
 DotwurYV6AEb7WC34dZH1Od0gEqzaupzpdGFn6bAJ4NMf13rXkqFi2o8/9vOOAuoAwkH
 z7bl6t/TM9+9TjUvhxG1q0grzk5OXridsy71uzYoVptpAK+xup1Q9geIF0md5eOOc7aA
 2rLmZqQR6jP2yHHznPAGnX9rTy4sISEPHeiCNHcDzFmEvZBCbCtRfzJiA/0glGYvIKbg
 qQg4D8aYq4e5+dB1PPJmPMucaM28c+sn16AsHKOK9+3WJZkQ/597oXtdVpvuSJKCpxdA mA== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb9nfurtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 02:07:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2OY3nGJ37FhzjmEh/CtLgcaya92dQ1mtC+xhWp0plrn1OjeUVq0lPCfT7DmtVD/cEed2UezqGkIOGyeigSAXZ90ZgMcN792r3uV0b/ORXnTfjBuZxFmex2k2o3k75vGrna04oPLsq9boRcnybXbuJC2H/pdDKT1ywTD2qkDHkl6ONbrVC6sRJrunr0GklacX+TaddyU2JvO04SkpVPMttZr2dBsA2iCiddHDsOQQpsXA7yMk9SH14DqWBxBPf1u1amsDwX4RjXaxLPlYyYOR8b+7sc+yEjO3nyAmBKIOim63BjfB5GQsGf7c2CdHAvmGam+MLCVXX4fjrPp5zpYsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kajK0/T//T1Wuk0/KmY0XELtSJKSpY+Ap+ZTtliB9uA=;
 b=PwDFfO1TtP1frte8mj0AEm0w40DbI57ch00uycQbHC6O50QxtIk1URqZIBAdl2BD6Mtuo0+HQGdFqjdvLUQy4/BRcHCXPpZ74FC1sf89us9PEYF71PiVNEAsNGivhSsyUuF1MB04ItFJs+d8QUND61kC8gF3QzI4wgUTGlApjTesDdd6FsOlj67PGiOupDCsW167Q1elBlnl+PmrYZGbx7h1E4Qfjzl3Xra1O/tafzQAVq2lDnGbtNmA7Hp4NHeM2Yk0oVg0hh9J0d8LcLY4/RgEkneMdZyPxbcySuu5uXC4ZxGW2rO12UEPRNFQNxSfaG+hZmtNS6pdCnv7cEvlbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BY5PR11MB4356.namprd11.prod.outlook.com (2603:10b6:a03:1bf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 09:07:25 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 09:07:25 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 4.19 4/6] selftests: cgroup: Make cg_create() use 0755 for permission instead of 0644
Date:   Thu, 14 Apr 2022 12:06:58 +0300
Message-Id: <20220414090700.2729576-5-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220414090700.2729576-1-ovidiu.panait@windriver.com>
References: <20220414090700.2729576-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR07CA0263.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::30) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75c06ae0-44a7-4399-3d51-08da1df63121
X-MS-TrafficTypeDiagnostic: BY5PR11MB4356:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB435696E13331C26F4E0DDD9BFEEF9@BY5PR11MB4356.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S7+QG8ARMC04uzKTcLZWmPOQPAkYXGT4uJZbFmnQp7nSVUmYOq2q5n1hP5GCMqJBe8Ey0FrFbN8jIWmicKFbdPYU/ZpiHxR2ivecT1mfuKCIl+SU+Ak9sMiQOK6HhtNA9bST66QpsHS1ghk5iW4kPDpjMjrcLXBqzzvofsnaD8aM/vUSlFkbHRRA0ZdEG/oUDhohEFAgQmkjka+75g5UWTwYEiR0RhHmUjCY0sFdnSaZB6HFnbyQYJCBCiWXy83wvATunBGqdtfhUxBRIwS1O0YDLIuWGVD4UOsaVwUKKip10gp7k2bfr7ZZDN+w5yh37jtravc35BoxIaxeV7WVi50FdvJs87D0TfhpkObU6FAsh8+0jlTwAL3m28sXeVQDyX4zz6DLNpdkiYZ8QsdRLaXDQsmp9y1aNuGgbbJf1cWaI08O2bMK7OPZWAjvf/+RhSF0Xa+W6xmwZ3CcJFxkj2WfaGLaZULENpthRfDmI5hCwfMOSoa86sc53n2O6ADEivMfIibsj3rB5nPDPjZslVoEuh856vWNVQWG5b2vHhsqfEd6fTCUSne1faFXv4Fe2Ppp2eOghFNmP4khQrtxnFQcwgH1CLwI/Q7zA0EDGoAvbNW9Fdt8FjCojXr7s1rWT+OYz44XyieTywkPDvZ1HcciNvj18WTWF/Gz27IeAP0NaBxwe0JNdsyrhsPSXDaOEifmc8dTvTiDhgTDIEDiFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4744005)(6916009)(5660300002)(52116002)(1076003)(186003)(8936002)(6666004)(26005)(36756003)(2616005)(6506007)(6512007)(508600001)(44832011)(316002)(2906002)(6486002)(66556008)(66946007)(66476007)(38350700002)(38100700002)(8676002)(83380400001)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkxwQnFIMnFqZHBvaXpUa1I1QjFCZzQ5ak9qeWJJVFVQZzRGOXYwNmdZbFZJ?=
 =?utf-8?B?UW9KN1h5SE5rc0ZUOC81dDVBaHVWVStaS0s2cklHcmhJdm03Vnp2WG5CckJT?=
 =?utf-8?B?cC9aa1hvQUhxMCtJdWtHKys5aUJFZ2p4b0Q1T0JPREdEMVIxNW56MHA2RHRp?=
 =?utf-8?B?dFU3YUY0SnVreFMvK0tXb1ZPTFh2c09Qb3JCOCtQTi9tT2R2U2Y3SVdRaXVk?=
 =?utf-8?B?Smx1QXhuK3dXY2c0OXIvREJxQjRWTEt5UnRJNU5tVURSTDRZb2RLa3VhUVk1?=
 =?utf-8?B?UUQ4Qm9DYzZVL3lYT29tand1eVpXTXZpZElBbmV1Q2hQQ2k2ekkvQ2NsWEdq?=
 =?utf-8?B?cGhhaFRFK3BjeXNjbEdER09UYm43T214YUs4eFdLelBOUWVQbHllbnpNT2k5?=
 =?utf-8?B?V0lLTFRlcGR4UjBiVXFUb0xCS0ZXVkp0TkJOU1pvcDBqc0IzZHVMZmZBaW5J?=
 =?utf-8?B?RDN6a0UzMk9lRFUxYnR6b1BTbElPSFJSMkhVRENQYU45V0ZkSERPaFB6WWxW?=
 =?utf-8?B?VEw5NFBHMnJwYnhBOURPTmpYQ21nZm9mRkpzNTJOMEV6Ymo5VTZNcUcrRis0?=
 =?utf-8?B?Q3dHRExQN05kR0NYYXRMb0p2ZjJDMHVpeVFrQkQrTGRhM2JyWG9FQ0dhZHRi?=
 =?utf-8?B?c1UwbTdMRDFEaHN0U3F0UjRsZmV0TS9PeWhiV2Q3RVJyOXQ5ZnMrVllyaXlx?=
 =?utf-8?B?QjhuMHlheVE2MHFZcW1DS2EvWENBSFJVRXBkaTRXRnFtRTl1ZVh0R1EydVk5?=
 =?utf-8?B?WEdJMExyMzg3TEJDTEF5eDQ0L0swTzJEeDd3V1pwdDFybXVRcjFPRGZ1WTZH?=
 =?utf-8?B?d1JzdnNsZTJJWVNvR0E4bGs4enFIZHM5SXphZkwxbytNSnptTlpNZkYzbGtp?=
 =?utf-8?B?SFN6WEhLQ1c4bE9wdGtPRHNIY1JtMGMvWjlUbVJnWGFQVnp2SU4rNmlLNmNh?=
 =?utf-8?B?eEVDbFcwYlNoMU8zUWxNN1VydHVFVDQxUVh3ajlMMDlwUHBBL3B2YzdPazNq?=
 =?utf-8?B?QjRCU1VYb1BDSzU5WXFMdi9LR0djbHJqYzJtT2hNaXlCaHJpbGcyL1c3N0c2?=
 =?utf-8?B?R0RJcDd3OWRwNTc4eTByMFNFcUFydDRRbXNHN1ZUMjg2MkJLZTVYR0V2S1RE?=
 =?utf-8?B?bVVjbktOYjF3TFNSM1BRR0R6TWZJZGplTDk0eldwVkJ1dW5rYXFuRTlmY2tJ?=
 =?utf-8?B?M00xN1hKTXB6TXdsbXY4OWtLU1Y3RmIxMkJCOWxjUzRhRmsrcWF6UXJuZGxQ?=
 =?utf-8?B?eW42cXF5SWVTZERzWmJVc1VORm9KdGt5cy9PaDZvREd4WUlBVGs4NU00Q041?=
 =?utf-8?B?T0tPVmdLTDZIYVpyR1FrODc0ditXYW1VeWV1bExvT1FHNWhxelNOQklmYlRl?=
 =?utf-8?B?bDMzL1hTcmRRWUpoemJYSW9oM0ZENG4zVlB5cUp5ZXhGK1A0SFFVeWVBTnV1?=
 =?utf-8?B?ZkNyRFFoOUpaVHBlSWxrZXliZ24zd3AxSHlWWlhxRnBSSmp1OUZZVUNZWVRD?=
 =?utf-8?B?bFpnTzFOWDAvUUNRYWNNYmxFZ3MvbS9mNkQraXIzdUVTaGN2S1V5Y3FFQ0Vx?=
 =?utf-8?B?VXB5MFBXTEZib09lV3o2dVJmVU9SSWoyZjhCMXRqMVlmN2lUNkxJQmFpTGgw?=
 =?utf-8?B?bXNldUlnYXg4MERnbDY5YXBnOHh0aTJvd2R6ZXNCODF2UzVFNDcwaWxYVWQw?=
 =?utf-8?B?WFVoL1NSNklTMUhpTmZmRmtkZ09PcWtuVi9aUkpVSWxtdVQ5M0RPMGUzWXlK?=
 =?utf-8?B?QndaS2ZMeHBGUVNVcTd1WUNJVUdlbTFRYTM5ZHlUYjNlUXFSa2VVTzZCVStQ?=
 =?utf-8?B?YUJTcmhCT1BvTVhZS1h4RUhHS24yeUpCVmhoelRKR3lKeFlCZFRBdHo1OVZ4?=
 =?utf-8?B?WXZxeU9jamlWTjZNbHhGTVkvUUVqbmZ0cVhPdHZFcldJS00xcXJ3MTBRcmdH?=
 =?utf-8?B?UTl3czJqd0JPeStUS3g5MlRkeUN4Y05zdEc0OWFJQlZsa0hvSzNUUXBJVFdS?=
 =?utf-8?B?S2o1ZkFpUjBqczRxRmtRZkttTEgxejR1TG1PMzZQbVozcmxINDZGQWRpRVNl?=
 =?utf-8?B?UHUyY2FFdmdFY1FNOE1xOGk5VHh1MmxsQXIzME94UVpuQTZsYlJxbVFwQmtn?=
 =?utf-8?B?d3o1Q3d2dmttNFkwV0F4VU5Xb29DOEd4NWUxcmFDckJrSXlyOGVKakhiUFh5?=
 =?utf-8?B?NHZHWFJkYmM1bnFPVnVvVllOck9DQlZ2UG5FOUp5YzBmc3hPRDBGaGowRHlR?=
 =?utf-8?B?UG9JQTR1cnRHM1pwVkJBYWw3SThmRnFGSVR4OHpndkRXOVoxcDY5U25nQnFa?=
 =?utf-8?B?eFpkSHNGK0Q1dmNIaUdFc3RoVEFZcm9PTTYwZjRLRUxIY3BsMFVWV2tSbTVY?=
 =?utf-8?Q?nLbK67ft+RkCPF44=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75c06ae0-44a7-4399-3d51-08da1df63121
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 09:07:25.2268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gPSlFrKBelwMbXYFfwNPxXdRv3Gvbve/zUJ+dvjGH2c1URns+6E/H/0oIDf5yzpzotLy7R6InVSU27hFHUYPKv7O7v4EmRqDkbBYcev8Yzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4356
X-Proofpoint-ORIG-GUID: HezUShE_YFOY6Nd2ocdyR6MPpQDTpiis
X-Proofpoint-GUID: HezUShE_YFOY6Nd2ocdyR6MPpQDTpiis
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=958 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 phishscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140051
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit b09c2baa56347ae65795350dfcc633dedb1c2970 upstream.

0644 is an odd perm to create a cgroup which is a directory. Use the regular
0755 instead. This is necessary for euid switching test case.

Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[OP: backport to 4.19: adjust context]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/cgroup/cgroup_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index 90418d79ef67..a516d01f0bfc 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -192,7 +192,7 @@ int cg_find_unified_root(char *root, size_t len)
 
 int cg_create(const char *cgroup)
 {
-	return mkdir(cgroup, 0644);
+	return mkdir(cgroup, 0755);
 }
 
 static int cg_killall(const char *cgroup)
-- 
2.25.1

