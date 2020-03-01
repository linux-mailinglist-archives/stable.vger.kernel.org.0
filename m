Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1B14174C91
	for <lists+stable@lfdr.de>; Sun,  1 Mar 2020 10:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgCAJic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Mar 2020 04:38:32 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40515 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgCAJib (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Mar 2020 04:38:31 -0500
Received: by mail-ot1-f68.google.com with SMTP id x19so1998200otp.7;
        Sun, 01 Mar 2020 01:38:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PZkFkXYlFxgkmvJgFU55SlOGglVdT51q/lgkk0P1mmk=;
        b=nHEv3nkWqdcwCkQGPM3ObZqDUVnUXIxjtBoKoNMHGoIEkWM2W0hNDk3bIPVV1MI0WK
         ivPeBIN6UsQpCcsFobhNtF8+jboXSZ1UnzAzieX6shSsjm3E5fr9LbAmqwrQOKE6PnRe
         jJ2jsP243WpjlHk3Kh9k9leHzeTsmo+B3bPh7wPJlTOuQLGGqAnn04Bsy1hbBDiBvdkG
         h/rmiBjomivli0KpwEAsbIMsCiQmvJk8EDvRFsuG2+Jnb2pvZYsggEzIexlZNUMRDpsE
         U5pggSXV8Iaqm/NPpBV80Xum0+y3Jmi2kX2NjKgykbzXrAnf62OmjWl+F5KQcZP3gnaW
         cnAQ==
X-Gm-Message-State: APjAAAU3zHPNw5YNC914QUMLldJLKa7JEvqV7NMKgKJKdzt38RUkgDX+
        V80zoQRyvy0C+Xj+hvDkB6npBgIJuzzlQOLB4N7iwA==
X-Google-Smtp-Source: APXvYqxpOedhwTtpKPqHlp7kho/JLyNBlapXOA/q5dVMKVUDW8GKWOrjBfkuKhsSVEeE3DT/OEyxkZWqctyO9lnMTTo=
X-Received: by 2002:a05:6830:100e:: with SMTP id a14mr9462713otp.297.1583055509293;
 Sun, 01 Mar 2020 01:38:29 -0800 (PST)
MIME-Version: 1.0
References: <20200227132255.285644406@linuxfoundation.org>
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sun, 1 Mar 2020 10:38:18 +0100
Message-ID: <CAMuHMdXPzqmhj1E0AywSiThMQK1AfR4Rp19DV7W8uSp=8p_Zgg@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/237] 4.14.172-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Feb 27, 2020 at 2:55 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 4.14.172 release.
> There are 237 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.172-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:

Given you do have a git branch containing these commits, is there any
chance you can update your scripts to insert a real (sorted) shortlog
here?
That would make it easier for us contributors to track what has been
backported.

Many thanks in advance!

> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 4.14.172-rc1
>
> Nathan Chancellor <natechancellor@gmail.com>
>     s390/mm: Explicitly compare PAGE_DEFAULT_KEY against zero in storage_key_init_range
>
> Thomas Gleixner <tglx@linutronix.de>
>     xen: Enable interrupts when calling _cond_resched()
>
> Prabhakar Kushwaha <pkushwaha@marvell.com>
>     ata: ahci: Add shutdown to freeze hardware resources of ahci
>
> Cong Wang <xiyou.wangcong@gmail.com>
>     netfilter: xt_hashlimit: limit the max size of hashtable

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
