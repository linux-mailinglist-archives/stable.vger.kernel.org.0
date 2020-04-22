Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFA31B41B8
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731762AbgDVKy7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731054AbgDVKy4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 06:54:56 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF25BC03C1A8;
        Wed, 22 Apr 2020 03:54:55 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id s10so1388275iln.11;
        Wed, 22 Apr 2020 03:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qbTF/6WmCkCfEIdriAM1kmliqTmGRinJAcRxbEj4b+o=;
        b=GGJjGzCKvcvFvEW9/4GVAuFLkz3biI8fYmQaRXZIfBzbbjnkJJsPu+9fMJRGq2299y
         WVi8hHMJZt2d5mpBoRRtiDs62ILUCFUE9Ntz6l0QwQZCtDSQiJrv+idS//YkPobi5zfG
         9dcXZiCZR5sjzOS/vfgzBmPslX64F7iJ0Z5GDAmMJUKs37vzKtyVWbzRF6f5A3GIuPJF
         MCDRJbp1a6jltHGq0LAjiWwueWkkaafePfn871/S5kHphDCI8Qe4/R+kTG4f8mUsDOXb
         lXgaggFh3voCWmybYfaTI+rESz13UKY35lfqylKR77luvlFtmroNLLdwYl77PJR9Y+AN
         qwLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qbTF/6WmCkCfEIdriAM1kmliqTmGRinJAcRxbEj4b+o=;
        b=ialUim3c4+QvaCFTpCz+0PDzRd29YKah/PYn0UvmLsROFLmVeQWIwEQouyh1/qZBWO
         GVcZ5eLU3Z3GUM0a4Fm7277LKt2KXztrex2TC6Yl2t7Gtu+PVRMzh+Fxp3URSKz0J7PL
         GJJvGNwTY/kU9FuryorfXU0OmpiNr7FBGVGYCZN+tTlHYwfHaHB7nlurhX9YV/8mU7H6
         EbqVkFmXKFe0sfGFOEgO+ln4K/E9NkroU4ixkPzfMD08XuTgkUhgyre9UNzZ7LGDlvMa
         6pJH7aI/JwA88jswpof8nUVQEORzRtlI0Fcrr45GqpLPdVzi2JnOcRFWu2mOxOWB9whG
         shNg==
X-Gm-Message-State: AGi0PuYtTW6P1puHytduC0wf6jAElRqvRX0SUEWFTa2TriUTYrdz7vxV
        EGRXnGJ9b5FLJh5XWhwDadThUJI/CQDeplr0opc=
X-Google-Smtp-Source: APiQypL3aEJoYT/ir7jYLSXWokkuifO05C5RCcBccYb9L3IA5KrZYKikP5zAsU+AH/S8APS2NglRyYT0QgH109JIPB4=
X-Received: by 2002:a92:1fc5:: with SMTP id f66mr24891442ilf.157.1587552895234;
 Wed, 22 Apr 2020 03:54:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200422095031.522502705@linuxfoundation.org> <20200422095042.013796362@linuxfoundation.org>
In-Reply-To: <20200422095042.013796362@linuxfoundation.org>
From:   Marian Klein <mkleinsoft@gmail.com>
Date:   Wed, 22 Apr 2020 11:54:43 +0100
Message-ID: <CAA0DKYqAoeY8YSWVQCfcq4CQ5iF35eoYm--5SNrFL46+m46fag@mail.gmail.com>
Subject: Re: [PATCH 5.4 061/118] hibernate: Allow uswsusp to write to swap
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Domenico Andreoli <domenico.andreoli@linux.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Everyone
I am glad the official patch made it into 5.4 finally.
Well done everyone. Now distros should pick it up quickly , especially
ubuntu 20.04 Long Term Support.
Your most faithful fan
Marian

On Wed, 22 Apr 2020 at 11:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Domenico Andreoli <domenico.andreoli@linux.com>
>
> [ Upstream commit 56939e014a6c212b317414faa307029e2e80c3b9 ]
>
> It turns out that there is one use case for programs being able to
> write to swap devices, and that is the userspace hibernation code.
>
> Quick fix: disable the S_SWAPFILE check if hibernation is configured.
>
> Fixes: dc617f29dbe5 ("vfs: don't allow writes to swap files")
> Reported-by: Domenico Andreoli <domenico.andreoli@linux.com>
> Reported-by: Marian Klein <mkleinsoft@gmail.com>
> Signed-off-by: Domenico Andreoli <domenico.andreoli@linux.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/block_dev.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index d612468ee66bf..34644ce4b5025 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -34,6 +34,7 @@
>  #include <linux/task_io_accounting_ops.h>
>  #include <linux/falloc.h>
>  #include <linux/uaccess.h>
> +#include <linux/suspend.h>
>  #include "internal.h"
>
>  struct bdev_inode {
> @@ -1975,7 +1976,8 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
>         if (bdev_read_only(I_BDEV(bd_inode)))
>                 return -EPERM;
>
> -       if (IS_SWAPFILE(bd_inode))
> +       /* uswsusp needs write permission to the swap */
> +       if (IS_SWAPFILE(bd_inode) && !hibernation_available())
>                 return -ETXTBSY;
>
>         if (!iov_iter_count(from))
> --
> 2.20.1
>
>
>
