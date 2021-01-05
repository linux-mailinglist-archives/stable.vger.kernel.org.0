Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E004C2EB052
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 17:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbhAEQkW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 11:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728156AbhAEQkW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 11:40:22 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB07C061793
        for <stable@vger.kernel.org>; Tue,  5 Jan 2021 08:39:41 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id q1so243136ilt.6
        for <stable@vger.kernel.org>; Tue, 05 Jan 2021 08:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4gYM6g13cZog+mgiG4FjGwUq7xLmy3Je4+qBJIyQZDI=;
        b=gCOSxoPicXJC6YTXpTRutL4C4IAG+KLXhLjpjzWbIr5+ZMLF70D/mBoxeAcf4qEHR+
         gnuZvbiMwFOlKukFmTgZaZuNakUmufbp8lV84XyBXzwdgOnCx8/0bb/HDe3vmnEKpobL
         J7T3lQbVbqX85o8IjzcwCaG7+SPQ6OHL8rcd0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4gYM6g13cZog+mgiG4FjGwUq7xLmy3Je4+qBJIyQZDI=;
        b=XRWdok/4wHxNWRTZ1o1cfekCZg2kJZLMrW600E5rY9kyR8VISi9wcDH9sZ716u5da3
         glq2S3Jnp7WWAnR3J6NCaNfdslxH1G/SJVHAGrmY3A+lnzc++licwGL/VJI6rS6dxgbz
         m55DtxjAX6rdlTU4hKFYYt4rXJdapR/O5ZKYBvHrgA6ue9Nne1kybY2G52P1kwWXH6ks
         68EIJ+Gb0M8ASLATPW08kIJO/URxVGWbprB2JfXqCzAmDwoEM3N8Vht0aOonuSqEWIyg
         sSp7pNfrGlzJvkFxepqQRhTFjKCa7kwYCidFPjn3earP1z90ASMva+fSbWN1Xtj7uAey
         sjGw==
X-Gm-Message-State: AOAM530a34BcRjhy9lHwircNBpP4sohoKbyULFeUAdnJdU3ftQebVkOw
        rDKWZdVhDW8mD3O5vGeSbriImw==
X-Google-Smtp-Source: ABdhPJwJ1TIn8cKZWNOmzrhMfDdbW6MogFY3P6KSgqiYScCNz7JMmUlIs1LG+s95Sn98uTMz8VN4PA==
X-Received: by 2002:a05:6e02:791:: with SMTP id q17mr476042ils.190.1609864781071;
        Tue, 05 Jan 2021 08:39:41 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 143sm69300ila.4.2021.01.05.08.39.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jan 2021 08:39:40 -0800 (PST)
Subject: Re: [PATCH 5.4 00/47] 5.4.87-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20210104155705.740576914@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <72b03c46-d37c-3a2c-710e-470a49d83c8b@linuxfoundation.org>
Date:   Tue, 5 Jan 2021 09:39:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/4/21 8:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.87 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Jan 2021 15:56:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.87-rc1.gz
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

