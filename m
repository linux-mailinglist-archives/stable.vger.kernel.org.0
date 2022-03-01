Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCE5C4C8FA8
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 17:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbiCAQHB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 11:07:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233039AbiCAQHA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 11:07:00 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A7B45AF0
        for <stable@vger.kernel.org>; Tue,  1 Mar 2022 08:06:19 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id g6-20020a9d6486000000b005acf9a0b644so12551215otl.12
        for <stable@vger.kernel.org>; Tue, 01 Mar 2022 08:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FjIe1KKKDE0QpJR+EX/tD4Xgs8J58UrfwdgzXopAHx0=;
        b=DxhqBPY2ZJvFRPNcfFL12VwJZ/aXUFAV2V8IB44VwjzZJ6VevVFo0Xd5JwZv5/3tyP
         fiSjMi+f+BCyxcQbVWAl2TLMWtuRkKljuEta7uAgDXQyKqq3mBFyZtCjVkmQJratgzq3
         P86SkEpvse89SsTdUbTkEG5k/HLRzN6MAxggc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FjIe1KKKDE0QpJR+EX/tD4Xgs8J58UrfwdgzXopAHx0=;
        b=P2B/KOkuIe4AJi4wZk66aTdn1PiFfoMHzKMdQ0J/v64KK4LWYS+Vwyjei20yAXsyMF
         04q2an56C+ArM9XDdvuDuKf5pq0SF7yREzy1IVdxZ5VjkfrdL+m/r5Z0BlPXQLcY3Ick
         CrWnE0rm8CNWgfSN5flnpFrXCXFr3oQIh4FVPDH4xLHdjzMUTjZaqyV3Jpns+w5ZI+t4
         FYbOZh+Ya7JLjlTtEJI0rTV2wD6SNMvk2Cbtd9qBvNUlqtPNqAfFd0hTHwWQC+gaJn6b
         oqYAqqQb49WNpmRQM+ehiJ42kakFbYj6vpCbjAQ3N88neLrq3QELpHAXex+FDEjDQsLf
         +9vw==
X-Gm-Message-State: AOAM531ZKxKu1Fc9qrhA5cIActj6WIX4HOvqcvtMyKWLSFEChooYg0KG
        G5S4KPVqBwH7LXuAYe++pabjDg==
X-Google-Smtp-Source: ABdhPJwLe78NTYJKm38V5AVOnQMIUbVYK7mL7wvNoTuFdjZv0B5QM9fTBqOf5UQpU6Dgwlrjswfzlw==
X-Received: by 2002:a05:6830:5:b0:5af:7ed5:8f64 with SMTP id c5-20020a056830000500b005af7ed58f64mr12743319otp.257.1646150778490;
        Tue, 01 Mar 2022 08:06:18 -0800 (PST)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id bf39-20020a056808192700b002d51f615f1csm8435165oib.34.2022.03.01.08.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 08:06:17 -0800 (PST)
Date:   Tue, 1 Mar 2022 10:06:16 -0600
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.16 000/164] 5.16.12-rc1 review
Message-ID: <Yh5EeJ/psXZrrJSk@fedora64.linuxtx.org>
References: <20220228172359.567256961@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 28, 2022 at 06:22:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.12 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Mar 2022 17:20:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
