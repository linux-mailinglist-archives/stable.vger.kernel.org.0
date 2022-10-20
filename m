Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEE6606808
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 20:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229755AbiJTSPc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 14:15:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiJTSPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 14:15:30 -0400
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D817564F3
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 11:15:26 -0700 (PDT)
Received: by mail-oo1-xc2b.google.com with SMTP id s1-20020a4a81c1000000b0047d5e28cdc0so84569oog.12
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 11:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1+pWbAD1M2vNKvKxtdRsmSPgl3psNK2Gs/LGU6NGnbc=;
        b=LX8/mIYryI54+i1NEERYLBmXHXy830UqM7EaLz3WrFUBdIBLq0gwHI+IESCj3YAhVe
         E1Mc6hvyGLo16IgschP6IMoc+iklWUWDvXfrFL6GMvyLUiLTlSDNttv3h6o41CMBDk1S
         /0GxYBcUuQJ1nmyrIw2vb+mDtlh1gwSt+powQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1+pWbAD1M2vNKvKxtdRsmSPgl3psNK2Gs/LGU6NGnbc=;
        b=Dp8+t7amlIRnyVQoNsWUvp53CcbPx6/6HWBgzsmKjsgJNMy4giTPeAKY+R54Bg5Hv6
         hHw3vvSsG1Nlk5nx0YmOnGxvooqbe3qIuuMWf6BrrwL/JzvBQ8l5lx62LRPqtsT3XI5F
         +dxdLNWVjnDSKMIh5iM+i68X4Nkdic7e/opD4FXWukdfM/j8VZ7QQUN8poyEvbkdEycf
         46fsF+pSzFDhM8CeRwQ+y8aRLpZh94IazyJ+PCQCh91JPR2qD7FVfhI3YkK48vI+RxBB
         UMbvMlVpRukgIeA4cekGNy9E+Q2XEJ8ZI47ziEzx3SQsq07qR36/vjOt47UP8ubdqN4R
         J2sA==
X-Gm-Message-State: ACrzQf0qMUc/PIstdxjB3Dq5Xn8vruKcQYXeP/S7QDSTzJFOEeMZ18wo
        FRCtWm5ZZw3rgrmURwAdUhONuA==
X-Google-Smtp-Source: AMsMyM6laKFJIOC7Ta8SxjYf1tmUGZ/3HXYIFdO7ngRvFSu/9alIlq8++rLRijWj0rkmkzeWWF8ATw==
X-Received: by 2002:a4a:e645:0:b0:480:9cf5:d4e4 with SMTP id q5-20020a4ae645000000b004809cf5d4e4mr6965876oot.77.1666289725686;
        Thu, 20 Oct 2022 11:15:25 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id ep10-20020a056870a98a00b00136f3e4bc29sm9155456oab.9.2022.10.20.11.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 11:15:24 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Thu, 20 Oct 2022 13:15:22 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/862] 6.0.3-rc1 review
Message-ID: <Y1GQOrWWDe11Ae95@fedora64.linuxtx.org>
References: <20221019083249.951566199@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 10:21:27AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.3 release.
> There are 862 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Oct 2022 08:30:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.3-rc1.gz
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
