Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6A211FA7E
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 19:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfLOSkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 13:40:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:55994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfLOSkH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 13:40:07 -0500
Received: from localhost (unknown [73.61.17.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66C0B206D7;
        Sun, 15 Dec 2019 18:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576435206;
        bh=/U+b1fJIxF7ytZ1OAsOjHaaTSNPfagyofdfgamhxPQI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gmmP6XSyTybQQqPENUMIsshHuGIYEQeWYDLpy5lPaN/tBvLKeJ5u+KPfXY7NHt7HW
         DRAvifkecmYje8cWpfygGVWQbw8VAtEbwKJg/6D9DZdBqVw82DimwHo4J31oknHfwK
         LIaA2HB4jAvfRhBTlsWHaZsThInyaNozOSQeWQaA=
Date:   Sun, 15 Dec 2019 13:40:05 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     wenyang@linux.alibaba.com, heikki.krogerus@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] usb: typec: fix use after free in
 typec_register_port()" failed to apply to 4.19-stable tree
Message-ID: <20191215184005.GN18043@sasha-vm>
References: <157640796159177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <157640796159177@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 15, 2019 at 12:06:01PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
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
>From 5c388abefda0d92355714010c0199055c57ab6c7 Mon Sep 17 00:00:00 2001
>From: Wen Yang <wenyang@linux.alibaba.com>
>Date: Tue, 26 Nov 2019 22:04:52 +0800
>Subject: [PATCH] usb: typec: fix use after free in typec_register_port()
>MIME-Version: 1.0
>Content-Type: text/plain; charset=UTF-8
>Content-Transfer-Encoding: 8bit
>
>We can't use "port->sw" and/or "port->mux" after it has been freed.
>
>Fixes: 23481121c81d ("usb: typec: class: Don't use port parent for getting mux handles")
>Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
>Cc: stable <stable@vger.kernel.org>
>Cc: linux-usb@vger.kernel.org
>Cc: linux-kernel@vger.kernel.org
>Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>Link: https://lore.kernel.org/r/20191126140452.14048-1-wenyang@linux.alibaba.com
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Fixed up context and queued up for 4.19.

-- 
Thanks,
Sasha
