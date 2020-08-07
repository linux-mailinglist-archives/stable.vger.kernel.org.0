Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7AF323F28C
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 20:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgHGSKh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 14:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgHGSKh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 14:10:37 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2958C061756
        for <stable@vger.kernel.org>; Fri,  7 Aug 2020 11:10:36 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id v4so3169155ljd.0
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 11:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZuMZhLaLnOL/xHC8VZQJDfaqHK+dWPlzzoa/rHVDySY=;
        b=hp3wruGBgMl3qDowQy031caRIO4JiMrZVpDijEr1AkV+ZTBT55IiLiOnOOYUAfiLNJ
         vpXZ5maf7VrbTancPdYdV5CSaDlXcoWjNjxXQLcvYpo+SfeAQ6K3YqTTiDXRwPbMuBYh
         2TEW+2b62x8SXQcL767MXDD6KRoZvSOoL63RU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZuMZhLaLnOL/xHC8VZQJDfaqHK+dWPlzzoa/rHVDySY=;
        b=E6S/76mZVyAKT5zz0PfIWGRQUiyrpOt8NIyhXgLi57orC0pwrjJVao2mxdtGHUorCb
         igub1/ZQEG29PVl7EXmhGBnTgX59g+Pa+Mjtf+8bkR+9yNIV0/0a6JSxqI0xAqLp7gsM
         vJrxMNAwW43dczNQpFMDCrD+WTqULj5LMrYuMVmTndUC8RxLET/h/pWC5ZXfduz+uFBv
         WoYpmjzxPTROfF82/g2WN9HOgy+Nic7x4ml1Jd35xy2yVaM0mKU7+klZY+mr/3PHfBUd
         YHD5flSCyXeH1V4cFPDIF76S1XvRoU20jPOgrXjib4h/buFizqKVqnof1qbqsk4l2Fj4
         Nhyw==
X-Gm-Message-State: AOAM5313G/MolAkbaD993h+QB+qnDODUxYz0AG5mSFO0m9cT4U5Blf95
        FdgDVZ3DfRGXq3khA7VAWRGuQVZcNAs=
X-Google-Smtp-Source: ABdhPJy2dgVCPmFk7OBMlWyVRHnhjrdQyEar02w4yc1NXZayYyQmNy+oVEk7nDzbVr1BxIAE+9WfcQ==
X-Received: by 2002:a2e:9a03:: with SMTP id o3mr7036767lji.48.1596823833949;
        Fri, 07 Aug 2020 11:10:33 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id l26sm4506441lfj.22.2020.08.07.11.10.32
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 11:10:33 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id s9so1462799lfs.4
        for <stable@vger.kernel.org>; Fri, 07 Aug 2020 11:10:32 -0700 (PDT)
X-Received: by 2002:ac2:58d5:: with SMTP id u21mr6821303lfo.31.1596823832127;
 Fri, 07 Aug 2020 11:10:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200807174302.GA6740@1wt.eu> <C74EC3BC-F892-416F-A95C-4ACFC96EEECE@amacapital.net>
In-Reply-To: <C74EC3BC-F892-416F-A95C-4ACFC96EEECE@amacapital.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 7 Aug 2020 11:10:16 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj4p3wCZpD2QU-d_RPTAsGiAUWHMiiVUv6N3qxx4w9f7A@mail.gmail.com>
Message-ID: <CAHk-=wj4p3wCZpD2QU-d_RPTAsGiAUWHMiiVUv6N3qxx4w9f7A@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Willy Tarreau <w@1wt.eu>, Marc Plumb <lkml.mplumb@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 7, 2020 at 10:55 AM Andy Lutomirski <luto@amacapital.net> wrote=
:
>
> I think the real random.c can run plenty fast. It=E2=80=99s ChaCha20 plus=
 ludicrous overhead right now.

I doubt it.

I tried something very much like that in user space to just see how
many cycles it ended up being.

I made a "just raw ChaCha20", and it was already much too slow for
what some of the networking people claim to want.

And maybe they are asking for too much, but if they think it's too
slow, they'll not use it, and then we're back to square one.

Now, what *might* be acceptable is to not do ChaCha20, but simply do a
single double-round of it.

So after doing 10 prandom_u32() calls, you'd have done a full
ChaCha20. I didn't actually try that, but from looking at the costs
from trying the full thing, I think it might be in the right ballpark.

How does that sound to people?

                 Linus
