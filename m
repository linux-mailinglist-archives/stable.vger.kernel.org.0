Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6171F5C04
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 21:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbgFJTh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 15:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728166AbgFJTh7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 15:37:59 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7310C03E96F
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 12:37:58 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id a3so3201979oid.4
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 12:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qw7mwA33eVi6Ku9Rv3oEh0XhxvWo5n6dAxDv4/ZVn4Q=;
        b=Cl+/Mzk/0SZ3XffJNq32Ne2MCmXxwekCz05Fm7Bm+7CjSaVPVxcMysuVRdv6C0EWDP
         CUQBz+ypmPSZ47o1g8EQveiPFae2ysIw2eXX3xojpL6fd2zPjvbsEvaP3Ag/m1VR4qnP
         Lpo+qYxyrZAJqTh+YQQSLf7sZfyS7a42TjO+A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qw7mwA33eVi6Ku9Rv3oEh0XhxvWo5n6dAxDv4/ZVn4Q=;
        b=tCBGerUsUeN+lMbeg7cRi2R082PjjfOIwJQ12WlOa3Z9wHDT4Mmt9hvEgyEwZZAgs+
         v1KimqRfllSeIqy25Halz/bCT+EsrlO3wJzV9zmdcx9XTmWfdliUKhaSxNhtu9ypFrby
         vc9SBXwtadeL5RbuzCCT4xB9o6fh9yDSqyN7t7OcwQNGId06oNbASjTnluXKWZT23T7C
         GCbuILjsQtDAIwHb2/bWz8qC2+rsO2/uozes+fdB+ntf3O2yqw3lydjDhx/LWPT8w1VD
         RM4PalcOAMfgD1AXjxlCbriYyyxox/SfoyeAJi8tLsJIkzBsdCYLJ732k+iRKYDmh1Gq
         ALfA==
X-Gm-Message-State: AOAM533V5g18uWiZjxSL5ovrcNEMuNQ9VwvddC4FduTIBMYk5jCiw1Ch
        kxS+5L0lbpMlOtmJotetNyIrhUvmRsM=
X-Google-Smtp-Source: ABdhPJzVvS64iuCcJSk72RzaJ30X/jutQHsqxWHMVgIr8ZyLUB7b5a8cG2WaomugGeNTRmgB+YVfhA==
X-Received: by 2002:aca:b155:: with SMTP id a82mr3658802oif.122.1591817878292;
        Wed, 10 Jun 2020 12:37:58 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id d13sm198468otq.46.2020.06.10.12.37.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 12:37:57 -0700 (PDT)
Subject: Re: [PATCH 4.4 00/36] 4.4.227-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20200609190211.793882726@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <d78b5b05-2f40-9152-1752-4a1823d0ab46@linuxfoundation.org>
Date:   Wed, 10 Jun 2020 13:37:56 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200609190211.793882726@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/9/20 1:18 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.227 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jun 2020 19:02:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.227-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

thanks,
-- Shuah
