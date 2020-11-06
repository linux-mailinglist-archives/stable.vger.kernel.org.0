Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5044C2A90C4
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 08:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726027AbgKFHy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Nov 2020 02:54:28 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:50903 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgKFHy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Nov 2020 02:54:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604649267; x=1636185267;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=+MOkP8J8/wRehLFzT93PZC7fjDf6InpvzJAS3fvbkJA=;
  b=qsTLvRymkzJfsJ/j9Yd62mpPsOKK1Wu2fTXKjY4qgQWy6yuZCaZ8ZVJW
   A+Nb5aatrk9qgs0MyytgDv1TIgiFa9D3yQ98t4vzcK9DNSiVJLuH3kL0N
   nOf+FXt5Zk/fEvkKW1Tz3C+Az+ddOX4Y7MEfGu5cXjP8AkHKFHCgwgTfT
   nif/+HO7lsFrtfsCpLV37uJjJgbRY2Kp00y+Nji9X/WfvKxTATDRuY/xG
   z5+XXY9jPvN3bMxbU2vP+FeKHWynEvHIPXbBl3yYvY5REztEIFbTSLUhC
   /ys4gD2gDjcYhE68hoCrBhqGbH84e//mo/wil5bM7I8Ao3SVj5rX/27wa
   w==;
IronPort-SDR: FVfG/wPz1tazxKcRHVcN1fdjCu3oTGpKWMOh5mmnUDTQSIc04xlrW3bIHrWu93RDh/SP34t92q
 jCk7Fj5Dxf2dD72r6TlO/1m4NjfBPvTbIkuM2luIL8Q/yG+7sEsQrw/7TcPgdba3IxFyEIXe1h
 sP+zVC5oECVd1DqgDAe6dsiuZTplkA8hFJgegjBrQVJnUNe+ZPsDYKp1H9GUjyyHf4lZUhiHvU
 rRC8hE2D7clgomI+IGUtNDI0iBRixh/dikBIcJ4JR0k6gbK3wQc1bh+ArzrBOo3QRpBFJGLgn6
 w2o=
X-IronPort-AV: E=Sophos;i="5.77,455,1596470400"; 
   d="scan'208";a="152117309"
Received: from mail-mw2nam10lp2102.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.102])
  by ob1.hgst.iphmx.com with ESMTP; 06 Nov 2020 15:54:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyjk1lf7Dr/SuTWq+/5YNIQg597i2u3wsYUrip8352nnY5rNRBWAS7aZ1lVZaGPjZ7p3Qab9eZIdClByhy171scb/D2i7NlOpZIqtTAcAj4fr/NhYw4bHvFZZl/SBfhl5aF4AE6YXwJ6YLiRCmNftMJtgTZMxiMwZsnz2MjPTKA8DrFQVmYmi5n4ETjXPnYNEQ2QVcEuWS3pkX8yBg7sP4zHQF+Af0EnuwdF8i+Lk3x0Zsrp4ptrYuPcbiDF/lJJnNauwKWoY9dXQnOmzfYR9UM+Y/Oh8dw7ajHi27RWi848iv+cLYa7RoHgBpY3QbRBJ93vsqO7tL8ChyXFn//2WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=teBxnOcg9xFezrnVu2XPb7iVQc+j1UfNi2JGgoQqDO8=;
 b=ihunovyU1Ndw6PUxfIy5SSFtYmV07MprvOciG/R44BoRRK8cjAjwKCiK8H+/ywSePZo6OvsEGQ+t2DDtNTYmtUS+lZLCoaOBVqK91xOOA7j/ZHKIjd2ivtaOnvVkkki55EkoJFqY2Q36G4R9zBz0eFQLhK7/fxfNqGmCO0iPLWRsNlTdiWHDc5EL/Cb/oE0iNWaYbGzvbiavcDS5WbXh8lhIXYgwrdUHvV8+9Hq2n4ZtK7eJrN1BY9GwdF8hA0DGhXxD7X/91FczdqVJDx6b1VJ5G8fVGFl0hOK/qCrTm023UGezySrQCWMAiGUMq/w4agyFqDba1vzMCm+wh5f4mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=teBxnOcg9xFezrnVu2XPb7iVQc+j1UfNi2JGgoQqDO8=;
 b=X3s50Cm4eibrg/QaLflGIVllamYtMpxrJ4cphZkRHBFN/SYpkKmAsEPz23USJMoT4JHXNm4WKNKLVbf03RdYYIEutUdLZobF1vpxeH78Kex8x+QVM6XK9ihvS07uRFAzHT9E9Rp2Ls2u2NhommCkNU/qY3yCJNw9o8Ts2//LeW8=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB4524.namprd04.prod.outlook.com (2603:10b6:5:21::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Fri, 6 Nov
 2020 07:54:25 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd%6]) with mapi id 15.20.3541.021; Fri, 6 Nov 2020
 07:54:25 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>
Cc:     Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Anup Patel <anup.patel@wdc.com>, stable@vger.kernel.org
Subject: [PATCH] RISC-V: Add missing jump label initialization
Date:   Fri,  6 Nov 2020 13:23:59 +0530
Message-Id: <20201106075359.3401471-1-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.167.36.171]
X-ClientProxiedBy: MAXPR0101CA0010.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::20) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.167.36.171) by MAXPR0101CA0010.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Fri, 6 Nov 2020 07:54:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 575ef81d-3e33-4875-df98-08d882292e20
X-MS-TrafficTypeDiagnostic: DM6PR04MB4524:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB4524764B7079F6EA990A51F88DED0@DM6PR04MB4524.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KjgVoxyKDN/fUEB562Jwoxz7HrOSnqJYQqtOW0+MQH7ArZvBN/kWybY4Gbnmz5K7R8yXpm60W+b/s9UaJGVnK/LPM3teVZa073pkj01Vzcg5M29dGT1f8qkzGkn6axqPKyY7Fy6/cYaxlFl1zq096oCHOX67l0Li8Vk4YNTpeHMDoUP64A0R2T+TgZAZ+d5A2SgLuMvJE13e5hH0kyBHqESUmwve8ZheAc+gpkvVaqtXPIdrWNmCWwE+jmWeIp7IyiweGRdZBBmTfHRyRBpbKrF3xqzU3l+iFdJuVJEakGcmsMwuQvpX8lzKL8K8trq2RjLOiupvwaSLynY8OyvYlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(366004)(346002)(8886007)(66476007)(2616005)(52116002)(5660300002)(1076003)(478600001)(4326008)(4744005)(66556008)(956004)(8936002)(55016002)(26005)(66946007)(8676002)(86362001)(16526019)(7696005)(54906003)(44832011)(316002)(36756003)(186003)(110136005)(2906002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: E0v3nfr5srNUbNxYfgTmAzk/1OkY9t8OzCVsSv+3XAntXf7Lye2aizWZEbX90EPGOpkZEKP58b5gxpw/7KZux6X75UEU1W+2uiYaPUjQ+4JGqapXtQxiogbSqLKZm+M7chG939x0ox5rB3mCRG30/RyqKEfsgHkBxwiCSGv60b9oiBkD58HPBOx3LJIY3i/ogAZklTN8vbjkYxe1vbfODbLIA3GGh8YRJ52KQWODZMvVOlxm08CL2aoRU22lYhVgwh1NPb25ufaykyPXKpdwtUfSSl9HhKJgTbeVYV15q0c0zYA6Ki/c9h/kdaKvd+bBDgXv7kYppKXJOamWmpsDuXZvS4+63ZEjUb0zPjaZhLPJBtPVwG4BrN4iJMig7ftshGemrWIFJGFlU7zjUuMuyKu6oL2/kWuv1aCQeVzq3HG4UKTBgKBSyJrhZcUsJCpyIm18cGS7w2iGJZxpdS3fRzmMCPuPHDOao3S5O6keIx2waObDR6392f29N+Rp5jGiD4L2vWz5So3X2cwNOLrhezrL6yhhgq+B/CvaKWxaOTgmJ8gqAPH5mkwxVSjQYaDM0U0OSKxxhAMOrXoYDBDECvdI3/wm8V+eR2Qu46tEi22UOUaGWP2lal7jvg4SE56NIfLwrNQBOkocOdm4eZdjYQ==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 575ef81d-3e33-4875-df98-08d882292e20
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2020 07:54:25.6668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /dgjLx+inBrFPbSgf76udPsPdzxqGuKudk2g7bRuj4GEt82qrz6SwBAM/9ladxHxNPIJPubbSIGcYiwtnuoV7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4524
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The jump_label_init() should be called from setup_arch() very
early for proper functioning of jump label support.

Fixes: ebc00dde8a97 ("riscv: Add jump-label implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/kernel/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index c424cc6dd833..117f3212a8e4 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -75,6 +75,7 @@ void __init setup_arch(char **cmdline_p)
 	*cmdline_p = boot_command_line;
 
 	early_ioremap_setup();
+	jump_label_init();
 	parse_early_param();
 
 	efi_init();
-- 
2.25.1

