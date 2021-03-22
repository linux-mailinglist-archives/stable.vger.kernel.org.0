Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A8E343C0D
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 09:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhCVIs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 04:48:26 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:50797 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229865AbhCVIsW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 04:48:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 895C715A3;
        Mon, 22 Mar 2021 04:48:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 22 Mar 2021 04:48:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=E1bI3I
        FL2fSarCwgnl5Q73+VhCEboRYVAUUn/+1GjWI=; b=huchKCRFC7pVwKyOgQkysW
        0lB31hDAyW4dGsac4mevqpTw+4zwEWmFJyLExOEHQKbva83ny142Q3NCmnyl1DFq
        iU3fSvr0iwBHk47Gk0NUJyF9l8VyuBEG+MEMpyi/gSiXUSehdCK5cuoda48/eUpK
        JhnzxehX4Oqbg9OV+0tGJhYmYT4KQi3uN6tWl3HHzKqJe7XeudIoeUFvymFyR88p
        pJ79vILB9Qy1iVmRDuYCKJbkw4dz+za6HsXKg2Qq/gvwYjwoAWYQIalju8UFQu0b
        DNRvdcQBcoJKYVCdR7jR2JnLM0j5+yV7No4ENt6hQYX1uKEuU09WpFM7fWUq0dmw
        ==
X-ME-Sender: <xms:1FlYYDTIXOtaCHGuymKPnU6xqcYCnIa6EVDrN--r9By_kbIj0tJktw>
    <xme:1FlYYEwSRoKTzwIGVRPlSVhVupWq_bIMfAzLs5cYdw5nPlqeqYzm1EWl36ugO-WNA
    FSLbc7_VykVoQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegfedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:1FlYYI1qtik1F2uylQ4mbc2yInxMrtHJ8mJ08rb18CwN0Dq5K_QlOQ>
    <xmx:1FlYYDB4RWs1iGVdfDaqX2VNF9ZpYwRpypjE4aZVPAeCZ2aY337AOg>
    <xmx:1FlYYMgQE7_elQzDys4xoQj3GEV1rRR0Tt3Lq1dkG94u3m-83qMZsw>
    <xmx:1VlYYIZZ4UNSdokNEgyehbKeYVU3415AWzCja0sssxWysFxXplD5CkS2y7g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6D82A1080064;
        Mon, 22 Mar 2021 04:48:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: typec: tcpm: Skip sink_cap query only when VDM sm is" failed to apply to 5.11-stable tree
To:     badhri@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Mar 2021 09:48:18 +0100
Message-ID: <16164028986793@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
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

