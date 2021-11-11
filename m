Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E28044DA41
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 17:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhKKQXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 11:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232033AbhKKQXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 11:23:21 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA0EC061766
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 08:20:32 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id k21so7602745ioh.4
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 08:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B0W6G1UOKLiVk/uulG3jqtzFnzz9ZwgwPEbQZHyhcfg=;
        b=QReSc04RD00zcTqdyAeWunQZQRfWnzJkUL762nQwBnDomBSzNH6vpQs35Ilua0kmmp
         9vNJH1ugDashDZ44QsBIBAEZGTjG2QELjkWzhnh3GLPLVRhq2RR4U63VT48Bt3j51HcY
         8H4uBq6xKQ4KaB7TS1zLTX8CoqwT6uY1rFo8c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B0W6G1UOKLiVk/uulG3jqtzFnzz9ZwgwPEbQZHyhcfg=;
        b=ptu1gcpSVu8Ad7QVX2lhotSc4MsD/AAPxLCmxdHiEQyu7YCYncVnO2y3ltRze/3PcW
         3Kx+m4m8zdmlOLj1IWo6XMYrr2v2oKmViopYYIdmfcYht8Qw7Wvsm81vWuLjSt+Wo2kE
         fyySVnPv9bGjx/NzIUt6RHcbx9F719/xhQPQztBpteGZWKgMnRH7dQesB0lgTjO3sL3x
         P0EnL9l8K90wjLw1+dJe+mW3mCZRYGdcfOVsjx1HtjvJG6OaRYfHMFm+DFVctJb8TN9H
         nTxqoEjxE0fbnVyxUFLg1ioKIi2ayJp37FDgBeukPlXSuo6Nnn4P4IUb55H99WWnc/wM
         D6gw==
X-Gm-Message-State: AOAM532NNPe1KjpK3w026+S5VYMjsQmsgH+2x3TazQXw8n86cHz8UHrs
        Ug+wL3a3VVGVCUiOkNGGrDJnHQ==
X-Google-Smtp-Source: ABdhPJwm8KY930iocnfzXrIO6dNfqxVfdG7CQRARwIF1LCsptS+/NB4tMtOpzUyQPF2o+q1iw2Ix+w==
X-Received: by 2002:a02:9609:: with SMTP id c9mr6406487jai.118.1636647631747;
        Thu, 11 Nov 2021 08:20:31 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g11sm2297295ile.30.2021.11.11.08.20.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 08:20:31 -0800 (PST)
Subject: Re: [PATCH 5.10 00/21] 5.10.79-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211110182002.964190708@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <aaa666ca-0b1f-9576-015a-7501aa4ff1d0@linuxfoundation.org>
Date:   Thu, 11 Nov 2021 09:20:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211110182002.964190708@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/10/21 11:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.79 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.79-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system.

dmesg regressions. It took a very long time in trying to start
Journal services and finally timed out. Pervious boot was on
5.14.18-rc1 both boot and shutdown were clean.

> systemd[1]: systemd-journald.service: Failed with result 'timeout'.
> systemd[1]: Failed to start Journal Service.
> systemd[1]: systemd-journald.service: Consumed 3min 490ms CPU time.
> systemd[1]: systemd-journald.service: Scheduled restart job, restart counter is at 6.
> systemd[1]: Stopped Journal Service.
> systemd[1]: systemd-journald.service: Consumed 3min 490ms CPU time.
> systemd[1]: Starting Journal Service...
> systemd-journald[913]: File /run/log/journal/351d6659a0b4490baeff8ad3c4704a35/system.journal corrupted or uncleanly shut down, renaming and replacing.
> systemd[1]: Started Journal Service.


Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
