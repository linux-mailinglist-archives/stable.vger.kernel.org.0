Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 044EA62364C
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 23:07:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbiKIWHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 17:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiKIWHH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 17:07:07 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEF5303E8;
        Wed,  9 Nov 2022 14:07:06 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id v3so17385320pgh.4;
        Wed, 09 Nov 2022 14:07:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iw5S3C75tN/oGViY8ItNjGlumx4biWxjIIT5f99rcI8=;
        b=kRKJwoIzfYQ/DWIm8KSUaZ4Ro0bDtgjRpwb7yY0HH+jZHaujlpp0j43JGV1jtKLbXf
         YWQe6oMBenkCa4M1iJtKSv0M5JtJvkWWYtp6RPjnRwmPCBHhoQo6dNmgO8xJPnSlA429
         J2dp+3cMGwOqunwxv+fMFpFbOPTeZboGdvylHh/oMSVEC5IlhNSdrpNwA6EVkOt4hRMd
         8kaUw7q36y0iZc4k17BeX5lASGLa4Gx7TLwra+8d6HgQnuZlL8tp9+rsf77WGLH9jXht
         M5fTLPm5tkibU8REXZZfJxFOGHBWXvZE7jKkSRjwOE1QdLJ6y23ggQbuHWQeOch5XcGc
         XlhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iw5S3C75tN/oGViY8ItNjGlumx4biWxjIIT5f99rcI8=;
        b=zMOCzszx3qtmw1aw/dLZLJZpuWeJ6GCK8KSNFsmi+zJVGZYTbPzvsmBIpT8TWxBdKG
         IqwPyHSCJN8i7edkN2G1uQqi6JNgJaArNIgSTwtvz+E1BBRgJVFw2LB+jGTR6/32i7mJ
         ZuB1lRA803h/AkwPwf1kcV+6JflJFWXR8rjKhmJA3bV3U8FM/X+5rXzJNaDKco7OSjME
         Spmmq9oCn91CGP8jscBxHF6RNsuue4scbl/HxAY4yq+RyXqEi131gwTskLDK9RzCT5Se
         rqCtNGhWBTctSBQ8mRvYJN/SXi/pLdkbL4iEiGO6pAI4tfyUNupKXlkiDnYmxMBUL1Du
         XV7w==
X-Gm-Message-State: ACrzQf3E/3LacmS1/D+gFBeFzFzC9PFFEB4/Z736uhhEB/lgw3icS/UQ
        p+3dHY8I7fP+XoXUM5SessS2cp9xts4U00GGrUg=
X-Google-Smtp-Source: AMsMyM7Q+Id4Z7/MMoExlaIfDv+7Yd88p8dRT/wqu4p3TYsopLqogJ8/a9QHDZpDUfikABiFJVuq4sT58bxn9452QOg=
X-Received: by 2002:a63:ea4c:0:b0:46b:2772:40a4 with SMTP id
 l12-20020a63ea4c000000b0046b277240a4mr52259052pgk.342.1668031625779; Wed, 09
 Nov 2022 14:07:05 -0800 (PST)
MIME-Version: 1.0
References: <20221109082223.141145957@linuxfoundation.org>
In-Reply-To: <20221109082223.141145957@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Wed, 9 Nov 2022 14:06:54 -0800
Message-ID: <CAJq+SaCw85ENMx+QNimuckk46eU9bwf66QmuK_x6GnWMGRA5-A@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/117] 5.10.154-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
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

> This is the start of the stable review cycle for the 5.10.154 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Nov 2022 08:21:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.154-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
