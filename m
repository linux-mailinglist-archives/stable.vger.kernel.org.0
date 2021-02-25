Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C89C2325883
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 22:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbhBYVSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 16:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbhBYVS2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 16:18:28 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 201E1C06174A;
        Thu, 25 Feb 2021 13:17:48 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id t11so4666470pgu.8;
        Thu, 25 Feb 2021 13:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s7Kbco3BnLNX/4+0R0xyB0PyCIbAKst4y8GfjvhcqZ0=;
        b=kbLPZB9rGlIEYKcMJqMvIwtMq4zwKdhH3wbmKqyV7PPH4EdwH//RTFlyg4HYPDhmb0
         c61hgCllCjKyPP1gZ3Q13LwZQ0kyAvNfvhoASpj4erFz8103ArImQmkKfxn9P9gZp2hm
         x76mXxBh2JrEEH2G9ThCkuVMaqEGMkqG47ciR/G14M9jMP9Z572da4XP5Gq0FMxGDLG2
         NB0sbiOf8pxF12lUBmSWcl2jHKTiI4WErDuUwL2VV8dppV3hK5wXp/k6HU+FtBJYYiQw
         AKLZz3D5p6cPyD4oPqUdl3tm1pIbb5aO7WMU6ZDISwC8yIh4siPR/JsSvqqoQ0OD7dIh
         M8jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s7Kbco3BnLNX/4+0R0xyB0PyCIbAKst4y8GfjvhcqZ0=;
        b=ADLkzW9OBrfekd0HKNdI7MoZNIy/I5ZtcDiUV2JC+2TqL5E3ZrrR7JYnlBAkzySNT0
         ChwOBnM5Lyz0MmQ8B2gGul7vzfr5GHzcuAHst1ISdXaQC9v8amRzAdXZis37b6xDsb6j
         qrrJhyq7Bwp3INrJQCHHWy8rxoO/ymrGImCSZ/nnGChxva/S3AoTDnO3ENH9VjXWzvPd
         bOQmY2v5nHfQM54ImO9dcGDQEW50lFlg4DErT+8hMHtpnYNW40MHqGoXpwlncntWqHdI
         KENI4eYN9MYD2I21MAMAw0I62PdPJps6CnujZVHvRls0Ps9mjMLrIR5myqftUyb5011w
         YIfQ==
X-Gm-Message-State: AOAM533XyPfS8BvUKlz37ipQS3EvQXqNlYtz1ERlv2JpffFQCLcCaDK1
        1DfwjCkhBcnfBycUBCaadvhScN5u8sQ=
X-Google-Smtp-Source: ABdhPJytEm/maIAO/FgcNslW9vhYnmSR/c2MebnH4/0Btk/P5ksZMg/cC23Uo8wp/rIeccHuwrogJQ==
X-Received: by 2002:a65:4083:: with SMTP id t3mr4774282pgp.150.1614287867105;
        Thu, 25 Feb 2021 13:17:47 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k7sm6675426pjf.34.2021.02.25.13.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 13:17:46 -0800 (PST)
Subject: Re: [PATCH 5.4 00/17] 5.4.101-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210225092515.001992375@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <26e9bf21-3a0b-dc0d-4bdc-b9eb0eda8d7f@gmail.com>
Date:   Thu, 25 Feb 2021 13:17:44 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210225092515.001992375@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2/25/2021 1:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.101 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Feb 2021 09:25:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.101-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
