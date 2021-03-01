Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE2E6328FEC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234687AbhCAT7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:59:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:58018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240811AbhCATtV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:49:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 796FF64FFE;
        Mon,  1 Mar 2021 17:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621093;
        bh=JNHFnso0xQGoEgZeY0wSr2b8I2qce0XEpseJ+QIzKdQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kLddvEqj/WhHW3hfK2N3yewfjAN/hr1tUUO1aWAgwceCEth37Tk0nDnWVsCjMRiV+
         KIQ5rkxdnclnJ/f+r/0D57os7N/vH4M8c0lQUOjqbsbdQEurhobT0rw8QbZgffj1AT
         lXGLb1GT8xm7WNwV/nA+0tjaQyhewIXFaZROkN2U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 390/775] powerpc/kvm: Force selection of CONFIG_PPC_FPU
Date:   Mon,  1 Mar 2021 17:09:18 +0100
Message-Id: <20210301161220.870751066@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 27f699579b64dbf27caf31e5c0eac567ec0aa8b8 ]

book3s/32 kvm is designed with the assumption that
an FPU is always present.

Force selection of FPU support in the kernel when
build KVM.

Fixes: 7d68c8916950 ("powerpc/32s: Allow deselecting CONFIG_PPC_FPU on mpc832x")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/74461a99fa1466f361532ca794ca0753be3d9f86.1611038044.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kvm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kvm/Kconfig b/arch/powerpc/kvm/Kconfig
index 549591d9aaa2c..e45644657d49d 100644
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -54,6 +54,7 @@ config KVM_BOOK3S_32
 	select KVM
 	select KVM_BOOK3S_32_HANDLER
 	select KVM_BOOK3S_PR_POSSIBLE
+	select PPC_FPU
 	help
 	  Support running unmodified book3s_32 guest kernels
 	  in virtual machines on book3s_32 host processors.
-- 
2.27.0



