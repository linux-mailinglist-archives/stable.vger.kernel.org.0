Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D916D3E065D
	for <lists+stable@lfdr.de>; Wed,  4 Aug 2021 19:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239798AbhHDRKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 13:10:24 -0400
Received: from mx0b-0064b401.pphosted.com ([205.220.178.238]:16394 "EHLO
        mx0b-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230161AbhHDRKY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 13:10:24 -0400
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 174FTHdD019136;
        Wed, 4 Aug 2021 17:09:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=UJjI1gbesNOqC1qthiJkPKHW9JGPbVlLzQye1a+vVhk=;
 b=jdKXByV1XXDAa27PUA17Staz9l2U9F+F9XDgsSZEApFKUObSOONVBQuNXKmA7j7+3Vtb
 h5uYnbHG1xjR8ULVObEOYFqnwPs18p5r2xn0Ndt9pHtRJCLb0e46jXesu+0OShizCgz/
 nvJu+yEt68Jw2py930ULjyJ32IPXTpR1j7FikHnTh99JSp0KeBmoboIM/l6FXYNmA1iz
 ljfbLiRgb9RZNH+SbbVGyNWVEd41BDMDp5FStX8BFxE15EKRw0PdSWCqT99yXqJicN6Z
 mCEmAM3fbQ5kI9GQv2Xq6/fYMrRCDpf6b//rjCENTzmMKgF10QT8VRJNTNmy7YzBBcw2 kA== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a7uekg62r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 17:09:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Thy5LTKHj/viZhw0qOuhYP9FeuBeXmGWPGTL8A0p7/MKwEm4Iu2ENYWFSDSSDWCru6oKI7MJLydDkHHBHJo2COFzZhcVWWdmMUb5IlVqts/53E3ie4n9TtEZZtTx0b35PUcGY9ljY074kQAOFePmlgasbUmsqTN9eU2gLlU2rMYm2m0WGOv//q6vMa2vlPvZANoK0fx6Q+HC9v72Ow472m1YpEZjCI8B6lOLAyAO5TeT1Tg20a25cO9zOEbDAet3IN+oxcp8E5YoD1f0unfz0fMbvZQVAFIxb00xYg0XkDLoV2xcgf3QkLlC590fdAqVe9WtOxqiXIUlkPMkawykdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UJjI1gbesNOqC1qthiJkPKHW9JGPbVlLzQye1a+vVhk=;
 b=GhRfqgLYa5ImvSwLqo2Ii+pdPApWd7KU3v3aLPZaBv8AfUzFtQyzDCSWpaP5zpIDklqGRHa91JIhvwfh3TpMCeWSDvkYeeXq7LiS+rFkCdFxf8HFW2I+BUgGSqkO9yXa2QDEImUmgMFliOpXM783hhqSKE64zyMblNaNi5v9lkJ9M/gey/uPxltBK8VLdtoRPKmVO7yfTyJ6bLZyQpqUW7sy3jOrkKHqivT35dhwXhWjbGvYe21rdjz/k0gDsgd+5bICgiBXW8xYGOBpfp2kRfBw3T2u9/yg+hqCnY9VTJPLEXnCA9c/H8Ih8RYfRaxNahZu/tyUaxWyWlAmmtEM7g==
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
 2021 17:09:33 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::ccb:2bce:6896:a0c3%7]) with mapi id 15.20.4394.017; Wed, 4 Aug 2021
 17:09:33 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net
Subject: [PATCH 5.10 0/6] bpf: selftests: fix verifier selftests
Date:   Wed,  4 Aug 2021 20:09:11 +0300
Message-Id: <20210804170917.3842969-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0033.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::46) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1P190CA0033.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:2b::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Wed, 4 Aug 2021 17:09:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03b84261-c245-4165-b530-08d9576aa10e
X-MS-TrafficTypeDiagnostic: DM5PR11MB1834:
X-Microsoft-Antispam-PRVS: <DM5PR11MB1834180340657F4A41BFFBF7FEF19@DM5PR11MB1834.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2201;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o6G39NmZ+XYp1fRAHoN7Dz9fNedou0nhZTkLsj6PKYURWIQG0/HpvMn7sAAlKGeWEYvnvc0yxlhS+xMXRcMo6B1JufLW/mNeyzEFsV3aqq6OGgnyoYY03wguPOkep0zwgI/8F0Az0l2dbozr0k0AN0wCwUStobVCL1MfHXt4W4bTXoVnCW1MikzcocAKMHPd29ZnG+gddS95ZY0kuFFgq62dsSpmP24K17VSfMKhEfbPNRD0DThO0onimsujL4yqXxySahCljRSVEda6is3TT5Cv20NsPpGxRnhg4lJ6XD5o5KXJ5XNfNdk44h13wn22cfIbJ0N0BlrKLXLR+h780XFQUBnv3TnQ81IsALAKf+6spJEFneGNR0Pt7o+TgqXPCaqO0rNmtZrxkutZc3cP4Ks9TaC92k/rDr7/JQmcXCUNtua9wchHAikj8skyWPOWKaon/5GDY2AEsp0cFdqZgqFv/lSGT3Plua7YgbVnbDGX3CQ/vvaRf3/tk632SF9ozCxC2RjdtnOB/bSPTI/pjo3IozNFew0UMfnm1+x8OlikfTPWeO+3WhFfqotEUdrucQBdiRjnnDp8wI6IJkDqDoqjJx8EbwN2W4yS5wbbofnoMb5ckWclv8bytBtozp8Ip3Bhp0UM0Gm0dzja/+4lTwjH/UcDwHU8iMv+utfL8VS+LsFpxaJP2azwLAsI1+tsmZ9q+b/X898+p8S995PJ6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(136003)(366004)(396003)(346002)(376002)(6666004)(38100700002)(316002)(6506007)(1076003)(86362001)(38350700002)(52116002)(83380400001)(478600001)(44832011)(2906002)(5660300002)(8936002)(956004)(6486002)(2616005)(4326008)(6916009)(186003)(36756003)(66556008)(66476007)(8676002)(6512007)(66946007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+4kufiQaR6lEkjjMIsHP1k/KIrQTQIQ2dzY8H6qLSj7U5U/16KJiHEJTppOa?=
 =?us-ascii?Q?+8b7+wJHlugSO1nqw3T5cQErlyYrRe3wVTGZ1d5IwZ9038PAqmcFFhenX+RQ?=
 =?us-ascii?Q?hMNjEN5ZCXlGupwW8f6xwl9cNFt3fYgbBAg823yn5sia9gxHD3fACCiaVCz3?=
 =?us-ascii?Q?SqdYOu1a7QkowHvMpyPgMek4VjS+HFDnJVNMmA1u/DgIecsNrR5IOOtiUtA6?=
 =?us-ascii?Q?pnmTxw+FjJ1FcCa+Rd3VRBrdskyRJus5fRMURPp5w3NIn1md4+lZtXYv5tli?=
 =?us-ascii?Q?6vI5ZFMYEEXor0zKmcslksfI7er8Q3nQ1V3NYEDyrAPPYrg0m075n+84Z1zX?=
 =?us-ascii?Q?Op3GIt999UTVDwqOqctIcXF29G2gbsVPbYYE3f5ewzMc4B4EEVi6M0e8jNTX?=
 =?us-ascii?Q?Hb2Nrf3//3Ef2onwI2r6t48iFp+z/gmH3lnhsY2jadZMlK+IItWChcy08LBF?=
 =?us-ascii?Q?v7kLa9NbDy3Vd8bHM9e2gWZ3fREFLHZjAMTUS/JGvn+bWPiLQmRSC7KKrSkK?=
 =?us-ascii?Q?YZHTUjMxuLkWhJrWbwHfsBkR6gbacXnGOi72gQm+G7SfKZdcZ/4lOUex8oAB?=
 =?us-ascii?Q?82noDLPy1FuscPMAUiMjCe9ooi0ZiYVtv1Vn2s3hEWegLGhTElDlZH+k5s5i?=
 =?us-ascii?Q?CwFXRM5ex4+TtaCWzU5+fqdw242JYImQtCPRuwMADL9A1b1O9CNTE7KaKUEY?=
 =?us-ascii?Q?jFsHk+b/Is8EXL6QeVtQsxVqEc74dxqiOLcSiYYAk3al+QCXUaQJEqVBbNC0?=
 =?us-ascii?Q?i44bGULB/SMfQzSlD9dXyLBKxsejcZaFCrS2QYHzwN9U4SlAdc7/GmC5IuiC?=
 =?us-ascii?Q?1mnySCWJGHPSOxHvHcfS2DbBBlGReusYfvwnaNPhZx6cHPRuxKYKfLV54+v8?=
 =?us-ascii?Q?5qAJZBDrNcMwN7CTIoqyTHP7TD7cwxG9qXylfG64Z6Cegsa59OTAZ9fpi2r+?=
 =?us-ascii?Q?Z/kLEXRp8dHiQyuABIImMlFH9FmTORThRBNATyQp/Cx0uJGUogtgIBhg1Io0?=
 =?us-ascii?Q?0A2um7N6h04gNuh9s3QbRTrcoO1aHgzwdwX94iwd2dz9bchg3Kqy6doPcd+j?=
 =?us-ascii?Q?+V2B2HDwwUcm6QrkUdiHw/wEYoL1rW0iKBUoYGKTg4hwcrjLVMGoISKiZk+0?=
 =?us-ascii?Q?1dNCk7FCdnDQwSv7uc3BHNSvB3N+lqiixMzjAV/0WxtpcWAT19sBehSaFN9a?=
 =?us-ascii?Q?G2zEbGfPSt+OzGlqvCkLZAY6Crigdn7BXHFcJWVnyLgXVUrdnXBptmmFKdlw?=
 =?us-ascii?Q?xNdx7eaw6PL4Xtfa1TJAclAckOZEYFqXixp6TzXHUrrh35mxVpx8HvTEjx//?=
 =?us-ascii?Q?rH5LSsXbkzqe8o3ldHPoOSbe?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03b84261-c245-4165-b530-08d9576aa10e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2021 17:09:33.1295
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yok4UXyMNAaYGkPk9WYWJ9ITIQwo2KqhwRu5hiGGMm8nR7fAocoYxdoqYXmDXuDF7Ggwlkb6/5dfu+yJ5RDamQKJDcRyrofcmlR8YHsSLAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1834
X-Proofpoint-GUID: rNpc_vQz9CcqFoXAnQVJvXmpd_kjjBP8
X-Proofpoint-ORIG-GUID: rNpc_vQz9CcqFoXAnQVJvXmpd_kjjBP8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-04_05,2021-08-04_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxscore=0 adultscore=0 clxscore=1011
 malwarescore=0 phishscore=0 mlxlogscore=739 spamscore=0 impostorscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108040098
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patchseries fixes all failing bpf verifier selftests:

root@intel-x86-64:~# ./test_verifier
#1149/p XDP pkt read, pkt_meta' <= pkt_data, bad access 2 OK
#1150/p XDP pkt read, pkt_data <= pkt_meta', good access OK
#1151/p XDP pkt read, pkt_data <= pkt_meta', bad access 1 OK
#1152/p XDP pkt read, pkt_data <= pkt_meta', bad access 2 OK
Summary: 1691 PASSED, 0 SKIPPED, 0 FAILED


Andrei Matei (2):
  selftest/bpf: Adjust expected verifier errors
  selftest/bpf: Verifier tests for var-off access

Daniel Borkmann (3):
  bpf, selftests: Adjust few selftest result_unpriv outcomes
  bpf: Update selftests to reflect new error states
  bpf, selftests: Adjust few selftest outcomes wrt unreachable code

Yonghong Song (1):
  selftests/bpf: Add a test for ptr_to_map_value on stack for helper
    access

 .../selftests/bpf/progs/bpf_iter_task.c       |   3 +-
 tools/testing/selftests/bpf/test_verifier.c   |   2 +-
 tools/testing/selftests/bpf/verifier/and.c    |   2 +
 .../selftests/bpf/verifier/basic_stack.c      |   2 +-
 tools/testing/selftests/bpf/verifier/bounds.c |  19 ++-
 .../selftests/bpf/verifier/bounds_deduction.c |  21 ++--
 .../bpf/verifier/bounds_mix_sign_unsign.c     |  13 --
 tools/testing/selftests/bpf/verifier/calls.c  |   4 +-
 .../testing/selftests/bpf/verifier/const_or.c |   4 +-
 .../selftests/bpf/verifier/dead_code.c        |   2 +
 .../bpf/verifier/helper_access_var_len.c      |  12 +-
 .../testing/selftests/bpf/verifier/int_ptr.c  |   6 +-
 tools/testing/selftests/bpf/verifier/jmp32.c  |  22 ++++
 tools/testing/selftests/bpf/verifier/jset.c   |  10 +-
 .../testing/selftests/bpf/verifier/map_ptr.c  |   4 +-
 .../selftests/bpf/verifier/raw_stack.c        |  10 +-
 .../selftests/bpf/verifier/stack_ptr.c        |  22 ++--
 tools/testing/selftests/bpf/verifier/unpriv.c |   9 +-
 .../selftests/bpf/verifier/value_ptr_arith.c  |  17 +--
 .../testing/selftests/bpf/verifier/var_off.c  | 115 ++++++++++++++++--
 20 files changed, 208 insertions(+), 91 deletions(-)

-- 
2.25.1

