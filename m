Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F225F39CA
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 01:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiJCXZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 19:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJCXZI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 19:25:08 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9EC178AF;
        Mon,  3 Oct 2022 16:25:06 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso133435pjq.1;
        Mon, 03 Oct 2022 16:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=mZr7iKmHTafhYw/ZwGCayhVMHO2w4Xr+aXR34ga9mRA=;
        b=THzFZQETy6yzicdPS70LvBOmSjIxO9+hdeRWqioGelaohFCAwzJXFZyzPCY0UqlXog
         xEeF7NkhE40Lo869s5SSvhrI7hbdEymM0H97GpPaBJRs42GAQx6FBKv+u3DlUL7j+hfa
         xvUtFvfhmXwVhfVJ59G03w7viRAKSy0shsSdPkKukF9wjRUHmcX3tMXsetn1WQVMeJQv
         R5PqtL4xioYLM1edrgEik727XHDOv7g2tzFKna0SBYXEAXusZvxk/vJ8f6yUIe5erPlq
         tmmJ5n1/GkUyLzIZ/BaMPlO4WOX9ZWDTRMijN9NHP21cdQs+jFY58WhLEzdqo9KSldm9
         99AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=mZr7iKmHTafhYw/ZwGCayhVMHO2w4Xr+aXR34ga9mRA=;
        b=1OkauKBhm4VqMklYJb2r+Kv39MBm2nMmy3WNnNVwMj3mtnyoHXEHgDtqabShb1ga+d
         Ox9EblctRv6lepR7ITpX/5XAR5jlUZ6oWJ8rJcz6PQqWwWco8OGKd5ccXOuouQIXUOFN
         RV+EH94v3gjAH2xBisI07icDIxFPtcKmjlcCb9YulEQ/hY1vJ4a+XKYGE0oV5CZmtK+w
         cf6GxRap+Yz9Vx71x8fZ8P9LJAiFHna9lB0wJt0FST2cPTjSd6P9NLXv4nXW1m2XNr3K
         gehfjafRrMYVN6YI6pCKhVuWh6ZWSgVYKZiSCcdD6AIlP7y8vpKY3Ta703GCKJOct/1l
         DETA==
X-Gm-Message-State: ACrzQf1+/T4tCiOC3ZkM46jRMgOcOZQAQt25u2QD5TNFOEQivC+irKhq
        pmlnZanLYCp+9H7bi8a3ADZGlWQaIXG+TDSJN+4=
X-Google-Smtp-Source: AMsMyM7qWF+Xc97JVqgvrgazxbD+OOMZzU8gg++rKutPxNQzJcP5L0y9aTQUY4Kcojj81GYp8kv7YQwFRtuqGNbJkAA=
X-Received: by 2002:a17:90a:a503:b0:20a:d877:638 with SMTP id
 a3-20020a17090aa50300b0020ad8770638mr205741pjq.176.1664839468288; Mon, 03 Oct
 2022 16:24:28 -0700 (PDT)
MIME-Version: 1.0
References: <20221003070724.490989164@linuxfoundation.org>
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Mon, 3 Oct 2022 17:24:16 -0600
Message-ID: <CAFU3qobWX7=TPHXkEG6Mxh2nCHA1RAV29GG=xycfnoVtPNwqDw@mail.gmail.com>
Subject: Re: [PATCH 5.19 000/101] 5.19.13-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 3, 2022 at 8:56 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.19.13 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.13-rc1.gz
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

     Total time: 0.740 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 9.647 [sec]

       9.647452 usecs/op
         103654 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
