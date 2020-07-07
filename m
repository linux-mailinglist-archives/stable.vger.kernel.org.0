Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F22216CDF
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 14:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgGGMdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 08:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbgGGMdt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 08:33:49 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CD5C08C5E0
        for <stable@vger.kernel.org>; Tue,  7 Jul 2020 05:33:49 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id t25so45079260lji.12
        for <stable@vger.kernel.org>; Tue, 07 Jul 2020 05:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iPF0JvFJGRu0MJDb+xo/+g0FOnfGSe89EWgDZnv/5qM=;
        b=ljk5CgumTgOD4AurgcmJGCpCoc0SmL4X+mF3OtZln8cT9mLEF8oyiEC8nmqLtzRYKD
         FLYSSULnop3FJv0+vwRTIgXvktKapS93Nl+iA6UhhJNh1Is5Zi0ox/381H72KYn9tTqz
         4SmnmnSwd5DBCzJ8SZY3qUsMFmznlQcF+q+fvZKeXShMVFvJ+WJdVGgpmaTKrueR4dDw
         h2U2VaMhGO4m9vK84x+tbQpduvLzMf1aBu/8KCukU5lk/XHpUEtYo1DwYlCWZGAiDrN6
         MG0uaAoRfdz52ZNtkioWfOnUEGE0K0tLoD1eDVJo1u3ffBkebdkpb9LR423pP47PiB+j
         l8bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iPF0JvFJGRu0MJDb+xo/+g0FOnfGSe89EWgDZnv/5qM=;
        b=eLU1HbJrPAjLPGivlUE10lB9WQ8Fu+zFD6djr4KUFnY5PQ6dmwpZgIelxzTe33Bmpi
         UfTbw8JQsuNt3OBGBLgTte7ouxZhhw33ihSk2gPwW2GKH0NskeNUYjFrs63ufq1hE/05
         k6urX0ZD+o0J4eRH0Q+I1ZhOhzymHpjLnI63IPEsp7E7WBqdpkZRrX6tj0UezPUcpaic
         1RSqJ1TjBVtuAJIo/2E79iNawM5mQHuKgaKIsXZVEhpqN76pErX6WPTrCTKMM0bdGjYU
         LB9mAm3wa7EaTrp6c7ZH51W+Ha/qLvlYmSwyrpiEwfcrnGIqnWTXgx+54Uz5vmu5Ua7F
         +7EQ==
X-Gm-Message-State: AOAM533nQBK/HUCNEJVMvFavi7FQkquzuwJVDFsCQJY6mZSFoUAnxvRX
        Z47K/sdt1gHgOP9jsHbiqpbmqi98QewCE/Rppf5G/Q==
X-Google-Smtp-Source: ABdhPJwm9uSvCy1ijsZZSaxkzwPkbMSb8dX86U9xsSnugGgEuoIv9dKGoYNkQ+OlwWcP85adtm2cZNokYOnEBnsAhZs=
X-Received: by 2002:a2e:9a4d:: with SMTP id k13mr8689552ljj.283.1594125227640;
 Tue, 07 Jul 2020 05:33:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200624150704.2729736-1-lee.jones@linaro.org> <20200624150704.2729736-7-lee.jones@linaro.org>
In-Reply-To: <20200624150704.2729736-7-lee.jones@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 7 Jul 2020 14:33:36 +0200
Message-ID: <CACRpkdYV-gUZJPtwdUhsrbN9hD9Eg6er5-kpOcPJ1vST8gDqTQ@mail.gmail.com>
Subject: Re: [PATCH 06/10] mfd: ab3100-core: Fix incompatible types in
 comparison expression warning
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
>  drivers/mfd/ab3100-core.c:501:20: error: incompatible types in comparison expression (different type sizes):
>  drivers/mfd/ab3100-core.c:501:20:    unsigned int *
>  drivers/mfd/ab3100-core.c:501:20:    unsigned long *
>  drivers/mfd/ab8500-debugfs.c:1804:20: error: incompatible types in comparison expression (different type sizes):
>  drivers/mfd/ab8500-debugfs.c:1804:20:    unsigned int *
>  drivers/mfd/ab8500-debugfs.c:1804:20:    unsigned long *
>
> Since the second min() argument can be less than 0 a signed
> variable is required for assignment.  However, the non-sized
> type size_t is passed in from the userspace handlers.  In order
> to firstly compare, then assign the smallest value, we firstly
> need to cast them both to the same as the receiving size_t typed
> variable.
>
> Cc: <stable@vger.kernel.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
