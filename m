Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF344DE45B
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 23:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241421AbiCRW6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 18:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241418AbiCRW6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 18:58:11 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68062D41F6
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 15:56:51 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id z9-20020a05683020c900b005b22bf41872so6503762otq.13
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 15:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PLzyPUSjfo0Qtpj5gmZd3aXs/ZxVVAJIrjiNg+OPCHg=;
        b=PWzsIQQCIcyveMJ9nhBODeJlRKnFyQEWhF7OC2D7N/QJkOdQ6YM/fOulb4LMqr/d+Y
         h2mK0uAXa4P+LglwFvAmALzFBYaR1c61ZVS4w18xGGfbSeb8ia4nzQmW6ycemHJk0/hH
         eFzCqha6TMLWYSgWiPBOObHDZFBVBYyKX82PA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=PLzyPUSjfo0Qtpj5gmZd3aXs/ZxVVAJIrjiNg+OPCHg=;
        b=ep6On+vob/Iukq45RrWbn7GcVaLtweF3QcM5nlDWqSbRPuktRweD20YnLLsS9CCiPR
         usAU43RmyE+6YbciNuAvsHbDpegsf1seKMqUHu1YJyHmlxxa6utfumdF4re2MCSy7Ry2
         W+J0i/102Ejd182QcTzVMQe3XxHx4kF9BHYcLE8KpMZmffurXawIXZRWWhBdX4C2/HaY
         HIdg8k1Q4BB+REVnSo7+LKB7ZVCHCoXwBX5fzcCtkFW9a0sxTluui9g2RClSf74rC42N
         7Okf4NudU+nKIIZPDpvmyXQjyxuF5+3IuyUC1eatLR65aHBwqTL4siCmy7ytYkjrk/+J
         h+vg==
X-Gm-Message-State: AOAM530+IG/qude/nNaCP1/ng3qnb0OyAF8F6LXp1AZiAkcKGvfRPtw1
        HWuBo3CrQ7ynzXD/+ye4tmfXQA==
X-Google-Smtp-Source: ABdhPJy4i5EDcsoUlN68saZ/09C4VCIsWJfAbzbGOa4yNvDkoFlpTvlK83YrW3J05AREmJlmyQVRGQ==
X-Received: by 2002:a05:6830:34aa:b0:5b2:613f:5523 with SMTP id c42-20020a05683034aa00b005b2613f5523mr4153857otu.40.1647644211102;
        Fri, 18 Mar 2022 15:56:51 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id 89-20020a9d0be2000000b005ae194ec5absm4316722oth.15.2022.03.18.15.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 15:56:50 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Fri, 18 Mar 2022 17:56:48 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 00/28] 5.16.16-rc1 review
Message-ID: <YjUOMF6dvZ83YhSl@fedora64.linuxtx.org>
References: <20220317124526.768423926@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317124526.768423926@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 17, 2022 at 01:45:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.16 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 19 Mar 2022 12:45:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
