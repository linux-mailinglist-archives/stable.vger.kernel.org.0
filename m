Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19967343C0E
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 09:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhCVIs7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 04:48:59 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:39933 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229874AbhCVIs3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 04:48:29 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 0234B158D;
        Mon, 22 Mar 2021 04:48:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 22 Mar 2021 04:48:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=PdXUoE
        +h9fMN7Up7w+jrO5omqjFwKFevBDDHhGUDBc0=; b=L6OMrRdxU/IWCJjV3yvMtL
        dWq8Ti3C9CwvkgKOiMLQWB/aNwOsm3W9MNYWV9QafwU5lTWT26FMNUAn8wF1J8Vv
        aPn7vvKe7W6jnGw7yJGgon5yEgEwcyQsp3ZrvX65gAfROhchyA/cXbCF38rBc7P7
        Gds3roFlNnMIHCvCMzPgRV9c+R72c7TdyXhCRueXMq6csDwEJ3AVFxKiiOzAYO8g
        NwRTneHy3AEnhpK9GwfS8duwe+TnZrUx8k+5OdZAOuOEyxYuXgBdfkn0ULTwDG9v
        qFjenRUAxmomz0D6tuY0DPZ2dnuBR1HnhQjVyLIzsRDS+Sepi7ftDOK1xOmFhQKA
        ==
X-ME-Sender: <xms:3FlYYIS8S_kGeIW-e73cVzFkjYBDZTL8bZXf0gbfc7clJDrxj180Ew>
    <xme:3FlYYFz4Q7qYderwTA-F5aKs566J329h47tpXaY3QQATq9rPnpyUMuhxGTAy9Rb66
    5NV1RA4CrL0gw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegfedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:3FlYYF2_QxRAwyD1XXHdKhrP2F4LEoK9UZiSFJsHvS5QIAfdMepxNQ>
    <xmx:3FlYYMB0ZdOyazzo6JSyUbAUQULmb3OLzI1x87foVxl4Q1Fj4hrlTQ>
    <xmx:3FlYYBj6WobN4rpi_F3VLq73AyboIKfk2Dx1bJ4Hm_WzE30ojWAr9g>
    <xmx:3FlYYBZYrn66pwGlOfcD93PPBxpcWAaV2c2gj6NlfizdOGxOH9wDnEfVtUc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 51587240422;
        Mon, 22 Mar 2021 04:48:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: typec: tcpm: Skip sink_cap query only when VDM sm is" failed to apply to 5.10-stable tree
To:     badhri@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Mar 2021 09:48:19 +0100
Message-ID: <161640289925083@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2b8c956ea6ba896ec18ae36c2684ecfa04c1f479 Mon Sep 17 00:00:00 2001
From: Badhri Jagan Sridharan <badhri@google.com>
Date: Wed, 17 Mar 2021 23:48:05 -0700
Subject: [PATCH] usb: typec: tcpm: Skip sink_cap query only when VDM sm is
 busy

When port partner responds "Not supported" to the DiscIdentity command,
VDM state machine can remain in NVDM_STATE_ERR_TMOUT and this causes
querying sink cap to be skipped indefinitely. Hence check for
vdm_sm_running instead of checking for VDM_STATE_DONE.

Fixes: 8dc4bd073663f ("usb: typec: tcpm: Add support for Sink Fast Role SWAP(FRS)")
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210318064805.3747831-1-badhri@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 92093ea12cff..ce7af398c7c1 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -5173,7 +5173,7 @@ static void tcpm_enable_frs_work(struct kthread_work *work)
 		goto unlock;
 
 	/* Send when the state machine is idle */
-	if (port->state != SNK_READY || port->vdm_state != VDM_STATE_DONE || port->send_discover)
+	if (port->state != SNK_READY || port->vdm_sm_running || port->send_discover)
 		goto resched;
 
 	port->upcoming_state = GET_SINK_CAP;

