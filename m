Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44B958E458
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 03:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiHJBJP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 21:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiHJBI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 21:08:59 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CD0804A8;
        Tue,  9 Aug 2022 18:08:55 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s206so12970113pgs.3;
        Tue, 09 Aug 2022 18:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=UpOhBIejKfcj5e+Ps9ytmdQy+VLPpHfE4fHPr6Z2n0Q=;
        b=iH/wKYJ97xqOQzT097OZqousXle776MgXBwzGnv+7CRZk5/rt3dFy/FKJmdMNf3OoH
         HphmMvF9IKCDJ8Qs4ZBZnfyFLyBw67FjskZC6dBRB/qGgwTDAXnTKFqFeXEXxZUluz1b
         Qv/Ps6nGToNsniAbq1tQ0dilX6fCscr5BYV9DZpID+ObSMZ9rbr4CD7Y3ltaDJbqzVtu
         zVOga0WS0hEAc+XjhK6zZdF3mDbqn9ZDu2XMJnFhvDdTwX+CN7CyTJKCidLQ5R9pqsNQ
         DdMaYsTodUBtkR675MMfRD1yu+sz/expR+znh8vlKL8WEsGe5eOzkcNWzEy7jkr6vlXG
         r3/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=UpOhBIejKfcj5e+Ps9ytmdQy+VLPpHfE4fHPr6Z2n0Q=;
        b=P7DBysEjHVsxLFWFcI7aycL4GFFAELbsjlbR78NQuzFnXSGqHlncV9pIQpeRSkUUrz
         03S8nSirkPaVK7qcuKGKIRtXx0fmdjkQxUFn5LOAW/WkPcmSXcTosGD/Sr1hQLaykyvI
         e32CsSnlDq0P48BUwQFTi8sEaPuDiJWKVF3xst3B1PhjxgQs/WA7x/988zNQx5OITbbs
         JYdFL1yTe4qUGCarPbKsH0LplMTBqOs+uxgoBXPNtrF6mfDf67DMK+FGILk2YVjorIOV
         erf9RoyuhcFMLcuKcZ5cN0TcLOYqjlNXIZ31dGGXGrAgRf+gop+uHpXKdykWBkpIrUzu
         bfng==
X-Gm-Message-State: ACgBeo1DqJEy6aHSSpdJ/OfO4ujmKOtp81k8dp15YS5vp72u0+eEBqqy
        kGjWgJ3lb1kPxjxO83XKiFs4fjkPYGXB8FVAwLo=
X-Google-Smtp-Source: AA6agR6FNHKbAfMPXbJXuA4T8c4LC45hJY84BOuA/qxExxvpBTDck501Q4UDBw/7F9uL+xjieKf8reGyOszvoft0KkQ=
X-Received: by 2002:a05:6a00:13a7:b0:52e:3139:f895 with SMTP id
 t39-20020a056a0013a700b0052e3139f895mr25037838pfg.43.1660093735211; Tue, 09
 Aug 2022 18:08:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220809175513.345597655@linuxfoundation.org>
In-Reply-To: <20220809175513.345597655@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Tue, 9 Aug 2022 19:08:43 -0600
Message-ID: <CAFU3qob1YMpGNeATYENBZgL28VcCUEO709sYQf2Jbx0snRN4Bw@mail.gmail.com>
Subject: Re: [PATCH 5.19 00/21] 5.19.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 9, 2022 at 12:58 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.1 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Hi Greg,

Compiled and booted on my test system Lenovo P50s: Intel Core i7
No emergency and critical messages in the dmesg

./perf bench sched all
# Running sched/messaging benchmark...
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

     Total time: 0.865 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 10.206 [sec]

      10.206371 usecs/op
          97978 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
