Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D5E2E6982
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 18:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbgL1Q56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:57:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727534AbgL1Q56 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 11:57:58 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA59AC061793
        for <stable@vger.kernel.org>; Mon, 28 Dec 2020 08:57:17 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id cm17so10319396edb.4
        for <stable@vger.kernel.org>; Mon, 28 Dec 2020 08:57:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h2qVmb+m7zKNZ1pL5S9rgGhVZpRwLRQ8nI/4+bwyg2M=;
        b=YBe1+IMIaecgUR/8tsWs9InVDC5S4G4EMCBnCoeTKgLI1t0WJpODIUelujcFXluIBL
         flTS4Hy2gcrSId0/w+cQ+66eX0hQa45XKlj5Cgsy8F2ylFyouK+oJ+mqkw9GwdpIXktt
         b09EER0KGKGsrdm7nCiWRWeKWN2cWuMY2v7bQPWzuIdDDLJop2W0eDTxlmgjH16kKuum
         PEi4MCwyu7/2KxpsOb/0AV8/ugG1WEBqhjKOmBmFoYtE81M+BDmvZejml9zQFrMx1SVu
         5w1ttIW+hXV+b6GjbzOcv4HXrq7cHAq5G/PmBdhkzyhP6smVcymia0Uhpl4LJYAbxpC0
         NqLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h2qVmb+m7zKNZ1pL5S9rgGhVZpRwLRQ8nI/4+bwyg2M=;
        b=CHnYQi/tgBQwWYPO7qgmuodjBZLIpeLaLsjucIqrvDlem2C1is/6o2KsKl1kihUQ6i
         F346JSc38u2miyazPD5LuzPq7Z9uHbbyisZnhigiJ4uvQnc+Hc/qJInI15Go3c0xIO9r
         2Qtn0MV3IgKBXVjR9sKNkj/rGYOcAN3i2iCfB/Bhd1HZTVbnNWBPSbdrOYcHcucjrN4C
         c13ZgcxNG7s8uRfVc+wHkHP3wxl5VNsc3FQjc1lowN01R3Tnib1XniIdrdxFUt/hlRJT
         5bYqQBwsSnYQo7zEv0r8PrXeSg9hsejLpKHOiVaRRvRpN1rWsEcjDxcAcNMH/ponvfcG
         sY4A==
X-Gm-Message-State: AOAM533PUvCMshn5cDpgyYqq/WYX8zssVwvL137Jt8sDd8GjuegqfhTj
        KdzFnveTUX3Y2njon7Bn0HZekYb8lybVGsCHocMdjw==
X-Google-Smtp-Source: ABdhPJzuPXEA3qxcovRjoogA/g5t4HAbxBS6/tahLJZ6IhdXidbuELGzvrt0S8koadxwpzK4d4kCGVNT/pM8Hndr7vE=
X-Received: by 2002:aa7:cdc3:: with SMTP id h3mr42348971edw.52.1609174636617;
 Mon, 28 Dec 2020 08:57:16 -0800 (PST)
MIME-Version: 1.0
References: <20201228124937.240114599@linuxfoundation.org>
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 28 Dec 2020 22:27:05 +0530
Message-ID: <CA+G9fYsAz_drXA3RJW-hZ8uAUv8AQ7X_JwmM38NSp6ERZQ8Wkg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/453] 5.4.86-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 28 Dec 2020 at 19:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.86 release.
> There are 453 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 30 Dec 2020 12:48:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.86-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Perf build failed on stable-rc 5.4 branch.

> Andrii Nakryiko <andrii@kernel.org>
>     libbpf: Fix BTF data layout checks and allow empty BTF

In file included from btf.c:17:0:
btf.c: In function 'btf_parse_hdr':
btf.c:104:48: error: 'struct btf' has no member named 'raw_size'; did
you mean 'data_size'?
   pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
                                                ^
libbpf_internal.h:59:40: note: in definition of macro '__pr'
  libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__); \
                                        ^~~~~~~~~~~
btf.c:104:3: note: in expansion of macro 'pr_debug'
   pr_debug("Invalid BTF total size:%u\n", btf->raw_size);
   ^~~~~~~~

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

Full log link,
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-5.4/DISTRO=lkft,MACHINE=intel-corei7-64,label=docker-buster-lkft/346/consoleText


-- 
Linaro LKFT
https://lkft.linaro.org
