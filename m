Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D352648A339
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 23:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345523AbiAJWz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 17:55:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237087AbiAJWz0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 17:55:26 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3C6C06173F
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 14:55:26 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id y11so19816621iod.6
        for <stable@vger.kernel.org>; Mon, 10 Jan 2022 14:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CqFVa+KRhHTBPE0VRAyEjDnBk9I+Xd+yTxNQSK/RCbc=;
        b=TaWMLPVI4fQ051phvS4xUnYWuTpwWHL6VOPM7gLGWZxaTPsjd9TQAF0IVBvLshT72D
         fG5aO2XbGidKef1TvT9JotCJXYJKrGH7keAKv2YfClVi3FZWcz4YFsO+Cmks62mbs868
         pxzqecL1yW8z2N2BMpJ0JMCTT3KQgUVZgUVg0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CqFVa+KRhHTBPE0VRAyEjDnBk9I+Xd+yTxNQSK/RCbc=;
        b=7RrpXI70QmxUMrrJTU0HgVxuXJTzzspeEVjPZYAT7hrv2bbSmJ7wyl8D40ApI1QKJA
         7XdyEMqXnSUmCIvhC4HGJt/ZpMevig8zVBQGJsbBAAFvhUxWHm27HjKmL4LWt6c13jce
         JGpVQ/HPKK8nzT0MnNPzcx5DPGiYMRGY1JNrlD3FvHoDsWXZU+okRxjUwAEfSWZ+8+rD
         Noev5XZiddC00RUA1yVtbo7iZEWPi2kQ3PuyWAhizt0z2hUMkLTrMg5pxn7rSxa5Dl2e
         12BgE4sTHC5cRekbnPiPLYn5G3/p/KDdOIorYUAOOweJDheGm2RvVyZjpd2Obo1Fds9C
         oQew==
X-Gm-Message-State: AOAM531n5gb2VChXFabXSNNYRuQ6woMCyairkA2BdBxL9T8QLa3AtPO6
        TIWDL4lq3Q9NxS+DtozJgK9EXg==
X-Google-Smtp-Source: ABdhPJzSpyEDp3f6DRoRcwarPMAwJ2WNN6N2HqpkAzL6XrWp12VeogOU/crJLvY4mkbl+u2/GG5loQ==
X-Received: by 2002:a02:cd23:: with SMTP id h3mr631596jaq.249.1641855325695;
        Mon, 10 Jan 2022 14:55:25 -0800 (PST)
Received: from [192.168.1.128] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l11sm4623751ilq.74.2022.01.10.14.55.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 14:55:25 -0800 (PST)
Subject: Re: [PATCH 5.15 00/72] 5.15.14-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <dd3b1de6-dd82-fe48-7802-8d541db99def@linuxfoundation.org>
Date:   Mon, 10 Jan 2022 15:55:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/10/22 12:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.14 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
