Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7932D344E05
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 19:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhCVSCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 14:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbhCVSCE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Mar 2021 14:02:04 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A43C061574;
        Mon, 22 Mar 2021 11:02:03 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id h25so9128128pgm.3;
        Mon, 22 Mar 2021 11:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6n8LQDiEpWfSi3CrR6UldqapfBm+HvBgVi4dTHd5tBc=;
        b=mFTl2fa+mhkuhIeZvfP2OVx1IX8MmqovM9xsY/zKl6JmFxs/61Qx8YUSy3tHb269GY
         e4F03HoXaL/n1hwJZw+/0T8SXprUJbobgQ/nNE7qQiL0141673FEo9xlxdWgGVjazEiW
         KOiUGUoJT42vPI4cxCFt3OQefxfQhLjscFL6xnqJOEANkYe/Qpi23ZCKg5S3+djJ4gBD
         3XFrf9401Vvew2A3Z+qrYttCNv76YifgBSHuqYyjEuJYtkb/5j5JLIEOFdntTF+M1M0b
         C9SFl+n0t4PuFduivplJkuAqIDKL/aT0B6vpv83tg/w1qeVFrabNCs8I+T1dHvCJLl8C
         wrfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6n8LQDiEpWfSi3CrR6UldqapfBm+HvBgVi4dTHd5tBc=;
        b=tFEH2s2DsDkNOqkXS8KdImNhNr98UxVgBd7Ru/QNWBnEg3XRDDpjX+a5tSQT9ozhk8
         +4dSg/wFAnBiZ7s8QB9Zrz/Mt4RMt2J3HBz3i5KOPVM2lzfUrae658zf8rwhA/2Y/l7P
         0FBBfhG1JuuSf+/HchnjB8Z0NujEFQRoZtWC70s9a0oIuTFF0zSEsk7qNYTdS/G0MjqD
         SU7DmbHFigqgPIoUMeFpI7Ner2jonWzj+mJNqXTHac7BoqcFmB2ePOGEsdsJ9sQKAFPi
         uhYV7Zf8mz4I3T8QyDNqio7KdWWoREbGBkYucjyBiD6Eu7LKdCroXcpxguzjF91kcwKF
         welg==
X-Gm-Message-State: AOAM533Yc6OwnyNM0quoVpujIlGa6i1FYxZd3pl9pGCpxAOOLQ4ASWNF
        gjymdVOTiSxHyGuEA691WaywDKA5Ca0=
X-Google-Smtp-Source: ABdhPJxZbIxkYnPLp1ENa8d0vfYFblOkKu2wEUaaYgy2IPxONllLG5DJmktgrzglVCJbleFW2IZiww==
X-Received: by 2002:aa7:9e5b:0:b029:1f1:5ba4:57a2 with SMTP id z27-20020aa79e5b0000b02901f15ba457a2mr956448pfq.59.1616436122677;
        Mon, 22 Mar 2021 11:02:02 -0700 (PDT)
Received: from [10.230.2.227] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id k127sm14962367pfd.63.2021.03.22.11.02.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 11:02:02 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/60] 5.4.108-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210322121922.372583154@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <739491b5-456f-7fe8-7c19-5af725ec0ae0@gmail.com>
Date:   Mon, 22 Mar 2021 11:01:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210322121922.372583154@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/22/2021 5:27 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.108 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Mar 2021 12:19:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.108-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
