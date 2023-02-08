Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEFE68E51D
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 01:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjBHAoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 19:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjBHAoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 19:44:19 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6878A3D901;
        Tue,  7 Feb 2023 16:44:18 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id v23so17547319plo.1;
        Tue, 07 Feb 2023 16:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UgtuVeH3SQrUqkXUTAMLpB03R+YUjFpbnh0x6QNQIww=;
        b=YecaEnu4PJEuRg3f48t57xWKTGgZJxOd7kXDGPQtQaAiP1KUBIPIgQTEYEgGxzLysh
         ZIUfSCbWOYSE1nimvNgQ5PtZBnWJsz5UOwH2V0+REOEPcKrns/r1ngDWdwbQExEzq2S4
         Gputbv6CohN8TWR/XM06Kis3RDGhq9X46kaXGwkZe0pPrxscEXEG5wVvnLgHEVRuRBUS
         6InZ/4lWTT8sYBJGA9Cj3WczS9BIfs9rGfHj4btE40NWCgtUQsgvrlLQBesFupC0izyb
         Opcabc+22PncmaiU5JjmZ2CgGJ+n4svsYei/x5QNqAwHn1Pfjq5F9xmUatKHZwOqzln5
         PEhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UgtuVeH3SQrUqkXUTAMLpB03R+YUjFpbnh0x6QNQIww=;
        b=rquYXHi5qFkHX+yqtV8n5KvTtgthxp/70MOFkskdnBZYJgsqaAZsExwtyTphYRaqY8
         SfJKyvHIOjo7KrK78WJR04zgLc0u2pK3Ir4hXok64nZX2o/xU9UkPaPaplLGSJMfvcN+
         rP3EYhyjsVqdZ/U783snj2OSZPJ/3AKyflMuvMZ5tf1iDv4v/a4zZCgjgvSFG0O+iExM
         IMNaNRyauqBHqoTaFswG1NZP9YSzzPmU2jyZJJnKnNb8tXZS6IhTtnOfqeC+MCzNmx+k
         SCdjfcPCw3HqVQDrdy1XPdzxhjr/x88ajbE97q3tqicdSLltp+6RlUziGzZMvM/9A2a0
         KuXQ==
X-Gm-Message-State: AO0yUKWzQ6BNRwAiY9kv1HIibJyBMTEm8WDvjmu1mSf2N5DCrZoWBPB3
        MdUWl4G3Xy/caopy2398hvc7cTm87+jWeADt3Rg=
X-Google-Smtp-Source: AK7set/X9pmwhtLDus/6ojj+JFftt4o1+koEhwtLlgqj+PGzSIcLJnd6LyATGopfv80ukhar9wMOXKJYHEIEGH/CXXw=
X-Received: by 2002:a17:902:c40f:b0:199:ad4:6e63 with SMTP id
 k15-20020a170902c40f00b001990ad46e63mr1262887plk.0.1675817057927; Tue, 07 Feb
 2023 16:44:17 -0800 (PST)
MIME-Version: 1.0
References: <20230207125618.699726054@linuxfoundation.org>
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 7 Feb 2023 16:44:07 -0800
Message-ID: <CAJq+SaDLnbV0MCa8ioHBntSVexLik8DAVbEFYs0383DuscdqbQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/120] 5.15.93-rc1 review
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

> This is the start of the stable review cycle for the 5.15.93 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.93-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
