Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4280A23D03B
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 21:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgHETpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 15:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728959AbgHETpt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 15:45:49 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10DDC06174A
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 12:45:48 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id x24so7568316lfe.11
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 12:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YMknd1+dlXX/Q3YM8+W65fV77VdzsmUF/OU4h6Xq9xE=;
        b=ZAog/SvHzVeXNMZb2Fj5fRotY3ezW+cicXN46stQ1/EcG2JvDXQPNisMdRpFYwto3Q
         Dv3M/sBUceZ5Dyhdv1XWGkFmj4MJymVOF7batv5qAvZjxsoQDutBTN4BJSi6RVDxcp3D
         +gb2PdLmzPW3FgOKTKFIsirWz5+LHUS5bP2gk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YMknd1+dlXX/Q3YM8+W65fV77VdzsmUF/OU4h6Xq9xE=;
        b=eCb4J4P5dk9zTDxYVizmlsL7b/nK60e1YzsrrFsmRK1X9JJWDRv9nanYT+HRXVeznO
         dyKN0Molve/M4VEfB0ogePED839jrd6+nuVCVFzYZSfrk111xDKP/8p7miLGjKK1DnG7
         01mp+zlRgBTMPf/LOJlJAfeJca1wzcOLfT3j1VIRdp7zWRXqafBmm5UnGYwulvFH463n
         pqsCUq8lLB3AIfY87Zwgb/xTm6DcBpkNhEzGdopCPnGUxxLVbF7SVwgTE/K4Ut3fGSq0
         mzgUTZ8fxunSWDKzw15E8bnCjGhCLcwDHaH/wZQgY2a7bYEfXwTT5emaztfF1dwcyXin
         dDzA==
X-Gm-Message-State: AOAM533iYGwA/n+4eicNZQZxdGAt1nrG8f0t/imWJfMUGiJ3QRP+MYFu
        cadFpZRWNocCx6eDo9nmBLvvhuh08O8=
X-Google-Smtp-Source: ABdhPJyOu2EYTx8d/QLa/ewkNqscLoPj0lyp36g+oHISHEZZ4Uk2VAbboavAGnD2SziKC3/YN6eXew==
X-Received: by 2002:ac2:4adb:: with SMTP id m27mr2344337lfp.90.1596656745828;
        Wed, 05 Aug 2020 12:45:45 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id i7sm1377916ljg.54.2020.08.05.12.45.42
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 12:45:43 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id x24so7568168lfe.11
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 12:45:42 -0700 (PDT)
X-Received: by 2002:ac2:522b:: with SMTP id i11mr2306959lfl.30.1596656741926;
 Wed, 05 Aug 2020 12:45:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200805153506.978105994@linuxfoundation.org> <CA+G9fYv_aX36Kq_RD5dAL_By4AFq=-ZY_qh7VhLG=HJQv5mDzg@mail.gmail.com>
 <71a132bf-5ddb-a97a-9b65-6767fd806ee9@roeck-us.net> <CAHk-=wi0WGMs6+Jz6rXbQO4mfzf8LGVc3TwmCdz0OwRtj7GgMQ@mail.gmail.com>
 <7e1c9df5-d334-461d-56fc-53625c6ca163@roeck-us.net>
In-Reply-To: <7e1c9df5-d334-461d-56fc-53625c6ca163@roeck-us.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 5 Aug 2020 12:45:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj1m3VFa6Sz96gxNjKCOH21jDuuODm46-VAukD5YGc1yA@mail.gmail.com>
Message-ID: <CAHk-=wj1m3VFa6Sz96gxNjKCOH21jDuuODm46-VAukD5YGc1yA@mail.gmail.com>
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

On Wed, Aug 5, 2020 at 12:24 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 8/5/20 11:37 AM, Linus Torvalds wrote:
> >
> > Because the trivial fix would be something like the appended, which is
> > the right thing to do anyway.
>
> Correct.

I'll take that as an Ack, and also remove the crazy reverse include
from archrandom.h that most definitely shouldn't be there.

It's now commit 585524081ecd ("random: random.h should include
archrandom.h, not the other way around") in my tree, because a grep
for "archrandom.h" shows that now the only place it exists is
<linux/random.h> and a few files that cannot possibly affect arm64
(because they are on x86 and powerpc, neither of which has that insane
reverse include).

               Linus
