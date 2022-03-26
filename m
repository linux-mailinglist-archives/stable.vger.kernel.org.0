Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E2B4E8148
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 15:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbiCZOEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 10:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbiCZOEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 10:04:36 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BA5156C5D;
        Sat, 26 Mar 2022 07:02:59 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id q20so5880969wmq.1;
        Sat, 26 Mar 2022 07:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kradlhexzl6o52v00L6GMF0yV/dw0O6+Ff/xGQaY6Ww=;
        b=jBMQnDcVkTL8MqArkLZZAA9K1892I4m7zQBJRPhBecpzEyjVXVKr77BW37GHPOujuf
         Q10ao0E9xOBiT2XSx8odO0MZX8YUPUrL6Af7GBJMBS7Vj6Y5qoBEYjr0XuyDzwe14hhp
         /91HllW21A/5RbbYHVy0MOJroZ0ZME/JqpFbkWa7PpcNpOcdANNQBSmSOesjfJ6ypowF
         ip7CrUCYezMKwHY3jNAcAh4F/iNfym4Fbsp6ux2/A1g4gUgUjn2CW5J082CCDY55dtm9
         pRGPeQjL3dNo5wHFboz0YRFyD1woWVtLeE4jhKc06qvUhfMa7bg7fH0gceraJCJ9GzFH
         3dgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kradlhexzl6o52v00L6GMF0yV/dw0O6+Ff/xGQaY6Ww=;
        b=zLm9uPYhEepkLL5QmYbSf5E7/LwflPp15mkm68VH2Qq1/lxqpYtSCTFYLHRLo7JBkT
         uwqfwLps7SjexXrJRofEUDjBwrUPH4XjgOdOHMNuou4LxA3bWq1pdA616Na5sENimHJR
         H6eiR3yV8a2+y5pdUzMk0OGTgB8Q7cfoASVv1DB82l2ouBeuVTm8eOabfCdu3W6eMtFb
         xLFQOo/mOZWWJhLdXpm4JD/ombnU8ny9IfgRyRmyj7oW6N+uG0GA3lkHD32wkaFETV/U
         zvcHDNFvlHrkNpHB/if99G8sFg47UYNNR49ATN3vhmPJLAyGdJJRDxOvcZi48ZosEhvG
         gNQA==
X-Gm-Message-State: AOAM530+2YTxlRKA7qQr0kZx8GedvS4hitxGcDBvTfMQMH0EGCyFGOYX
        UrJ2yXrnLMue7tV7CiVXqwX+RyQqDhE=
X-Google-Smtp-Source: ABdhPJznXAs8lFjkpctlNtM4KyIsKa1y2zHOgCoqLK4I0FcfWd7DKi/KSvAz35WrEn/7yZQ02aiNzQ==
X-Received: by 2002:a05:600c:4f15:b0:38c:b729:4838 with SMTP id l21-20020a05600c4f1500b0038cb7294838mr15331887wmq.132.1648303378266;
        Sat, 26 Mar 2022 07:02:58 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id h188-20020a1c21c5000000b0038c6c37efc3sm7374828wmh.12.2022.03.26.07.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 07:02:57 -0700 (PDT)
Date:   Sat, 26 Mar 2022 14:02:55 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/29] 5.4.188-rc1 review
Message-ID: <Yj8dD1ejU2zCa6OA@debian>
References: <20220325150418.585286754@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220325150418.585286754@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Mar 25, 2022 at 04:04:40PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.188 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220314): 65 configs -> no new failure
arm (gcc version 11.2.1 20220314): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220314): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220314): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/939


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

