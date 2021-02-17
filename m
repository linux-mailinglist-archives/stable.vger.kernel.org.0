Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D79B31E0F6
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 22:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbhBQVBq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 16:01:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbhBQVBm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 16:01:42 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865F5C061756
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 13:01:02 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id x16so3422615wmk.3
        for <stable@vger.kernel.org>; Wed, 17 Feb 2021 13:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4Ayh7e2qF9tRPD+U37n6BEuIB55CSCo3OhF4HgwiNeE=;
        b=duS7IDHRzlRkq/6hyhQ1YRa6VT/59qDplTFO4loKhP3OCMmtYMzRWCgXXJdw600FpF
         mucqECkLaWKnb+f2KU+i12pG9ZLG5fl42vBEm7Jug5jIou/A7NK4nW4ckMoE2bx2Vr9u
         bE8W6N8JUtH80ZeDZ4VHegMBTw0gh/5QjDJoWyhHmbxhwFoXTXcpfNG1JH5opXoZLmJj
         DNJNFB3ZE9URyaB4ohupG2aBrh4vfT58UP51Q+esbCuOX7d2pIL/e+HEqBusgOkeUiao
         xuc4c6GnA6wqf8M0DpuQh6FsAcBLC8/ilhg3Vy3mg0q8wtJTgsqCns38Wtrow5w9xeEn
         wZvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4Ayh7e2qF9tRPD+U37n6BEuIB55CSCo3OhF4HgwiNeE=;
        b=DhGSBvnpUUKok02YsavAa2FntXQYbq5tWI9hNEBRHeaSomrE56Rob1eQh2vrxznTTU
         7upVeNtvdav2J4GoAaAvtNpbh0O2edcXq7N5j5wxDYk10C8P8X7lXJsSrjLTK1r/aVWh
         sgpxxRsmUUtfl1V31ftHPYvIkdgn2D0QmNRQQBLkAQes0KSP7zXlbenFqB+hgX90CwIu
         llV/chNsYBhgBRdMwD7RuC1b5PVB+Xwxe/1pkySuXgvstwv7ETI4vTJDAmZMMOEbrsjz
         WGvecCpUdUuBgeo6A6BqaZMQxOJ9wjjj5pgF+PqeKrsZ+FtN+1l9nCiZLCEgmT7384nz
         7W1w==
X-Gm-Message-State: AOAM533P/wwPPAK2HCnHDOborndpDvkAQCaEzHiN0amBC+IsV+m94++h
        7QL2H4frZqLOVBYPnjN4CTpgRmh46TqNXw==
X-Google-Smtp-Source: ABdhPJyd9qCXL5kmUps2s5c5Xe51lp+vKxAOCxHZw40U9vWBWgY0oHeN9IUSHy6/Wu20/iCqvNJVyQ==
X-Received: by 2002:a7b:cbc1:: with SMTP id n1mr654649wmi.30.1613595661198;
        Wed, 17 Feb 2021 13:01:01 -0800 (PST)
Received: from debian (host-2-98-59-96.as13285.net. [2.98.59.96])
        by smtp.gmail.com with ESMTPSA id x4sm5502302wrn.64.2021.02.17.13.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 13:01:00 -0800 (PST)
Date:   Wed, 17 Feb 2021 21:00:58 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     manish.narani@xilinx.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] usb: gadget: u_ether: Fix MTU size
 mismatch with RX packet" failed to apply to 4.14-stable tree
Message-ID: <YC2ECvwJvBaZ8f/1@debian>
References: <1610354613231213@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="FuCb48ARK38qhFYr"
Content-Disposition: inline
In-Reply-To: <1610354613231213@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--FuCb48ARK38qhFYr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Jan 11, 2021 at 09:43:33AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport along with eea52743eb56 ("USB: Gadget Ethernet: Re-enable Jumbo frames.")
for easy backporting. And looks like that should have been in stable by itself.


--
Regards
Sudip

--FuCb48ARK38qhFYr
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-USB-Gadget-Ethernet-Re-enable-Jumbo-frames.patch"

From 91b75a430da3f5d346342e812b31b553e41d083a Mon Sep 17 00:00:00 2001
From: John Greb <h3x4m3r0n@gmail.com>
Date: Sun, 6 May 2018 20:01:57 +0000
Subject: [PATCH 1/2] USB: Gadget Ethernet: Re-enable Jumbo frames.

commit eea52743eb5654ec6f52b0e8b4aefec952543697 upstream

Fixes: <b3e3893e1253> ("net: use core MTU range checking")
which patched only one of two functions used to setup the
USB Gadget Ethernet driver, causing a serious performance
regression in the ability to increase mtu size above 1500.

Signed-off-by: John Greb <h3x4m3r0n@gmail.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/usb/gadget/function/u_ether.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index 716edd593a99..0b24c365d988 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -850,6 +850,10 @@ struct net_device *gether_setup_name_default(const char *netname)
 	net->ethtool_ops = &ops;
 	SET_NETDEV_DEVTYPE(net, &gadget_type);
 
+	/* MTU range: 14 - 15412 */
+	net->min_mtu = ETH_HLEN;
+	net->max_mtu = GETHER_MAX_ETH_FRAME_LEN;
+
 	return net;
 }
 EXPORT_SYMBOL_GPL(gether_setup_name_default);
-- 
2.30.0


--FuCb48ARK38qhFYr
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0002-usb-gadget-u_ether-Fix-MTU-size-mismatch-with-RX-pac.patch"

From 600a331b4ec9bca91677a2fb7704f900c4b210ee Mon Sep 17 00:00:00 2001
From: Manish Narani <manish.narani@xilinx.com>
Date: Tue, 17 Nov 2020 12:43:35 +0530
Subject: [PATCH 2/2] usb: gadget: u_ether: Fix MTU size mismatch with RX
 packet size

commit 0a88fa221ce911c331bf700d2214c5b2f77414d3 upstream

Fix the MTU size issue with RX packet size as the host sends the packet
with extra bytes containing ethernet header. This causes failure when
user sets the MTU size to the maximum i.e. 15412. In this case the
ethernet packet received will be of length 15412 plus the ethernet header
length. This patch fixes the issue where there is a check that RX packet
length must not be more than max packet length.

Fixes: bba787a860fa ("usb: gadget: ether: Allow jumbo frames")
Signed-off-by: Manish Narani <manish.narani@xilinx.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1605597215-122027-1-git-send-email-manish.narani@xilinx.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/usb/gadget/function/u_ether.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/function/u_ether.c b/drivers/usb/gadget/function/u_ether.c
index 0b24c365d988..989682cc8686 100644
--- a/drivers/usb/gadget/function/u_ether.c
+++ b/drivers/usb/gadget/function/u_ether.c
@@ -49,9 +49,10 @@
 #define UETH__VERSION	"29-May-2008"
 
 /* Experiments show that both Linux and Windows hosts allow up to 16k
- * frame sizes. Set the max size to 15k+52 to prevent allocating 32k
+ * frame sizes. Set the max MTU size to 15k+52 to prevent allocating 32k
  * blocks and still have efficient handling. */
-#define GETHER_MAX_ETH_FRAME_LEN 15412
+#define GETHER_MAX_MTU_SIZE 15412
+#define GETHER_MAX_ETH_FRAME_LEN (GETHER_MAX_MTU_SIZE + ETH_HLEN)
 
 struct eth_dev {
 	/* lock is held while accessing port_usb
@@ -790,7 +791,7 @@ struct eth_dev *gether_setup_name(struct usb_gadget *g,
 
 	/* MTU range: 14 - 15412 */
 	net->min_mtu = ETH_HLEN;
-	net->max_mtu = GETHER_MAX_ETH_FRAME_LEN;
+	net->max_mtu = GETHER_MAX_MTU_SIZE;
 
 	dev->gadget = g;
 	SET_NETDEV_DEV(net, &g->dev);
@@ -852,7 +853,7 @@ struct net_device *gether_setup_name_default(const char *netname)
 
 	/* MTU range: 14 - 15412 */
 	net->min_mtu = ETH_HLEN;
-	net->max_mtu = GETHER_MAX_ETH_FRAME_LEN;
+	net->max_mtu = GETHER_MAX_MTU_SIZE;
 
 	return net;
 }
-- 
2.30.0


--FuCb48ARK38qhFYr--
