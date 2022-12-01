Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C762663E7B9
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 03:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiLACUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 21:20:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiLACUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 21:20:09 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5D99D83E;
        Wed, 30 Nov 2022 18:20:04 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id t17so530501pjo.3;
        Wed, 30 Nov 2022 18:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6y9AUyAqq0punB0p25H3aQ8RSZH3MKAHnozHOyjdT/o=;
        b=GkZbysRbQz2Phy3zO7CnVjp8oZ3E1AIXTQMfBWKR51wcKg9K6ymnCmz0eBo5jCz4oD
         Zm1cqfAb1ajgztTvYr6L/QakMxwGWXUbhljQb9j1L8NuvFH2hKSNdCkMnnCvXkAI5pp5
         rmdZ4qDJ9egcNLwVa3hiQV+RnGbY5AfJ4+/t+H0uWlpneNWcBmVfOJnalZo0vW3urCBn
         teX13Pdl/lMyiasmQftLVuyzEQ0XI5gWV0+d4OGlgAlm/JDTU9TUSg9uLSmf8i7mi7La
         yIriDqpDX23oOTtowOdATtzKYsNyvG5ieGtPnAxieuBWOuvwX8tfpx20xl5EOSyQt0op
         vTGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6y9AUyAqq0punB0p25H3aQ8RSZH3MKAHnozHOyjdT/o=;
        b=A19AFL0IWKIPcXqEFdrZzhaPahlTcjWd/x+ATMrFzBjSXQ/+xaJe0OJiZJhmBZENvv
         MAYB2t5enJjdgfrj3GHUQ5s1pKXLljDnUJPTn9ZeSfcg0YeQMIzWBHLw0WZw3DOYVE35
         veyOXCZj97lTGLtCqLHoAFwzHBGg9jEnAmAwvbmJ9bD/dZHfie1DsL3M1njsZhD/wQzW
         fN2+R1n+Ard/drXpmWU3iWPKWiB1jIHjtXgmzsEdHILHkaWsIjT2OPRofKFQg/1QUkEU
         Jh52COnszH6Wy6DYSCTk5sV9fdSWHLC8egvxDuDKZwuc/jiJVhXed2Iq1A9rEf5qZmL0
         PVpg==
X-Gm-Message-State: ANoB5pm8SSCm5Y8aj7ivQwpTCX8ZfMDQSbXeb6hxlxokqG0of2hs56Ab
        dwh4I3z1/ns1cwldrKx1iLsMs24/ltwfCulqva1LLMIceog=
X-Google-Smtp-Source: AA0mqf5rVSN3sU8H7annQKroyzCuVfNG6TOykuN/kwAF13K5JIWuu8skyrXchhhBPXYsKpgRNQ8TlQ516IH3mgc28ME=
X-Received: by 2002:a17:90a:a88e:b0:213:13ab:c309 with SMTP id
 h14-20020a17090aa88e00b0021313abc309mr67274062pjq.80.1669861203738; Wed, 30
 Nov 2022 18:20:03 -0800 (PST)
MIME-Version: 1.0
References: <20221130180544.105550592@linuxfoundation.org>
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
From:   Zan Aziz <zanaziz313@gmail.com>
Date:   Wed, 30 Nov 2022 19:19:52 -0700
Message-ID: <CAFU3qoaA-_ixnfFFZXvnSp3t5YPTQzY01US4gOyaJedfFg56aw@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/289] 6.0.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
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

On Wed, Nov 30, 2022 at 3:16 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.11 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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

     Total time: 0.710 [sec]

# Running sched/pipe benchmark...
# Executed 1000000 pipe operations between two processes

     Total time: 9.551 [sec]

       9.551475 usecs/op
         104695 ops/sec

Tested-by: Zan Aziz <zanaziz313@gmail.com>

Thanks
-Zan
