Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6594937FD20
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 20:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhEMSRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 14:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhEMSRX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 14:17:23 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EDFCC061574
        for <stable@vger.kernel.org>; Thu, 13 May 2021 11:16:12 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 8so654660wmc.5
        for <stable@vger.kernel.org>; Thu, 13 May 2021 11:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5E9BIA5GPAk+9qy+6fCvvYM/XcjYDBMVgcstjh5C8eo=;
        b=euIicu8OP0C4v4xJbHjbNOSQThYsrUsG+bLfj6mrHgLs44V6m/PeyQ98eQYvICoP2h
         irj2L2REn3cFR25U/DxPDHrYnQ2V/zZc4cZqizV021yTxCNoytQXidWabiCwFF1Y1AAg
         nB4iSPs9hYR2GiFvzfqdBrvRGCj/rUjEMXAHI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5E9BIA5GPAk+9qy+6fCvvYM/XcjYDBMVgcstjh5C8eo=;
        b=PsL4nlB6+d7niOWC2YyjhXlL7rB4eBbkc/4duZ/dmnxYHzFB+HLLPpQp2udPEdGYJ/
         J7iYS0YAhs1kTitI9i9Lz2HGhOWG6STOsrtTDzm3vG1pU5iVDTIL8mbMlUAEwYGqItmy
         7t506NvCoNL7Vbt6uNNLaSLglqTf6kOF0bXG6H7J/v6nBG6ToOqv2QJhH2zKXWvvumP3
         4DfZfe/rMaj/IFtJMF3qKfG6YN7Yvb49EhzWD4LrbL1ZHiV0zsYBXDH3vPORKSoc0qOE
         4mGjO3uJI8zKPiWLyugICrxKy0ft6mbjvDuBCoff9EpvIAMph7GcB6IY4ws5rX98sou4
         q2WQ==
X-Gm-Message-State: AOAM532D6f+g+difP+KqkB/QcDKgDOPr+wByuApUyRwO3Dz/8a51ZsZ0
        mkXmWENmga8pigR3CT7TghXPOauZM2foBPf5T6ZXRw==
X-Google-Smtp-Source: ABdhPJyaj8hDkjQInwFSHvO2unCTVLSXBb4jub7FsGkgQ+Gu84qf6RYXzKl1ZyxtFKI08O4JC5JpZmmPdrchch4dhoQ=
X-Received: by 2002:a1c:9856:: with SMTP id a83mr408849wme.121.1620929771024;
 Thu, 13 May 2021 11:16:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210512144827.811958675@linuxfoundation.org>
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
From:   Justin Forbes <jmforbes@linuxtx.org>
Date:   Thu, 13 May 2021 13:16:00 -0500
Message-ID: <CAFxkdAosbVD_0GM_xvMxZmRPyWVZ+N14Xmwt=JphV+Mqg8phNw@mail.gmail.com>
Subject: Re: [PATCH 5.11 000/601] 5.11.21-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 10:56 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.11.21 release.
> There are 601 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.21-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
