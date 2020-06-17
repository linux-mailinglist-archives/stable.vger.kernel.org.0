Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64F501FCF45
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 16:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgFQOQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 10:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgFQOQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 10:16:06 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01ACC06174E;
        Wed, 17 Jun 2020 07:16:06 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id b5so1340217pgm.8;
        Wed, 17 Jun 2020 07:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mfndk5N0w8Iv4fVwaHeA1worwlJaTizl87QwfFhj0ek=;
        b=W+zpoAkn12uMALVb1E6Pe5rLdj8li7pG8D1bIj/vCaVZH9BMnvYpC1AiaR2zznPvXd
         FLfgYeUYF8Aj71hl73NKf+/JmsCihBrmXS0ttUmsXT5HliYpx2Q5rvNQoEhPbEwUX+bY
         iw13oBc2qXHZ07xu4ZHEJ/JqbLEUSflrkP85dRxuCBpvLminahKCZiuaxDIEjVHocE6W
         /s4Whno4jFDfITOpMNCeHb9XZgOwdPJCJ83N0wWOp9UIEA1EcKgB47qeKdHloBIIqqP2
         HkIX3PADBG0QiSDWqjj0++pI0P+R8TJ+KAfd/tnRGmG9UwC5WQejTsuFLmAUifstV6m1
         VueA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=mfndk5N0w8Iv4fVwaHeA1worwlJaTizl87QwfFhj0ek=;
        b=Lmn/u2wnxTgASocKPJCC+AvWBknh5BD8FqjzOHLnGr9exLb7ETcx9aAVAI9lTjGm+T
         iI1SIyBWurdlMBaGLfU+IELtqpXnBhZmnnOfEKLGmuPwnrXLtLuXOnEPKojjc9uJ83Mb
         u7XYvxt0JBymCWTrFveXcRE794LTTdfg8FGnV9AJWjRPQ9/GPPLCmg/z7woOG0x3wEjs
         XQJopzDOdYFu/7v1PlBgujVbjc/yNqcoluPGpqJUHX7JG6G5o/bINVD21bSzdf1LoVcL
         g100s9O7EUxrxby5rEoLQCCDSa6TZVZcWNID/fb+G8iZLd6AA1CO68WRBuhEszCxJqI4
         wQsQ==
X-Gm-Message-State: AOAM532dPsPFxOXNCvEwwkoDv8uE9QvP9vEbgYgpJ6i32zjTpOFg/t9o
        yJtVgvrFRQU5rL+21j7bNafB3oHP
X-Google-Smtp-Source: ABdhPJxdNTEcHTeTa9pNALJHsqozRHP/heu3JtTMi8PJwsHC0nnezgVC6GLd756z9Wrb4RDcji+Uwg==
X-Received: by 2002:a65:6106:: with SMTP id z6mr6487022pgu.368.1592403366462;
        Wed, 17 Jun 2020 07:16:06 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z8sm410207pjr.41.2020.06.17.07.16.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Jun 2020 07:16:05 -0700 (PDT)
Date:   Wed, 17 Jun 2020 07:16:05 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.6 000/158] 5.6.19-rc2 review
Message-ID: <20200617141605.GB93431@roeck-us.net>
References: <20200616172611.492085670@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616172611.492085670@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 16, 2020 at 07:26:59PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.19 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2020 17:25:39 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Guenter
