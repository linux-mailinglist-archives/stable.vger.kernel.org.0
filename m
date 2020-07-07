Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D07C216CB4
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 14:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgGGMWe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 08:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727834AbgGGMWd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 08:22:33 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CAB5C08C5E0
        for <stable@vger.kernel.org>; Tue,  7 Jul 2020 05:22:33 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id g139so24584700lfd.10
        for <stable@vger.kernel.org>; Tue, 07 Jul 2020 05:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8FZ6b+u5hIehEVHEyIzeSnPbhkCZR5qqkr1GS1FN368=;
        b=e2w+qLHC9gUCkhrQmqzM7pcqL4MQF71oL5qMBHAX5ratJP+59bnK/pgD0OdRSrPwW4
         7AOOLfsDr8mOOOi93MQ+vsZFEu5FSmXA3X7gbTIqw09NU8BtkIbifam82tZoVsNCsZ3g
         v/+EhHRjDh0T2V9z4AqrYYUyWORI6uz3ODSOOjD++nnw3LCH1w63npSnX/+atmBAqEbJ
         1reFAxRm1wH47R+DfUTQnWjdP0UirIikXXNbpKsOmdE5V87NQp4Y0BawMh5zHD6upwnN
         slGc2HIP4lZgUWLI5a95vK+Ea5VN3Z8jMI91hxy2apPtqQxu2G3OC5XpaeQa7vkNbVKn
         gr2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8FZ6b+u5hIehEVHEyIzeSnPbhkCZR5qqkr1GS1FN368=;
        b=aoTvynf1n77JbKpBeVMdvaAY7lZFnTXGHNGUibVkPNcD8foswM/vgVn2cBH4lbfUh7
         q3lYaVquBS9qATxGMio0BL123FGxT9KJKUJ2dImbzIn0mVXfJsvPFPlVcv6iUdk/IKXR
         DTom3ewB0/nuGlvKK+Le9qsx/ejrXCDDalBqnzr+321HPQrDqJfHjfcMcmFmPFIlsGV0
         yWoVKquWb9Z9zVW6qLGKk+i9L1xrRkQZdazzoNCjUi0HGJQ6+/J6sEhYk6g1N4PZaWGj
         DpzDVOm0s7O/1Mq1FW1x3eiED6UnxQArYJjwoGmfqpsUOqa3NrElleifnR5NE/uhVXLQ
         AZVw==
X-Gm-Message-State: AOAM533o68nwDM6lKt36X+5aoqYofTizO9irNW9F9RWwFaM6Qek15tP5
        JEkkH4xAL/doXqNsewd/IsZR4050NvjVxZnaBd83HA==
X-Google-Smtp-Source: ABdhPJy10kov8+Mkmk61f0WKp6Ld4d65E/TrwXZO1pVb4/ph9AvFTgkedwG7sd7BumQWUfn2llEmg5uClQm94RJryQ0=
X-Received: by 2002:a19:f20a:: with SMTP id q10mr33221646lfh.89.1594124551643;
 Tue, 07 Jul 2020 05:22:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200622214548.265417-1-paul@crapouillou.net>
In-Reply-To: <20200622214548.265417-1-paul@crapouillou.net>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 7 Jul 2020 14:22:21 +0200
Message-ID: <CACRpkdbb3RCuu52kyzWZr+mDaWrcP5_CTfEp4aN+GddOKxDcOA@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: ingenic: Enhance support for IRQ_TYPE_EDGE_BOTH
To:     Paul Cercueil <paul@crapouillou.net>
Cc:     od@zcrc.me,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        =?UTF-8?Q?Jo=C3=A3o_Henrique?= <johnnyonflame@hotmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 22, 2020 at 11:46 PM Paul Cercueil <paul@crapouillou.net> wrote=
:

> Ingenic SoCs don't natively support registering an interrupt for both
> rising and falling edges. This has to be emulated in software.
>
> Until now, this was emulated by switching back and forth between
> IRQ_TYPE_EDGE_RISING and IRQ_TYPE_EDGE_FALLING according to the level of
> the GPIO. While this worked most of the time, when used with GPIOs that
> need debouncing, some events would be lost. For instance, between the
> time a falling-edge interrupt happens and the interrupt handler
> configures the hardware for rising-edge, the level of the pin may have
> already risen, and the rising-edge event is lost.
>
> To address that issue, instead of switching back and forth between
> IRQ_TYPE_EDGE_RISING and IRQ_TYPE_EDGE_FALLING, we now switch back and
> forth between IRQ_TYPE_LEVEL_LOW and IRQ_TYPE_LEVEL_HIGH. Since we
> always switch in the interrupt handler, they actually permit to detect
> level changes. In the example above, if the pin level rises before
> switching the IRQ type from IRQ_TYPE_LEVEL_LOW to IRQ_TYPE_LEVEL_HIGH,
> a new interrupt will raise as soon as the handler exits, and the
> rising-edge event will be properly detected.
>
> Cc: stable@vger.kernel.org
> Fixes: e72394e2ea19 ("pinctrl: ingenic: Merge GPIO functionality")
> Reported-by: Jo=C3=A3o Henrique <johnnyonflame@hotmail.com>
> Tested-by: Jo=C3=A3o Henrique <johnnyonflame@hotmail.com>
> Signed-off-by: Paul Cercueil <paul@crapouillou.net>

I have applied these two as non-urgent fixes for v5.9.

Are they urgent?
Are they causing regressions?
Tell me if they need to be merged to v5.8-rcs.

Yours,
Linus Walleij
