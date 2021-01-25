Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163253027D7
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 17:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730612AbhAYQaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 11:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730549AbhAYQ1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 11:27:50 -0500
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10450C061786
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 08:27:10 -0800 (PST)
Received: by mail-ua1-x92e.google.com with SMTP id t15so4614008ual.6
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 08:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=23/I1vn8eLvYOTmtz9QZ6LtBsLe8fOz6qyyvD1EMJkk=;
        b=fUxSD2m05oYMpg/pmIhzS7RtAzx1O0MqWlOIzutbc8hymCttn11Vcdda5PGBvuu04A
         1zmotmq1a/Pxq3+aCmJfHmdMjfX+vhqsIj2VQbRW/wOa2gioQLVoNk63m0euSQ1JYKmF
         K8qf7CPArw+7c1c9paBg+QigAHxgrx12k66pc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=23/I1vn8eLvYOTmtz9QZ6LtBsLe8fOz6qyyvD1EMJkk=;
        b=Dvc3FKevLGEZLVdL0Zno2UOZeiTt612Y+oXoITlr9iGHuxADG+4+mkg6yFgdG6YQzz
         9Hb3xeFj83bHNyX60r8YYbkLWCMvOZ2kNbXavvPf/qFSawUaBkbqQj5S9lokL/C4mtup
         dxoCnT13Cfz9vYh87RknA6MIFGPMyLVQ4Jgultb+5FasWGqgImVF9Ny2dhSj3os8E1QH
         hTWbFdjwgqOJ4rNPxOjBvN+Dtu3QVxBfkI0cObSQEjxnn0jdWuA99ffGeGnkmcmQ0g3k
         q+h92CVQZD7iyZ+RXQKmVMFo/BDrIogWSb6ekfmOq5BNFGe1c+zkFPGamburaFEO0n3t
         X3pA==
X-Gm-Message-State: AOAM530fkDzfjXZBSjhoCJnQv2zGBlO43A0sfqXjg/0/WtAQeF/4wab4
        Tu2fo7+8Byrw2XZWS0dN+NTgNktoWkNp9A==
X-Google-Smtp-Source: ABdhPJx6H+/rnmzsryK6pXLEuUjt+/awR/a6fuGKNz0HNRzeRt1pOaAVbcYKCKS4k3xCn8buZv0VnA==
X-Received: by 2002:ab0:2eb0:: with SMTP id y16mr1109955uay.123.1611592028924;
        Mon, 25 Jan 2021 08:27:08 -0800 (PST)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com. [209.85.217.43])
        by smtp.gmail.com with ESMTPSA id d26sm285976vkn.17.2021.01.25.08.27.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 08:27:08 -0800 (PST)
Received: by mail-vs1-f43.google.com with SMTP id e15so7486599vsa.0
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 08:27:08 -0800 (PST)
X-Received: by 2002:a67:f997:: with SMTP id b23mr1296783vsq.34.1611592027577;
 Mon, 25 Jan 2021 08:27:07 -0800 (PST)
MIME-Version: 1.0
References: <1611585675228156@kroah.com>
In-Reply-To: <1611585675228156@kroah.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Mon, 25 Jan 2021 08:26:55 -0800
X-Gmail-Original-Message-ID: <CAD=FV=UmMuiR=NV_fs7w-JGAdBy+NL1GinLw3=on0rMNNKeDqQ@mail.gmail.com>
Message-ID: <CAD=FV=UmMuiR=NV_fs7w-JGAdBy+NL1GinLw3=on0rMNNKeDqQ@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] pinctrl: qcom: Properly clear
 "intr_ack_high" interrupts when" failed to apply to 5.4-stable tree
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
> The patch below does not apply to the 5.4-stable tree.
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

I think for 5.4 the most expedient thing is to take these two:

a95881d6aa2c pinctrl: qcom: Properly clear "intr_ack_high" interrupts
when unmasking
4079d35fa4fc pinctrl: qcom: No need to read-modify-write the interrupt status

Then it should apply cleanly and you'll get this one fix.

After fixing, you might hit the next failure when trying to apply
("pinctrl: qcom: Don't clear pending interrupts when enabling").  That
one might be slightly harder to backport since it interacts with the
PDC patches.  Presumably anyone running a real system on 5.4 also has
the PDC patches backported so they can get wakeup, but getting all the
PDC support in 5.4 stable would probably be too much of a "feature"
for linux-stable?  In any case, my default answer for that I'd be
happy to help review a backport if someone saw a benefit but I won't
attempt it myself.

-Doug
