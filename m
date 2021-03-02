Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C9432B02F
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344628AbhCCAyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:54:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2360749AbhCBW1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 17:27:13 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC66C061756;
        Tue,  2 Mar 2021 14:26:23 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id g4so14893546pgj.0;
        Tue, 02 Mar 2021 14:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8sfn6PyE8JLHvP21jdc22sY3szZWUCoaBSLCffzwwZA=;
        b=fcR72n485t1ZD/w0/9B9Mr6u1xxyzJPwRRe/IW1P6qklSc+1oVNhEkvcjI+OfRycec
         vSCu5v8jPFFm6oOZu5ubVRJQOmj+aA1gC2tryHlRZ4Z/iZ5u9vpiCawZHidUNjj685Br
         ijDUhKtSNUu+HHf4TWFsRUGUMEtmUZCC7b7f0TijBwwjNXK/A7WZDq/xFC/9wHWsbAsf
         tbX37SdDbARJwEsIggdF+r0BYgrSYegWf1r9KkpVnWKsV3UnRkdfqAuy0sgEUPh7d64i
         BvL8iH+AQgIVjA78FxpF0I4u3RV1Tm0ck2nr108QO8O0pUYHLhWRU9yvXb6hjZ1PbFtr
         Rn3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8sfn6PyE8JLHvP21jdc22sY3szZWUCoaBSLCffzwwZA=;
        b=h4EYlenUiL0czHSO5silu1yOqqdRCAMaN1qgpAgy3mFGVdmfjzKz0lKBhueRyhexYy
         aeDSoHXsUpj0snk8+5a+D/9RIR3qqu/4Wnvifs0HGgLwB5cbgr2M/DWLUKWNcEYjPm47
         g6XLiXoIL3m0eu/YK8vey2t4fIyxZrIVWaojMfAyaEBYtF2bB18dm7VRcad5QTHi4X2/
         kYPjLVzEHdaORxGByMhdZIF26lktYkPSQsPQ5K6dXOIJMGxeYtOshe+esTpq0gOZxfWC
         GPgb8exKE4hhem8RhbnBxS8jfZYJo00WS7wjOC9XjqCD4IKqgOhOjXXeO7JcWlKySUEp
         D+fg==
X-Gm-Message-State: AOAM532bHZJsQfI/cscVtgf8WT5vKCKTVsehm6cRX52WP+ZkcoAo7xVb
        tOrXjoIjcGNvd0ZYSYizAR1Nb1EOHAw=
X-Google-Smtp-Source: ABdhPJyiBRFnuU6pgr+qKnfbuTIZCxCEymouQlYJEpoyJ9KBAPvqk1kKJ8aPV4E/GWnQiMAyq43UXg==
X-Received: by 2002:aa7:84cb:0:b029:1ed:9b6f:1b6f with SMTP id x11-20020aa784cb0000b02901ed9b6f1b6fmr5501pfn.57.1614723982192;
        Tue, 02 Mar 2021 14:26:22 -0800 (PST)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x2sm21789618pfi.220.2021.03.02.14.26.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Mar 2021 14:26:21 -0800 (PST)
Subject: Re: [PATCH 5.4 000/337] 5.4.102-rc5 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210302192606.592235492@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2752c06c-db1b-eb6a-38a9-818ff7398665@gmail.com>
Date:   Tue, 2 Mar 2021 14:26:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210302192606.592235492@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/2/21 11:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.102 release.
> There are 337 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.102-rc5.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernel:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
