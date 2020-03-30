Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9AAD1980CF
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 18:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgC3QST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 12:18:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:53742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727437AbgC3QSS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Mar 2020 12:18:18 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 486DF206CC;
        Mon, 30 Mar 2020 16:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585585098;
        bh=C8H41guE4+23olgfo1+0z8XUUYQNiKD3edu8ydBBQNw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l4dhnBBZ+qpuStglbLpJ3ah4bWXIXmxP21FMvuIyqZCyTMQQbm1emd0jjHudVS/f5
         g46b6y4TCJ2LYup6I1vBc5ey2HJFUjcQkIzBOFe4DRCDNyqxkI32Qd748kp1NuvJGI
         G+PzlhFc16ETPJC0h4xKmOJrwLBQS7mA7+1s/32c=
Date:   Mon, 30 Mar 2020 12:18:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     dhowells@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] afs: Fix some tracing details" failed to
 apply to 4.14-stable tree
Message-ID: <20200330161817.GI4189@sasha-vm>
References: <1585575122165119@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1585575122165119@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 30, 2020 at 03:32:02PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 4636cf184d6d9a92a56c2554681ea520dd4fe49a Mon Sep 17 00:00:00 2001
>From: David Howells <dhowells@redhat.com>
>Date: Fri, 13 Mar 2020 13:36:01 +0000
>Subject: [PATCH] afs: Fix some tracing details
>
>Fix a couple of tracelines to indicate the usage count after the atomic op,
>not the usage count before it to be consistent with other afs and rxrpc
>trace lines.
>
>Change the wording of the afs_call_trace_work trace ID label from "WORK" to
>"QUEUE" to reflect the fact that it's queueing work, not doing work.
>
>Fixes: 341f741f04be ("afs: Refcount the afs_call struct")
>Signed-off-by: David Howells <dhowells@redhat.com>

Conflict with f044c8847bb6 ("afs: Lay the groundwork for supporting
network namespaces"). I've fixed and queued it up.

-- 
Thanks,
Sasha
