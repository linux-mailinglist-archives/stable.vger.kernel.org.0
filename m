Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54F98379A1E
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 00:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhEJWeO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 18:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbhEJWeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 18:34:12 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07348C061574;
        Mon, 10 May 2021 15:33:07 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id x8so17042701qkl.2;
        Mon, 10 May 2021 15:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cx2WMvocna7wtr+HEzTjcO51BpH4S0BF9D3u54jPCyg=;
        b=eFQ2hjcvig9PshVW9vxgre9prMvZuc7IAJUsh8R3kplgZsPM2YW6euRNa4GCopTKGY
         KxKLfcREzxpceJHERR9M+dnDbKg9iZA8s2wLGexhIW0bpyAU/6ZRwbbGSTEV+UGhKVIl
         imcHZ3K0SSnSLCt9LXuhwPwMiq38oVrkiw26c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cx2WMvocna7wtr+HEzTjcO51BpH4S0BF9D3u54jPCyg=;
        b=QQ7FH7CwSIIeQF3imD+bh2v6vKIIGCr57gozrS+PwHGlzuZPWhewYXt0VTYAAe09k8
         saUCkNoDCDQCFuJFxlSodMlRitGBDy3b4lTHPNEwWvzhTghZ/GPscl+dsq/aCErvFQ17
         cXtYl7k+rtpJfGuqqumcdn4MDNtb9Y/vb76nhHXSr6R2bAGo/hXChCkcPa2TgrbR+x7a
         MHb1CNSrNeZFpFvdi/o0vvxm1TUMBAiB5YoOsn1ekxuFThegzOpg5rKAGEwCkAdgtQAD
         ESA4V+ztJcig4vLeCEx1dLA6y5teOv2raNgaREI69oWxAguxakP8TqacUT/km7xoxpx5
         IjjQ==
X-Gm-Message-State: AOAM530Q//cxZY4ZW7xIHW0l8heNAzkqAq7jvzoJlJvm4qIAk6hmtb/b
        luEKYb5GNZuppQC+ueGS7Jdm7ZzOM8hSsq82ysk=
X-Google-Smtp-Source: ABdhPJwGDKgJsOpmVHQwJYj+8VY+AURumradvCJZVsA/VFpq2Bx1WioRAivSjOwaXLws0Rkp7PgydjKCDlxAvsWTqlw=
X-Received: by 2002:a37:63d5:: with SMTP id x204mr24881365qkb.487.1620685986177;
 Mon, 10 May 2021 15:33:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210510102004.821838356@linuxfoundation.org>
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
From:   Joel Stanley <joel@jms.id.au>
Date:   Mon, 10 May 2021 22:32:49 +0000
Message-ID: <CACPK8XfVuJKus3vnc0h8sXjZdUQD0W0dNUr0gjPzbn1b_ThnRg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/299] 5.10.36-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 10 May 2021 at 10:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.36 release.
> There are 299 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.36-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Boot tested in qemu for the 32 bit ARM aspeed_g5 and aspeed_g4 defconfigs.

Tested-by: Joel Stanley <joel@jms.id.au>

Cheers,

Joel
