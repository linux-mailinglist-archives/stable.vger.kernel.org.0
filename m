Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFA0D3EDF82
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 23:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhHPVxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 17:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232230AbhHPVxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 17:53:42 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440BBC0613C1
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 14:53:10 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id r6so19031852ilt.13
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 14:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7CIrFtnNaIDsfpDOFOm0ZVbPEF1sRclAJ9nGB5sECM0=;
        b=Bh4VLOHOHVp2Bc5njuRkcmRbFJFFOW7K/rg9l0uQd5UhPzmsA9lhPpUIFRWpo5VzSv
         +pO9nXj/365E4odcZimrwHNARzmfBt6TarK/PR4e/AijJQB8fiJ6jhXI7+95mx6xt+Pb
         +eXsg9wtHJwoNKC80gpofbnTd9FSRsEFQm770=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7CIrFtnNaIDsfpDOFOm0ZVbPEF1sRclAJ9nGB5sECM0=;
        b=ovWYZAI8+rdd5TCVNEh7HZ4e/184LkXyE0mtseECj7OMCgZSUAcyVYK+F1CSI2ZTFd
         by61+oBxb0s/1kgbQ0pwXtCb+5qJjY0jqMu5zSZv2V9Yy4Vl2//vuQhRDLAjTzBBkVGr
         PkcG663MiEEQleCWG67Qk+cAyC2pMfkUsObdVhF/2hxAvcBYn/7aKs96Ev1cTg0I7HIu
         AHxZF5BHuJFZ8VgThfqIQ/BsMO1m/8UT7+Mp6vEgcaxinvtC+0SSBeYhnAYSruOC+02/
         MD9eQbIrjoI7iM1qp4WXSQ9ssZGo4hKPv6GSkjCRGTlOGxv4kKMum8fYJlU4Sp7iy+HF
         QpmA==
X-Gm-Message-State: AOAM531J1ZTwjUXsqbN1b37hkZzJOPBVi0I/4ys+K7fmFc55gp2H8MhS
        dJAXAqPxJ+KR5C1w3FI/M6QftA==
X-Google-Smtp-Source: ABdhPJy/fHwPa3SBSjZ9rmxdn739vjsV2cJLxZ5cgLnintIU521MjBY8Niu6yibxhDcFGWsClifOgw==
X-Received: by 2002:a92:d70f:: with SMTP id m15mr83002iln.162.1629150789723;
        Mon, 16 Aug 2021 14:53:09 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id u14sm88200iol.24.2021.08.16.14.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 14:53:09 -0700 (PDT)
Subject: Re: [PATCH 5.10 00/98] 5.10.60-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210816171400.936235973@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ec6840d8-7e31-ffb4-74ac-bd7c5b1dd8e5@linuxfoundation.org>
Date:   Mon, 16 Aug 2021 15:53:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210816171400.936235973@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/16/21 11:14 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.60 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Aug 2021 17:13:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.60-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
