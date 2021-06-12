Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0213A4E6B
	for <lists+stable@lfdr.de>; Sat, 12 Jun 2021 13:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhFLLzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Jun 2021 07:55:07 -0400
Received: from mail-lj1-f175.google.com ([209.85.208.175]:33329 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhFLLzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Jun 2021 07:55:06 -0400
Received: by mail-lj1-f175.google.com with SMTP id l4so711815ljg.0
        for <stable@vger.kernel.org>; Sat, 12 Jun 2021 04:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2KkBXOCZdfq/rt6q5vREjQ868AAMzp+m/F5l/ILKBhA=;
        b=dI2qo1jU+Z0JRb+dKT8m/wGrggSWIylhoNU4SkWfKCRmt85UGT+ojj3lTPPjp6tvmJ
         lO71J82qMMhs0rRBkjIxcOcaqhDzQwaf9yQ6X/KWtMwpNYPAGIO37nI6m0LOu5Y3WJ1X
         FQqDKzIgP/txY0rl+id7n29OlNva2PRkJ84JaxqBngAtANKVV78q7ffJcbkS+G3AVva/
         GOysW3lDgLRe3nKJJKmhQ6yhmj4Oae5iAE9TFMhWNx71R4AZJ1fxL4IzTo70WR+cKleF
         RXiK2JL6pscWiPAC8s098ePdiVxvO/eWzJAUW2O1KQp4eAmw027EW3Hx9d/t2tDOLjJr
         JOiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2KkBXOCZdfq/rt6q5vREjQ868AAMzp+m/F5l/ILKBhA=;
        b=G3aL8StdDoYXDzkKfdKx/sHreP/1WDuLroZOKO95QO4MUbHRbX1ZLqSO1QcUzd8msR
         riNsXzBgYbnEnhMXcNM0cY0DdkrQbZPIgzZRYZaKwz8va9pFDcgfP3/LRRhzcha53tjb
         1MkixpKvANs/S1P50cOUogc3TZTdxN1VOJFBfyhKMucYAELDyZ6FhmXdEepQRmoe0/wz
         RWhjgoM/xezUh+yrvA8stBPSUeBTgmAGZZeiD70V/rP9sjd+O4Tw7zmShOqWRt8mlSpq
         NMAACCUkkgcArH6M+7zMH5RYWuLxZrhYIyN8rdQLokY/7sO9SXC4qP3UV8MMlohtSj9A
         kB0g==
X-Gm-Message-State: AOAM530/IkhBw1mffE+lkt1TOA7QPNXmUqS+rxeUm4NdY+hYUg8mm11y
        YaZMw8OuoBWI4sWx4uTTVapI+MSoMW0YVLM/Gys=
X-Google-Smtp-Source: ABdhPJyLO1P+rUjJJXUVvU+t71eOdMwQ1HbeOGUN+A8zac/2hKdsmF8J+Z6VjYx7b1n29OqJALk19hx6jhM/e2YWUFc=
X-Received: by 2002:a2e:97d1:: with SMTP id m17mr1955305ljj.490.1623498726557;
 Sat, 12 Jun 2021 04:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <1623396129105150@kroah.com> <CAK8P3a1Y2g+-tKy=zD3yKhxjhVuWdMQvuP_MRbxzdeQFvAB-pQ@mail.gmail.com>
 <CAOMZO5DMQJ6GG+jfKO1a_HmfN_hwuL3De=KEV=g9WN7ejmMK6A@mail.gmail.com>
 <CAK8P3a1R0xNRLYrC9oKgjUDQj2GwBKrcE1FfDqfryLBeg-X7dg@mail.gmail.com>
 <VI1PR04MB4478C3FD8C6600ED9A36AAD58F349@VI1PR04MB4478.eurprd04.prod.outlook.com>
 <c6c0efda-d84f-7a-48d-9cc2c5a6ba63@gmx.de>
In-Reply-To: <c6c0efda-d84f-7a-48d-9cc2c5a6ba63@gmx.de>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Sat, 12 Jun 2021 08:51:55 -0300
Message-ID: <CAOMZO5BVtEAWVXqq8c=oUw6s5k5G6xWfL17QU2+JY1Ak8mpshw@mail.gmail.com>
Subject: Re: patch "Revert "usb: gadget: fsl: Re-enable driver for ARM SoCs""
 added to usb-linus
To:     Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc:     Leo Li <leoyang.li@nxp.com>, Arnd Bergmann <arnd@arndb.de>,
        gregkh <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@kernel.org>, Joel Stanley <joel@jms.id.au>,
        kbuild test robot <lkp@intel.com>,
        Peter Chen <peter.chen@nxp.com>, Ran Wang <ran.wang_1@nxp.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Shawn Guo <shawnguo@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>, Marek Vasut <marex@denx.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Guennadi,

On Sat, Jun 12, 2021 at 5:38 AM Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
>
> The fsl_mxc_udc driver was originally developed as a part of a DENX
> project, adding Marek to CC to have them check internally what their
> preferences and requirements might be.

Li Yang has already fixed the problem:
https://lore.kernel.org/lkml/20210612003128.372238-1-leoyang.li@nxp.com/
