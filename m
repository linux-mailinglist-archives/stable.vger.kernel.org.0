Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61752E9C4F
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 18:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbhADRoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 12:44:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727695AbhADRoU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 12:44:20 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466EBC061574
        for <stable@vger.kernel.org>; Mon,  4 Jan 2021 09:43:40 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id x13so33015640oic.5
        for <stable@vger.kernel.org>; Mon, 04 Jan 2021 09:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+LCXKPEB/hewuwkhbTWHVXw737PfQlWdNOWuhiAqpDA=;
        b=l7y12RonbWR2q1Qs7ztSpcP5LZZ0x8UwDulHQLiRTc3az219ExEDau/Mn2zaVha/Iw
         AOVDK1pU1/jAC1AKLZmjK2wI55qTltQ2F4N6+VytBa3a8EjO6WReDNKnujaOUBIJGlkl
         uS0/DgSQC0U+uQdHmGa1LPwKU79xkvKeWzLMr91CZxI4Hg0f28GMocag7MlKCM2VLB03
         UwhzzbpsCxzZSlE9IyR0YZNZTi7lKRouQOFAUGwuISSACnfSFpXl+/0jOit5pZXV02+M
         7HgwBcJ8u4qjzXDr+gvdDbNOof5gWfn72IIPSoto4z7XmOS6e2pEWctcN8ve3FD2ZpPZ
         PdjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+LCXKPEB/hewuwkhbTWHVXw737PfQlWdNOWuhiAqpDA=;
        b=tTdXe9OnMg0PR9YAV41hEpnZKi29ya4BADFHZgXHUthfo9OvgPUNg8f8qW6nIYyU5x
         7HFQoru18qvxUFq8eJfVIRD6ltIRIe0dldLJhk9JIW7EsxDA93ClunquOEvu+2lFYubr
         Ek+Wqe/Aer7m8J0flENk5SIU5ObsNYb3OepVaXsClmrP34RboIeKSFdl3QYhSTfb3elW
         WhJyDfvJqh7WVOHZXPZlPVILUk5en9HflW+tmPdHigFimjc7Gg/jiNOXW2ZWhECcC7V/
         D8enWx8uTa9QBb1eeDT0BU/8FVIrSLdlq3XFvkcRo6nJY00+h0i4LFcKscVJq965y9iI
         KnAw==
X-Gm-Message-State: AOAM533ziApkR0mOFhMKjzU8YaOtcPUV0CjRjRyyu46VEyrCHxXmnyy/
        pepqvr4DY8jtLIyN7OUd3Ct5Lin1hvql6IRwKtmXiQ==
X-Google-Smtp-Source: ABdhPJyZLPuzv5+r2HCT/0oWYyWV8Mp1n63c6IXTVAQEU/o1FUrnjCI6zAJLPn5xLIcW+OWcM+L2m0mnmlmy9H5FYj4=
X-Received: by 2002:aca:a9c8:: with SMTP id s191mr12129oie.11.1609782219730;
 Mon, 04 Jan 2021 09:43:39 -0800 (PST)
MIME-Version: 1.0
References: <20210104155703.375788488@linuxfoundation.org>
In-Reply-To: <20210104155703.375788488@linuxfoundation.org>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Mon, 4 Jan 2021 11:43:28 -0600
Message-ID: <CAEUSe78+F1Q9LFjpf8SQzQa6+Ak4wcPiiNcUVxEcv+KPdrYvBw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/35] 4.19.165-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

On Mon, 4 Jan 2021 at 09:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 4.19.165 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 Jan 2021 15:56:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.165-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 4.19.165-rc1
[...]
> Peter Zijlstra <peterz@infradead.org>
>     mm/mmu_gather: invalidate TLB correctly on batch allocation failure a=
nd flush
[...]

This one fails to compile on the X15 (arm 32-bits) with:
| /srv/oe/build/tmp-lkft-glibc/work-shared/am57xx-evm/kernel-source/mm/memo=
ry.c:
In function 'tlb_table_invalidate':
| /srv/oe/build/tmp-lkft-glibc/work-shared/am57xx-evm/kernel-source/mm/memo=
ry.c:342:6:
error: implicit declaration of function 'tlb_needs_table_invalidate';
did you mean 'tlb_table_invalidate'?
[-Werror=3Dimplicit-function-declaration]
|   if (tlb_needs_table_invalidate()) {
|       ^~~~~~~~~~~~~~~~~~~~~~~~~~
|       tlb_table_invalidate

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
