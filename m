Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02DA3CAF24
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 00:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbhGOWdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 18:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbhGOWdr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 18:33:47 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A164DC06175F;
        Thu, 15 Jul 2021 15:30:52 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id j199so6967569pfd.7;
        Thu, 15 Jul 2021 15:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vytsy0IcEmMVO1itDPPXDuj7iE07xYLydZo9z0U7YgI=;
        b=KQ/T/XNqar54wbEMQf/lV6OT35KRL3sXqEuxSGH1ksqOg9P/iiHcg3R2FOODuoX6i7
         7CsPELydbpkX2v7JIV6+QV+DZnLcqCENtaf7FAiEsKl7H7s0m3+GVAh7QooGtBjlBOob
         6nuU3eNMERbOSNOxwH1qBIxXw6PcQ1+Is8K+TTCLw7wgGsiXOmoyVmX7aZL9boPX+QzX
         t4Jqan+PZUlc0qgrCezL4ZnCUZEbZZZX6YCMyTT1Nj8vrqsS+pX6p/Lt/QmL4RF6QCZ/
         aGwWhXaVQTRotyjI/lGTD+69pLZwjtM/EtwlKKImsgkBwo3l3+pz86bFzB4MCmbD5uAT
         s+SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vytsy0IcEmMVO1itDPPXDuj7iE07xYLydZo9z0U7YgI=;
        b=WpIACgwWxc+gLf/kkG9HF7Frf5zooDIPbXhji0cyMCTjX38pbhAbrQBwSPMamsmXpp
         n+3UG6z3ZL7gsCYGrxva30WVW+p6LJROyx6eDhsfEKIsc11chp2GMZv6QrMU+d2n6oP3
         7i80d9IXkEwrumxZKLuBc3eHS3afmQwikSgjJA4BNCXxM5d3d5hN0/1R6UcnvhR5n1f9
         kLZ8hwcqGVmNPMylYTrJSkryaCS2Fks2GdgY6REfP+G0JlCKKZrxWpnF3X9OMi/CGkM9
         LVurn+btP/ncsYIf9/1yfZgnFH3YDfNhC0BEklm/NMj2xVfdOhgvFx5O28Itzo13XkVv
         chXw==
X-Gm-Message-State: AOAM532ud953TKyI8BfHFNz3YaBmagr1RxVZF2lvnJh6dKorxRknkrF2
        8VUYLVnVWNBNTzlVZMei3xhPNq3hooo0ow==
X-Google-Smtp-Source: ABdhPJzFLcY5f6FQhOsNTZ264+HWVWI00gDTZWBpWtQuugZYUKgzCOTkzhpZgpdyJiYBEli2KUrjcA==
X-Received: by 2002:aa7:818a:0:b029:309:a073:51cb with SMTP id g10-20020aa7818a0000b0290309a07351cbmr6988517pfi.40.1626388251557;
        Thu, 15 Jul 2021 15:30:51 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ca16sm6267989pjb.44.2021.07.15.15.30.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jul 2021 15:30:51 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/242] 5.12.18-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210715182551.731989182@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <68dcf9d8-2766-177e-3268-7daa8f9a3347@gmail.com>
Date:   Thu, 15 Jul 2021 15:30:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/15/21 11:36 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.18 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jul 2021 18:21:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
