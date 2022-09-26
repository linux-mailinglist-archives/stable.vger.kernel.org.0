Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6603E5EB2A0
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 22:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbiIZUs1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 16:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiIZUs0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 16:48:26 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4892EAB05B
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 13:48:24 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-11e9a7135easo10850004fac.6
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 13:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=K6v0/vgziQ+cKq87uw/0VRby7rDeuYWz4GmqNxiYxpI=;
        b=KDA5cNFkdA2pr9ofCfl5A14qZZJwN5L6pIuuciMjV5gIAjz4IlapIemDY2doQQzJMy
         6ioFDr1LIkei69OyYKq45IpjUHUr4AV/ray0s+scVirTXMkaONtWOt/Q9UCOq9+Ddq+a
         zWmf/YRzG4N8Cie5eL1/1M+Drgzc8Tqj2zJgU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=K6v0/vgziQ+cKq87uw/0VRby7rDeuYWz4GmqNxiYxpI=;
        b=zuhLVatY67h+Dg79oxm/hoGOS9+MPq2d9Aj26WD46Y+kMTGR/aifcqmb6fWbaOeAjY
         8kPGOzKF3jOQueuBnZ4rB7auiN6k/aJvvohCD1I4r5D/UQvGOAoOwlnEwLc0S2JzCF6d
         Sh/uvgzzhbVUDGWA9NpH+X+1tczsVBHWjTIPEmXV4uIYIqYztKiGrSAtwMcUMzWx1f1P
         rkhH+2xszCxnObjUf5kOKAOMKeDaryInORkAjbeg4oBbsOs4FYD4LYPgMRGonAYVT5HV
         TQTdIfKyILVWWL0sMmp7C9BDYreOe927TwzvlYkHhCtqYVi78Cwz+E96y64Xdk1u5PF0
         ymJA==
X-Gm-Message-State: ACrzQf1FBxiwa30mfOzBzlg1TRw0N6gvB2EkyW76GGLqP/wciEA4ZCID
        FW7kQwdA+l2o33EFiN5K3lAwVZu3fD5aIDKZrbU=
X-Google-Smtp-Source: AMsMyM7o1uilDp0u8x3/YIdfeSBJoMgihD/ajz9kIzH3ahz8qz13LW4dtpSmDCELokDIQkZ9QEG70g==
X-Received: by 2002:a05:6870:899d:b0:12c:5f78:328b with SMTP id f29-20020a056870899d00b0012c5f78328bmr340448oaq.94.1664225302649;
        Mon, 26 Sep 2022 13:48:22 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id x9-20020a9d5889000000b0063b2875246dsm8447856otg.49.2022.09.26.13.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 13:48:22 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Mon, 26 Sep 2022 15:48:20 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 000/207] 5.19.12-rc1 review
Message-ID: <YzIQFLKl7HT+m+wV@fedora64.linuxtx.org>
References: <20220926100806.522017616@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 12:09:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.12 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 10:07:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
