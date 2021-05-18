Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3473870FC
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 07:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346399AbhERExC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 00:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241463AbhERExB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 00:53:01 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4573FC061573;
        Mon, 17 May 2021 21:51:43 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id f29so8212440qka.0;
        Mon, 17 May 2021 21:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z/E9dFa0W450Bi8Y9ltqYjqXwUS5O6Sg/Is6y2lBvD0=;
        b=QyvJRcdfl/F7A/W4fm/Rqi9JOMB9hLFsx9uMoNOIkDJ1KzCb4TDbT/eK3JhrLkPuZY
         ag+DpgwEymhUxiUDQGkY+xh6nYGaXUJjC/vaHKB1lv/0AsTUFUQ2sTdMEevSPuRlbPfG
         9gOngun7x6bSfHR/W2R30sZ0gwz+Hyb0hOMo0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z/E9dFa0W450Bi8Y9ltqYjqXwUS5O6Sg/Is6y2lBvD0=;
        b=HjJmf5l7uB4NX8S+zkWqRmcWNHpN33HrZPkTFmXhe2OctyZZ+FHiTgP86P43YNTiY+
         KSj4p/3nYcyz72NpgbBUIq/vz5k05DHY8kZGCNS74FHut2ulWwTuWlgogIV/nQJJj2Pb
         619VfGF0mA4u03yXk062O5Ur15DR7gARcIF7+WDGN1S3WmT3QKNSsDBPPA2rVlD3+q6B
         RNheuBOiRUY90mmPQ6HN9/vZ+PAm392F7Xr/0n7vxgHH0DkMGrtSyjL03fgQG9F7pYHx
         2hsbmdZh4qSDqT8KlTPI94u+zZdwv5ROw7Y7mevBKv/8OKt072CYdW2ntZjqKBll2tOG
         V7Wg==
X-Gm-Message-State: AOAM5320rh1oAjXBFt1d5tR4K1ivqNQI2JsJ6hgCl28e+0wVMAZnRquu
        5VYGehE1Ztd7VCNqC78juNXpFzNB8LgfHUqjxyHN2hKCABo=
X-Google-Smtp-Source: ABdhPJxgAEPmXRP7k+XKzNYIyjgVefilXnPFbt/vj2NlxAMZQqeguNf29mGs28vKPoZGDjRzXVwn+hOj/mXG5PfY4vg=
X-Received: by 2002:a37:63d5:: with SMTP id x204mr3462095qkb.487.1621313502482;
 Mon, 17 May 2021 21:51:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210517140305.140529752@linuxfoundation.org>
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
From:   Joel Stanley <joel@jms.id.au>
Date:   Tue, 18 May 2021 04:51:30 +0000
Message-ID: <CACPK8XfFuxCvL8FDH=g-JzPjbAQDA04QekmB+J_Ck4F9vye-Og@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/289] 5.10.38-rc1 review
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

On Mon, 17 May 2021 at 21:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.38 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 19 May 2021 14:02:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.38-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Boot tested on arm32 with aspeed_g5 and aspeed_g4 defconfigs.

Tested-by: Joel Stanley <joel@jms.id.au>

Cheers,

Joel
