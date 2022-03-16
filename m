Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C17B4DB5A3
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 17:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346704AbiCPQJr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 12:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350028AbiCPQHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 12:07:52 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC36D60063
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 09:06:38 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id y142so5214600ybe.11
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 09:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jvZpoB6cFnERxO+/0O9vNqVvN/e5HvQCpLV+GN+m+EM=;
        b=ZuKHunVlvCPr8n2rnJnCcZRXc06pbvoWlzf/76uaTkBUikRhgluNU2Rk6KE9kLEYD3
         wOyIlHRF4cb7imwQ4n8Vxt/ySZ3od+Xiyd2GwhCFZ/BXYgEJ7twn+HRCha6VoFy2d+8R
         fL3zdftRyIt6bLxAlZ/35cDjfHD2q4LBTERaZEEXYCIqVpQjkSj3ceoR/e7K/3/DWyjT
         lcOvq2yRFqw79F4vPgHDnOZv4yiaeoZFglzouFQUQxuBCLVBvoRS+JoQ4Z7FjT6SoHaO
         yZ5Wp1wuAR8FkBaCF/x2xGA4BcxjY7QqUORHLh4XA2+NGdtPJz8zi3qImMdleZFIGGyn
         +EyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jvZpoB6cFnERxO+/0O9vNqVvN/e5HvQCpLV+GN+m+EM=;
        b=pQAyCPrETRHkmt35qR7HMk29alycuRwBClsgo8+Z0SReOaL/rE/96jdKAX6U1a6CIK
         hJmXBfo+GUEVP7xdOHm2pShn5n6ilQ25OItwUmQzNeJnWMpeJCkk6TmMxjdnywosxiqR
         Fj9Gq393fbSGhnzlcXfQyv0f6wUMJtQ0IrdH+qZsu8LgevhSGBru8+/C3oF4qluLjwwt
         KEuMQIzjQ5+rpIXLIy3YuLXs00Z7eO8OMbbALBOB0CESDKqUWMlEo/RLkS8sd/6VxWtb
         v5pXKQpoWRnKdMOyW0QZmRL66u/KyQosewO2sheurs8o0kngFRcTmMakJihEUz+3tfZ/
         wuhA==
X-Gm-Message-State: AOAM53368u8ltCfB85074VnMJ3zvbPOy8kKWuA3ByRYaxhx6RQJ+nG8M
        pEa98ZR+SRqh8wfXkOD+b3KBEIDJ0jbhCIVAiCwwcynhml1DoQ==
X-Google-Smtp-Source: ABdhPJzGDIZoeZOns79O6LnbEyJRCLUOZhKQ3e2pXeAnDxeDpIDNA4ynQo9sjR4TbIXAa981O39StZryshfMjFwRLFA=
X-Received: by 2002:a25:f406:0:b0:628:c29b:5c39 with SMTP id
 q6-20020a25f406000000b00628c29b5c39mr591420ybd.369.1647446797921; Wed, 16 Mar
 2022 09:06:37 -0700 (PDT)
MIME-Version: 1.0
References: <20220316141513.247965-1-sashal@kernel.org> <20220316141513.247965-11-sashal@kernel.org>
In-Reply-To: <20220316141513.247965-11-sashal@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 16 Mar 2022 17:06:27 +0100
Message-ID: <CACRpkdYnDDX2Q-ucyPm2N+yh+Fx-X36HbZ49JvS6QNqw0=9cag@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.15 11/13] gpio: Revert regression in sysfs-gpio (gpiolib.c)
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>, linux-gpio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 16, 2022 at 3:16 PM Sasha Levin <sashal@kernel.org> wrote:

> From: Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
>
> [ Upstream commit fc328a7d1fcce263db0b046917a66f3aa6e68719 ]
>
> Some GPIO lines have stopped working after the patch
> commit 2ab73c6d8323f ("gpio: Support GPIO controllers without pin-ranges")
>
> And this has supposedly been fixed in the following patches
> commit 89ad556b7f96a ("gpio: Avoid using pin ranges with !PINCTRL")
> commit 6dbbf84603961 ("gpiolib: Don't free if pin ranges are not defined")
>
> But an erratic behavior where some GPIO lines work while others do not work
> has been introduced.
>
> This patch reverts those changes so that the sysfs-gpio interface works
> properly again.
>
> Signed-off-by: Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>
> Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
> Signed-off-by: Sasha Levin <sashal@kernel.org>


I think you should not apply this for stable, because we will revert the revert.

Yours,
Linus Walleij
