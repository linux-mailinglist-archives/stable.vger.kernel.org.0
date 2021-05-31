Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB75239686D
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 21:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhEaTtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 15:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbhEaTtU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 15:49:20 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6CDC06174A
        for <stable@vger.kernel.org>; Mon, 31 May 2021 12:47:40 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id v19-20020a0568301413b0290304f00e3d88so12045938otp.4
        for <stable@vger.kernel.org>; Mon, 31 May 2021 12:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3lF6MoSj2wY9eDfl/0ZlHspX4t/Cc1wkZeLHSfsMxRw=;
        b=SrSHMGkcG7/IFFCtZHfMZ/VjcoSKWtPB4oDc7ZIRfafUvkDyz1IbLLyiHb572jUQ04
         o5d5NmgymWh2n074gHJEyLGLVp190Xt0QYwDJJJRHL/fiFLsV6KjMYH7HKGMVqsFt7Es
         aKtYB8MxDA/walyUzgdCrON+VSPOLO3Hm59vg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3lF6MoSj2wY9eDfl/0ZlHspX4t/Cc1wkZeLHSfsMxRw=;
        b=AKVAXMVCk81QTd+9UbRJ1ZBgS6rpzvZ7sfyBrAf69gk3bVRxS+AuEVxdyJT2W4ugjV
         X+uOKlN1QsuYluZq3jTDqtQ1vP7XUuSRMvPVf0vVMW7lHyrrH8JT8NLslHfpcg9WfNG1
         l4GZHMJz1ti0AO7l/G+4QrwjCY2goFQaZ6qKU/eTFuKSy139Vy/GZIcp5qj3ZLl90ywS
         upgq5XjTg+6/B7e0QJSEgG5TqR6i9xOsEGgABsNDQPcDxAXcnqgH9sznRxAUue47262N
         bsOUIyApbqsn00/UdjMoJIRlSm5Uhs6M/rn0RbWa20TMi2fB5TQMvr0sjW/VxHtJM3I5
         h92w==
X-Gm-Message-State: AOAM530Xz3hr2j6Sh3NhxdstI+mhZU/8h/A4gyMeoa/Y5qGLZu4yIrzv
        6KLTZaNfiXpaDWCkNC3n5JWhrMCqTyNTkYAF9iY=
X-Google-Smtp-Source: ABdhPJz9JU40RWd5fZXozCP8eoT6CNpk99Olq7W7dcXpIic/IJIWDc6+qVE0lH6ZMkNPOYqJWHUDPg==
X-Received: by 2002:a05:6830:40a8:: with SMTP id x40mr6741102ott.364.1622490459378;
        Mon, 31 May 2021 12:47:39 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id a5sm3486343otb.41.2021.05.31.12.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 12:47:38 -0700 (PDT)
Date:   Mon, 31 May 2021 14:47:37 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 000/296] 5.12.9-rc1 review
Message-ID: <YLU9WWjyVm+WRihm@fedora64.linuxtx.org>
References: <20210531130703.762129381@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 03:10:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.9 release.
> There are 296 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
