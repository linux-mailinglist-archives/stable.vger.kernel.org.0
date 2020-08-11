Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A1F241A00
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 12:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728326AbgHKKy5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 06:54:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728280AbgHKKy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 06:54:57 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E29C06174A;
        Tue, 11 Aug 2020 03:54:57 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id b11so6401733lfe.10;
        Tue, 11 Aug 2020 03:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=70Up9z9wSMaoR2aNY1eUSKhBW91aRmZQ48unQBd8YGA=;
        b=p15OKQ0B1cqUK91WwW3wXcV6A/K6ldC7BspOWe/hTR3w2TTTRSI+Rrm6l4sx2YGNhy
         czP7GhTGSip1Mdzm1Ai3vFQ0wY72RfkwT1sGbCEmCnpl47RG+4CsnAFKKIrgggactmYv
         iKjcxjOhtg0MFA9x9bstmFLNQhu43ZYQ641d+q7bicklCJaC7sriy1GSCWIOrLu9Poi2
         D51PJtObiXlEkpaqm9OE1ebnhJNAo4ALQefYUqUIhGwNmlZmJ/RWjlJFxl1L+PRC2fZO
         PcT1VXpav/UOMC9VVyR9XJrmRBzLUmUHclEe4bYbfy9tkh6oOi2jXnA1I9lMurGkcZIY
         NL5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=70Up9z9wSMaoR2aNY1eUSKhBW91aRmZQ48unQBd8YGA=;
        b=c4otZeY3NUy5hVN0AYouf/Cr/5UpivlOl6zDnMqBgg4jmqgvH0RiJZF3Ue+lrDxg4E
         kJ/NhuivLOFWNOY/xLmVQU1L2AbGAztyhmZcOt1KS6RZGAaQGi7MV8EQNTpY2DdYRzNI
         TAKsXAjN3kNpOdDcBW5lfVHjdl0eIAnsQyzwepxIJztkvQEFy+pNDMMzsRdZYM7X9oND
         WSq8qfK3nYHoyfWj7tNNoYTpH2uyBD9xVm37a5057kTgJyon6szD8Zl3S9OVSVqzxIF8
         V/u6HqK6q+AiuqYPIG7Yagp/1/MSunK02+GfNUnLtFIy+8LOiQm8MyoU67qEilQnXGZu
         8Ifg==
X-Gm-Message-State: AOAM533hqhApmwa+szjzUGHg7F1o4RmuIT7mgMo6KgTtZ/c2iGdGUO0J
        7OHZJZzsOAFsFlebDlcJX6vPb37NrxusPivVEyo=
X-Google-Smtp-Source: ABdhPJzuEz99wYtFWOo4xi9WxDsReSIZ3oPfSCa5vUioSXWWF30eLbWTM9EmGBaCAouUOvsLAkHvqY4lYu4GGfFGRhE=
X-Received: by 2002:ac2:5e2c:: with SMTP id o12mr2938346lfg.71.1597143295578;
 Tue, 11 Aug 2020 03:54:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200810151803.920113428@linuxfoundation.org>
In-Reply-To: <20200810151803.920113428@linuxfoundation.org>
From:   Puranjay Mohan <puranjay12@gmail.com>
Date:   Tue, 11 Aug 2020 16:24:15 +0530
Message-ID: <CANk7y0hRikqFBPfkPmEZRNOubeLXr1Us7w3C3-fwkgfxZET8FQ@mail.gmail.com>
Subject: Re: [PATCH 5.8 00/38] 5.8.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 8:53 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.8.1 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Aug 2020 15:17:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
Successfully booted on my Asus machine running x86_64
No kernel regressions found.
-- 
Thanks and Regards

Yours Truly,

Puranjay Mohan
