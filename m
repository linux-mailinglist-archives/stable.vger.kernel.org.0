Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A343F3C3C0D
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 13:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbhGKL7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 07:59:02 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:54731 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232786AbhGKL67 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 07:58:59 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.nyi.internal (Postfix) with ESMTP id 777A71940873;
        Sun, 11 Jul 2021 07:56:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sun, 11 Jul 2021 07:56:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=5swgRn
        OFBBs0I1U9oz7Nd+g0gDpW95OoOrMBYYF20jM=; b=EBPkaGVOOkSNObGOzVadco
        XYej8wwaJZxnkFSIkx3zOzY0c/jAnibgqALPpvFLaDfs2UPZYXgeDYsnVj+q3dUd
        wz4scsQ7ALntrLZT9WxUpyi3gnEgxSy5QAv/eupt41X6kfXekwUcTuRYNWhc/jkR
        fulDsDcQMUOa3dV8fuWl6iaGWk+MtWQL79AIXSAs2ev4HLx+8IKUvrEZQ3oqE3/I
        4WJ2uIjzGKAtM4ehteLm92YWDVKHpLPTHYGh0ieDJKhLxopUP7MS9CkqtzGb4eGY
        9asl2N95kw6u/TCWr7W0IN6zncp+IZXALV4ZpGT61N+JWnQe7rH98vemu1Og+jKQ
        ==
X-ME-Sender: <xms:XNzqYJaxIvAnjMcD8bjxbR4p9GBMVZ5xv0bsuPWg9llUUPc183dQDg>
    <xme:XNzqYAZ9kHxO3ZjBKlYeuqM9eXkXCEZh_eHebjj_b8tRDVWuhjrhfQTKH-VShJRvs
    p4--G6NBb1O6A>
X-ME-Received: <xmr:XNzqYL_3wEZhzDjVwLCapTV7l5gmmMGluNvxx2O23n3kVotm8WtOSbSvnUDtgXiOzECqa52_K2bC0a-QP4dg97Wb6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdegiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:XNzqYHqCtskLowh0NT7gGdu5_VlGssdCb8LArNOj-92llngduVZGGQ>
    <xmx:XNzqYEruqixDXXZuo7IK-xF6GQKR9Xoroskhnh-QqcjJ3_xo0m_M4A>
    <xmx:XNzqYNSN_O-cW3dgAMYQJ5UCq9zmTmvU41_9PemD9vYi3GFWDZ605A>
    <xmx:XNzqYJCKORqYzjotwzEZx5HQ3GZc4HiWblTl3JIVwty0N5QVAUCKOw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 07:56:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: typec: tcpm: Ignore Vsafe0v in PR_SWAP_SNK_SRC_SOURCE_ON" failed to apply to 5.13-stable tree
To:     kyletso@google.com, badhri@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 13:56:02 +0200
Message-ID: <16260045628187@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fed09e0bf9f0622a54f3963f959d914fa817f8a6 Mon Sep 17 00:00:00 2001
From: Kyle Tso <kyletso@google.com>
Date: Wed, 16 Jun 2021 01:32:06 +0800
Subject: [PATCH] usb: typec: tcpm: Ignore Vsafe0v in PR_SWAP_SNK_SRC_SOURCE_ON
 state

In PR_SWAP_SNK_SRC_SOURCE_ON state, Vsafe0v is expected as well so do
nothing here to avoid state machine going into SNK_UNATTACHED.

Fixes: 28b43d3d746b ("usb: typec: tcpm: Introduce vsafe0v for vbus")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Kyle Tso <kyletso@google.com>
Link: https://lore.kernel.org/r/20210615173206.1646477-1-kyletso@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/typec/tcpm/tcpm.c b/drivers/usb/typec/tcpm/tcpm.c
index 197556038ba4..e11e9227107d 100644
--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -5212,6 +5212,7 @@ static void _tcpm_pd_vbus_vsafe0v(struct tcpm_port *port)
 		}
 		break;
 	case PR_SWAP_SNK_SRC_SINK_OFF:
+	case PR_SWAP_SNK_SRC_SOURCE_ON:
 		/* Do nothing, vsafe0v is expected during transition */
 		break;
 	default:

