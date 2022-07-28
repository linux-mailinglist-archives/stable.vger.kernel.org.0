Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBB6584239
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 16:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbiG1OxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 10:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbiG1OxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 10:53:01 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE9E5E335
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 07:53:00 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id i4so2694057oif.2
        for <stable@vger.kernel.org>; Thu, 28 Jul 2022 07:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OzaFTfFjJcBqeTt4+aAXn7s/cwrwl9JZ8wjMvkdATBg=;
        b=hAYopeDIjkC3heXdVb/Lb9okyGlITFJJJnujN8M3uPUVG75NLrD8xgCza//DxNNjmD
         P04P+KqPxvocSYLdyw3W/z2Cdqkah7HM1rz/h5jvJVvsj71F/rKJioHG0PoS8rI2x3Me
         2wj1DIpCedWMNpM+ctFq14ojwxhr7uIjOtlYE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OzaFTfFjJcBqeTt4+aAXn7s/cwrwl9JZ8wjMvkdATBg=;
        b=DJpXjgMK9j7rGjFQrizpJf0RXsjq9z0MxCfgwlyUdn3pV7VrqXZFOFb+SJRJA/xfJ7
         yy5QVDxbqTUI8jEdSuZ2xhhV7GG3u4HfrbmZXygPZlx2joeHJQVUpXQPK6dvfR1QJrg1
         W4OfzPJEYiuGdnfzsTXhRPkExF+dNakO7E/Fc4eXPrFwHTCPhcoqXEjNwXT/D7HB0pb5
         daIskBTB09+lvDql9KB45IDFzlgXa77DGo4qy+9r2gBBObpI19wgBiYIoVo+iAYs5rOK
         DeDFcD1lVH3bKW1khjLcf032p1YQNnLhFM08FY4l7sKFZeafd0xaS5/XloytsUnODIEH
         D4Ng==
X-Gm-Message-State: AJIora+mPhNhBU1vHHSad/NoYTytLr0VFanCzGXu+gEXkOi43u2NRvAY
        rfd5ezLVTTWeD+vUJy+hraYVDA==
X-Google-Smtp-Source: AGRyM1u4oe9L4dQ9fEMwdz3b4J9ov/Jni73YxJ8sfm2poCcNqkLa2HDNpw2dtDnRVfo6k26hkLBUPA==
X-Received: by 2002:a05:6808:23c2:b0:33a:ad0e:f85e with SMTP id bq2-20020a05680823c200b0033aad0ef85emr4071998oib.203.1659019979967;
        Thu, 28 Jul 2022 07:52:59 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id d184-20020aca36c1000000b00339e6212ea7sm321607oia.55.2022.07.28.07.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Jul 2022 07:52:59 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/26] 4.9.325-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220727160959.122591422@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <75abf2b3-b6f6-1c8f-ab1f-8533e09804b2@linuxfoundation.org>
Date:   Thu, 28 Jul 2022 08:52:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220727160959.122591422@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/27/22 10:10 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.325 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.325-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
