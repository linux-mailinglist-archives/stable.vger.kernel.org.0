Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B71412AED
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 04:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhIUCDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 22:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237997AbhIUB45 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 21:56:57 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E422C06127E
        for <stable@vger.kernel.org>; Mon, 20 Sep 2021 16:59:11 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id 24so6071582oix.0
        for <stable@vger.kernel.org>; Mon, 20 Sep 2021 16:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LsAcbqCOznCCesA5M1HtjmmF5lDx1DBcGXXZJMNbi5M=;
        b=FnrIBlAqcU9RQN1qWIrzAEpI+nxH5Pvyckbh6KpZsRLiMwdmDRJyGQ9epFg6bAtj+3
         9V1W0A6laHnsvLQL5KTMzqnmJgVr/ZS/A5wOUMs1RUjqpHofLEqyDKHWYe3uY+kpb2ak
         7EbE2l2bPmgVLhORAFis+RMdEvKMbfqRNYdc0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LsAcbqCOznCCesA5M1HtjmmF5lDx1DBcGXXZJMNbi5M=;
        b=I3w7Xx0xkicQiKlpD5NFcASBcb+kJaBGozpi/dIv89MBy2HjbohPK9YVtLLmwxW20b
         nXNGje51CPaWUMaFUYt6mw5vIKXGNI23tpqbHCKb9kxlw/r4BqxdFIlyIXjBFShBUn7S
         DTfUCnGDbtrWSeGU8qubXC7YBcQWmKVSXDn+YkIMjaowLeuDY3TEy6Wl6ii9IYTdrGnY
         4iuzfjLrTzX+G/Hgo3qvgRi1Q/7Zp/Llh902mIuJHu4cUgHklR/Y0m1qJUZZVwcO/m2F
         MNsbXkgVt8+kqduWIiOuQBTFbvg7r8g5SMhluflAZ2NTzNvUpa+bAxTrStr/zs/tefpb
         CHgw==
X-Gm-Message-State: AOAM531rl7CFRsM3rUVKHbkqZ/3DBqZ3l1Fc+fFQhZqRC2q49jZo/0Le
        mdLbnSHhf4Hm71dGYkH801kpSQ==
X-Google-Smtp-Source: ABdhPJxbNH/DkXzFL8muMgudxy5/Ej/ewPN6YEU26m6d3M6V788VafXJlr03Fx4xe9/EfHr+KaoA2w==
X-Received: by 2002:a05:6808:e89:: with SMTP id k9mr1290672oil.169.1632182350663;
        Mon, 20 Sep 2021 16:59:10 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id h12sm441479oof.7.2021.09.20.16.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 16:59:10 -0700 (PDT)
Date:   Mon, 20 Sep 2021 18:59:08 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/168] 5.14.7-rc1 review
Message-ID: <YUkgTMRoCGo+VDR4@fedora64.linuxtx.org>
References: <20210920163921.633181900@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 06:42:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.7 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
