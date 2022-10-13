Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 853E95FE3C1
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 23:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiJMVH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 17:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiJMVH5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 17:07:57 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FA3188AB6
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 14:07:54 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-134072c15c1so3791235fac.2
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 14:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AVEUKlqWo2ttd10gQh3gawam9X0cvCfnEg2BZkSEor0=;
        b=HJeySj+BDWcYJMKmqAj4xZ2JSfBiTiBaTnEUBFY83WIfVa+3LzILeNtjf8pXD9kyJW
         RvoW3x3MlFnSKRB6GfX2xAKb4mEQKOZFvsVq2Dr6ZzPnSSMdDSIix9tVpECs37Wr/UEW
         wyWklMlNOJCzxr4ZdW2EC+DkqBcPiic1kh/JQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AVEUKlqWo2ttd10gQh3gawam9X0cvCfnEg2BZkSEor0=;
        b=NJZL/82E/AePNSc2BdkKzBstOCq9bocdQFC6ECaigOHMiqkWrn76BRit2u4hLtm4c5
         BTsoUJ6dvMnMKYinJueDV5xf6CshYPUQt0dQ4TbOMXUzxGfGujuuTQbLNHemmXrIlNvq
         GwxiG/KWA5rJn6tgmasQ9YBB2Ev1o0bETls2vP82vLlMa5jCMpwP1NmihYCUbWI70DWr
         QPpdjSCpJZyTpg5FyA8wTMR0O+5DvkxdJ7//nQJl20Ro1l5V1XaWzagnKHGLF5rgFjr6
         OzAjALD/93lXAU9kwTOED/yr+vAzhUw+8B8iWI8CSzzyhkhcEzk3iBMiEtDkpnAanar1
         1rhw==
X-Gm-Message-State: ACrzQf1BTtCJayQTH2fg/jJurUnbtwtZcZxzuSuXGkdWg+GnRFKY5og3
        NKBgukHEa7/E4pFSpHxwudraMg==
X-Google-Smtp-Source: AMsMyM4xBIf6fZEPKvGGyT4fORjzrVpM0TNb/dbjVSNAoLpFpy/MJCYEdG2B8VpeArgPwDqIuBOzAw==
X-Received: by 2002:a05:6870:d1cb:b0:12a:e232:688e with SMTP id b11-20020a056870d1cb00b0012ae232688emr6604562oac.24.1665695273421;
        Thu, 13 Oct 2022 14:07:53 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id e24-20020a544f18000000b003436fa2c23bsm352449oiy.7.2022.10.13.14.07.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 14:07:52 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Thu, 13 Oct 2022 16:07:50 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.19 00/33] 5.19.16-rc1 review
Message-ID: <Y0h+JnZVQ3Fk3UTw@fedora64.linuxtx.org>
References: <20221013175145.236739253@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013175145.236739253@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 07:52:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.16 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.16-rc1.gz
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
