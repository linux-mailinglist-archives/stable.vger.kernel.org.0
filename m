Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80172C65C9
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 13:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728910AbgK0Mfn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 07:35:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728404AbgK0Mfn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 07:35:43 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5680C0613D1
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 04:35:42 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id m6so5411369wrg.7
        for <stable@vger.kernel.org>; Fri, 27 Nov 2020 04:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZVIBbg8ucTiKssn0uh6qymCrrjarQixQdL62NomKaAg=;
        b=jFaYYnl4v1eEbNB0BppZPjsfGhhnpZIaddBgO4BU5krzPEkut9BMf9LVwNSsbB2Ndl
         XI6OR/yUjbXUuLPH0aHlUYhyscHeaYoXJAx7UCJwILqWncj5bPKPjjjRNZWFD5w8Oxlr
         32cC5uKOKIVjw1B2gA7MG7vtFPSS/SFFkN3jEAcaq0K0AM7HLxW6pl0vv0N6t3JuaAao
         jIsRIZdg3Sf1ynEtDrnu+o65dpk7pBm1TICQk2iBIP4C6z8c3GhRDcgcn7nRm2KyHCYh
         K9HCB5Jp0meVDdMXYcM+YjyKW+8HpByQXV0u5ZskTQwgKU+6F/G3KUOiwKSKs8EkJO+1
         MEBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZVIBbg8ucTiKssn0uh6qymCrrjarQixQdL62NomKaAg=;
        b=tMqOzni7XMbQA+jflUE+a4mTM8Ma/TYwI1JEX6MIs18Tnmo1atNS8x4YccP2W3BLWl
         DVyiKNQ0MPD0WADuoQOM0WZC43heOoeXcuqVTF11F5avfT1EEuHa5zY3sGIY9haXKC/p
         bF7WwlCkDbuH3smgxUvSfp2/NcyYSnkbG2AYFJK5V0J4cPrXUYLHF80ZaLPCxx9ofw9c
         5VH115rz9/bNFnm/ps9ukITa83a57c53QsdXWUtOvArnG3W0XK/kbqbdzAZB9ssiEEqe
         2DJuVj9AVtf7+NVlF0RChwg+qT1lr9B9G6L2mLpYB8Rh5ZEIoQLak736dA1zkMomf3wd
         oH4Q==
X-Gm-Message-State: AOAM530Uj90hJaPg54gyrRKUezg0cNI5/P1Mbd7usI9TQ4OG1yJVXiuj
        qmiF57BK/Rx9iqhgJHl0erY=
X-Google-Smtp-Source: ABdhPJzCkBI8lQoK8RX7Qncv1hQDQtMaD4TOzI69JkeC7/13F5AR+jHcdZMu1X0uJdNPAlwNHWHrBA==
X-Received: by 2002:a5d:46c6:: with SMTP id g6mr10614511wrs.170.1606480540756;
        Fri, 27 Nov 2020 04:35:40 -0800 (PST)
Received: from debian (host-92-5-241-147.as43234.net. [92.5.241.147])
        by smtp.gmail.com with ESMTPSA id a18sm8041378wrr.20.2020.11.27.04.35.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 27 Nov 2020 04:35:39 -0800 (PST)
Date:   Fri, 27 Nov 2020 12:35:38 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     rajatja@google.com, bhelgaas@google.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: Add device even if driver attach
 failed" failed to apply to 4.14-stable tree
Message-ID: <20201127123537.t2oejpb5iickm52z@debian>
References: <1597832576184218@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ccmh6ylvarxjaivm"
Content-Disposition: inline
In-Reply-To: <1597832576184218@kroah.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--ccmh6ylvarxjaivm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Wed, Aug 19, 2020 at 12:22:56PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport. It will also apply to 4.9-stable.

--
Regards
Sudip

--ccmh6ylvarxjaivm
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-PCI-Add-device-even-if-driver-attach-failed.patch"

From 60381cacb8a08f8d20f2043633362fdc8e393178 Mon Sep 17 00:00:00 2001
From: Rajat Jain <rajatja@google.com>
Date: Mon, 6 Jul 2020 16:32:40 -0700
Subject: [PATCH] PCI: Add device even if driver attach failed

commit 2194bc7c39610be7cabe7456c5f63a570604f015 upstream

device_attach() returning failure indicates a driver error while trying to
probe the device. In such a scenario, the PCI device should still be added
in the system and be visible to the user.

When device_attach() fails, merely warn about it and keep the PCI device in
the system.

This partially reverts ab1a187bba5c ("PCI: Check device_attach() return
value always").

Link: https://lore.kernel.org/r/20200706233240.3245512-1-rajatja@google.com
Signed-off-by: Rajat Jain <rajatja@google.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org	# v4.6+
[sudip: use dev_warn]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/pci/bus.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index bc56cf19afd3..8f78e8c15d2e 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -324,12 +324,8 @@ void pci_bus_add_device(struct pci_dev *dev)
 
 	dev->match_driver = true;
 	retval = device_attach(&dev->dev);
-	if (retval < 0 && retval != -EPROBE_DEFER) {
+	if (retval < 0 && retval != -EPROBE_DEFER)
 		dev_warn(&dev->dev, "device attach failed (%d)\n", retval);
-		pci_proc_detach_device(dev);
-		pci_remove_sysfs_dev_files(dev);
-		return;
-	}
 
 	dev->is_added = 1;
 }
-- 
2.11.0


--ccmh6ylvarxjaivm--
