Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09B220D189
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgF2SmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:42:07 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51147 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729018AbgF2Sly (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 14:41:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 94B0B245;
        Mon, 29 Jun 2020 07:37:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 29 Jun 2020 07:37:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=CR0tT3
        PmOtYyvI6NaXiI+KlSr1JgsbdIFh0QOaHpfMY=; b=bnsPiWeQFIX+RSSDh2cd7F
        UvjcPp78LSrATbtZZd+Vb+fXAbYDSs3YpE33GK28eKKswYLn2APvm44Hy5KpvWN0
        yrCZQS6DwBXwhZXXpjgoFM40x9q82hsqC0a/kJsynCEGLRPAi+lRa6wWQnDVfHdZ
        v3aMqzDeXSm7w8Lxkkwld+03hZvfoBStW9J+hELQ83KH8HzqVW2xsHCiGnfuTGaT
        14/RHUAuTpSq6Sp4BsOVCIpJLhw+fn2HIJDS8zshBshd0emG3ftcR8t/iu8nYJvU
        xnk1jEBSVM6iVpnudMqUJxpKUbcd7azQMJ7arbE5PoXyRH3xKVVSi5u622Wl7WlQ
        ==
X-ME-Sender: <xms:XdL5Xg3uQl_mPA3nha1i1hOiF0uMAgmYA7seclHuh1X99RNxckAmMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelkedggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:XdL5XrElUbM83mqAcUcnXp1yp59z8Irrf6od2WaYO7vG4FDGr7gLtw>
    <xmx:XdL5Xo5q9nVMkDswc8GsYGYqQA0MD_TX0sjWnzXQXW0qCNAlfxnQ_Q>
    <xmx:XdL5Xp1eckGS6O94J7u9t9qjtTCBvFzSaL9eZHTC9z5WUth5zZ6mFQ>
    <xmx:XdL5Xqz9N1Vqrzcm1EvMAlaJSi70Mp82ngeJUwH9ms7rl3zS8gqgI-fSUi8>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C3743328006A;
        Mon, 29 Jun 2020 07:37:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] EDAC/amd64: Read back the scrub rate PCI register on F15h" failed to apply to 4.9-stable tree
To:     bp@suse.de, pipatron@gmail.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 29 Jun 2020 13:36:48 +0200
Message-ID: <159343060821230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ee470bb25d0dcdf126f586ec0ae6dca66cb340a4 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <bp@suse.de>
Date: Thu, 18 Jun 2020 20:25:25 +0200
Subject: [PATCH] EDAC/amd64: Read back the scrub rate PCI register on F15h

Commit:

  da92110dfdfa ("EDAC, amd64_edac: Extend scrub rate support to F15hM60h")

added support for F15h, model 0x60 CPUs but in doing so, missed to read
back SCRCTRL PCI config register on F15h CPUs which are *not* model
0x60. Add that read so that doing

  $ cat /sys/devices/system/edac/mc/mc0/sdram_scrub_rate

can show the previously set DRAM scrub rate.

Fixes: da92110dfdfa ("EDAC, amd64_edac: Extend scrub rate support to F15hM60h")
Reported-by: Anders Andersson <pipatron@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org> #v4.4..
Link: https://lkml.kernel.org/r/CAKkunMbNWppx_i6xSdDHLseA2QQmGJqj_crY=NF-GZML5np4Vw@mail.gmail.com

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index ef90070a9194..6262f6370c5d 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -269,6 +269,8 @@ static int get_scrub_rate(struct mem_ctl_info *mci)
 
 		if (pvt->model == 0x60)
 			amd64_read_pci_cfg(pvt->F2, F15H_M60H_SCRCTRL, &scrubval);
+		else
+			amd64_read_pci_cfg(pvt->F3, SCRCTRL, &scrubval);
 	} else {
 		amd64_read_pci_cfg(pvt->F3, SCRCTRL, &scrubval);
 	}

