Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A89259DAA
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgIARwj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 13:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgIARwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Sep 2020 13:52:38 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3A2C061244
        for <stable@vger.kernel.org>; Tue,  1 Sep 2020 10:52:38 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id d2so1293959lfj.1
        for <stable@vger.kernel.org>; Tue, 01 Sep 2020 10:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CMpumXM77amvS49xy/9DUPd0nToJWJsPGlhtEwylJnk=;
        b=jEUATbvPxL4kAIYHkXIwoYi+GGSwy30deBV1xEisCvLy42+AeuuUbtSSMFhjSVDXFT
         QL8dys2wre+530ezC5hLsEaDgQzfqNkRQ5IkWdI+nkdCjrWCq187OvcpkDXh0Fu6wGPR
         uLziA+UTyf2Co9pSHVky6Uhz6v4aFt7TsZN6KSyOg0BVnINFR9PNYA51N/V9Iwgo91PZ
         7YzcBS0VmydOO9pDsRtVgZKRZ7xmkN8nwscG5f3lxf9R0xbtrgAVOv37/cdIe9JbH9T6
         TVzMzAPT7z/09HXiI7jzAXJR5q1s6TqlWPfkcXFPOXGlA1xO9TmwTFrRxt2efTluBt3g
         84/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CMpumXM77amvS49xy/9DUPd0nToJWJsPGlhtEwylJnk=;
        b=qqXWFAIZy5I8szZ6FbsCBAHhiHjp0qQZrZhYLhTkOC0FCgyg36UCtPiMN99AcEWvDh
         UN/HHW92xFKsnrDap7JrEEfJk2L2kmRvJKw9nBUuUYL08/AxMQ9hNwZmtsO2ob1tb/xZ
         FWzh5QCwRB5H1A1WOkPLevEj1r2bG6YEguFVBFbfJn5Bn60Lj5PueHMl/UbZEf44CcA5
         pezdWcv522i2mD//y1TMxTunNfAw9aUcih9r3hf1HD8Rdi4/uFiq3FHVG1rSYAW5HJQN
         VbR89TLjhAB8vO1FDX9Ze8Sjzvmm1dWOm5tLWyTwApc0p5eREfZWp2LesgnmaSjM8IRe
         sjLg==
X-Gm-Message-State: AOAM533UsemfCTOYL8yOEUT8+StPzLkOJIIIAbdjBadMbA6NPZJPMSFw
        U9Vd9PInTj/vvTV+CltdYa1Hs64Wl18rbO7+JERMSg==
X-Google-Smtp-Source: ABdhPJyyV/RxbSMWOGBItEFz4WiBpWYrsnMK3PtnzYYJr3XWLVbRhW7CnNJ4zOC11FhCqJC/ReoFdFPIRoAi/OMoOLo=
X-Received: by 2002:ac2:4c07:: with SMTP id t7mr1221019lfq.194.1598982756539;
 Tue, 01 Sep 2020 10:52:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200820203144.271081-1-linus.walleij@linaro.org>
In-Reply-To: <20200820203144.271081-1-linus.walleij@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 1 Sep 2020 19:52:25 +0200
Message-ID: <CACRpkdYHB2SFVqpuL0GtPe-yk7wrA=nFiQk4f7Kj0aFB9rOAvw@mail.gmail.com>
Subject: Re: [PATCH] drm/tve200: Stabilize enable/disable
To:     "open list:DRM PANEL DRIVERS" <dri-devel@lists.freedesktop.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>, Sean Paul <sean@poorly.run>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 10:32 PM Linus Walleij <linus.walleij@linaro.org> wrote:

> The TVE200 will occasionally print a bunch of lost interrupts
> and similar dmesg messages, sometimes during boot and sometimes
> after disabling and coming back to enablement. This is probably
> because the hardware is left in an unknown state by the boot
> loader that displays a logo.
>
> This can be fixed by bringing the controller into a known state
> by resetting the controller while enabling it. We retry reset 5
> times like the vendor driver does. We also put the controller
> into reset before de-clocking it and clear all interrupts before
> enabling the vblank IRQ.
>
> This makes the video enable/disable/enable cycle rock solid
> on the D-Link DIR-685. Tested extensively.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Would someone have mercy on this patch and review or
at least ACK it so I can merge it?

I offer any reviews in return, on stuff I understand, such
as panel drivers.

Best regards,
Linus Walleij
