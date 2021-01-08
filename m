Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE812EEACE
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 02:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbhAHBNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 20:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729752AbhAHBNp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 20:13:45 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4711C0612F5
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 17:13:05 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id j12so8195400ota.7
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 17:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HpydmE46nbrEno1OiZi2S/y6ek3RrBHv5tLq0z/gnOM=;
        b=Yo2/vitVp4cAG5aeIE4DvzI6zK2W4DEKSI+lh183pQ6jfMiCBxQ14Fmrdmaf0bTtwE
         ica4EICasf04GaYBd3s4KIhy1NHB1XuvEuprn83ehKG5e+jbKCaB/akOhhI1JGUOlHGY
         TGsvwQtnrcIdESaV4unkeB6w51xshkOPRuq08=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HpydmE46nbrEno1OiZi2S/y6ek3RrBHv5tLq0z/gnOM=;
        b=PIOP9yYIOYBWBzWtY8egAT4dggjJLl/JCqg0g5JL0/Ghv2uDEUFgd70nf535SySTEx
         4EoE+bvKJ81+UD5xbBpSvAfbKLEGrChk5SZUp8ZbtUCT4PDhMeMNjT39XE7ppIJSzyFM
         ryoJhr00E/ojj2ehShVBt6o4JmbdR+sHZghiPpBpRDAlwhWiWkMpyqpMvipguW46Q+4F
         d5NpxUChIQ3R6z1zdR4l401YvzV5YX5J6peEKYOv6w9PogUcSZ8ZdAV/1SvXDmiErzTk
         kc/kQ6bWSSxLz5TlcNEh5N2SsaPzZ7Rtk2J4edHK8ME4O+/j+4v2cZeMEnULd2ImdYdM
         owrQ==
X-Gm-Message-State: AOAM531QlJvL47w6TUaPnQkT5mB/V3Jw8AdVJQzKeOQ2wfaiU0PBaJJ1
        hUoHNSmtoU2lyB+uuBHWQTF3lQ==
X-Google-Smtp-Source: ABdhPJw2wL9Wae7HzO3tzkeDh+2fzbZ1C5q44Qgjor+2NVTQPz37GwqnGz1glxmjEJJ7toVVFTbnXw==
X-Received: by 2002:a05:6830:4c3:: with SMTP id s3mr870308otd.235.1610068384664;
        Thu, 07 Jan 2021 17:13:04 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id r10sm1493705oom.2.2021.01.07.17.13.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jan 2021 17:13:04 -0800 (PST)
Subject: Re: [PATCH 4.4 00/20] 4.4.250-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210107143049.179580814@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <6cf301ce-61e1-740a-0bcd-d3452ac8559c@linuxfoundation.org>
Date:   Thu, 7 Jan 2021 18:13:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210107143049.179580814@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/7/21 7:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.250 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.250-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
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
