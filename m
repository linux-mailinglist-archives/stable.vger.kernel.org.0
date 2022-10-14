Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147365FF2FA
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 19:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiJNR3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 13:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiJNR3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 13:29:46 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B8310D5
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 10:29:38 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id i3so5500614pfk.9
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 10:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=D0te2oWDw1wzOI/Tpg4a39qhOqMmTSOu+4eexqc84Us=;
        b=RcY+BOXpgQlAp/1vCnAGZwqGTc6rvBK9SRQ7QSVPc4oR0PBKaw6ivtzR2xNPi6df/6
         CwMTZeCeKe76jl4J3G6e3xQ5TuGUKMnH5pDVob+EpSW8X1NHyP6OWl6v+3Z9XsllYld3
         u6CVceT2NaPwZz2ef8e0gThyQiiDkafB2F1OPZ/MdF6kUwLUm0cOVE+d2gSf59yJhL+i
         25A1aRtVBFjRQ3AvM8AcJLOHEuJ2LfzWstBnfnpWd7ltkCji6FLIP9q0VDczOGkYUeTR
         HRPIBx7ZxaeKWaLKT5F4qZGGF4AhPwmdnGQE6yqPeHD5jRjkab++WqKkz7FDTEQHhUTe
         4BQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D0te2oWDw1wzOI/Tpg4a39qhOqMmTSOu+4eexqc84Us=;
        b=drfYzkUFerK22/IM1I5/EpSAPgei5u/GJPsarsL8T9b1LxcydkkHmEKGV6LWfuKCZI
         qi3LfRxLJb7j5MNfZ8SqKkJHrsBcvnTGuw2hlhBXPzxu9c7XytVcmHkCJv72cKdzwowj
         7PF6U1H2RN5aWBRSuskLJTrllj3gOtfYzD34wLw0xzpsTmJ7MCIwZtfAQxVUd/i8H7dM
         gnz2xPxgwTrCkXPPcw6/OjtzImqJdOvdwsWw8JmBhYUJCu5x6HSltKXsqXLREevgD/Xk
         X1HkP63aqXYMB43nsuRqrzeKWkTxLiK3RsNGEeVUlcuD8NMmU71lgkfBaJlAxLB7y3yG
         Wdug==
X-Gm-Message-State: ACrzQf1o4P1vhkXFEyd8UAPVM/H4NLjyhXUCxu01DAltwW6CIid0q7f1
        2mnUPgw1ARKzGx5P7VzoV2wnVfLcj+Gsc7XpABt72g==
X-Google-Smtp-Source: AMsMyM7jSh3WjaSdEFoy56KJr2Ezfo5c1wOt66wughISVt6a7ISKC4K1HhNLBGR4RtLz7OWZF4UJlGjGKJMG6hSLRnc=
X-Received: by 2002:a05:6a00:8d0:b0:53b:2cbd:fab6 with SMTP id
 s16-20020a056a0008d000b0053b2cbdfab6mr6268943pfu.3.1665768578194; Fri, 14 Oct
 2022 10:29:38 -0700 (PDT)
MIME-Version: 1.0
References: <20221013175147.337501757@linuxfoundation.org>
In-Reply-To: <20221013175147.337501757@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Fri, 14 Oct 2022 13:29:26 -0400
Message-ID: <CA+pv=HMiD3-nepe6EL=Zsq8jSgHw5b1ot6Czvs960J3KfjDrbw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/54] 5.10.148-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
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

On Thu, Oct 13, 2022 at 1:55 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.148 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.

5.10.148-rc1 compiled and booted on my x86_64 test system. No errors
or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-srw
