Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C37D43865C
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 04:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhJXChe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Oct 2021 22:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbhJXChe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Oct 2021 22:37:34 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A49C061764
        for <stable@vger.kernel.org>; Sat, 23 Oct 2021 19:35:13 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id ec8so7464992edb.6
        for <stable@vger.kernel.org>; Sat, 23 Oct 2021 19:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=edKpwoRN8Hv/cXIlxyftKTSXyuYnNxa371gif/W+RLM=;
        b=O/1N85sKgzDx0nQyxN3DY0Hc52cwWXTreBthF/7S5+tvdrsKCZTHz7//BuSceD3IQ4
         LN1Auke3eJX31YK6DbuzOOCH9SUdHDU2Fd3d/L4O/tvH4vjknzP++IXXQKZKluDAQ+pi
         T84ZKb4EDWOcX8RlwpmtEgLjRahJku3DD9LdxLuGAMFteWuP9rYSrWXCOQFHaMYYkROJ
         JM5PiuF8jmbB2BxKWnFbRrmVJM8iMbiggQ0yo4xY1ncCzWSQ0e9Nn6ILcXy0Zah63OA2
         Hn4SqrNbs/JElGA005S76kt9BTZ/FlNht9x358Lxr5dzCQkzP0JB8S4u5kclAS7r6yvI
         kNsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=edKpwoRN8Hv/cXIlxyftKTSXyuYnNxa371gif/W+RLM=;
        b=yL9iVvp/qgY0NCfA4p+C1VeD6iI4TKsJGI6PTF9YW3abX0lk/KSKn2LW1DkMJ1deKY
         4gpO0AW7OhXeU5e9yUdmVwuY+2DYOpY873ZfN4q+1zD1+t5AxTKjfZ7cd9Q8KN2IATsM
         CgJbFuYBn734/ZCVtdMRuA/PI32zhusaSqwSg/gvdGXVXW4QiW6xNhXNkMDQzEGKlHbR
         JgtuG0scbP66S/4WWxHWmP8lPPxQ/ULMoZIwdAao2VJ6DqVbLJpyKjPHzfKcnNzR8M0e
         6N0Q8pCVmMKqjFnBXhha6jTh3HKb2gljpzvBsrjCSihWTM1w0QKhKxMbvAtWy3lNYr4/
         M9Zg==
X-Gm-Message-State: AOAM531PAvrXee4Ck8wlkwy0KA2Fo9NMcpsY0gwemJcsySTyVFis11IK
        xRvBZSopTBW10LEJkCGaEVRDZvOIWMvgiHUl/QVFUw==
X-Google-Smtp-Source: ABdhPJxzqHaAGo0dX869Vvjl97IFV6MXmhNE0qVtiw+aV7FdLcz7mfeAzo6lNi10pUxA0nyue0iP1epJKQMEJ7CwFgM=
X-Received: by 2002:a17:906:c7c1:: with SMTP id dc1mr11789939ejb.6.1635042912321;
 Sat, 23 Oct 2021 19:35:12 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Sun, 24 Oct 2021 08:05:01 +0530
Message-ID: <CA+G9fYuhRwQhByNkWQ4OLP7y5vBTGoWdW4KrJSzJizVsDzWQSA@mail.gmail.com>
Subject: i386: tinyconfig: perf_event.h:838:21: error: invalid output size for
 constraint '=q'
To:     clang-built-linux <clang-built-linux@googlegroups.com>,
        linux-stable <stable@vger.kernel.org>, llvm@lists.linux.dev
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Following i386 tinyconfig  clang-13 and clang-nightly failed on
stable-rc queue/5.4.

Fail (119 errors) with status message
'failure while building tuxmake target(s): default': ea3681525113
 ("net: enetc: fix ethtool counter name for PM0_TERR")
 i386 (tinyconfig) with clang-nightly
@ https://builds.tuxbuild.com/1zvtvNS4eyYkOMiXtFgR7n1k0Yc/


make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=i386
CROSS_COMPILE=i686-linux-gnu- HOSTCC=clang CC=clang
In file included from /builds/linux/arch/x86/events/amd/core.c:12:
/builds/linux/arch/x86/events/amd/../perf_event.h:838:21: error:
invalid output size for constraint '=q'
        u64 disable_mask = __this_cpu_read(cpu_hw_events.perf_ctr_virt_mask);

build link,
https://builds.tuxbuild.com/1zvtvNS4eyYkOMiXtFgR7n1k0Yc/

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


--
Linaro LKFT
https://lkft.linaro.org                           ^
