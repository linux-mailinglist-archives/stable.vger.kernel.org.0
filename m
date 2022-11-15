Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE0E62A104
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 19:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbiKOSER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 13:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiKOSEQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 13:04:16 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129801092;
        Tue, 15 Nov 2022 10:04:16 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id q71so13962236pgq.8;
        Tue, 15 Nov 2022 10:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7hjDlcOlpzcZMaZmjaOdAYcchAu+QZ7y27zokjeIm+0=;
        b=knwpQhq6UHHVzOyJIuuqpYIvY5vApqtFQq52fophV6Eq3mo+INTLPMOveaNIByRd32
         q5bymQftooacaVaoSl6a2FvOACQKJLNLxYKsCAJC1eciNzHDcPeZR/P+VLC+wMgZNZ3O
         X85NbcEi2KCvzupC7Q7Hh5b45UUug83ibZNsMVCj4SiFUmtcVwraV9LXpS/KpqVboSe/
         aNd1+bXjruJ5F3E7qOA+KPxWImF9/58q+TBdpwE6/2VT60TYG//t+bvvCSnh7FvttYss
         mNlfIRZPUga99B7iL8wjjPBpSJ3grqEMvLXMsidVbx4/MBCVufbypMeZqiP+fUCAaH9O
         qHCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7hjDlcOlpzcZMaZmjaOdAYcchAu+QZ7y27zokjeIm+0=;
        b=hLAzgbCPNiZ8bKoHUc5extkUKco3cDQ3V7ZiEbKycie82+Wi4ioZzDaiB3FdjqUnFW
         NWKKAIH0VdYVDg39JNkBdQ1CO8jrCA1XpgJ9PqVOm50AciqZGXJvMqsqphrLYg83dbUv
         yNzHtiP2XYdDmsBiNZF4fdivI5jerrdrS5qCnQi0fO1O4JqRMsYUU9RyQbpwHBGNg+YV
         mha3qgA1F2uqm6ZiaYt9/IkCckgiezCe+j0w2iaDdot3tSOWGouUhPdLW2IQIHTze9Zg
         uq/XusXATdTYwO4tMG2bsTwa6YINwVLQDJ6YgbkJKHdGjA80FmFUCRmrSTucRTkVarvq
         JvQw==
X-Gm-Message-State: ANoB5pkCfaqGeLmv/HPceL+gh45HwMwX17UOBeu443yebj3sr/KLd8Eq
        xgM6qE6Lgy7oWFJtV1U/IapDMFtuNjOE6r54U+4=
X-Google-Smtp-Source: AA0mqf54BVv9TveESwDR+SVTHOBdV5poFhZwiih1udbzORXO/rFlNXtnhKvgRU9LdeqkVxoWKRXgWommxnB1slCnf10=
X-Received: by 2002:a63:511b:0:b0:438:f2ce:2379 with SMTP id
 f27-20020a63511b000000b00438f2ce2379mr16579193pgb.333.1668535455571; Tue, 15
 Nov 2022 10:04:15 -0800 (PST)
MIME-Version: 1.0
References: <20221114124458.806324402@linuxfoundation.org>
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 15 Nov 2022 10:04:04 -0800
Message-ID: <CAJq+SaD+dNPqxta8fM2pxYF3pdqfUU7YpgXwbHbWOj4ApK4bDA@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/190] 6.0.9-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
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

> This is the start of the stable review cycle for the 6.0.9 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
