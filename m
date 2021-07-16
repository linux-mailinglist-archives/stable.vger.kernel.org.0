Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20CF3CB9CA
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 17:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240361AbhGPP3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 11:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241014AbhGPP3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 11:29:32 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1DDC06175F;
        Fri, 16 Jul 2021 08:26:36 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id f93-20020a9d03e60000b02904b1f1d7c5f4so10210571otf.9;
        Fri, 16 Jul 2021 08:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FQdR6op+7WBYNDUzA/PH4cP1TLkkwTedaU7CNoXH0K8=;
        b=is23gRH3vT6ZrN6v0otpUpycO4RBmpGLjWUc82bGf5Pmt35OEJmdy7KO1RVbmrov/g
         c3YgR91KO64xek+vwqKy4kNRDsvoFTmBjhdHeBk9tFc4B/eJ7Rh5TlXvgt/5ggo33/08
         7Bae+SvDRhyC09Al4mkqlTDkvtGT3e2339tzOEvEEVxyw3AJ1kxziOzSFTqYWztwUDhD
         UYQQoeG8j4DhW3y5E1R3awj1unI6Jbm66v1qZF3IPzVAvv6NG+YqRb55QbhmCd+INH2c
         yBvXgdeDCXe3PydXgYgp5onbjp3qSD+tdKFbu8BcU82wyyvt3szS6APMx+a/OB04ewZ3
         TcRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FQdR6op+7WBYNDUzA/PH4cP1TLkkwTedaU7CNoXH0K8=;
        b=GNO23amslpOFc7FRzsJRf07ndsqZn8qjeId8KqOpvJNxZYf+tKLookWHmV1zXfIKxG
         tUOZGbHP+zXcOTizSjrkSlCVI5QwdJLxLHCA4KFPm0SOGc8fXxD5KfSkrCwTyrtvwsRG
         /EspoOi3gW96ivAWfja9oSiBLAmZzR0/mJs21KzXQIbc7pYnQC+yJ6bMlmX1c2ZDZxgC
         4ZpkfnLMiTANDnKOtcP5FdnHNeXBw9WlylY0yQrwDvsn3LmQG8ZA9LTck7GK0c4I8KLp
         y7xsHs6hB0rh2FrS1nUF3PuLV0B9ifsHyENCKy7HdHllNlaaBdebASZnU31dtgdwKxPh
         RFqw==
X-Gm-Message-State: AOAM530Fq3VPmmNUfDVm8CokIHH+1vBB2vPTaK3p/cFyjlHHP2vz8rF6
        BNn+PySVmEDJ/JXqYuVs+7qMbk3ZjIA=
X-Google-Smtp-Source: ABdhPJz5YgLyGmPFe0qN9DzV5hOPlVEkLbcG6cHQLfgEYZJ/KWbCTwZBeGesj+I2faoJ5h95bebMCA==
X-Received: by 2002:a9d:1d7:: with SMTP id e81mr3716619ote.106.1626449195707;
        Fri, 16 Jul 2021 08:26:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c11sm1965155otm.37.2021.07.16.08.26.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 08:26:35 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20210715182613.933608881@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.13 000/266] 5.13.3-rc1 review
Message-ID: <2eeb4711-8ad3-9d87-23b9-ba298cd462dc@roeck-us.net>
Date:   Fri, 16 Jul 2021 08:26:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/15/21 11:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.3 release.
> There are 266 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
> Anything received after that time might be too late.
> 

This one is a bit surprising.

Build reference: v5.13.2-267-g7e5885d
Compiler version: x86_64-linux-gcc (GCC) 11.1.0

Building i386:allyesconfig ... failed
--------------
Error log:
drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c: In function 'dcn20_update_clocks_update_dentist':
drivers/gpu/drm/amd/amdgpu/../display/dc/clk_mgr/dcn20/dcn20_clk_mgr.c:154:47: error: 'const struct stream_encoder_funcs' has no member named 'get_fifo_cal_average_level'

Turns out that CONFIG_DRM_AMD_DC_DCN is only enabled with allyesconfig
for ARCH=i386 but not for ARCH=x86_64, and get_fifo_cal_average_level
is indeed not a member of struct stream_encoder_funcs in v5.13.y-queue.
This strongly suggests that commit a39c5ab96adc ("drm/amd/display: Cover
edge-case when changing DISPCLK WDIVIDER") either needs to be dropped
from v5.13.y, or it needs to be backported (and tested) properly.

Guenter
