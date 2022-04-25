Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEF950E9E4
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 22:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245070AbiDYUMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 16:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240903AbiDYUMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 16:12:21 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BD21240C0
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 13:09:16 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2f7d7e3b5bfso47654057b3.5
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 13:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NfxDulmsqhxXYyN5BV9MHprI6PjKOv1s+ZBzAf57s4s=;
        b=rAreSYbIYa7d1O6k0eeBoQixeROl7b4GeOBqgh4WDsQEPcfgAgTbGYjLwan/Vhvori
         3rKztPP7u1/1T57or6r7tIyxMtjNvvdR59iU8ugQjY/VkRBSn5dyyIB84PY2URQnfMHq
         6Tk4X7ng4dRI0IZnnvGMDJhkmMpozAefRCn3FfU/UQWwwUAyJEQTWXP5yQ5PZF4NX4az
         SqXjiK6VhHcaxA4kw3r0Ib0+V3IPHMFDT6GyUjPzTnOcLziEK+uv+evIiUv9WoLiLkZ2
         u1cI+zT6AEgLMrm316QTOYk8KstUMLznGxEXS4M5M1sW++g5oPo5V4MzA5av/I2F6yTr
         MgwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NfxDulmsqhxXYyN5BV9MHprI6PjKOv1s+ZBzAf57s4s=;
        b=JC43+brYhUpTg6G1eh7PkbYdyCgtC4lnc8SFWMrhU471esDUsuLxK6lrxsdDUIzaZV
         4R7lH2BmiKZpPJ4ajEzxTaWQ7IaDxUUz5jQHH7QyC+zhr23grePsTbyz1QldFRdtqQwO
         5QQAeeuQhs1yvpLetauS10/lerowd0V1w+w9hufCnmYuYX4FMIDcsjb5cA06SX8rgiXQ
         1dOigLtYAxfvBIo7m4KRD+UVUmBz0PSNzBifajhAvDD3SjRfjf9hOAKjGJ+cEZeFLLXj
         tuhVh6CCzVakPaJeBvgn//6yKdleEZ2tU6OknCX17OYaizVALMuCtI0tjZ2hUMRPhT8F
         KboA==
X-Gm-Message-State: AOAM532fiFFnftfzCdTTT7E3wB7W5aBSSYk6XR+DFMOlG7PhP7sa4f/j
        drvDQwPGDFc9d4v6bo25v/sglN90HB4WRRhp0OodMw==
X-Google-Smtp-Source: ABdhPJyF695Tiq9KWQzZuGHqu4LK5YmP82HABpDAJ9oWVE5UTcdqsbMaZTDMDolz5sNv29B66+jrLXn+uK5V9V//hCo=
X-Received: by 2002:a0d:c4c2:0:b0:2f1:6c00:9eb4 with SMTP id
 g185-20020a0dc4c2000000b002f16c009eb4mr19186232ywd.448.1650917355287; Mon, 25
 Apr 2022 13:09:15 -0700 (PDT)
MIME-Version: 1.0
References: <34212129-bb2e-46d4-4536-28f11b1c61ca@living180.net>
In-Reply-To: <34212129-bb2e-46d4-4536-28f11b1c61ca@living180.net>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 25 Apr 2022 22:09:01 +0200
Message-ID: <CACRpkdbw1E3qOc=+PXyO3tQSXpa0yHd5YTbXMe97dPq9vCcTVg@mail.gmail.com>
Subject: Re: Regression in 5467801f1fcbd
To:     Daniel Harding <dharding@living180.net>
Cc:     brgl@bgdev.pl, shreeya.patel@collabora.com,
        linux-gpio@vger.kernel.org, stable@vger.kernel.org,
        andy.shevchenko@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Daniel,

On Mon, Apr 25, 2022 at 9:00 PM Daniel Harding <dharding@living180.net> wrote:

> The commit "Restrict usage of GPIO chip irq members before initialization" breaks suspend on a
>  Dell Inspiron 5515 laptop in a very severe way.

Does this commit, which is already upstream in Torvald's tree, solve the issue?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/gpio?id=06fb4ecfeac7e00d6704fa5ed19299f2fefb3cc9

Yours,
Linus Walleij
