Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B8765EF08
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 15:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbjAEOnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 09:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233408AbjAEOna (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 09:43:30 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15CB1B9FC
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 06:43:28 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id i127so32142212oif.8
        for <stable@vger.kernel.org>; Thu, 05 Jan 2023 06:43:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EdNIzr6K79WGrUyV+pZ/Ft7qJJmll5v3NGysEKK7sJ4=;
        b=hV/gs6uGEhp2/BqwXHHWgvEpjroUzlbH5ZC972vJ/UcAIGkZD8KViT/iwG7m9ZfKVL
         4p9k5lNOY3ZDmRf517hnQLx9WH5EIK2P2gDAOBbbOlFc04N54f2ZwtvGyUfWfQUcuyUc
         lMnhJ/6husUN8ZqIPXO5e6DdPwmB40nz/jetw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EdNIzr6K79WGrUyV+pZ/Ft7qJJmll5v3NGysEKK7sJ4=;
        b=EwWt7iJtlMxNcgSEDIfQ4Q0bgXin/0xtiUJO4lS4E8R3/aVuZm+jVEF2omOIlLhwjo
         HESEngiGXUuzLROZsb5ocuhPQgivfSTt/rT3pEYMqOsQ5ZDl5UR7PHAAwu8h6F61hcTV
         0xpsXlgiOLImpQ6XGDmgDRAPlWhbABLpzlH8qnr7UlCVMRXsuOVi0ncZTWrcvXlQuF5A
         3/VvGs3Zq1oYJPpk/HiRga98v2Tl+6UMAGPUd94oTShKDMpS/1VRkKhwxUlgwUKLNw1E
         7kBoq1F4rG80Jk1FePLkw8xolawRsEocYyGdWMt/FPtNXQ4Sae4TCZYQGAON3anu3yTs
         mzHQ==
X-Gm-Message-State: AFqh2kpb6sTiuzhj+eg2Wic7zcuhu1cvS6xsRCPO8GutjSeimOC5LTCU
        9MLRGJcpFUgi/uUTZSwccA5SLg==
X-Google-Smtp-Source: AMrXdXs6IuHALNc2iJnYamsaDTWMfvdsNhCSKvmYJvtEl5OJreiggIYBSep+IOTVbeYybTh5KI2NKw==
X-Received: by 2002:a05:6808:309a:b0:363:aeff:9969 with SMTP id bl26-20020a056808309a00b00363aeff9969mr10397466oib.13.1672929808065;
        Thu, 05 Jan 2023 06:43:28 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id n67-20020acabd46000000b0035b451d80afsm15375146oif.58.2023.01.05.06.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 06:43:27 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Thu, 5 Jan 2023 08:43:25 -0600
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
Message-ID: <Y7biDVBJ9ZR8BSfk@fedora64.linuxtx.org>
References: <20230104160511.905925875@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 05:04:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.4 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.4-rc1.gz
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
