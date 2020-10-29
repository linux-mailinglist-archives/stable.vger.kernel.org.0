Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326D129F939
	for <lists+stable@lfdr.de>; Fri, 30 Oct 2020 00:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725379AbgJ2XqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 19:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbgJ2XqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 19:46:06 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BD7C0613CF
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 16:46:05 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id r10so3637453pgb.10
        for <stable@vger.kernel.org>; Thu, 29 Oct 2020 16:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kGjqAOdcC5QA0DRyEF0KSvVoN/sesHrA9HjD2QObBEA=;
        b=byD4ZuKzmQJwen0Px0eAhntfvWNP0bdFDrZn6l8dLtefqQuuqQKElTVD69EdEkAUEi
         +YqONnWHjkMz1fS4x7D+dbkZu0D79gw3tBeMwrG0pVvw5GmYVT2vkzWQxgU4R1QgFwkt
         QQGJ5vc8Rn7qbn3JaC4ZUaAnCWGg0b5kytPUl7Lo5Wg5Xe5ExUBo+8UOeGPJ32V9oRqY
         avtUKmvWn2xWfyGX+imo/7Gqtai4RaPHwGX3yVdFFFm3IKMjPxBYYEvtgfWJasKWRzW5
         DmeL0uxLXs8V02hJdOl242tkcoeu6GCOwtIlRuaRzFu+fl01O7yz536tEQtdBaRtYli4
         NkzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kGjqAOdcC5QA0DRyEF0KSvVoN/sesHrA9HjD2QObBEA=;
        b=crTiw90hs3HIu6IpWuQIqar9S4GPYx3KHuYaCtJM73eJdl/ziUF5FW8VAnsLWU7M2O
         WYNTvQJ1LiCaEvMV/V5YJOzBSoXC5MjttYOB+uE+1sNhJw/BHr6strMq54e13sB4wH9W
         XXM6TSX2gLEQr73Uu0S1sk3QslhgAMz2pgv5+Szg3gtZ+he1fuvNsA+ktY8yPIo62GBQ
         tn5569sd9mIt/v6u37rn710i5BGWo4hylRTqnHryj3h+YfgUXhd5MLDz0D0gSa0D/krl
         QQVp1JhM4+KeLu4BbrO/u7VbqMrxvbwGP5XuUGaCb053YPH+S3hZeBszBh8Dqnb2lNwu
         rONw==
X-Gm-Message-State: AOAM532EDWf6OP+eS/yxgsMsxzwwlu0ZxRwfRvU5lKDfI2bC9Q+EG3M9
        NNX3FqcEV7I5jQyVgNNuuUp19S+EWBAowXnJgX4HxQ==
X-Google-Smtp-Source: ABdhPJxviljmY9+mLV2iAwebovZEYN2mccFF6yYPtYM4WQh4oURd61zF3VU4iF8hxAAJvL8VdR71QbE6zNaKKkso+yA=
X-Received: by 2002:a63:2f41:: with SMTP id v62mr5972972pgv.10.1604015164347;
 Thu, 29 Oct 2020 16:46:04 -0700 (PDT)
MIME-Version: 1.0
References: <CA+SOCLLXnxcf=bTazCT1amY7B4_37HTEXL2OwHowVGCb8SLSQQ@mail.gmail.com>
 <20201029110153.GA3840801@kroah.com> <CAKwvOdkQ5M+ujYZgg7T80W-uNgsn_mmv8R+-15HJjPoPDpES1Q@mail.gmail.com>
 <20201029233635.GF87646@sasha-vm>
In-Reply-To: <20201029233635.GF87646@sasha-vm>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 29 Oct 2020 16:45:52 -0700
Message-ID: <CAKwvOd=MLOKH-JoaiQcahz3bxXiCoH_hkfw2Q_Wu7514vP3zkg@mail.gmail.com>
Subject: Re: Backport 44623b2818f4a442726639572f44fd9b6d0ef68c to kernel 5.4
To:     Sasha Levin <sashal@kernel.org>
Cc:     Jian Cai <jiancai@google.com>, "# 3.4.x" <stable@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Manoj Gupta <manojgupta@google.com>,
        Luis Lozano <llozano@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 29, 2020 at 4:36 PM Sasha Levin <sashal@kernel.org> wrote:
>
> On Thu, Oct 29, 2020 at 11:05:01AM -0700, Nick Desaulniers wrote:
> >Hi Jian,
> >Thanks for proactively identifying and requesting a backport of
> >44623b2818.  We'll need it for Android as well soon.
> >
> >One thing I do when requesting backports from stable is I checkout the
> >branch of the stable tree and see if the patch cherry picks cleanly.
>
> btw, an easy way to get an idea of possible dependencies is to look at
> the dependency repo :) For this commit on 5.4:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/sashal/deps.git/plain/v5.4/44623b2818f4a442726639572f44fd9b6d0ef68c

Why you guys never tell me this before? :P Very cool, how is the
dependency chain built? Is it built for every commit?
-- 
Thanks,
~Nick Desaulniers
