Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDB736BC4D
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 01:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235298AbhDZXqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 19:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234929AbhDZXqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 19:46:47 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78597C061760
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 16:46:04 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id e186so4735166iof.7
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 16:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aeFXEQA1OpO2ZkSlsw4q2VLn498e4QOy+9AcANmjbzg=;
        b=XnYuOHtQOQmX1ztPes9lmziQQ/Q+ik/hngtsucKh1eBIBJhj2XMF8+0Edsb+/H/0Qf
         FcbOLiAOkPv95Ih/k+SrchNn4BVZ7lUWUWiy8dRVGrBDxmvYgoZxsOZtPoYcwVmylrIQ
         DOijOJQBc8lRUUWHwNKyy04obt7OWZb5Q40EA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aeFXEQA1OpO2ZkSlsw4q2VLn498e4QOy+9AcANmjbzg=;
        b=LAV/ENPOf18V9dIDM+GWhDQNicGgSkC+9rlZhs1+UAY3qHTo3njz90iZrSLYaPds5P
         p9i3cdcTkzSMq4H0YIXQ2BU9g60rxBKIc7P0TI8OQtkwFlO8OLTrYvv40yAZJB9RuUEA
         3m0YQzeIWe2WObw3sE8nWecMl1qR4JbyVpmDX9ElgyLzqD2qXExA2eMIAYIJ1GfPSkGJ
         vxiTTzQ5VMwQvusoW+o9HDt8CgrwCWcYBIT0IFmmURw0njm4Mj9Bw5fNsUHMRjLhy/f2
         /XXy9JguLRI1pcfILDBIO1Na8tlVEQmxBTT0oMKAh9x5fdrsyxoskqLuX+itdp5bBK/P
         c/Dw==
X-Gm-Message-State: AOAM533Wp0v/4SmnQuRI3gXQWIYHsoJYlzHtdpsBWANWAbtS4oD/U/xr
        bIhfel6xObqwtXjuOEKwudWeXw==
X-Google-Smtp-Source: ABdhPJxMekIED+uhIqW300/rZH7aS4Aut/ISFFQUrRnLNY34t3eNwpX5XHeDjalc8EXTjMYsvB9Z7w==
X-Received: by 2002:a5d:9742:: with SMTP id c2mr16627406ioo.58.1619480763532;
        Mon, 26 Apr 2021 16:46:03 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 12sm601980ill.72.2021.04.26.16.46.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 16:46:03 -0700 (PDT)
Subject: Re: [PATCH 5.11 00/41] 5.11.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210426072819.666570770@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ec54055b-650d-a516-818d-d29e4c0d011b@linuxfoundation.org>
Date:   Mon, 26 Apr 2021 17:46:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210426072819.666570770@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/21 1:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.17 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Apr 2021 07:28:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
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

