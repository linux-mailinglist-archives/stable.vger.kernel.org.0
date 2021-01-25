Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC433032DA
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 05:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbhAZEjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:39:05 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:42421 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729411AbhAYOXp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 09:23:45 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id D476AE14;
        Mon, 25 Jan 2021 09:22:52 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 25 Jan 2021 09:22:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=E3HlSM
        4vx8zbDHcnqo9qg29cHn7L+fqdZ9rmYAvRZFM=; b=UujxPFDYdOzbjkVDlbjVn3
        vg5BRTg2wtxiwjfetFnsNKoapto7hl7mt8wa9nWyIrevaJ+6e/LTTwlhR/NCwHMd
        p9f2gnUmi3pHZojdm1Cqvezmv9QShn+0QvGXPpP2o1n+6nxvNzC2gXvougbphvsn
        zBqrd1zRLMLha1ZwTenaX8+vbzQmYbbZ3WT1OxAdhtrPsgbRIHuhnbJS3Ss0L1Xz
        Tk9R8zsOni8+e6OP83Kn7iMhluEPzLkJLC9lNH6YM3reJqi5kYcIptb/X8dl3JXX
        IfePYSuGd0ZXICOQJvJq/l7x99EmFGgn758frargTVBpMLEKyPgZpQEXky8iRBug
        ==
X-ME-Sender: <xms:O9QOYAYxLQH03mNne_kkCXDCTiyZ8JfxWHlDBnCSeqJlkbYNZfwk9Q>
    <xme:O9QOYLXERui7PRczfQwc866H4xFPesLPDVBC8V9uoNcd8uGoJF5Q8IcNbXmNe9USD
    abDlj7WaJTvcg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgdeiudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:O9QOYH1U3WgTILdu9LY2sHwxZtcOr9xn_lQwpzIZYEr-ZnX0JcVVOw>
    <xmx:O9QOYCY0DIu8_M8yjvEzTPqybxw0vncwvzTLLh9IQVXoUOXQMKvUJw>
    <xmx:O9QOYKphE0F_kbcf8Ur6YiR3cRPUgOwJPVMCcD21kArRJgKCs8f_zQ>
    <xmx:PNQOYOkmN379cUYavFBcxkjgN12hYojvCt8Wsqe8ZiSx4uDJGug6kjtodA8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DBE2824005A;
        Mon, 25 Jan 2021 09:22:50 -0500 (EST)
Subject: FAILED: patch "[PATCH] driver core: Extend device_is_dependent()" failed to apply to 4.14-stable tree
To:     rafael.j.wysocki@intel.com, gregkh@linuxfoundation.org,
        saravanak@google.com, stable@vger.kernel.org, stephan@gerhold.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jan 2021 15:22:49 +0100
Message-ID: <161158456921623@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3d1cf435e201d1fd63e4346b141881aed086effd Mon Sep 17 00:00:00 2001
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Fri, 15 Jan 2021 19:30:51 +0100
Subject: [PATCH] driver core: Extend device_is_dependent()

If the device passed as the target (second argument) to
device_is_dependent() is not completely registered (that is, it has
been initialized, but not added yet), but the parent pointer of it
is set, it may be missing from the list of the parent's children
and device_for_each_child() called by device_is_dependent() cannot
be relied on to catch that dependency.

For this reason, modify device_is_dependent() to check the ancestors
of the target device by following its parent pointer in addition to
the device_for_each_child() walk.

Fixes: 9ed9895370ae ("driver core: Functional dependencies tracking support")
Reported-by: Stephan Gerhold <stephan@gerhold.net>
Tested-by: Stephan Gerhold <stephan@gerhold.net>
Reviewed-by: Saravana Kannan <saravanak@google.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/17705994.d592GUb2YH@kreacher
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 25e08e5f40bd..3819fd012e27 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -208,6 +208,16 @@ int device_links_read_lock_held(void)
 #endif
 #endif /* !CONFIG_SRCU */
 
+static bool device_is_ancestor(struct device *dev, struct device *target)
+{
+	while (target->parent) {
+		target = target->parent;
+		if (dev == target)
+			return true;
+	}
+	return false;
+}
+
 /**
  * device_is_dependent - Check if one device depends on another one
  * @dev: Device to check dependencies for.
@@ -221,7 +231,12 @@ int device_is_dependent(struct device *dev, void *target)
 	struct device_link *link;
 	int ret;
 
-	if (dev == target)
+	/*
+	 * The "ancestors" check is needed to catch the case when the target
+	 * device has not been completely initialized yet and it is still
+	 * missing from the list of children of its parent device.
+	 */
+	if (dev == target || device_is_ancestor(dev, target))
 		return 1;
 
 	ret = device_for_each_child(dev, target, device_is_dependent);

