Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95FF36661D4
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 18:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbjAKRaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 12:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbjAKR3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 12:29:41 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8077C395F3;
        Wed, 11 Jan 2023 09:28:19 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d15so17496722pls.6;
        Wed, 11 Jan 2023 09:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yrIkiViylEgVu6ZuHAgyOCheYiQrsg59YN+MI+nDprE=;
        b=c0ufZIq2sgNi3qTiU/Xmc7FOpFVXquc1lNGuLhG1Q5T8HOKoPQ22tbICHXW2MGIBQB
         1uGGRYrhwJHffT7seCIt+lRPOawH7rwRpYmuksI4NOve8pG6TGuccYvJM8U4OQIWyyyV
         GQioQmFqrlXwhNBA1IckELxRi2d0MZxBNHbD07ItF4/D920V8nlhy5VSGLcY962huHMB
         Sxe6jvArbrnNBM25wRnTaeQElrJKRdjfUZLFA0kVvn6GjBHsz0AS9zK9dylqqoFqtiJf
         M4ayUZAvqzYbCQ+dS5uvLl3/BFz0J5kVgHZcIQ2igN+RF7HxXUoLID4cJTflNo29xPM3
         DatA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yrIkiViylEgVu6ZuHAgyOCheYiQrsg59YN+MI+nDprE=;
        b=mzVQusZlrzweZdvjuAOng4uomSJBdvWvG9f6bD2Qnd7T4ZqLNLnfHj+9i6VzNjMskA
         HhhHR38+D2dKUCXKN7FrMySXC/F/NFiCgc38i1n24vU2pOdCZU+C7Wcxp7QIhV+04x8+
         WMOSJtmD7cL7kg31Y9sOGml53aZPbltpuKYIyq0s8rXslb+EKj0bmEQx33lauO9BDrcc
         95Onwjlr/tdL3aiuKG4jXKJtXMswwSxtEzrOEp89/pIZJDsc1IZp4YprvVIz3xETBggW
         RdR3e3dhjixzfimCjW6CYGpM8kwAH9z7Jt7hyXkO+WXsWScmdc07G/aMJJDyOIv0kb+1
         AQ9Q==
X-Gm-Message-State: AFqh2koGGOSTfzt8h3HzZjCnvW2i7ACRqDc1S3AjFDEL/QQhZ6n/PG/i
        vP8XpTmHzUyxgdSW8ynwO3OoxoQTo2cmgUoIS6s=
X-Google-Smtp-Source: AMrXdXuecLOQ3peFwfbkliYpXmwQqXfiKu4JVnPUtGOEQ8OaH8Vw9YJ0/wHazgyiQahR7HS/wLEAMDErgVMcjh9ecHo=
X-Received: by 2002:a17:90b:4fc9:b0:226:85d6:e6fc with SMTP id
 qa9-20020a17090b4fc900b0022685d6e6fcmr2997258pjb.12.1673458099034; Wed, 11
 Jan 2023 09:28:19 -0800 (PST)
MIME-Version: 1.0
References: <20230110180018.288460217@linuxfoundation.org>
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Wed, 11 Jan 2023 09:28:08 -0800
Message-ID: <CAJq+SaB6HWg7PJpMn6+k_mrumTOh8CK3qFKxmcE=csTZrn+29A@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
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

> This is the start of the stable review cycle for the 6.1.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
