Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 626675FEF5D
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 15:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiJNN5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 09:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbiJNN42 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 09:56:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C0C2CC88;
        Fri, 14 Oct 2022 06:54:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B078A61B27;
        Fri, 14 Oct 2022 13:54:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10C5C43143;
        Fri, 14 Oct 2022 13:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665755655;
        bh=tZ8r0nEm9ww6pagcy3WIdi9jBPme7+ILd/BnEUv8f0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tM+TL5FJ4QDGIaaHt8NuB0tALyo9w6LyO3smq6n2PZ1waQWFbTVNS08kA6EvgFjz1
         d1/ZpwYd+t9hNWcrnq4NRp336XlvBDsjnFrBVTTVr4ykSCRrHFSy71kewUeRcIfVP8
         eN73lNM0SsWHXPOweIkLhg8jS96DZuLHF0EnU6R4mNXZ2kP+AkXX6f0ywjV0tdz7u3
         vWnqLA+FDfGLmgt19qIC6SRu05KFCyxWCQLUOHNEDVhrxNdCXKvkSxArD/8bLqSnYB
         gbdSpGNTRYNtGSBRDvlxNBKo9gB1KyLq+KZ7IQJ0pXPqoCeqcD9XebIfwfmIYw6FwI
         dXV2nYJVbiNKg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, oss@buserror.net,
        nathan@kernel.org, ndesaulniers@google.com, joel@jms.id.au,
        nick.child@ibm.com, christophe.leroy@csgroup.eu,
        Julia.Lawall@inria.fr, linuxppc-dev@lists.ozlabs.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.4 3/7] powerpc/85xx: Fix fall-through warning for Clang
Date:   Fri, 14 Oct 2022 09:53:56 -0400
Message-Id: <20221014135402.2109942-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221014135402.2109942-1-sashal@kernel.org>
References: <20221014135402.2109942-1-sashal@kernel.org>
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
index 6b1436abe9b1..ee2e6906250c 100644
--- a/arch/powerpc/platforms/85xx/mpc85xx_cds.c
+++ b/arch/powerpc/platforms/85xx/mpc85xx_cds.c
@@ -158,6 +158,7 @@ static void __init mpc85xx_cds_pci_irq_fixup(struct pci_dev *dev)
 			else
 				dev->irq = 10;
 			pci_write_config_byte(dev, PCI_INTERRUPT_LINE, dev->irq);
+			break;
 		default:
 			break;
 		}
-- 
2.35.1

