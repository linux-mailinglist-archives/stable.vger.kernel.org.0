Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADAD24C8E1
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 01:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgHTX5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 19:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgHTX4L (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 19:56:11 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2928C061345
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 16:49:05 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id x24so266796otp.3
        for <stable@vger.kernel.org>; Thu, 20 Aug 2020 16:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mnJZDGXI6zXjEF62GaddKutFQulnWj8IVNGC78lZ79U=;
        b=HoGuJETd9azLWHZJlZzmu0v0cRLthoTFA8Tp4H3VoRjT9GCoMfsbUTvQfE90Ncqrd1
         1i0nX7haiTwpkjb7Ao/f1zRVrM1K5i4IwC9r72a3PlWrZ3VSVV7rF+xHX6//bKO4ZyYM
         oSCGYTWHwZf6Pi0yBxoCiVhIixkwYwRTApVJw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mnJZDGXI6zXjEF62GaddKutFQulnWj8IVNGC78lZ79U=;
        b=S7y4W44rSETM9w8yhxkNtM0H+kbecAWCIjbC/f6ob10nHcxAm27W2I9iFDeNfpn6MH
         eUtYApPrrKTY7vXvNyL0UZrXL4yIKfCTCAvrHBPZXUNvqU3QxxITIBe+VAbn2Y1+WbIz
         UDkHDLVM08ZZIKG0M+8yBXo6zK4sM+Maaux8CzLBb1x27kkSE7cPy8SNnAJ8kQKA73hi
         5sOI5WER8adAKBN04nK0ZI8pgB6vr6DG2bdVEaDFcVmBv1XJjd/bz+An1EWgsw+ed9IL
         4CQ2Mn+J88VEEJ/ZCeP+yQB8RvKs8Wr5pO95Nh00A3A+6mrYNXlPOIFJRvWFXqp8zbUx
         vR4w==
X-Gm-Message-State: AOAM5330Xennl8uR7NubMUQ6hWIoNrD/4xCXiJJgQvg0nWejasJ5K9c/
        OycM03jPkaZoOHjbnHIltf49Aw==
X-Google-Smtp-Source: ABdhPJxRJ/FeP0jRFjDaeoUAiGM7TW9cSgqPX9ZiMYmD2RDMMLX2o8oIrgP/YNz/BfAnG4aut5nsjQ==
X-Received: by 2002:a9d:171:: with SMTP id 104mr173955otu.256.1597967344102;
        Thu, 20 Aug 2020 16:49:04 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id y66sm33087otb.37.2020.08.20.16.49.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 16:49:03 -0700 (PDT)
Subject: Re: [PATCH 5.4 000/152] 5.4.60-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <aff708b3-7abc-ba23-746c-4603246b52a6@linuxfoundation.org>
Date:   Thu, 20 Aug 2020 17:49:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/20/20 3:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.60 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.60-rc1.gz
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
