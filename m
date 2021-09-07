Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98563403059
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 23:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244484AbhIGVh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 17:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243917AbhIGVh5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 17:37:57 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95525C061757
        for <stable@vger.kernel.org>; Tue,  7 Sep 2021 14:36:50 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id l7-20020a0568302b0700b0051c0181deebso99963otv.12
        for <stable@vger.kernel.org>; Tue, 07 Sep 2021 14:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxtx.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Cq2RpdWRFR+UJ1eunmYcEEJnFAucRxkrMkgHCnagpFk=;
        b=EtfvV1UQAdKlQR8G538c1zvAh6HZnSaRSH46IaYnNXXQeCqudGc4Iibh/1OqP6I/sP
         Va4gAg/pTcXUd4AAgDNrHOG9yp3QrmX7H8KhPH7/bxRdOOwBF+34q637fkfrv0u60yBe
         FgUQuugc9+B5cxKzNJw6KbBNfA9gZky1mbyoA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cq2RpdWRFR+UJ1eunmYcEEJnFAucRxkrMkgHCnagpFk=;
        b=MpFXRL42VM7+mhmRmoVaI2tWs0ly3iDVVipGO0+LDXaVjVWqhW3J4Tbe389QhPAHP0
         YD0hhqqKiHE7tmv1GkaluwJFb4UfX+t5B7J+hjecuur8QBNwtrBFZiRcynwDFyRhXvno
         fSjRmDPTzIQ61vfGoZNF+P+VZuWCQ1W3lIpBu9WuJKHIbjQ1y1z2azWdlfqwPbsFoX1R
         +4urgq3SrRPbxYKCCz/HtssmOIhU1nJ2mEOM/pZHvLgAwf66ysROqVM6RotCv9kGiDbh
         LqaJxAPwK5wCBhn0I2ggy7UA4q6azVUb+fV8FVFH2U/BlBxVZtKUEadymffot3bYPZft
         MtIg==
X-Gm-Message-State: AOAM531aNpQCFImyjEq17iiGRby+KSxAi86QMp8T6LT+UWqsU4R0AJOz
        PJ3OsxTI/1MKw5NpPaopaZ5t7hG/gbEJJZRb
X-Google-Smtp-Source: ABdhPJzs3kNTVYBemwHzzzOsf+62in0rMRleY8QoiiOZHZnNG+IiIWE26TV31NAvMOfBW27vVTCFog==
X-Received: by 2002:a05:6830:241d:: with SMTP id j29mr428186ots.47.1631050609864;
        Tue, 07 Sep 2021 14:36:49 -0700 (PDT)
Received: from fedora64.linuxtx.org (104-189-158-32.lightspeed.rcsntx.sbcglobal.net. [104.189.158.32])
        by smtp.gmail.com with ESMTPSA id l4sm31380oth.4.2021.09.07.14.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 14:36:49 -0700 (PDT)
Date:   Tue, 7 Sep 2021 16:36:47 -0500
From:   Justin Forbes <jmforbes@linuxtx.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 00/24] 5.13.15-rc1 review
Message-ID: <YTfbbyQr3+nrrpxm@fedora64.linuxtx.org>
References: <20210906125449.112564040@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210906125449.112564040@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 06, 2021 at 02:55:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.15 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Tested rc1 against the Fedora build system (aarch64, armv7, ppc64le,
s390x, x86_64), and boot tested x86_64. No regressions noted.

Tested-by: Justin M. Forbes <jforbes@fedoraproject.org>
