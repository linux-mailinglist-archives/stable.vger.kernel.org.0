Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725364A522B
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 23:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbiAaWPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 17:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231337AbiAaWPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 17:15:51 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B947C06173B
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 14:15:51 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id s1so12696206ilj.7
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 14:15:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4WIAAI1YyTvDXovf91hwEptzHInPStTeN3fbxZKa7ZY=;
        b=K0hwEHsiNUfEgHoL27BAk1HZYvaxr/kAD1ShrexM1dvZrYkcLyK5bmxNUb6BIRK+jj
         DTeD/axsxnjifcP4BS91/rQcA53+C6ZbRgW+ShfRChgCsG8gZc2lrlMKpeghyKk/Tz94
         5KvElx1aK0ZOo1ieHO3jMEkMeNGnzTkcjaxAs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4WIAAI1YyTvDXovf91hwEptzHInPStTeN3fbxZKa7ZY=;
        b=qOb0yJD87SO4QOsEc0KzB1HImAoV5oBhg/GBmziqyaEYoYgpoTqC8V5we8H7vDd2Qy
         1hvqFITf8SfMGCJzIzdZwNLOUshxNPqn06MVnqQQX109m7MtksvJlPuO96PvDEXvif0I
         iHu/zGJmfRY31DQ9zZlTusFTuchPtPhfEtbOJikpo+Bv43/fV4plHmNYr/Po5qqIGKAt
         hBF4szH8ZaM02510KpCN8RFryRjA/ZkTrDObQtLZlkosKYOlztD+LhHdlep8WN2uBixM
         KflKBxoZO/UrJ4bals4FcFDRGlGDldapJOWEfc1DtO5UKknDbuxlZOrJEKWk2Y6+61Q0
         a/uw==
X-Gm-Message-State: AOAM5339c/S2WQ+wF79KM+n3u/h3fgq4BWItHGDkvrYdferqgzQp7uIJ
        X6fQiQBJD2oXP8s5QRzmuUeKVQ==
X-Google-Smtp-Source: ABdhPJwAGB75HkpJV+hmWtYYbrikRpPLL5ZAx/Nex4Buj/2Sxu7MU4WzWsU2kp0RoUBrg5VyEi4xFw==
X-Received: by 2002:a05:6e02:1a4f:: with SMTP id u15mr2168857ilv.245.1643667350527;
        Mon, 31 Jan 2022 14:15:50 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id r64sm15480536iod.25.2022.01.31.14.15.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 14:15:50 -0800 (PST)
Subject: Re: [PATCH 5.16 000/200] 5.16.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, Shuah Khan <skhan@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <55b6e728-f613-da6d-bbe0-df123eed6ba0@linuxfoundation.org>
Date:   Mon, 31 Jan 2022 15:15:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/31/22 3:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.5 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
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
