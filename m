Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86E516953F1
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 23:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjBMWhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 17:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbjBMWhW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 17:37:22 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AF71EBEF
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:37:20 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id y81-20020a4a4554000000b0051a7cd153ddso1357027ooa.10
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ILaLJ9YR+MoneWuXWsO60RbFqEPdAmDr7KfJYbc7HOQ=;
        b=dHgZoUtmmMYrAOBfecVNoznwGuiSrgaLDInRvVzPGCALMXcewC0op5acIKOmcMgo57
         rzAsPlyqleqC5UHYZAZzwN4oMOdHDjR9cQ398xaQHNtx6GAkdTvhREUmVaO3QeEgoPXL
         Ay4l51dSqHQvZW676bLFDiCbHP5OurCKTIAu4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ILaLJ9YR+MoneWuXWsO60RbFqEPdAmDr7KfJYbc7HOQ=;
        b=7H1l5QxVIMgoDfz7Zm397xkAl12R5tUCJbs4kxriphQypkxu/+IRUvrm8bL1KsqNFn
         lfFJ7t5QRyBzXqy/rpBOu0U/w14j+R2yo1qG8vDcBBt7f/dWn+ZRQ2pnAsy2jQtvC1ZK
         EtUZbSa8Z4PFWax/YpLRNeAFDk8GkhfmHwtHbdRAnwxW2sMuK8cJ6UaxkiSamzesT2sG
         9CoWGzLovUBZe7yThbXVQIPzuFl7fuJ4iFMb3/GVlzDMAbh/HibKYqejj4GrGyr6/HqR
         Q7JFL7epdPYn9HXrX+O0B4H344TJtNU/Yz2kHv7rUmfjo9bSi8yELf6SxRlgOA06BQQD
         sD/g==
X-Gm-Message-State: AO0yUKVYpslMA3NBOrAhplE8XJIXxtEz2yx2a46UZDq5efwPGH/OKRTt
        dlRIPSMhz3/1gB1OnXXt6MiuHw==
X-Google-Smtp-Source: AK7set+oJDpiX0BezbSDLHgZy5zuKdFJxOKFo/m3LpiD5p54GQW0gYJpZtkdfmsmxFSTMXVVAiW9Dg==
X-Received: by 2002:a4a:6b0f:0:b0:511:f3d2:bb8d with SMTP id g15-20020a4a6b0f000000b00511f3d2bb8dmr13170775ooc.5.1676327840082;
        Mon, 13 Feb 2023 14:37:20 -0800 (PST)
Received: from fedora64.linuxtx.org (99-47-93-78.lightspeed.rcsntx.sbcglobal.net. [99.47.93.78])
        by smtp.gmail.com with ESMTPSA id p25-20020a4ad459000000b00500c1100651sm5321387oos.45.2023.02.13.14.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 14:37:19 -0800 (PST)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Mon, 13 Feb 2023 16:37:18 -0600
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/114] 6.1.12-rc1 review
Message-ID: <Y+q7ntjaI5oSts06@fedora64.linuxtx.org>
References: <20230213144742.219399167@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 13, 2023 at 03:47:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.12 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.12-rc1.gz
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
