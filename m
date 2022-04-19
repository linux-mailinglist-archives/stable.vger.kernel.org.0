Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1658E507715
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 20:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237014AbiDSSLF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbiDSSLE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:11:04 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2143CA5A;
        Tue, 19 Apr 2022 11:08:20 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id 12so16527202pll.12;
        Tue, 19 Apr 2022 11:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iKOXan7V6RgDyVxgnCAMfM5Hv9dIcawtEU7/h6jjEHs=;
        b=RSKnaYTnNBghXp8rxYSTgkSIL8DokwS4KiI9c+zTVTq89fJR3moUgotnxnVc+h3aDd
         LUMolsMnIKjkQpY93UfcPwI3NWxe7nukTaV35kXPWzPyigJbVKZ2JaCJRS6Fy/SrBkpH
         1Lg64KfUhNEQqXNvpKW1KEnS9ArLJI4WPMQ/Gt7PVDt0jQ5cuCSQZzBMBAwczXZxYMBm
         XszqXDEheJRRn+IYXIDmZ99G4bKXC53LPYTFtEQNBPQt9pz4A1Qrb88g7kisaXIFzFra
         PpPNrvsai087/gDmWGFhsSTRDfGzBH7JIdr0g0ybhY7E27maNx40xtS+z2nous2nHPcf
         G83A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iKOXan7V6RgDyVxgnCAMfM5Hv9dIcawtEU7/h6jjEHs=;
        b=7DuXiqCjDB82PeM4zKXw8H5oTW9uyQ9e5sRVZ3NtsTx/Nj+xS6tmhUhHF22srt3suN
         SkIl/cKdmntuy37YHHnuGRbiXcZdAhs4tW7jAC/goJHYTLANaFmPbvgqDd4PeKrQ91qM
         LOSbfi+7mQTWwzwA0L/tq5oZgnKGUrGk4ulyVnI+kq8g8PfYQbtXUzTfNMcwXctxBiho
         FDwmXq0PmyRcsXeCvMrmWJLhckqP0uEh0HzR8a58Am62DdPkPCjz23j83lO2PS4f405N
         uLyFJ7TZtjWtK/rpg0EobvFzQ1rE7oI3b2W4eE2XJYRT5lSWVGBLJZtfBw5UO/YJ2DnP
         9AzQ==
X-Gm-Message-State: AOAM531KWo3om43+N4+d2EgctKVWgb8Rp9Z/LGHqkuVgrSftEYclZVr0
        cVIRW1P3708ttlkdJNY4X4k=
X-Google-Smtp-Source: ABdhPJz7FgWZWrG45H5E6ucr6YgCG0gEKZgfjn8yDjLNPd/tyQkdDXq0o2rBEvYxQEQMIPySh2vg4w==
X-Received: by 2002:a17:90b:1d82:b0:1d0:5679:b96c with SMTP id pf2-20020a17090b1d8200b001d05679b96cmr25267182pjb.167.1650391699860;
        Tue, 19 Apr 2022 11:08:19 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id z27-20020aa7991b000000b0050a4e43d3ffsm13535625pff.65.2022.04.19.11.08.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 11:08:19 -0700 (PDT)
Message-ID: <dbef40cf-b698-3884-6c34-44c504320935@gmail.com>
Date:   Tue, 19 Apr 2022 11:08:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 5.15 000/189] 5.15.35-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220419073048.315594917@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220419073048.315594917@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/19/2022 12:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.35 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Apr 2022 07:30:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.35-rc2.gz
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
