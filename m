Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D85EE64A7E8
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 20:07:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232930AbiLLTG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 14:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiLLTGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 14:06:49 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AC92DE6
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 11:06:46 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id q18-20020a056830441200b006704633f258so7932155otv.0
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 11:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bc2DPrk+jmvIB8OtsNO1XeEuDilKuTsyr5RnoWNLVIA=;
        b=eEIOe6BJqa5uLynDP14d9654wXp1J0S5TkCOQQ2gjQ+fnIii4aYlovvJ6/HlIXYiFX
         TuBCjt689w6EwitE0MRDKTSzpnQOM1yE99H/ryU3Yuhj6BhyTawgvyEuDWj6Bx1e2lOD
         9iRHncaA+ScI85bta8K1PTXz8hOJtxV/6dV1U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bc2DPrk+jmvIB8OtsNO1XeEuDilKuTsyr5RnoWNLVIA=;
        b=KUMkdpKnkU1R2siAtt5bKzTJ2Mrb1FUGM4ho1EXQMBhXMYWmX/A+PFJ5mbzuV+HwGi
         dhSZtvtJauP4zd840EsIovJG7q7CkiHq38EYDkVQSaVCSKUyA+y8Co2WP6bWVpogyxBK
         sfQ/GnMxgHxng3ACNUZ8Ywc9GisQti9mn1XIu19nqou2IF8ZSiuomKwSro+i9RXuDedp
         3wYieMrJzCttJVx6oKiku73jyZ/IpS/huqbSv4r2DEdXMJyxl122yTKzGmdzBdD0opix
         R6Of/+UJMkKuY1Ay61mGMcxma68RnHiP7eV9+s0In/qdfpJsl3J3fx65zaoWbkej+vyk
         9gSw==
X-Gm-Message-State: ANoB5pnMrtCx8eDcLVbuFW2Rq1G453Y0LY6/9SiTlWqlpSK932gAi5nD
        INlXQjlkv0ofPRmK1pb1mi1JJg==
X-Google-Smtp-Source: AA0mqf6uTZ+e6jCs1WM/4Cf7QSikBIfgshTVvf1Bodz84WQeHECU3VgpoGsYu5W0f68ZVq2P5icfQQ==
X-Received: by 2002:a9d:178f:0:b0:66e:6f72:dea2 with SMTP id j15-20020a9d178f000000b0066e6f72dea2mr7866951otj.30.1670872005662;
        Mon, 12 Dec 2022 11:06:45 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id w5-20020a056830144500b0066db09fb1b5sm258171otp.66.2022.12.12.11.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 11:06:45 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Mon, 12 Dec 2022 13:06:43 -0600
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/157] 6.0.13-rc1 review
Message-ID: <Y5d7w5OMUtKz//jn@fedora64.linuxtx.org>
References: <20221212130934.337225088@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 02:15:48PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.13 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.13-rc1.gz
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
