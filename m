Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFE93A0A54
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 04:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236199AbhFIC6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 22:58:03 -0400
Received: from mail-ot1-f52.google.com ([209.85.210.52]:46899 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236198AbhFIC6D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Jun 2021 22:58:03 -0400
Received: by mail-ot1-f52.google.com with SMTP id 66-20020a9d02c80000b02903615edf7c1aso22433869otl.13
        for <stable@vger.kernel.org>; Tue, 08 Jun 2021 19:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MHpXnINlDo8d9pPIDXFx6YoGT9n3o2aqraOH2+9LSv4=;
        b=FUw6YUzivJjJWXKWDgAwOEVpQqTamyMGDRvIR1KoND9YULhUajppopwEQnLZ6U8lFN
         FLIxPZScahxyFN+yWxsAqjTB/G6m5Fno1obEueCHP+tEjWp89PFw5HVLY+MWzLO1DGBO
         mc5JAKxOEH4RiWXv1wTS90vlrIMJWfBCoo6pQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MHpXnINlDo8d9pPIDXFx6YoGT9n3o2aqraOH2+9LSv4=;
        b=B9IAIv9Bp3901amd5cJ9F6Nja0m9OkJ6URGdCBqY2tx1Yr/Jgxkg3pu5WqQxHDlzuc
         u9W+WJVrvfwI5ef9uuPpalE9U4BUCCAxVvik0D58WJ87MruiSpTldEJWM8T+jSP8Ar70
         tFmkQEfTMdCHnjHmzvIblcoZflqMugl3q1syUbgHPO0ZejSIiEam31eYsSnAWiz8sKkO
         2AG3lVcm5HyojK1010nmIHLO9TB/KfUx2MbIGqOpDKJGj73dLsuVbyquFVrLSlF4cDqL
         zNIgbck7HjsOIbxxFyGMWKS/u49G3CMDa47q6c3WC5vsz6SvMkEyWLtfUigyQ5N0RYhp
         fgMQ==
X-Gm-Message-State: AOAM531xijt44r7rkpbU8ygksz2gtsSxY/JrHFBSCMahQYyRIrOZcnQ+
        lpQgJyAb+BR2onhN/jD7D7WknA==
X-Google-Smtp-Source: ABdhPJwFj8sEuoLDo/xuACWJbFpzoEIpcdPRMqW6TQf/lgHmwCvj7IycxlT6MTpbsT54eKwafn0vOg==
X-Received: by 2002:a05:6830:2fa:: with SMTP id r26mr21001606ote.325.1623207309738;
        Tue, 08 Jun 2021 19:55:09 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h18sm2044876otm.46.2021.06.08.19.55.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 19:55:09 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/78] 5.4.125-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a0b9ef36-c154-1e6a-00a5-68bf70c69dbd@linuxfoundation.org>
Date:   Tue, 8 Jun 2021 20:55:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/8/21 12:26 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.125 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.125-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

