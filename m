Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6006661D2
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 18:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239073AbjAKR36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 12:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234534AbjAKR3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 12:29:32 -0500
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A4E395E4
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 09:28:17 -0800 (PST)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-15b9c93848dso7967290fac.1
        for <stable@vger.kernel.org>; Wed, 11 Jan 2023 09:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u54AezqJjjpM+HGr4IJs9A+cPR+RvkDqVZbwor81vek=;
        b=LAPsO9RurEB0r9THrmxm35xrP8vycJrtwQDDWQYt68C1TFRc9uKOfrPgCC0/xvGF/K
         j4h41s9nRZDT44jVc9HBVh3hSFEE5elJV5BFIA+Ij4kAkkPPN94wMfQD9Op/QolgYM2q
         wk1g+HG1Ti5OoEOb4bBIKwwWslh6Ypfeja68c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u54AezqJjjpM+HGr4IJs9A+cPR+RvkDqVZbwor81vek=;
        b=ikJaejoDNnuh+uZSnVWGfswzzpbNyplbfJM/z3s5PVROXjJeKgkQjH+DwtokWx9CEr
         r/AsnTG7yY1OZnRlBxpMc8ng1rcAeaqiDH50czJA9vTYPFlBNMco4V8kIou6x3Y+/y0z
         0CLSpieEsW32aSG0V6YkKg2FOQZJ3S4jJCLylNByxFnu1D0Rkwp7ti0e+UQ125He1jSi
         oDWjcr1okVLyrS/kpQrMi95PhDxkvtoj5ILaXThbIPCe3+NKa/q46C3tL/ecqkN6fDft
         I0Yc/U39Genfs4+gv3+eZr1CEdpJfweM5j49rZBCP84017BZl9/R0whcwCw5W86g+s7N
         rZ1g==
X-Gm-Message-State: AFqh2kq5DUhOuQeMzoVWCpODwPKWQ6rWMUq4xN4RE4TR/WsVY+EK8FOa
        Vphu4c/8cl8ylYpL94HYQx5mVQ==
X-Google-Smtp-Source: AMrXdXux1df1fFmYjJ7Bb6xj79MJxEeW8UUn9KvAGsRK1VijyG5s4AkNRcRQyVoNAWocXDr3l5vyWQ==
X-Received: by 2002:a05:6870:5b85:b0:14c:7959:8c2e with SMTP id em5-20020a0568705b8500b0014c79598c2emr1742032oab.2.1673458096651;
        Wed, 11 Jan 2023 09:28:16 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id y9-20020a056871010900b00143065d3e99sm7638241oab.5.2023.01.11.09.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 09:28:16 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Wed, 11 Jan 2023 11:28:14 -0600
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/159] 6.1.5-rc1 review
Message-ID: <Y77xro03HZe/+DyP@fedora64.linuxtx.org>
References: <20230110180018.288460217@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 07:02:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.5 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.5-rc1.gz
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
