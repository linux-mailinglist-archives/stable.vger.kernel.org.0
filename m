Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70623216CF9
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 14:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgGGMjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 08:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgGGMjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 08:39:35 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE287C061755
        for <stable@vger.kernel.org>; Tue,  7 Jul 2020 05:39:34 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id s9so49650306ljm.11
        for <stable@vger.kernel.org>; Tue, 07 Jul 2020 05:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PR8nQ43YtQ2kzqu7CAHdusW+BG3WkQqUNKXDoqQv2Bc=;
        b=wOcMzoL9PKOfCE92T5O5jZORfBcPgPzM0JNaF/FGTlzRWnpNx4/Ts9/TwRH1muW1hG
         NtSdl2AsV52A1f8vNs8jpCg5Sf08q8JmBH+QSIUFvTTXqj6SDODu3YlIz6LgkR5Mml5d
         uWyGBXz0agObrxeH3HyQv9iCPdwcXOwztAd5URyZolZuy2Ho3Wc8lRh30jBV8yx+UK/s
         eQlHYQzaoxf+4UtJh1jgFILwyzXqmKHa6EahoUnz0l+tEO8fIGz/n54Hn9A3hN5nxOjh
         Poymz4VH+xHPQcQ5Evt8qCUXRKk228OpZRp0a3vyuyhgD4Md+wT9iTxnU1xfEifnAe0+
         bRQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PR8nQ43YtQ2kzqu7CAHdusW+BG3WkQqUNKXDoqQv2Bc=;
        b=tBNUZygQ6ajuQfwBYNbfaRrSrLUKBq4RMI8W7ZcGv3I+Qt3LaDSMuZQDHuq/gTtOMn
         2hacezzcqoqaOd6rjJcSMIVA8WIbKBeSdsvoSQcklLZ5VFK66PaUYjbQ9te9vksgPlAN
         P2NYpa0jBuq2FuM+3NZSP/ma+hZst+dLEpLuoPF7tBfsXPhC6vYC8S35FpA04KKSOLR4
         YNO+xwyQmeKuZsIpQmr5TUZznx1XoDSpab6waNDyPVxbYVqu6yjgzpFKu7iljpP0y+k+
         Gdduj81RaSB/ZgnlMTzRaKjPnXqkxEPmWSDJphQacEoHGXA07yp7CCwlK/n9syGW1K2f
         d29A==
X-Gm-Message-State: AOAM531n1VZa/tHEwlJqTdUBnNndyprLNiKG4IPeuR+w2YbWKUX7/WxV
        YG+73lb7XDqfw4hcZDif6VDsme31JsnpYM3vtdLHjg==
X-Google-Smtp-Source: ABdhPJzLxIIZvKvs0uuMjas/mWF0QR8HShPsPw1tvxHg6ZOg/jx/Zkt6iaQekUaGKH8RYIPUuoMFtXs1GM/t0jP7rH8=
X-Received: by 2002:a2e:9c3:: with SMTP id 186mr31275956ljj.293.1594125573245;
 Tue, 07 Jul 2020 05:39:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200625064619.2775707-1-lee.jones@linaro.org> <20200625064619.2775707-4-lee.jones@linaro.org>
In-Reply-To: <20200625064619.2775707-4-lee.jones@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 7 Jul 2020 14:39:22 +0200
Message-ID: <CACRpkdYTb4MTX9YGAW9_Th1ntcE4Go_N=wGMJ9Po8KpBGehT4w@mail.gmail.com>
Subject: Re: [PATCH 03/10] mfd: db8500-prcmu: Add description for
 'reset_reason' in kerneldoc
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 25, 2020 at 8:46 AM Lee Jones <lee.jones@linaro.org> wrote:

> Each function parameter should be documented in kerneldoc format.
>
> Squashes the following W=1 warnings:
>
>  drivers/mfd/db8500-prcmu.c:2281: warning: Function parameter or member 'reset_code' not described in 'db8500_prcmu_system_reset'
>  drivers/mfd/db8500-prcmu.c:3012: warning: Function parameter or member 'pdev' not described in 'db8500_prcmu_probe'
>
> Cc: <stable@vger.kernel.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
