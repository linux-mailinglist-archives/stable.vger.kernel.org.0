Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63D421FA2B
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730281AbgGNSuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:50:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730276AbgGNSuL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:50:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8402122AAA;
        Tue, 14 Jul 2020 18:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752611;
        bh=QiABNGIC6INiRA8Y6M1rckpaH1GiJ7V5407vAG7OMGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e6rCN3AwgHNcsTe3M/waFILJ53odeoQj2WNGdTDTDun1p3TuFmh1NjL+/a/S+/gGP
         5vy5nXNsIQRxcqeqyvdZbnaGH6eCYXTqlzGzfIguMxMvif6X+3fU2qJQ5pZFWwsKfC
         WwCUUYBjNyxEIgZdywUKAVL+HXCSrep7A8xnpDjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 013/109] ALSA: hda: Intel: add missing PCI IDs for ICL-H, TGL-H and EKL
Date:   Tue, 14 Jul 2020 20:43:16 +0200
Message-Id: <20200714184106.155795290@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit d50313a5a0d803bcf55121a2b82086633060d05e ]

Mirror PCI ids used for SOF.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20200617164909.18225-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 612441508e80a..95b0fdffc504c 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2433,6 +2433,9 @@ static const struct pci_device_id azx_ids[] = {
 	/* Icelake */
 	{ PCI_DEVICE(0x8086, 0x34c8),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	/* Icelake-H */
+	{ PCI_DEVICE(0x8086, 0x3dc8),
+	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
 	/* Jasperlake */
 	{ PCI_DEVICE(0x8086, 0x38c8),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
@@ -2441,9 +2444,14 @@ static const struct pci_device_id azx_ids[] = {
 	/* Tigerlake */
 	{ PCI_DEVICE(0x8086, 0xa0c8),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	/* Tigerlake-H */
+	{ PCI_DEVICE(0x8086, 0x43c8),
+	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
 	/* Elkhart Lake */
 	{ PCI_DEVICE(0x8086, 0x4b55),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	{ PCI_DEVICE(0x8086, 0x4b58),
+	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
 	/* Broxton-P(Apollolake) */
 	{ PCI_DEVICE(0x8086, 0x5a98),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_BROXTON },
-- 
2.25.1



