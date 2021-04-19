Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2C7364313
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:17:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239749AbhDSNOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:14:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:47094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239342AbhDSNMX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:12:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86AF2610CC;
        Mon, 19 Apr 2021 13:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837900;
        bh=zo2VGUA4vjyaBsM1mgdZmdaQSOR5md7ENQk7yO5LMLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RtoDt16w7m4svaQPTWphMRtBuAiYBVVxiyD/Yi9T9sjv4Dt5lDHJ96oejRH+EKlMJ
         FHOt/o2YJZQJS0DYYzz9MNEqutg7oqzdjl6vE6x27Y0hpw1Xj+ehA0I9ZVtHrmIhHl
         FwtyZgB5LYgievaVvYZZIBTZMs3fWdVnRVtzvuBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Christoph Hellwig <hch@lst.de>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.11 093/122] ia64: remove duplicate entries in generic_defconfig
Date:   Mon, 19 Apr 2021 15:06:13 +0200
Message-Id: <20210419130533.313495650@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 19d000d93303e05bd7b1326e3de9df05a41b25b5 upstream.

Fix ia64 generic_defconfig duplicate entries, as warned by:

  arch/ia64/configs/generic_defconfig: warning: override: reassigning to symbol ATA:  => 58
  arch/ia64/configs/generic_defconfig: warning: override: reassigning to symbol ATA_PIIX:  => 59

These 2 symbols still have the same value as in the removed lines.

Link: https://lkml.kernel.org/r/20210411020255.18052-1-rdunlap@infradead.org
Fixes: c331649e6371 ("ia64: Use libata instead of the legacy ide driver in defconfigs")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/ia64/configs/generic_defconfig |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/ia64/configs/generic_defconfig
+++ b/arch/ia64/configs/generic_defconfig
@@ -55,8 +55,6 @@ CONFIG_CHR_DEV_SG=m
 CONFIG_SCSI_FC_ATTRS=y
 CONFIG_SCSI_SYM53C8XX_2=y
 CONFIG_SCSI_QLOGIC_1280=y
-CONFIG_ATA=y
-CONFIG_ATA_PIIX=y
 CONFIG_SATA_VITESSE=y
 CONFIG_MD=y
 CONFIG_BLK_DEV_MD=m


