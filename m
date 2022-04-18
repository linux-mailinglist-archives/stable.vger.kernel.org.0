Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A44505ED3
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 22:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbiDRUL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 16:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231805AbiDRUL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 16:11:56 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8962E0AB;
        Mon, 18 Apr 2022 13:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1650312554; x=1681848554;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=yhFDXspCVXCb5F4JI7NnpbnrX8FzaSIthfXgw7wdyZI=;
  b=fNV9LvGCkERJQ33xvXEdreW3EVP08gPv+KnzZ+bROPAToLhmAEZgJycQ
   qLW5zMI32pQpYXgLhmBS5OGkyyhU4O0uNBP6GwD45peFSyn3FUCULhLCn
   Y3lxcoa+GA6oy7YzFnEmVeMRzCKKV15jzJ3/X9gJU8KqRp+/78EQKmek6
   QmF3Y+lNRvAHghEdtgfI1GXxGoiKu34vjuV8CfezoxTyChBxikqAtMsAh
   JuES2kc50bIm/NF4tt6nXVoHJoSG5FFRXSqyk2AGL0lEv0VsODeofjh9w
   l1CLqgW75mRpwDI/oNc7pznws87tE7lFAkhiYslrZVN+SL6FWgrO97q/1
   A==;
X-IronPort-AV: E=Sophos;i="5.90,270,1643644800"; 
   d="scan'208";a="198197451"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 19 Apr 2022 04:09:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KhBiGt6y9tSazMFpfVHEtnuRaP0uyUecx5M+hJ/ljKvpDw9XYFWlPTBbgSbYXICWqLSNBLEBhGaz1uOhvcwDkum8j5NvPPRpn8z/2eeEBNHQwhgTiorjQBY13xpz5igvRY0CHZAE3oDHRg7CwjuElPfzJDFx1QwVKMuPdu3w+ty0aqFDhiffP0XJ2rd0u3bWc240C3FDiqxXYrIxeUzY9ctq3iH/ai3pOwzg1g1ijVTnCJjwYu7g7ue4643LEoCJJvw7Tdyz0XDnBW8v88EQOWWar7urVxLqADXGVrjzSYRv0f4BckwJlSoboamjgmEehl7HBg+5h/BCkdD5HstgVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HWdpgzDlX9Xj8rx8GPoMj6NCBBTnvqXrYvvH2rZoi3E=;
 b=GnCWJSTc1ie/u9LSdxwsI2NE9CEkeGW5AF9luazNCpe8BMFGlu1YgueABRz5EG5polRA1WkEvJ3clph4FJD5kRcW9MpieoeMbzE4TsBu5TEfSaZLmjGAJprBf6N6DIm1EGATdsySCCixJgnwy8IN0hUqFYvapWmjRI4x3+zkWPRCyso+T7PBlN0BPKap4lJoxkiDK75Tbz0gXBwN8fqQIi1EwJLUZIjWT0mkrTMACl3q8v5q3N8kZZm+QaFFXY3htMq43MQW61q6njICFsy1swESfPR7UJPhmiRjvunissum5CJuRoNJDW9wOO7yJCnUvlL75xqqlXHcMbSDKpoN5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HWdpgzDlX9Xj8rx8GPoMj6NCBBTnvqXrYvvH2rZoi3E=;
 b=lFCjHrBEdfG8EG8cM+vYyU4fpvXcqkNwEa25t0XThW2JI1VDEi7BVHMjIbng5TEDTNFkFdlqFTSQiUDmrufcIjKPLADcpB6U1y0TI+gfpA99fn5I0aZ8/AynRxvFb+Q1N6ObY34G6BStcMBDEv+RHjKJnObDTmvFT2Prn78RGiE=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by MN2PR04MB7022.namprd04.prod.outlook.com (2603:10b6:208:1eb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Mon, 18 Apr
 2022 20:09:12 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::995b:363e:8d1c:49af]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::995b:363e:8d1c:49af%8]) with mapi id 15.20.5164.025; Mon, 18 Apr 2022
 20:09:12 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>
CC:     Greg Ungerer <gerg@linux-m68k.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        kernel test robot <lkp@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] binfmt_flat: fix sparse annotation ordering
Thread-Topic: [PATCH] binfmt_flat: fix sparse annotation ordering
Thread-Index: AQHYU2ArT/6GP/7pQEy2Uc+2aJ024w==
Date:   Mon, 18 Apr 2022 20:09:12 +0000
Message-ID: <20220418200834.1501454-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.35.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7a934cc-be16-45a8-b2a3-08da21774e76
x-ms-traffictypediagnostic: MN2PR04MB7022:EE_
x-microsoft-antispam-prvs: <MN2PR04MB702273A1028C56A1374DD498F2F39@MN2PR04MB7022.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cI4j8GQfMqevLBxbiOVJFCHc3P7Okd9cGjm2uOhJnZ+JLTmIh32wlIVi3/d+m4/UYFupYUvUoJM/aN81Zpa+popc8J2MD9GC7cX2NAdYchkFatENe/a2vxzattTLJpELrAs/cQI4kSaDp57GBcBHpd0OhXryWKFfjETWGOuQgTGYEpCVTsj+0BP8E4OUB0jUBoQbrHD8a9z2JFQaKweclRyL+pPiloGfuPBiGWUmnhopAgI8SgRlQKNJmI5gWcs3kHfnWmywFfwpTL/W6pplWQpqpvqojKiWCWbd6d29wjJW2RmPrVDNivw2/N+oNM2NYjcMTkscf79+c5iUgm5kuIGY9HipyPoC5qFLLwB6jvdQlpAJ+MPopIg50IVGJ2lnebYH8rvhjfJjTbxSOJOMkvIskUQL2+DFxPNyEcVz7WX0GRRuq63CWaMj1p63HbrNYLQMtfUEF1qimB9nGz7OoHOQdLyaGn/aunvwmT+rN12x/xQAh0gOCA8P7iXNfRmxP0TsZaGp6lAAt5mIeWWk05ZLLUdWsMQu4Bq4hvWejH1TJlcUVpoP8w+l4MN6xhN8ltBLBLp+sNojOujTifw5vsmEf/tMkRPsYujTms3zAIvXThAW7fUrhGhirpXc16b4HxKvBnFazTVc1hTfTTMKtfuUxV0UQ6m3rDjRJmlnayukvR6IJfdFcvSIHQup8CR3xoZXU3Xd6gP6iaKEIZJY2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(66556008)(1076003)(186003)(6506007)(2616005)(64756008)(82960400001)(91956017)(66446008)(8676002)(4326008)(38100700002)(5660300002)(36756003)(122000001)(2906002)(86362001)(54906003)(316002)(71200400001)(38070700005)(6512007)(26005)(66946007)(66476007)(6486002)(8936002)(76116006)(508600001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?wzs6FxtnNYxqERRog1/Fzx6e/HozBPQfhNyElIO9m/Ej1xhXVxS1ILSkMs?=
 =?iso-8859-1?Q?g5qiximkv/PfYdfaW25AVqORnRBYJvo2lBwMAlrFfAlXkelovHwRvg1AB9?=
 =?iso-8859-1?Q?RWKGSe+QYhlj3utAZ1N0TmJ6uh/MuVsZG4/9ZibxSx6voK1N03e4qxRK9Q?=
 =?iso-8859-1?Q?cYKBeiZDF+Ue6kT0vw4MNNJCfJ9H3TP92Y6NBHQqE7gJYSiFx9F54L0Ok5?=
 =?iso-8859-1?Q?VohPfVms6eEA5k7G+WA1fGLk2BpI4krrNXXVZvC9F7zoAVYxM0eM75vvvR?=
 =?iso-8859-1?Q?WAk+fC286RR+loHZAAmTLWsoq8EKT8+K+lt2y/79kR3H6SlFE+LPXrvAGk?=
 =?iso-8859-1?Q?5N92+iL2Uy+BJJ1rw7JqE/rHUhkA9HjDUtzWkYJkPb5QQIlZY+aHNDjwJp?=
 =?iso-8859-1?Q?mZ//BAhmjsJ3Ghq3ZziuTs1Uj2fzRjAn5ZeMBxrm4PE9/IfmCn/syH3jPn?=
 =?iso-8859-1?Q?9JpZGUE8swhqSzN8x32wYwW8IqtEB4vAgP53D3+vyn3HQKMqnP7sWWbwzn?=
 =?iso-8859-1?Q?8gjIgKsfoCNRQbBMeBTBZB7WwG844YReDJPJoUD2daLEl1NvdZrGrDg43g?=
 =?iso-8859-1?Q?0jX0EWcBIKXWg2cqDfNZ7BE/LIwvdhVqG+RASkFSYYZr4fjjlVtsSaDygK?=
 =?iso-8859-1?Q?uIiYfI+oOKC5updPWd3ZsbLl8I1C3fvmKOnaUi4r+G6rrtkhX702LRJ4OB?=
 =?iso-8859-1?Q?45CeWMrd+AgyZewPDiQpnAyFXX/8e0q92TA9xUaw6nwXw0k5qdi47ebJ9c?=
 =?iso-8859-1?Q?HGGH6e0lGLLKQUz8Ge/GT81WXqJ0tbdLiw13yAr5XhpoN4hU9BnEnks8sp?=
 =?iso-8859-1?Q?QjXlE8SNEpx/Ic7g+6JHWcnvSkebPcVJjFgRaBzKVjD44/obdtDhHdAKY6?=
 =?iso-8859-1?Q?c/X6cQO7/HojReVzeLEer79qkptBZF7B26kI1zkUlAw/bqaatZdxvulFib?=
 =?iso-8859-1?Q?J7E7R9DVHsTcd0sbbSICDGivv4peYRtsAUviiAlcdwm2RuO8KX/kvvOXbf?=
 =?iso-8859-1?Q?93HG5P5wUOd2h7RlszQPSvKinv6ctLQiIhjDqC6mITAqxA+dvuVqfDSplU?=
 =?iso-8859-1?Q?2Ck1/viIPEBM4i+fR0to9nB25gp6SQIq3fWyaJs4jz72HfEdT0l9owGoGc?=
 =?iso-8859-1?Q?m75R4BBEH6E0QQV0ggMqUR5sDnMCEMlsIAO+8/Ngp2IaBy4eE8Lx9dijL9?=
 =?iso-8859-1?Q?TmnNQEMgFxF+FrAxK6BU3iyqhMd6+Frxa2kQwPdI/RsW1YguzHb2LKHJPs?=
 =?iso-8859-1?Q?JdD+o3yBm61wEr6AZZ6SFR7lta97XULZPNUwKvh876V6Q9jooyqKkDUyEe?=
 =?iso-8859-1?Q?vn9F4fEs9DpSene4QFSK+BUbYcx8j167oe0E0p+0xBUJSzpvC4KrEwzNCS?=
 =?iso-8859-1?Q?tbKvZN3uDZbWbuoIwWN/hQ87JnVCluWs9FfNfJIf4vuSDUSqsVyDIQ3UoD?=
 =?iso-8859-1?Q?5c6D2Z9YMvRjQYZuYHY5JySiQiUo3TTbPyrL7nBfYVTvNvw1qNjxB5NOEM?=
 =?iso-8859-1?Q?gl4SrJxFbqxUX6THrKiZwRseuJnhtgM6JPzWmphaVc/8eXSs5UzbpTEntc?=
 =?iso-8859-1?Q?6Y4gSKb4juIPjfhPPT/FQzgDSdaXw6U9Z+4qVQ/nsszMqBMOI7SC/Qsu3K?=
 =?iso-8859-1?Q?9RMwAOJVQN9wyyKRurIdi991t9FBbAA2lu4ljFbBBfgshTnSKVgXki7ioE?=
 =?iso-8859-1?Q?KCnxy5Wz7xndzIRKD6y1KYiixxFJGqe18wreSN2hrfsT4M5Bpmt8jgNn/p?=
 =?iso-8859-1?Q?54rDFy9oj/fjsShTSGqkT3fA/t//jL1t1vCkviRrbU/Gs6jubpeasOrFHf?=
 =?iso-8859-1?Q?xvlYfeZYpXQa+zMaYhalrYezTlMJCec=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7a934cc-be16-45a8-b2a3-08da21774e76
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2022 20:09:12.6154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sqvYWR3G/Z3PnSplhd/2XowTy69ZLxPohVnhLcRSTVcuftBUUuRtk8TN8lAxdahhFHgvTER+GoVrBkBaD+tqcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7022
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

The sparse annotation ordering inside the function call is swapped.

Fix the ordering so that we silence the following sparse warnings:
fs/binfmt_flat.c:816:39: warning: incorrect type in argument 1 (different a=
ddress spaces)
fs/binfmt_flat.c:816:39:    expected unsigned int [noderef] [usertype] __us=
er *rp
fs/binfmt_flat.c:816:39:    got unsigned int [usertype] *[noderef] __user

No functional change as sparse annotations are ignored by the compiler.

Fixes: a767e6fd68d2 ("binfmt_flat: do not stop relocating GOT entries prema=
turely on riscv")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Cc: <stable@vger.kernel.org>
---
Hello Kees,

Sorry about this.
Feel free to squash it with the existing patch if you so like.

 fs/binfmt_flat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index e5e2a03b39c1..dca0b6875f9c 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -813,7 +813,7 @@ static int load_flat_file(struct linux_binprm *bprm,
 	 * image.
 	 */
 	if (flags & FLAT_FLAG_GOTPIC) {
-		rp =3D skip_got_header((u32 * __user) datapos);
+		rp =3D skip_got_header((u32 __user *) datapos);
 		for (; ; rp++) {
 			u32 addr, rp_val;
 			if (get_user(rp_val, rp))
--=20
2.35.1
