Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 232FDE6DA
	for <lists+stable@lfdr.de>; Mon, 29 Apr 2019 17:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbfD2PtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Apr 2019 11:49:24 -0400
Received: from inva021.nxp.com ([92.121.34.21]:53412 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728394AbfD2PtY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Apr 2019 11:49:24 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 4FB32200265;
        Mon, 29 Apr 2019 17:49:22 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 43AAD20024C;
        Mon, 29 Apr 2019 17:49:22 +0200 (CEST)
Received: from fsr-ub1664-009.ea.freescale.net (fsr-ub1664-009.ea.freescale.net [10.171.71.77])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id EE9072061E;
        Mon, 29 Apr 2019 17:49:21 +0200 (CEST)
From:   Diana Craciun <diana.craciun@nxp.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     linuxppc-dev@ozlabs.org, mpe@ellerman.id.au,
        Diana Craciun <diana.craciun@nxp.com>
Subject: [PATCH stable v4.4 0/8] missing powerpc spectre backports for 4.4
Date:   Mon, 29 Apr 2019 18:49:00 +0300
Message-Id: <1556552948-24957-1-git-send-email-diana.craciun@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

These are missing patches from the initial powerpc spectre backports for 4.4.
Please queue them as well if you don't have any objections.

Thanks,

Diana Craciun (8):
  powerpc/fsl: Enable runtime patching if nospectre_v2 boot arg is used
  powerpc/fsl: Flush branch predictor when entering KVM
  powerpc/fsl: Emulate SPRN_BUCSR register
  powerpc/fsl: Flush the branch predictor at each kernel entry (32 bit)
  powerpc/fsl: Sanitize the syscall table for NXP PowerPC 32 bit
    platforms
  powerpc/fsl: Fixed warning: orphan section `__btb_flush_fixup'
  powerpc/fsl: Add FSL_PPC_BOOK3E as supported arch for nospectre_v2
    boot arg
  Documentation: Add nospectre_v1 parameter

 Documentation/kernel-parameters.txt   |  6 +++++-
 arch/powerpc/kernel/entry_32.S        | 10 ++++++++++
 arch/powerpc/kernel/head_booke.h      | 12 ++++++++++++
 arch/powerpc/kernel/head_fsl_booke.S  | 15 +++++++++++++++
 arch/powerpc/kernel/setup_32.c        |  1 +
 arch/powerpc/kernel/setup_64.c        |  1 +
 arch/powerpc/kvm/bookehv_interrupts.S |  4 ++++
 arch/powerpc/kvm/e500_emulate.c       |  7 +++++++
 8 files changed, 55 insertions(+), 1 deletion(-)

-- 
2.17.1

