Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E15E0172A17
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 22:27:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgB0V1X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 16:27:23 -0500
Received: from mail-ot1-f53.google.com ([209.85.210.53]:39306 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgB0V1W (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 16:27:22 -0500
Received: by mail-ot1-f53.google.com with SMTP id x97so617250ota.6
        for <stable@vger.kernel.org>; Thu, 27 Feb 2020 13:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JZYnaJ9HWU6etbohvKqz8ttfZNwJEE76SG7tMr7053E=;
        b=sYHhD0ew3jlpNB063916/6SrGhZo/ltAmt4CX5wzeuAk2ytJEwdpuUsdrmfKtlO+r4
         DIPkCKU5qG1RKBB3omLT/fm1X3k/Ae0w+bUK5K1PdPlerfFffVJSwQ4pd0LTvIwdvg3u
         egbYOiOgFv6Wc+Dgqznwsl0wMoxirsUMv3dZttnYhQqq9j7KL+t6B+kyWAz2yya79P1H
         1VmXXJ8RGbrvb4YHXEoM790fNSKLlaaBrl5QQPUr0fNDteVOdt7KLrtcQMNDBB+PhCY2
         FBFfho7dvTqTMNTJNTZeFuNThx5edLkLpWx957GTiY70s/6QBDeEasE/88RdFi3cYD4p
         4bhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JZYnaJ9HWU6etbohvKqz8ttfZNwJEE76SG7tMr7053E=;
        b=b8hpoM7yeywZu+FN9khaG1bEBMgmjBEjktVdQZIbMm2YoZ0jlyemaIfr+bU3YxF0Je
         5ZUcZI3k1LQcVJLCYDxeCIgsxV5Ki8KyShIVhxaDj8Upneo2YDn4qpcAOusba6q+rOzC
         QbSIHJA34CfQtJVw6JCi15tHlh8AK1pD11gP0uhkPKs0khYS2YKFrRvGMFbh4H+5fWeU
         bZnTIx3jAF9XIjEjvYS+qHqun1gWtVoZ9a6JYtbm4PfuRfcYCu8dEv5hHdDi4oVGC+LP
         uzIg+tjIN/IR2heUQqPpj8Al4kyyMvxVoYbPV2/HvMoTaW5MTxUzisUDYgtH4aJzGTrw
         G6JA==
X-Gm-Message-State: APjAAAVBTX2eY8AGAqJHlLlw6PYreStlYKkr20cwcmuhOxonaWA886b1
        izSiEtqozHuii5YtcZOUY4gv7pQa0hrWWoCo9nLkQg==
X-Google-Smtp-Source: APXvYqw8ecEa8Qw32UQJLv4dOn7rLo/gJAMcvsTLaGUQRHiz2CqjkA4cejT2yaFsnu+2d6EQqqx8m2++ksujyuYJuUA=
X-Received: by 2002:a05:6830:22ee:: with SMTP id t14mr732410otc.236.1582838841411;
 Thu, 27 Feb 2020 13:27:21 -0800 (PST)
MIME-Version: 1.0
References: <CAGETcx-0dKRWo=tTVcfJQhQUsMtX_LtL6yvDkb3CMbvzREsvOQ@mail.gmail.com>
 <20200227095107.GB579982@kroah.com>
In-Reply-To: <20200227095107.GB579982@kroah.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 27 Feb 2020 13:26:45 -0800
Message-ID: <CAGETcx-RCS84nWAU7BPZSaXei5VCV1X+S48eYoSjYhgmjaFq0A@mail.gmail.com>
Subject: Re: device link patches on 4.19.99 breaks functionality
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 1:51 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Fri, Feb 21, 2020 at 01:21:00AM -0800, Saravana Kannan wrote:
> > 4.19.99 seems to have picked up quite a few device link patches.
> > However, one of them [1] broke the ability to add stateful and
> > stateless links between the same two devices. Looks like the breakage
> > was fixed in the mainline kernel in subsequent commits [2] and [3].
> >
> > Can we pull [2] and [3] into 4.19 please? And any other intermediate
> > device link patches up to [3].
> >
> > [1] - 6fdc440366f1a99f344b629ac92f350aefd77911
> > [2] - 515db266a9da
> > [3] - fb583c8eeeb1 (this fixed a bug in [2])
>
> "up to"?
>
> 515db266a9da does not apply to 4.19, so should I just drop [1] instead?
>
> Or, can you provided a backported set of patches so I know exactly what
> to apply?

Let me take a stab at backporting [2] and [3] or whatever else might
be necessary. What git repo/branch did you want me to try that on?

-Saravana
