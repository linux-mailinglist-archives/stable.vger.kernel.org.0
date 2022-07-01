Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9EF35638BD
	for <lists+stable@lfdr.de>; Fri,  1 Jul 2022 19:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbiGARp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jul 2022 13:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiGARp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jul 2022 13:45:59 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5477735DC2
        for <stable@vger.kernel.org>; Fri,  1 Jul 2022 10:45:57 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 7-20020a9d0107000000b00616935dd045so2369102otu.6
        for <stable@vger.kernel.org>; Fri, 01 Jul 2022 10:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+uIzzdIqyx1C6A1HKW7nXMx0lE0tm3iNprUI98UNAUU=;
        b=YtVG2Sjd5m9rs2+dhrnvYW3C3+DBij0IYl+cvTgLrW3Hhtfrq4OUGHX+0fPazgMVHK
         FDQ81a5YdXRy1e96RX0d/19s4YCFlkjekR8GAjLGwoNGN+SOEvZFHGh6TOqEl5OSuEtc
         Kdv0Ig5uoj7B/+zq3Rcuhhmi3bbCLMPV7awAk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=+uIzzdIqyx1C6A1HKW7nXMx0lE0tm3iNprUI98UNAUU=;
        b=E2CGfXfH964BZLjwmdzgVqaYXT3BG7fEoJkphZ6pgBwJdcWtQFjk7x4BGfE63BFRA/
         xMeIK5qPqNpMcYy/jZzIz60LATTWXEzSW3Tg5qn0btmIt6mLfLGPR2MSRjTRQTrErHK2
         vHS8/jdck4E/bV0xLuj4R8HBo0MC0qs+pLTQ6WvKQgQ63irqcRMWf2QpCXhGv4nmvsMT
         xq4mFKYRPzQTBy1MJJ1yckvL0rdW8z8qh/ir0YRMcl8ZbYKRnFLKRlJVGgsegZyRO8kE
         1UQfuoTs+Nrcni0O/bgJ0LJSZWWoP4NgrAGmgNc61nhogyeJVPjPuM/0VOmoNVWi4PBG
         zyfA==
X-Gm-Message-State: AJIora8TIu3ryNEjdMkKZAPM99Wpv7k6Y/pBKxUynLyf+8PXvdCbC9r/
        vBTrkQU3BsGIlJ/h0o52yDdxJiB7jIMtSgYy
X-Google-Smtp-Source: AGRyM1t7FtB00Y0DvB1zawcqNsUYNyKXrLFdTG6V+9CprD263LFKV2Droh55OHeKOHMJpIQ/qyICDQ==
X-Received: by 2002:a9d:630f:0:b0:618:da60:4c62 with SMTP id q15-20020a9d630f000000b00618da604c62mr777731otk.296.1656697555809;
        Fri, 01 Jul 2022 10:45:55 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id r16-20020a056830237000b006168bc4caacsm12955696oth.67.2022.07.01.10.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 10:45:54 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Fri, 1 Jul 2022 12:45:53 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 0/6] 5.18.9-rc1 review
Message-ID: <Yr8y0SYVXmzEDGmG@fedora64.linuxtx.org>
References: <20220630133230.239507521@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630133230.239507521@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 30, 2022 at 03:47:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.9 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Jul 2022 13:32:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
