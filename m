Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2610A681E81
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 23:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjA3W5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 17:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjA3W5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 17:57:37 -0500
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324D119F16
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:57:34 -0800 (PST)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-16346330067so17223327fac.3
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H4C3LLRe7XudZxVhxF9djT/1jzCGZdm6sY4sPImvKLY=;
        b=C5HOxKzbKCXsAxmhxxStBrxA7KmKH5sorHz15rcY/lnCedBwFHiEl+vphFvneNyL+F
         Atc/qUJx4oN90L84rpFKpJMDyy/k/dSYdHB+FX0Z49nYSU+z/2lgSfllfG46LFbYfQqQ
         I8mRCuZWWL845ITNtKlsGDOydPj6zB1VzCSCc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H4C3LLRe7XudZxVhxF9djT/1jzCGZdm6sY4sPImvKLY=;
        b=yn7H0qIMiff20s6RU8ZXrZIaGkPEM1G/gcs+1DIiXMRQ6bbM+u68Ktw4sgVfTGguEj
         FqKJTpAdNZ9EUsJK77URxn0jxvJu92jJT1SeE0NUa68cvtZTD+sPEHPi7aeOh71qLCTv
         eSjbFHqtNVdhuAivXqsfmJhw66OzoBJAFWFwPQ7Y1hleQoHCNOLQIOS+NHwh4zmq7S6+
         IQa1I7xEqcZGZupCO/JnuxROXhoGgPJ7aOfoUpeqMoyhDBweQwPiZ+lmEz5LWF7VKZox
         L/P8dfI+CwN9VoXQ1G6Q9fdFNULhYREIpwzi+cDqKsUzdBJwAeOqMb/9ceG6RKcITMR4
         IeSQ==
X-Gm-Message-State: AO0yUKUin3vdqsysJyrmcJqWfzXTp4hWSLMpkpEJ82vnhsduTyNVqb3h
        ITTZoggcxI05vIQDjRuNQWY/d+ymJK1o8RZFNwzPCQ==
X-Google-Smtp-Source: AK7set8YyE0Ax5BBAeYzcYcOqGbn0g4cxVDxl7J238q/i8urKB9VuhYDVNT0IzxlWYf6K7hppB1Jpg==
X-Received: by 2002:a05:6870:20d:b0:15f:1c2:230b with SMTP id j13-20020a056870020d00b0015f01c2230bmr5569641oad.43.1675119453368;
        Mon, 30 Jan 2023 14:57:33 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id nr9-20020a056870dc4900b00140d421445bsm5769855oab.11.2023.01.30.14.57.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 14:57:32 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Mon, 30 Jan 2023 16:57:31 -0600
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/313] 6.1.9-rc2 review
Message-ID: <Y9hLW3Rl8b8iMS7D@fedora64.linuxtx.org>
References: <20230130181611.883327545@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130181611.883327545@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 30, 2023 at 07:24:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 313 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Feb 2023 18:15:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.9-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
