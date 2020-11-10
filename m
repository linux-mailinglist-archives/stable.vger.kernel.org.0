Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D442A2AD81E
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 14:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbgKJN4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 08:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729832AbgKJN4z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 08:56:55 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB9AC0613CF;
        Tue, 10 Nov 2020 05:56:55 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id a18so11317143pfl.3;
        Tue, 10 Nov 2020 05:56:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mpnRgVxMMUNeiw92WlpVsVqIDwQcDc5++U/ogKQkyQk=;
        b=T1gAQtBJp21GevZ263nOtzKOSdYNNVYrLFUyplmnnWtxuYyJMDrA84ci/Vs9rXsjL7
         UT6lewPfHO7uS8ImiOi0kEs9/65Mb80Y5mjNwFUHEvQdERfY6GXtd8YZ6zbBjnVmePO0
         N+FVfmLVt8RenOXDJjRhYg/9OK0T7+ugMD47B9/+V/z7GUGFsFpxLqtt51VS+bY76AHj
         zFqrDW49wRsa9hj4nWBYTYHXmq8TUnc+/nqrcSXxmViaY6Dw4YmgeSiNse3UnDgkIoC6
         CfZFvEUVtpihVcvxUWjoP9MgRctMPRRIneuAuTubhv60vIqp8Vivyxbn2G3PMRvVu+jm
         98qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mpnRgVxMMUNeiw92WlpVsVqIDwQcDc5++U/ogKQkyQk=;
        b=NPkaPuMMcuG6A0GO4APWcNDSL9GOoK2XLjfT8R40zG0ZQBCVO8mfER2Wb5QdIyS2HR
         ETQsE3DA1As08hzobExssv44eY2cjSJMtgXiyNhKOn52w/wCqGJ6p3xJw0PPNpOzblQx
         pkeCpNfd2puAGepo68VB2IaDwL1c+DQZL5GPOtu5/jGUAEp/eOJxRAn0/CO8RKcWCH6o
         Ts1EbV4Be4zGHN1E+kV5SryXRe7mjsRAc0FMQR2Zxg3w1VReDVVlpOFESXtyU0eGRJzs
         DmJ6RUHcovtWSGc2nIF2YlXLU+S/dtv18PTgIkTDBdcLdRuGTT1XyvqmoVOTeK5QkxhY
         AQ5Q==
X-Gm-Message-State: AOAM532V5O2rR/rH0wR+/OpvBxlSVO6PeJvM73L6VWFNzpm4P2MOdVm6
        13YH72hQfGArivZWb5lYys/Rnm8mos4TtKWaQN0=
X-Google-Smtp-Source: ABdhPJyr1H95bJ6XvUbdzmooeNRvpIzzSrqbSFKrbouxCneBVgAf3t30nKkDIgFz46kU8YjkGujxt/u2tG8EurFdwes=
X-Received: by 2002:a63:4d64:: with SMTP id n36mr8331872pgl.203.1605016613859;
 Tue, 10 Nov 2020 05:56:53 -0800 (PST)
MIME-Version: 1.0
References: <20201105231912.69527-1-coiby.xu@gmail.com> <20201105231912.69527-5-coiby.xu@gmail.com>
 <CACRpkdbNDQrZYx=B7fuc34j-5Mb0=h8VnFROQYHD5DzX9Orb=A@mail.gmail.com>
In-Reply-To: <CACRpkdbNDQrZYx=B7fuc34j-5Mb0=h8VnFROQYHD5DzX9Orb=A@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 10 Nov 2020 15:57:42 +0200
Message-ID: <CAHp75VdohrhNyfARir4e2T-PqjbAs7Dvn37zEw=zziHEwLzNAQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] pinctrl: amd: remove debounce filter setting in
 IRQ type setting
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Coiby Xu <coiby.xu@gmail.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 10, 2020 at 3:23 PM Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Nov 6, 2020 at 12:19 AM Coiby Xu <coiby.xu@gmail.com> wrote:

...

> If Andy or someone else needs to take it through the ACPI
> tree you can add my:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> If I should apply it or if Andy sends me a pull request, just
> ping me and tell me what to do :)

I can take it, but I would need few things:
- Hans' blessing of my series
- tested on top of my series (hence tested-by tag for my series)
- I would like to perform more tests myself


-- 
With Best Regards,
Andy Shevchenko
