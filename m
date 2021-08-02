Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 612CB3DDF95
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 20:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbhHBSuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 14:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhHBSuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 14:50:09 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54BB9C06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 11:50:00 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id z128so3571815ybc.10
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 11:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jlekstrand-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P/uyuMe+KXvhXgEAfGyAFi5lTv7MdpXbhBdlFK0tsZ0=;
        b=dKbfy5zWEEfRjXBTTIBbBGnN5Kp0pb2Nz1IVI9qICWSNk5LZcX45mdqxH7lhBmZtnQ
         uPUZPYK4rJoJH7cB56TCHf+Vj7RZNwOZKhDenDjG3bMIScY1Lq2W+mlXLRMq1uIOCBP6
         sxAhsSqfykMB7qVwTsCav94QLWpmHUTHjfyhDDB2NBF24ta9YhcQORn3hOL9Qyr90izD
         BUhDLzlfzZ9zpePztqBCoeepdhpaN8x5wCbmtaKOKKctBhvrvlPO4Y1t18JrZAFaLshi
         mgQwNsCn16ahezMzeP1Z1geVvfkKuxWLIjO4J2oa/CreJNgCFU8JsAqhcmONNH6c4mFG
         wdVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P/uyuMe+KXvhXgEAfGyAFi5lTv7MdpXbhBdlFK0tsZ0=;
        b=G1ZhG0L6JtLpa8lzlFWabCtgKVgEl3D8fL5cXI0N0wQW2/TM35uOO0fh8djosAvm+3
         X1xwzOd37sl/NFZ/V1scDThZMqopjo0PTc5FtSt4rduUMJHtVnKpELFKfp70Qcsz1nu1
         GEvTCh8bzH3zM0e1MVVyQrb50M9fJxMR3a1SDt9h1LlthxVeU3P2DKIP4ftjfCGihOTj
         H2hHVdGdlh5ENBWoicqKUFvsC4g4kuSUfN72c0+sbhshal+HtUaBr8GietfMX4uPPr9m
         xAmQv7JKkwrlnVBvzBt2kA+PN1QvozmdAC2bVzwr1oHQPMZUCsCjr376fKcOQAMac4n1
         D4cQ==
X-Gm-Message-State: AOAM530zW1C2NBctTHG6K0a6HgaORIlrzw0u2J2tJ3AIMyTi1usu3/O9
        qDIUgkXB73+dDUX1dbBx4bWEEOvGdoi6OXiNUix4UymlqLAeVw==
X-Google-Smtp-Source: ABdhPJwpOrwanAWNeHZmx7jZxyJIqG6rYsn+HK44fjP3XgAXGYyxaTf4vOQTLGymfIQxaIVSkN53alnFM1H6SRyNnv4=
X-Received: by 2002:a25:d714:: with SMTP id o20mr21834861ybg.287.1627930199392;
 Mon, 02 Aug 2021 11:49:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210727163024.3536962-1-jason@jlekstrand.net> <YQTxXYk8ORBYxWCe@kroah.com>
In-Reply-To: <YQTxXYk8ORBYxWCe@kroah.com>
From:   Jason Ekstrand <jason@jlekstrand.net>
Date:   Mon, 2 Aug 2021 13:49:48 -0500
Message-ID: <CAOFGe95ypAwsycqnG6r3bhnnnH+20A5WoCtkQ7bTtEQ21GzWFg@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Revert "drm/i915/gem: Asynchronous cmdparser"
To:     Greg KH <greg@kroah.com>
Cc:     stable <stable@vger.kernel.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jul 31, 2021 at 1:44 AM Greg KH <greg@kroah.com> wrote:
>
> On Tue, Jul 27, 2021 at 11:30:23AM -0500, Jason Ekstrand wrote:
> > commit c9d9fdbc108af8915d3f497bbdf3898bf8f321b8 upstream.  This version
> > applies to the 5.10 tree.
>
> <snip>
>
> I don't know if you noticed the other failure messages, but there were
> other patches in this area that we had to drop from pending stable
> releases.
>
> So if you could please review all of them, and resubmit all missing
> patches as a series, so that we can apply them to the needed 5.10.y and
> 5.13.y trees, that would be wonderful.  As it is, I can not take just
> this one, because it depends on other patches in the series from what I
> can tell.

As far as I can tell, there were only two patches of mine that need to
go to stable.  There's a third that got stabled tagged but it's a
false alarm.  It's also just a docs fix.

I've sent two series to stable@vger.kernel.org, one for 5.10 and one
for 5.13.  They're clearly labled in the cover letter.

--Jason
