Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB40C147E68
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 11:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388984AbgAXKIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 05:08:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389216AbgAXKIn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 05:08:43 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2DDE214AF;
        Fri, 24 Jan 2020 10:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579860523;
        bh=E6i2NibqQ//tVZ9T/luhILqSMHOn/vUKO5L3IW+eNr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hmgtlZkpAt8gRWs0f+YQfESZBfPt4opZsyF9CJ0KiqruYcNhQw+H9G3TIuEgbvNpG
         A9x2Y0sv5t02s5zPKgTsiu1h8HplA19mZCIhSYFleNjSW1c1xfegli61ik5LwIm7ie
         vWOyvBXFycVoKaxQSkFAuATPDo2gJ1pXyPsiEiJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrel Datwyler <tyreld@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 007/639] powerpc/pseries: Enable support for ibm,drc-info property
Date:   Fri, 24 Jan 2020 10:22:57 +0100
Message-Id: <20200124093047.995617900@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyrel Datwyler <tyreld@linux.ibm.com>

commit 0a87ccd3699983645f54cafd2258514a716b20b8 upstream.

Advertise client support for the PAPR architected ibm,drc-info device
tree property during CAS handshake.

Fixes: c7a3275e0f9e ("powerpc/pseries: Revert support for ibm,drc-info devtree property")
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1573449697-5448-11-git-send-email-tyreld@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/prom_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/prom_init.c
+++ b/arch/powerpc/kernel/prom_init.c
@@ -904,7 +904,7 @@ struct ibm_arch_vec __cacheline_aligned
 		.reserved2 = 0,
 		.reserved3 = 0,
 		.subprocessors = 1,
-		.byte22 = OV5_FEAT(OV5_DRMEM_V2),
+		.byte22 = OV5_FEAT(OV5_DRMEM_V2) | OV5_FEAT(OV5_DRC_INFO),
 		.intarch = 0,
 		.mmu = 0,
 		.hash_ext = 0,


