Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB47045363F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 16:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238489AbhKPPsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 10:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235140AbhKPPrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 10:47:55 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930B4C061570;
        Tue, 16 Nov 2021 07:44:56 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id b15so89491674edd.7;
        Tue, 16 Nov 2021 07:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dPtLToE5cD5TDCZBnySfRMPwBDNfLu66tXoIIjjwJg0=;
        b=jwgwFDbpsVXEPMwxwbCql8RXmlxwLVobB+ehZ4Qi3/nY6x9PNwpUWwYXLGAjxvFs7F
         whBDitbMDMPaLHZkU9lVKti/6Obfyi+WpoW/gbImvr908RN8cfwX8BRrovmXeU/mcowq
         WU7TjQB9W+pnUcTdFvTCoWQhHbEieEBPLWYQSrAWpvOFAGXHG7WadukIhPzHx6maVU/5
         Zuvx2p54Z376AGE2zvOa1zJqAtY4PZL+NAedQtg3QKoz3bIJ2oDBim0FgXeLhAfF6p/S
         IzK/k8MhGljJgaU0rErxOKTGTqtL/orYRdIZbRkvoSCfieC4sAwqAMhw2+C9HLGbhxbk
         X0zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dPtLToE5cD5TDCZBnySfRMPwBDNfLu66tXoIIjjwJg0=;
        b=abs8mFvCs9WmiFDl3Niz6b84zlMUeL4BURPzLoC1xFAL/RCJFc0scqco8Rm0MlbQ/L
         z4G9MCOUmHPAQ2H2cAfA9aNu0evQXu0M+7awtylJi+nzBgx1eSw+7K5C5KIGYgDaAmEl
         L/U5yghHUe30Lt7Pt2hplWaPUqdVWzDEJBO/h3ajkoa1Pn4yDYebNF9oP1ZgtZPzSFJk
         LTzz1h0Pj8AoEQreLl9xVs1glvTOR0ixHRZOqMc5cFw0Dz4YD+HfKyD9iI3oU75i0zsq
         tCO9MwGClyRIL0ZdB4JF9XEJ06RDOvJd41SgrvhCXMcMfvZAtYM+XSCppsJG6BK2gKHT
         1xUA==
X-Gm-Message-State: AOAM5321+H74AEhJ5dkLsRT+vR2TokdRAEdwMBeJCd6rjrCdPRiFhBrt
        CKhcpfwOZV2mfhnORfCgxPou3oSYEwh5gc3A9Zk=
X-Google-Smtp-Source: ABdhPJxiHT47RdHiJkKx9zv8ZX+VcqnDh///cEECVDZ+1Ed5hCpns4qOt9B3FFUtYYGKkfJknz4KnkBIZhbKNYRBekY=
X-Received: by 2002:a17:906:6a0a:: with SMTP id qw10mr11538826ejc.141.1637077495214;
 Tue, 16 Nov 2021 07:44:55 -0800 (PST)
MIME-Version: 1.0
References: <20211115133745.11445-1-johan@kernel.org> <20211115133745.11445-2-johan@kernel.org>
In-Reply-To: <20211115133745.11445-2-johan@kernel.org>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 16 Nov 2021 17:44:14 +0200
Message-ID: <CAHp75VeGinEWv0BuAsrHtif2b1p26uUEmSRqG4_y76vDdvNKAw@mail.gmail.com>
Subject: Re: [PATCH 1/3] serial: liteuart: fix compile testing
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilia Sergachev <silia@ethz.ch>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Filip Kokosinski <fkokosinski@antmicro.com>,
        Stafford Horne <shorne@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 15, 2021 at 3:44 PM Johan Hovold <johan@kernel.org> wrote:
>
> Allow the liteuart driver to be compile tested by fixing the broken
> Kconfig dependencies.

...

>  config SERIAL_LITEUART
>         tristate "LiteUART serial port support"
> +       depends on LITEX || COMPILE_TEST
>         depends on HAS_IOMEM
> -       depends on OF || COMPILE_TEST
> -       depends on LITEX

> +       depends on OF

AFAICS this is optional and prevents compile testing in some cases.

>         select SERIAL_CORE
>         help
>           This driver is for the FPGA-based LiteUART serial controller from LiteX


-- 
With Best Regards,
Andy Shevchenko
