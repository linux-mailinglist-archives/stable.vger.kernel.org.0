Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB7F3A883C
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 20:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhFOSIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 14:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhFOSIZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 14:08:25 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D96DC06175F
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 11:06:20 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id r14so26192298ljd.10
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 11:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/qEnYGVBFFbXkq5KvPtZ4VbGgkzVQLvVMcAHO89ymh8=;
        b=e+3T/cGDneNOGM3EtKxeixqgv8YFwnvwg34OxaUhgby81ngEvynd8vT7uwKn1KT5QB
         zaLKV/9hkcVwq9vBc4W8Q+j/hGY0oSBcJzEo4gNAKsdpjROcgagHK3m7fXzTZxydLd8x
         ve/cAzVBacvLZLBxquthJRg8JOKVTAwQvlIb4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/qEnYGVBFFbXkq5KvPtZ4VbGgkzVQLvVMcAHO89ymh8=;
        b=OAdCPxXK4AyIXbvSd/17EXI9/VSujIHi1hu0MhIR1+N/EAOfkqzR6IFBfUchSgg+gv
         CdthOZFFtj+G1LsMlN7TI3gtwxdl4hhcruvqaCvn9FVZJHQUDRA9hscAZetSCo3oCXD8
         xXWfNniJHfCK+RyITNP8F9OyMOnp7N1O/sGQe0GD3tIB+SpDbl3bAVKSYM8ZSr9KrxR2
         +ZDcp2JnspOjysH3w2+OIDJuNvfwxJiLfEVlKzDQPwN2NZPqvVo1kFJiYCuPpPyEiALq
         IKADDiIDavDYPJbHWMYEA5KbidxPBsos4PAkc4uVDM6BhNYZt+M+KrbXNd/YCNDO4IZd
         +9Rg==
X-Gm-Message-State: AOAM532DrAYMuwsUsY6NdbPebr5DKQnpuBREKmRgYkbj8cgMfC6X7r9m
        5ftgMawgPhECM4Y1KhK/4pBBaB4uZh2kzg77
X-Google-Smtp-Source: ABdhPJwFnDa9IcQ/wAJ7wFwN3uww2vyqMIICDUqc+fMMmxgjqwBpOrEiU/zuWkmAFgInAUA45V5LfQ==
X-Received: by 2002:a05:651c:169b:: with SMTP id bd27mr729683ljb.219.1623780378718;
        Tue, 15 Jun 2021 11:06:18 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id k3sm1920717ljm.5.2021.06.15.11.06.16
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 11:06:17 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id e25so5158087ljj.1
        for <stable@vger.kernel.org>; Tue, 15 Jun 2021 11:06:16 -0700 (PDT)
X-Received: by 2002:a2e:b618:: with SMTP id r24mr775343ljn.48.1623780376308;
 Tue, 15 Jun 2021 11:06:16 -0700 (PDT)
MIME-Version: 1.0
References: <YMjTlp2FSJYvoyFa@unreal> <CAHk-=wiucGtZQHpyfm5bK1xp9vepu9dA_OBE-A1-Gr=Neo8b2Q@mail.gmail.com>
 <YMjnRLdctAzzP0Fi@unreal>
In-Reply-To: <YMjnRLdctAzzP0Fi@unreal>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 15 Jun 2021 11:06:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjjzn7Yu42LMJosifcJm6Qp6O0DszTbFyWcdYZ6zQ4eeA@mail.gmail.com>
Message-ID: <CAHk-=wjjzn7Yu42LMJosifcJm6Qp6O0DszTbFyWcdYZ6zQ4eeA@mail.gmail.com>
Subject: Re: NetworkManager fails to start
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        stable <stable@vger.kernel.org>,
        linux-netdev <netdev@vger.kernel.org>,
        youling 257 <youling257@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 10:45 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> Yes, this patch fixed the issue.
> Tested-by: Leon Romanovsky <leonro@nvidia.com>

Thanks.

I've committed that minimal fix, although we still seem to have some
unexplained failure in this area for android 7 cm14.1 user space.

This has turned out to be fairly painful, with multiple fixes on top
of fixes, and there's still something odd going on. Grr.

           Linus
