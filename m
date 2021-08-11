Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFBB3E9943
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 21:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhHKT5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 15:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhHKT5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 15:57:41 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1912C061765
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 12:57:16 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id d131-20020a1c1d890000b02902516717f562so2776007wmd.3
        for <stable@vger.kernel.org>; Wed, 11 Aug 2021 12:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iqYghHQ6rzR7jlM/SUSkgZkSeP460YAYbIlLeEb1Wh4=;
        b=XWiGvkWXp09ncmHSm/Wy73iaZRQO1IcQG3sc8YEZo4BU6fHwqmgthGUGH9Wkj3tdrj
         LRZNtNBkVAdbKLmX0iVBi/ntfLrIElXcP2GUZigkJTSSoCjhPimk/E5XJI5h7Xua9KEa
         fCk8gn9vgJkRqGUBv5pYW8c1Lggzn0wZniK7QAD/uOJegnS02rOhpvmVa7e6Reqp3x7e
         QXAflV0tmuQmCQcC+kGyPtPua8HCdd2bG76CnA1XDefmaAuJwVXj3NZSr3z1wWhs7q0y
         t45+JMAE7HllOkTjKAoT7BUOU7KN3dTMVmMbKINzP0yIMj4DgXUy7oXr6rD0FkDljf/x
         geNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iqYghHQ6rzR7jlM/SUSkgZkSeP460YAYbIlLeEb1Wh4=;
        b=Dhv6XrXzBpsbbEdxsItfe68tRlTRZ/7ryvubIL1bkQ/dRau6QFjo3ZEssr++6XHazT
         4VKJsUaJeHK4qzXh4OlVDjklxCFns5ZyGzHArQv0BPkjJgJ9oCIwb1ggi907CgeBMC1T
         EQb8U70MiZkS3TQangFhNqd8fVmRMYV2qj8cexOJZFMR19V2iE0mD2EB1QgjbnNMb+K2
         3hgV8WJLORx31eIpZHUpfWY7A2/mxFC1hHQ1O0q3p0bFIaLbI9KcXXFmz3FqNvOJ1YN9
         ENKrDHQhz2IjgHpdrAseb3qb9WzsDX0kv0IczsBSp7AH4iVPmOzhwTQiUAbfR9TvRAph
         YrEQ==
X-Gm-Message-State: AOAM531eU4+6nY21qi/tNiSbOKJP5/fWSiqU7I/XCJN5WKw7FxD3lCMt
        jjwaqdK4Z/NZ2tWVWcsJjQRSXObDwhRw0Q==
X-Google-Smtp-Source: ABdhPJyqhtuBj+8hqVg8UYR0xmlJ8wi+MbO4w7clB+Ehyb9MU8pQS8ig2j29rtmiYWJEQDwNvQZI1Q==
X-Received: by 2002:a1c:7e43:: with SMTP id z64mr250951wmc.66.1628711835544;
        Wed, 11 Aug 2021 12:57:15 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id j2sm8096304wmi.36.2021.08.11.12.57.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 12:57:14 -0700 (PDT)
Date:   Wed, 11 Aug 2021 20:57:12 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     wcheng@codeaurora.org, balbi@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] usb: dwc3: gadget: Use
 list_replace_init() before traversing" failed to apply to 5.10-stable tree
Message-ID: <YRQrmJuVH6PlaP1P@debian>
References: <1628498902192246@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UkX4noAi4Ifo6Ocb"
Content-Disposition: inline
In-Reply-To: <1628498902192246@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UkX4noAi4Ifo6Ocb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Greg,

On Mon, Aug 09, 2021 at 10:48:22AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here is the backport, will also apply to 5.4-stable and 4.19-stable.

--
Regards
Sudip

--UkX4noAi4Ifo6Ocb
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-usb-dwc3-gadget-Use-list_replace_init-before-travers.patch"

From e01c2051bac15d89168e30c2cfa2cd828104ed4d Mon Sep 17 00:00:00 2001
From: Wesley Cheng <wcheng@codeaurora.org>
Date: Thu, 29 Jul 2021 00:33:14 -0700
Subject: [PATCH] usb: dwc3: gadget: Use list_replace_init() before traversing
 lists

commit d25d85061bd856d6be221626605319154f9b5043 upstream

The list_for_each_entry_safe() macro saves the current item (n) and
the item after (n+1), so that n can be safely removed without
corrupting the list.  However, when traversing the list and removing
items using gadget giveback, the DWC3 lock is briefly released,
allowing other routines to execute.  There is a situation where, while
items are being removed from the cancelled_list using
dwc3_gadget_ep_cleanup_cancelled_requests(), the pullup disable
routine is running in parallel (due to UDC unbind).  As the cleanup
routine removes n, and the pullup disable removes n+1, once the
cleanup retakes the DWC3 lock, it references a request who was already
removed/handled.  With list debug enabled, this leads to a panic.
Ensure all instances of the macro are replaced where gadget giveback
is used.

Example call stack:

Thread#1:
__dwc3_gadget_ep_set_halt() - CLEAR HALT
  -> dwc3_gadget_ep_cleanup_cancelled_requests()
    ->list_for_each_entry_safe()
    ->dwc3_gadget_giveback(n)
      ->dwc3_gadget_del_and_unmap_request()- n deleted[cancelled_list]
      ->spin_unlock
      ->Thread#2 executes
      ...
    ->dwc3_gadget_giveback(n+1)
      ->Already removed!

Thread#2:
dwc3_gadget_pullup()
  ->waiting for dwc3 spin_lock
  ...
  ->Thread#1 released lock
  ->dwc3_stop_active_transfers()
    ->dwc3_remove_requests()
      ->fetches n+1 item from cancelled_list (n removed by Thread#1)
      ->dwc3_gadget_giveback()
        ->dwc3_gadget_del_and_unmap_request()- n+1
deleted[cancelled_list]
        ->spin_unlock

Fix this condition by utilizing list_replace_init(), and traversing
through a local copy of the current elements in the endpoint lists.
This will also set the parent list as empty, so if another thread is
also looping through the list, it will be empty on the next iteration.

Fixes: d4f1afe5e896 ("usb: dwc3: gadget: move requests to cancelled_list")
Cc: stable <stable@vger.kernel.org>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1627543994-20327-1-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
---
 drivers/usb/dwc3/gadget.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 756839e0e91d..788bbb38cf79 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1733,11 +1733,18 @@ static void dwc3_gadget_ep_cleanup_cancelled_requests(struct dwc3_ep *dep)
 {
 	struct dwc3_request		*req;
 	struct dwc3_request		*tmp;
+	struct list_head		local;
 
-	list_for_each_entry_safe(req, tmp, &dep->cancelled_list, list) {
+restart:
+	list_replace_init(&dep->cancelled_list, &local);
+
+	list_for_each_entry_safe(req, tmp, &local, list) {
 		dwc3_gadget_ep_skip_trbs(dep, req);
 		dwc3_gadget_giveback(dep, req, -ECONNRESET);
 	}
+
+	if (!list_empty(&dep->cancelled_list))
+		goto restart;
 }
 
 static int dwc3_gadget_ep_dequeue(struct usb_ep *ep,
@@ -2867,8 +2874,12 @@ static void dwc3_gadget_ep_cleanup_completed_requests(struct dwc3_ep *dep,
 {
 	struct dwc3_request	*req;
 	struct dwc3_request	*tmp;
+	struct list_head	local;
 
-	list_for_each_entry_safe(req, tmp, &dep->started_list, list) {
+restart:
+	list_replace_init(&dep->started_list, &local);
+
+	list_for_each_entry_safe(req, tmp, &local, list) {
 		int ret;
 
 		ret = dwc3_gadget_ep_cleanup_completed_request(dep, event,
@@ -2876,6 +2887,9 @@ static void dwc3_gadget_ep_cleanup_completed_requests(struct dwc3_ep *dep,
 		if (ret)
 			break;
 	}
+
+	if (!list_empty(&dep->started_list))
+		goto restart;
 }
 
 static bool dwc3_gadget_ep_should_continue(struct dwc3_ep *dep)
-- 
2.30.2


--UkX4noAi4Ifo6Ocb--
