Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65748AD1EF
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 04:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732947AbfIICaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 22:30:55 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44760 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732530AbfIICaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Sep 2019 22:30:55 -0400
Received: by mail-io1-f68.google.com with SMTP id j4so25205324iog.11
        for <stable@vger.kernel.org>; Sun, 08 Sep 2019 19:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r1kBM8+FpCn5DwArkBe4qisyPtgF0D1ChYizbMJcwFY=;
        b=f99c3fWlG0hXsPYKN1ha72hlU183tKwmYztOnrgbbGD5XZnzv4em8Y9vsOCyx9DSlS
         dUarEbTMEHWjtf7eMG0g1uFW7cCPXMx5p0J73Z8s8I6CRNHP8Zfzt4ZOVacCn4ecwMKi
         tUyk9xKtYjU6KIkeibQe6Tqske60T+U1+UxfFSO0nsEKzwnqUPOhy8SbKNjrUNqBPu+g
         2yT3JE09WyZsoKHDzmVrPK/+8W4FLmypaWCiQcjXU8sCBo4qs83TwZ8p6lOfl/1AZYD7
         lxwZNrzwMqKFix5+OwAXYkkSWgSlpHeKMG6xTdTNegui8bKsIZ0tUYMxsMgExlO3Xea7
         JUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r1kBM8+FpCn5DwArkBe4qisyPtgF0D1ChYizbMJcwFY=;
        b=PQRx2jzeG6YmMJ9hwI2fNKGTOkpYTH9vWrQ8LZxdNxaXak+S1XKLMot7vd6IJ4JO5b
         d/Hd+wf0B9xRX0BUF36VU+m9XPxJt2t/XVMGhJGOD01l8DofZodfCCfoK6r0RjOZX8+l
         kCcWRhMGNRo+6mjDePa45ecJpafRSGmTaBPJWvLSFW+Yi6y++tOqczTsXuMHK5nrFwsv
         mQhokmu2slhHvCs29f8cnWzmVugX7tEvqhU/171DXkOx/u4gDDLThSnYlqLtu4jOxHqB
         GBBy/q+eZRGDqblQJIvPofqzrVlc2T+Gin7Bbvxg60zIo1m014tbpSngvnCvf9VvS+zc
         O3TA==
X-Gm-Message-State: APjAAAUwZYdU3h0sU/u+QpOddvxWnG8dZxDW9bFx1Shaixb92uQKbxJU
        JnGuzcnqBVt2R5flMb+SwvI5lNnl/o7cuS9hqxU=
X-Google-Smtp-Source: APXvYqyrCRQRwtZO2cJ0+ag91SP1gVT+1Xx5uH6/S0Y8lrBOq+8Dv2NKb0Hllam9Zz1D3Zr/9La3rNfeotnolKfrwNI=
X-Received: by 2002:a02:608:: with SMTP id 8mr23052655jav.88.1567996254437;
 Sun, 08 Sep 2019 19:30:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190908024800.23229-1-anarsoul@gmail.com>
In-Reply-To: <20190908024800.23229-1-anarsoul@gmail.com>
From:   Qiang Yu <yuq825@gmail.com>
Date:   Mon, 9 Sep 2019 10:30:43 +0800
Message-ID: <CAKGbVbt056DyZHer1bKnAv8uBCX6zbsWeMjE6AQy8HYQf7L1wg@mail.gmail.com>
Subject: Re: [PATCH] drm/lima: fix lima_gem_wait() return value
To:     Vasily Khoruzhick <anarsoul@gmail.com>
Cc:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        lima@lists.freedesktop.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Oh, I was miss leading by the drm_gem_reservation_object_wait
comments. Patch is:
Reviewed-by: Qiang Yu <yuq825@gmail.com>

I'll apply this patch to drm-misc-next.

Current kernel release is 5.3-rc8, is it too late for this fix to go
into the mainline 5.3 release?
I'd like to know how to apply this fix for current rc kernels, by
drm-misc-fixes? Can I push
to drm-misc-fixes by dim or I can only push to drm-misc-next and
drm-misc maintainer will
pick fixes from it to drm-misc-fixes?

Thanks,
Qiang

On Sun, Sep 8, 2019 at 10:48 AM Vasily Khoruzhick <anarsoul@gmail.com> wrote:
>
> drm_gem_reservation_object_wait() returns 0 if it succeeds and -ETIME
> if it timeouts, but lima driver assumed that 0 is error.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> ---
>  drivers/gpu/drm/lima/lima_gem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/lima/lima_gem.c b/drivers/gpu/drm/lima/lima_gem.c
> index 477c0f766663..b609dc030d6c 100644
> --- a/drivers/gpu/drm/lima/lima_gem.c
> +++ b/drivers/gpu/drm/lima/lima_gem.c
> @@ -342,7 +342,7 @@ int lima_gem_wait(struct drm_file *file, u32 handle, u32 op, s64 timeout_ns)
>         timeout = drm_timeout_abs_to_jiffies(timeout_ns);
>
>         ret = drm_gem_reservation_object_wait(file, handle, write, timeout);
> -       if (ret == 0)
> +       if (ret == -ETIME)
>                 ret = timeout ? -ETIMEDOUT : -EBUSY;
>
>         return ret;
> --
> 2.23.0
>
