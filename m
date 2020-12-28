Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853212E3694
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 12:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbgL1Lfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 06:35:30 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:43595 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727329AbgL1Lfa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 06:35:30 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id B7024871;
        Mon, 28 Dec 2020 06:33:23 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 06:33:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=KVOi4R
        LkQ2ZqAWDRoHrzPs56ZyF8Z2Xa0SpEDnICI3o=; b=ZPdv/LcLmb9O2flapOpzXE
        TlkgpwBxcWGGJRBNRvZJ8xTxDYcg7AtIPP8ocRh3dOl49mcEI7sxSLrBp1ELdint
        q9IrNvTfwNHy9YuZB4vqP2k29O+HHAooVuMP9kcrcQV/cscr886V37ZRXGNYGQZB
        uVF//s6+aijxSLWHX8VG+LvmrgQ6D0Qi7kEnEsxR5iUvR7ZEXunrcV47T4cvbNGb
        vwG2PovnM4DxvfXKg99QAe5+niZXwZyXhtbHKotLLoxD1CRh3hRs0yx970BbS8C3
        neag3tbaojGoRX80087BH6pJXAhsI0rzrTVRD1Dt0zmpgcTQN+aNAdqZN67t+RlA
        ==
X-ME-Sender: <xms:g8LpX3xs-PzH-uD22AOXOTUDxiuoCTgZJMmxeoegnJVTnNDK_LmSRA>
    <xme:g8LpX_S0g7mXA0r4WZoxwd3Uh0VJXjrSWlpjnkUWQRvXJo4XZ3GjH1xdQva23xnbS
    2M8Jo23deMdgg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:g8LpXxWc97FOY_s5_-sSTQ_JQVpWJepcjebQ23fJySm8w_AhAuOF9Q>
    <xmx:g8LpXxi_55pZFP5WIjMV8EkTnA7XCOBxezZFUM2evhIsfc286tEf5A>
    <xmx:g8LpX5Cxv2BgZgrbXfkvXj-GcjpVB3INAg3IOoiGEaBWAHRELgg9nA>
    <xmx:g8LpX8NgmV4GyGfbYeSFMRpLP1PpEEeazODWtwTyLD_EwpDHACpbnevM6kU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0A6361080059;
        Mon, 28 Dec 2020 06:33:22 -0500 (EST)
Subject: FAILED: patch "[PATCH] xen/xenbus/xen_bus_type: Support will_handle watch callback" failed to apply to 4.9-stable tree
To:     sjpark@amazon.de, jgross@suse.com, mku@amazon.de, wipawel@amazon.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 12:26:21 +0100
Message-ID: <160915478124028@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From be987200fbaceaef340872841d4f7af2c5ee8dc3 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sjpark@amazon.de>
Date: Mon, 14 Dec 2020 10:05:47 +0100
Subject: [PATCH] xen/xenbus/xen_bus_type: Support will_handle watch callback

This commit adds support of the 'will_handle' watch callback for
'xen_bus_type' users.

This is part of XSA-349

Cc: stable@vger.kernel.org
Signed-off-by: SeongJae Park <sjpark@amazon.de>
Reported-by: Michael Kurth <mku@amazon.de>
Reported-by: Pawel Wieczorkiewicz <wipawel@amazon.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>

diff --git a/drivers/xen/xenbus/xenbus.h b/drivers/xen/xenbus/xenbus.h
index 5f5b8a7d5b80..2a93b7c9c159 100644
--- a/drivers/xen/xenbus/xenbus.h
+++ b/drivers/xen/xenbus/xenbus.h
@@ -44,6 +44,8 @@ struct xen_bus_type {
 	int (*get_bus_id)(char bus_id[XEN_BUS_ID_SIZE], const char *nodename);
 	int (*probe)(struct xen_bus_type *bus, const char *type,
 		     const char *dir);
+	bool (*otherend_will_handle)(struct xenbus_watch *watch,
+				     const char *path, const char *token);
 	void (*otherend_changed)(struct xenbus_watch *watch, const char *path,
 				 const char *token);
 	struct bus_type bus;
diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
index 4c3d1b84aa0a..44634d970a5c 100644
--- a/drivers/xen/xenbus/xenbus_probe.c
+++ b/drivers/xen/xenbus/xenbus_probe.c
@@ -136,7 +136,8 @@ static int watch_otherend(struct xenbus_device *dev)
 		container_of(dev->dev.bus, struct xen_bus_type, bus);
 
 	return xenbus_watch_pathfmt(dev, &dev->otherend_watch,
-				    NULL, bus->otherend_changed,
+				    bus->otherend_will_handle,
+				    bus->otherend_changed,
 				    "%s/%s", dev->otherend, "state");
 }
 

