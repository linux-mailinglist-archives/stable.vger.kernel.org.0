Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C2330278C
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 17:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbhAYQM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 11:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730329AbhAYQMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 11:12:10 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF055C06174A
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 08:11:29 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id b5so2858308vsh.3
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 08:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hig6/IreCUlDumVNstNRr9CcTHNDRCGBluvlK3pY3/I=;
        b=FbpiDf3ND9qTov5f4Wg6JF/1qjQl/kh8FHCcoRiZ6Y0D1MIDtzN9ir3MxjXZO85vE7
         AFkSoQUv6ht++QBit4oMYmeqejC3y8PeLN7e++HetAu1fF/2eOFwRp2zN60bAGfe7i2O
         w1pDvr78A//yT1RgUJgKClWMmBde9vTuqVqNU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hig6/IreCUlDumVNstNRr9CcTHNDRCGBluvlK3pY3/I=;
        b=ISaXz+huwmifc4aGnwTk5W75cdWj8vbtNY7SbXnB677E6mT3VttRnT4UpZ0woyn4NR
         R3zjqOmfRWp12NchoJ/xyHaT1SbtCLd8xeN9Wc7Q06QdmJPfa2G6YgwosoEANmd6iZq2
         uQnH4moM7xO0aJbo8C8BAY0BVlVc81rycydqEKR17ueSl/jyLyszmGk65qNg72WhgPRJ
         dyt6cHT3KkKLop0lZWAp8RbZAA9gHyICrd1+dmS6GTMcI3TZVWVXUOHDVyFJK8/AcagB
         ly1EuQ1bNj3MFgwKN72CviaFlw4EHuUka0GUbev+JJ1FePt5id1SXg3xpUe+dP6XVmxk
         kZmA==
X-Gm-Message-State: AOAM5309PXnY3TqQTqHhw42QN/dKGTRfkiSYXJPLcjkZPd/H0uPyNMUw
        PT7uwDKuLr30CvB9KvNhsZu7XVfXme+k+g==
X-Google-Smtp-Source: ABdhPJz4+CFYQTWzNXTks+R93ayHCVT4QOOKa/YVBqZdcLshPBlJ6wN/tu2FdUsZeeNhrH0RfeBHxg==
X-Received: by 2002:a05:6102:22da:: with SMTP id a26mr1197930vsh.56.1611591088658;
        Mon, 25 Jan 2021 08:11:28 -0800 (PST)
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com. [209.85.221.170])
        by smtp.gmail.com with ESMTPSA id a22sm2602359vkm.0.2021.01.25.08.11.27
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 08:11:27 -0800 (PST)
Received: by mail-vk1-f170.google.com with SMTP id q140so2439254vkb.1
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 08:11:27 -0800 (PST)
X-Received: by 2002:a1f:4901:: with SMTP id w1mr1142412vka.17.1611591086775;
 Mon, 25 Jan 2021 08:11:26 -0800 (PST)
MIME-Version: 1.0
References: <1611585674115135@kroah.com>
In-Reply-To: <1611585674115135@kroah.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Mon, 25 Jan 2021 08:11:15 -0800
X-Gmail-Original-Message-ID: <CAD=FV=Vx02dQ2icjt7D3gC7ew=m27ZMKKhE1jsYD4hcFcwwN8g@mail.gmail.com>
Message-ID: <CAD=FV=Vx02dQ2icjt7D3gC7ew=m27ZMKKhE1jsYD4hcFcwwN8g@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] pinctrl: qcom: Properly clear
 "intr_ack_high" interrupts when" failed to apply to 5.10-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        LinusW <linus.walleij@linaro.org>,
        Maulik Shah <mkshah@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Jan 25, 2021 at 6:41 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From a95881d6aa2c000e3649f27a1a7329cf356e6bb3 Mon Sep 17 00:00:00 2001
> From: Douglas Anderson <dianders@chromium.org>
> Date: Thu, 14 Jan 2021 19:16:23 -0800
> Subject: [PATCH] pinctrl: qcom: Properly clear "intr_ack_high" interrupts when
>  unmasking

For 5.10, we should just take these 4 patches:

cf9d052aa600 pinctrl: qcom: Don't clear pending interrupts when enabling
a95881d6aa2c pinctrl: qcom: Properly clear "intr_ack_high" interrupts
when unmasking
4079d35fa4fc pinctrl: qcom: No need to read-modify-write the interrupt status
a82e537807d5 pinctrl: qcom: Allow SoCs to specify a GPIO function that's not 0

If we apply all 4 together we should be good and no backport should be needed.

-Doug
