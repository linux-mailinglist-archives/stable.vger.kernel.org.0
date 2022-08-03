Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0DE1588EEF
	for <lists+stable@lfdr.de>; Wed,  3 Aug 2022 16:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbiHCOuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 10:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236284AbiHCOui (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 10:50:38 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE29B0A
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 07:50:37 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 273AwRKK012049;
        Wed, 3 Aug 2022 14:50:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=cCVD1m12sSdX1dSL6IJiUR10uC/+82WQYxQIRL8SmpI=;
 b=dg4UTTqKSSqaxWsBa5bsyuwLr59RHd8gY2rS9IwwJRJ5FKs4V92peUrptv/eOQ1sq9PN
 yavnNp+9UXnanYG/6kr3ak4vWgaFU+P6Ce9h/P49F0Obi0zBiikaLtYTz7OSXqHQE+Iw
 3ZyXkfuu0D26G7tpOPGKtaiAsHy0l59KAHUxsRuzMgMaqPlo10LGJDaxMHvfXb5B2aQn
 3ISbi3Llm/P9ewX8rNHRkTdZLUjjQxVQ+LNVUlEXv9rD5HdoHfrJQmNwjVXhKWWqp8oU
 KlTCgBLLUg9AvxrGJbSXl4052Dc4VHHkkQTP/A5RgrDIGu17zx96SAgAqwYJB9Uo1bi2 Cg== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hqdbvrhkt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Aug 2022 14:50:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9+65ku+ZtxCtC4mAxDGWg3qKKC7/z3ts2UTMlig/0uJEVDjufEZgJlzc3p/ZcIs5xWuRa/m8D/0Jh318QbCvXtf+adBqqX6Ig017pQWJJBty8atxEnUWpILjGWbvoE7GzOi0tf30sYfmbWb1OoT4Fg/ohiQ55ozvb617QQQwdFWrNM34XpvngXwH9/4XNBmN07RmNKazS2ovGebdoQNlz9ZmJTIAKkAHif3nKpIJizs8ajl+FNw/+uDE3qPMLk+CG9O/iO4hjrO0ZSJAjACa5/+3LTsBIsZP1l4aw/rqWeh93GbAnr7jGYnBlwedQgnook9QtvrAgTPqrKRRj1FAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cCVD1m12sSdX1dSL6IJiUR10uC/+82WQYxQIRL8SmpI=;
 b=m3imYgMFEyWWZvzcbDI0f21aH9YMC6Cz8EyeP33wTAGb0Ocqk2DlBlFwAK+0Mj8cbPTlO2Vv5E3Wws6yo1g09iZV1WLetP7Jsz4Bjug+0i4COW7Qq5TB3ayz/3k3yU1VZugIGvGC4GnqDAQgas6Kwt7mXQ1aZe3hed8cvEEbtFIbCFw4F1x9WPFawFzCCWiJhLe2wTrp5WTZLUmU9gYcuMG49NyX1Mno5VSlyBBQ96ByBXlewqIzhqTP25kygBEoXz1XV4LcC/s7xsTwlxvvZG4K6h2mB2lVx/HplXFmKaTgYfM4hl2+oigUmKtopCEqlH44sCME7T7NV6VTdIxsvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CH0PR11MB5505.namprd11.prod.outlook.com (2603:10b6:610:d4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Wed, 3 Aug
 2022 14:50:25 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b%9]) with mapi id 15.20.5482.016; Wed, 3 Aug 2022
 14:50:25 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 3/5] bpf: Test_verifier, #70 error message updates for 32-bit right shift
Date:   Wed,  3 Aug 2022 17:50:03 +0300
Message-Id: <20220803145005.2385039-4-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220803145005.2385039-1-ovidiu.panait@windriver.com>
References: <20220803145005.2385039-1-ovidiu.panait@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0250.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::23) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66cc0d51-32e5-41c6-714e-08da755f7fa2
X-MS-TrafficTypeDiagnostic: CH0PR11MB5505:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JxyH5gqH+4s0x75ffRpyLdp8aSkkrwVGWpuSdEIxN218Ty8tcF/+KPEyl5395mn8dgxhFpjpstSoCdJfZUSlma7FbT491CwULa8jUQgKsrSFoh7WSxlDpeInZ0CeKX9jAagp3aWuXSdo1IAnjquNbdhuqpfNGm1wmBLVXWGfcdTwh6Iq9rOvS+jsSzqZMYT38Znn+tj/dLtKHi3ajwJ7hisytEpAEhpa2x11RxN87B4iqB0tmXsCy9C+R/5dd91asHC7Kimj1vSD56Q64nP3yTd4WQ/o8nfbfaNBaDpKpG+Mpv8AZQSzdj80IDbT1Z4GB0zR8xwqtKr+1EZlhdYwqwL8R6pnQzdU3knoKQ1NVYU/DGq7hDIaq7LxRMkCM8m9DziOWtdSF2fLGul9lwPE2AyLpT7epF8/zfPsZyFZtSuobT3dBCf/moKQMzzT3GS1iArVijaSnmmIlB+wRnfXLwO+nEsf8nyALuh1mNrT13OGb7ydpAATJPergaX3cZCAUACeJH6ia6Ox2sazcoCGDJ8VHNRfzrJuaJc04m8GcLEBP+YBFymEOZ0W2+UBG6NPR/Ifu731Vg0mHvvMOPQXO4Rcw2MLMkPJecPw0T/NiyhhtIv1QR0adCWpph66E3QXNj3IUh3t6KKOQXzvdQduJQfWHdoO4AgB9yUYOgEfakmH//WcK1yIbpaxYzjqkbxQjI7HZqwOI4o2D8tNLqPSsJyC7O3et3Fh9fKU97HvhFkS9nG6QeirmWXYNrGdFCf3jZsfJheu1SyL4TggdoOXKEbESHPIzUKCkuNTuj+RsmcKK/mzl/7xzXF4r3Ad22o5D14HH+iKczTOsATjXiJuUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39850400004)(376002)(346002)(396003)(366004)(107886003)(2616005)(1076003)(15650500001)(2906002)(6666004)(83380400001)(186003)(5660300002)(36756003)(44832011)(6506007)(52116002)(41300700001)(6512007)(26005)(86362001)(966005)(6486002)(478600001)(54906003)(6916009)(316002)(38350700002)(38100700002)(4326008)(66476007)(8936002)(8676002)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GImEZcjk4B18D7uyhotuRXC2IlDRG+hpS+sVect6Z58YleZ+8ZwSE9tEU/rY?=
 =?us-ascii?Q?WauLBIduZzhOpMgAEAjN3orEigyOaf2pxEiS5ljBjZk4YWRLBAaWfv0rzlHO?=
 =?us-ascii?Q?QYNRKvjbgedJVTHa4kXTLF2rgWyBSgeKHE9aYGnlCZM02liNcUJxYd9xl9+S?=
 =?us-ascii?Q?ynWpCTVuL0Ba3duE6a32Y9P4zLcCCnluK9sv28IIHxpgaMviPh0YeShSBQwA?=
 =?us-ascii?Q?aliu43nwKxs59nOwWFoRH3sIcMIgphKEh4QR6UYzv7Xu7bI17r5zlWiDoz/g?=
 =?us-ascii?Q?1Sw96uPe+Lk002DegnVv5O9ypLgPdNZQDeDC6NQ77jEciwXoJceQr/gsPGUo?=
 =?us-ascii?Q?dvOAo4ZzzRSQ1fIfQUMbWeaJX60FHrfAS9Aomc+GWoOTbNC6PvN3u70qxfnD?=
 =?us-ascii?Q?bpR8mVKITIOEnvyScY6p9MDCexWSKGJ1hWzNN+IF4E3MSS8gaqC7+3zyyD1r?=
 =?us-ascii?Q?qQWhp9XvfHUTN2qOwaZm31wEd639wvXGJVIuBMweosEXu1TecvyohUh/q1q+?=
 =?us-ascii?Q?GKudaHEiIcF0qDPE325AGasr5pOGQyeUcY9CGKRXIEQsQzlym/UxbcoP4P9s?=
 =?us-ascii?Q?fSvUmlGTevKMk3IwJAeFafKeoCgCU9z0utrYpDmk27VssWcc2EypR2nO9hlg?=
 =?us-ascii?Q?UjuGriKRvEv75mwuQtenju3upFBsa6U43ozn6eH/MMtgIfEDiujq8TB7O4RF?=
 =?us-ascii?Q?sFVJNFZ3jFk/bngY+PycLxGdqTDDT0HGPktBw/BfPFyaLsIZ85LI2aklYf3a?=
 =?us-ascii?Q?OEzAFCX3b28Um+CD8J77HdbzPL2GU2OhUzOQaGfOSYUUa95YegCGA0YmmPBg?=
 =?us-ascii?Q?Fd5soYQO3oBg06brndkvtV/NITH/+BwpL6o1W/V2Am0p4+Rt+CobNivLxJ+n?=
 =?us-ascii?Q?dv1k3vb2yWxIRSeqMcWYB67h1BH0nv3OG4qyTwC2ZpNvtSpvZjRBdPIs0vOl?=
 =?us-ascii?Q?bRMUBTkexjCpRWWxomIcW+2AtjblChTPwaY/k9qMtCsqkSaygM8sBVhkw/Cj?=
 =?us-ascii?Q?Jln31iMa4+12fN76DAqQURfOa4MlXgoS0ZhCM5XkKuDkCKaMlKbCsSOkOjG7?=
 =?us-ascii?Q?qr95SWrbpla7QEG3r5XXymtpkg0G1fzsxl8HOoVMsfFbj6QHm8TZJUIcqBMz?=
 =?us-ascii?Q?O47rm/l1wJTKye8XkjtYh1Ar3Kt5KymGVqrXeR8slXu5SYTwdOFBC1Lcyd91?=
 =?us-ascii?Q?kXrtr/U1DXZ/ODkVeIN0oGJK0SSPxrxf/gsvbgL/LOqGbesZj2zi4qfHIlT9?=
 =?us-ascii?Q?jAieSB7So4Eknuax/S7SBsjFqhoRAZXnvioGVRQ8WqoHee8gK6lYxxcPTXmO?=
 =?us-ascii?Q?lHue0d46S1n9hnR9R1KDaiAJ7ij1hr0p9VL1AsWTxqgImrH8XR+f4Pmq+Ess?=
 =?us-ascii?Q?OwBza6TGt4HLAfhUnzgkLiMzSPo5vMm2CLhxeMJ/AmCxYRv6YPX7jIhJUnKC?=
 =?us-ascii?Q?8lwFXcgMZOatozBWWTNsaExbQhn66ix8KZ0hKh9FTc9zNBHfxejKdBm5o/bM?=
 =?us-ascii?Q?02rmT3UmoOyTkPbIAnBjuWnOR/Xdh1IJZMvKEADb092qZQHZV3S88WI9Ndb0?=
 =?us-ascii?Q?NvOO6I8lL4Mb87SK15Kj9wV9ouc5zKXz0CV6fhhTLnn6Vg/R+hEqyp57ODVp?=
 =?us-ascii?Q?sw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66cc0d51-32e5-41c6-714e-08da755f7fa2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2022 14:50:25.2072
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KJxIA3YudzbfCrlyCEU/uHQtw3XV7GHQVqirwu2uhHDhL3B5j8xa7/tyCrE/LRN5kvCkAKL9wsl29zCAroRvMcyVs8EAGuzOkLiSCcWxyRk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5505
X-Proofpoint-ORIG-GUID: D1SxzSs1vJAiqasSXEcUbwg2dEV1yfZ4
X-Proofpoint-GUID: D1SxzSs1vJAiqasSXEcUbwg2dEV1yfZ4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-03_03,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=659
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208030066
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit aa131ed44ae1d76637f0dbec33cfcf9115af9bc3 upstream.

After changes to add update_reg_bounds after ALU ops and adding ALU32
bounds tracking the error message is changed in the 32-bit right shift
tests.

Test "#70/u bounds check after 32-bit right shift with 64-bit input FAIL"
now fails with,

Unexpected error message!
	EXP: R0 invalid mem access
	RES: func#0 @0

7: (b7) r1 = 2
8: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0) R1_w=invP2 R10=fp0 fp-8_w=mmmmmmmm
8: (67) r1 <<= 31
9: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0) R1_w=invP4294967296 R10=fp0 fp-8_w=mmmmmmmm
9: (74) w1 >>= 31
10: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0) R1_w=invP0 R10=fp0 fp-8_w=mmmmmmmm
10: (14) w1 -= 2
11: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0) R1_w=invP4294967294 R10=fp0 fp-8_w=mmmmmmmm
11: (0f) r0 += r1
math between map_value pointer and 4294967294 is not allowed

And test "#70/p bounds check after 32-bit right shift with 64-bit input
FAIL" now fails with,

Unexpected error message!
	EXP: R0 invalid mem access
	RES: func#0 @0

7: (b7) r1 = 2
8: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0) R1_w=inv2 R10=fp0 fp-8_w=mmmmmmmm
8: (67) r1 <<= 31
9: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0) R1_w=inv4294967296 R10=fp0 fp-8_w=mmmmmmmm
9: (74) w1 >>= 31
10: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0) R1_w=inv0 R10=fp0 fp-8_w=mmmmmmmm
10: (14) w1 -= 2
11: R0_w=map_value(id=0,off=0,ks=8,vs=8,imm=0) R1_w=inv4294967294 R10=fp0 fp-8_w=mmmmmmmm
11: (0f) r0 += r1
last_idx 11 first_idx 0
regs=2 stack=0 before 10: (14) w1 -= 2
regs=2 stack=0 before 9: (74) w1 >>= 31
regs=2 stack=0 before 8: (67) r1 <<= 31
regs=2 stack=0 before 7: (b7) r1 = 2
math between map_value pointer and 4294967294 is not allowed

Before this series we did not trip the "math between map_value pointer..."
error because check_reg_sane_offset is never called in
adjust_ptr_min_max_vals(). Instead we have a register state that looks
like this at line 11*,

11: R0_w=map_value(id=0,off=0,ks=8,vs=8,
                   smin_value=0,smax_value=0,
                   umin_value=0,umax_value=0,
                   var_off=(0x0; 0x0))
    R1_w=invP(id=0,
              smin_value=0,smax_value=4294967295,
              umin_value=0,umax_value=4294967295,
              var_off=(0xfffffffe; 0x0))
    R10=fp(id=0,off=0,
           smin_value=0,smax_value=0,
           umin_value=0,umax_value=0,
           var_off=(0x0; 0x0)) fp-8_w=mmmmmmmm
11: (0f) r0 += r1

In R1 'smin_val != smax_val' yet we have a tnum_const as seen
by 'var_off(0xfffffffe; 0x0))' with a 0x0 mask. So we hit this check
in adjust_ptr_min_max_vals()

 if ((known && (smin_val != smax_val || umin_val != umax_val)) ||
      smin_val > smax_val || umin_val > umax_val) {
       /* Taint dst register if offset had invalid bounds derived from
        * e.g. dead branches.
        */
       __mark_reg_unknown(env, dst_reg);
       return 0;
 }

So we don't throw an error here and instead only throw an error
later in the verification when the memory access is made.

The root cause in verifier without alu32 bounds tracking is having
'umin_value = 0' and 'umax_value = U64_MAX' from BPF_SUB which we set
when 'umin_value < umax_val' here,

 if (dst_reg->umin_value < umax_val) {
    /* Overflow possible, we know nothing */
    dst_reg->umin_value = 0;
    dst_reg->umax_value = U64_MAX;
 } else { ...}

Later in adjust_calar_min_max_vals we previously did a
coerce_reg_to_size() which will clamp the U64_MAX to U32_MAX by
truncating to 32bits. But either way without a call to update_reg_bounds
the less precise bounds tracking will fall out of the alu op
verification.

After latest changes we now exit adjust_scalar_min_max_vals with the
more precise umin value, due to zero extension propogating bounds from
alu32 bounds into alu64 bounds and then calling update_reg_bounds.
This then causes the verifier to trigger an earlier error and we get
the error in the output above.

This patch updates tests to reflect new error message.

* I have a local patch to print entire verifier state regardless if we
 believe it is a constant so we can get a full picture of the state.
 Usually if tnum_is_const() then bounds are also smin=smax, etc. but
 this is not always true and is a bit subtle. Being able to see these
 states helps understand dataflow imo. Let me know if we want something
 similar upstream.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/158507161475.15666.3061518385241144063.stgit@john-Precision-5820-Tower
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/bpf/verifier/bounds.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/bounds.c b/tools/testing/selftests/bpf/verifier/bounds.c
index 92c02e4a1b62..313b345eddcc 100644
--- a/tools/testing/selftests/bpf/verifier/bounds.c
+++ b/tools/testing/selftests/bpf/verifier/bounds.c
@@ -411,16 +411,14 @@
 	BPF_ALU32_IMM(BPF_RSH, BPF_REG_1, 31),
 	/* r1 = 0xffff'fffe (NOT 0!) */
 	BPF_ALU32_IMM(BPF_SUB, BPF_REG_1, 2),
-	/* computes OOB pointer */
+	/* error on computing OOB pointer */
 	BPF_ALU64_REG(BPF_ADD, BPF_REG_0, BPF_REG_1),
-	/* OOB access */
-	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_0, 0),
 	/* exit */
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 3 },
-	.errstr = "R0 invalid mem access",
+	.errstr = "math between map_value pointer and 4294967294 is not allowed",
 	.result = REJECT,
 },
 {
-- 
2.36.1

