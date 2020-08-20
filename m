Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D840024C8EE
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 02:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgHUAAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 20:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgHTX7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 19:59:52 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E061C061350
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 16:51:17 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id u63so103238oie.5
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 16:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bWH45KSsjMDtcB36FJCwfAf8uMmznGsZVuQtNo0KJIE=;
        b=FJhaosUCodFEAJRj3zyKrxXgw2KLeOB71sGFq8MfhnXDSf8Bqgv5tiOEVsVRbdaWtm
         sBtxKlzlUFEfaXZ2k4E8RqXrG4xu21TF6H5bOjCVZKU08xOy07giksduSxkQ9wNaOoEN
         g27quDxW1zmdIxE5kcnTuOinwv1GutFAb+Lfs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bWH45KSsjMDtcB36FJCwfAf8uMmznGsZVuQtNo0KJIE=;
        b=nsdvIZWfGIuUGOMdicVb2ViLelBxSK/KVx4/Lra6d/vtbv/euIL1pvKa5wmVLlDRX1
         UXTaoNFu890sbcyt1XsLPWxgKSlibolEvI2zLgV//YLv5w5oJgfe3YjcdCXyWha8YpuK
         1VTt9N4twBoBs8otX/xFdmYJI2rTdkbDzLMdt4L9qC3j6Fft1feS45fFgUo8gTPjd6PO
         56cfUCCSxX95oWZ9a+HTGU0ZrovOMsesOsgQxRYGVcleGl0xNA/p2tbn8mkKJLtChMYu
         Dtah4y0j42d70t/0sMsHf98+21IZclQbhAsoJ2/45y3gweWaHaWYI/MZOXBvdilKSawJ
         FIZA==
X-Gm-Message-State: AOAM532qvrgOaQ/FXL0pTQsyARj5HnTqRwHl3jmJM0L7XyanVxZKi1fN
        TYrNUI7ZYBwju2sEz6JqFUFw5Q==
X-Google-Smtp-Source: ABdhPJwGsqbYR42hZnuQpFyt9MFGKV1Ti4RcBLS4mOzHG5sgOkbEdSNJY/JGxUJ0lAVPZLAEyJJSXw==
X-Received: by 2002:a05:6808:8e5:: with SMTP id d5mr265149oic.64.1597967476593;
        Thu, 20 Aug 2020 16:51:16 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id o22sm31838ota.49.2020.08.20.16.51.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 16:51:15 -0700 (PDT)
Subject: Re: [PATCH 4.4 000/149] 4.4.233-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <70ff8ddf-810c-6636-2ab8-fd15027f7140@linuxfoundation.org>
Date:   Thu, 20 Aug 2020 17:51:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/20/20 3:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.233 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 09:21:01 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.233-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
>

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah

