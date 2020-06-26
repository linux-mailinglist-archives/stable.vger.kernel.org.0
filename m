Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F59D20BCD8
	for <lists+stable@lfdr.de>; Sat, 27 Jun 2020 00:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgFZWkV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jun 2020 18:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgFZWkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jun 2020 18:40:17 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041EDC03E979
        for <stable@vger.kernel.org>; Fri, 26 Jun 2020 15:40:18 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e8so5586334pgc.5
        for <stable@vger.kernel.org>; Fri, 26 Jun 2020 15:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Qiw/4HqpKwpuAtYDhrx0VRiSxfjJMMRWJH1BewxoU94=;
        b=ElvD1uMJMkIninVnGWVHv6GjQ28Y7Lm4w/pAJVf6qvS7VQhCql7sxpZEfH9uWTq/Wp
         2wysk47sGligNjrUQMXRBlAkhSabR5x5ZB21ds2+Gc/oqbg3UrzT5GsqLVIWdHf+irAq
         An9hz6B7OmPDit4iDvWkn5KAUllnE+38ieVvlQiLCnMyJV+u3gPUj2ZTrVPt8CdpzEt8
         0yVjwNV1lsTIGkswAOxK/9ouobMtmQpFJhEK7mcdCL4WGaJ5cSL+p4XffkyGpahBaNUp
         6V6u9UtnWQzcf/hpfSTBMguhcj+fLjGwNPXmAV+h5OjQ+/U+V5gRqldQbWmcvAlrYaNN
         OGEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Qiw/4HqpKwpuAtYDhrx0VRiSxfjJMMRWJH1BewxoU94=;
        b=hBU7ov5hDK3EHPrXjUr+uV56n+z9sXCyJqBaiF15bSIvTRtwgldHZIF4Feni/JbN3W
         RLWfD+D1/oDHwCV/m9jZfoPfoyM++X/twTXPImRgGWXpoNfUkljmnMztazmUh4ucW95R
         mkLwlRWGsUmaveqJxgWAr9FCiwzSnVkbjFmtmj9UsZlLYL+L6k/rfvKzuh5FgvTu6NIR
         acg8OHMUZdBKtYV6btXQyHte4klASHVeNCFItQzY7hyTNr02hw699rKlaThSmn4uqCpT
         +7hCN/v8FJe5ean4bTj7WkzgTmJ8wSHvFmnGIvDSW+XDahNXe4ZtIzjD1NXyycoSokHO
         g93A==
X-Gm-Message-State: AOAM533IlehwBnIqpm/cMdG9V+IH75n9hMizizDtJk4aNqy4Hsr7b+Aw
        biG0AHXfsig2C7aQLaV62KtfIfJS
X-Google-Smtp-Source: ABdhPJzi/ygzpKT4j49eHKDx87JFbYb6VmUYW3ybJ5OvD1oH/nCN7w3EzMjDXNOvaw8IfL8OhJoGZQ==
X-Received: by 2002:a05:6a00:2b0:: with SMTP id q16mr4746076pfs.104.1593211217522;
        Fri, 26 Jun 2020 15:40:17 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h3sm3309350pjz.23.2020.06.26.15.40.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 26 Jun 2020 15:40:16 -0700 (PDT)
Date:   Fri, 26 Jun 2020 15:40:15 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: Patches to apply to stable releases [6/17/2020]
Message-ID: <20200626224015.GA256865@roeck-us.net>
References: <20200617235308.132274-1-linux@roeck-us.net>
 <20200626140413.GA4098272@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626140413.GA4098272@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 26, 2020 at 04:04:13PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jun 17, 2020 at 04:53:08PM -0700, Guenter Roeck wrote:
> > Upstream commit 64611a15ca9d ("dm crypt: avoid truncating the logical block size")
> >   upstream: v5.8-rc1
> >     Fixes: ad6bf88a6c19 ("block: fix an integer overflow in logical block size")
> >       in linux-4.4.y: b8cd70b724f0
> >       in linux-4.9.y: 5dbde467ccd6
> >       in linux-4.14.y: 0c7a7d8e62bd
> >       in linux-4.19.y: a7f79052d1af
> >       in linux-5.4.y: 6eed26e35cfd
> >       upstream: v5.5-rc7
> >     Affected branches:
> >       linux-4.4.y (conflicts - backport needed)
> >       linux-4.9.y (conflicts - backport needed)
> >       linux-4.14.y
> >       linux-4.19.y
> >       linux-5.4.y
> >       linux-5.6.y
> >       linux-5.7.y
> 
> Can you provide a backport for this?
> 

That one is easy: 4.9.y and 4.4.y are not affected even though ad6bf88a6c19
has been applied there. Reason is that 64611a15ca9d only applies if
bc9e9cf0401f1 ("dm crypt: don't decrease device limits") is in the tree.
This in turn is a fix for 8f0009a22517 ("dm crypt: optionally support
larger encryption sector size"). None of those is in v4.4.y/v4.9.y.

> > Upstream commit 2f02fd3fa13e ("fanotify: fix ignore mask logic for events on child and on dir")
> >   upstream: v5.8-rc1
> >     Fixes: b469e7e47c8a ("fanotify: fix handling of events on child sub-directory")
> >       in linux-4.9.y: 987d8ff3a2d8
> >       in linux-4.14.y: 515160e3c4f2
> >       in linux-4.19.y: 20663629f6ae
> >       upstream: v4.20-rc3
> >     Affected branches:
> >       linux-4.9.y (conflicts - backport needed)
> >       linux-4.14.y (conflicts - backport needed)
> >       linux-4.19.y
> >       linux-5.4.y (already applied)
> >       linux-5.6.y (already applied)
> >       linux-5.7.y (already applied)
> 
> Do you have a backport?
> 
I _think_ this doesn't apply either because it also depends on
837a393438475 ("fanotify: generalize fanotify_should_send_event()")
which is not in v4.14.y and earlier, but I may be wrong. That code
isn't exactly easy to understand.

> For all other patches you listed, I've queued up the missing ones, some
> already got merged since you sent this out.
> 
Thanks!

Guenter
