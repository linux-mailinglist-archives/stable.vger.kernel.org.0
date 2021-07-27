Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F623D6B1E
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 02:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbhGZX4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 19:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234193AbhGZX4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 19:56:21 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897DBC061757
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 17:36:49 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id c2-20020a0568303482b029048bcf4c6bd9so10443476otu.8
        for <stable@vger.kernel.org>; Mon, 26 Jul 2021 17:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MnfUJHksOhHrUR4OzOMW3hWEu649YzD2jTIICKMt5sQ=;
        b=iV6A7lnpOdoCkH4bF2cs2IBlbktKjllJ5l+aU1yNjdDQdswAPo4jpAYCUW9lfTIq72
         28L9pXqVlW83XhqadlQjR8l7nBnJ64HVWG85aF1LOvbC9ySzNZkbKZyxx/KXfYTF7UOD
         v/6cWQDWcrUTRxRkFcN/vz2Gxht+TCrNFzLpY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MnfUJHksOhHrUR4OzOMW3hWEu649YzD2jTIICKMt5sQ=;
        b=YV9rGvJw6WRzxj+wvFu/xZkmC435VojA4AGdmTc8/7o0TQfIHRZjS8enNZ7X8M4Qr9
         IcH4O36U7ZyqYcYd9ZWLmQRCNKefNoI5miKndM6XASIjBbmUR1ObSLzNuNp0WhtqWbel
         oLbfq4do3qww0NYBrmOKyKootYKIlXzXEao+IvF+fTXaoAzx/Jp5GCOnwR3xYzIvfkfi
         1zfUHx6W0Cwhj5wvD1vX5TTQHgR80nVzyubyUMAonu8ZeZGdWO6Gnh4PCALxy0mdSq8n
         jfbCtWcsG26F+62RcNW+ocb7GIZU0/a0H/nirYDF0mLgVg+crP9kAhH9zCVWLff96iDA
         pm1g==
X-Gm-Message-State: AOAM531XkD+TYrpyJjp7WMKS9ZH4d2hqfFpEKPqdvyneF4GGz2E+iM3W
        FNTWjPZ8aDIx97N0q4tE5YmWOg==
X-Google-Smtp-Source: ABdhPJy0VTIyUADZKpT/SzGXvk0UX3vIraW1PwQRzICgZAhChGVUVcZ9wUPo42CrETT+LCCqyqXDwg==
X-Received: by 2002:a9d:3e06:: with SMTP id a6mr13778092otd.50.1627346208873;
        Mon, 26 Jul 2021 17:36:48 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x14sm323672oiv.4.2021.07.26.17.36.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 17:36:48 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/60] 4.9.277-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210726153824.868160836@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <4b21c15d-7689-4f4e-ab3b-829b3279ebab@linuxfoundation.org>
Date:   Mon, 26 Jul 2021 18:36:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210726153824.868160836@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/21 9:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.277 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.277-rc1.gz
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
