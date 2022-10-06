Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBF295F6E87
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 22:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbiJFUBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Oct 2022 16:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiJFUBR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Oct 2022 16:01:17 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF093AE229;
        Thu,  6 Oct 2022 13:01:15 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 204so3014738pfx.10;
        Thu, 06 Oct 2022 13:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=QID4mZ6+Ln4Dy9tQ5FS+Lme8sqZOwvScyJQa62DK9Qg=;
        b=GlxyKn5KHcw9Jfdpa1JYWX8RZidLlXbH6fpRWyw8NNYUhCD0PzG7CDqZ0VhET3yDKl
         PxVk3A8JNfdl5MISuhLfRNRkAhheQuJaVUgNfCdyNzSYF67dKfdwZdqs7whZBKU5M7E4
         kFAfMTa8dHsDkIVX0/n2xb8LTZK91BYnxlAF1NLsHj/1f6SF/WrPLLUFfDbYN7gsGx8j
         lFCQg9IrGks3d0EwFVYBU4+XI+YRJHM3vQm+eHHR2+CsvdD4MjlFXuwLTiNTHwKsXQM/
         6q24uFxdsH8AP11ZxN58NoJ9/cTCnaSjayuxFBPfcjgK2GoBusDA85Jcz71YKfAYJqip
         nXaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=QID4mZ6+Ln4Dy9tQ5FS+Lme8sqZOwvScyJQa62DK9Qg=;
        b=Fpcv71bzIOeZw6AYLwSMSBVLxK6ZU1tLesrwAnHzQv4c8TePbDSOG7oT8CQcB+FKXa
         lwL+18fv3L7ZEgpK5cSOpw2NZPwSjVN9JnTZGDH9TSSzBXft69LIhfkamowrDJgtAtEv
         I2f/4uz4yZWJyd56PCN4NNsoKkQ5IZW5oDpjsutJ0vckMahAR+WCgQVIY+2Dih7XGrSD
         pOT21ei1ZRf4venQlyaWMJdxIzjJgTHqFK3pX8d4MjAl6jqo2cWAriCaH1rjbG7+C0Uz
         80OCbRrQ8EjG8pzkvMryoOw66px5OTEoDw5hpwZiqiGlm0w2/TDgknbP8AKH9zMFf1pt
         wOjw==
X-Gm-Message-State: ACrzQf3ggbkOHT+TQQZtTasJ9t5neOTjxOqa2YDj0mRcMIJgygZkQZPJ
        I0TNCmQMLkkKpe+HiAjqzAIzP4fseYtaX255EVE=
X-Google-Smtp-Source: AMsMyM7eoytn3Ir5HNBSL96ewlJpbViQJ1cOjUJ4f0xnE25K5dKlnaFzSg7ZbuKK+/WGrK0f4mgsaHMDkIE4jDyJdoU=
X-Received: by 2002:a63:d4f:0:b0:457:2427:eac with SMTP id 15-20020a630d4f000000b0045724270eacmr1294278pgn.251.1665086475275;
 Thu, 06 Oct 2022 13:01:15 -0700 (PDT)
MIME-Version: 1.0
References: <20221005113210.255710920@linuxfoundation.org>
In-Reply-To: <20221005113210.255710920@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Thu, 6 Oct 2022 13:01:04 -0700
Message-ID: <CAJq+SaBC_JANh4zKHdLNhfc+iL2_3ogm+UHxbhLSC3SR+vvkJw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/51] 5.4.217-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
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

> This is the start of the stable review cycle for the 5.4.217 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Oct 2022 11:31:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.217-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

compiled and booted with no errors or regressions on
x86_64 & ARM64 test systems.

Tested-by: Allen Pais <apais@linux.microsoft.com>
