Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0C7624F0E
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 01:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiKKAsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 19:48:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiKKAsQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 19:48:16 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3258961B87;
        Thu, 10 Nov 2022 16:48:15 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id k2so9321275ejr.2;
        Thu, 10 Nov 2022 16:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jccwGn6yraR6ggbRcl5+kQG8NY32menh2AFqjtDH2Ns=;
        b=P5U2OVQ/nvzFp6KeGVu5Ia7mi8o7RbKUCzp1mUSahT2VHwPbpgY9kQsBj3i2y39X9u
         /vDBkESTrEV1jp1hEJU730zDEZ+5IU3BiSklFdqzkjQieBAiYk2zxifgADC81VEazg43
         HSTN8GidE/16q+P66QziSy5v49F1LqNfTXz2TmqH/aoji2Pgoy2RLPgyDhXz+7X1IFcD
         R6UYn703346kzahSS8Mppto0C1j9FENa+wsylBCbbDjEiqZbecnqRbsx5lTqxYhImLlM
         iYfTIlgPxirtYdQQ0TIUQozBQNGt0lV14uCSVuT5k6PLeXwa1G8EGKw5TVeX/HQoDqQh
         8oNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jccwGn6yraR6ggbRcl5+kQG8NY32menh2AFqjtDH2Ns=;
        b=F49MVUqu5Xnn8y/1JLmV+feDo1ePEjS0TEsLLX570BJIrLgLKjVSjSucj+uejbJYnX
         1Pzxxy/n4k18y13ookwWZjyK/v85HzSPHygVOUJPTjOnDDsLE6JEXxNbZJ75d9Y4BsJI
         nxlPMnq2oGkko/PaT9jYUAR2AZqFtxvLGS+I8L5Z1/KHfIeQn23+3+a9NMZbUbCynL5h
         T2sqx8RZClaUTD7fPXmwPjUtNKia5fP/KyJi5upZXIE3yVSiCqbvvm5fo+uDqfFk1bsG
         C+pi7S9yjhynEK+ORtw96nSeoIkkOF45pCGt0zyIzph8Z0G3nS+bOKFAkD+mtGbMzRNE
         pXFA==
X-Gm-Message-State: ANoB5pmVIPVBvu9NRqRYLOFyTShv8FrZ6qf/EYthT2mDTiecvyOBq2pH
        2E7vH1kFLMuy1hii9MIU4iESB7z+u+oRSmgiZWU=
X-Google-Smtp-Source: AA0mqf7+WaIbUDbHTenBcZfm6dv2gC5twOFRQs+QLb7avRwCeVzc2ICtecXSFuk0wg0gLob81C9GahjCkx9dzqOEKzQ=
X-Received: by 2002:a17:907:2045:b0:78a:3479:ec7d with SMTP id
 pg5-20020a170907204500b0078a3479ec7dmr49199ejb.671.1668127693508; Thu, 10 Nov
 2022 16:48:13 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYt49jY+sAqHXYwpJtF0oa-jL8t8nArY6W1_zui0sKFipA@mail.gmail.com>
 <29824864-f076-401f-bfb4-bc105bb2d38f@app.fastmail.com> <96a99291-7caa-429c-9bbd-29721a2b5637@app.fastmail.com>
In-Reply-To: <96a99291-7caa-429c-9bbd-29721a2b5637@app.fastmail.com>
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Thu, 10 Nov 2022 16:48:01 -0800
Message-ID: <CAKdAkRTOanSFKzmDgJc9oi1CM9D5D97+_oz31-MM0ADOtY6A4Q@mail.gmail.com>
Subject: Re: arm: TI BeagleBoard X15 : Unable to handle kernel NULL pointer
 dereference at virtual address 00000369 - Internal error: Oops: 5 [#1] SMP ARM
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 9, 2022 at 2:20 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Wed, Nov 9, 2022, at 13:57, Arnd Bergmann wrote:
> >
> > One thing that sticks out is the print_constraints_debug() function
> > in the regulator framework, which uses a larger-than-average stack
> > to hold a string buffer, and then calls into the low-level
> > driver to get the actual data (regulator_get_voltage_rdev,
> > _regulator_is_enabled). Splitting the device access out into a
> > different function from the string handling might reduce the
> > stack usage enough to stay just under the 8KB limit, though it's
> > probably not a complete fix. I added the regulator maintainers
> > to Cc for thoughts on this.
>
> I checked the stack usage for each of the 147 functions in the
> backtrace, and as I was guessing print_constraints_debug() is
> the largest, but it's still only 168 bytes, and everything else
> is smaller, so no point hacking this.

You mentioned that we are doing probing of a device 6 levels deep.
Could one of the parent devices be marked for an asynchronous probe
thus breaking the chain?

Thanks.

-- 
Dmitry
