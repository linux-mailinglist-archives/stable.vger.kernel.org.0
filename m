Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCF03D6D02
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 05:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbhG0DHX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 23:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234422AbhG0DHX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 23:07:23 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CB7C061757
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 20:47:49 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id go31so6107856ejc.6
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 20:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nId3EryuDVVIw/l/VpympL9hOCFnfteI56eFXtNB8IY=;
        b=I/rkzhGxZPcWLLrDMh4uMGpggD6T5BC7IXHXiM48P6d83E+q2//8XwOSVtaCxL4Mzp
         Gff//cRFbhjsr9eP+0Bm8EbPB2zVHkXhLYIM8MmaSZuJLPPLUJX0SB5Jk7OXQhs0jaRL
         MOBr1BpJi53dEi1oOBkM57lwMOIc7DcQ3EaOqTl7DSCPLPiTgbutxL5MW+mTWbq891VJ
         T+Opa9om1K6D4KBRmbm/4fwha2APTKeFjo62fXe8Uvl/AltvOiSobP52gAKoJTadA6mU
         BQdo/gShFwWzTD6/C7rAZdQdRAlXD9A9LRoYDTRZbf7OwMIzm3fa2BinOsw3/7o4vgs7
         +wvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nId3EryuDVVIw/l/VpympL9hOCFnfteI56eFXtNB8IY=;
        b=HVZCAhvazH8+IzSdWX3QZ+IpUweveOaks7MRIcKtv2Y7KpGIYKN8w9j21Vn+JpL4u3
         5SgePleK8JjGKGETzFlEt1HR72UYytUQwqgsY0QlnTOW86EUKiC1GN7smhA45SPAzcGs
         gffEcTS58QtSlC40yGj5qaypCGFTOFw4TwMLLu2g/zC2oKepQm8RKCDuETpHNakeGA6i
         kgzocrEBYiGzk+6NfCUV86MBwbsw6UIhCkkNw7XB7CxosmI/z2+7tvjGfYPNzbd5fT9o
         4Ykv9S8qQrsSMxevireVtIZBnuWVA5vmDqxtqTY3RLphkYL4FuJNpdoaDAKgBFpQ8ptq
         LgDw==
X-Gm-Message-State: AOAM5301XkaegQNfLP8bfpixS44NxT+rMX+BUGwpe6zqbxtb4Bq1kYgn
        uqYAvysvTygelHBQC7SUCrPbpMBCJ+Jvs3rTUYpXgA==
X-Google-Smtp-Source: ABdhPJw/83V0W6bq05thAnl23kZdD0BQtxuVPPxsfMpLm2e16D+7VZilbomSI3HljuQu6OmE+moi98rHUQYjqQd9wT8=
X-Received: by 2002:a17:906:af02:: with SMTP id lx2mr7091139ejb.133.1627357668324;
 Mon, 26 Jul 2021 20:47:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210726153824.868160836@linuxfoundation.org>
In-Reply-To: <20210726153824.868160836@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 27 Jul 2021 09:17:37 +0530
Message-ID: <CA+G9fYtKbCnGTMJod3PYEmcUHYLhj-WHS-rKQNCiWw7DvdVzjQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/60] 4.9.277-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Jul 2021 at 21:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.277 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.277-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

perf build failed on 4.19, 4.14, 4.9 and 4.4 due to this error for
all the architectures.

> Riccardo Mancini <rickyman7@gmail.com>
>     perf test session_topology: Delete session->evlist


perf-in.o: In function `session_write_header':
tools/perf/tests/topology.c:55: undefined reference to `evlist__delete'
collect2: error: ld returned 1 exit status

ref:
https://ci.linaro.org/view/lkft/job/openembedded-lkft-linux-stable-rc-4.19/DISTRO=lkft,MACHINE=intel-corei7-64,label=docker-buster-lkft/893/console

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

--
Linaro LKFT
https://lkft.linaro.org
