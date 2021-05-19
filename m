Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1C3389A16
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 01:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhESXwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 19:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhESXwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 19:52:23 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5C3C061760
        for <stable@vger.kernel.org>; Wed, 19 May 2021 16:51:03 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id e11so17534415ljn.13
        for <stable@vger.kernel.org>; Wed, 19 May 2021 16:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0sYniuRP4wqiZIQyuEg/qe+aI6tAjP7d/4JXDzHYsZE=;
        b=oJSxYQ20m+wQOda1P23ynKuBf7Os0nvDkxJdPhD3ae9EpqZJ5EJcbVWaetqjgDTChG
         m+UY5QlrVyWMNXVavl7mV5o+QVfRaiwokaHzsQGeQaGDwkKV/dNDXu4NH9+7FAntM2ur
         vckz0r40XkvPQz3ECPnAoSbDHtpqPxvizAHIOrtnT/doJd9ny6law0sNeMYJ25K7cqLL
         Qer717RNGQ3xHnLCin95829gw8zCa2fjgrwDm7FPgGZg+RT3jUGxnLDR6t8685XzVznU
         OXJ/DbXA2usE53/9Cse6ll586+207AxFauPM4/y/+XbL5LZaG9zemRENkuUZA/1a2Djy
         GGKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0sYniuRP4wqiZIQyuEg/qe+aI6tAjP7d/4JXDzHYsZE=;
        b=KVjwSAR3bwRlwV8v4eaLdF2u7DfmDRsdhjlxNxswhPSGnQ4h4k5AB+jM6hXhCfLmco
         vVCB/c5gD0cuj4gjp9gBsdfCh2xfETCRRjkSZM088/4fnf2y8LQPmDLA0Irqkbk/u3DR
         6M7ndOGi8Dc+SFLHld95cLd7/rxeWstejOuvVHj6eIo0BbvcRB+C1lxw4xJ6MEe4Kebq
         AYwM/Zk4BncXSr8du05Z7aGjyQgQEaEBTpZfbbBtZ60UhFJMm9Ceh7of7Z0DHsWzKY1d
         enl2JDbrzPXenxMMXjSo0/zT4DzLR1/1cQai/lNy3iCsZnFbUdTTJvvXuHNoweDstUT2
         31Cg==
X-Gm-Message-State: AOAM530nfSidImdnxYXHP8LFm27vPZk7DZ40EHd83Opx5AVpxUw5dnnm
        5/76yGAP/Su7Z+7yyi0vHZEFuo4qjq8n3SBenAmehn9g5Ag=
X-Google-Smtp-Source: ABdhPJwp8DSHuZ2aQWqeW88esMeyMWsFvWsiq/HWOPEM1egcEKRRQzdxAwFFE9gysyEhGpY+ZAwyRtwQA5Uc0QHZTJg=
X-Received: by 2002:a2e:889a:: with SMTP id k26mr1150709lji.438.1621468261465;
 Wed, 19 May 2021 16:51:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210512210316.1982416-1-luzmaximilian@gmail.com>
In-Reply-To: <20210512210316.1982416-1-luzmaximilian@gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 20 May 2021 01:50:50 +0200
Message-ID: <CACRpkdZpm4w6Ym2p9xTsYpkU7CR531aLUUxXj54tssoqd6c9=Q@mail.gmail.com>
Subject: Re: [PATCH] pinctrl/amd: Add device HID for new AMD GPIO controller
To:     Maximilian Luz <luzmaximilian@gmail.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Sachi King <nakato@nakato.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 11:03 PM Maximilian Luz <luzmaximilian@gmail.com> wrote:

> Add device HID AMDI0031 to the AMD GPIO controller driver match table.
> This controller can be found on Microsoft Surface Laptop 4 devices and
> seems similar enough that we can just copy the existing AMDI0030 entry.
>
> Cc: <stable@vger.kernel.org> # 5.10+

Why? It's hardly a regression?

> Tested-by: Sachi King <nakato@nakato.io>
> Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>

I've applied the patch for next without the stable tag for now.

Yours,
Linus Walleij
