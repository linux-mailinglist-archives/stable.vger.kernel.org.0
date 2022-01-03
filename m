Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45A8A483694
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 19:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbiACSHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 13:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbiACSHz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 13:07:55 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B46CC061761;
        Mon,  3 Jan 2022 10:07:55 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id x194so7446222pgx.4;
        Mon, 03 Jan 2022 10:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kOy+sT+L4gcJgf1UeMhwqUCWpARH297mZ/gQC9UmtJ4=;
        b=EVHEf6XDGcuhT1g0jBoFhq2juZQOAStwkovp3UtYTe9kVR2DeIe1ifxmt0UFGRYK0L
         oYBAxA/KafUAtRWF5QiPJz8Ef1MvAaOqIZ2wHeBrjc2ZOX+uREMlbsSZiZ4+Vbv/PU4X
         NfICM6frlYVT9t6KVv3qs/RdTvlqIaD/gdWX0yQRfLbMsM60k+HVWRLoie00aHYIHulp
         EtWWqrOfD6tOKxTgcP15kZKh2zKGXC7Dl5Eo19LCj0hSrMLpJgAweTbPYwjKl6zAzo3T
         HZeplhP3lw+ZC5Kid8TvOtohGnP1fCEzeclyqZzvkzrVEDs4/wIIlLP56wnasE/i8q2I
         59xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kOy+sT+L4gcJgf1UeMhwqUCWpARH297mZ/gQC9UmtJ4=;
        b=CFE4dBxZFoRrqEx6Dks5jxd8lEN+TTvruekdwKDhjzI5oHIDugVkMnwh80dHfY9sVX
         vvAHmjI81gVOuMVSgbEh6/D6aydmek528OjWidUH/xHjz9qFQ/XJs7YBdTbatwg/+VrF
         t+Ao/celqTniXphhW2PvpVO2LqskI4ZW+12p86K7jNmFCxJlBIurtJfTgwAFa5OHxklV
         j3s2ouKfRrftj3c5cLoocpKN2WuploxHB1HreXPs/aFdRRB7kTJDp2dPAenb1ihNZ+Ly
         1LXiqM+ifrtRoKZBu0Ayovb7oZjL9bIXyEkt5Wbz61+BZN+V47hKHfZuh+/aQnMQtEF9
         ug1g==
X-Gm-Message-State: AOAM5314We50beZrNc4KuEbPKku+fvIKeITXu2+kA3vp079V3GyTEPbD
        ODXjtCHVWakTZYAwzX69hno=
X-Google-Smtp-Source: ABdhPJzcmCcKXSA4Z24FaQsYLyK2gAJIfhgZxGyxNZiy3XOAFqSl8J1Wm/KN0Ebhphaq33YHHUefBg==
X-Received: by 2002:a63:6707:: with SMTP id b7mr41656351pgc.588.1641233274514;
        Mon, 03 Jan 2022 10:07:54 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id nu18sm42205728pjb.15.2022.01.03.10.07.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 10:07:54 -0800 (PST)
Message-ID: <8acad1d0-041e-9208-9b46-fe5718e6e4de@gmail.com>
Date:   Mon, 3 Jan 2022 10:07:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH 4.9 00/13] 4.9.296-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20220103142051.979780231@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220103142051.979780231@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/3/2022 6:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.296 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.296-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
