Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE3F66D40A
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 03:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235212AbjAQCFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 21:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235208AbjAQCFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 21:05:44 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319F5234FB
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 18:05:41 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id p17-20020a9d6951000000b00678306ceb94so17110790oto.5
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 18:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gt3lu2Eo9scEd1w/hLxcrFCpQl1y6EBw4SedxjGpoHg=;
        b=hIf/bK6KpisdKpn0lutY+ug0qSbaAr90xwrHnj4VQRtv4Pr7phmV4mZxbmi/2DPfkq
         sRr2eLSJUfgSAp1DCLEPmyRCqaPql2N3rhvL+Gxdtsr3P2s5/PWf1jBqMAH9H19dEVqM
         LX89U7iXfVS9QTfaj/MPzamrdXBz/0hGEnCWw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gt3lu2Eo9scEd1w/hLxcrFCpQl1y6EBw4SedxjGpoHg=;
        b=G5rZpE8L/aEubluejZl7G0bP9nvot+1i36edTykDjA//vJkzl/dlRPCSEa1RXCER3A
         +Y7nKqmNLDjoZA26UCt1xVXwfJleEAhBqdByT020B4aPuH6zhsc9qyEercdWm9SELAgW
         EGiCQ9S9x0Pp9XqO2XiHyD+qnFSphmGxT2d0vUiP6BsRKnvAlhoLGhG1GoFkwmo/cYIF
         yhvFH2/Jjr1PV6fcY22WqM/93jZdwVHq2/s/yKNSUhSrciVUyZ54fHTxVlTkArrb3Z8J
         u7FT0UQSX4IU87smaBBzmCWXhdB0dI5+zq3uOP6e/vK81eqLLsZNGrLCiUph+xIgjcTh
         qLIw==
X-Gm-Message-State: AFqh2koD1rE+IiSdpwoWxo2xVv8AUIt4+Y1z67tFAlJTlqrx1RuzerQX
        ytoKsKr07TYZssgHeBnXApd34Q==
X-Google-Smtp-Source: AMrXdXu80sZ8VGqMOHuCEol8vjyQr1hDeoh+HypB+EmkOjHM1dNyPMRxPszGClP+QDnZNueqcHWrYA==
X-Received: by 2002:a9d:72da:0:b0:670:a09e:c7d2 with SMTP id d26-20020a9d72da000000b00670a09ec7d2mr12981255otk.30.1673921140445;
        Mon, 16 Jan 2023 18:05:40 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id v4-20020a0568301bc400b00661b46cc26bsm15400639ota.9.2023.01.16.18.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jan 2023 18:05:40 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Mon, 16 Jan 2023 20:05:38 -0600
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
Message-ID: <Y8YCcn1aLoFqI7SL@fedora64.linuxtx.org>
References: <20230116154803.321528435@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 16, 2023 at 04:48:43PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.7-rc1.gz
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
