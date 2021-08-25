Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0613F7582
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 15:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhHYNEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 09:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241024AbhHYNEM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 09:04:12 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA5FC061757;
        Wed, 25 Aug 2021 06:03:26 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id d22-20020a1c1d16000000b002e7777970f0so4241763wmd.3;
        Wed, 25 Aug 2021 06:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ajoObTpBOMq0HG6JcMfkwvfTBeAFH7pnhMJZIOox90Y=;
        b=iidePI8/ErhARNUitKfra37DTcNrGi8trDUpXw8kl5DOJSLKA1o2ZOeEwTvW9yUDAi
         mNOz0OA/03uRMqx9SzN/SdRQqffLZvJe4l8I65NjDHTaRD/3px9TQ/W0bft+A9CzqJU1
         uhUCY0mES//qQZL66wvyYOX8AWuPgOc42ilzhvkilKts71Vquo1WXTvvg47R6sEQ37FE
         YeFvgwjsxBqZ1y7e26S4wKH+7Xn7k8X0/VynT1T4i1VmAeGzjEFq4AsNOM3R7e10ZTlm
         zHc+B2Un91bnnT5tCUYVsj6uC1BDWLsOdrNYu4oNIuyjDoWocj7SnU3fZm8Uw25lIjM0
         NQaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ajoObTpBOMq0HG6JcMfkwvfTBeAFH7pnhMJZIOox90Y=;
        b=c+DT51jjiv+M2gfsj9B1hVOoKen9+B489GbolGfSLIyd1zftxx1x6DHNWl3B69JUR0
         Y4QFI141ryWrFPOOXGCK6xCu5wlUUJ4GwuoLH+hHP71X3tig4bnN5dUcl+ko1ItRPT7y
         Bki6zt0m678xn15Ur88+sRFSjZd6QzJoXc0WmJxKuAKgioA2Nerka4fmi4wj2lT3ZnuZ
         pdwcQ+MLEgB9DdbJcyRCTogZvPq3wH3PCQN7CTToHdDL5QTJinYon+7tReG7x/JJRVG2
         N+JxXV+eQ1JX8oA96fm1k9pgSgxwil3gpTLLdOwSj+somnkfCuSIsuBIPvFgAsLXn3Ja
         BhFA==
X-Gm-Message-State: AOAM533jCiSvfIOP7twia5lcSQkuwceVlOuxBS7xi2MHWlPaQlxrXkNL
        eg37Zycbvk/Lpu/pxA+6ijk=
X-Google-Smtp-Source: ABdhPJwBJ1eonlShCcYY5lreMLwyvX3XBf0OChuN2ZsTI19ZKJwHgFx3nZ9mlRzIQCjaqkO+WhqYEw==
X-Received: by 2002:a1c:4e16:: with SMTP id g22mr9192676wmh.55.1629896605275;
        Wed, 25 Aug 2021 06:03:25 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id f23sm5067597wmc.3.2021.08.25.06.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Aug 2021 06:03:24 -0700 (PDT)
Date:   Wed, 25 Aug 2021 14:03:23 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.4 00/61] 5.4.143-rc1 review
Message-ID: <YSY/m/h1AmTEKHXP@debian>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Tue, Aug 24, 2021 at 01:00:05PM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.4.143 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 26 Aug 2021 05:01:01 PM UTC.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210816): 65 configs -> no new failure
arm (gcc version 11.1.1 20210816): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210816): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/54


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
