Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1379E26249F
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 03:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgIIBpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 21:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgIIBpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 21:45:21 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F756C061573
        for <stable@vger.kernel.org>; Tue,  8 Sep 2020 18:45:21 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id a2so926755otr.11
        for <stable@vger.kernel.org>; Tue, 08 Sep 2020 18:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bpK281isRf5gVgnXwTUWT0hn9s9B4RkkPUa9f71NFqw=;
        b=Gt2KdmKKpZiPG0ag5WURFB2PAY+484m4T+mguV6iGLsOapG3xL8SeLmO6advSguk/7
         TIexQmi+oT4AEKZljrCPbVvYy99DCHd76PYrl/HXPOH1lUYi5phLAwF9J+neHkCJApvt
         nnAyem1cptrnHYekemViSnxAmmyIsFie823tI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bpK281isRf5gVgnXwTUWT0hn9s9B4RkkPUa9f71NFqw=;
        b=eiR0Cu4L5nquAPz45W5znfcdjdRicGY1bcFfParpp+vy+OwnaljliEz4PNbFJzrajR
         9BPQlR98hfZdEl8i9haBjT1t+a0Z+C++HpY4pn/U4BbfDkZr3/diG7NtmZYxsEeVKowc
         1LbhLb4+6f6XLVbK1cvQPFQeHs1J3JSPZ91EvtxLrNlKjwJ7T7DHgN4r4vVqRKZdm78F
         W4bcFSMdqr+lO9baVtZwGjMSsCfiEc3b1cvhSEHS7tFRDP1IXYvpwhsqz35lLkJ1br+S
         8OR3ng/iAwt93KzWNArMClQRkFqES5Jd0cXY5cW0ygCIvWt8qt528P7j5w7P8/OCpXKU
         rJ1A==
X-Gm-Message-State: AOAM531xlWzMj6SRZ0pqxzNa04I+W3yuUWsfkeTo5oAfzKPDtSqYfVWe
        XmPA9ceK4j7IOqu8ZtNQqLNurA==
X-Google-Smtp-Source: ABdhPJwjD03FtbLJKe25UNa5gXAKc0ojHLVlL78dyRhzyTdeqBt5GA6EknB//XJ16qIabfgkNuNCCA==
X-Received: by 2002:a9d:8b8:: with SMTP id 53mr1367208otf.85.1599615920310;
        Tue, 08 Sep 2020 18:45:20 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k19sm179508otb.45.2020.09.08.18.45.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 18:45:19 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/88] 4.19.144-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d20738dc-2fb0-450b-c594-758346d740b9@linuxfoundation.org>
Date:   Tue, 8 Sep 2020 19:45:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/8/20 9:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.144 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.144-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
