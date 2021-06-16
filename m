Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DCA3AA6A5
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 00:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbhFPWjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 18:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbhFPWjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 18:39:12 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141B5C061574;
        Wed, 16 Jun 2021 15:37:05 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id a127so3356676pfa.10;
        Wed, 16 Jun 2021 15:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hZUzX7L+X8248IlqznGd/tGj9uvSGrTKFNzxv8fT7v4=;
        b=uWD58+kXcCorcFIJvp/XB11u52btkCWGMq9OvS8jrgvJGvpnRtBR7WsOx8tvdQI+yt
         mwszJye5FqVV75EVJFpfXytDh4ayFrk/EpAbc3GOLEKCLG3SKa2b0090iXxX1mppfCDH
         uP7A0FU6bqaDKy7aYCBjmXHccFssAlwTGh5CiXgm6FZEquv2eJw/tDJ8oH8syHWhx2Ra
         5UyMO4WZ1lXvfg4R1aNRsnpFyMDCVMMi/m1jfe7NFSqLJwpokbFeKepyzX1du1463APD
         z9rPi1z1D7fEcq28Wv6HZr17Cm0bw1CHpBJHfCw1WeqZ9+L2pqCaP5BukhzCEM2T1L7O
         Xieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hZUzX7L+X8248IlqznGd/tGj9uvSGrTKFNzxv8fT7v4=;
        b=OFNrq5jJTLjgx0RuY5i7ra6RjEuVnJFZR4qZjLUh6k7w5dtJo+zMaYVsy8x7HcZmse
         TR66K9+mNDTP8A3OwFWqsN1L7Ofyu485yIW1bprTdsyC0r65ZsVNY2AjUqwgUh0OSa7H
         DDMLs4HjW8bB1EgqJNIhT6KXb4PY2KSP7xUNZ3mA2KY8XBQpMc5gl7gGKI6zSGsc+K50
         x0IBAAZCQQ7Gx9wZiQNB54+gMzNibfKX6tOC8WOcXtEEQbjepvlOXa/Fu6Mm4ey399/l
         XJYymeoUQkOBItobBUm3BTSuujZ+YvgnBxyyfLYce+uz8/CteDvfDY66gpRGgEyu+dvz
         Q/5g==
X-Gm-Message-State: AOAM533CSyn++MA7edJU6uxWA2ow4jg6Sk0yEk0I+PzDjKDssZXcqBWc
        ErHiqafFLkqkSC9Z8qU4KbaKUQaQKrs=
X-Google-Smtp-Source: ABdhPJx1RHv7iG2OpFQWGaKlro7Z055KSnatoOw5+14P2ww8WukBHsdC+WEesi4LP2+xRC/LF1zsrw==
X-Received: by 2002:a63:5f46:: with SMTP id t67mr1890134pgb.37.1623883024131;
        Wed, 16 Jun 2021 15:37:04 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id p14sm3446454pgb.2.2021.06.16.15.37.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 15:37:03 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/28] 5.4.127-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210616152834.149064097@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e679a33c-fd45-df52-fc57-c4be4675d187@gmail.com>
Date:   Wed, 16 Jun 2021 15:37:01 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210616152834.149064097@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/16/2021 8:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.127 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 18 Jun 2021 15:28:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.127-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
