Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E47A328942
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:56:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239062AbhCARxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:53:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238360AbhCARrL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:47:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D343264E5C;
        Mon,  1 Mar 2021 16:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617945;
        bh=U1xvixLjF4IbMg+HXU8aLtIaQiu3aPinR/PuB672iBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZDacMoQeGYOsyH6i2PrGZEI38plU56cjpHxgINgxzJGcwJlNOpBmAQJGNEYIDozT
         whwU0onxU5M4iKbGdiol9jIuG+N/4dMrx7D6/nBvrVudo2pMw0oLXRzvOOGWAiz7Bm
         c3aGg0dR3BxB72iR79w9JSSAZaeYHWl4b8j3rcvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 252/340] ALSA: hda: Add another CometLake-H PCI ID
Date:   Mon,  1 Mar 2021 17:13:16 +0100
Message-Id: <20210301161100.699557955@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

commit 0d3070f5e6551d8a759619e85736e49a3bf40398 upstream.

Add one more HD Audio PCI ID for CometLake-H PCH.

Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210212151022.2568567-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_intel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2447,6 +2447,8 @@ static const struct pci_device_id azx_id
 	/* CometLake-H */
 	{ PCI_DEVICE(0x8086, 0x06C8),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	{ PCI_DEVICE(0x8086, 0xf1c8),
+	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
 	/* CometLake-S */
 	{ PCI_DEVICE(0x8086, 0xa3f0),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},


