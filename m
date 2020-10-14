Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8806D28DCE2
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 11:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388206AbgJNJU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 05:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730887AbgJNJUm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 05:20:42 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401D1C00214E
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 18:39:57 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id 32so1992616otm.3
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 18:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=InJlbJBQqXUR1oQj//MwzYufQPHMfh3uXTDyt2f2iPE=;
        b=QdLyM8Y9kzCzQMAnhirRhrBkGaHPWIuNuB7mMAZjtNIruKFLJv+gHCwX1m0hZQ6chb
         gdDA9tBvnR6/lKYCKKkfi9+hZ9ZyY8zHPSBJktNp4as9GoMP2XnzfGenRtU7Zf35gcAI
         HHEo0TVqviF3CsLG+idkZxMV04M+klp0mn718=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=InJlbJBQqXUR1oQj//MwzYufQPHMfh3uXTDyt2f2iPE=;
        b=pddc3JAUEHGVk9O2oxYlbpuA0NAzB9J59kgYQ9yxxQvsRtrTFJIb2ZtNCeHl9Qh1IY
         bHoVlIWAg2oFwr2ZqKIYjkREfYSrrxX0ow/i6UMCBUaXmTn+UfWwgv1cZg3FTAtpyft+
         hbkttMtcoa87dKZI6tALXguqwq+6zs714fU1yUhZhdyGtYLZYfdzN+eSeA/ZzDd1c46E
         9ldHAsZfLQJ5QEQEM3QpArrXBeztViunvI6c/LSQqFvcRbmqoSh8OlB/vLp20Pb2HeUd
         kzGCSqDGniWfYy+6iw5Qt6mXxkHB52AGQM60XWWo9l900V0mI44zO4kxab4imDXxorcn
         rQdQ==
X-Gm-Message-State: AOAM531/Qq52dPQWaEkp6b7xDTMJgel9ngwJcDNCTubcjxYyTVi9W/I9
        gl2Ar/RUMwwVxkPOKqhtrzDU9w==
X-Google-Smtp-Source: ABdhPJwvNWhRi5/MWd++5EqpBUb6BJMpOOl4ZZs6SPSlaB2Wrs0JujJHlz5wQnyC7i7we2qIgpMq2g==
X-Received: by 2002:a05:6830:1303:: with SMTP id p3mr1835907otq.282.1602639596657;
        Tue, 13 Oct 2020 18:39:56 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id l62sm660451oif.18.2020.10.13.18.39.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 18:39:56 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/54] 4.9.239-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20201012132629.585664421@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <db4da98b-793b-81d1-f246-4fc0c5d0f9c2@linuxfoundation.org>
Date:   Tue, 13 Oct 2020 19:39:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/12/20 7:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.239 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.239-rc1.gz
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


