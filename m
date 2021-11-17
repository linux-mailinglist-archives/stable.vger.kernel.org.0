Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D798C454D6F
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 19:51:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239235AbhKQSyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 13:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240242AbhKQSyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 13:54:41 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78599C061570;
        Wed, 17 Nov 2021 10:51:42 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id z6so3515429pfe.7;
        Wed, 17 Nov 2021 10:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ymJQcJRqf96Ow2zei4DBcVd1WDXXoNRjGtKMHrKgyCo=;
        b=gnk0mZKgSm7QfrIaXSU0G0tO4ESnMmu/pavEGl0r7MlUElajM1NfYGU1ROQs+03vvO
         FIvU5T6CZRfsVxxvMnfZInSfGCMoGaczdWcrAhMaHldzuh3BHfvhzieXUOEY4q9AOAm4
         BQv0IIVhAGccbiCVS4BNL8K4mTfWUNliY6FgCmLoOqn4+h89Fed/j6lXYI5yqf0Bivx+
         gVZ5cvJ9O1u4QWksoWn+77PKR5IjWpQfjuIehKRxF/QPd5Kf79umdInAkwCBZHwGc8bD
         1WptEZXbk5AOieMUTKgGDMXsyaeHWPGYF8cp8J8HbYDWfITqDvVU+BqwARVnf++oYnXs
         xmFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ymJQcJRqf96Ow2zei4DBcVd1WDXXoNRjGtKMHrKgyCo=;
        b=wjwYa4cIUP1ukphA9f3KM466+Ey//MNpmyGilYZU3+RvzLEX5X4wEIrQRh2XJZC8N8
         JxUHRa569s+BP0Ew/3FdHolHKS/jgYZneLuDs7kl3Rl4Bh3NcPYKfVVSsvz9//kYCxuW
         CM3Wq3XrOgVRDPl8z5aF0cKbKsA+H+oyy1QoJ9qgRt3lmlFG0y7HrEz/xhYEpBiL6jgf
         BMirr2ha8WK/seZ5iX6YEXW/5TO2jUU8zv73ilb1ry3N7id83iBQmqHVnBPLwLF/kboX
         NqKRU/lZYEcL3dQMy+AUBPSo9X0i7ZYiBUcwJDuSrSOU6t/ZOXHb/xyEGTNehbwzqAsN
         wWGw==
X-Gm-Message-State: AOAM532tgu4wIS4CgeSwd8jB5rXftMWZB22OtmoN3uOtcVZVfvXsf9V7
        a/tIHf/qXOC1TsPK0Tlq0npHe50D9Jw=
X-Google-Smtp-Source: ABdhPJwW87mY+vwP8XuatUOKD9cIRbP/+YXWu/v4p4fAfNeDaebzBGFNkroMgOnk7yX8Zbe2EWamlQ==
X-Received: by 2002:a63:5f54:: with SMTP id t81mr6685304pgb.247.1637175101596;
        Wed, 17 Nov 2021 10:51:41 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id fs21sm5040033pjb.1.2021.11.17.10.51.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 10:51:40 -0800 (PST)
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211117101657.463560063@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ca8761e9-63bc-cec2-3b0a-607c22fc22fb@gmail.com>
Date:   Wed, 17 Nov 2021 10:51:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211117101657.463560063@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/17/21 2:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 923 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Nov 2021 10:14:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
