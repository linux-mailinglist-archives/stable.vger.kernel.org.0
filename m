Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9232675D0
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 00:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725846AbgIKWXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 18:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbgIKWXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 18:23:42 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CA3C061573
        for <stable@vger.kernel.org>; Fri, 11 Sep 2020 15:23:41 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id g96so9619540otb.12
        for <stable@vger.kernel.org>; Fri, 11 Sep 2020 15:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZBzDx2rvg+cg8YKGLKdS/vkc5BkuGkpUbsVWOsoD6uc=;
        b=Rt1ZAzhKNMVfLgicICG6tRUvh5ZAahGK/IIt6nCoTgcJzczO53ti4IAL/yF0URT3bj
         1WXhOi/csK7NjNPEJd7Xx9rtB/QPqEid4vpMjjcWMaGA6XWMWY4qZ/qAvAUXWA5HeZ/1
         TqFM9YCjVHo7iIH5xTwoZLqo2Xk8G4HpDtrsw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZBzDx2rvg+cg8YKGLKdS/vkc5BkuGkpUbsVWOsoD6uc=;
        b=QNMGoJW93qBBS1S4H+zh8DicfjKdE+Bek6XPezbCcBM93/HHmTOpBT+QMLjmGUDhYe
         5sUCUwJx7sdBF8wn/1fWfwqu1g9QzOoZfWjRCHccBEg0PuJ2/6Qgs5pZ6+hxFqIeVsVv
         Vj+d9/jqlinWcKgALufAvt5C9+FQWNJYqDQ4XCiSPmGh5reUj5SUDaMnvuNK02nOBD4S
         7i+BsTTN7J0aGWeyv8LZgBUa8YsRwou8cr+4zP4kl0jmRryNdzZauacYxYro4WxIk0k3
         1y3Y6aw6A1QkvUHnnhe0FDgPq/Kl24VjztOczWMoMd6sL+KgsobjIuL9/IAevLbpa91z
         vCZw==
X-Gm-Message-State: AOAM533PHkmhLVydwx5yd4NJXMIFvPf7u0oW0MyyM4U2EPLbNOFdBItn
        eHuDAn88JTOn1qeHH2Dd2B/f/w==
X-Google-Smtp-Source: ABdhPJx64xR8yOo16vtOvBrsK16dHXjVksq7hKmQwL7iDep8lZxKG47W/0w5FFIw6wZb+Ju6rm0FmA==
X-Received: by 2002:a05:6830:3184:: with SMTP id p4mr2455668ots.26.1599863019463;
        Fri, 11 Sep 2020 15:23:39 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id h14sm567237otr.21.2020.09.11.15.23.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Sep 2020 15:23:38 -0700 (PDT)
Subject: Re: [PATCH 4.19 0/8] 4.19.145-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200911125421.695645838@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <38e71986-f70f-3fb5-6510-e397fc2764e8@linuxfoundation.org>
Date:   Fri, 11 Sep 2020 16:23:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200911125421.695645838@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/11/20 6:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.145 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 13 Sep 2020 12:54:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.145-rc1.gz
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
