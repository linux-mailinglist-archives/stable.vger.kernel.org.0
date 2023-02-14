Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B3A696C13
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 18:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbjBNRyc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 12:54:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbjBNRyb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 12:54:31 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AB92D163
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 09:54:30 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id lf10so10204340ejc.5
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 09:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gqG/enM8HfFTvnPDTpPzWk+Glm0amvtJkxf2NVo378E=;
        b=F+u65dsx99puM87w0HTzdq91Z0GfWip8hAbSdGjMMAN4XnQWUxvrD78auJ/6uRGwB2
         n3MHj6R+v/jFIpV6WZGax/PLLHuAW73dsd51EGdX4rRw1ddLtG1dK9u5CFfbwyz1CWP3
         bMtMSrbwjB44kodOjX9RvlF5yKfhU3XqIfoI4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gqG/enM8HfFTvnPDTpPzWk+Glm0amvtJkxf2NVo378E=;
        b=HOCZBAwBoeLqRMXBKIM43Y7UmovN4Rdhdb5qdXOy8e7mUzuaZmwhWa65gQdlHRJXLH
         BFdux2HYvGwyJ5f4BsR0mRBEHLa1SzvkGS6L+XTzR9eanlLpQstzowt5EYtmzzefOx30
         r8vv2vDi1lM3vKJ2yw55E+aMb3Y0bNrFcAOFsw2DOVQP5j/PBpvjerA/q/T++44tD4S1
         QgsrX5Je1wB2khONfSE6ajYKxxxGtE57coLrSz4V30vlSRmqZ0wMsgJw6Zf5SBtYjMHm
         ZfPXqnbPPP6S4aiVCVjusJOZCopUgj0gAxdV8ubGLAEaXA+WBCib3nORzZg+NCbIz8ev
         Ngqg==
X-Gm-Message-State: AO0yUKXpvIi/ENFIALeV9WWh9EKLDPARKrqLnN2m73BxRshjATzm8OQB
        7ns2JoLQUAeahUWLUkOnvT92OnZZZBYu2Ub65jU=
X-Google-Smtp-Source: AK7set/wvTxjmURTTOy01QR8OPOUiLtn4AUYBpIKD9xdKNOVk60MiiLIMGkI1BiEKTUDa+Sv5LhWVQ==
X-Received: by 2002:a17:907:1c8d:b0:888:b471:8e46 with SMTP id nb13-20020a1709071c8d00b00888b4718e46mr4814068ejc.50.1676397268946;
        Tue, 14 Feb 2023 09:54:28 -0800 (PST)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com. [209.85.218.41])
        by smtp.gmail.com with ESMTPSA id b9-20020a170906194900b0088478517830sm8511640eje.83.2023.02.14.09.54.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 09:54:28 -0800 (PST)
Received: by mail-ej1-f41.google.com with SMTP id lf10so10204182ejc.5
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 09:54:28 -0800 (PST)
X-Received: by 2002:a17:906:8585:b0:8af:2ad9:9a1d with SMTP id
 v5-20020a170906858500b008af2ad99a1dmr1732354ejx.0.1676397267927; Tue, 14 Feb
 2023 09:54:27 -0800 (PST)
MIME-Version: 1.0
References: <20230213144745.696901179@linuxfoundation.org> <05984672-d897-6050-3e8b-3e7984c81bd9@roeck-us.net>
 <1cd10087-87fe-048e-c9ed-0a5d32c50764@roeck-us.net>
In-Reply-To: <1cd10087-87fe-048e-c9ed-0a5d32c50764@roeck-us.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 14 Feb 2023 09:54:11 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgnKpVzL14X0+cLQcWuQmjPAvgrDGF69JRMjgc4rA0VfQ@mail.gmail.com>
Message-ID: <CAHk-=wgnKpVzL14X0+cLQcWuQmjPAvgrDGF69JRMjgc4rA0VfQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/139] 5.10.168-rc1 review
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 14, 2023 at 9:51 AM Guenter Roeck <linux@roeck-us.net> wrote:
>
> Reverting the nvmem patches fixed this problem.

But upstream is fine?

                 Linus
