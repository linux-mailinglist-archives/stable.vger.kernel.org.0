Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59F95FEFB2
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 16:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbiJNOEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 10:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbiJNOEB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 10:04:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A291F1D3442;
        Fri, 14 Oct 2022 07:03:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B35761B4A;
        Fri, 14 Oct 2022 13:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B494EC433D7;
        Fri, 14 Oct 2022 13:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665755676;
        bh=N7qjOu8AM4o2tEFVFWLtqsDSfSJXOTnsmwUIOChiYk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eU/V53/8xGV6aGvXIpDd+yVbTl/WtSqMm5szp8ph5UwdcukC5qqsJvi+rzy4I5PpX
         ZqlUSK4wW5n1EEej4zUYsKjWoCM2nlKSiTCnT8e+xYqXRMELUCz40tv619ZX34GUit
         onLHby5WlAO5ySo7OWBrgohys6kQrKv7yx+AZMNB2ilcDJqHqzLPgdc5QKafkImdPH
         UZnHMsjklhmSNBLmR/timpwRBicTDehTzZC8iCksuz5b97lb9SocQZBHa3xcR6tifC
         9REW9q1jx94QoO5aCERuF0Zk6povvmOW4tHHfh4ZO32kXOa7IM0Wa9p/GpWS+z/RqC
         yLZHY94Isgt0w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, oss@buserror.net,
        nathan@kernel.org, ndesaulniers@google.com, Julia.Lawall@inria.fr,
        joel@jms.id.au, nick.child@ibm.com, christophe.leroy@csgroup.eu,
        linuxppc-dev@lists.ozlabs.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 4.19 2/5] powerpc/85xx: Fix fall-through warning for Clang
Date:   Fri, 14 Oct 2022 09:54:25 -0400
Message-Id: <20221014135430.2110067-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221014135430.2110067-1-sashal@kernel.org>
References: <20221014135430.2110067-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

[ Upstream commit d4d944ff68cb1f896d3f3b1af0bc656949dc626a ]

Fix the following fallthrough warning:

arch/powerpc/platforms/85xx/mpc85xx_cds.c:161:3: warning: unannotated fall-through between switch labels [-Wimplicit-fallthrough]

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://github.com/KSPP/linux/issues/198
Link: https://lore.kernel.org/lkml/202209061224.KxORRGVg-lkp@intel.com/
Link: https://lore.kernel.org/r/Yxe8XTY5C9qJLd0Z@work
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/85xx/mpc85xx_cds.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/85xx/mpc85xx_cds.c b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
index 224db30c497b..b3736b835c10 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_cds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
@@ -162,6 +162,7 @@ static void __init mpc85xx_cds_pci_irq_fixup(struct pci_dev *dev)
 			else
 				dev->irq = 10;
 			pci_write_config_byte(dev, PCI_INTERRUPT_LINE, dev->irq);
+			break;
 		default:
 			break;
 		}
-- 
2.35.1

