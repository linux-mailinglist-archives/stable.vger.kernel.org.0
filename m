Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C05244DA67
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 17:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbhKKQbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 11:31:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234183AbhKKQbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 11:31:13 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E504C061767
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 08:28:24 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id m9so7706164iop.0
        for <stable@vger.kernel.org>; Thu, 11 Nov 2021 08:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4xuNQhveWOi8sSNT5WKsU3XgUMLXeLSD9oDb8jVVHfc=;
        b=DHwAKSThTF3kL9XfPrWqTlsenr0vCK71zsic7Q/T0wlLgVdd7oAtKnOdtSYbBSWbmj
         HBulcYuiUhgfCQSdOwIqnnwwefk3vFH4CMVrKpm8d09PDLekdt54nKOEbHVj+TNTdEZX
         mNEpQQ4q2WWJw/mZj56se7zpQ8+gz5YST1bTw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4xuNQhveWOi8sSNT5WKsU3XgUMLXeLSD9oDb8jVVHfc=;
        b=TNwoZ9F3PGOFb1IABk3PBVBNH49KXeMFS8gt20fKqN69vhptVCsbBLSN+GaRCFdI3o
         hJoyD6S52p8B8wfkfTSgJBWJB8XFSuXtgU4IHWHuV81YH+qVf0sOoGqqvilhDVaFGg56
         56U+Pvn+Uoa6yRdXpKe0m4SegOgO81zQbzH8D5Nx3ik3GMATQGvXDvLBrqUn0oQHitkQ
         pXEAHZ3TeuCWvaQon0RyTwpA1SDsDaY1vgWADzXOuuP+hXTmyf5Nbktmdm9+/v9Zu9VX
         jhl5c1CGfE7u2wUj1a19khLdVrL0DnsTF0e/gKUpuDpY46ffLRg33a4sXvcJpXNG9R3G
         XoFA==
X-Gm-Message-State: AOAM533aNFf7ZONaR1VEOe+TOFRZH18jhltXhboaWc9yetiTj1Vu1LSH
        Rry6XzyW8YKRYg74WsTGhbTOzA==
X-Google-Smtp-Source: ABdhPJw4Octa6XlUL9XrSSp4+hEdLchkQkFTlRKDR53o/F/JhJG3yVKWcOU6ED6B94TdzjdlaVmtew==
X-Received: by 2002:a05:6638:24ca:: with SMTP id y10mr6284180jat.109.1636648103920;
        Thu, 11 Nov 2021 08:28:23 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id g1sm2184590iov.23.2021.11.11.08.28.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Nov 2021 08:28:23 -0800 (PST)
Subject: Re: [PATCH 5.14 00/24] 5.14.18-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211110182003.342919058@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a3ceb6b6-1e20-be80-767d-2e56e9e25123@linuxfoundation.org>
Date:   Thu, 11 Nov 2021 09:28:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211110182003.342919058@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/10/21 11:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.18 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.18-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
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
