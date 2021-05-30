Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EACA395099
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 13:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhE3LM6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 07:12:58 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:50175 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhE3LM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 07:12:58 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2B301194011A;
        Sun, 30 May 2021 07:11:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 30 May 2021 07:11:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hGsnJZ
        5OM9pYgFUGfPD/dTlKI8aGud9JBVgOKB7jlgY=; b=vFYq73yucj4MrX/2OJIPqT
        wnbZkREJKGp9+NGZcmwWuGsBW55j3VxHhvm6Pz7cq+jRYSIxLKxSw6iFPv/6NhbA
        G+TH4uo21+tTY5stq0hHbrlLFaro2j6deF79E6dPtKZ9PM3XL3h2z8JfwTQHqoQQ
        3PZVaOUAd1Lyai8kYi9Hdtrc2Kaj4z2Bw2VOk4YM4tY9PWMZhoSS1p0y8MK0Irw/
        W0I1BkOnO6InFuWfecWhOCPPktPg1YCK8crvBOTR1Qha/G4C2fa3+HNDn6zXRKtk
        HWwY7axT0o19+WdAGvHZbTAi0uQP9UWEx3m3Q4qArlqtvK8I1V6B6pDdavKFoMkA
        ==
X-ME-Sender: <xms:13KzYPCogOEYWBW1xqFFvgijaxuFD43FzJ3azZcqxcKYyG8TYj4BpA>
    <xme:13KzYFiqxcAFGMT5hrA-rJkUk0fG-wr6znCw0nvNzM1V7OPqj9l3REQUWw-1CaThh
    vDTvrMoZVG-Jw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:13KzYKnvtPvrES0mdPQbaqKWFN-vAQEsSxB1mGrF0iec0VQrmzJz5A>
    <xmx:13KzYBxNC3742y5lr4Ds-UGr5oIU9h5gDbn_wF-o4CPAKzn7BUeUJw>
    <xmx:13KzYETBKmzjsnJbTwKlZI4G4XQrT3WtLrYpGVAbJj55Z_VYLQ4lSg>
    <xmx:2HKzYPcyK2c-x3gcV12YujWabrULIjzk2wREVjuj4dqhg9pNu99aAg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 07:11:19 -0400 (EDT)
Subject: FAILED: patch "[PATCH] usb: typec: mux: Fix matching with typec_altmode_desc" failed to apply to 5.4-stable tree
To:     bjorn.andersson@linaro.org, gregkh@linuxfoundation.org,
        heikki.krogerus@linux.intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 13:10:52 +0200
Message-ID: <1622373052250198@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From acf5631c239dfc53489f739c4ad47f490c5181ff Mon Sep 17 00:00:00 2001
From: Bjorn Andersson <bjorn.andersson@linaro.org>
Date: Sat, 15 May 2021 20:47:30 -0700
Subject: [PATCH] usb: typec: mux: Fix matching with typec_altmode_desc

In typec_mux_match() "nval" is assigned the number of elements in the
"svid" fwnode property, then the variable is used to store the success
of the read and finally attempts to loop between 0 and "success" - i.e.
not at all - and the code returns indicating that no match was found.

Fix this by using a separate variable to track the success of the read,
to allow the loop to get a change to find a match.

Fixes: 96a6d031ca99 ("usb: typec: mux: Find the muxes by also matching against the device node")
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210516034730.621461-1-bjorn.andersson@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/typec/mux.c b/drivers/usb/typec/mux.c
index 9da22ae3006c..8514bec7e1b8 100644
--- a/drivers/usb/typec/mux.c
+++ b/drivers/usb/typec/mux.c
@@ -191,6 +191,7 @@ static void *typec_mux_match(struct fwnode_handle *fwnode, const char *id,
 	bool match;
 	int nval;
 	u16 *val;
+	int ret;
 	int i;
 
 	/*
@@ -218,10 +219,10 @@ static void *typec_mux_match(struct fwnode_handle *fwnode, const char *id,
 	if (!val)
 		return ERR_PTR(-ENOMEM);
 
-	nval = fwnode_property_read_u16_array(fwnode, "svid", val, nval);
-	if (nval < 0) {
+	ret = fwnode_property_read_u16_array(fwnode, "svid", val, nval);
+	if (ret < 0) {
 		kfree(val);
-		return ERR_PTR(nval);
+		return ERR_PTR(ret);
 	}
 
 	for (i = 0; i < nval; i++) {

