Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FD85E5469
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 22:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiIUUTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 16:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiIUUTM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 16:19:12 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5744BA4064;
        Wed, 21 Sep 2022 13:19:10 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c24so6797634plo.3;
        Wed, 21 Sep 2022 13:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=7vvPFj0jE1tZKf3KUJVQolFFxWiOViW8vu90FqvQ880=;
        b=Ff/Q71J6NxjFjngVC9VCamiLcQ/uCanQ9oTuUBfy0gwBS1G2JzqiozFDqms+jaWJy0
         nmneiL3xcwreF/BocIoFke4uHtE2kycnB6qlX7rPzsUrBv8kLxnBcOtrPTlwomt8edkO
         HKE7Kuur942MGf1VkO99FD9RvEYXvErSsMgdJfBMvFUqiFbbUo782iYKXFhc96MUtlWE
         klx6Bx1fprJq+s0oPTT9wbcEh4gXXXmrMlmVVNQvhZIX06qR1GgMHmU3KHRAz0rh4y++
         MEkQtmYsh17fhbrmdl16Q4BR3Z/PLjPfNEWNzLqnnUjW4sZ7qbLwE4+359mPnIpPBS2f
         EQLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=7vvPFj0jE1tZKf3KUJVQolFFxWiOViW8vu90FqvQ880=;
        b=DLcl+K6df61ldmw6WZ6lm9oM01HZS0aFijX8XnzSXAeSU/YqyOZxiLFybsaZG9qO/d
         XI8FIdnI08XaToOTuMx2V8Jd0qbyyHNhX4UcTiYmT6D2h0SrrzBCPtRXazhB2vT561aE
         20DWdC5Kc9S8HDsZpfY809lV675nw0d1qzHCmoxh22X6/xH3IIE+U9877P0Vwg8WGfzO
         E/xQxvavq1yUfRhbHyfra/nGHk60IBaVbeOYTZy0aGqQOXCAKs6QuRHa3f9CkI8Wk+cI
         9tSP0+etlWmfNCAxs1ep5i2gasYERSe7RXw8JWh0AHDVEJ/nNXxzhTiI04YOU36Jt7Rw
         bvUA==
X-Gm-Message-State: ACrzQf1Ne9am0gl7QDmnVLWGx/ITd3Z7+jyMLpl1Q9THDulQqx+a80YH
        lVrSq/fiP1m8mAqIrXWQywe7fcwmUuON3yzKI4eAABJQmrg=
X-Google-Smtp-Source: AMsMyM4yb0J4N2D/Nqs0pZVq+mbfo2LTBF8Wq2C/+//t9TL+9wUn8qPZo2Riz6RLZdcnG8dI+JEZlhuKsK007hKMLNI=
X-Received: by 2002:a17:903:2306:b0:177:eafd:36e9 with SMTP id
 d6-20020a170903230600b00177eafd36e9mr6424723plh.135.1663791549856; Wed, 21
 Sep 2022 13:19:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220921153645.663680057@linuxfoundation.org>
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Wed, 21 Sep 2022 13:18:58 -0700
Message-ID: <CAJq+SaBihOWnXUWczrufS9v3VJLLe92UPY3k5crd+-O55pKyHA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/39] 5.10.145-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
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

> This is the start of the stable review cycle for the 5.10.145 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Sep 2022 15:36:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.145-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>

Compiled and booted on x86 and arm64 machines.. No dmesg regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>
