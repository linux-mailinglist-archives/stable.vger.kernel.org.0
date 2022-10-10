Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B575FA1ED
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 18:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiJJQ3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 12:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJJQ3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 12:29:13 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AA51C933
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 09:29:11 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id m11-20020a4aab8b000000b00476743c0743so8292573oon.10
        for <stable@vger.kernel.org>; Mon, 10 Oct 2022 09:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+2uYq3tgp6/J4DBIjupnsIzkyc6wJWd0bWQW/BTTTME=;
        b=ibkfke7+fgDqLXAvl6MK4j9UaJNQrz49j792Px4lUPBv4WIgPwzgrJUNSQ06WfWWVd
         eMPHE94SSfAUxG+l3ftKsng2bwFTeHrnMZVlMsVsI+lwdMFeBgJicd+7pXX+b8o3nfxN
         f5V/7p/5moQhhmgNvVjGXTn47TPwxZ3A8e2l4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+2uYq3tgp6/J4DBIjupnsIzkyc6wJWd0bWQW/BTTTME=;
        b=P+NrW/K1m48/9KJ1rpTn8JGzn7AjHGjJbcxqYzEG2MVRthlpVAsQKcHU9jkkZdwZ2N
         67Qa3szviaRK94v6jt8hi5OR7BT0piAgs3SVe9+ZM8Ti425L2vNxYoUbc6mHEcpm9tY9
         Gp5bQlxtNN6RW43sW9ELhEtD4EJnmXixRHQgHuOA/gTBxjoge7Zt5ipB3ZA+LTf5lNK2
         uqvLtikR70EbWVpsNwoNydCRW2MXYHDNk6naYFOfiQwQOmdZpq9Lk2dho2f2P2wpEKgm
         ZItdzZtDFK2JFLQ0ZUeiGms2+ob25mVK7QctxU6pKbyvvVAk4da9f21jl2vQ22pjCuQQ
         sN1g==
X-Gm-Message-State: ACrzQf131yiXRrsG4RI5cRXtRd2REUsa2URDdSH+VVTEz7b6lDCY4+Vz
        FzggMVHduujqp72f8rqVLubmuQ==
X-Google-Smtp-Source: AMsMyM5QP7cdwrSX/yV35weHhtAm3JF6qMYzIFg4BZI3GkFSvPECEJzVgrZVDmzpYaXWKOr0I7UccQ==
X-Received: by 2002:a05:6830:4191:b0:660:f2e9:a775 with SMTP id r17-20020a056830419100b00660f2e9a775mr7967009otu.268.1665419350429;
        Mon, 10 Oct 2022 09:29:10 -0700 (PDT)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id r14-20020a056870414e00b00127a6357bd5sm5271549oad.49.2022.10.10.09.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 09:29:08 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Mon, 10 Oct 2022 11:29:05 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.19 00/48] 5.19.15-rc1 review
Message-ID: <Y0RIUa9e7R5lc5px@fedora64.linuxtx.org>
References: <20221010070333.676316214@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 10, 2022 at 09:04:58AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.15 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 07:03:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.15-rc1.gz
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
