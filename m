Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25B6AD03AE
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 01:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbfJHXAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 19:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbfJHXAb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 19:00:31 -0400
Received: from localhost (unknown [131.107.159.163])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59A2B21721;
        Tue,  8 Oct 2019 23:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570575630;
        bh=qP7sXeUq0jaAh5JebtbM4i+utoRIDax1oWTEesCxc7U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=L2KndYwad/C1ZaLSriiHyHY+87z8mR9F+2dqJhThHgNj18x928+InAZpIiTmcKSyP
         ujQ35VriKKUMoVJZB8mHlJEgFJxiGE37/yFhT6XRwftL6XOLmqZSwEeOOYDpD+W2DK
         NHp4/s8eqvvgvxASj4fTWiFImEg+0obVo0a/mVZw=
Date:   Tue, 8 Oct 2019 19:00:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     rostedt@goodmis.org, acme@redhat.com, akpm@linux-foundation.org,
        jolsa@redhat.com, namhyung@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tools lib traceevent: Do not free
 tep->cmdlines in" failed to apply to 4.19-stable tree
Message-ID: <20191008230030.GJ1396@sasha-vm>
References: <1570520058216250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1570520058216250@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 09:34:18AM +0200, gregkh@linuxfoundation.org wrote:
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
>From b0215e2d6a18d8331b2d4a8b38ccf3eff783edb1 Mon Sep 17 00:00:00 2001
>From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
>Date: Wed, 28 Aug 2019 15:05:28 -0400
>Subject: [PATCH] tools lib traceevent: Do not free tep->cmdlines in
> add_new_comm() on failure
>
>If the re-allocation of tep->cmdlines succeeds, then the previous
>allocation of tep->cmdlines will be freed. If we later fail in
>add_new_comm(), we must not free cmdlines, and also should assign
>tep->cmdlines to the new allocation. Otherwise when freeing tep, the
>tep->cmdlines will be pointing to garbage.
>
>Fixes: a6d2a61ac653a ("tools lib traceevent: Remove some die() calls")
>Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>Cc: Andrew Morton <akpm@linux-foundation.org>
>Cc: Jiri Olsa <jolsa@redhat.com>
>Cc: Namhyung Kim <namhyung@kernel.org>
>Cc: linux-trace-devel@vger.kernel.org
>Cc: stable@vger.kernel.org
>Link: http://lkml.kernel.org/r/20190828191819.970121417@goodmis.org
>Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Conflicts due to pevent -> tep renames in traceevent. I've fixed it up
and queued on all kernels.

--
Thanks,
Sasha
