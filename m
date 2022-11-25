Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C666381E9
	for <lists+stable@lfdr.de>; Fri, 25 Nov 2022 01:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiKYA3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 19:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiKYA3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 19:29:13 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429A474AA4
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 16:29:11 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id p27-20020a056830319b00b0066d7a348e20so1766298ots.8
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 16:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rTkWTJr+jVo44z0ToVSWhOX33FwS2vLhzhC45GxZgmU=;
        b=Qdjl+pr+iIz3S+2tn1Q0JU7ziR4GJ03sr352O+F4nFNUm1ZTG52sYXAn95iZZhHWA2
         vfyvvqmSy/GXOB8bIDWNZaol5ovJUTOs+XSMPsjBBdwVwt5nfJGp+M/DyGLj3qCbT6nF
         MIuRFfqjJ3qVcCymi6VGzNg03Rj4i/w1QMoF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rTkWTJr+jVo44z0ToVSWhOX33FwS2vLhzhC45GxZgmU=;
        b=BNHmWk+AHhV42C+WeAzhIW9cpG+YKLLqdlsxew3IG5INsKJyc62aX6IiJZvpEKwTCB
         HIBjatRNFdICfrRiMvArq/NZQfO5paibmqnydowYszzduu+1OXgxGpvCVxtnDTMuvsIE
         AW3/oMEhBWhM5HXKTCkj4+ylqWYlS5c9zpDxRXPeRmduHERQ8DMkhTL+0VBK07TxzCsq
         Ynk/WnB8APIQ5ofA5Ox4p4J9+0+ZMtfh48qJfFf4WjIOEz0h68xQLvLylGHDZ566uaYK
         iqmiBU58ILq2P+2cEtcNXZK7ZMtY/2gbXc63U6u4yzu9ffDI9oo8jPdflqfNPCHGspGY
         bFTw==
X-Gm-Message-State: ANoB5pnPdM53VyoI9xFnNb9czbyuvwA7xnLr/6szC0ZP3nadxHNraL7M
        cG2g/m9mysMIElG3rg2fMYQi4w==
X-Google-Smtp-Source: AA0mqf5Up/gRWD0unDI43s9o/afyX5Cgl0YlLTTlVxTCX38dEV155pu9MJQMQWx1c5O2bS1YQcANXA==
X-Received: by 2002:a05:6830:1604:b0:661:ef0:230a with SMTP id g4-20020a056830160400b006610ef0230amr9369057otr.235.1669336150530;
        Thu, 24 Nov 2022 16:29:10 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id d16-20020a9d4f10000000b0066c8bf7f196sm972120otl.51.2022.11.24.16.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 16:29:10 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Thu, 24 Nov 2022 18:29:08 -0600
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/314] 6.0.10-rc1 review
Message-ID: <Y4AMVB9zUGgPQbLk@fedora64.linuxtx.org>
References: <20221123084625.457073469@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 23, 2022 at 09:47:25AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
