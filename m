Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C642FA37A
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404954AbhAROqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393066AbhAROlT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 09:41:19 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD33CC0613CF
        for <stable@vger.kernel.org>; Mon, 18 Jan 2021 06:40:38 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id h16so17848694edt.7
        for <stable@vger.kernel.org>; Mon, 18 Jan 2021 06:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NsWzXboGpAJXv9vpOlbeGOk+81oA2YvwloCKYrLMFOA=;
        b=Sa+U/OWQL6mMt+GIu8fw+fY3FrA92oQkIoCvTUAxBuDml0tIvY+55vicO5xc/llY4z
         FLGIC2cx1PavtQE/eMv+O2Y8OzG7nCrchtQFCxIoszPklxhGOXyVgk6UTRkEQ6HYVzoU
         6RJ4cy94/cDhlMawXGpKsksQgBOYBpOoc9qvb/lPxdiCc04d4wjskYsO3P5YG7hX6BjE
         /Z9XgrjkYVsIalX2Pl42T0UEjvMbElAphUH9WJrv59ozXxHZSuF0AmZ3fpozimgdtRBG
         EIWFaC44fjtWunq3DZJvCWlkTCMwGNLruBCOWkymat70cqloPEg7ZEWo0empYpTohV5S
         uUtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NsWzXboGpAJXv9vpOlbeGOk+81oA2YvwloCKYrLMFOA=;
        b=C/RGkVgUZEvWSjGZBDg3KBe1nATN572fcHpCcjw+PKfMLiNcWuI/0LcnsDjMRA79Pw
         gGbDw57I4InZEoyQc0UUuCmXcO5iSp5sNdoha4bg5cBQtxbWe7KdjcyMHCJ6/dc0Al0s
         C+mmn2QB16TBti8lNrO1/uXtqoNTagTRNwzPKzY2m7hQbQGUa3+mCzodr1odoXePgo3i
         xkb9Ku51oLWQrF8Doc45NMupiOvMvEBcqjP/xlqCdyuN9Fv2jqzK7t5uCmTPqO0jEcqU
         sjIDWiCjHpn1TLA4zRwJwNquRgcgZG1u9nQcmw5vATzBhL78OS/qTxW2jBoyZBBFROFH
         mRdg==
X-Gm-Message-State: AOAM533kZOHB7n/LazYu1lr563yxbJ9WZz8cHF/c+ilz2crGRT/qJtdE
        zbBx66pMjz8iyL6KmkgNByDIvQ/8q0HsaSEVifFYkw==
X-Google-Smtp-Source: ABdhPJwLNPR8KiRG/OWK0LNSj/48WXKaO0d52vcSqoLDePBstbl1RKIENlGJbPQ8fZgnnILWh2zdon/teynoT3D7aIA=
X-Received: by 2002:a05:6402:26c9:: with SMTP id x9mr6443592edd.365.1610980837381;
 Mon, 18 Jan 2021 06:40:37 -0800 (PST)
MIME-Version: 1.0
References: <20210118113334.966227881@linuxfoundation.org>
In-Reply-To: <20210118113334.966227881@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Mon, 18 Jan 2021 20:10:26 +0530
Message-ID: <CA+G9fYsVb-4L65-YjNxVhGWeQySQAQVyQGudDtbmzfZq4g4vFA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/43] 4.19.169-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 18 Jan 2021 at 17:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.169 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Jan 2021 11:33:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.169-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


MIPS: cavium_octeon_defconfig and nlm_xlp_defconfig builds breaks
due to this patch.

> Al Viro <viro@zeniv.linux.org.uk>
>     MIPS: Fix malformed NT_FILE and NT_SIGINFO in 32bit coredumps

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

-- 
Linaro LKFT
https://lkft.linaro.org
