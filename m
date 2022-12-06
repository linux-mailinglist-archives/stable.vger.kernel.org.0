Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDADB644AD2
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 19:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiLFSHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 13:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiLFSHM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 13:07:12 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 533113AC37;
        Tue,  6 Dec 2022 10:07:11 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id m4so7779580pls.4;
        Tue, 06 Dec 2022 10:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2YtxpTRBMkQrFKVlk2fLe5SF6BAZI+FTZ8g6kFOfOAk=;
        b=Hx3c1iTrsaQWgVMlJZ/AjAREoRG8YNOURxidP0YjgaPt69QiceSsgqs8rPspgjy9sJ
         e2ln0P7ZY4MUFKGepPn58S0wFlfdL+SnHC3BSEpBtxu100X2aJXMtGXF8AxjpZfHTO95
         8FDMGGvH4gQ0+BoupBaV1tghVUhrxWsq7GH60tm/Z6/Htn03oF1RuEzQx1LMyQmdrag6
         8Y9DteQwk9FnQz84C2VPMymjsjHWjvQg9RVaIOkNtE9rrVovUy1jku8IO5Dk9+gytqSo
         2AGIFvoN+HlitDp1f1HRp+Ai3QiYaEGx63L13+nCDb9CiSQH/9JPAopgxu+KZCL3svTO
         9/KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2YtxpTRBMkQrFKVlk2fLe5SF6BAZI+FTZ8g6kFOfOAk=;
        b=BBNnfkiHfZum184Eortf0ptf3II4HJ9Z1gMBumNw5asLYxzkKYH+VUYftsJUCaNcDW
         afJQGu0T7q1I9tyt3x1kD2udgfM62DETRET0bxA6UxfVrFy/HE4tCLiU5N7NN65vCNFp
         n5jWpHsOSc2eJkGiecJt4a+70O9ko1v1A9+FmyWhEoaTkZmTGQdVLu0fp1c7/mh5vOjr
         ZNA+0izYFsamithnDNmIjT0HFPSjhYly5+TI61/n/3XZquxpMOTqowT8MuLO6cbmv+Ls
         Bw9znsvNR7iW/wtZt7Ct+06tKXLhCEpWRDAFBhBwqdo+pjXL7FAuLHrzc6rTCXVB8bFs
         escw==
X-Gm-Message-State: ANoB5plaFg67K4q/PXKVSexLZ+mofVWL6qixkesmoVkw9+HFovAKhgkM
        4nVQcbHH4UvG84VvG0llqZz7z/pbvCxczR5iZWA=
X-Google-Smtp-Source: AA0mqf4KfDHXmkm1COm0QbVzaO0KO9OVT7vFeFskzI57ZSVymhCP/xzXMl8NoNFPgEEzzOGSFYnKLtDdfC70gazcOL4=
X-Received: by 2002:a17:90b:194e:b0:219:64e2:7570 with SMTP id
 nk14-20020a17090b194e00b0021964e27570mr33838030pjb.213.1670350030909; Tue, 06
 Dec 2022 10:07:10 -0800 (PST)
MIME-Version: 1.0
References: <20221205190808.733996403@linuxfoundation.org>
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 6 Dec 2022 10:07:00 -0800
Message-ID: <CAJq+SaCmmB_NgM2fHi0NYGOqSuio8WMATGVFwfh1vzzCwsG7SQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/153] 5.4.226-rc1 review
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
> This is the start of the stable review cycle for the 5.4.226 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.226-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
