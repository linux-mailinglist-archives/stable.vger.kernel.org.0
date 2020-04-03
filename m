Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B92AE19E114
	for <lists+stable@lfdr.de>; Sat,  4 Apr 2020 00:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732299AbgDCWbG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 18:31:06 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:45814 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732261AbgDCWbG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 18:31:06 -0400
Received: by mail-il1-f194.google.com with SMTP id x16so8933179ilp.12
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 15:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DReb85Qq2spLZofMdlhxOcB9wBI8gRgFAWJWWxwUWJ4=;
        b=p3Vg07HugMx59Hl9uRmPF02wEopJiGjScvyc3cNbTeTRK1rQSLC3F4Y/NGyk5p+Zwr
         ULGOUm2S4lrONnGuw9wvmKM+KDRg8zgmcwwh3hSfWuqh9EG3bwc47cBBRDDuIAYuGehs
         FgNSlLtuf2IK1yvpbOe8jxqtgM7CYu0JCoNAFjc8OemAfoVGvMgMFJVpobTSdZKb746t
         2AapcWxlhAm5ylae+d4K+Ic+NsfnHvKM0gEnu0Cq3ClfKFN+MZxqRoyS8Ql8304a6iI0
         GHoW+SRbFNkFkl390lYbTxiNkVFOp76+uCxIYWOMQtVO+ajueeImpAo+q1UuI+A6t/B1
         LoLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DReb85Qq2spLZofMdlhxOcB9wBI8gRgFAWJWWxwUWJ4=;
        b=r2Z7TsnChUdIUfewAVQWEaXaLvpVW/zQqB1wBfA+mCvq1Q9CA3QX9AqjdvKaLzV+Pw
         dQicRYFPY+yxnjE1ND+1OpbbETBaLtn5wfdnqwrHffU7PYuSui1aub7ALM0WbmUTmv2v
         OxI8lx97xpveksa2iTang4sKege101ubKgxfJMDm/PsPsS3Oh5KCwwwdyYqlisIReHU7
         4ncVKIBsZbA5dBdq6eTwlRCrzLIKQ+PWeKjAOkZLwktd5+W1AXU6WlUODeRdYuK5DFQH
         1w6VtGXCx/aE6QnopXBcnC88Q1NQjbHwC/1xXb3ccool/101b7NrjSiFQ5X62Fuzlog2
         PFZg==
X-Gm-Message-State: AGi0PuYIaeQAwfEyhYTOBTMYSMrh9DVDwI8CuZUsm4jFCnWdrPxOaM8Y
        iyXasGU6c/qUKbUin3Kw4p9KnVcAZe43z7iO+9KgTS9yyx0=
X-Google-Smtp-Source: APiQypJf2GmCn3gmBx+nWPt/1eYEgC0Gi5yeAkMwOpENRC5/vQnc6AnfdowU4Z7zHJEmwA4oqRHHGshHUAOZcaIHlV8=
X-Received: by 2002:a92:364f:: with SMTP id d15mr11686016ilf.0.1585953064618;
 Fri, 03 Apr 2020 15:31:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAGvU0HkVUE_mQY8AUjieRcRrD38gdJRE+CbDuenMxnU6DAFOSA@mail.gmail.com>
 <20200403092032.GE3740897@kroah.com>
In-Reply-To: <20200403092032.GE3740897@kroah.com>
From:   Giuliano Procida <gprocida@google.com>
Date:   Fri, 3 Apr 2020 23:30:48 +0100
Message-ID: <CAGvU0H=+KrQRV7SUkVjWudKi7i1LqmGheRfVofKDV0i8Qgd=bg@mail.gmail.com>
Subject: Re: backport request for use-after-free blk_mq_queue_tag_busy_iter
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg.

I also have 4.14 and 4.9, I'll send them on for comparison.

I will try 4.4 but, as one call site doesn't exist and the other
didn't have any locking to start with, I'd like to try to reproduce
the issue first.

I should have some spare time for this soon.

Giuilano.

On Fri, 3 Apr 2020 at 10:20, Greg KH <greg@kroah.com> wrote:
>
> On Wed, Apr 01, 2020 at 05:47:02PM +0000, Giuliano Procida wrote:
> > This issue was found in 4.14 and is present in earlier kernels.
> >
> > Please backport
> >
> > f5bbbbe4d635 blk-mq: sync the update nr_hw_queues with
> > blk_mq_queue_tag_busy_iter
> > 530ca2c9bd69 blk-mq: Allow blocking queue tag iter callbacks
> >
> > onto the stable branches that don't have these. The second is a fix
> > for the first. Thank you.
> >
> > 4.19.y and later - commits already present
> > 4.14.y - f5bbbbe4d635 doesn't patch cleanly but it's still
> > straightforward, just drop the comment and code mentioning switching
> > to 'none' in the trailing context
> > 4.9.y - ditto
> > 4.4.y - there was a refactoring of the code in commit
> > 0bf6cd5b9531bcc29c0a5e504b6ce2984c6fd8d8 making this non-trivial
> > 3.16.y - ditto
> >
> > I am happy to try to produce clean patches, but it may be a day or so.
>
> I have done this for 4.14.y and 4.9.y, can you please provide a backport
> for 4.4.y that I can queue up?
>
> thanks,
>
> greg k-h
