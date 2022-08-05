Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1628A58B0B7
	for <lists+stable@lfdr.de>; Fri,  5 Aug 2022 22:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241459AbiHEUF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Aug 2022 16:05:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241135AbiHEUFX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Aug 2022 16:05:23 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6025F9B
        for <stable@vger.kernel.org>; Fri,  5 Aug 2022 13:05:20 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 275K0PDd017371;
        Fri, 5 Aug 2022 13:04:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=date : from : to :
 cc : subject : message-id : content-type : mime-version; s=PPS06212021;
 bh=WITCiyy5zC31JCllQtsYFzuTHPEjPa0HZr/k3Nwj7/w=;
 b=j610gJbXtzW44kjgT2NY5w3L+TyxyPh/T7e2JjtFeqFrMlHm6tjf7/Y1L3mllwN7cFbR
 VB7uuXVE31kCiMz7o8HPvpmpB7pbfuZUyZfl570AZSiPUFXEVsgPvDubYsSd2D/FGOMf
 CsjoCHlbFyiYFNXOyUX/t7kCUHwg8Adcyb5jMyG3sllcAudqDYAMhCQxFTXHIsiVFETE
 QEg9WAAzA2GrEJie5TiEq3L9FWVooPPluyxBpEnMZwOClXDtQAggPIjPCuRrKneFPM0A
 diYny6ByiHLrqY68BKL2cMWBY4aqVWF9IzWqRkx0pg+KA3I06GlZeG1IdDUp7wQftD9f FA== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hr3xpsntq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 05 Aug 2022 13:04:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iCpWjWiHzz1KlTU9M1uJMzkwnPAqy5cQVMGe5SsSICwhjNROSPFygAY+NVAugrg90fexfA5FOGRxlx2PPJsNkwW9Heuc1lNAEwT9hO2gnJlYXrORklVZz4sNIPBWhbs/bCKm9VVUubxfbn3h8dD08MJyjgPtZ/BSLd9g7smD0FsACofbEfxlZAihtj7epL5CS74evsdSEZzguGJegBUNo3rtlvlBu3dYvpTqqkCuzCs7/W7zx8FpX7m7Z+neONxYndjwyTLkWqZQigWTUGZErpdkES9TAJSCdj8LhbrIz2cnW9RK9xPekMGnhSr7/00pVcQzegKcuhdY1RFPpUaQkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WITCiyy5zC31JCllQtsYFzuTHPEjPa0HZr/k3Nwj7/w=;
 b=lD9Fir7/J7aFBh+e/KiltDT7v9GuEUupH3VJFIZqTty8QdOR8Vqh3ipJq09Rz+YIW0TVOKiX0l1kmzdLwAENCL61zsJz8mVjLZq4owz8VQ6vIIIDPa9HtVHvoB0CxFqFCDzhN3puR8/KQEqBP0f3raNJLZDw6vZXysUVkzu1DwosQ06WB3KEiDgD8ULgTgZp+Wqrg5gYjGPN7LarfODSsUJf711evchlyL9SGmtKe0P31HnZsgD1BFwkeqNq3b95+7+5ub3IAPnnUmRzNUC9CvjoCh6xn4sl0SviZ7ZRVmj7PFjfYpZLokol3BRwepbMTRmCKQanuznSxNBckvGq/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM6PR11MB4545.namprd11.prod.outlook.com (2603:10b6:5:2ae::14)
 by CO1PR11MB4785.namprd11.prod.outlook.com (2603:10b6:303:6f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Fri, 5 Aug
 2022 20:04:42 +0000
Received: from DM6PR11MB4545.namprd11.prod.outlook.com
 ([fe80::d07a:62c7:2b1c:487f]) by DM6PR11MB4545.namprd11.prod.outlook.com
 ([fe80::d07a:62c7:2b1c:487f%4]) with mapi id 15.20.5504.016; Fri, 5 Aug 2022
 20:04:41 +0000
Date:   Fri, 5 Aug 2022 16:04:38 -0400
From:   Paul Gortmaker <paul.gortmaker@windriver.com>
To:     stable@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Borislav Petkov <bp@suse.de>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: v5.15.57 regression - boot panic after retbleed backports with
 CONFIG_KPROBES_SANITY_TEST=y
Message-ID: <20220805200438.GC42579@windriver.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: YQBPR01CA0042.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:2::14) To DM6PR11MB4545.namprd11.prod.outlook.com
 (2603:10b6:5:2ae::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4ac0ea4-3518-441b-5636-08da771dbbd9
X-MS-TrafficTypeDiagnostic: CO1PR11MB4785:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QX5j9StSZ2MsH/XBUdXsD6u2uk98vlij9mU/8luM2n2+koSCdSgB5Ujl7DEcg83ln/V6J8Qa/pgq+2iOzkyGgBkXcuS1At3bvBbDKjtaTK5bjIXgU51H7eevWW347skg2AUI9QHq3nofnnmS9+OjTn/5GA9kBGfWU09WcCh8QuWusSG+DQrA1vK5lFkU8qs7+gKjFcsZUZqU8TKtMywcvPrWhf92U3OFOGXnUcEbhLISu0cOZvnXKoXk4/23Jso2q1LJBUVUaHMYRo8nFCEAVl+lYfxY9wm1z99ALBpYVWBaMidPNJ6fXobyg4Ds+UajvLPL9fx17lHNK9ekic2oZ3Ay/V3O4umVnFh1JzBt9J1LxIQUL2l1bb/iQioEUEQwNV/MBYpRYE9GdEeNlhjGSRGSvYBvcgF4mhdvOIjPSpbsW7mPH3cp29iPNSaCBGOonS0iCAQWI9WwqJ4b1LBU9GY5SW6OtIb5FT4Im79J+2Gf74YjkwWICRmuc249LNiPR2Zp+YqvChR7XzIo9yZtcP62EgspvhJwRIrgvloSSOY0HyFEhS6s8ez82LrD1NtPBNaT4n4GWSIFjO6cA8cyixJ7FBuRcnevFLy/F5s/om1dOPXhEN+RQbACeN4CcpYjYsD0G4xmiwwBrNZlqbHMgqCliYh0sqYsZ29Hp4Eu8623rd1rPZuL3kUUieb09INioKe9MWlt7k63J8oC55Y5ukI/MVEEB7BTQNFUjGZtegbi4XMXlZeGJsRnVt5aC/qtV3h6Kpaf5D/F/uHPPvX3ZCiMcvKMAG8WhwGeuQu5MOA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4545.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(39850400004)(376002)(346002)(136003)(38350700002)(38100700002)(1076003)(2616005)(186003)(6512007)(86362001)(33656002)(26005)(36756003)(52116002)(6506007)(54906003)(6916009)(45080400002)(6486002)(83380400001)(41300700001)(6666004)(478600001)(316002)(8676002)(8936002)(4326008)(66556008)(66946007)(5660300002)(44832011)(66476007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KYbE2XlLEuUHy+mKZg2X8pgDIoZlehGXYum3fYVK6R/zMxCaasfU+iiZ7vwz?=
 =?us-ascii?Q?nQ0ksDLGt79t0vxxP0Y5uTGXgzcCq84doiLDdVIBIouc8Pl1fIqcMpWWzgic?=
 =?us-ascii?Q?BAHyY1ct7JuLcCHONyzEFPh5NJRlYas5xSmFAhignkjaLOyBQpOalIFS9Hea?=
 =?us-ascii?Q?A+7ZByiFL/YFuY7vpFVEbN9Egl6BjUYMQz3aD/MP0kRcKXW7OyN4O5Mf0f5B?=
 =?us-ascii?Q?NX8+8CFM6XDONMjelCSOJCzzFDqzRW4A0T6wWip+JPCwpOUuTjlnecuW1kdP?=
 =?us-ascii?Q?8wHQEDJfaPT4+bC2hCyLH29LETlkVTK6foZyk5zoTy31xqej5/Snd6C00Gjh?=
 =?us-ascii?Q?VcDZZ9k9mShP+ueDq8DvXhJatcbYoGk7qDvQyTruR/Nfm6ZsKTwIlE6PEb+f?=
 =?us-ascii?Q?2IBR1N8d+RE2y2Pkil/LqDvUx+CO/OaOAyzWkEi9umthmPHC1i8If9Vm9Mju?=
 =?us-ascii?Q?5Bk2E6WiyCu3cpIRdDIxMl/9eIO5Xb+O0v2PeEZbQVJeLwMQYbFTZ3kWiu2F?=
 =?us-ascii?Q?0hvZGbRDZaD5dNyCqHrh3oJWBPSyqml3hbS2C8HQIH56JYaN9OIbVcXgQW16?=
 =?us-ascii?Q?YDt7Jca08L6YUrFAVSTxpIHq+tzaQObmZFtzRsbDQlxRGYwpOOg2lqB1NIsg?=
 =?us-ascii?Q?u3aDaxHzZLY/m0fLIYLUkIvXq3elVHKw48SV9EZ5Vx9FzpZ6drWVl7E2UDk/?=
 =?us-ascii?Q?/hNCyVriLXFOL0psx/M/910A9r5zQMujIkSDg7nX+T5GsTu+B9bGWm7JCgwg?=
 =?us-ascii?Q?lntjCi2TTqZwXaXM2zOPAMdVzWlyzGtk8kzFI+t/PzRsHVKRHVm1BiEbLZaG?=
 =?us-ascii?Q?G5Rki17zQlEIsMHv4ZLYEqybkdtUJslMmgPYZ1co+aeSDdab3SWUhc3JqBLw?=
 =?us-ascii?Q?gs+MZkuBwTUaj/SESAJ62KNfGYOYqLEGyZHGthRs1O5AKwPCxiq7dFdAv5YG?=
 =?us-ascii?Q?qMMFWkQJH6PXWa5H/JwEapAS0yH10qM9yfQ2hDaSox2yUiYModX5+C8hmtEl?=
 =?us-ascii?Q?y7K9vrND9u3xxLTWj2qGMVrepNE1M9sbQQErJ/bR9m79P5C1Sl1sUZCR54ee?=
 =?us-ascii?Q?z0pALbOrFcdIK84Rr6uVSlhJg1UAgQuyYxfIanyeQmZWeNdg3CB7eebMcPXZ?=
 =?us-ascii?Q?E5xOmXq54F5vjCbf2G6Rh1FdqrSM4HWvZ4gqcnIqBZ73JERjVHTP3HiMWOcP?=
 =?us-ascii?Q?oUChuzG8KT2OJbtBLmI5f7ZRM9uAsgriJkUah4QPKroST16wHdH5Sk2dmN+9?=
 =?us-ascii?Q?3b6HWooxdHpzUTIw9SCTvZK3n6FYKdZ+yAsBKsteeNSnlx0KmZgaQ8qb6KE2?=
 =?us-ascii?Q?r5Yf7Ld+8UkE5pLovXkBrjHrVOVbn5Zm76lTahNkKqmKjU6erPgeiIqnX+cp?=
 =?us-ascii?Q?Hx54KxyGHOdSjunuKRs7VjFcczwl91an3S0ACy1Les9E8hus/QwVdTXRDHmW?=
 =?us-ascii?Q?JDu+BF1JTHNdDSpyIvF/sxCp3+F2/tS5FPQaFxXY/gueDP9/SonWU0B9ju1j?=
 =?us-ascii?Q?QDtIBjG1Nl0qdidEJdGrKRzGUqK2GgShVOcyvGyDyXsFhvwnI+5Wncxo7c6/?=
 =?us-ascii?Q?DHd2GL4uBd4CQDv7Dc/fG1F0dZRr82rJjdt6FmerfyCr0NmWFXCyYZOoffUH?=
 =?us-ascii?Q?fg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4ac0ea4-3518-441b-5636-08da771dbbd9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4545.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2022 20:04:41.8980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LoR1mqb3gkFUMXl+78x8LQlw359MUNTQgdX1x6/zq+damXcPzuz4vjV8styZnjpOFsgKsszMl2ETB4t1XUdpB+afQ8VICzxZ1+BPkT4UP4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4785
X-Proofpoint-ORIG-GUID: NecmpXgTM9yAU7Od-QlS8et22IRX0gAl
X-Proofpoint-GUID: NecmpXgTM9yAU7Od-QlS8et22IRX0gAl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-05_10,2022-08-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 mlxlogscore=750 priorityscore=1501 mlxscore=0 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208050090
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The panic comes from the sanity test code, but after trying to boil down the
.config differences between the kitchen sink our test team uses, and a
"defconfig", it seems there are at least a couple extra dependencies for
creating a reproducer:

  make defconfig
  echo CONFIG_FUNCTION_TRACER=y >> .config
  echo CONFIG_KPROBES_SANITY_TEST=y >> .config
  echo CONFIG_UNWINDER_FRAME_POINTER=y >> .config
  yes "" | make oldconfig

Note that ftrace is probably just opening the door to CONFIG_KPROBES_ON_FTRACE=y

The report I got was with gcc-11 on an Atom; I was able to reproduce it
with the default gcc-7 found on Ubuntu 18.04 and booting on a Xeon v2 -
so it seems to not be specific to gcc options or processor features.

I don't know if the v5.15 backports were specifically tested to be fully
bisectable, but if we assume they are, a bisect between 56 and 57 says:

   commit 1d61a2988612ac0632134454d5407c63ae0b9d42 (refs/bisect/bad)
   Author: Peter Zijlstra <peterz@infradead.org>
   Date:   Tue Jun 14 23:15:45 2022 +0200
   
       x86: Use return-thunk in asm code
       
       commit aa3d480315ba6c3025a60958e1981072ea37c3df upstream.
       
       Use the return thunk in asm code. If the thunk isn't needed, it will
       get patched into a RET instruction during boot by apply_returns().

Splat follows:

   rcu: Hierarchical SRCU implementation.
   Kprobe smoke test: started
   BUG: unable to handle page fault for address: ffffffffc110f3e7
   #PF: supervisor instruction fetch in kernel mode
   #PF: error_code(0x0010) - not-present page
   PGD b2c60f067 P4D b2c60f067 PUD b2c611067 PMD 0
   Oops: 0010 [#1] SMP NOPTI
   CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.15.57 #33
   Hardware name: Intel Corporation S2600CP/S2600CP, BIOS SE5C600.86B.02.06.E006.013120181511 01/31/2018
   RIP: 0010:0xffffffffc110f3e7
   Code: Unable to access opcode bytes at RIP 0xffffffffc110f3bd.
   RSP: 0000:ffffae4bc006be38 EFLAGS: 00010246
   RAX: ffffffffb973f310 RBX: 0000000000000000 RCX: 0000000000000000
   RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000005856e7bd
   RBP: ffffae4bc006be60 R08: 0000000000000000 R09: 0000000000000001
   R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000001
   R13: ffffffffbae38560 R14: 0000000000000000 R15: 0000000000000000
   FS:  0000000000000000(0000) GS:ffff8c92df800000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   CR2: ffffffffc110f3bd CR3: 0000000b2c60c001 CR4: 00000000001706f0
   Call Trace:
    <TASK>
    ? kprobe_target+0x5/0x20
    ? init_test_probes+0x78/0x420
    init_kprobes+0x16c/0x18e
    ? init_optprobes+0x27/0x27
    do_one_initcall+0x43/0x1d0
    kernel_init_freeable+0xf1/0x240
    ? rest_init+0xd0/0xd0
    kernel_init+0x1a/0x120
    ret_from_fork+0x1f/0x30
    </TASK>
   Modules linked in:
   CR2: ffffffffc110f3e7
   ---[ end trace 759f040622219261 ]---
