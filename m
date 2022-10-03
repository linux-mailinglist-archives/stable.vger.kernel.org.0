Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC3F65F3606
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 21:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiJCTCU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 15:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiJCTCH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 15:02:07 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DEE2CE2C
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 12:02:06 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-12c8312131fso14078071fac.4
        for <stable@vger.kernel.org>; Mon, 03 Oct 2022 12:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=DaGwZX9LcSjLClWmUN+1ijO19QLFnhodEz41C/aj6Kk=;
        b=Oe2LW38CHd8hiH04XHaqcbLV3SHXbcuU9amClQbgmSbBwW0B506EUFH+yFeZzLw0E9
         8ualGTGTkFk+5ALvo6GVKCZEisOsLHcO3OI4L6sGW+Cg1ewrDALzU/IxiR3qwafsa1AI
         yZY0lS6paqW8Aps/i68YTkcH7iGPcRa37bnek=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=DaGwZX9LcSjLClWmUN+1ijO19QLFnhodEz41C/aj6Kk=;
        b=zERTvGtv+BSanaMioKySEZfgMcF3GdU+dTlguGbc86I/fA+p4P8sI7duV9tfYa7nJp
         yAKSoX8xijiD/YhXIjX21ypS32va0EW7OlLeFAiRsXR8R9pJ1XEVlYyezdc3SVS7KMDM
         4AagQXX+VLCx6SKe2z2CDwE+r3JFCAk3e84DW+WUmOZUq7oDfKQCYCEEXtknmKtJQslM
         5UqSdhs62eqpfudBgnpxNEhJ5wKtaj3t6QlstMdQ+qU0KkzcpXEeeeBevL7cvpaojvsX
         D/GvJ6uIODtTNuTy8ojYNogMJUtfL2PtEzdfpLdsXM5EQ0otjr4U8qUdBjE21gJ8VSnH
         Y85w==
X-Gm-Message-State: ACrzQf1dznBhdNZJDl9L8mAsKLI78R7hl2rTPsN7KvuXDofOAWDzlQGN
        cugL9loqEMi+GriG3in2N4vNuA==
X-Google-Smtp-Source: AMsMyM7lW9SOfuotrVaYSrWs6Hk6XmrFW/2DEF+pNeFj7LuHj9YcrVqCXqrfS9eGNO52MmJsZcvjlQ==
X-Received: by 2002:a05:6870:828d:b0:132:c30:a8ca with SMTP id q13-20020a056870828d00b001320c30a8camr5951987oae.293.1664823725438;
        Mon, 03 Oct 2022 12:02:05 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id p21-20020a9d6955000000b00657a221eb71sm2529820oto.65.2022.10.03.12.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 12:02:04 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Mon, 3 Oct 2022 14:02:02 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.19 000/101] 5.19.13-rc1 review
Message-ID: <YzsxqvBUsRLQS30I@fedora64.linuxtx.org>
References: <20221003070724.490989164@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 03, 2022 at 09:09:56AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.13 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Oct 2022 07:07:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.13-rc1.gz
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
