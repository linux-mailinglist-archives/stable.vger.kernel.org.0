Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5330A325928
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 23:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233644AbhBYV7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 16:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbhBYV7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 16:59:39 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B929C061574
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 13:58:59 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id u187so3947917wmg.4
        for <stable@vger.kernel.org>; Thu, 25 Feb 2021 13:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iTiwlERwF64zshsIIMkKk8/wv4RuW04Rr3/QxObwIbA=;
        b=OE+Nso0xZ3Z0U2goU/o9NGtQgJcBjUfIeNrDHLZsqkTuE3Rb1yP4NC8hu0yXDdVotN
         TAHg85oDQlEb0U32bQ/qx/34P4vnExTg2nvMiKBzGBU+b2eUfi4ev3evxGZm0Q9KvmW2
         ayGDv6n3HujzTourTYBqBJep1RqWtS9wIt6dYTTIFAVo6fVxEgNhu4IW5jKOPEnyDVy4
         dWoGJvRYix9a90eXiJZYD9Fkdt7AoUlD/a18aw1CUmYc9KUzEZmU4BIOvmQM8A7rBjh+
         mBMiK5zNio26FTZOvAY6Q0WtYHkGxpZ5IXkSeaX8VnuZyH4i8f1o3OQ441YD2to6Z8MI
         1tYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iTiwlERwF64zshsIIMkKk8/wv4RuW04Rr3/QxObwIbA=;
        b=a/HTV/JmTg+HBAUhyZ/ZV9xTDeG3J2j6cqRq0oaDbbrjE6ih1rWrrYUQWtNfM5zYh4
         gieh1Jplsix9eWKuLd8YRVCzPkrtCbx9qNjqkfGH09S0w1ySWWq57gsC0AxI0DYDXhBj
         uNmsCoVH+ZOWA4tIZihqDGsftpQELJhf65VkT15SAM9FzmhnnG0HAF+2wt/d2BtFNLr6
         JwuoGIoBU5opQQAY1zeJsNysS1ldA4TfqZu2FF8wEvthExDcqtuQccBEi2GPBDtDR6pu
         JHMANPDfLoRIcYGcNzbsu96JLDInAgiAUP9v0u4OOeQuc1mAVMyT2NeD7//imbQFbk+2
         lbhg==
X-Gm-Message-State: AOAM533D5jGZOQeLDu3/pg+xIExO16a4mx9fDOxGWiVBPEpmGOE8mqXu
        M33feN0nfPhDjwSjddQT0Jat36RiUpOU6AHEayg=
X-Google-Smtp-Source: ABdhPJwCEA0EkOwkdXoFGJmbPFJaPUIHfRzaMkDBAQogiVPJgSTWwu2dofTpeIZhANWOVEcrSRaflA==
X-Received: by 2002:a1c:f604:: with SMTP id w4mr381721wmc.39.1614290337833;
        Thu, 25 Feb 2021 13:58:57 -0800 (PST)
Received: from debian (host-2-98-59-96.as13285.net. [2.98.59.96])
        by smtp.gmail.com with ESMTPSA id d17sm10911245wrv.93.2021.02.25.13.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 13:58:57 -0800 (PST)
Date:   Thu, 25 Feb 2021 21:58:55 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     yoshihiro.shimoda.uh@renesas.com, stable@vger.kernel.org,
        tho.vu.wh@renesas.com
Subject: Re: FAILED: patch "[PATCH] usb: renesas_usbhs: Clear pipe running
 flag in" failed to apply to 4.14-stable tree
Message-ID: <YDgdn7E9Nx5GMxkq@debian>
References: <161277841922126@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PXZavNPVIOr263xB"
Content-Disposition: inline
In-Reply-To: <161277841922126@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PXZavNPVIOr263xB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Feb 08, 2021 at 11:00:19AM +0100, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport. Will apply to all branches till 4.4-stable.

--
Regards
Sudip

--PXZavNPVIOr263xB
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-usb-renesas_usbhs-Clear-pipe-running-flag-in-usbhs_p.patch"

From 5f0d0919f09f86b4b1365d46d9f7ddaa0ad3c15a Mon Sep 17 00:00:00 2001
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Date: Mon, 1 Feb 2021 21:47:20 +0900
Subject: [PATCH] usb: renesas_usbhs: Clear pipe running flag in
 usbhs_pkt_pop()

commit 9917f0e3cdba7b9f1a23f70e3f70b1a106be54a8 upstream

Should clear the pipe running flag in usbhs_pkt_pop(). Otherwise,
we cannot use this pipe after dequeue was called while the pipe was
running.

Fixes: 8355b2b3082d ("usb: renesas_usbhs: fix the behavior of some usbhs_pkt_handle")
Reported-by: Tho Vu <tho.vu.wh@renesas.com>
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1612183640-8898-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/usb/renesas_usbhs/fifo.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/renesas_usbhs/fifo.c b/drivers/usb/renesas_usbhs/fifo.c
index 4a486fa5473e..3637d5edab74 100644
--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -137,6 +137,8 @@ struct usbhs_pkt *usbhs_pkt_pop(struct usbhs_pipe *pipe, struct usbhs_pkt *pkt)
 			usbhsf_dma_unmap(pkt);
 		}
 
+		usbhs_pipe_running(pipe, 0);
+
 		__usbhsf_pkt_del(pkt);
 	}
 
-- 
2.30.0


--PXZavNPVIOr263xB--
