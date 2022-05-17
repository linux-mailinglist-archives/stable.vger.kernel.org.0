Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F37E352A03D
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 13:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344978AbiEQLR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 07:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345778AbiEQLRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 07:17:43 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D91D20BEB;
        Tue, 17 May 2022 04:17:39 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id j24so9020914wrb.1;
        Tue, 17 May 2022 04:17:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tfzfVxge0emhM+6jxN26BTt/S2/OLle3vsBshd/D9og=;
        b=m7TIWesAhnzeCxa9V1IG6Ls6U2l28DOdwwv0jTKbzasUhqOml1xHVdH2rJOW9T9Fa+
         9ytobq9oKQScZGb0RymVEkgtX0Extnvkna3Eajo8gvTJhH0ck+3GhSb/vxZTz9ah72j5
         O2AuA7nkQdA4FIFJn9MLffDwew7t8gKHnPSAGz7FM7CFkluQ5bBuPoaOw3aMWmJbsOas
         DJpoHkfJDCRsuFfC6IF81fIrU2CS2ZHKWIl273ajmSR6Yo8pOG+bLeJhNjj43GLbYyJF
         gllrBEFrqOOQEASGA9rA73osxPzkkez/CkQ+D0Gk4LZXwZnXAcY1B0m1NHBxYMzL5an1
         NFsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tfzfVxge0emhM+6jxN26BTt/S2/OLle3vsBshd/D9og=;
        b=vRXddHhCyIlhbaCytNFUkiMeZs0xRYmoNlHktsai6DGPqFODWo1F9OqecR1vqmuj9v
         UJVD9SMTgkxYsRmVKYKO1hCKhofYtWaYTLYdltbI+FNmdtxhmHUBfUTgp0/mIF7IfpJa
         b8svLha3j5ktr2IdkvniugWwmIQJFqQpfu0D9HaaubVxA6YNfGphk0yU2BVvBalZa13V
         5tmDO/FyZ7vOncQL11mUvFVOijLiwF+1nJTrUL7+vzIDgqEo50ZMmsB/i1Gi/JLB8jvI
         R7GCC3eHCUykWuDQDr5irStOzTVNm6eECVzPdiYdBL+r9zg6GuH+gDQbvA24hVN0r3Dk
         O9aA==
X-Gm-Message-State: AOAM530H/YQV+Mt8iI1jzqj8iF41mRJ47hvQv9Fez+6CZl+VJmE+3HRx
        WK2EZExPHetcdFiCUxCQqmQ=
X-Google-Smtp-Source: ABdhPJzvaKR5MdM358nMlAB27yX5l1lDgvYcY04Wvoru13CiZgJ569ZUbrJ+BL9iIME76qsG75OEUg==
X-Received: by 2002:a05:6000:381:b0:20c:5e07:f75f with SMTP id u1-20020a056000038100b0020c5e07f75fmr18624349wrf.678.1652786257958;
        Tue, 17 May 2022 04:17:37 -0700 (PDT)
Received: from debian (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id x7-20020a05600c420700b003947e11c3ecsm1557758wmh.17.2022.05.17.04.17.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 04:17:37 -0700 (PDT)
Date:   Tue, 17 May 2022 12:17:35 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/68] 5.10.117-rc2 review
Message-ID: <YoOETyKQRf9RFvuT@debian>
References: <20220516213639.123296914@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516213639.123296914@linuxfoundation.org>
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

On Mon, May 16, 2022 at 11:38:20PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.117 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 21:35:34 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220408): 63 configs -> no failure
arm (gcc version 11.2.1 20220408): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20220408): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220408): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1170
[2]. https://openqa.qa.codethink.co.uk/tests/1165


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

