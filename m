Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA5A4A4FCF
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 21:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377955AbiAaUE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 15:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiAaUE4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 15:04:56 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA7AC061714;
        Mon, 31 Jan 2022 12:04:56 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id v3so13268295pgc.1;
        Mon, 31 Jan 2022 12:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=1mSllUnOW4LcLF/WFUis2RlwIFI7IUg/uQnNfEXGl3U=;
        b=Nm07KSh7C9U30wfQlTnD2b7nYbh1kzuwDf08x3rIUB0kS+t0kCBPOABUZu6wDrfV6M
         OdwZb3d+/V8maCI2Ka4xb1i5zKTiTweU9XcS3JgcXz7qKVM90Ca/eOuQqcy2aLQNtlkJ
         bfiQwq8NYwbRBcyIAZ+vLNCnreYFf5cBIUkGibLjiP9oIqiabv9qNzq5MXAP7/onzF1H
         UeEty33P7YlEqP/c1u8cof1QKlufMXiN0bCqX6qvGdEGger1ORA5d5TSzgPHeVef7Ca7
         CqlnbtfEm3W1GwbwfRid+X76SlSl4FjR94jqf9/umwhogOjKv1F0BDiVipH6x07nRwmi
         WTUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1mSllUnOW4LcLF/WFUis2RlwIFI7IUg/uQnNfEXGl3U=;
        b=O6F1WiHSBOe3l6jCDtcO612EB9zD2d2YK5HAq5+FXB84FaScgnJBw0CAZebloGngyL
         e3W4pPHjR77SbSQNUY76bHDB6dvEHDETKrglkMZOM/qj04v3WHX/V7Xfmr/TSof3EIrc
         M/x28ACy0iE3eSXLbY6icnHA92VDLXqOvROaOQyD+82KoiJjV6wem678KOj+0H6Lc4ea
         SMLsTDNo9qnY5kPBjnjpolxOg2mz6BnAQyV4ndKhP6aFJggiZ/G8TfmyXhfipK0AdQX3
         vEQoGa3V7taMCuXo2rxRnPVkHJcbUdrXaohnMekE9wlCLqxYpz9M+/gWZHTnZ33U0/Yw
         8VMA==
X-Gm-Message-State: AOAM530YUA8wsG/dqVTXVWwcf0zjnF0g3beOPQdTZbk2oVbrdDs23yyi
        jp/lvYrFbh1qo9WtKHlsxYQ=
X-Google-Smtp-Source: ABdhPJxWl5YExMRAfLoIziUpVjs/aPD23RbCsr0zz4O2l7HlSB6bAg6vfUwhlw/BUZoP7og4OlIhwg==
X-Received: by 2002:a63:6c84:: with SMTP id h126mr1715557pgc.456.1643659495665;
        Mon, 31 Jan 2022 12:04:55 -0800 (PST)
Received: from [10.230.4.36] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id j10sm19503269pfu.93.2022.01.31.12.04.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 12:04:55 -0800 (PST)
Message-ID: <88677e0b-6580-4118-71c6-820bb618ead2@gmail.com>
Date:   Mon, 31 Jan 2022 12:04:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 5.10 000/100] 5.10.96-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com
References: <20220131105220.424085452@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/31/2022 2:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.96 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.96-rc1.gz
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
