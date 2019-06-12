Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A71B642E59
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 20:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfFLSHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 14:07:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54584 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728442AbfFLSHu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 14:07:50 -0400
Received: from mail-wr1-f69.google.com ([209.85.221.69])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <guilherme.piccoli@canonical.com>)
        id 1hb7f2-0005T2-9S
        for stable@vger.kernel.org; Wed, 12 Jun 2019 18:07:48 +0000
Received: by mail-wr1-f69.google.com with SMTP id e8so2395118wrw.15
        for <stable@vger.kernel.org>; Wed, 12 Jun 2019 11:07:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9OGRUmhqlKrRJMqfWIDmM/X2ZfNPUoSa1OGXxMXehSE=;
        b=VlJd8EfIqT9cgCg79ad7lSD+b04v8vK7OcPUUoWvWNumP99KGan/T5oZF6E9OH0SPg
         SGA+xaPTUfFmBBSHjVEfbL+YoNuucOxyzXuyRCbqRupxvT2lu+lsT5kuFVeddLPk4tD3
         WJm2rWqxi7eN8rdLF23oxDLAxEutmjjOzTU8A8qP3QZLKer2H/4IwRSzAJ4IGlgPmB6D
         p3gMCi6M6i2iWaEdvkChBhbd3Zhe0hg7bLrbW3Nv1hRqqUGk4Gyd6EGQr5uz31JfTuHe
         mcgbFCC0b0vNy5Te23UuP5LLFsXp3M1wQFu4GZvfV161n6Wn27rT7r8ckBOIme0pA/1s
         vkcQ==
X-Gm-Message-State: APjAAAUysPH3DJNRmVQAACkmBqfA4U4lzyUysEIJ7xRID6LJPP98RqnD
        TfY0sIitKXS2/1QfUwwmElJ+Ddsw35k2MK07TEa8QEhlA4Gcw9r3IixjytQYXgqTNEKCp5mWZme
        BoqX33Z7nzc7zpdbo5m/YN2g/ZVFueoVsMcG9CsiL7fwMLvcDww==
X-Received: by 2002:adf:ee48:: with SMTP id w8mr33383258wro.308.1560362868064;
        Wed, 12 Jun 2019 11:07:48 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxOqEGqIlqv+f9AXu73DLfKUKScc/uWI7hpSWZQ2cTHVf6FRayN7hzBGmeRUIbYbzbQeUXLl0TkfWRTbRPD8HU=
X-Received: by 2002:adf:ee48:: with SMTP id w8mr33383235wro.308.1560362867807;
 Wed, 12 Jun 2019 11:07:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190523172345.1861077-1-songliubraving@fb.com>
 <20190523172345.1861077-2-songliubraving@fb.com> <3d77dc37-e4be-2395-7067-5a9b6a71bf3a@canonical.com>
 <20190612164958.GB31124@kroah.com>
In-Reply-To: <20190612164958.GB31124@kroah.com>
From:   Guilherme Piccoli <gpiccoli@canonical.com>
Date:   Wed, 12 Jun 2019 15:07:11 -0300
Message-ID: <CAHD1Q_yoda7MUWDU5H4FKGK6tgmFXEEK9cvg20QJNrsgNgHnZQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 12, 2019 at 1:50 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jun 12, 2019 at 01:37:24PM -0300, Guilherme G. Piccoli wrote:
> > +Greg, Sasha
>
> Please resend them in a format that they can be applied in.
>
> Also, I need a TON of descriptions about why this differs from what is
> in Linus's tree, as it is, what you have below does not show that at
> all, they seem to be valud for 5.2-rc1.

Thanks Greg, I'll work on it. Can this "ton" of description be a cover-letter?
Cheers,


Guilherme

>
> And I need acks from the maintainers of the subsystems.
>
> thanks,
>
> greg k-h
