Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BEB328D2D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235159AbhCATHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:07:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:34094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240832AbhCATBN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:01:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE6A065239;
        Mon,  1 Mar 2021 17:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619565;
        bh=KEuC3VuSFURCKnFmbBxDshUa+CiBAHG91XOc7Kf9ZfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zDw3ERi0J5no/pzHaDDQaQKmcQm0Je/jY7OIT3Ciw5o5+Rv1KvkrzHVS5ckEeiD0l
         D4rW+t2/IZyYpx2JxAPJHQ/YoGGmMR61qkcRnQvcW4vgSNgUsHQ0r1huRUIvU8qi4c
         SJKVeZHbSAp8kYkuNJQtMkmZQigYtr1XQu/V9au8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 501/663] ALSA: hda: Add another CometLake-H PCI ID
Date:   Mon,  1 Mar 2021 17:12:29 +0100
Message-Id: <20210301161206.639042266@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
@@ -2481,6 +2481,8 @@ static const struct pci_device_id azx_id
 	/* CometLake-H */
 	{ PCI_DEVICE(0x8086, 0x06C8),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	{ PCI_DEVICE(0x8086, 0xf1c8),
+	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
 	/* CometLake-S */
 	{ PCI_DEVICE(0x8086, 0xa3f0),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},


