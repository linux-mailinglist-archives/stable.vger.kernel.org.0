Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B21093B3E15
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 09:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhFYH7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 03:59:47 -0400
Received: from mail-bn8nam12on2049.outbound.protection.outlook.com ([40.107.237.49]:41825
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229454AbhFYH7q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Jun 2021 03:59:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=flvy7FDreesEZSxtG0dP5lfbzpaHVQk0F6YeljljebNNgTvlUjNI8c+DlqX2wJ6BLODJ5bNkX1HulaQQB9kDQWd5AmgmQmmQ+0GqDcI8zJrfhLoriPSq0cxbY1UHZ0Hgk9MuLw1dLdGM3lCKsSZAJDniD9xyr1TqMLofvCLjNGayJl//fX+r3/KVYEuUVYD2tIxqOGwnihiAa+BSfCgWVUI0QRUDUslSjARuhrvSHi/mrezVMWqpVKVF9V88I9uhPwadgGZoNzFroEToeQJHq2Z9lEbgPYNoB1oyBf0U+cW/qCQ3EtCXfi8q77h0oAE0aFUhrKJBAZ+sWN/auphSDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/F32mO0WG8EoKDH09o/w5GJ0EjS3ELQuvArvH7EIm0s=;
 b=NZ1dPT09ZI974+18rRzDZ6rdxf2Ova54fQvi1h3KJRq/TozF45oRGRN3OtZo+BXB8XuAMlMLEu5a7pe0Nlqoj3eWqq7+Q1RgJrvIeC2PcJK9R65UTxR3PKFU+UDtzt8QEoPUpZecGZFW/sO+HMYRDtNFAMvm5zN2C6jpIb4tJrHEEOVIAn68iieCaUp3BFNoLBiBCURyL3Y0/6RQyHvwxo3lfeDY5fcifDCyPUyj68E25kWX52YA3FxJDVUbSXniW3dqYbT4U6oxvcZAICl+Kn+YgGnPraEafGwxjcap8HITHvClXL4Pr/EsLFDGea8+XYcAU35gkDF+iCHuwKKenA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/F32mO0WG8EoKDH09o/w5GJ0EjS3ELQuvArvH7EIm0s=;
 b=euE2631MZV6/0tBrt1Cy4Nmfo2qS9yB4+9GO2gsBRNEu9VQHKVSJw+KxzVCElfiF83c8Ha+q/JN8cPLW6Fvz3kClWc9UzTZDzcYIsHEPEx8ZNjqBNE2/lfExWHlGHJarE6YFs/4H9F+/Cuf8Xh+61Qkvmgc5uGOLd9+2UQQAWag=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=synaptics.com;
Received: from BN9PR03MB6058.namprd03.prod.outlook.com (2603:10b6:408:137::15)
 by BN9PR03MB6137.namprd03.prod.outlook.com (2603:10b6:408:11a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Fri, 25 Jun
 2021 07:57:25 +0000
Received: from BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::502a:5487:b3ee:f61c]) by BN9PR03MB6058.namprd03.prod.outlook.com
 ([fe80::502a:5487:b3ee:f61c%3]) with mapi id 15.20.4264.023; Fri, 25 Jun 2021
 07:57:25 +0000
Date:   Fri, 25 Jun 2021 15:48:35 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Nick Desaulniers <ndesaulniers@google.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Alan Modra <amodra@gmail.com>,
        =?UTF-8?B?RsSBbmctcnU=?= =?UTF-8?B?w6wgU8Oybmc=?= 
        <maskray@google.com>, Quentin Perret <qperret@google.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH stable-v5.4 v2 1/2] kbuild: add CONFIG_LD_IS_LLD
Message-ID: <20210625154836.382536b1@xhacker.debian>
In-Reply-To: <20210625154737.3d64a434@xhacker.debian>
References: <20210625154737.3d64a434@xhacker.debian>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.147.44.204]
X-ClientProxiedBy: BYAPR06CA0033.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::46) To BN9PR03MB6058.namprd03.prod.outlook.com
 (2603:10b6:408:137::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (192.147.44.204) by BYAPR06CA0033.namprd06.prod.outlook.com (2603:10b6:a03:d4::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19 via Frontend Transport; Fri, 25 Jun 2021 07:57:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7f00a81d-6b37-4189-a703-08d937aeded9
X-MS-TrafficTypeDiagnostic: BN9PR03MB6137:
X-Microsoft-Antispam-PRVS: <BN9PR03MB6137ADBBD10E3A2076FE6389ED069@BN9PR03MB6137.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:118;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ithze1DRX7HpvwTv1ZqYH+AUMg79xSLCMS50T0XNb+APfwqhiHa/YmeC2AYX/KAhDgprbA555xIKuMXS3ZhDdk4OBk44Ig7l1QJyv1rPEcr4IbcXUZksGipuTpyNhuvL2XCF4dTu76dQTC++3WDu8TwsLCoLR7/5ZCjGAyliI7fO1Tx3XdVEBa2oy5g3XLsFSmotMZVb55XPnA5Yq/00eUZYODgrSK49LunMJhCsgdMeGZgF4LSY/BLbCB8x2thPQIMS2i93x4Lg1fTIHNCBxsa4sKIQ7dHAvmAf77EUIEhp/Ir0QdR4awy3xU3w1xdsLgb+VBP2CrjN8MbgecGeyEjp9JfkGiARPEPyvojOVP8J40qROkiq6QmJhMjOBsfZ9twY03MJVUIyMW+BNiYCVT8QFxmPfM0agVZkVsXWD/f1NGCtKm0vOgEOddtQ6UAyN9GgT0U48Y8r6bkAX1hHpusB7F5apiizE6npY2USQwHyaxRP1fw2ky4HesVMTDYqXubyS2Sp8nUIm6hLCy88I2oXad3Ptbqot8V8QDMwzs7x3ywKxDgFBGP8gDKuTGwcHtZw+uAt41nFQmd7Mi8T8gxk559clPVH196G9DhIhRDg6FnfBkrzSovEJeV11urAwLrZU6tuPL8vSKmS1atvaPjzp8UQghniXDRH47lxxKiV/NQzTE/kA2OEVgQv3IPbqpXPUOeom6c8Vhf/Jim2Ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR03MB6058.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(366004)(396003)(39850400004)(376002)(52116002)(2906002)(186003)(66946007)(316002)(6666004)(66476007)(8936002)(66556008)(7696005)(26005)(478600001)(55016002)(5660300002)(16526019)(9686003)(110136005)(7416002)(1076003)(54906003)(86362001)(6506007)(8676002)(38350700002)(38100700002)(956004)(4326008)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jBxgSsDahX9cMBluyUGUgonoioPdV+WLtkxILQ+3jXv6Nu1YJA1FF6zUK+Bb?=
 =?us-ascii?Q?NH5rfq44YLS1poTTeOsqZsKeWMd8ivr2RLk+3wA9vOo627oPSG4UKqFa6Rxh?=
 =?us-ascii?Q?vctkzpXRP5HsEcEWqx/MdH2tD2mntwD3cHzx28Vecg4mv/iKhoLxsDTMAR5e?=
 =?us-ascii?Q?YLuxmB+T/Qyf+FNgJutXH8ulKiErdJS2WBtZnOX/96V2bE8Qpm2qGHD1mij+?=
 =?us-ascii?Q?xqa7pjdGphclPVx2OfvhtrFQiY2elIwXpX+h2ObjlegZ2sO7TR1Tx81R2Noj?=
 =?us-ascii?Q?vXHs8TF6F84IP8ngExCQSITmHhclVKYIVl9/2IwMJNRtdNoftTL3wu+O5P9O?=
 =?us-ascii?Q?TSZ7uSi0x+hxvfnnQWKEBhyo0i8oyXIfEckpy7wjyo7P8+OpPu/Cu5NZ5jEg?=
 =?us-ascii?Q?Cg5VEZoll3pSMo6wUZtXZkMiUWiRsbZEOS52nNgolxwQMXsI2sKCzprKDmXY?=
 =?us-ascii?Q?1ezcmzJqGmr7Ng4erNdf+JXW+kY4U4/F0cpuK6RrZR7a08Gd4Tw9jjNhK7SX?=
 =?us-ascii?Q?5CpV3HlAGsdA3UAAjik5GzS3MnOPJ03gKYt4Ke5b0scByrcbinhxSqtW7Lmy?=
 =?us-ascii?Q?+oOIDMEuMVXbHHrUuux2OFJvrTrD5ll+eJugLDGWnFPmkT/55tJ8t+mCz6Hn?=
 =?us-ascii?Q?9il6cMuFjWiFAiWH2sLpWOBbRE2VIO6C6jeUcB3X+lt9dGj0a71D03DdYzvz?=
 =?us-ascii?Q?yES26hHvV2NseLgQDNrdMPjK8krDNN/W784i3iMI3mLtJPfAlLzEUZbUPDMg?=
 =?us-ascii?Q?fXzFC4lYF1Co2jRixOUeRaYW+UXlzQ7hnENAPtSBYgCS0IwxKHc5x9QqPKoF?=
 =?us-ascii?Q?vtEiKvNVCm1P2dg5idbv3FMXA4YExdyIP79CzUFJrXKZfR8ufPWtrimbPKhq?=
 =?us-ascii?Q?rBujHwv+ZUoLFS9GOTfSOkJstSKWMGYV0oo5H8YnPY+u5nPwrQoG/6nc13Nn?=
 =?us-ascii?Q?ujZ3M9xA0XHg0e7p53gdgy+5lb79PM56btGq/5H5w9aPb4kHvkkzYzdIxNzK?=
 =?us-ascii?Q?kt299HK+WRTuhmKfD295O9XHDsegyAQ2KiWd2v8TjaSuO58VN0YzOmXe3lVL?=
 =?us-ascii?Q?PE7Pw2/ihpngsVU/NxmkqqWTYqK6kEcPA0lRpPMJNrmCY6GdIUzLyGWLh5eR?=
 =?us-ascii?Q?iC/iooJIQNHquNqPs+IbExsqE8pnumg9pWyd7Ak4OPyWQYnNcN/uMrDZ0jLg?=
 =?us-ascii?Q?9yI7Hx9OnnSOrlVjUJOidNcGMPVz8yXKnAmFzcv1fuV3K69IVP41GlycJIM2?=
 =?us-ascii?Q?eUnqn4dJUtOcIjiGAejTGnaRaT4suT+hnkTLaPzVt67ytJZsTSn2GozqVhgw?=
 =?us-ascii?Q?nmfZ0pAC1osgndRKhLwfE8vE?=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f00a81d-6b37-4189-a703-08d937aeded9
X-MS-Exchange-CrossTenant-AuthSource: BN9PR03MB6058.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 07:57:25.3424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B5/GZO3BfS9GrFJl55pN0kiPh5YnTCakNndYg9cKWCNzSXcAcHwjh776x8XBGrki2dTj0USAl3eODJMmowEdrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR03MB6137
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sami Tolvanen <samitolvanen@google.com>

commit b744b43f79cc758127042e71f9ad7b1afda30f84 upstream.

Similarly to the CC_IS_CLANG config, add LD_IS_LLD to avoid GNU ld
specific logic such as ld-version or ld-ifversion and gain the
ability to select potential features that depend on the linker at
configuration time such as LTO.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Masahiro Yamada <masahiroy@kernel.org>
[nc: Reword commit message]
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Reviewed-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 init/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index 4f9fd78e2200..f23e90d9935f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -20,6 +20,9 @@ config GCC_VERSION
 config CC_IS_CLANG
 	def_bool $(success,$(CC) --version | head -n 1 | grep -q clang)
 
+config LD_IS_LLD
+	def_bool $(success,$(LD) -v | head -n 1 | grep -q LLD)
+
 config CLANG_VERSION
 	int
 	default $(shell,$(srctree)/scripts/clang-version.sh $(CC))
-- 
2.32.0

