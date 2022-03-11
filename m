Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFAB34D5666
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 01:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243503AbiCKAPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 19:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238512AbiCKAPT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 19:15:19 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7E3A2517;
        Thu, 10 Mar 2022 16:14:17 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id p8so6498474pfh.8;
        Thu, 10 Mar 2022 16:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=zbX83z35j/rnQDfABxGE7445I8A/z79BcW1OI6aapq8=;
        b=Ey1EGYpMHaPe/pbpGgf2hpOAvp+TAa8DzhC7axztR4iP9Gxyi45N0oqSvmVlvD1XFB
         0ceshw377pNwIjUkEHxONEfgKPy2di4NbJvBgwPqDkq4Id8pLlZBXVoh+jPubThNnsru
         vcXSFD528ImogR7UTU9IRISMBu6MLeKYQIof0MnR5vTVCw0eDyrtwuSRkkpL9X0oreB6
         ilGG0t5PQeYb1zSH3NNDjb3uLWX9c2biTk1uu9C+DbOVUkDaPOxAXZu2jLbufehqTpQ6
         iF78Ds432Wr6iUz60DatqkcDRi5xw968ekcTco6XAdMciIHSh3mSpa/ud5ge5Q4MRPAj
         ALEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=zbX83z35j/rnQDfABxGE7445I8A/z79BcW1OI6aapq8=;
        b=eo0ozxV3/DXSxzdT5NukZmufA/aaR02vxVS5e6dpOk+ptM306impYAfZMLJIy2xniV
         OVdDKmpiPaihH+LJQfqc/UgtflDk92Dy4scfNaMnT7nvlRctSbh2tlraS9SqLeCnqm4v
         H9UZImA7hZVYwFaZecIefwTQOEGBkN0xb5Bd6ENbhLfrmPl3rybneQMX6sbNayUjQipZ
         CgBXff4RDwJQoa8+ydDrIA1QAbXg2m+Exg2q245c+Zbx3mdedV2rBxkh/LHQMdSsqrUA
         6pkZR6ZZgkyAAff5KetFwckgDk1oMVTZv0K+5e80JNNDwJ+MlSMKwt/C6+36LjF7dyyA
         IPEg==
X-Gm-Message-State: AOAM533/INple+3XYWg2+vJI6K6v7T3tKn6WFvuKdKoG2IuGoRL6GPSI
        uEZTKuM7MlTyiQp+0YWcyGLOBxhexeEChc/pnBeaXA==
X-Google-Smtp-Source: ABdhPJzbVZ4TiwTU+xGJ+q/45X8ZjZzzeZCiIzrsGKi7fXzTwr3R/XiJWXVLUV6wfmhlYm7z7CaA6w==
X-Received: by 2002:a05:6a00:1694:b0:4e1:9050:1e19 with SMTP id k20-20020a056a00169400b004e190501e19mr7577766pfc.72.1646957656492;
        Thu, 10 Mar 2022 16:14:16 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id x9-20020aa79409000000b004f704d33ca0sm7849248pfo.136.2022.03.10.16.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 16:14:15 -0800 (PST)
Message-ID: <622a9457.1c69fb81.37f28.5250@mx.google.com>
Date:   Thu, 10 Mar 2022 16:14:15 -0800 (PST)
X-Google-Original-Date: Fri, 11 Mar 2022 00:14:14 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220310140811.832630727@linuxfoundation.org>
Subject: RE: [PATCH 5.16 00/53] 5.16.14-rc2 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Mar 2022 15:09:05 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> Note, I'm sending all the patches again for all of the -rc2 releases as
> there has been a lot of churn from what was in -rc1 to -rc2.
> 
> This is the start of the stable review cycle for the 5.16.14 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.14-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.16.14-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

