Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A059949F1EE
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 04:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241873AbiA1DnF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 22:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbiA1DnF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 22:43:05 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9FFC061714;
        Thu, 27 Jan 2022 19:43:05 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id r144so6209289iod.9;
        Thu, 27 Jan 2022 19:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fEeC00YZEKtaMEvnvsES3LOa4ntiyaf7LZhFOYs3mwA=;
        b=cGVIb30a2ofqveaSazvsol9VT3z5u7suLZF5H/C/1plXhq7KFMxmfpH7cTJKhpDlvh
         s1YWuCiTvJ2SEpkUhX48EXZiWZk+pX82VxFDCyEYtPqO2JbJEc4KvyDv+0a5VE4ieMBO
         bxAGM1B4sxxjh4XyhJuVS44T8mFjWiUIKeyEDqRD17TsWfVXRyl9a9yy5U4ayr1RC6Fo
         uNEt2nKvIDBEeOVDXAXOEsZruBysI9Wztv32csPLl9sQpDQt1ZWbjuZRsKdQO9sZCOYb
         Ny0dOHQsjkeZtyY+KxBAAPa8T3fAjcvlhAV+h4X5lzeF+YaC06GVhY1S4EyAM1rWRtLO
         pfiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fEeC00YZEKtaMEvnvsES3LOa4ntiyaf7LZhFOYs3mwA=;
        b=I8Guu3blo87A7ZKipae+g9Qc5YVFTuTseyFHnI629iey6Kg61eQ2YSIdEycb7mEZc0
         PZcsB4O8T6J7ZPxwtHDl3WomKG2sXxU6mWLdyvU+yDJsOpvBA5cJXFBC66Ky0Y6XoJyr
         hbMs9ZvM3NZp/Ccknzlrya/43EINgVQSF1yoxH7F2AC2jdMnjK+Oxez7FHdwc+UZeG33
         cwviKL1y6VhNN6GN6wiJARDODNW7OGFRil+N0u2mOor+DJhHHr/LqY51WgwVeixzUJyl
         vlRd4O5UG3fcTbryN4G5uoq6M+w+IF/GhMqFfH/UlQtr8MkDFG9dozqM3lAovCT6uhhT
         hbDA==
X-Gm-Message-State: AOAM533NIj0gfWEjWm0YDjL3GeHPOuzqtE0mnpv3kScGaHAErK8rJhMg
        bKJTzMeOPeHglOoGHvQytbvVoGYDtQghtvdgfp0=
X-Google-Smtp-Source: ABdhPJwj6fP1tLpQ2aUqt0hrqlpXUJO8aZobJmU5jeOkSf1eN5ylbgZu9llVb4DR/1aPutJ2I7gYC92qRsJ2l6E+FuI=
X-Received: by 2002:a02:6988:: with SMTP id e130mr3623894jac.120.1643341384617;
 Thu, 27 Jan 2022 19:43:04 -0800 (PST)
MIME-Version: 1.0
References: <20220127180258.892788582@linuxfoundation.org>
In-Reply-To: <20220127180258.892788582@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Thu, 27 Jan 2022 20:42:53 -0700
Message-ID: <CAFU3qoaRESfpS5gk-RSXUL+WABgPeMuk+3qPQxuvx9pQ2x_6SQ@mail.gmail.com>
Subject: Re: [PATCH 5.16 0/9] 5.16.4-rc1 review
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

On Thu, Jan 27, 2022 at 12:13 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.16.4 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.4-rc1.gz
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

     Total time: 0.441 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 7.131 [sec]

       7.131623 usecs/op
         140220 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
