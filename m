Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9D83C3C09
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 13:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbhGKL6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 07:58:51 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:50573 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229688AbhGKL6u (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 07:58:50 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 245E11940859;
        Sun, 11 Jul 2021 07:56:04 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 11 Jul 2021 07:56:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=57IklO
        Is6pDjIU8/btVy9QQgKUZpk5VVu6p8moMN+yQ=; b=GjwxyVaeNXT7Qi3BIlKxCO
        DYaf7ok+/CZnwDeJCuLBg/MNp65xTXgAzDQBfeKxaVtfRWnU48HbfnrD7zGlHxx3
        PxtRHOTV1WVpWRenL7fubCSvAEqPaEuOxYlvF9c5G/8y5IDw5kqAqmnW2mvz9lvu
        QYWn/tJnE7TiYHEHUTGZAyuUkt2OAhzhoouKmF6hyJzvi/Ih18iXpC2fAA5UMlSy
        A9ZNCb85jL1jvKckRo5m6yFIi8Sl3oFC/rDohOwoGecHlIhCMAqxI+a4mlbDDjxH
        /hjWSdq3SZXzyehmSpXJtI8BpXesc77fIqMkR9hEPY7ARtWepRqYBvLA10bGL+MQ
        ==
X-ME-Sender: <xms:U9zqYLFDVeK5sSedVducu3JhGScvfaO5LgGoFNsAve-7Gfikza3qEw>
    <xme:U9zqYIX0QCYJ1K1Px--WlbslKuaBrwoTO16ZLL9Mhn0Ws1IyXGa5iwRLZVythv6G5
    OYxqvYzLxnwQg>
X-ME-Received: <xmr:U9zqYNLyU13N_WEeLegSiYZEyWe7Gq_d2em3V0gyc2HNR1wQxlCdyB9sx5z6YzWSs1n8Tk-W4epEEX3ed1RTyLXakA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:U9zqYJF7YmMSy2HTkTh-rC1Uh0bdHAC2PfxTrZmsefH6QWpNjX1mcQ>
    <xmx:U9zqYBWn4q9nOogZxtOjxZrPH25wguShzm890oRcR32O_dfrHHA84w>
    <xmx:U9zqYEOe4EMRdE0T6htKIfa2ro10JJDOGEvk8HIqqRcqLFfOGBqT2g>
    <xmx:VNzqYPfnjsMi_Hj5Sj_94ldpKJNMDEPlpX3dZyd-TewCakGyhCIjRA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 07:56:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: typec: tcpm: Ignore Vsafe0v in PR_SWAP_SNK_SRC_SOURCE_ON" failed to apply to 5.12-stable tree
To:     kyletso@google.com, badhri@google.com, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, linux@roeck-us.net,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 13:56:02 +0200
Message-ID: <16260045623385@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
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

