Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2021340321E
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 03:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238890AbhIHBUt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 21:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233422AbhIHBUs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 21:20:48 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2DCC061575;
        Tue,  7 Sep 2021 18:19:41 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id o16-20020a9d2210000000b0051b1e56c98fso793155ota.8;
        Tue, 07 Sep 2021 18:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Vd0+DOdzLhLIoU7Acfs57XFTHZxw+dV/qQztLukIFHc=;
        b=OaPPOavZN4Dm5FpUVZLMUPSOXmNAr9tmPrF5LCdtP9QPWZ3zEcU7RQ7F2mpch0NmSp
         gyS4q+aePLfWrLTBcvzeIdIpCiXenJE8Ahu01bs9yAsXaxQnYxS4yAwCqN4hfd+mxOAv
         WcuRGgjj1AlRdbiJATaf2Q4Alkokc26wRcIVcWzVEp2t1eCYdPEzNoMknwfJpTVotrNe
         HA5kqq3MYAmJ6dUVvOKRRrozazG6IYHO9I/UDfc2BIi0ge2bHdAgkGq7mpUmR2mKUXFo
         YnAc3vJ9506kKspT/B1f0khsA8ZWknxhd0jE728PXa40j+1DyVqP3bxSazmUYq3eAhgu
         /07A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Vd0+DOdzLhLIoU7Acfs57XFTHZxw+dV/qQztLukIFHc=;
        b=ugqSqEGIOdVbDYT1hbsTfRvOTw5pm87+Hg1v3mgwuhf9cEtiIpi3AarO7LWnuUn1SS
         I7eWoSd10nLdlN5aSKUs76/33SsA1UCnSdFs1Ew/kBPqIA6UPPu1+hO9yoJCB8Qmrao7
         pIwE8DxqipuJ4y0KS+9tfF8KumVjEHHwX+05XkBzeG/ttFs8520E5WWoSYKPibIdj4mh
         yYgrnutLzCr0QN5cAGwiv6G6L+PpFnoNqs5yak0CXttzQPTsvlSJevC7ChWFAV0lm8JP
         wg5vJQWpHFxOvL1nlan40QRWnRv6ic8VrwZQZdjM2+kWz9ELjwhqHkV3JaURzuItQqXV
         j3tA==
X-Gm-Message-State: AOAM532wgjnZpDDR+yn9KMhkqJKqh1dT2I7o6wcVYaMDqjN4l7ktSRvX
        C7vgcFyd2PEPs6E1nKZICvg=
X-Google-Smtp-Source: ABdhPJyQeDcnbqzZpUBUBNKMJ19p1HKVw6PjUsOOkE0us2Qb+sLnZ5TZJMkqW7VxgoI2YETkcaX50w==
X-Received: by 2002:a05:6830:2108:: with SMTP id i8mr1073149otc.336.1631063981197;
        Tue, 07 Sep 2021 18:19:41 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v16sm134417oou.45.2021.09.07.18.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Sep 2021 18:19:40 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 7 Sep 2021 18:19:39 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/29] 5.10.63-rc1 review
Message-ID: <20210908011939.GA2310006@roeck-us.net>
References: <20210906125449.756437409@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210906125449.756437409@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 06, 2021 at 02:55:15PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.63 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 456 pass: 456 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
