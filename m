Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 552B411930
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 14:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfEBMd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 08:33:28 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46019 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfEBMd1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 May 2019 08:33:27 -0400
Received: by mail-lj1-f195.google.com with SMTP id w12so1985934ljh.12
        for <stable@vger.kernel.org>; Thu, 02 May 2019 05:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NNbg9gANrmmsdRd0Zr7L3nd9Jkm0CdKUVf+M5cGLvuM=;
        b=UIbMFWd/JYY+vUYAN8fUQuk9tp3wNqXO1KTtAlXNBtgaY+CpZB/3lqHTPEYL3n3CFn
         VYLkMAJqXjP+r34aM8nP0uGZgfy3/QQ+z/wBMvBuU27smCYSuVrf3vN5OTGfzHuisBt2
         1Iuv4GSrCD+Q6q1r/SyetoaX7cxlLvgjF/oqqlIec7cFiZ6t1IatG9npCvkKd9kdBtFq
         aD1kKsDu+eDksFPALxg/lU1rBPYTBbcpy0uJCPla0XiBY2fKOFPj0Gy3UrOYVkLK7ZgI
         vtsRo8P6wbpA1BfJENOAeBTM13u74i9iQOZTWfWkHpfSxgQd4KXHB4fW0nnp5teis+GJ
         hGOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NNbg9gANrmmsdRd0Zr7L3nd9Jkm0CdKUVf+M5cGLvuM=;
        b=dQlIG1bs3F4yeYT7EQPLufM7EyBGlFGSFHUmlYTlBYhmMo4GqHw7kol0ZVviVdSBMt
         z/JigIlcD+VR/3/nNmY1R9K0XIzEyZdoDK6mK33jCXDM//nsbgVWayI8TP+j/b9fobG1
         TXG44xjponr3bftVIsjnaX6g2iYGxv8i31UUdMAZdNnIvpAeCxI7jq78kshL9LzH4ikH
         yCBy3ghSzB2F/4KN58x0VZlHbx9TOrYYIbELFQeSsXYE0UbZJBxedJisSM3oOewp7XpY
         qFKP6f/9pHsGCyVY2t0udWh6NL7NzoYdhk4T4vA6M2PUnQnEQtAeag/M9ETWlaXXyHG1
         DXPw==
X-Gm-Message-State: APjAAAUc644jsIRU5K92/cV1V530PnUFt1Pc4foXOUGtKQ169M7TuSkR
        o+7PwRCPGOautfHbPydPcNieKoq+0OcB0WzRWGI=
X-Google-Smtp-Source: APXvYqwX7rPZE0WLmjSK+B42RS1OHvVk9gkcTvWQWjpSvtOXsU0JzLqbEpqCeg7neShbXwqbf26nIk+rCce+i35yLfo=
X-Received: by 2002:a2e:7318:: with SMTP id o24mr1659257ljc.138.1556800405586;
 Thu, 02 May 2019 05:33:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190502113020.8642-1-festevam@gmail.com> <20190502122645.C5FD52081C@mail.kernel.org>
In-Reply-To: <20190502122645.C5FD52081C@mail.kernel.org>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Thu, 2 May 2019 09:33:20 -0300
Message-ID: <CAOMZO5B6GJ_OCX_22M+RQ6HQG=_kxEcM7x1X8+VL9fRc+jHx2w@mail.gmail.com>
Subject: Re: [PATCH] ARM: imx: cpuidle-imx6sx: Restrict the SW2ISO increase to i.MX6SX
To:     Sasha Levin <sashal@kernel.org>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 2, 2019 at 9:26 AM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: 1e434b703248 ARM: imx: update the cpu power up timing setting on i.mx6sx.
>
> The bot has tested the following trees: v5.0.10, v4.19.37, v4.14.114, v4.9.171, v4.4.179.
>
> v5.0.10: Build OK!
> v4.19.37: Build OK!
> v4.14.114: Build OK!
> v4.9.171: Build OK!
> v4.4.179: Failed to apply! Possible dependencies:
>     6ae44aa651d0 ("ARM: imx: enable WAIT mode hardware workaround for imx6sx")
>
>
> How should we proceed with this patch?

I can submit a version for 4.4 stable tree once this hits mainline.
The conflict resolution is very simple.
