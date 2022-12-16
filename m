Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA5C64E947
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 11:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbiLPKVX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 05:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiLPKVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 05:21:16 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D67558D;
        Fri, 16 Dec 2022 02:21:12 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id b12so1454501pgj.6;
        Fri, 16 Dec 2022 02:21:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u5s2efA9OpsOkJAjhuuBC6txtEfx9OeQwLBhU20dKA0=;
        b=GU5K59LVv0g5znwPI2UdFduZID1wexyKsPHZIwlLgDN0Tn/2oA7P5MgUmvGXOhTXbo
         nTLRTT5X2hAZWT6+Z1xG+pz4hxAmyqkoZ+fnf8LDmuC9k/kh8g3kWHY3wPkvbt8Tj+bW
         80JZZZ13QCCcF4yocIs0I21+TW1AXTMBdmIHG4lZZxSweEhXGvJt+zY21RH5ICYl5sTs
         i51Js9RApQbG3+yNQk6JnRM4vC03L8V2wcj2HuDuf01hta+EtHLuuJV3yoCbhAslQZ17
         q3z1klErSDgupsCl1h18YSKlWNeeUM3Oze8rhT4kBGHOJgpoboizig9BWsHuy74RLxgy
         zJNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u5s2efA9OpsOkJAjhuuBC6txtEfx9OeQwLBhU20dKA0=;
        b=du4SVrCMd+YUmik+sWcmow8mI/hoos+6q7Jw1JmdxP8dy4BoBkZYzVsd0YK10MwMK3
         Om5fO37UG3HbXtsJMzvB+0iJD46UEpjscg6bBykievbhQWjQX4ZgZSFRkHKejedcCdxY
         W80IW7v6LMUOAhSTM5F8teozCXfqwj87UuAksKLuFMS4ZUuGStMHdf4FjVpzsWu3suH2
         RUH3ucF+3fBkcpPhomLGMiyCRzGJpN+uuiGjZZnaQgy6+3WyDuYpZQzWhEXxSMpuupzZ
         tWXlmlj/U/p6RAiyHP1Koa/Soo9qvbuT/rqwjABqG0RWPdWXnH8jLLDYp8Q3t3I4HUxx
         MYKg==
X-Gm-Message-State: ANoB5pkm7/16eZBBCDEcnz1IzhoHdMPWUzZvoER362ChY9mZMTVni5pL
        p/8kRWe2HI2uw2Nzi7TG1bXvYEeY8Zk2fnenflo=
X-Google-Smtp-Source: AA0mqf59EK5o43aImON/i5f3koYcOESjaO9ughNFEWatMBlE5FkNjTHOk+vd7nxHBsWzEckowBSYmunDU8QO/cUy5W8=
X-Received: by 2002:a05:6a00:1d22:b0:577:16ac:8447 with SMTP id
 a34-20020a056a001d2200b0057716ac8447mr17087539pfx.56.1671186071940; Fri, 16
 Dec 2022 02:21:11 -0800 (PST)
MIME-Version: 1.0
References: <20221215172906.638553794@linuxfoundation.org>
In-Reply-To: <20221215172906.638553794@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Fri, 16 Dec 2022 02:21:01 -0800
Message-ID: <CAJq+SaDApqmwA4p3-yA6zyiwP-LHyKySS9mpXrFnndWw2RJ=ew@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/15] 5.10.160-rc1 review
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

>
> This is the start of the stable review cycle for the 5.10.160 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.160-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
