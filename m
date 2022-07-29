Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE0D15852AC
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 17:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237297AbiG2P3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jul 2022 11:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiG2P3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jul 2022 11:29:40 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33ADA66B8C
        for <stable@vger.kernel.org>; Fri, 29 Jul 2022 08:29:37 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id u9so6091495oiv.12
        for <stable@vger.kernel.org>; Fri, 29 Jul 2022 08:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LUOI72qEDQxm1rvXFiN4dVLMwsuuFVOA2VC1CbACSkM=;
        b=ROZ+R3K4RAhClh7B4NyFYoHqEhE84TrndAVBxDYXYiBcdgkTomNSXOZRoAdhT+gMBs
         +QBNmoujMk5nr8B0lT+D/lOhPT98pMro2X0TWUiEVPSBP1PhluhN/EJwot4kF6TRZdSy
         KI3syoXx2pvbMlvzPIHqvEm3r3dYDTgWjFo3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=LUOI72qEDQxm1rvXFiN4dVLMwsuuFVOA2VC1CbACSkM=;
        b=m7yWW9WBW3hCPCQ6SzROlNIMtY4HjRmXRrMA7VL3XFzVUBoDHu5xNuOM8OonZg/IHu
         0JMQGtZ46lx0MT3XsVIxhyywDEFw7cySdBTQLC9/+JzXAH16Y1E8yoMTNjcJXRVsJ2wa
         Jndiwv+vI5TmkbK142icbXu6wWW16om/yHB67zEcWVohFAQtYSPMknZodpZA3+3gpkw9
         G4YFxmVLGyhyGV86C0uLB9aDLGDpOHhCz9Feyq2SahAYcw53Be0RAC4mfoHmFbS0FnWa
         KJf8GcOv2gXscKthDbR+RH00N9d6jrMuk8CRA9pHcTZZ3mpIUL/5SmpIdF+dEsZdKujM
         LJwg==
X-Gm-Message-State: AJIora9MdEQbi00SoDNDK0lP3mTDCEnReeIqiZRekA7D9f08FdRuu3jY
        sFbKq3cLKzpjmnwWb3djK2iiZg==
X-Google-Smtp-Source: AGRyM1uyxVrEmyUV0wJHweS5SV8xFQfE+l6ZeH6uwRIJZu4wB5OmGAnJBCePUoMV0LvlwQOid8f1Rg==
X-Received: by 2002:a05:6808:1492:b0:33a:7448:8b98 with SMTP id e18-20020a056808149200b0033a74488b98mr1865351oiw.92.1659108576511;
        Fri, 29 Jul 2022 08:29:36 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id bj27-20020a056808199b00b0033b14822f48sm1195002oib.35.2022.07.29.08.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 08:29:32 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Fri, 29 Jul 2022 10:29:30 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/158] 5.18.15-rc1 review
Message-ID: <YuP82nauCY0Ha2fe@fedora64.linuxtx.org>
References: <20220727161021.428340041@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 27, 2022 at 06:11:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.15 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.15-rc1.gz
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
