Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 814282B713A
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 23:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgKQWGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 17:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728726AbgKQWGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 17:06:41 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20165C0617A6
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 14:06:41 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id x18so106637ilq.4
        for <stable@vger.kernel.org>; Tue, 17 Nov 2020 14:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SMxWeh8e5DNkgRIVx+jsEW7I6O9OLAOqcDNVLYpDoac=;
        b=igHDZi4KcaQAWD61z2SFEFRzOEQAY8adDtFSSy/f9H1g/rU++I4h1QgXFB4+RhEtJE
         K921Q8MZE7cPmo1zCsvuEpZxQ2slQEENEIemcTdLUT6/bNNJYV0t1Peixuv+jgtUywjl
         uDnamq4kTGLSKvjAQtJnibdMavbGat3+LYu0o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SMxWeh8e5DNkgRIVx+jsEW7I6O9OLAOqcDNVLYpDoac=;
        b=nfrCTkTiWEa+dfzTJkCEn8vbSdop+dOCOGnFIYgxeLx8Z0gQobzJUz87mUiou62DH6
         RWV1fXp6YqIIBc4bqxSfiePrR3S7uQAAErsdhlaUQwoqnyGU4Dtxi+rx5ww6CIeZ8ez7
         MY+Mb4FnOnsHU0+h2om3Z/s+JnECCmCA5cwEdUTRm3u6He6+FssdSl5rs5AgOEEQqcaS
         OhVLpxBW+X68J4QQksliOCAZlZNCOTn78D3u7/L7s9lyDeBz2HTiIkA3AamjE/ej9prv
         97GjBLbFvHYDHHrCb0MPUhgHSDeQKWUTbYry7Ws85YK7iddkBqDen/MGsrCymQ1VxAFp
         ATPw==
X-Gm-Message-State: AOAM532GNYZEOEMh9bj+kV6jIcFNysC3Ai4U295VrNy41sBfQ4CZyge4
        dYmoZjgxutvlfBDXXBPzQs/IdI39fFldrQ==
X-Google-Smtp-Source: ABdhPJwLcEEPobS8s9JKOlw25TC4euYStZqTnLPoZbxNrwKhrT7an+7GlUXjr0v1+idXItPvtjcGlA==
X-Received: by 2002:a92:40c8:: with SMTP id d69mr14096764ill.66.1605650800471;
        Tue, 17 Nov 2020 14:06:40 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id b15sm14411923ilg.83.2020.11.17.14.06.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 14:06:39 -0800 (PST)
Subject: Re: [PATCH 4.9 00/78] 4.9.244-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20201117122109.116890262@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <46f69429-9c62-cad3-2e8e-bc6f8d0ef8ab@linuxfoundation.org>
Date:   Tue, 17 Nov 2020 15:06:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201117122109.116890262@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/17/20 6:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.244 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Nov 2020 12:20:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.244-rc1.gz
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
