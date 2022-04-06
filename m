Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9EE4F6BDF
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 22:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235031AbiDFU70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 16:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234607AbiDFU6e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 16:58:34 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069821EA2A5
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 12:23:50 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-e2442907a1so3652781fac.8
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 12:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qOkCi6aBiGDNuil90fvbIVbrL6IcSa0yO6vUS1wbz/o=;
        b=VvcRTcX33AP76PhS9QCw6Mael2tfF4uBCzsjh+y38urQRPERv4w9KEsumBh9f4CU1M
         bPgGCRHGJKNY1RK7/nptKusGkKEzkoPYl479YrIa9NFGTrgngrYKtOZ2CEBgc4isltuq
         NcJMNYJMwef0fNL9xMxurQBhjq6jNXx3/H9rQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=qOkCi6aBiGDNuil90fvbIVbrL6IcSa0yO6vUS1wbz/o=;
        b=7VsxX3yzzOXaELo0MNYnUz3f39xjjpX7x59iLF4YC5maKmJ0Lw+UasrFNbVxgIqx0Q
         y5FwTjvkQrWF2S4jxZWkSi2eoaBvUbenbsgH+YOT4YioPkHh9TbCjZ9v5XwxkRgOPDSo
         Gf2ZazsXW1KatX9lqI9/CoKzP6hQowyUIAC80QpUAia3u6rLLqbpi82jjs02DNcLXTdx
         ZPfK7aCtNyulOem4WzdSvFJ5AL+Gglexhl5zpyLeZbePIBE2dB0QFki9nSYxSisOnUkm
         Co3oimd6M7fuM1fgL82hBASg9Yjj3bp9SOxuF4pmLwZmEBop6vIeLFf+gl4uNAEScvfA
         xivg==
X-Gm-Message-State: AOAM530ySAY+d3rPom6pZt8u7kTCdbdJ8+i+uiHzGhms/vfkqf+tm/Hv
        WukWj3YgULqOGsssG0zYliN5Zw==
X-Google-Smtp-Source: ABdhPJw5BfDj5IK8VYap1qNQKmFI6A86mQcaAfwliVH0VvwnHIvoFTzA4hdTv1Oj4uLPTxFi3jfBYg==
X-Received: by 2002:a05:6870:a68b:b0:e1:fde6:ba38 with SMTP id i11-20020a056870a68b00b000e1fde6ba38mr4659332oam.71.1649273029333;
        Wed, 06 Apr 2022 12:23:49 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id r82-20020aca5d55000000b002ecaaa13cafsm6755430oib.8.2022.04.06.12.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 12:23:48 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 6 Apr 2022 14:23:47 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.17 0000/1123] 5.17.2-rc2 review
Message-ID: <Yk3owzoZWLqdqqs/@fedora64.linuxtx.org>
References: <20220406133122.897434068@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406133122.897434068@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 06, 2022 at 03:44:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.2 release.
> There are 1123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.2-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc2 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
