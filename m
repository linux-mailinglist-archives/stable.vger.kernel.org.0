Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4E22A0EB0
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 20:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgJ3Tbj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Oct 2020 15:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727450AbgJ3Taf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Oct 2020 15:30:35 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002F2C0613CF
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 12:30:34 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id t22so3436756plr.9
        for <stable@vger.kernel.org>; Fri, 30 Oct 2020 12:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ysr7bKM2lzNExseYzJ/9rb4f5LUk91heylbWQW32gL0=;
        b=PT8GKpUxNBmOZcZcqeGjYmWIOI+RmJY6OrXfE6mvOTPb5t/nrRZCcUoR+WtJNdxoNA
         YZZcfcYqgWvcx/nNY0/BOupXKJBwxOKCNXtrDBFI2ClrbdXicbDXUPneujuZfALTTPeb
         xQ9DiBZIwo05kw86W+mPGctr8j2CoSAGcObWZWg0j9gCpSGqS4hGOX2bbbDZ8ZwokkNs
         7da2ZvN8jt9qz2/UfOT/+IyFeqeYi5S0IWlKaSqFSRQr+oYph39OsXE6kXzETE7q8RrN
         YHgYNDHRYaFpU+CkGw55aIKbawiPhDbmFS0t+1eG4HAOo2Mwgu8cGFnz7L4rUaCNQLxX
         XO8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ysr7bKM2lzNExseYzJ/9rb4f5LUk91heylbWQW32gL0=;
        b=iXwpYg//eL6VOjZPlmYR2iyEtwn4uuUK8oqWhWOTgiYZVZVoFesNNsRR6eAofefwsF
         djimBgZUVtvvhq8cn5dINRrFd1xYc48O9CaK58wsl2Sl3DSTlXz30Enz72mmMcGPrL1Y
         USzzv9wIjsb7WeSOcBXCreR5BoyZH3TbE/USj7kqEhobSNDX1fj/sNSjh3em5+oVCqty
         JZ4b4Ez/UNlG+K+O1CMPLA40XIDLRjRZSyIO/NADN6Dmdkq6Jh+nlZy2oZmH4eCEStxT
         z15IcR35TuVw/WL7wBh1H1RaWHcyv4eqZ/Va10Cng/svdTPmpPFAGCW17PTAq4ZqMtcX
         yBTw==
X-Gm-Message-State: AOAM532U1zcKkOz3urgEhBpltzu1w2tDJfRVrJqdys3Nh9ky6cszOpR6
        Zsat2SwALccKgYX455VNxsRA3zHsIye4wzI8GMFReg==
X-Google-Smtp-Source: ABdhPJxh5kzc2t9fnqgU/0q2i5JfwzsIns6sTtRB36RN5DppjCt1PdKACpcKDN3va6abHDLvYCMzOuNsAsubRxRXdSc=
X-Received: by 2002:a17:902:8a8b:b029:d5:f871:92bd with SMTP id
 p11-20020a1709028a8bb02900d5f87192bdmr10310927plo.10.1604086234238; Fri, 30
 Oct 2020 12:30:34 -0700 (PDT)
MIME-Version: 1.0
References: <CA+SOCLLXnxcf=bTazCT1amY7B4_37HTEXL2OwHowVGCb8SLSQQ@mail.gmail.com>
 <20201029110153.GA3840801@kroah.com> <CAKwvOdkQ5M+ujYZgg7T80W-uNgsn_mmv8R+-15HJjPoPDpES1Q@mail.gmail.com>
 <20201029233635.GF87646@sasha-vm> <CAKwvOd=MLOKH-JoaiQcahz3bxXiCoH_hkfw2Q_Wu7514vP3zkg@mail.gmail.com>
 <20201030004124.GG87646@sasha-vm> <CA+SOCLJqVjy9QRssE9AZ1nQBwZB5mAcanpVTVOd4kO3=r5jrfA@mail.gmail.com>
 <20201030014930.GB2519055@ubuntu-m3-large-x86> <CA+SOCL+b_qvvEHFz5g416Kdfzy3nZQnizow9-C9k1pw=ZeoKJA@mail.gmail.com>
In-Reply-To: <CA+SOCL+b_qvvEHFz5g416Kdfzy3nZQnizow9-C9k1pw=ZeoKJA@mail.gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 30 Oct 2020 12:30:23 -0700
Message-ID: <CAKwvOdmK5i9debF+8X6HVmKyAeVYQOf7d1HHFLNUCGN-DhhitA@mail.gmail.com>
Subject: Re: Backport 44623b2818f4a442726639572f44fd9b6d0ef68c to kernel 5.4
To:     Jian Cai <jiancai@google.com>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Manoj Gupta <manojgupta@google.com>,
        Luis Lozano <llozano@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 30, 2020 at 12:24 PM Jian Cai <jiancai@google.com> wrote:
>
> Hi Nathan,
>
> Thanks for all the tips! I have fixed the issues mentioned in your comments and used git send-email to resend the patch as recommended. FYI I used the Message ID of this thread but it created a new thread anyway.

No, I'll bet you're using gmail which has issues showing threads when
the subject is changed or is not `Re: <old subject>`. If you look at
lore, it's correct:
https://lore.kernel.org/stable/20201030014930.GB2519055@ubuntu-m3-large-x86/T/#t
Just that you forgot to cc stable. :^P  Don't worry about it; I forget
to do that still myself.
-- 
Thanks,
~Nick Desaulniers
