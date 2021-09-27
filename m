Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0A96419D72
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237570AbhI0Rvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235880AbhI0Rva (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 13:51:30 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85211C061A54
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 10:43:24 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id x124so26562379oix.9
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 10:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/6PqtAuxAQF2+Mkx3dvUi6/5jAweBVPbOW1F3Gm5Qus=;
        b=TK+OvSWcoa7k2LYKZKp7aonrPA+03c8GYlBHXgBm+hFkUnsmqIqL0SH6VcjDu5x1UY
         Mte38H6aHi83/a1WV165YfBPG/uC9g3ZukGnvXayKwhfxl1Igh+A4fCpnRdozGRDwLS5
         f2nY1qzNHmgBICDOuz7D9m8hJcZBbDk9p3UwbafNY6lv6GieiinUqewPMCoktSCbXnQc
         /SV4/32i9Qd+OYm6n2weVGB7/Ev+vsc3IrhmtOlV3e8Ss1JWeGW1pG6Jbwm+yYa8yq9J
         ykVPWPIZ0070MD9jqIIpi/4ArCDJqcC08luNmkdpwf+hFSqFGaVj4tqUrmSTAIcN8hod
         2hrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/6PqtAuxAQF2+Mkx3dvUi6/5jAweBVPbOW1F3Gm5Qus=;
        b=MUROXz+Qtoz7XeWUjyXeBVxk4/+77Q63bmdk4nMpCn1VXOKhoYqJkyh0lW12BAjzX+
         EKGWbBjEqK5dcz9sCdrBcWmLHoEfx7fpOpFzY4q8TGQEYiklD7XX6/v327BHHKt7uKqu
         PJYPo8/7mD2jn4aBebi291zqqvZtHV/bVEEoDKp7pG0QBXIpzUvv7wZZQ53Ssokxcsv2
         CRFIGCvOVAsBnGEm3iYMrBenOSJ+ciUzs4KgAzyG7kpxWAoDcarENwrQ02E5cpcfAoH1
         Re2rZYstDwR4PVFBsGfPR8tRj3B/miOuVbPMfWFWnA3+1A1Ea6EpYr8ZrS6Shke01rd8
         kzrQ==
X-Gm-Message-State: AOAM532f1H6YONj5dxzCIDNPzyb64umS9dqlY72yxwfoN6ZkmzITl4e4
        HmFMmuey1wvzSOt2Xr9OeC7RWVa14Dmosk7YBQsNpQ==
X-Google-Smtp-Source: ABdhPJw8Qgh0R3YF8UblgpBhaO4+VlkiynxF/BTrAxLvED9CTrftnAHjlziEtuo/EiYryFMZ9GhQPRk5XPhTQ8Z314s=
X-Received: by 2002:a05:6808:1a11:: with SMTP id bk17mr269217oib.0.1632764603683;
 Mon, 27 Sep 2021 10:43:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210927170225.702078779@linuxfoundation.org>
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 27 Sep 2021 23:13:12 +0530
Message-ID: <CA+G9fYvJ0rqin3f+46dzrXEeGcP+s6iwsUdnHJiQr8qzkPEJFw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/103] 5.10.70-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        wintera@linux.ibm.com
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jon Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-stable <stable@vger.kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Sept 2021 at 22:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.70 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Sep 2021 17:02:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.70-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following commit caused the build failures on s390,


> Alexandra Winter <wintera@linux.ibm.com>
>     s390/qeth: fix deadlock during failing recovery

drivers/s390/net/qeth_core_main.c: In function 'qeth_close_dev_handler':
drivers/s390/net/qeth_core_main.c:83:9: error: too few arguments to
function 'ccwgroup_set_offline'
   83 |         ccwgroup_set_offline(card->gdev);
      |         ^~~~~~~~~~~~~~~~~~~~
In file included from drivers/s390/net/qeth_core.h:44,
                 from drivers/s390/net/qeth_core_main.c:46:
arch/s390/include/asm/ccwgroup.h:61:5: note: declared here
   61 | int ccwgroup_set_offline(struct ccwgroup_device *gdev, bool call_gdrv);
      |     ^~~~~~~~~~~~~~~~~~~~
make[3]: *** [scripts/Makefile.build:280:
drivers/s390/net/qeth_core_main.o] Error 1

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

-- 
Linaro LKFT
https://lkft.linaro.org
