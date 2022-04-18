Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB9A505ED9
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 22:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234421AbiDRUSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 16:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233242AbiDRUSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 16:18:47 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3368C2E9D2
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 13:16:05 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-e2afb80550so15363532fac.1
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 13:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jfTSvzLEsIFzIGEdPP77hzD9OrKunCJ5pKCIypKdvDg=;
        b=ahTXagNwJo70JaylxAX0XNNvg5yPuhHtZLp+npcHtRfQyz5en+ZC2yaG5EjR1FsTBV
         wrCGYcvWwl7m0QQ4SM6anG8U+ib15ydg2IyXgnj8C29rWMLduL4hztznkQsMPG7RLrxA
         62BoX046rDzch8H+qDTEoT5+krDPScFrYVHeI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=jfTSvzLEsIFzIGEdPP77hzD9OrKunCJ5pKCIypKdvDg=;
        b=Ou5T6ZfxusgBOXpdQK0Ul65IMsFO6l9pR4sJoBHdaXIfV13k/4vAMsNOkVhtUTPBFV
         92GilpxivxSzdScQrK6Q+mtywaGemQVSkIO4jjMHo/5LyEdVqssYQ4SWqRBuq5RfgWXc
         hDyIFN2qpMwe5U9E4defqdxjoi3S2q8OE3Gz8iOJE6dTIdMr7IrpsyEI7C0OWGMyzCoz
         /V10li/44HPQiaAiM5ZsmWowKOfRsHZ4fm6tOeos8hJ3cBkTtH+qqfn8kgD1xSZtvNmu
         elkQAyXvy7IdCiySfYpychIIg/U8QOnBm49v2sYnmaFqhINd+Xlks37zJvaVrY5Xyss6
         5Zow==
X-Gm-Message-State: AOAM533aPrQyfHbysmipJB0NNB9SDNPuyiLXZAg6QQ1305E8CvVGlY74
        lGpKyYOQeFhDFqfRGzvFooo2Kg==
X-Google-Smtp-Source: ABdhPJz2dYbMmK/Jx8T3ha2lBlZBZHo/j7P2UruqgSIgdYeFsWTf8S92eyUV3SikRkKWrO0FS/OX+w==
X-Received: by 2002:a05:6870:c88a:b0:e2:125a:809b with SMTP id er10-20020a056870c88a00b000e2125a809bmr5003775oab.242.1650312964462;
        Mon, 18 Apr 2022 13:16:04 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id l33-20020a0568302b2100b005cdad9100desm4734175otv.40.2022.04.18.13.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 13:16:03 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Mon, 18 Apr 2022 15:16:01 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/219] 5.17.4-rc1 review
Message-ID: <Yl3HAf+YuKL1F5hH@fedora64.linuxtx.org>
References: <20220418121203.462784814@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 18, 2022 at 02:09:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.4 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
