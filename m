Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C511484CFB
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 04:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236106AbiAED7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 22:59:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230284AbiAED7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 22:59:01 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEFFC061761;
        Tue,  4 Jan 2022 19:59:00 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id v10so30014695ilj.3;
        Tue, 04 Jan 2022 19:59:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jSwc2gpQd+XchfSgUCHEUu47Nw0ikHAolADuPyx1fW4=;
        b=JQLEffMcvVi35oJNSVtnoUxz8KS1/rNwy3x0riOo8BFtkI3Yp0tgBLTIRrZqHEfqKj
         KJNmQD+zbfxVgynsrpzNXFeIYZRvjHsk52mnvM1vHeoZ/YyrXP3TF1CzBNLusOdntNvC
         sznf53oJhvUrhKz/D3PUbMyFI/o3fYwXljrR94LW59fZCLjX1PzsNrwsBj5dBJaaCm26
         K7RbzPznlaNvKcz2smYZORA0F413PaO6u62aOQzuDMjbEzdW1BZz5WThfkRWCycCpJq8
         xz1ehtLzTF9AqEQuSD85krcS+SRMZMn+NNYfivGO/WoUkMb4QeywAmZ6Jo7Z0L9SevOw
         7+6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jSwc2gpQd+XchfSgUCHEUu47Nw0ikHAolADuPyx1fW4=;
        b=R+oAQY8Ns+IGRIYxbAvgI756gBbFO5lxO1rYpdk+352htp1vAdIC5qTCWj5qWL9l9E
         rV/VxYFVpW2gAynOA6qCEIWTJRdgqzbNF4X54MO9Ujdl6hwqn/P0sk/NfAerdKfPUjWP
         R2LU39EONQTNvW76FPxItgCBF3osJwB/JZL2G+EH4E3Thwil1WmgBmCVA5fP50AVcR3r
         u9vdXejt/CiSEv/zeiP/Zlry0tdiAzD58HcsKj5jx7a2PjWovlZIWa9pSU2eIQHt4S+n
         t0x5yUznUxeJ9qHuwPS0cKoTi1mp1LqLUcpgjjYBrUF/svCIwTimUsgToNlRn4oWlsF3
         Ntyg==
X-Gm-Message-State: AOAM5311b8q5dTnq4x3qPmvEhxAwDDhmPUFQt5Zy4qsZgEypFElWkXyy
        +6yndEgIsuSXQ1tFdMkKVlJtUs3eCbS1Jw1z6L0=
X-Google-Smtp-Source: ABdhPJwRYQoLHcO3SGaObxJrTeYphaYT3xCNsnxJt8WhO0u2xYbH9soYju+FkZ0EABT2Y8jUCGlwDb8QcSfI9Nsc3JY=
X-Received: by 2002:a92:d2cc:: with SMTP id w12mr26339642ilg.303.1641355140381;
 Tue, 04 Jan 2022 19:59:00 -0800 (PST)
MIME-Version: 1.0
References: <20220104073845.629257314@linuxfoundation.org>
In-Reply-To: <20220104073845.629257314@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Tue, 4 Jan 2022 20:58:49 -0700
Message-ID: <CAFU3qoYZcNjFa1tSdA-L16LzdWN8s_dMNHuJtELqMbEhJXfGgQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/72] 5.15.13-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org,
        Zan Aziz <zanaziz313@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

 On Tue, Jan 4, 2022 at 7:47 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.13 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.13-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my test system Lenovo P50s: Intel Core i7
No emergency and critical messages in the dmesg

I am a high school student and this is the first kernel I tested.
Please let me know if you
would like to know more information about my test system or dmesg.

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
