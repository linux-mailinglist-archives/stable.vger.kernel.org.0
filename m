Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 729CF24C8E2
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 01:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgHTX5o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 19:57:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbgHTX4J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 19:56:09 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DA35C06134F
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 16:50:46 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id n128so120297oif.0
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 16:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vTURMoPYRKEhRabwzbby4L0vZjRVRN5hzWu4YQjs3QQ=;
        b=co7VQZAt/z6lz3q9qMAU9jN4pgo/0qnIxC1u5TjcCzWwOdKDEl1uhRvC/3Uar501Jm
         lbLXThUTTvoeAwTGomftu1/kMB0SLkfevuBrTVCVrWfPKvN0iNi0YITtGoJpETSxtbkU
         Gw28H/6UORkqKy5OLVKy2wTreoQOmWQroqBxI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vTURMoPYRKEhRabwzbby4L0vZjRVRN5hzWu4YQjs3QQ=;
        b=jpDEmi4m7VpxD2cqg0r1pzpqfIA1OFBC6hROE3LXunAaFjBhPe4H+wZC/aX5Mc2Cbm
         vzoKQW7VQVfGOpVJBYnMzkPaJtLVQfGrOzNFi5/j06FiW0UBVtASdNTkPpq2Q2N4ZyKS
         AtE28m8yA97vxKYTjNl757mg2w83cz1wnF7410u7ymBi//q+eaQxIi4ZBUBtDgrmh6GC
         So3qvEweOdHFOLCyaGlA0fabVpqGI09RXlkCiwM7nKtd7ylTXmavgMMcHXfl1uktHuyJ
         9EbmbrDnsI2h/aJpCv9S/1rEO7uVxLfND3CWoZyBnY/8t7HvVB8JeHuhrMhK5dN0p+k/
         8sYA==
X-Gm-Message-State: AOAM530B6amzxa780IdPpeHLtGuQfv4nz94uHw4/MlX0A67kulOdXYbk
        6+ffI4S9yJJXUqKZssSrY9IHqg==
X-Google-Smtp-Source: ABdhPJzKdM35MbRce3CRCIbSdBC1voTjsnxHyYkR0m71G0GhjGjKgbw3NNmnIf8Fh1ImXs+BxAcQMQ==
X-Received: by 2002:a54:4f1a:: with SMTP id e26mr238535oiy.171.1597967446073;
        Thu, 20 Aug 2020 16:50:46 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k4sm36477otr.14.2020.08.20.16.50.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 16:50:45 -0700 (PDT)
Subject: Re: [PATCH 4.9 000/212] 4.9.233-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <96e6b82a-1711-d963-d382-5dc816b4b4ab@linuxfoundation.org>
Date:   Thu, 20 Aug 2020 17:50:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/20/20 3:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.233 release.
> There are 212 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.233-rc1.gz
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

