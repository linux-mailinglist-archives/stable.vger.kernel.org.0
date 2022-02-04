Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998BF4A9DA4
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 18:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376840AbiBDRd6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 12:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234250AbiBDRd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 12:33:57 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17C2C061714;
        Fri,  4 Feb 2022 09:33:57 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id i30so5682300pfk.8;
        Fri, 04 Feb 2022 09:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GwweWvs7v6mUrsF+avs0ZSyV9XiKyZYwIj1qrBh4nEM=;
        b=G/9LAxwzIHf9FW9ibkwk7z1rBoXlWN9CUCTiYLubxiEbyE2QQupEF2DmoasCut2Akc
         i2XbhJ0Q2KAubqvJXmmYEYm1Nz7/xo7U3hhd+wZvPDsr0LubUefNer521vdF6aZzmR2I
         9+IsO93XvbIqNM0Xq4+yhh13rAKcULHvknFGzzPjOVj7WQZw43fHgnOVds8YtUJ0UH4t
         zmCU44ra9RR1Oz/kQ57zVn8zLsZETw1oydrAbQiqy+LihzcUEnu0jUG2U/dyN1SF3Taz
         JZWJbtwswuB1xv+PpTKx/JnKyJJ+FrVaZQlTx6UYKciZLr78gRw7X4t4iT4r+qZJldW7
         eouA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GwweWvs7v6mUrsF+avs0ZSyV9XiKyZYwIj1qrBh4nEM=;
        b=pbdrLhsvPIXKy/5MwF0Hfs2fS8nkNaO9jQ8E7Qbk2OfFHXUfPQehOPwg4VDW7+RK/U
         A+/G7iZgC125duLm20jxrdCr/roW2K8JmEX7H91tmdr3wn7mlBX+ripZ+2iXXq1xazKB
         J+rwNb9BNspC4y9sMYPc4TQUSQy3jYbkKH6FVHOMXDgxLQ/tNzyycDLAamq3J+qJl/BZ
         Dt9OfCYVYgFWDvCVOvQvumz8O48vxfIjrFg6O8UEmqstyaCy7hHX6B/xT8WvmbLeJtMg
         sMICAa99JFWHZZkSXUCEBKlI4j/9qJbO/tYD0kwd9jkmvX96pHF6+/cO3kDf7SvjO2sH
         IhGQ==
X-Gm-Message-State: AOAM530YDZh4bKQjeaIjnT1VKp1PlIMw6ccQhnuzsKHD3uUpkefKzwD9
        hrFBPWOCrSrNDS6YLQ2Ax9o=
X-Google-Smtp-Source: ABdhPJzWptfhp/KpqAUOFKbPU7CjGJz9pbmEJwWldZolsxf/j2MP396lUPWuM3yYV+SPnOEgnrJiSQ==
X-Received: by 2002:a63:36c8:: with SMTP id d191mr39213pga.377.1643996037233;
        Fri, 04 Feb 2022 09:33:57 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id d4sm3270531pfj.82.2022.02.04.09.33.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 09:33:56 -0800 (PST)
Message-ID: <895b0b85-e1b7-3ce3-ef12-814033d30897@gmail.com>
Date:   Fri, 4 Feb 2022 09:33:44 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.10 00/25] 5.10.97-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220204091914.280602669@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220204091914.280602669@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/4/2022 1:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.97 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.97-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
