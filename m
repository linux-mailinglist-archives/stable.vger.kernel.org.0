Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF8E4644E2
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 03:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346051AbhLACdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 21:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241245AbhLACdA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Nov 2021 21:33:00 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36F1C061574
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 18:29:40 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id n17-20020a9d64d1000000b00579cf677301so33028035otl.8
        for <stable@vger.kernel.org>; Tue, 30 Nov 2021 18:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZuXjpzpLwqfQRycZlli2uRLaCIQV5k6p+3BxzVDW+WI=;
        b=dlYTI7DfPmmDUa1YuX8CbqEb+6hQ5bO6iUmTUyWsP1qz1zi5RJ5wlQET/c5jtMpRrx
         mZFZLqT7U4aziyVqzljTvEVg3TFqXY+7ZNCO8kBZNJT5K4fF7LT1nxtvzeym5EXrK3P6
         024rQHu94JzvxN9ogfsaOEf+jJKXs0BbXYOKY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZuXjpzpLwqfQRycZlli2uRLaCIQV5k6p+3BxzVDW+WI=;
        b=Ig5vTIFaHWvrZuo5ddGZzdwvps6tcT1gLKmEzt1VFm5pb+Iq/r2GDEI71R31LPsQ+y
         G2TLVos0t3bA2qM5M4p76iOk2845v6b8OIrIfjEI1Wnkh4rVgOJOLo6viX0FK5K0Wmkz
         Sy5oAN3lSn77aymHqkeMba3MCIctM9ofOSUVZEGX5/NrtfA1yc976FyIReeP8rOlYkv4
         WLr6aHlGLBlXHR0VmiuxLNaenSxlLvv6Brb3vYipFJlGPxIY9GsaKKXNgJRM3/Od9gyb
         NB02PrNa97C69+oA9Pmy6o0bKOy9jqQ3TFhTiSkZYLDylAq0bhByfMzqs1Lb2YC4nqny
         7xNg==
X-Gm-Message-State: AOAM530nZC1eO7q8Q3736ob1TpSznldP9w6CciIdbAEA8LfT6kMB+tPR
        8urT487gHR+SB+zQuvMZ5DEP7A==
X-Google-Smtp-Source: ABdhPJztAsZQ7GnyItpymeT7+bXoL2bJD+pv7bbuKiyzDNcugEdOnmzN9gWbORcFwtZOByh5R7r95Q==
X-Received: by 2002:a9d:2a88:: with SMTP id e8mr3073112otb.375.1638325780212;
        Tue, 30 Nov 2021 18:29:40 -0800 (PST)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id e14sm4024821oie.7.2021.11.30.18.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 18:29:39 -0800 (PST)
Date:   Tue, 30 Nov 2021 20:29:37 -0600
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/179] 5.15.6-rc1 review
Message-ID: <YabeEWzqaD/KzLKs@fedora64.linuxtx.org>
References: <20211129181718.913038547@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 07:16:34PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.6 release.
> There are 179 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 01 Dec 2021 18:16:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
