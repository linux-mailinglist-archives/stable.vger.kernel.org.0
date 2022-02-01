Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166D74A54A9
	for <lists+stable@lfdr.de>; Tue,  1 Feb 2022 02:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbiBAB3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 20:29:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbiBAB3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 20:29:54 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8554DC061714;
        Mon, 31 Jan 2022 17:29:54 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id i1so13030121ils.5;
        Mon, 31 Jan 2022 17:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XqG+5fzWY0U/afJ1BOIAM3pbp3MnppszbdOcfZ9XLtI=;
        b=eT2WsnR1FbC9brGF7W8Vk+2VvwRznIY7/OT1DBCaXlkXWT5CErIBQYnrko4m6aUHpB
         3EwaWXW2Ro5EwSP84rvJhBFjlrim3RxiB0fPdAISf7x32lWX1PiV0IERjh0T1I53muxI
         ozmuuMjZ5IwZCUUBZRDQeZyJywS8mId6mt1GympL0FHCYqy7ROo/2zzxIqJZ9t5k/EyW
         KRBRj975mgUledpaue1zFz1KY072gGM96y0gxZqAKvLSZCac0lag0xrBG32VVNz9jyLj
         58b6VD0bVR6CeUHzzcAK4WyZdHuStG5rxXgYiqEHuFtfg0s7HuRGtoVNr5lNJNSC4DVF
         SxDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XqG+5fzWY0U/afJ1BOIAM3pbp3MnppszbdOcfZ9XLtI=;
        b=rdEZL6SJOwUBuoDPzsfL4Zc2n/7NNWVFDnd2c/M3TgPT0b22uexbR6M0cIdiGMPlal
         CXKRrx/LmANEWPuMrAvqyjInMrrqfIgW6NmG7Ec72PYGFhHBdTGzR54tx8IO1dvmNKSZ
         wGLaZ+nkKs3K9z3lhQBnKyvlNnAOtQAmhO8nXh2+I1zY2XXr3IbrZWM4Vzb5K/CJVgqG
         yXzpytfh+E0obNjgKDei8ZErRVh9UoLxy+dzPB5OiguPhtWtnnnLMOxCW4kagX08MwWl
         UFciV32zdOpO6WwmFohtVEcpPRwZK+5YTssVwVSkMLNJD05F+BJzdynH1wf7S6kKX6A+
         8oLw==
X-Gm-Message-State: AOAM533X2UFrbxzATe91Uy/eUuL42XH3B0cJMn0iZKsYC/cxhJV9GSRb
        LkCz37xz57cUxOvsLdVfJ0FY0tmAEkI/ngljGFg=
X-Google-Smtp-Source: ABdhPJycYZQaQXEpbkKL1+jfKuIawVfU7apQcaQUm9HHQzIFTwYqhllQUkV2zogf0BOGtvghjEJDVcZtEj64Hv7xtAk=
X-Received: by 2002:a05:6e02:20cd:: with SMTP id 13mr13460574ilq.225.1643678993918;
 Mon, 31 Jan 2022 17:29:53 -0800 (PST)
MIME-Version: 1.0
References: <20220131105233.561926043@linuxfoundation.org>
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Mon, 31 Jan 2022 18:29:43 -0700
Message-ID: <CAFU3qoarf16tYk6JxRn=R07pp4G4ZjU1RDTO+xwgLyAzsVU_Ag@mail.gmail.com>
Subject: Re: [PATCH 5.16 000/200] 5.16.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 31, 2022 at 8:38 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.5 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Hi Greg,

Compiled and booted on my test system Lenovo P50s: Intel Core i7
No emergency and critical messages in the dmesg

./perf bench sched all
# Running sched/messaging benchmark...
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

     Total time: 0.436 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 7.170 [sec]

       7.170326 usecs/op
         139463 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
