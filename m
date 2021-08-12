Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFE73EA8FD
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 19:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbhHLRBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 13:01:32 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:22248 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234122AbhHLRBc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 13:01:32 -0400
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17CCk0Kh010817;
        Thu, 12 Aug 2021 17:01:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=ZJ+xE3ltCqvAyyGfX6QgpOxb0QbQzX8L8UcwFrooW6k=;
 b=c6m37/KbYHuoTaQthp2SFdO9LliNn3XK38Fck/N6MD8KAvNJ6tMmBbZbgjbB7SVfbG2Q
 7PA6Ik0p8s/y8ilSDrm41z/8o4HXyBBFRnJBN+PIVVDbi4Am0oenxqaqopwXDAQM3mK2
 +Z49TNre/rpQBRWNfzFNPN36JiRQPIvCf29OKIiihnkuAkB4IF/jfRhBNkOVS1B1dFfA
 WaCdYun1Y2k39QmfRj1FjwhFzIdk0djRruZ6nSBv9AquE+CfDAb/i8PDIqhgun3spXaj
 lUnX0V0t/wBYksOLRvt0mMJOcK80tOfU6ZX9sdcLnj+ggvrZr5oLBHsml/fVztznxLZl xA== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by mx0a-0064b401.pphosted.com with ESMTP id 3acsen0jxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 Aug 2021 17:01:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGkL3zKIg86gMmJNNzlOGebjVNaUhp8hv8eAcVT02+GaNR/SeeSh7yBPHuzjRBwYcjaiQ4d+5bSF9wJzb8QltWxuiLj8JhPN89BJ6CDgoOgHsXC3f0WKFF9pnhq4lOUdfuIoWY+NIs9F0YXjQVKSxbt9DatK1ueKRwgbgU8fogYddhGkVnyqqjOz/XxU4w3mERZ/IzCcrxEpPzBi7TxKgWcS3RULlK0Mm6I+YSH42LDcu/6S8u4SvOkgTROQYRBq6r5ItfPtXRIc/KLZM2oNXfuFMexsR5Eb2W7uq+Nc11xEru5oRarVB+3XeNGYqp2obwGSMZbpfNVNVxzgaSHUiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZJ+xE3ltCqvAyyGfX6QgpOxb0QbQzX8L8UcwFrooW6k=;
 b=Pl1S/ANMZlpd31QHtAVP6dhxuJpv1Ji7cEh9mkPJO1MQvK5RRTTXhdaEvg9ro/66NKTEXFE1MeIoN1YXM73Cb5vLBzD5OqOsK4iFEYpeIBbfc/H6ustUqL2lGVzlWh+Yn5tlvau9vKcX2VNrNesbXadkiOJQyiCmEFjaBXLdfFR1kW1gYmWckfDhd04RZHbPXLQqP86CCI2gmua09L+JOt4k6jN1UcP/7gh5qfDftX6bGFvPhJpAVbMZr6AbvXsG6BJCN61eifTfNdOAOB4ljFU7mq7th7GEhTjyJmHZhf1A8ikqrZ/fXqpQYmIHQER6U5WIiZssOjU2KbLjNamzkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR11MB1593.namprd11.prod.outlook.com (2603:10b6:4:6::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4394.17; Thu, 12 Aug 2021 17:01:00 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%9]) with mapi id 15.20.4415.018; Thu, 12 Aug 2021
 17:01:00 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org
Subject: [PATCH 4.19 4/4] bpf, selftests: Adjust few selftest outcomes wrt unreachable code
Date:   Thu, 12 Aug 2021 20:00:37 +0300
Message-Id: <20210812170037.2370387-5-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210812170037.2370387-1-ovidiu.panait@windriver.com>
References: <20210812170037.2370387-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0251.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::18) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR07CA0251.eurprd07.prod.outlook.com (2603:10a6:803:b4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Thu, 12 Aug 2021 17:00:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 295f124a-81d3-4267-e3e9-08d95db2c2f2
X-MS-TrafficTypeDiagnostic: DM5PR11MB1593:
X-Microsoft-Antispam-PRVS: <DM5PR11MB15939328E0CA0541DC0E8BEFFEF99@DM5PR11MB1593.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UA4ciA12Q2efNJa99Taolkfawk/EeykANNHQNcji1vTYq4gQugFtSD8loB02mhW3gpsjkwWEAKI5Q74qwut3kAW7gsm+Gl294Z0TdvcYhedhvPgVPvZB8V4Ox/PfD/7caBMQPJeUrVgWpZ0CQmBUeh+kzu9/wI17+GBZsHR7fEg1nDEG4xtug4MwSjJ5O/2OgSOL3h0Q5/5o6QviK+i3m/fQhKiMjiZftnA+EA2CDVHfxBoXQlbVaMb+h/63aJoTBogFwmZjq7Xow7TSRn5jimXcIA4TUImpQHN2T/rX85m3zAp9x9MJaXPqqatz/+HOiihVpT2vn42s+NBgx40q5/EsYnyusjBiCbNLINM+3LJxlBP3/5+NfpLcB+RjD7Y01AGBNBIRKtbsWZtCaZ1eU1aws7dEZhDf6ifmTPcjV8bmt1+ezaazJBxNk/O3RR2BVhSHPNPId/eA6nNzE2M0Su1HlJqajNAsHeEqerg+00oFptjQgLAyga/m563QMrTO/rtQcfeyYhsBmmtC64EeaPTlUArdyYFA6zvI2geUuRJyQHjlN0V9LEj/JpfLasoB3TZoXgNBZ3ByaVqs1+CQLQ7jf/4P4upqSHhOfA5H2C0ZfkfIoSMgM7lOKwjgQAkFUWxZap3Qrw5Ycp+22iihS/RF4mn/qRjv3VUql4tzES1I7N2yL2wZFPIt4m/LuJ/V2K8tCI5degu4rzqcNbW2+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(396003)(346002)(136003)(376002)(26005)(66476007)(66556008)(8676002)(44832011)(6666004)(316002)(86362001)(2616005)(8936002)(5660300002)(186003)(6506007)(52116002)(956004)(66946007)(6512007)(38100700002)(38350700002)(4326008)(450100002)(6916009)(83380400001)(6486002)(1076003)(36756003)(2906002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fWHJlbgU33KlX9XwzjShqYPS08grP6OweIZtnf/MTM/Nqd07VHdl8X2WNhl7?=
 =?us-ascii?Q?ilWdLQKYAIYTvQWQQZ/SWmv+e9txC+HrfAj+lYFuc9ouN2oX7ZXPZhQmUCz2?=
 =?us-ascii?Q?ByE9NkCO6oD0zYf3r7VDkitnMRvNnxkN/6fN9s2AQqrhDh3oP4UtO7NOsGKd?=
 =?us-ascii?Q?CCmpemeZi/elKQ3Cilq8K73sEk0o+ri7qZryGtosdQavM4OknJwkYZkepUsQ?=
 =?us-ascii?Q?a0N1386MMvngi2BnepZ2fVq+sXpWL51QJA5d4kGIlze2vRldGFwZPqZ6fy7G?=
 =?us-ascii?Q?gzTrPFYjDw3YLF/tmfGwMfaLVgFhzzBBB6I3teug0EPx6yEI6RSbIQL+lU4a?=
 =?us-ascii?Q?eDapzbeWGhR6/1LXXk3h7FTZnh9QXzXnB0zGBI9p7UIofTMIA6fBnYILACBK?=
 =?us-ascii?Q?YzqtORM7E4G+m9B2YJsJmcJwsOVY4ZbDYtvxncNoBrmUn/BVIQ49lrzvXFQL?=
 =?us-ascii?Q?5FAjNnZcI5jRuzdA0P33fBnfV6AT+boa4JjVkkeI6kRQsXUkHkWnYYifXBL3?=
 =?us-ascii?Q?18/FEYG/b1rg4TD3jR9IPCCqOFPcO84MedV7o9koTn9fS4FfUJ4e6ncovqmB?=
 =?us-ascii?Q?UQk+dNT8Af2SUXd0vNK+VykiPMh7in9b+j3qBOk80cAtvpxdIpafip6ZS2kP?=
 =?us-ascii?Q?diUzDWdGwuUzPP8TmDk3GQ5Dtpq6rZmbbgiMUxLEyjtD29fCDvsFrrcGslcU?=
 =?us-ascii?Q?XXGgNUwqUA3uOBxxiAr1qbCrDvL6keBqa3G69e7Kbi3cR3yvRR+IOcpzV1P4?=
 =?us-ascii?Q?I7LevErVl6IPx7oxMwpeU8J7QFUrK/pTgFuQHQ1uIBBwzXxaiTuPJR9fRuyc?=
 =?us-ascii?Q?uzsbFwwNcw/3p4Urv5UQD4mQJORxM5YAIVrQiuZSLrQLyYxUnwEnuXEzpI5F?=
 =?us-ascii?Q?N/eRyc9f+1HaloAT13zSTjvuvPHVjeSKrd+7vsKRdKEp9hJKB/QoV63OHxZh?=
 =?us-ascii?Q?QTNbLrQovISXqmgWJTNfY8P1N/+BdYMDzcV0sJ/onDUl3nYGn5CiNEw8VwAL?=
 =?us-ascii?Q?UQijnL31s8ZjrHHH646ANJplUGYt/eGVv8M+fb19Xw6MC+JVChYchq/150eZ?=
 =?us-ascii?Q?owb0eeogRREsscP32IFZCY57mvtKWgbXGD2mPHgYP6ztlamhGet27mjJ1zr4?=
 =?us-ascii?Q?jSfKDQdV8iJmP5BNycSN6qj6bMIxu/Oaq7n1ysjvVrL+fnK2K+SHph+myURn?=
 =?us-ascii?Q?UibHXkTCMpMR1evg0foG5adI58/VE8YNUDNa9dmSdH3cSli1UiaPlmu8VtY8?=
 =?us-ascii?Q?cbdtv6tvAcGGBaY2S4TyJmWMtroCWFDh39t/zukDlG54GkIqS+MMIiEDfD7D?=
 =?us-ascii?Q?v/zuP3Te/AE+ntk1qBXmmxE1?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 295f124a-81d3-4267-e3e9-08d95db2c2f2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 17:01:00.7170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dCbrGxgj/hcvZ4qswkN+MhNpaoRa1CORivCVeBMS8LTs+WhRO0vkFu5iqny/BQxfdOMTg6HTYuxrjl/ugWNiHEJc76GllGQoB2qNg8LMW/E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1593
X-Proofpoint-GUID: PjNnaaqoB34DD1CrtjNMvCNOAZbjGJOc
X-Proofpoint-ORIG-GUID: PjNnaaqoB34DD1CrtjNMvCNOAZbjGJOc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-12_05,2021-08-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108120111
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 973377ffe8148180b2651825b92ae91988141b05 upstream.

In almost all cases from test_verifier that have been changed in here, we've
had an unreachable path with a load from a register which has an invalid
address on purpose. This was basically to make sure that we never walk this
path and to have the verifier complain if it would otherwise. Change it to
match on the right error for unprivileged given we now test these paths
under speculative execution.

There's one case where we match on exact # of insns_processed. Due to the
extra path, this will of course mismatch on unprivileged. Thus, restrict the
test->insn_processed check to privileged-only.

In one other case, we result in a 'pointer comparison prohibited' error. This
is similarly due to verifying an 'invalid' branch where we end up with a value
pointer on one side of the comparison.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[OP: ignore changes to tests that do not exist in 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index b44324530948..c7d17781dbfe 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -2792,6 +2792,8 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_7, 0),
 			BPF_EXIT_INSN(),
 		},
+		.errstr_unpriv = "R7 invalid mem access 'inv'",
+		.result_unpriv = REJECT,
 		.result = ACCEPT,
 		.retval = 0,
 	},
-- 
2.25.1

