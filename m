Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1557944DC4A
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 20:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhKKTsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 14:48:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232513AbhKKTsf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 14:48:35 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3485C061766;
        Thu, 11 Nov 2021 11:45:45 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id a129so17711919yba.10;
        Thu, 11 Nov 2021 11:45:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KanKvW9knMkjHLSimNH2i1EojftG486/SdICiXW+qfg=;
        b=IKQsnXqZWJvMVPghQJgbhDzCCV8cpx6a3W8Rut+aHVeIeuEEWlVptGPvyVI2tibdzL
         gMpwXKiIEmr3N6aRa/SwFhygIV2CfXTFYIDp0nNLU14ZPAiQjjCvU617LmOZyEDHSoJz
         M0gwQZO9W/WfQR668D2ajd8NmCUlXDcxpZ3xYBUp2QVA2pBRyDZ5xoxzVqDwWfF4IU96
         SzM+huRzf5WpWLGQ55mghyum5zOtLSjlvTkAKeYuoA/zRY2TEqpfHbG7xxZUWdOtLmce
         02j2j2PHESuWCQaPTom4qkH4kuql9TVMm5N02g8CHM8yPg2sELrtGtTpOU0/iqH54fax
         PbxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KanKvW9knMkjHLSimNH2i1EojftG486/SdICiXW+qfg=;
        b=3EcWAgNJeXRyDUdNQ/HSaKwFmS4Ajrd+kum5c8DTvTIUl7euBkdZZzXT0Fuv0Z5xmO
         dmzGWOe2w55JRUmktUpNMbN5TDcD9TBXf6xX/jW8PwSGGw2yHuIH0tbI4Bf9G6FoymLw
         O9quaaFF9pjhb4aQTm8Z1kP8eiBNcdi7FwronzSGSjhcVX1U2rPufyzVvM99gMTKP8pO
         kQKW3UpOHW0qkMsa5YDsjTw3K6k0CEoNmLlE9kVe//SdurRzNdMc3V5ob15KjkczwvTS
         vp9KQJsERBIA1xpU2g1NvCYUGQ6wWKXClE2GM8j/tjHVxqajtOM0suzQCOlxLa08ODrm
         sdgw==
X-Gm-Message-State: AOAM531GDY0xUZHbOX/zzr2Xpas61L72YVvyq/0piTOqxle0USX6Lp+d
        X+lv5VHZKFOjKARbWrHGqPH557oSIdUKCoYuoC4=
X-Google-Smtp-Source: ABdhPJy70nUyVVTxVdzTjmvH1Mw2XqCn4m+nK8DEGJoA2os2aO9KauZzEi2MpYSXNglAl7NJByGiRgL/w+FPE/dTSCw=
X-Received: by 2002:a25:488:: with SMTP id 130mr10360670ybe.346.1636659945096;
 Thu, 11 Nov 2021 11:45:45 -0800 (PST)
MIME-Version: 1.0
References: <20211110182002.964190708@linuxfoundation.org> <YY0UQAQ54Vq4vC3z@debian>
In-Reply-To: <YY0UQAQ54Vq4vC3z@debian>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Thu, 11 Nov 2021 19:45:09 +0000
Message-ID: <CADVatmPdQzsMk4HSYftUwEQ8PXF5rBVuYN9kp4aOvj7Pd9ds6w@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/21] 5.10.79-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 11, 2021 at 1:01 PM Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi Greg,
>
> On Wed, Nov 10, 2021 at 07:43:46PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.79 release.
> > There are 21 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> > Anything received after that time might be too late.
>
> systemd-journal-flush.service failed due to a timeout resulting in a very very
> slow boot on my test laptop. qemu test on openqa failed due to the same problem.

Build test:
mips (gcc version 11.2.1 20211104): 63 configs -> no new failure
arm (gcc version 11.2.1 20211104): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20211104): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20211104): 4 configs -> no failure

Boot test:
x86_64: Regression mail sent earlier.  Caused by 8615ff6dd1ac ("mm:
filemap: check if THP has
hwpoisoned subpage for PMD page fault").

arm64: Booted on rpi4b (4GB model). No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/362


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
