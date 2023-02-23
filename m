Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 533B26A0150
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 03:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbjBWCzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 21:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233470AbjBWCzU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 21:55:20 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0697434C34
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 18:55:18 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id q11so11576911plx.5
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 18:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XQPHO+gl/DhYC4r22uP7h9xL0tCG9iAevyTPVtriPQo=;
        b=Ffzo03v+l25EXyWJifw244XNhDz8wJghOb7k4p1ylBpVzAQQ1mUmUN4ZX7d9fSyhjZ
         N1wUjMyk73kCrZtbKAuYc0AbzVdWH0+DQdTnLSKNaOFffc8tG6sR1p02579PPIbzSPxN
         MvU7odQaG0VUedi0VCGmQwSJ+J30gQZvnM8KB2qc0K4mdl6U48lLX9LbVz3qW23wGVfv
         RPzc9+ITya5C4t1bJFimdoWHUmieuiVHEBFpHlZ3AHF8BdvHD0/C6MCkulAKgCR9nrae
         LjIlK4JS24XDnSWjzllL2ZNxAITY0l8EkZgPbxk9tO0ohsGK4TRd+DNU7HVWDLWUsVTl
         /WOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XQPHO+gl/DhYC4r22uP7h9xL0tCG9iAevyTPVtriPQo=;
        b=EeELLyVPinIRaWcrHZibMNGiWCpUbRyrg23+BloD0uf+c4UgBDbJo0K/tHgpy1qHFH
         uoaO48HX+fvDG6cuHl19y7C28jdRbicp/X9/pzy9UI98MwhSxrJsrLfGxR1krPT9qfZe
         iHCxZX6JzGpKkBnikLjCg5NfOgDP4MvWiYLzYjPgZVlULMMVxeTBGuDM2ia3AppeXP8B
         S87L92Crxgsc6RrScRanU3lWrxPfEg6zoq1OYMdvjQI0C0Lm+KdwMJcVzgD1pehzAi87
         RchXaKoOyhFsaU12hkuYjBNIbh1fYJuESMRswe2ztYEpe4r+jftYJsVuWUaVqWZiuemV
         i53g==
X-Gm-Message-State: AO0yUKWshaGt2p9668lHCKeovZXTN0w/+udRVH1cbFtraEHt4/ANjfyj
        yqCLjzwf+lYhBrmY8omXjs7WZiUjLtRCKTrlIRGRmg==
X-Google-Smtp-Source: AK7set+sXcdhmJLQhp1HnsxoaWEiNvC2w5ODsm67G7ZcQMIsy1veA0VxS0igMXfb2hiUE1B6yJbPUxrsOn16CMsbPJI=
X-Received: by 2002:a17:90a:df12:b0:234:889e:d88d with SMTP id
 gp18-20020a17090adf1200b00234889ed88dmr130880pjb.5.1677120918304; Wed, 22 Feb
 2023 18:55:18 -0800 (PST)
MIME-Version: 1.0
References: <20230220133548.158615609@linuxfoundation.org>
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Wed, 22 Feb 2023 21:55:08 -0500
Message-ID: <CA+pv=HP1Jv8m_eSv=h6fKFE-ynkgHCdWNB1dnmFZUqsrcGN5cg@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/53] 4.14.306-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, rwarsow@gmx.de
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

On Mon, Feb 20, 2023 at 8:38 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.306 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
>

4.14.306-rc1 compiled and booted on my x86_64 test system. No errors
or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-- Slade
