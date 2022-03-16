Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1478E4DB596
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 17:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243193AbiCPQHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 12:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242154AbiCPQHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 12:07:36 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CB65FF07
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 09:06:21 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-2e58e59d101so28338097b3.13
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 09:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2CjuLtiygIAsFw7UyXktfZ7WSDrm/cFs1oSdPGPEYzI=;
        b=OspIU2BhBJZC2NaN5YDDr0A7x7A/09XpSt1tU7QY70aJC3u8VqmuEFWi207WmuMqaf
         6qpmskYfqHgSRy8unq//2bYVJHWb1vxfSgdYNvH5fdCVUM/bf80mEhpqQECcrwvSAe2X
         gUiEcmsspKe4vdCKv2esPk+89ax6t4uP8VqxBw6YQ8EbjI3/flkeivtAn/+fPGsQeqft
         1ERvmYR9WPryF4CqwWcEvCUcFURjV9xgS2UbXOS3zdeCr4yVIaJtK98Xn9G19dBlqglb
         OVZ8gc4OzjNw7apBrhjZ2eOWa5Z3gMehHZCmWycs4iKL6tJjD/HDMh4RKznV0irszz6l
         cw8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2CjuLtiygIAsFw7UyXktfZ7WSDrm/cFs1oSdPGPEYzI=;
        b=ovE0Q7lvxrGfBklPgQOSAcCCqiQJZMdTfh0O1WWRxcRuNm6QrRjt1uypT/one4qsq+
         K6ge7f2l9hCIJrp1ph98UTAHzddv+RWtLu/+HqHK+DJYocPhjasCWtTIKYd6NSEt7Rwq
         IbAni/Gw7QoF8UUWXezT2H09kKZk2cOS6HXcqhc52Kl3X2uF5M0T4Fours0rTeusYPs3
         TZsNBC6dTqLJWZ2jz7Xy4r1ZMkQVmMxQTTQFj7BORPBzqKjJlpj/7Ad/ztbPrjgYoAsb
         zyO5kMoyi9vr8QGMQLohxj/3QxR1ZBzGYmSMyRLovEA/BMT+cuJQeKvOp3SNu0Be89OP
         l+uw==
X-Gm-Message-State: AOAM5309wzMVem0E6NQfL/EWBk+82CWmoVmDPCUe+lr8rdXeAIZFOCV4
        wgB6nwPiWXZU9Ujo62C5n9gqsg9tJbENQ/kX25zxdw==
X-Google-Smtp-Source: ABdhPJygYdyJ2oD5MvUWxH7zac5rsixkpWaHXwVbW8sC0RtxEydpTGWI+yMWqIGchfBWGr94pp7UVI9eQAkP5mAQKVc=
X-Received: by 2002:a81:9c47:0:b0:2db:9e18:6e75 with SMTP id
 n7-20020a819c47000000b002db9e186e75mr778283ywa.437.1647446780804; Wed, 16 Mar
 2022 09:06:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220316141354.247750-1-sashal@kernel.org> <20220316141354.247750-11-sashal@kernel.org>
In-Reply-To: <20220316141354.247750-11-sashal@kernel.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 16 Mar 2022 17:06:09 +0100
Message-ID: <CACRpkdauQjYyouf-TeVuDeLQ6SPtXJpV9QGeC17BEBs5Y_Fr9w@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.16 11/13] gpio: Revert regression in sysfs-gpio (gpiolib.c)
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marcelo Roberto Jimenez <marcelo.jimenez@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>, linux-gpio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 16, 2022 at 3:14 PM Sasha Levin <sashal@kernel.org> wrote:

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
