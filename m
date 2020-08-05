Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD7323CEE7
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 21:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbgHETJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 15:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728451AbgHES4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 14:56:18 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2868BC0617A2
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 11:37:45 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id x9so48881316ljc.5
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 11:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nKsScY2SqSaUIDsji3DbH9vARZk9m+RN1f7vMYsfm00=;
        b=iAliQHEzDRAQlVI4XXSIEEBg6aUSSqeUoOj5qeHelfslSrZjysk8SyFIWWp/lX6uob
         Y8tkVHXeObZH8duByODMzQ/D2ShBAyXocCIroPsjHVj8OZ4FmcQmee7YLXFV+OzoqNW2
         aU7z0qneabKk64K5/XBM2l0UNPBabO/B59bN8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nKsScY2SqSaUIDsji3DbH9vARZk9m+RN1f7vMYsfm00=;
        b=oz7UJWLZsS9fctHYTduHVvFkWG7g45O3r6Nyku0w7NGaR5kEe2HUTlg0oiGYzQga/b
         fJLf760h8uhj+rp+l1h13eyM6jE2EBjKZ4Z5FgAokPvZJqliCpoBvrAil+HbwonyfGFS
         8nHflWQw8Ieu71rhWmVJ5qHfHJGrI782s+CSDEl/TikR6azDQJpTDJZ47rzt9vNSj7Qk
         vInfLXi8ml+h/H/PN3y+SkC+LkHHuOUsvMyOpqnvBtPKpAdDFX6stpG81q84on55WNXf
         r6onh7gTou9Bje23QOKuNmR4Se5CE7YxnUTnDMVdQZXmGunDfIEqCCJU2tneUelsfq3O
         1k2g==
X-Gm-Message-State: AOAM530+4IvouT+FgJH6XMW/5Dtr1eTYruUx74eUfEA7p17bilQVqUEO
        2McwRo+8xV5vgQu3buKKSuSrfnf3wSM=
X-Google-Smtp-Source: ABdhPJy4IJywY05uFLGEcY7n+dCxhf1X8yj0uEWdsnEXYYsLe9vmWfn3xkKbrnejVjm566zKED3QJQ==
X-Received: by 2002:a2e:9bcd:: with SMTP id w13mr2003818ljj.189.1596652656617;
        Wed, 05 Aug 2020 11:37:36 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id t18sm1316055ljc.126.2020.08.05.11.37.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 11:37:34 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id w25so13398445ljo.12
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 11:37:33 -0700 (PDT)
X-Received: by 2002:a2e:b008:: with SMTP id y8mr1797749ljk.421.1596652652831;
 Wed, 05 Aug 2020 11:37:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200805153506.978105994@linuxfoundation.org> <CA+G9fYv_aX36Kq_RD5dAL_By4AFq=-ZY_qh7VhLG=HJQv5mDzg@mail.gmail.com>
 <71a132bf-5ddb-a97a-9b65-6767fd806ee9@roeck-us.net>
In-Reply-To: <71a132bf-5ddb-a97a-9b65-6767fd806ee9@roeck-us.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 5 Aug 2020 11:37:16 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi0WGMs6+Jz6rXbQO4mfzf8LGVc3TwmCdz0OwRtj7GgMQ@mail.gmail.com>
Message-ID: <CAHk-=wi0WGMs6+Jz6rXbQO4mfzf8LGVc3TwmCdz0OwRtj7GgMQ@mail.gmail.com>
Subject: Re: [PATCH 5.7 0/6] 5.7.14-rc1 review
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marc Zyngier <maz@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 5, 2020 at 11:24 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> Same with older versions of gcc. I don't see the problem with the
> mainline kernel.

  https://www.youtube.com/watch?v=-b5aW08ivHU

> I think this is caused by more recursive includes.
> arch/arm64/include/asm/archrandom.h includes include/linux/random.h
> which includes arch/arm64/include/asm/archrandom.h to get the definition
> of arch_get_random_seed_long_early (which it won't get because of
> the recursion).
>
> What I don't really understand is how this works with new versions
> of gcc.

Is that the only place it triggers?

Because the trivial fix would be something like the appended, which is
the right thing to do anyway.

              Linus

diff --git a/arch/arm64/kernel/kaslr.c b/arch/arm64/kernel/kaslr.c
index 07c4c8cc4a67..9ded4237e1c1 100644
--- a/arch/arm64/kernel/kaslr.c
+++ b/arch/arm64/kernel/kaslr.c
@@ -11,8 +11,8 @@
 #include <linux/sched.h>
 #include <linux/types.h>
 #include <linux/pgtable.h>
+#include <linux/random.h>

-#include <asm/archrandom.h>
 #include <asm/cacheflush.h>
 #include <asm/fixmap.h>
 #include <asm/kernel-pgtable.h>
