Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271454D1943
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 14:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347117AbiCHNgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 08:36:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbiCHNgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 08:36:47 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB5B49697
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 05:35:50 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id x8-20020a9d6288000000b005b22c373759so5445744otk.8
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 05:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sapYZn40XqGnCxtzZFL0A3BdfWE1Z9XMUbpAoFl1KmQ=;
        b=MYsZtHctpn/h38nYRCf+ojO4Ao1LpNMVKTl8oo3cLqgKRMgdKRfD03GtnKhMomfmHx
         JkitXkcpxu3BzL74apiqvHfpx21Vm5DPEoeGpJs0r4KTtZcWLikPqhaLR97PQce1Ny8W
         TyjiTaccAu4ZL6BqX+W6hBy3bkTFqzO5Cmgm4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sapYZn40XqGnCxtzZFL0A3BdfWE1Z9XMUbpAoFl1KmQ=;
        b=Jfb9tKC8gqdDLH5stykmXAYek9k0MJz1THNvDrlBOVtla+XSVsMop3R2OkQHMbCGIV
         DKGl7I0CsFY9le4dJoZUBsRotBbooefsJXGjfSmii0bgeRPyFc4GeRRjSo92YRkeuTcS
         c0DpWpHFgYkR8HRumANmYDatFEUX5ZPyJ0tFZX1XSjZyaFNR6GmJPDXtgXh1MeFytBAu
         wP7jr2oO5GBrC+yxV0W0irheXRBl7Ljg1UT5UKqcxc/mNcCaiCpeNHT3en+qKuBwWQ5I
         kVzm0kcjliwIm0F4qEIAChzvaeB+z6rX4yKT0ZZ+XXMiGcWxU078fe1TwRmQvpeiaoNu
         RO4A==
X-Gm-Message-State: AOAM533uQN+40Adcyra/BGLKkaXUvCI59kk1nNAth85io+gCRwwN92Pi
        DLVDfXIl/wnjnLTAYftfpG6v8Xn3E4YL06H1
X-Google-Smtp-Source: ABdhPJy4WVZ4+JOObzkLMqzdI0KNHssS9/TrxwHgtTjA7Sz8W44I2rFN8lf4/0cX53oHmGAYJBx3Tw==
X-Received: by 2002:a9d:8b0:0:b0:5b2:387f:efb3 with SMTP id 45-20020a9d08b0000000b005b2387fefb3mr3950678otf.12.1646746550112;
        Tue, 08 Mar 2022 05:35:50 -0800 (PST)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id m17-20020a0568301e7100b005b256697d7csm350907otr.72.2022.03.08.05.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 05:35:49 -0800 (PST)
Date:   Tue, 8 Mar 2022 07:35:47 -0600
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 000/184] 5.16.13-rc2 review
Message-ID: <YidbszfvDiPbArGJ@fedora64.linuxtx.org>
References: <20220307162147.440035361@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307162147.440035361@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 07, 2022 at 05:28:30PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.13 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 16:21:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.13-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
