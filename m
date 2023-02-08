Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABBA968F752
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 19:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjBHSpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 13:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBHSpe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 13:45:34 -0500
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A077A5DD
        for <stable@vger.kernel.org>; Wed,  8 Feb 2023 10:45:33 -0800 (PST)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-16aa71c1600so2490281fac.11
        for <stable@vger.kernel.org>; Wed, 08 Feb 2023 10:45:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KSn/C1OjXBrUNFQN3FvWdY6XkcZfs6wdWyMFAnR5BhA=;
        b=HNzAQhW3Ao8fSueXBzGJed815Tdu47jyiyXtlkqn36u/ShQ9xb8BnCpHzOj3IU+chh
         IFYhJFCGPU8WheCE5omseiGLHofOgkWH1F2oJFOnkqYPY7R9wiaauXObsS/IN9JQ/8qE
         ZabMHrrXFiyiJSkfVtZwax/MMVU1EkA+WaPSI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KSn/C1OjXBrUNFQN3FvWdY6XkcZfs6wdWyMFAnR5BhA=;
        b=JMk2iy7lVxBvGdZSOA7F573kGwTqTp66oaZvpw4YKgoOC1+PX3G3Ih83RtCmNhfKhs
         iIrcGGZdAgU5SmHA3PZWpRfqSVIT+XDkSp20UhO4M8m7TsmwO4YQM+U967OjHjNVqHAZ
         DAZCCp4V+pSmxrPXSOK2e9ewoS+bqqpyU0o4hTy9LmFyZGOvve26pe6DpF3RHo48C6vF
         Mi2d+oqeZgjD0jJDZRfo6/vhH6uZ2HIThLM3eCjmPu5qdQsG/97iKWjYVfCXnoa/U/b5
         +0byiH4/HVx8N0+mmQyCcLY+OCplBXtvgTuSYl87OtPfEtMuuyeKMm5EbVY29w6w8D9O
         mkJA==
X-Gm-Message-State: AO0yUKUtzx0+n4bjO306HjMOIbBfuqdMPo4MplIphXGMIYmoqmk8f7YZ
        y+BhdFtwoGvHzM2hgI/Enzp9WA==
X-Google-Smtp-Source: AK7set/D/rCf8TU1DvW7e62jT2Yk5a3LyTNPjHU6O9n6cyi0Qn3mDOAhaqSJ7UNa+DREMN3yIT5jzA==
X-Received: by 2002:a05:6871:726:b0:163:20a2:ddde with SMTP id f38-20020a056871072600b0016320a2dddemr5438224oap.42.1675881932929;
        Wed, 08 Feb 2023 10:45:32 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id t22-20020a056871055600b001600797d1b5sm7051291oal.41.2023.02.08.10.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 10:45:32 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 8 Feb 2023 12:45:30 -0600
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/208] 6.1.11-rc1 review
Message-ID: <Y+Ptyvz6M29TT3W2@fedora64.linuxtx.org>
References: <20230207125634.292109991@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 07, 2023 at 01:54:14PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.11 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
