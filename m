Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1C62C7FCE
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 09:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbgK3I1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 03:27:06 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:46105 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726390AbgK3I1G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Nov 2020 03:27:06 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 4C68F6DB;
        Mon, 30 Nov 2020 03:26:20 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 30 Nov 2020 03:26:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=BaOXmG
        CE78Q7zJ0q9klmFHVyUPyg7BhYIhwF/RmCANA=; b=HpE1gWZZupYuJYm1SSX3I3
        yTlDF6qOW3JKATnallLxCeDTM9fwo2YbGVxDWgM6Wfe0InF1R9zkkQQirr1fwcs6
        7yj61IDruu6pMGFUmqO3yZoSmR/q9gzxL6ZFED7ky6KvF778iDHJ3nNNtg0i/LSV
        5d/53cYsSZv5wJUQoaM7LCO0eNYdi3vD8r0Jx44oi4GniW4DcGsu9/5FSf9dx3sh
        Fqo3lfEIqM6EuOJKt2QbdzSMmWQUjfKuQwJJWdjqJyqP/yTaXWsA1fxZ7XWUKC37
        tSkb+vDha0giahvzYAUoHM+1KqmyJVf9nDmlUXI3W6o/CJN/HQc5EaaIwDoJYY+w
        ==
X-ME-Sender: <xms:q6zEX3TT-KQurkoZFDKmFg-wN3JXNfPYbgTkP1XLuEfHulxf7jR-fQ>
    <xme:q6zEX4xc0ppsYpzT3z-vpurj6Fd9AmY4qBpuGu-ZM1s55If4L06knkR-9FROgRGhW
    mi7dWbWY1rdcg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudehledguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:q6zEX82HJ5sPnZkTOie2NQWvsA7f6uyfhM11nSWE1jWfHo-VahxZvQ>
    <xmx:q6zEX3Bsts_E3Lv7Sh9g1oC61Awx7DP8433y7wBtDZ9-OOMOcZ_mNQ>
    <xmx:q6zEXwiQnKk5_hnyOK_MQ35O5Ff_t5Wr6f9GEbHFJYp1oESYfLW7xQ>
    <xmx:q6zEX8aVZGvom4P46O3ZO8QDjpIPHow_RIHVBm3a1QR7fRT4tWo1lms_GKU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2431A328005A;
        Mon, 30 Nov 2020 03:26:19 -0500 (EST)
Subject: FAILED: patch "[PATCH] usb: gadget: f_midi: Fix memleak in f_midi_alloc" failed to apply to 4.4-stable tree
To:     zhangqilong3@huawei.com, gregkh@linuxfoundation.org,
        hulkci@huawei.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 30 Nov 2020 09:27:23 +0100
Message-ID: <1606724843225246@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e7694cb6998379341fd9bf3bd62b48c4e6a79385 Mon Sep 17 00:00:00 2001
From: Zhang Qilong <zhangqilong3@huawei.com>
Date: Tue, 17 Nov 2020 10:16:28 +0800
Subject: [PATCH] usb: gadget: f_midi: Fix memleak in f_midi_alloc

In the error path, if midi is not null, we should
free the midi->id if necessary to prevent memleak.

Fixes: b85e9de9e818d ("usb: gadget: f_midi: convert to new function interface with backward compatibility")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201117021629.1470544-2-zhangqilong3@huawei.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/usb/gadget/function/f_midi.c b/drivers/usb/gadget/function/f_midi.c
index 85cb15734aa8..19d97940eeb9 100644
--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -1315,7 +1315,7 @@ static struct usb_function *f_midi_alloc(struct usb_function_instance *fi)
 	midi->id = kstrdup(opts->id, GFP_KERNEL);
 	if (opts->id && !midi->id) {
 		status = -ENOMEM;
-		goto setup_fail;
+		goto midi_free;
 	}
 	midi->in_ports = opts->in_ports;
 	midi->out_ports = opts->out_ports;
@@ -1327,7 +1327,7 @@ static struct usb_function *f_midi_alloc(struct usb_function_instance *fi)
 
 	status = kfifo_alloc(&midi->in_req_fifo, midi->qlen, GFP_KERNEL);
 	if (status)
-		goto setup_fail;
+		goto midi_free;
 
 	spin_lock_init(&midi->transmit_lock);
 
@@ -1343,9 +1343,13 @@ static struct usb_function *f_midi_alloc(struct usb_function_instance *fi)
 
 	return &midi->func;
 
+midi_free:
+	if (midi)
+		kfree(midi->id);
+	kfree(midi);
 setup_fail:
 	mutex_unlock(&opts->lock);
-	kfree(midi);
+
 	return ERR_PTR(status);
 }
 

