Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B124D539B
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 22:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245709AbiCJVbu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 16:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245560AbiCJVbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 16:31:49 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75D6192CA3
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 13:30:47 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id a7-20020a9d5c87000000b005ad1467cb59so4967488oti.5
        for <stable@vger.kernel.org>; Thu, 10 Mar 2022 13:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5qJr9oFbO6WYeiROwbwsIG7qIaqfAiFr4KdfM+v42WQ=;
        b=GGPM27WOTI7uu5IJ0L11WadFp88pFu0pH7S28DbERHgwUzT8k4DvxicY7dS6et2tJu
         kYL4cLdwSJSyDWsRRa1s5aM6bRXC4uzyaTcbCs4zNkSwDjfYb056Yg8suKnbcJ1BJw0K
         yPmBXjkr8su9AJEu9lQrWQprsp+K4gCWSDBdY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5qJr9oFbO6WYeiROwbwsIG7qIaqfAiFr4KdfM+v42WQ=;
        b=0dzMpjMPyadPe6Og4pYt2Fm3vQnZcx3/fBxh+fXwAer1DOjiYFUfKOJbz5xGHM5vRJ
         JherhhiXH09rXPILpasEtxo0KiYObPTdOzYqAdcCP9BNwJSGRcwkeHWi7Z5UBlwvBmWe
         rl0vKm4rAqV4ELBAcfdesoKhkQje8uH/JqTISRF83gdM0sWB/OiPHhfr3eyhgbS8eyL9
         oojPRHBJ8ecZ/CvRFiNf1ZYreLLgE8p2cNoAMd1Arhbq0zCvsbfRBx3z6dOSWqI1cwiy
         x7gPGEa3vZWsAt4YjU3yNoZq9zOpS911eWjQSeSadIInBWhCFckvpc4HL277MrodlMLY
         aiwg==
X-Gm-Message-State: AOAM532uNwu3/93LzLhWsdvJa/pbdhbL8eNH4ZobKWjkLTgkenM8bo4M
        /ecy7dDUdJE7Grk7qqrHV6HX+g==
X-Google-Smtp-Source: ABdhPJys/PJe9Ij2hy1VoO6dGuDkJ0EYEPKkUlm8DUiPR7ZIeU4gvYdRfui73v63MgqFAuL7T8NX8A==
X-Received: by 2002:a05:6830:40a1:b0:5b2:2ab2:4211 with SMTP id x33-20020a05683040a100b005b22ab24211mr3467163ott.171.1646947847097;
        Thu, 10 Mar 2022 13:30:47 -0800 (PST)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id bb39-20020a05680816a700b002d9a8eb89fasm2737249oib.46.2022.03.10.13.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 13:30:46 -0800 (PST)
Date:   Thu, 10 Mar 2022 15:30:44 -0600
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 00/53] 5.16.14-rc2 review
Message-ID: <YipuBM+HbbZ3q7b6@fedora64.linuxtx.org>
References: <20220310140811.832630727@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310140811.832630727@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 03:09:05PM +0100, Greg Kroah-Hartman wrote:
> Note, I'm sending all the patches again for all of the -rc2 releases as
> there has been a lot of churn from what was in -rc1 to -rc2.
> 
> This is the start of the stable review cycle for the 5.16.14 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.14-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
