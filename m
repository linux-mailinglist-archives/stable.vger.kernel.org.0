Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB6F3B71C3
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 14:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbhF2MKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 08:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbhF2MKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 08:10:38 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96DB7C061760;
        Tue, 29 Jun 2021 05:08:09 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id m18so25530347wrv.2;
        Tue, 29 Jun 2021 05:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mw9td+stB9UompImlZHGudFBkxHUWrqi7qFElRkrGIA=;
        b=OO9Qro5A1nDXdxfwuIr3nkZaoAEfovXiiaFnaqaFu3gyJxOpTBLVVU1DBQBFEf+iMI
         kCWwd5OzmDKATFActg3Ncyh4fremldBXTBtMQuKLUdNfzD3ibv+xEQwOh2Grd0B2rAAU
         FNLzCJEquvxJ9ZKtOWrMHk/voedG1KLswThg2EP7PFhP/Jo60wnWfy/kYHSUGUoMSZt/
         9wmIr1LMPbGiZfazwaUI/gLamwco85JCOCbGBakTjbggep08EFry1gZYzYU1ZPk0sYWC
         01s5N8Gkbb0e+BxzFbPkeN9cu1DAge1EnwYGF6Z0jQ/sM085Uo9iJHEH6xWAm3tySE5D
         X6MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Mw9td+stB9UompImlZHGudFBkxHUWrqi7qFElRkrGIA=;
        b=jns9LLBGq45VGc/UuNar1Mhmk+NVmrN5s+T8sx3JAARshE5lN2vPeg0whss/gsv5wO
         ScFudwdMByPG4HVajZaOqDDT8YKDbjabVdCIgSCqLi6IdP+TvJWB4qtt7xAuHezF0rXP
         ImUdq35N0fhheoE+tMwDF8QQzOduUnxgnugvvDymnoQDXOnmhgIjbbddM1wvVJESQem7
         m4XWip89T86TJEOl2geLzxuAiENb7TMeFeW17Wsi6VpWmAowNrfRJMZ7SJ930U37gXRc
         3qdH466h2FbFJCU4XRhl/ijQ7O3LeIt6W+BpEEFRFpWyG7nTaPcYk1z21h30dtb6fEJC
         uxVQ==
X-Gm-Message-State: AOAM530yUNCDAUpxvgrNu93pKJTi73yhLkxYK30FMyXzJ0ZsPowuoFpc
        NXycr1gwHkvaOYa23qeqj9k=
X-Google-Smtp-Source: ABdhPJxPRfFu12ZjsZ24c0wKd8Qrs3nu9ZwiT+bvzTT6IQzT/EvSHw9iflKaS1WEnfFC5gxi9KreyQ==
X-Received: by 2002:a5d:400a:: with SMTP id n10mr11967338wrp.268.1624968488172;
        Tue, 29 Jun 2021 05:08:08 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id n20sm16109657wmk.12.2021.06.29.05.08.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 05:08:07 -0700 (PDT)
Date:   Tue, 29 Jun 2021 13:08:06 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.10 000/101] 5.10.47-rc1 review
Message-ID: <YNsNJnEsTby87llx@debian>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Mon, Jun 28, 2021 at 10:24:26AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.10.47 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 30 Jun 2021 02:25:36 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.10.y&id2=v5.10.46
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Build test:
mips (gcc version 11.1.1 20210615): 63 configs -> no failure
arm (gcc version 11.1.1 20210615): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210615): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm64: Booted on rpi4b (4GB model). No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
