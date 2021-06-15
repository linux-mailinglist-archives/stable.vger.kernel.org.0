Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D543A8866
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 20:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbhFOSVb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 14:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhFOSVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 14:21:30 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064F3C061767
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 11:19:25 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id c11so26382597ljd.6
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 11:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Av+6lPQlyv+Sn6WN/JAS+BG6bGNrpjaP5opx8sV0nnc=;
        b=WQuQwtCiT/eoKl6qV5lHYx4lH+0EDr7+nOJYQ1h6yvBunl0woPiervNHkI2DWuHNMS
         q2DNf1dI8WkF30DAo2o970Na/Exs7H+KKRGluFxJ9QUdoPaAT85CHvggye+xAbjL8yy7
         H4ASmIp9BBpePbCJfnUYj3imRXf4Pc4Dds7lg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Av+6lPQlyv+Sn6WN/JAS+BG6bGNrpjaP5opx8sV0nnc=;
        b=VL/PVKXoowkey6KE/YEe5bj2c4nmd4oc5NCbH/9fKhf7DUSmUyNC/kIW1NtvKd3r5u
         TzZ2P6nY1c7SSUxWQoervOKQCOaIW9kNckjwc/T6z9WJsCmJpt7XcmLTaq1RMdSC06Vu
         UOqizfIP1fA6Wme4BUHI47D4ZZejfJK46naryrRma65hi7KXB1DldkKmnAP1QtljB/ZI
         FSILE8icbgd2KHSDu1TVUXyjKVUfdAMAHReTnqSOGChuY2mY92A3jeAXAxIVY+pRAkwV
         45zuafojIzFQdA1Wni8M8AWLc/TUPe89qdk6o8r2QxBnf1ev1VqyF1B8X7gyH3v1/eHv
         Ys3A==
X-Gm-Message-State: AOAM532of2A5TXlQB3hr1/BwKQfkEneotK/9YdTjoYvBusQoM2qFlGED
        yJwAtnGQh8552nR1X4fTPz/D7VHSwz095NMQ
X-Google-Smtp-Source: ABdhPJwJGopZCdh/F+MEx1WyeRJSfJqLTVsjfjhITcWs5zKFRuPdfpeUkePGjvilpuDvI9Gs/UWRqA==
X-Received: by 2002:a2e:b528:: with SMTP id z8mr797302ljm.350.1623781161667;
        Tue, 15 Jun 2021 11:19:21 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id o6sm1883480lfr.268.2021.06.15.11.19.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 11:19:21 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id m21so28442554lfg.13
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 11:19:20 -0700 (PDT)
X-Received: by 2002:a05:6512:374b:: with SMTP id a11mr468018lfs.377.1623781160087;
 Tue, 15 Jun 2021 11:19:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210608171221.276899-1-keescook@chromium.org>
 <20210614100234.12077-1-youling257@gmail.com> <202106140826.7912F27CD@keescook>
 <202106140941.7CE5AE64@keescook> <CAOzgRdZJeN6sQWP=Ou0H3bTrp+7ijKuJikG-f4eer5f1oVjrCQ@mail.gmail.com>
 <202106141503.B3144DFE@keescook> <CAOzgRdahaEjtk4jS5N=FQEDbsZVnB+-=xD+-WtV9zD9Tgbm0Hg@mail.gmail.com>
In-Reply-To: <CAOzgRdahaEjtk4jS5N=FQEDbsZVnB+-=xD+-WtV9zD9Tgbm0Hg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 15 Jun 2021 11:19:04 -0700
X-Gmail-Original-Message-ID: <CAHk-=winAqy0sjgog9oEsjoBWOGJscFYEc3-=nvtzbyjTw_b+g@mail.gmail.com>
Message-ID: <CAHk-=winAqy0sjgog9oEsjoBWOGJscFYEc3-=nvtzbyjTw_b+g@mail.gmail.com>
Subject: Re: [PATCH] proc: Track /proc/$pid/attr/ opener mm_struct
To:     youling 257 <youling257@gmail.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, regressions@lists.linux.dev,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        SElinux list <selinux@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 6:55 PM youling 257 <youling257@gmail.com> wrote:
>
> if try to find problem on userspace, i used linux 5.13rc6 on old
> android 7 cm14.1, not aosp android 11.
> http://git.osdn.net/view?p=android-x86/system-core.git;a=blob;f=init/service.cpp;h=a5334f447fc2fc34453d2f6a37523bedccadc690;hb=refs/heads/cm-14.1-x86#l457
>
>  457         if (!seclabel_.empty()) {
>  458             if (setexeccon(seclabel_.c_str()) < 0) {
>  459                 ERROR("cannot setexeccon('%s'): %s\n",
>  460                       seclabel_.c_str(), strerror(errno));
>  461                 _exit(127);
>  462             }
>  463         }

I have no idea where the cm14.1 libraries are. Does anybody know where
the matching source code for setexeccon() would be?

For me - obviously not on cm14.1 - all "setexeccon()" does is

   n = openat(AT_FDCWD, "/proc/thread-self/attr/exec", O_RDWR|O_CLOEXEC)
   write(n, string, len)
   close(n)

and if that fails, it would seem to indicate that proc_mem_open()
failed. Which would be mm_access() failing. But I don't see how that
can be the case, because mm_access() explicitly allows "mm ==
current->mm" (which the above clearly should be).

youling, can you double-check with the current -git tree? But as far
as I can tell, my minimal patch is exactly the same as Kees' patch
(just smaller and simpler).

Kees, do you see anything?

           Linus
