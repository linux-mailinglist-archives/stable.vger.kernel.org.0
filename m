Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCA56EEC03
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 03:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239104AbjDZBrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 21:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238025AbjDZBrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 21:47:06 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A95D319
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 18:47:03 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-38e27409542so4615104b6e.0
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 18:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google; t=1682473621; x=1685065621;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ZsskTH5BhlaFFaEUUgbGihRjISLqNevqRfw2SlM6dk=;
        b=KXn5qYVKMdtOdTO4P68ZvepK9XiPUB7jDwoQlDGOEOiJ0de7TrRx7it5k9knGL5HmJ
         1F9UKdPzL2L1peyYkIO5AkUmWMWeJIDCBxVNCPXO2ZsuDgWbwQzn4V4Qqu/37v68tiqx
         KCF1p2hFO71VaFyeSynXu7Tz8ybtYfOCknL7Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682473621; x=1685065621;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ZsskTH5BhlaFFaEUUgbGihRjISLqNevqRfw2SlM6dk=;
        b=USH9OIIezpxCCty5NMlKcjgvGwkSbtBpOJ+kkm77HZ9q6grCfxcuNc4pBVE2yKRIpF
         JoNB3KcK9oa80Np4A7DjSgTaIUskK+dy3aGBEc/XhkPvZF3EYM4W5tFtTVmDL5luAyAw
         x1ABHsBHIPlF6LOJMVYgVWFODXcvboBNmcPfdd0I8oEY+OwqbFxEbRBF4x+LTWwQLf64
         py5TQK/62qyu97PcVb3gkdLzHQsP62iPI5lObk685E7R1Eahx8Z1e1xiWxH6zbGEHkxO
         YtT4yT/C1QtMs9mmpQBoNve6+hdx1Epz5KvyclI3Em+fqzEdd5ZXMu6OGzTHupNIPaiR
         HEbQ==
X-Gm-Message-State: AAQBX9fFlwYCJdxPCTnlNxRlpz6FUHztWQaencOf54inxs6rbMeDatQ1
        6ify/GFYxT9OE+2KuyZdx5lKQg==
X-Google-Smtp-Source: AKy350Y/k8gNDuC5ESi/KZW7Z0umdtFs+W28PYRjoB0A7+wtl9gzKvHW8TA8ZqeLvwKUclvLiZJuwQ==
X-Received: by 2002:a05:6808:2389:b0:38e:2993:be7f with SMTP id bp9-20020a056808238900b0038e2993be7fmr12170976oib.38.1682473620818;
        Tue, 25 Apr 2023 18:47:00 -0700 (PDT)
Received: from fedora64.linuxtx.org ([99.47.93.78])
        by smtp.gmail.com with ESMTPSA id o189-20020acabec6000000b0038c2e1bdf2asm2844138oif.36.2023.04.25.18.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 18:47:00 -0700 (PDT)
Sender: Justin Forbes <jmforbes@linuxtx.org>
Date:   Tue, 25 Apr 2023 20:46:58 -0500
From:   Justin Forbes <jforbes@fedoraproject.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/110] 6.2.13-rc1 review
Message-ID: <ZEiCkmdPVfkRzwkq@fedora64.linuxtx.org>
References: <20230424131136.142490414@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 24, 2023 at 03:16:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.13 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
