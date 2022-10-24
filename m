Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9205660BBAC
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 23:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiJXVK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 17:10:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbiJXVI4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 17:08:56 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DE2CAE41;
        Mon, 24 Oct 2022 12:15:42 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 3-20020a17090a0f8300b00212d5cd4e5eso8235289pjz.4;
        Mon, 24 Oct 2022 12:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6IMt7lvkWIN9TFVT/BPBQmQYfoSBTvupGRENdoEjmIk=;
        b=hx6wdQAu6pngKe6bCfxOeCp4ZOvzFBiRrbGC0DGyPctfZpWSUWoijWzN/+qN7POMbg
         MECcuym0C0wlHarzN18HZs/HtknXh0pTBxj2Kn8Mki/n7XTW6o3GHM9iUbfjfcoawnzw
         gsa6JwpPhG0CpDBOGEzM1cDwuhWFYtr5OCKYrw/nWrfNynzieRaKZgsz/tclW2Pj5Nl9
         PpaWXD5tTI8bBWwZdkW4Gj0F/r5hlbWaeYkWLBRhRmB6+848VhHeVA+I+dTXcbz0oUUq
         OUW4DgAkwec4gUYUNulTX1NunkV5ebq1ipKu5Vum9wmjOdDTs1dbf7WCZanpZPuzvaM/
         NWwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6IMt7lvkWIN9TFVT/BPBQmQYfoSBTvupGRENdoEjmIk=;
        b=PIublyvA9drp3AyLxsdbF706rUo1ZISlMhQV27Oj6djPuug8tL4tcfzbJjsCiyKIV2
         WyJDhLR7smYRJdKMIlbEVuqM1LGYCsBsAtF+BcyJuT36232R0LndtHR8Qkq5b8oxgimf
         +ZWM9ykyHUfMPJyeik3fOJPt3WYIn1+OG4Mkqrctmjhn0JTY0wmMBESo5eL+4/HshG/e
         VophPfv8N2tHywQPdkHbR3COClHGAaL96E0vSYK/MucEl8zC1LKPgc+pUcXw85+zo47S
         ypO7Okju+lYFuqAw9fATZPXP6tsSvMl+2U6/gQdtsZ2Av/tnVj0P3sQ3YoPxq4N+cqP/
         VC6A==
X-Gm-Message-State: ACrzQf16j7S+vR5iXuTmQHlyCWZfehCSoHfezRwlnUq5mdx8Uj0lpUau
        /qyQA/sGXrRifFRWEmXE98+ogzMXItss058ZLSo=
X-Google-Smtp-Source: AMsMyM4Xdmx4tvX5JfJX4BsQa5vH65PzcWVgRfjDZ2vA6oYPubyoiCfSSU0d8jzufxK4D3ultVDxWhQ90JJnh2XQvCE=
X-Received: by 2002:a17:90b:1a85:b0:20d:c705:92b9 with SMTP id
 ng5-20020a17090b1a8500b0020dc70592b9mr57641537pjb.213.1666638879368; Mon, 24
 Oct 2022 12:14:39 -0700 (PDT)
MIME-Version: 1.0
References: <20221024113044.976326639@linuxfoundation.org>
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Mon, 24 Oct 2022 12:14:28 -0700
Message-ID: <CAJq+SaAxYEdkuRTyHr6bxnYmYO+mrd=WqsVZ1M_Z_1-+4zjYwg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/530] 5.15.75-rc1 review
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

>
> This is the start of the stable review cycle for the 5.15.75 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.75-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>


compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
