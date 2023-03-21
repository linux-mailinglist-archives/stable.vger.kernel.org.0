Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 088A06C280A
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 03:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjCUCWD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 22:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjCUCWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 22:22:02 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFDE038EAF;
        Mon, 20 Mar 2023 19:21:58 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id p3-20020a17090a74c300b0023f69bc7a68so9960663pjl.4;
        Mon, 20 Mar 2023 19:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679365318;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wk7k/qCAEMpFxh6ljdNclCqPNBMbolmdQlBNy8zLG6c=;
        b=b1MSLsahswHQ/R2ruWXyq261SamPgeFglyhnW66D2sIrLNRx0SFsX2VXITmRYCB6CK
         fehaT1Sk5io6kbOcCAYGe2hREFU03baYDHSh2xbF20lhO36WlTb+uSykO6VpHg2RvkVn
         wXpDivVKoVSLiYqu/w1mYxJAluWFnzUd9Nwxd2AXQJjpxxurB3/X+fMG/8ciSgOMcLHb
         8eIR51rNeI+e+iOW9ez/PS7iLRc6f9SGJRd31JzU8Jb5oOT/CYKm82d5R1qClNgfAD43
         8uOf8uMEoHFSTCKKBNRPCIMDKMRnHKxSfc5CE5yqB4tT1QPeq4swNoMiFJ1bilaFgTjd
         dg5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679365318;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wk7k/qCAEMpFxh6ljdNclCqPNBMbolmdQlBNy8zLG6c=;
        b=EHDyP2PrRMbRVMg8wpcIae9VTvk9PYRuCwl5zdOgPrGcAtJV17fkMzFl4O0BlqdxUO
         la9vnUrfPphE4oq259e9LzI38omBL7Cy70BJYLl7ADRpfzFl9sa4EtayWLUzfOw+hEFg
         v3W2DkoQDvdtJLufY5giZO8ZaJ36u2so40sI1OOfAO18thhPhAajTzYsJCwKhAUlDKRv
         Czb2bm26v/Z44a+tLdAiIuev1SwAkXIaGILC9j/uU+ua5LqcZ+yaKnFm+sebiFbwZHwN
         hql2tU/3QmVN5wWb99juJ6gEt7XRClgJgEecXo7i3cQVvyAYtcMnDKPWy6MHb+jERJ4M
         aoAg==
X-Gm-Message-State: AO0yUKXOdQem0fdv8lrc1m6EVfuXrwFVotv3Mk1Sr8jUyiQPazQj5FKq
        K4JaGN3Hgl5yWN/bNhWl8OdaJhGuXOyueUJJwDg=
X-Google-Smtp-Source: AK7set/6yamH3SwJz12TWGOrpA7X6sERswa68dKqJacheL9RN5DQS5iOTenIxqkTYSJIWjI0P/gz4qQ3xJOrBW1iYHU=
X-Received: by 2002:a17:90a:29c5:b0:23d:2f4:af49 with SMTP id
 h63-20020a17090a29c500b0023d02f4af49mr200529pjd.4.1679365318063; Mon, 20 Mar
 2023 19:21:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230320145449.336983711@linuxfoundation.org>
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Mon, 20 Mar 2023 19:21:46 -0700
Message-ID: <CAJq+SaDtjHaEHH0Yo38ygEmXfnTTDEtuVd0bLF49E2W2UGc6oQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/115] 5.15.104-rc1 review
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

> This is the start of the stable review cycle for the 5.15.104 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Mar 2023 14:54:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.104-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
