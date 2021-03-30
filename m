Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D35834DD78
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 03:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbhC3B2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 21:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbhC3B2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Mar 2021 21:28:01 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A456C061762
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 18:28:01 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id x16so14724451iob.1
        for <stable@vger.kernel.org>; Mon, 29 Mar 2021 18:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qwcXVymEU/ZJLMA71UNTq1rRmsQJ0OyPmER1NfJWWqQ=;
        b=BvFzhJJrQqUuSpzJet1erfFVq+ppk7DvL/ktYDUTlwrHqDZdNNMzDcpoyeyXkCsch8
         bkkoZw0qhXUeSJY/I3b71qBCSPMS3htB57vW0GpIk1TR5gaMj3w+Y727EAAyaMqn3OF8
         GqYWs6NyXP0dgxwNjk8v2BxEHXlh28zNVQkX4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qwcXVymEU/ZJLMA71UNTq1rRmsQJ0OyPmER1NfJWWqQ=;
        b=JvyKaEQe/HSAY/B/bSEEWyCk5YC6gr0+n8kncwBv58mNEn4VHE+diPwd4/a/X2QdR+
         9i7cbxOcD5hT/7wS2qBFpwjEniUF7fS+ad6cYBE8HLGrf7gHDWnNz2fFjmBeX+RftMb+
         m3z5EGqrUncew8lLkrjFMAaerqT89jC4fZXVwQnIyN+NEAEnYTNdte6zCQQvnfLwJmfH
         24X6olHYMUa7a69m2USKd4CZo7ABVOwufCkt83M9Tub/gajUpmrq1gxzlN97OCPxk3Cz
         lAxJ77826uI6bpAfCauStS/uaTMJDKSzidzrzN9ddtb8C8bwne2sKN3RTf2ZeX6m6eWo
         XiwQ==
X-Gm-Message-State: AOAM532EtIrbc2m+wIlQvFIQ6jHln0Ladx7xpUvugwrEaCRwjDAitWlA
        3XPldAtBpySqqMJU+pf2dHPaPQ==
X-Google-Smtp-Source: ABdhPJzNQDTQQdzKN4s7uCpEG9fT9O2vxnyblbcEsR/2lY6GtzlAxlQK/hkEpWM5oxPp21rCeVUoxg==
X-Received: by 2002:a05:6638:3399:: with SMTP id h25mr26795575jav.15.1617067680706;
        Mon, 29 Mar 2021 18:28:00 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id b15sm10347660ilm.25.2021.03.29.18.27.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 18:28:00 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/53] 4.9.264-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210329075607.561619583@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <20d28e84-15e9-a14f-a104-c5d7830e86c0@linuxfoundation.org>
Date:   Mon, 29 Mar 2021 19:27:59 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210329075607.561619583@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/29/21 1:57 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.264 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Mar 2021 07:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.264-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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

