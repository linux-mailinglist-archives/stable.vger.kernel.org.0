Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 069346A45D
	for <lists+stable@lfdr.de>; Tue, 16 Jul 2019 10:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731702AbfGPI4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 04:56:54 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41439 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731706AbfGPI4x (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jul 2019 04:56:53 -0400
Received: by mail-lj1-f196.google.com with SMTP id d24so19119970ljg.8
        for <stable@vger.kernel.org>; Tue, 16 Jul 2019 01:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=InUWrv7LAkQKvZ+McQ69NdIMdHUt9wQBtSn0Ql2S6b4=;
        b=NYWBxxtkEarHHKN4dpAk9Z3o+e7dlOaIFbYRjCgVyDUXE5/Q7hCWk37cEjSrv+kDaI
         v7yHpJDZmf/3oYGlbX117KQzLJ4umJQ5+OjX6dw31RpDF48K6L5OswFhXCK2/NpCeonR
         jNNqGULBmAFVTWgakUEu4ZcLpiMAjEecaPzDROkawKgKwYej+eNtIu6Sj0yns/uOU40q
         TQ/2gC66WBgRApLvY2Qn8suKx1B64NI8JQeg/SyQBB+mBkNPYCOO26gNFyyVaq5smfTc
         2mZLXc/xf0XXa5oYidiHELyQSWN/3pnZoGg9/bVf2tLlzPOewh0d4cEHHMqWpOZfR0CT
         F65A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=InUWrv7LAkQKvZ+McQ69NdIMdHUt9wQBtSn0Ql2S6b4=;
        b=iOKVT1Zl4E8b2CvMUATaEoMZNh+1QxMguF/ksra+4nNg1pNxKl2T0d+4fv7OnjPc0X
         iUhkMHcgzKsRdTaB/vkKhY2ZfST+razze3G/nrU4/fpp+8PbLh7PQcHL0m9NDIM3Vz5s
         fc9ralYmXMT9dHH6mc5o78X///mlkO1PbHBe6tahBIwxotAOm44grXToNaYGfdWZUTF4
         wJzQKJldWCs/HQ++eNG1XI7KWk5nuGdopTLNy3w+HcJSmIDuvsXGz/isnWap15D4PUCX
         a3Hx8hsjDJGx2jYBYWWnbJ9R3759HWgmxEFQgCuWkKtjvr/FkhmrDjifr/LJaTgClTJp
         ZmZA==
X-Gm-Message-State: APjAAAW8O/GKxbhM1NvZV+FAItp59GdgnCuWSN7l22zE+OEgqXIM/Ymf
        xxKsZp86M6Eor0usfmiWRO3mIMl3MZIOF49B4mXyMw==
X-Google-Smtp-Source: APXvYqz0/LleO9xJcnbDEQsKjfgEBzAose29BV4VVCT9BK/mzxrXWaVnDmJyWLu7V7p65vgCAaGIQkI8PUIsBxalh2E=
X-Received: by 2002:a2e:781a:: with SMTP id t26mr16865993ljc.28.1563267411846;
 Tue, 16 Jul 2019 01:56:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190715204529.9539-1-linus.walleij@linaro.org> <20190716012712.BC9F22173C@mail.kernel.org>
In-Reply-To: <20190716012712.BC9F22173C@mail.kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 16 Jul 2019 10:56:40 +0200
Message-ID: <CACRpkdaLQzax2XPJ4j1a9gNw3r=ZizVSgsbLFGAycCLd2TzD0g@mail.gmail.com>
Subject: Re: [PATCH] Revert "gpio/spi: Fix spi-gpio regression on active high CS"
To:     Sasha Levin <sashal@kernel.org>
Cc:     "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-spi <linux-spi@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 16, 2019 at 3:27 AM Sasha Levin <sashal@kernel.org> wrote:

> v5.2.1: Build OK!
> v5.1.18: Failed to apply! Possible dependencies:
(...)
> How should we proceed with this patch?

Only apply it to 5.2.y once upstream.

Thanks!
Linus Walleij
