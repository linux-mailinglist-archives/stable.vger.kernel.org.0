Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 839EF46270B
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235944AbhK2XAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:00:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235863AbhK2XAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:00:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A541BC1A25DC;
        Mon, 29 Nov 2021 10:38:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CB13B815BB;
        Mon, 29 Nov 2021 18:38:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81730C53FAD;
        Mon, 29 Nov 2021 18:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211094;
        bh=nr6D9LJr5YW7Iz4pQ8ucgiAGoMhPfXBTBgZGacm63n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbbVSX162jvTshfm6uMxopJwlVwB++E4YKw3gh8CnSQUz2H2yfoPujXAwHtZlyzpZ
         40phWRKI/PvKBxboBxKOigWaHw/sJkvvwGsRUr4iy47HgEfDB63YzTP7L7h8u/EqzR
         4BmKiV2sl1ieb2dRsjZVgVavBDWUScVCT10Vhq+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 102/179] xen/pvh: add missing prototype to header
Date:   Mon, 29 Nov 2021 19:18:16 +0100
Message-Id: <20211129181722.296880822@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 2a0991929aba0a3dd6fe51d1daba06a93a96a021 ]

The prototype of mem_map_via_hcall() is missing in its header, so add
it.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: a43fb7da53007e67ad ("xen/pvh: Move Xen code for getting mem map via hcall out of common file")
Signed-off-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20211119153913.21678-1-jgross@suse.com
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/xen/hypervisor.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
index 4957f59deb40b..5adab895127e1 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -64,6 +64,7 @@ void xen_arch_unregister_cpu(int num);
 
 #ifdef CONFIG_PVH
 void __init xen_pvh_init(struct boot_params *boot_params);
+void __init mem_map_via_hcall(struct boot_params *boot_params_p);
 #endif
 
 #endif /* _ASM_X86_XEN_HYPERVISOR_H */
-- 
2.33.0



