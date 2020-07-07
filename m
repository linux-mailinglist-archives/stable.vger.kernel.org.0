Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7B23216CE5
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 14:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726951AbgGGMef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 08:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgGGMef (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 08:34:35 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45745C061755
        for <stable@vger.kernel.org>; Tue,  7 Jul 2020 05:34:35 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id z24so24784156ljn.8
        for <stable@vger.kernel.org>; Tue, 07 Jul 2020 05:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1f2289XWaOIfW9z5LP7QS3s93Z1ZNX92UPi5LaG1e8w=;
        b=REmyZh0QiGlSAQ8o1+EPSt6Bf0fvrt6ukZ6LpMzsdMjLFMFSJm9/nHklr5nPLRSyvI
         r6ar5JhU/uYwC5nsqDYpsRmBjGCuJUWQv1OzOhdo5dBBioBuKo4wyLF2uHeCbjY8Ws5C
         Gw0U1IoEixHtq8VRVRnkSHB1eulc2XTKOvuWAeI0eS6lck672sfoZ4pwBX5Fk1TexIrW
         7uznhBNVlDLspoyxTtrq0LSocmTQMyXddkGylZfhMPIVETu8pVxGxuCRUhiECPvzz8Pq
         KZksv8VwxTVsdXasl1mjwwprYQBLGw3m9LLfVUARC6Zrcs60agzfKtXiV5cl6yxGN/VS
         mqcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1f2289XWaOIfW9z5LP7QS3s93Z1ZNX92UPi5LaG1e8w=;
        b=BlqlxSP8ePu+HpEHUGkM7bjiiz0dsygwjRsPx+aSGEEBYvv4er2vWhriBzBihsZSZ3
         HCMSdLo3MeZe0EAQjpgzoObx7y3RV8RILXpt+RsiUICu6/vqv9yrDkgqOtGvUR0HK3pn
         mWO8M8K/XTuECUZDTo+m/GXqkgtcYC6UtkKUxgHPBAvjfCbdd3P/uh9DQbZvQU2OhodI
         TfsGer19TkKb7RFDzr6ljtnLcEbr7m1h5Ct1M/nXsNJtEisKq3CyNnpM1xFLGcN2m3ts
         wMKF8EmtMmaxAoIVQfKeVDoZeIB1mxRlXHJ1a3cZOLbttL7OM/k6g/ExUvUFNYziZynd
         wPkA==
X-Gm-Message-State: AOAM53102shYwb+I/fNEiNT+0MVnSa5yqRqTl728kaaQMb2oqXrFZWVL
        kJx/OZrhhNsyI0mLDJJ28sOIv/bQ0Hb60i9GJ+xITCuhYW8=
X-Google-Smtp-Source: ABdhPJwjEdZkw+eDahT+sUrZ0kdRgPaA7Y55vyrXTG6xW6wfrneSp67eE/ehBWGax8PbU9J+XvUZaq/B24TkV8j7FJ4=
X-Received: by 2002:a2e:7a1a:: with SMTP id v26mr14141732ljc.104.1594125273794;
 Tue, 07 Jul 2020 05:34:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200624150704.2729736-1-lee.jones@linaro.org> <20200624150704.2729736-8-lee.jones@linaro.org>
In-Reply-To: <20200624150704.2729736-8-lee.jones@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 7 Jul 2020 14:34:21 +0200
Message-ID: <CACRpkdZq_O_jacgAdnS_vwZe4wkuTSduUjmkG+EDQ8jQYQzSJA@mail.gmail.com>
Subject: Re: [PATCH 07/10] mfd: ab8500-debugfs: Fix incompatible types in
 comparison expression issue
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 24, 2020 at 5:07 PM Lee Jones <lee.jones@linaro.org> wrote:

> Smatch reports:
>
>  drivers/mfd/ab8500-debugfs.c:1804:20: error: incompatible types in comparison expression (different type sizes):
>  drivers/mfd/ab8500-debugfs.c:1804:20:    unsigned int *
>  drivers/mfd/ab8500-debugfs.c:1804:20:    unsigned long *
>
> This is due to mixed types being compared in a min() comparison.  Fix
> this by treating values as signed and casting them to the same type
> as the receiving variable.
>
> Cc: <stable@vger.kernel.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
