Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 291054B7308
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 17:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239592AbiBOPpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 10:45:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234702AbiBOPp2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 10:45:28 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D93149BA8;
        Tue, 15 Feb 2022 07:40:07 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id q7so32690561wrc.13;
        Tue, 15 Feb 2022 07:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xRfR/3cl8ngHKj2jF/8jnAtft+nkVrmLjzr2g6FmtNs=;
        b=HlCeRB4UmweM9i3yvrc8utK/dbRmdx0h3G3wkWJWdGGtk3peH2YVMyIRdrp+xYxw52
         Fhif/0VFBdswKLPW+17vXvbI/GnrROHAQbL7tQF4NT/CpA84OjUE/BCEF0FdW7jkxWDd
         Sz24Q9sM4WVUbwptdl1gM3kAOokwSRwax8xBrkw8JJ0u6SyOhyjrb6iMDJScIwtkpOF3
         HSzXgYPCDM2jAmBKAkuTns1V4QUr7DdiYc0H/A2EI7JA/MTtY1JwjiKfUz9uMIf2Bl+s
         43nb2cHiwwjOxrakxOu9G1NZrOoPCs3CKHh6TSm1IoqLTNLdYTImE7Yzc9FM8ByAgg1d
         +WCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xRfR/3cl8ngHKj2jF/8jnAtft+nkVrmLjzr2g6FmtNs=;
        b=mDfmyMGoI+eUzKh8PrpDYe9nuxgov2FVmcY9NwlIMa0VUC81kFXfqHLa22XprfwKAK
         CtzVCcmlJAucoI8HOjIglJt+roLpYcz6C2cC2zFhRIPYYi0Y6VT9HvPHNJbP3HkBdBdP
         WZwsvf0VTlvPn8rZhdHYQxTZoZX9IAJGVkw0ITTXjyd0vIIALX4iPhDNUObHfsNW5yV9
         A4OM3SykWhdjoUEGFUCQ23qCC9OAuezKiIjeKFiXNjqECmvmoD7uhxD2ewESl76NdP68
         /suXSCRw/Y2uzH/zf1EoOnuo+P5r7xO8FG44HPcBsBzkndP6SkXGwAo0RddkE+zI1qnk
         Vwqw==
X-Gm-Message-State: AOAM533BqwDTQddjvWIU0nbjK/ftI85Vo7/xgkP6L9gdpj6QZWzb8WLq
        bH4f/+1CAhA4FES+puXj8uc=
X-Google-Smtp-Source: ABdhPJzJq7MB60D6D77HTVecIFAuon+J4kqwg747+Jptz0ejRLFXLZ54BqFzWgiuNPskPUtplqeEAA==
X-Received: by 2002:adf:f690:: with SMTP id v16mr3703067wrp.707.1644939605970;
        Tue, 15 Feb 2022 07:40:05 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id ay38sm18225926wmb.3.2022.02.15.07.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 07:40:05 -0800 (PST)
Date:   Tue, 15 Feb 2022 15:40:03 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/71] 5.4.180-rc1 review
Message-ID: <YgvJU9rXZnUku/44@debian>
References: <20220214092452.020713240@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220214092452.020713240@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Feb 14, 2022 at 10:25:28AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.180 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220213): 65 configs -> no new failure
arm (gcc version 11.2.1 20220213): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220213): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220213): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/760


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

