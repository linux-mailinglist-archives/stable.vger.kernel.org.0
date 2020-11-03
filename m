Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22B32A4A36
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 16:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgKCPoN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 10:44:13 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:45369 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727901AbgKCPoN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 10:44:13 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id D9AE71942B01;
        Tue,  3 Nov 2020 10:44:11 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 10:44:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=gFKqZa
        rjeF3i3sDhBQ1T64wRQIiNFCAjC9H/9fA4lE8=; b=YiPC7z7ULK5yDJATiCv+WB
        vUWyP5S6VNVmUjzRC7JGtN7jC/hR4c1f+iM9PYvfgxLRxMF/PnFO5nIDHETrcllv
        zTkioN/O7WvX+FllcCFiX3jg6YEgFkhPi9XRtrfPhanEOrEBy5Xn4N8+SqdpWO0J
        9sRysZnZxZYWH0/ytZYxpbK1sm+VVquegEjW00ps9i9jy6/rJiBVAUuEKpatoc55
        6ORGEoBrfOL1LdyXL6qSCmjpPfr2/I1GPuzE66ll8D6EBztBZhMgtVaBjIJoI7pN
        j7tOchDi6dO/hIZYJqQT8kSedRxSfO3o/MdOjhRNCxoi+4hKABC4KJKL5eqQ0fsg
        ==
X-ME-Sender: <xms:y3qhX_JpjoWbmJH_moZMuOf1X8OQoLCtVeoi_2QXdVT9AvGNbocOfw>
    <xme:y3qhXzKk4J_2AKzCMCkVbNLN0xyz5UGdbTIfLIwLsQUtD5oo7la0vLpg9Ajf4cKSc
    j21FOCwRe4XSw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepkeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:y3qhX3sto5c_MMbbohebTTaW0vFdCd8nZAQpe-e5YXZGbkxMUKM37A>
    <xmx:y3qhX4ZLngeHj60LM_8hbceXIRfveK3GFuaC8fK6B_0iaUsNgn4jUg>
    <xmx:y3qhX2ZQDIapR_u_jh1qi_gio0G9BNfq-DzdAG_Gr0ATek7GumK1Hg>
    <xmx:y3qhX1nEDqOg04O2v25T7cOvUEspQzdgrNRT214_IzEWkCwOkX47qw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5828E328005A;
        Tue,  3 Nov 2020 10:44:11 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/amd/display: fix pow() crashing when given base 0" failed to apply to 5.9-stable tree
To:     Krunoslav.Kovac@amd.com, Anthony.Koo@amd.com,
        Rodrigo.Siqueira@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 16:45:05 +0100
Message-ID: <16044183051247@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 5ab7943187f22b572fd12d517bd699771b88ce91 Mon Sep 17 00:00:00 2001
From: Krunoslav Kovac <Krunoslav.Kovac@amd.com>
Date: Thu, 6 Aug 2020 17:54:47 -0400
Subject: [PATCH] drm/amd/display: fix pow() crashing when given base 0

[Why&How]
pow(a,x) is implemented as exp(x*log(a)). log(0) will crash.
So return 0^x = 0, unless x=0, convention seems to be 0^0 = 1.

Cc: stable@vger.kernel.org
Signed-off-by: Krunoslav Kovac <Krunoslav.Kovac@amd.com>
Reviewed-by: Anthony Koo <Anthony.Koo@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>

diff --git a/drivers/gpu/drm/amd/display/include/fixed31_32.h b/drivers/gpu/drm/amd/display/include/fixed31_32.h
index 89ef9f6860e5..16df2a485dd0 100644
--- a/drivers/gpu/drm/amd/display/include/fixed31_32.h
+++ b/drivers/gpu/drm/amd/display/include/fixed31_32.h
@@ -431,6 +431,9 @@ struct fixed31_32 dc_fixpt_log(struct fixed31_32 arg);
  */
 static inline struct fixed31_32 dc_fixpt_pow(struct fixed31_32 arg1, struct fixed31_32 arg2)
 {
+	if (arg1.value == 0)
+		return arg2.value == 0 ? dc_fixpt_one : dc_fixpt_zero;
+
 	return dc_fixpt_exp(
 		dc_fixpt_mul(
 			dc_fixpt_log(arg1),

