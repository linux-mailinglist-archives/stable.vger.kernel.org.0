Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAB944C8F8
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 20:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbhKJT3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 14:29:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbhKJT3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 14:29:15 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8BFC061764;
        Wed, 10 Nov 2021 11:26:27 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id r5so3922569pls.1;
        Wed, 10 Nov 2021 11:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1qbhSqcF16F2mjX6K1Vd2e5isFrE+1abQtDD/mqQSQ0=;
        b=kQNVmmBR8oG7TYiFOmbk7q4nk2xkMM18MNMD6LTnUc/wEbyG7rsysYdH2wW9pp/vBW
         6GsmsOKR9MEXum8u267pm0ZsJMnhE3zZaqMmBzTwU4kzaRlW06WNM1FbtFMdFshuWs08
         NIidpcJPVzgHbWJifPZfZtN53MslqMWpvjwX/5u1ZWj4B8oyVpRT2p2Hbr6sFs9VBx4+
         9jxxzyph1DcsI5hG7GJzG+WuzIpwuH+kih4QrMPIDLq7t14gFENxpIeBrViWlxd2CawO
         LqTBxaLk3tj2bxrbpyqyUaQgFXwW39x4RbzGy95+HxNOqYhYI3sWQB3c+RUmL8bS1V+F
         2N9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1qbhSqcF16F2mjX6K1Vd2e5isFrE+1abQtDD/mqQSQ0=;
        b=OHtiudMmI3+yDKj8bbe8Sb8g3NKqpKQIiZzIWumwcRMsElb2w8wnnLX5hJEdkkUA9w
         DNLcLWLA3BKNbEhg7d4MB2ThQ5Hhz1ztb/JRgVQ6/bvuKORX//Vr0r+lN/gOE+pPDIW3
         tzM1YAmlfq6aQlIsShj3uzZZYYZz7XcFhm7QBrGSBHZwA/+HECslHeXMwD5ssARuy2L8
         dK4E4cHxPRsWSHivbiSXJu3gid0WIFt3SH1Rju1QAkuyXOhFC+lFfYgFrK8NGClPG53y
         eCg7uEZML5GtK3Vx8krUO7LUpmKi/H/AGO/RQDZfpna9tpqXWZp7cQG12IrgVY7StYir
         Ck4Q==
X-Gm-Message-State: AOAM530ej3fiN/ddWeeJQjNDPFsUkLgj/nUJLVrig9KNvaMrU0V9D4iy
        b9GsR9V147ja4ytRhxEyIuPrtf3gBSs=
X-Google-Smtp-Source: ABdhPJx/ZnDWh3if6/hc+jMRHD5tVRjJoXXAo25eMhH/BIHm7MXi891tv/nPDHVy4hAOTHoG9wy0oQ==
X-Received: by 2002:a17:90b:20d:: with SMTP id fy13mr10887113pjb.47.1636572386340;
        Wed, 10 Nov 2021 11:26:26 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l28sm315148pgu.45.2021.11.10.11.26.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Nov 2021 11:26:25 -0800 (PST)
Subject: Re: [PATCH 4.9 00/22] 4.9.290-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211110182001.579561273@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f0fe2b4a-7de6-eb34-7539-62d1b758515a@gmail.com>
Date:   Wed, 10 Nov 2021 11:26:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211110182001.579561273@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/10/21 10:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.290 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.290-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
