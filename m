Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D46353D944
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 04:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243475AbiFEC3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 22:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234978AbiFEC3K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 22:29:10 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F9CB7EA
        for <stable@vger.kernel.org>; Sat,  4 Jun 2022 19:29:08 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 187so10088493pfu.9
        for <stable@vger.kernel.org>; Sat, 04 Jun 2022 19:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zmwdrkPzXm2zLB3I7uZQ7LfidxYJeRv45MlnmEANwf0=;
        b=nM+7bl0MGWutSe4tVSUsRTw7YIUHpQZNgWaltNcBVYw3GgpwA5HJxrSpH3VliKHzxD
         rfdvNh5gWHqdZLrV+Vj+DAvq5/rDUk4050PDiy9JlaMbku9TWTZ6dQwiR0yiRSHjPytq
         GgZsDyEgsoLMFtsgUVVscWBv41frnttpPm6uI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zmwdrkPzXm2zLB3I7uZQ7LfidxYJeRv45MlnmEANwf0=;
        b=FE9pkLdrG+ruUDWWOE02KoeyqzyP0aiaWzW/Zy0dLC5TZdxldLiaQP4ORJ2okYi7wm
         rrO1r/RG0Lyk7/9FpCzCmLPG7NZXQYmBynnyg8pm0btuFyZkjPGMbn8SpsTwOePC9YAL
         OzwtunfUYgE5WNuaQJW9XW9jtyuVZtnOA4WRmRNQZuwBwCuT99jVfmLtDGJfVKwqTwp3
         7OfjMmbht0So2jTaL8t5+fvn2Er+wNkEW9atjZxnE3wtd8nQvyyJx81hvI0N2o+jQ1eW
         jKXqdYngDPCiXuYfyNYgaVVJO8Bhxp9fnRDs2NzlmeE59bQiDrnYkJAMujOSkV2EM8bJ
         DLRw==
X-Gm-Message-State: AOAM533LEqOWHk69zAHMW8CmeLtcA9H3tLH84Rk05FaINm5UmUKFnXG8
        83MCLkCt7nexYkMidCfBEAYXZw==
X-Google-Smtp-Source: ABdhPJzCabmTySI24zEKZU3PooLkghD1bASDtXXDSHebcJDIFw13F7zEojNDmMRpFd5hFwQTxLAdzQ==
X-Received: by 2002:a63:874a:0:b0:3fd:3e1e:ca7f with SMTP id i71-20020a63874a000000b003fd3e1eca7fmr6980470pge.229.1654396147648;
        Sat, 04 Jun 2022 19:29:07 -0700 (PDT)
Received: from 1144aa5e55ff (194-193-162-175.tpgi.com.au. [194.193.162.175])
        by smtp.gmail.com with ESMTPSA id q5-20020a17090a178500b001e3937f21absm7566873pja.19.2022.06.04.19.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 19:29:06 -0700 (PDT)
Date:   Sun, 5 Jun 2022 02:28:59 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/67] 5.18.2-rc1 review
Message-ID: <20220605022859.GA7@1144aa5e55ff>
References: <20220603173820.731531504@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603173820.731531504@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 03, 2022 at 07:43:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.2 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.18.2-rc1 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Tiger Lake x86_64 (nuc11 i7-1165G7)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
