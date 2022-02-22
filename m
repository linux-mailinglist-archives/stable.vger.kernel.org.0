Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C745F4BFFE4
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 18:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbiBVRPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Feb 2022 12:15:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234284AbiBVRPH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Feb 2022 12:15:07 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE83B108568
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 09:14:41 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id d134-20020a4a528c000000b00319244f4b04so18495058oob.8
        for <stable@vger.kernel.org>; Tue, 22 Feb 2022 09:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iyJvWO94zxROKCAmWW+SeGmGl7pyXuanhPRu1GuYlqk=;
        b=deN0CXKmYJ6Z0HCrcZ1jVjxL1B0mDKtr8uPIq2rQnMalAWgW7Kx7yR17vydSsbhdG9
         EmC+ZSHlcYRGl/BclXjKo/oJCCREZjwTX1GvmbeUJ1FdlwZlvZSwImYl/cA6pg88Th5c
         Mo+WL9VJt4au2dcu7VZP6wXD6Wk/mjEzu0aVI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iyJvWO94zxROKCAmWW+SeGmGl7pyXuanhPRu1GuYlqk=;
        b=PvcD2nuL0Q7Y7EV3P7+AdlsaOgnAxHKhr9K1LkBWG/E2Kb/6l5vxZSdIgVBjIVt5Nc
         Kn4G7uq2GUg/ZKCAWx0hDpkkrI2YeL5LKvPvNUMbFMSHi6CmYT9/ME3g5Ctvwe+Bmt6G
         0YKqaK5Oa819ykCxSrZmvcdW20EJz1KeMP/blORn4pClhUdvxeRIV+16C7AbZAxQGQmN
         sYby7p0YtdXzZKAYr3Ez7L3msthKCjEYApQzkX9Tlkkn2hB0Y3s0nOoPeDbN3OvVTvDs
         p1P7Qh71gPjHB9l41C4tqCSi4eRsnX6ZZEmzpQ5Wi8LOPSXg9g3KIqW59Mu97c6vXS8e
         HWwQ==
X-Gm-Message-State: AOAM532Td5FSA5HtBUIKbBgpsMw7qH3/ujJqyDSnMagI34IV+a/Ytttl
        2Ye9+sS5co91/nXeg2nTHvZAPg==
X-Google-Smtp-Source: ABdhPJyi3s8+tDXRwUA4wJeKROW1T9avDWVsehpfFDzLIK7l2lGhRxmvn8RbkOAvCnGH0iSSm81kFw==
X-Received: by 2002:a05:6870:a68c:b0:d0:efe:5b92 with SMTP id i12-20020a056870a68c00b000d00efe5b92mr2059794oam.207.1645550080720;
        Tue, 22 Feb 2022 09:14:40 -0800 (PST)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id b8sm16436889oae.30.2022.02.22.09.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 09:14:39 -0800 (PST)
Date:   Tue, 22 Feb 2022 11:14:38 -0600
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 000/227] 5.16.11-rc1 review
Message-ID: <YhUZ/v4DeyH3BO2V@fedora64.linuxtx.org>
References: <20220221084934.836145070@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022 at 09:46:59AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.11 release.
> There are 227 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Feb 2022 08:48:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
