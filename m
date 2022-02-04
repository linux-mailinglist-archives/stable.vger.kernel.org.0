Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8562D4AA3A1
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 23:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350902AbiBDWzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 17:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243759AbiBDWzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 17:55:50 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59696C061354
        for <stable@vger.kernel.org>; Fri,  4 Feb 2022 14:55:49 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id m9so10178617oia.12
        for <stable@vger.kernel.org>; Fri, 04 Feb 2022 14:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lYzVe5193qn8COmgg7fpEZ/q4OPCD4XcodMJr96TYww=;
        b=gjgQO2f9qIpYD3Bjd72bgOKUZO/uN5+Xa/kUtlUNC6j73fRBDycuStIjX4URSYdw9t
         g1P9/agrVthOq8PD9jKOdiTHvPH6HzMwEzXW1CC0SszmIyr4lwTfgkmg5PPwmO15ZoZY
         TEES0S7p9Kht0RadfXMfydtz4JoKga1XPyXXI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lYzVe5193qn8COmgg7fpEZ/q4OPCD4XcodMJr96TYww=;
        b=iVHV+KTz5t7AiTDtBmIkT0LnjTal15Kf3fM429eJrDVHDvjD3A9OsVAHjjYXmfPBNR
         asZBhN40mjamj8JDjuL/cNTNxhYqckIg0ZB9P/kfKegDSkTxI8fzLyIYQm6NQcj8/gNb
         8UkU65kPZwGvt+MtY0CuxAPSqCVB3FGA8YUfNs2ejfGpsh5b4fnDSHDBF50Vi79oy18a
         xuBReddmH/BqrhmLYYRRq3Fb9tC3gQSDsRcRXPEE74OmOkBsijhswqDI/tRnd0O74kA2
         mVFSyhM8Q0x8TortWkWYmancgCmu0zJBGKxPZyU2HF1o/YmjHjEf2CIuYAIdTsyFNnsH
         titg==
X-Gm-Message-State: AOAM531GhXB1b6hF/l0480iJR5l/NhGv244VThebNuk6OEItRGQLRL5N
        //yebQtT3T+lXFjlsJtaG+w3Fg==
X-Google-Smtp-Source: ABdhPJymPvUu/qD68FpoKjiJxlky7nwkfLz/KZeSyYusKniBG6V0DKE2jLTPexRUby7viQBzmR7dEw==
X-Received: by 2002:a05:6808:159e:: with SMTP id t30mr620412oiw.132.1644015348581;
        Fri, 04 Feb 2022 14:55:48 -0800 (PST)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id e26sm1348221oiy.16.2022.02.04.14.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 14:55:48 -0800 (PST)
Date:   Fri, 4 Feb 2022 16:55:46 -0600
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 00/43] 5.16.6-rc1 review
Message-ID: <Yf2u8q6YcFKOYdYL@fedora64.linuxtx.org>
References: <20220204091917.166033635@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 04, 2022 at 10:22:07AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.6 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Feb 2022 09:19:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
