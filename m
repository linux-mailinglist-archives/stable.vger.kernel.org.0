Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF0E3E065C
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 19:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239797AbhHDRKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 13:10:07 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:55160 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239790AbhHDRKG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 13:10:06 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 174FpFA1032119;
        Wed, 4 Aug 2021 10:09:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=XZTSLUw4C4eeYXtd+Rlmyy4SYoT11tzDBv7rIG001+4=;
 b=lHEU6Dd6zda0KKH0RMnKSjxWdaJTdR/8bk7dOo8xzYT4yRMI8BqgZQ0aDy0aVFDtuVck
 IAbKjDwMJOmi3TvF4MNu8AkLITt1NNO1DWwDArz+23/zybatRHuEKJNFU4kC2MU3H0P7
 I7DegvR/ZldtPeApU8TcASREr9Q/qBa76S10JmlxfrIG1OGAPQChrdGeY4VqlTNinkY0
 V2WmmUDTAMp2bVcefTohmHx8rGN8B8PdAgXjRaN8n+2jIIymwfuI+UW5o+U16S32wupB
 0+kKIrG5LsTCbLvlEg/JmeIOLXt1ua9+NFf0atSm4z4LV0U3HRvFahxIXMU7+QNUMOsZ jA== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a7vt6r425-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 10:09:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h1y3Qs+T45MJexHpaPwNO8+VU4pCurBuadtEBB1hPY/KNdsXk5ZkFn6gPP+AU9tFRMyxvvaJr0axL5atONJUwbWDRObjiixZWUqjiY8RGcDqgdlATNm1DYe3NnqwDisw2O++vCO0uOWKq5BDNIe/z6Gl9yNLokLE6rfFWaBZPOMMjeY3sSTSHcWA6o0d59uLD0kF4e6ci00o/8FvKAsDztlXMmB8S3oeRZpERUvmcvmE1LvwYKY2a67alvKYU28GD6uzWgICUj0/qmYjklDvGs+rrI7t5LhE3M3aFzBgmbSesQMYgZ2Zf47ldiELtra3Cn9kTKYWoxs+XrIUPxGRGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZTSLUw4C4eeYXtd+Rlmyy4SYoT11tzDBv7rIG001+4=;
 b=QwRUn0vnR0J2aIqzv2a8Lj6BE8YgMRAbNzyuQhPrs4pLnRgOmjrBdhBQEkJhY4U4Ny2RiEB5HmIm8ecbuc6C0wlJPILm4zNarpVyDKi8aJPQZyplNViCxppL28/lBtuKFzcme0bvhMrAqDAr0PPc2nTQTo/awnvB/gJIg7HIlxTE2htgSv/zVZGoEEZPUdsdJh8h2kGTxN1Qo9SGq1u2cQPjmLDW8yw1wR8s5zko2rIi7yaXUXgIpyXNI1C8u+BIUAauNAovoYyrbH9alTpjzXATObMSxgI9gV72NeA3aKW1Ig2cTUpF24ww40dUeIEAE3AydKDJwUoQvkNEAKp2GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR11MB1834.namprd11.prod.outlook.com (2603:10b6:3:113::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Wed, 4 Aug
 2021 17:09:41 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%7]) with mapi id 15.20.4394.017; Wed, 4 Aug 2021
 17:09:41 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 5.10 6/6] selftest/bpf: Verifier tests for var-off access
Date:   Wed,  4 Aug 2021 20:09:17 +0300
Message-Id: <20210804170917.3842969-7-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804170917.3842969-1-ovidiu.panait@windriver.com>
References: <20210804170917.3842969-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0033.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::46) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1P190CA0033.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:2b::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 17:09:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40aa51fe-86cd-48ce-8b14-08d9576aa5d8
X-MS-TrafficTypeDiagnostic: DM5PR11MB1834:
X-Microsoft-Antispam-PRVS: <DM5PR11MB1834FD8702DC5AA2F93BFC80FEF19@DM5PR11MB1834.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:595;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HXYg9wNdOTnvYwKBw23QgFcpV54T8pKpanHyPXYJcYLqEUh2bHaAdExdOqerb1RRDXKYB2d0sVP8Vmqa/I1D3+Ivoy459xdtrKLNPe6vYFjCgOIy0DH5UTkuG09kx4zP3i6jSAChuyWx3gv+dC2EkLPDF2b9yk4Ny9w76IfkVYyazMZmdi+TaC0J1TVEOQtGgHnoS3/5ffPWp7x+xk/sljrd3tz9hgZKXkZZbzECHwsw2g4dU6EicY78UQEER56cFh40+Y1yo7ghZLdUi0hT+XLpi0bgO+kYeK1ETCMty/TXCG+xCeVSHHwdMMNbK8PtOBCcx1r3yFnwknHyBA7sifVzGygTZ5ayBVeAC7KjrAgvfZWtovuFFHmZazTotETPXXrGXTdIpkkEdSr+fXUMDOEB/98uz3jgccS/VMMTBMq2JoAOwIpt8Lml5Eh+504kr6fjJmeUAWAfdjgmmmkfJXgssUZbTbB0fUQx9k+GqoFvW04H4Ktpf4v/XFVpN3jKjZKStz7LeOsC+F1Ge7jv9Laf34LkNEHMg0NnwZAuMJBrtWKOkQPdBFoDYe69PvuKKCWYzDlLHSTEPlyMg7X1u0pfdgRgNYUbvL7jsTraRoWyxc1i/WMIKhBiaEw5HGPbrnRTYKveuWK+tjNtdMPHyfh6Vxolr23Syx90bgTWFGfYHZEvEVDms9lIWWcZD9F3FzU0vQ4/mYlscXoC4d9rtGu1vVPC7Kh4Dl/QNw4CbM8ixGsHfv7Eo3/Jrw2WToaThIN9GXqTW8bjWtX/HrqxnxOudFGaO0OHRGBaodfGoVA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(366004)(396003)(346002)(376002)(6666004)(38100700002)(316002)(6506007)(1076003)(86362001)(38350700002)(52116002)(83380400001)(478600001)(44832011)(2906002)(5660300002)(8936002)(956004)(6486002)(2616005)(4326008)(966005)(6916009)(186003)(36756003)(66556008)(66476007)(8676002)(6512007)(66946007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e3H3ibKNaHS4yk3ebUiFS3HNYa8YvRIHopwTp03GX+OoMNX4zdFZXHKLxazX?=
 =?us-ascii?Q?BsGp4OeL7nXrtpCIov4aEjLSLzNW4aMyHFtuJzBKiO04N4OKJaTUp/2E3jUA?=
 =?us-ascii?Q?m2jruJNDaqIJKPz+Qkdlq/J1gFKtHULdzXT2hYIRU3LCdesb02eTlvXsb7IZ?=
 =?us-ascii?Q?BvMFgvnLAqOG8GJD+zd5DRp7qxxu2oUedsiIlVSiP2ofPLb3TdNrqzzUaLbE?=
 =?us-ascii?Q?5OiRWOVLWJEuCMxuA3CjITpGRM/CxxwGevODzdWqvGUzbSwlbqUh/Be+a33b?=
 =?us-ascii?Q?hfotEMo/7AEDgEVgdjGWbFNuH3fy0AErIkGUlt2Www83YXF86DxlOA5v9/UD?=
 =?us-ascii?Q?nZGEJoVmJvX51U5hT6l/YYXjhiXwAywfwvClU/aM0dSa6UJ0aH6eva98Ezr/?=
 =?us-ascii?Q?0HAnKIBBeqW+xTOSM4rieZZUvHW2oLMWvRwhcpPNzjVzU3KOetyEYcrWSaUa?=
 =?us-ascii?Q?r6tzZugPMoH+6yeWtNqNgu8UV6rHQngG7hLWsna9Zt+r/I71rPWNjA+9YJh+?=
 =?us-ascii?Q?9IXPdLZF+FwI27PcXCoVxVW34hPfs8El1IZ70kmlNpchmJYWwBoFNvbydkEY?=
 =?us-ascii?Q?xoMDW50vuIfsFhSRXXS9SodFTNEZssY7UrBi/2ogp2epBrRhM9E2NcMgb4Q3?=
 =?us-ascii?Q?TH2u0Gl2zbJfxF9kudwEGSmx6Xh9jo/bb031EkqJ2DtToG6WCtJ48lZFKUeL?=
 =?us-ascii?Q?RPirZsyq+AcNLaRWWInyPi3R+XPNm0UH2ssI28Jcb/WrPgKZJB73AdjA2B7g?=
 =?us-ascii?Q?qtLemoowFq+yiChVvlsxg/quGGlrYbDD7XSSXqz9vBbitgzQGkYGqt5Ggr0n?=
 =?us-ascii?Q?FGDHLRRi4CmxfZHTKAIn1pSLlzJQ6aTSeZhFCH1s57NOwZ4k9lr3lKltnrc/?=
 =?us-ascii?Q?I5cspTIhZJVySAZQSVG6sCm+M+HePefmpo4031coOKMy+HKvB3UtA+P8hKO8?=
 =?us-ascii?Q?JoIYbX6XMiko9ww0C8ryKh7pRolF1lxLBMCKSJIItXhl4UYZc+DLEyfkqH4Q?=
 =?us-ascii?Q?qDtgckwdiKaG6jeOAYKUmDHecnCN08mluUuCF0EmnPxU6TvBBd8ckQ0iP7gp?=
 =?us-ascii?Q?P6fGlxavaxgnEf7fht1gYQjwCiw5HI+qcw+n34SGEkghNmo8C/HZXC6nAVc2?=
 =?us-ascii?Q?AWYJ0bqW4hISURjqq5ZU+Oxo2Ji9Qkt8UHREQsGq7DAcG+7aqup1MpxunW65?=
 =?us-ascii?Q?0X2sIomdZHjH1EOwjGHBUuzh5ruANRz9JJcT6BslLDswF9yrzaNv5wqokTuO?=
 =?us-ascii?Q?cQPyZtcv+GBAwvTxPmRO8huo8IkK/j5+e1lFyIrEz76SNF1sp/bcEwshMF5I?=
 =?us-ascii?Q?cgA6MRm1H2vAglNIXHe4mN3j?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40aa51fe-86cd-48ce-8b14-08d9576aa5d8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 17:09:41.1253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5NoVPd41GRxvVenLDri8gDkHd+9utJf6rnxRegXeCxAGKv3bn13ySZcmX7PqPiDn0Ftk+fPcTypj4Cfs2C5mufkCdyn7RhasFxtZmF0UUF8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1834
X-Proofpoint-GUID: r-p1DKfXrLuC1ANLwlKr6RkxF6D48oYC
X-Proofpoint-ORIG-GUID: r-p1DKfXrLuC1ANLwlKr6RkxF6D48oYC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-04_05,2021-08-04_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=994 mlxscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108040098
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Matei <andreimatei1@gmail.com>

commit 7a22930c4179b51352f2ec9feb35167cbe79afd9 upstream

Add tests for the new functionality - reading and writing to the stack
through a variable-offset pointer.

Signed-off-by: Andrei Matei <andreimatei1@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210207011027.676572-4-andreimatei1@gmail.com
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 .../testing/selftests/bpf/verifier/var_off.c  | 99 ++++++++++++++++++-
 1 file changed, 97 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/var_off.c b/tools/testing/selftests/bpf/verifier/var_off.c
index 49b78a1a261b..eab1f7f56e2f 100644
--- a/tools/testing/selftests/bpf/verifier/var_off.c
+++ b/tools/testing/selftests/bpf/verifier/var_off.c
@@ -31,14 +31,109 @@
 	 * we don't know which
 	 */
 	BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_10),
-	/* dereference it */
+	/* dereference it for a stack read */
+	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.result = ACCEPT,
+	.result_unpriv = REJECT,
+	.errstr_unpriv = "R2 variable stack access prohibited for !root",
+	.prog_type = BPF_PROG_TYPE_CGROUP_SKB,
+},
+{
+	"variable-offset stack read, uninitialized",
+	.insns = {
+	/* Get an unknown value */
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 0),
+	/* Make it small and 4-byte aligned */
+	BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 4),
+	BPF_ALU64_IMM(BPF_SUB, BPF_REG_2, 8),
+	/* add it to fp.  We now have either fp-4 or fp-8, but
+	 * we don't know which
+	 */
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_10),
+	/* dereference it for a stack read */
 	BPF_LDX_MEM(BPF_W, BPF_REG_0, BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
-	.errstr = "variable stack access var_off=(0xfffffffffffffff8; 0x4)",
 	.result = REJECT,
+	.errstr = "invalid variable-offset read from stack R2",
 	.prog_type = BPF_PROG_TYPE_LWT_IN,
 },
+{
+	"variable-offset stack write, priv vs unpriv",
+	.insns = {
+	/* Get an unknown value */
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 0),
+	/* Make it small and 8-byte aligned */
+	BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 8),
+	BPF_ALU64_IMM(BPF_SUB, BPF_REG_2, 16),
+	/* Add it to fp.  We now have either fp-8 or fp-16, but
+	 * we don't know which
+	 */
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_10),
+	/* Dereference it for a stack write */
+	BPF_ST_MEM(BPF_DW, BPF_REG_2, 0, 0),
+	/* Now read from the address we just wrote. This shows
+	 * that, after a variable-offset write, a priviledged
+	 * program can read the slots that were in the range of
+	 * that write (even if the verifier doesn't actually know
+	 * if the slot being read was really written to or not.
+	 */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_3, BPF_REG_2, 0),
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	/* Variable stack access is rejected for unprivileged.
+	 */
+	.errstr_unpriv = "R2 variable stack access prohibited for !root",
+	.result_unpriv = REJECT,
+	.result = ACCEPT,
+},
+{
+	"variable-offset stack write clobbers spilled regs",
+	.insns = {
+	/* Dummy instruction; needed because we need to patch the next one
+	 * and we can't patch the first instruction.
+	 */
+	BPF_MOV64_IMM(BPF_REG_6, 0),
+	/* Make R0 a map ptr */
+	BPF_LD_MAP_FD(BPF_REG_0, 0),
+	/* Get an unknown value */
+	BPF_LDX_MEM(BPF_W, BPF_REG_2, BPF_REG_1, 0),
+	/* Make it small and 8-byte aligned */
+	BPF_ALU64_IMM(BPF_AND, BPF_REG_2, 8),
+	BPF_ALU64_IMM(BPF_SUB, BPF_REG_2, 16),
+	/* Add it to fp. We now have either fp-8 or fp-16, but
+	 * we don't know which.
+	 */
+	BPF_ALU64_REG(BPF_ADD, BPF_REG_2, BPF_REG_10),
+	/* Spill R0(map ptr) into stack */
+	BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_0, -8),
+	/* Dereference the unknown value for a stack write */
+	BPF_ST_MEM(BPF_DW, BPF_REG_2, 0, 0),
+	/* Fill the register back into R2 */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_10, -8),
+	/* Try to dereference R2 for a memory load */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_2, 8),
+	BPF_EXIT_INSN(),
+	},
+	.fixup_map_hash_8b = { 1 },
+	/* The unpriviledged case is not too interesting; variable
+	 * stack access is rejected.
+	 */
+	.errstr_unpriv = "R2 variable stack access prohibited for !root",
+	.result_unpriv = REJECT,
+	/* In the priviledged case, dereferencing a spilled-and-then-filled
+	 * register is rejected because the previous variable offset stack
+	 * write might have overwritten the spilled pointer (i.e. we lose track
+	 * of the spilled register when we analyze the write).
+	 */
+	.errstr = "R2 invalid mem access 'inv'",
+	.result = REJECT,
+},
 {
 	"indirect variable-offset stack access, unbounded",
 	.insns = {
-- 
2.25.1

