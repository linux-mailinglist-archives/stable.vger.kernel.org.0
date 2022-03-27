Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 973054E8976
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 21:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235452AbiC0TEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 15:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiC0TEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 15:04:15 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACC7140D4;
        Sun, 27 Mar 2022 12:02:36 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id j15so24518185eje.9;
        Sun, 27 Mar 2022 12:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kA48y2HXjqj25T0IDSVplJZk1xExHaagDZIM0X0POGU=;
        b=HQyBU3Y4eyFwnc9ahSty/SHtBQR0l4T5z30Iaw7sPwZxEiZHLFgqcMq8XSlzluMC4X
         QERKdGVSzhiUT5bLJfYTPccVEcvEfIJ14S6dfyLx+jmSx9pZVqRzXHDptnWhrmFSxvv6
         gld1gXtkn2cemadcSG5soGuoeEwhBe4rfzxb0f/c74TC/E4GECEoCtx4xIwyruYPXR6n
         8LyfvvGnRUsblW947aLpdmJYI+v+XbfVn7fv3sG6dZQuteMCKgZbAMD5hOAmHdY9YA5P
         2n02PSgxeOYrQPE3BJ8W7GckrNFw5leo6fdXaK+4hFUHG2NJLaInXOAWcnRLnigqTFLM
         bHIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kA48y2HXjqj25T0IDSVplJZk1xExHaagDZIM0X0POGU=;
        b=jmzUL3tUNCsRYAW0KkrZzw6kofXaAxNUzam/nf6jDhmW+eVA1TPdiyEG8wtxv2ridA
         IB4h2er2Gl/11pRENshhImAt/iU4HQrCo+wG1IIayuokp/Q2/jr1zKw3i/5BQk7VXFo5
         j7LIHXGPTXiE5NTJrN3ZH35ZK5/9wDX+PpCAwNlUEpcAwtSp3erMfzM3qiL+VBkStsYj
         Tv2Q1tZXY3HvtVaDaYltEfQpo7aTs9oypqHtXGDc/z1nMKjDRD0Zq1bYorUoat3rMIkQ
         BWNZxZ2BTV6NCkI9onrs1uV5Oz4EfhgkZ6n076swxLn7zqDcixwoKKbzKHfCyiHtXtPC
         vA1Q==
X-Gm-Message-State: AOAM533ATHi0YPlX7k+d5XL/kLqw4fBdyp7kfZhiZ2e9s8axJwmJQufx
        Ouobrf5F/EVRI76armGqUu2FLhGuq0yz1nVpYUw=
X-Google-Smtp-Source: ABdhPJzirTH9/1YtP5SVBpqCJMYl08ZB1cYfp6bCIVm3LSwRTQTubHsEoYrEOBozFmqsYMN3k5ScunZdiJ7ltGlpZBc=
X-Received: by 2002:a17:907:968e:b0:6db:aed5:43c8 with SMTP id
 hd14-20020a170907968e00b006dbaed543c8mr23318941ejc.636.1648407754845; Sun, 27
 Mar 2022 12:02:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220325220827.3719273-1-gwendal@chromium.org> <20220325220827.3719273-2-gwendal@chromium.org>
In-Reply-To: <20220325220827.3719273-2-gwendal@chromium.org>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Sun, 27 Mar 2022 22:01:58 +0300
Message-ID: <CAHp75VfYmXoWtG-Reu+Yqt4bOY4rCvFiMVdU_em5Akm3WGw+KQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/8] iio: sx9324: Fix default precharge internal
 resistance register
To:     Gwendal Grignou <gwendal@chromium.org>
Cc:     Jonathan Cameron <jic23@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Stephen Boyd <swboyd@chromium.org>,
        linux-iio <linux-iio@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 26, 2022 at 12:34 AM Gwendal Grignou <gwendal@chromium.org> wrote:
>
> Fix the default value for the register that set the resistance:
> it has to be 0x10.

Has to be according to what? Datasheet? Reverse engineering?

...

> +#define SX9324_REG_AFE_CTRL8_RSVD      0x10

Seems like a BIT() mask here. Also I don't think it's a good idea to
put RSVD. Does it mean "reserved"? Is it really how it's written in
the datasheet?

-- 
With Best Regards,
Andy Shevchenko
