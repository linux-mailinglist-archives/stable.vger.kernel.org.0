Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F59532CA2
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 16:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237325AbiEXOyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 10:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238434AbiEXOyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 10:54:15 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5377E793B1;
        Tue, 24 May 2022 07:54:13 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id bg25so10743913wmb.4;
        Tue, 24 May 2022 07:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lIftGkxkcgH+2a59/SoXiFal9U5oJMiR2S1lVUmLpoc=;
        b=L+QvIQpjzyG02NccJs6ASkL5wfY9L8/NFfboQwkx22Fj2k39OsxEwqC0OopRzm885C
         nHTCfXc9zeklkRswUx2xpZh/VnQshqxQ6MEDamxWTXHTj3lKKurSmystiXcmrLt/DK0L
         gFp+VK9yzICfJJjV4d0CsZshyMxnN7ViUVvgE3GnZhoWQC7xVXExOWui/azG9JyYiFpl
         kBTT1A7TsgE+HFeLbpPyt/z31wspV+b393GmXdLp4uJKvyfagyxUBkzTRcvb/FLAYdWo
         VPDsJNci6VN3aGKdykMRoyeyySLcxA7qJ2excfeOJUY96ENVZFcuT7M5B7G0WMRUbiW2
         2nkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lIftGkxkcgH+2a59/SoXiFal9U5oJMiR2S1lVUmLpoc=;
        b=mQSwcVLZlypIsI+ZTWTZQfhczYV+78AMa1WLxKhVyRsBQyVlSdupzcFYyvP6R4YKkm
         qG6xnZNs5mezja7stFiLKx5v57nTg8SGO6E8+LU0G7Ebu62hJsMYJcl+EsUTpNmVuzJu
         4u4ENwYcEB3Az4QpwzVD3DWt7UUOpQL4bWCtLCqgS4qoA20jjdYfcm9x1+/QwZjFIKGr
         1WVzV1B1iVGoiqL56oMcySu1ZL8HKOYttZS098+GlcAEoZ5DuF6vYy4rfc64a6rzfNQk
         RrmH1LiqRPbnPyr28SU6Jw6qnSMbqGqmcLKIB+Jx0UtAT3rSTXXkTohg75QBQaL1jFr0
         6fLQ==
X-Gm-Message-State: AOAM533tLflVz6IaadltT3Y/K3thXpCFcB1l27oNtmvlRY/VCGpQo7W3
        8Enk8irrOSY6UvO8zvgbjnY=
X-Google-Smtp-Source: ABdhPJzk/AGPZprAGdMvvsF0LAQZYHiQMgYF5dpdZGMAGp2Or8mPvdVitlpgv28UHLPycS5/DkkIjA==
X-Received: by 2002:a05:600c:26c5:b0:397:49d9:e038 with SMTP id 5-20020a05600c26c500b0039749d9e038mr4292589wmv.25.1653404051898;
        Tue, 24 May 2022 07:54:11 -0700 (PDT)
Received: from debian (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id x5-20020adfbb45000000b0020d117a4e00sm13042824wrg.105.2022.05.24.07.54.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 07:54:11 -0700 (PDT)
Date:   Tue, 24 May 2022 15:54:09 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/132] 5.15.42-rc1 review
Message-ID: <YozxkRYdKPpL3Myj@debian>
References: <20220523165823.492309987@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
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

On Mon, May 23, 2022 at 07:03:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.42 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.3.1 20220517): 62 configs -> no failure
arm (gcc version 11.3.1 20220517): 100 configs -> no new failure
arm64 (gcc version 11.3.1 20220517): 3 configs -> no failure
x86_64 (gcc version 11.3.1 20220517): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1199
[2]. https://openqa.qa.codethink.co.uk/tests/1202
[3]. https://openqa.qa.codethink.co.uk/tests/1203

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

