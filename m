Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A9B3AA711
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 00:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhFPW46 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 18:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbhFPW46 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 18:56:58 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5ECC061574;
        Wed, 16 Jun 2021 15:54:51 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ei4so2644922pjb.3;
        Wed, 16 Jun 2021 15:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JBtUVTCa78ihNc/bCTxiOwk3vf7if/kPJeJC3e2mx7Y=;
        b=q8Ce5FHdkLdpsiby0G+NTkpp0sBg0rROZ7wfV80+YzKqwhrBav2LGyz6B/uHA3z2nq
         Oyki8YhzOywlLoovNbEW2dMA62iec0rRuAkGSsGn4GEM8r621CaBHx2fcAl0JHmfEvJ6
         UrX/VESLiHolZoLf5PUaoxWHXr0mO6ky39NFItuztM/E5uqzjCn0PMhTeipAHvpiXGOo
         jmMeWe6MjB8YH0YYmJ470tVcxbaJxXAtAJJWn9tS717wLHwAxsQfH/C3IEUlxwRJuBhI
         RVcqwGA4ewLTiqEBsK1kIsNmqZx/n9c7BB0LxpRMhu42H+PXcvst1S2oh4eWhfAJl2G/
         IxXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JBtUVTCa78ihNc/bCTxiOwk3vf7if/kPJeJC3e2mx7Y=;
        b=PjF5Dc9TuF+jE1afX5Vn+fP6i617oBe5guHvr4V7T4OYGpJwJQa/aztHkRQ/sTFvIf
         F6FE+4cC5wW1q0IWsTtBYxCISs1R0fiYMrNqdV63AgVjVJrSY2xf342jrwmUJzVeF90d
         R6IXf4nFI/xfMx47HRiaGolMXyMQoiv+9CPpXXRUGt8aWo/6XjWGsf3rqC2S4HCKSKUF
         ++EWYQFD/RpThbuMhc5I8nSjNKgVjYCQMTj5tA7uRpEedSceB9PB2QIVbc72tI/5j2/B
         POGwZX0iIbN5CSdorqTWtU70TCgBsMgUOzb7NiIBsrzY+1/3jNXCoVMD/MRyDZ3QqeDH
         9lwQ==
X-Gm-Message-State: AOAM531XDMsXk2GbBpc33ZCiPLJs0lbpI4zXBvnlwL+R9ObLaih/f7gH
        dtj7SRrIzUwby4TWLrPLhUASnLAOsyY=
X-Google-Smtp-Source: ABdhPJwLTmvBwJ7rO3VHtbf17SCfAtpVAwuHdUYq6zzsrEiEYVzRxLIfjB7JaTVyMLbAJbK2/zeB6w==
X-Received: by 2002:a17:902:d211:b029:110:a94c:74b3 with SMTP id t17-20020a170902d211b0290110a94c74b3mr1735684ply.54.1623884090886;
        Wed, 16 Jun 2021 15:54:50 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id d3sm3203046pfn.141.2021.06.16.15.54.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 15:54:50 -0700 (PDT)
Subject: Re: [PATCH 5.12 00/48] 5.12.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210616152836.655643420@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <119e9355-c48d-4716-f1b4-68dcd5ed1dd6@gmail.com>
Date:   Wed, 16 Jun 2021 15:54:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/16/2021 8:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.12 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 18 Jun 2021 15:28:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
