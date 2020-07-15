Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAD62210B3
	for <lists+stable@lfdr.de>; Wed, 15 Jul 2020 17:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgGOPSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jul 2020 11:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgGOPST (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jul 2020 11:18:19 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4D6C061755
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 08:18:19 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id d4so1756131otk.2
        for <stable@vger.kernel.org>; Wed, 15 Jul 2020 08:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZGZrT5C+OJg/dALQFoR2ZSEYVyJtYgGFY+YpC3Erpsw=;
        b=C5RE3jdW4ZsdO1UdVDukf3InUdzEReBCssd7hCg8G1G/ZxF5LPBHeFwtJuWCPtizfV
         DNtQjrtzwALOkSRzxUnbiSoHK3v2CDFblx8To1rgM4bIidVH5nFM9hjaPaMwiHAez3Nj
         PJ8/QvXffLbUf+rc898BiuFM8Hb3unpxGKKDQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZGZrT5C+OJg/dALQFoR2ZSEYVyJtYgGFY+YpC3Erpsw=;
        b=C/bUzvc6jHZw7a4PPySt8qsAdlGI+WU8ZrEearLved7joxLTBYlWltb9v+uCg41iEG
         BWCb0Li90BzVnLVRQ8F93xPUNVCci5ep41zQ3ha3B3ZYq5OV6cLmv7HldVgS2XDKSDbZ
         pxAbtOHP3W/phcDPJI8LbYlLgdqwL5V6ZJ9eZxkVGFHUCGmDVz0jnJYDEy7bR6pHVa17
         SHbiMNMnDEUdsaBtPmJOOO+haW88rdKIUhHOC6eR0JiuitmqEaLJjOAoIDhe8PHMIZHl
         im66cYtev6ZgcbtDzyQTFFpPIiUFDtmKxkWnPAQQ7zl2NQJn/sqe25pE7fsTe/lK4mzS
         +k2g==
X-Gm-Message-State: AOAM531plnjqJa/kmffWiSvAI0M0mrZBIQ5EKfs8N3S6UR3U7v6ddO6/
        99iHlsAi1hTxA/WVrttYqhayQfQB6Uc=
X-Google-Smtp-Source: ABdhPJzcsWOqIAC9bUlBbYxT5fvs2+0huil4HgSCi+u8/mV6BPw3WkZeUOUph3tU6vKs+0neR4jl9w==
X-Received: by 2002:a05:6830:15cc:: with SMTP id j12mr145626otr.116.1594826298533;
        Wed, 15 Jul 2020 08:18:18 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id y1sm474728oto.1.2020.07.15.08.18.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 08:18:18 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/109] 5.4.52-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200714184105.507384017@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <8cdff8fc-07c9-8d55-3559-21f5e7d3e537@linuxfoundation.org>
Date:   Wed, 15 Jul 2020 09:18:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200714184105.507384017@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/14/20 12:43 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.52 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jul 2020 18:40:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.52-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
