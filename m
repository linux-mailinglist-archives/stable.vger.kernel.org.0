Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1F5329428
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 22:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234988AbhCAVtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 16:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237980AbhCAVqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 16:46:36 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE77C06178C
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 13:45:56 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id u8so19421852ior.13
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 13:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=foYQv/l8h3Pxdd58QVRj6n8oxvA/TYgNyXI2JEnMceE=;
        b=ZSl2EXLNv882UZ4Gv8lMv0HNKO6yIIdRSbz+jp7xJnw/hbe40jPXbpI2S9s5uBdG1B
         MLX49BQtyNn4TlMN8rwb4LYK9nWMyn3zMQf0EHZwbcID8jkak4VFwIlgz5s3lHaHRRXe
         480JK1fxh2tCsqgL2a1+WdbzuBnbrL8oYj3GU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=foYQv/l8h3Pxdd58QVRj6n8oxvA/TYgNyXI2JEnMceE=;
        b=Uin3UQjikIXXuFt7uMbXReCfcMFbtOZ3x7kW9+ekpFtakWivnKuNkSfGzyYhA8L+qb
         cQLC9nUmWuGPs0vCPVMeDJ+GrAnULFXACVdIkZOEceITnDVSCyBozOp/Oh/4B5vEgDSc
         bPgNWGc5hkLsYA3GB7eF93HeGJINjrCN2lCSbBEG89Tk2Kw6PNfcgK999YGXzmv7mf6J
         i+z1D7EbU1Xle/NA7mfmpyjphN/21m9YXtMrND9xtcDDIWHtTJT/MPIyzym0UVFI90BA
         cPGZh1YQCzQqzhfGK/iR/9IbHW5bquhahHO6x0FnvLidgR/rSmvDxmV7P564flTZDaRZ
         QV8Q==
X-Gm-Message-State: AOAM5333nTgUcDxuAaSzB5QxMX63suYTCDK0Gw/gAasK7qz2bTnv4KiN
        TOo1cWRzKd6j89xDJKNMqCEMgA==
X-Google-Smtp-Source: ABdhPJy2WaFcZIcnys0b64fiUzWD5ZMjcVRM/PieSLz5M6RG5ZQZpP/UzXJGiGNcGt+dC9/fLTtaPA==
X-Received: by 2002:a05:6602:2486:: with SMTP id g6mr15329461ioe.134.1614635155825;
        Mon, 01 Mar 2021 13:45:55 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k23sm10778531ior.12.2021.03.01.13.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Mar 2021 13:45:55 -0800 (PST)
Subject: Re: [PATCH 4.4 00/93] 4.4.259-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0c3cef57-e9ba-40fe-f002-d74bcb07984f@linuxfoundation.org>
Date:   Mon, 1 Mar 2021 14:45:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/1/21 9:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.259 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Mar 2021 16:09:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.259-rc1.gz
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
