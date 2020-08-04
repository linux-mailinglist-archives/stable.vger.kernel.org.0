Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146D123C0B2
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 22:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgHDUVe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 16:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgHDUVd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Aug 2020 16:21:33 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4EFC061756
        for <stable@vger.kernel.org>; Tue,  4 Aug 2020 13:21:33 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id l204so8747822oib.3
        for <stable@vger.kernel.org>; Tue, 04 Aug 2020 13:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p6aJjp2qwX9qzaME2ZzUSooW3XI7kCVJYMRCSmKVaKE=;
        b=gasbSYx0Bh+N0bu6QixSfOcMWVOI5WJPNSXFO4/paUMTOvKjVBgHgcVAdoX6y5aEGE
         3p/Na1k11+wAzoOLyBmMVuSKroxR//bs4WHIFQaAWyZLuPs+lycHlFZ6MTHhIuRbk463
         HyY+0RTVbSXSEUybHhDPPcszZGzPGqrByHcbA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p6aJjp2qwX9qzaME2ZzUSooW3XI7kCVJYMRCSmKVaKE=;
        b=AMK4+SBQq3jvakTxBZA64ncbka0MnX6lSPIKML5oOv/GGuoPUSONKZSKtKLQolBOoV
         I6TlDUuo6oHWUb82T3FH+P7revyAjalig4CHxuOITnSCggsUZA3aBi6w/EaA5evn+w1k
         dPghL+3L3bFd3bO8Pliwtt0xs/hUDTt2N4pV/9idoNLL4sXF3sGhRsnmpNMSPeFVHhVh
         P5p3ELfds2XvsWd6G3rdA1Z7MHD3WSh99yZnsv2R6RjTfqgxwXwij4pR5pV2aOhkXQCs
         trId5XCccYzdL+bhBk0lZ85Y1w9AfIEYbb5raRmJCIaKYlRaskb/pz6lD4skwT0pbQAW
         VL1Q==
X-Gm-Message-State: AOAM532NWCgzvmo3z5lKIbrUysMW4kTBukgEBX5pgkVotgDk6g1WiKTX
        5SxAHm6r2xdf9pB0ndhM01WBxhTJzzU=
X-Google-Smtp-Source: ABdhPJy+sldgfYbBIL2+o8GACk6j3smlqXK1I76rGan+9LOPt/UQ802RqnCvYXOC8Y9feI19zBZ1uw==
X-Received: by 2002:a05:6808:256:: with SMTP id m22mr87151oie.103.1596572492788;
        Tue, 04 Aug 2020 13:21:32 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id u20sm576273ots.0.2020.08.04.13.21.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 13:21:32 -0700 (PDT)
Subject: Re: [PATCH 5.7 000/116] 5.7.13-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, skhan@linuxfoundation.org
References: <20200804085233.484875373@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <5770087e-992e-39ac-61c1-5fc23fdee22f@linuxfoundation.org>
Date:   Tue, 4 Aug 2020 14:21:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200804085233.484875373@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/4/20 2:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.13 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Aug 2020 08:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.13-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.7.y
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
