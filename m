Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56F228DD61
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 11:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgJNJYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 05:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731109AbgJNJU6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 05:20:58 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365F8C002151
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 18:43:41 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id s66so2004226otb.2
        for <stable@vger.kernel.org>; Tue, 13 Oct 2020 18:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tL82F+6RfgjrUZlRR/8HglK3DMbaX5GLDo9+n11tNvc=;
        b=UpqvWPrKLoCqNJQtED0BcS6u2rHPPKE955incSRgD5BIQL0KM4X+HTGFkTp/dEDB2J
         njVm0RZU39UazrYaakrzLdtGUsVhf59aO8MYtTRcKlTbKOE4it7jVtrrY1Aqjr0uDqCv
         bNs0usT0QJo5U6m3w02j9LDzElgtvu4pjN2UU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tL82F+6RfgjrUZlRR/8HglK3DMbaX5GLDo9+n11tNvc=;
        b=KPA4hmm+5T6WGlWJ+YuszRF9q5vuG7EjmnTm/idlPTRat9egZ+4VrkEngAOPQpbcRA
         ETiOrU37MCdzFVT6bPRjuvaBYin5E1X3g7ZveYr4Cax0d0ATA3CPeLv1xzo4O0RpUCrs
         sI9afSuBg4ORuaBfqiGI6Ts48zDSs8tcCBoCWvC8JcrjRhHoGRVlI916pHxJ/i1OTWd1
         jHDugikcH/BeochbSkr04XMkeJbMX7M0gbXVn5vNgrMUAJtokBaoqPMhWxel3hUtyeR3
         J1L1BrwAYfdOFh5kgJWhxN/XK7SArpdSibhmH/rBcn8lUKpJkCYvZ22XB27uFV1GqGnn
         XWfw==
X-Gm-Message-State: AOAM530VNjwYXBigBqtY7VSZ1ReAFOUHNIsDLLxoswIM9LDwaDzpdKCn
        QZACJfEeG5HP2rVPtpLv8GN9CA==
X-Google-Smtp-Source: ABdhPJxt++xCoWN7NJ/Xr8Kh8FEiLJINytfvdn17wmfuC/fj6AwxV6jRVd8ZPALMQWPtAgi0T0ZAiA==
X-Received: by 2002:a05:6830:30a8:: with SMTP id g8mr1800961ots.370.1602639820546;
        Tue, 13 Oct 2020 18:43:40 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id 105sm402780otf.52.2020.10.13.18.43.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2020 18:43:40 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/39] 4.4.239-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20201012132628.130632267@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f400c1b8-bcf9-421b-60ad-b2c7024685d6@linuxfoundation.org>
Date:   Tue, 13 Oct 2020 19:43:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201012132628.130632267@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/12/20 7:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.239 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.239-rc1.gz
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


