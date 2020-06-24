Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC9742076F1
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 17:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404116AbgFXPMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 11:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403831AbgFXPMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 11:12:46 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDC1C061573;
        Wed, 24 Jun 2020 08:12:46 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id p11so1276106pff.11;
        Wed, 24 Jun 2020 08:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+jeXCiPdu0+JuL6DX00sYXCjsFWpOPKbNcwGv6ghV44=;
        b=f5YG7ridqpjb4s8x3yx49FuZ8QGQnD/rE2/sRdCl/C05iuNZhiebIYI2cMnPjfg9Fz
         SIpm7iHKDZhx0z1+EZnci4fcl+GW8t/0R49Kyfs+oR3lG6+Dj4zDfO8lmM06u1JRlsho
         ke48xISq/PacXrILkhHtGFarHLL9KW7N1kXlYbmNa0PlHasrQsG/3DY85XB2+T9PCzPP
         EVxJnPaJAbEn9X07Ze/Bb/8ljEzRgcEVTA9ckeq6F1oa36VI+MyqsG/LDXz6XMtA6acb
         4U10QxCnyb0SJwXmkDznJ4OWh50rLObDj+h2zxmCQ4fOUsx9s87q+DJl1wYBOm6A3c8R
         p/ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=+jeXCiPdu0+JuL6DX00sYXCjsFWpOPKbNcwGv6ghV44=;
        b=lwIa19GQYdNh349YVLY4yv+HRcAlloKiXUYRdghW2J7toyZBrxqK2x4DD6qAiPYV1t
         XmmHr2n0KZjqBoWjElKr2Ycy2GR/4q+q+rq1rtU/XzUuQFTzX/LjgbdpUAZvx+yU0LDH
         IT4IHG5jh2doHBxRb16r88S7mYVHArKp0LWuIt382dpPd4Qq0X45Qt0cNKFSw3Gum/1v
         MIPlhB//wNzODYkq85calC1eW0VkOoBnk/tT2HiluuQeAhJqZNaABXlYYAg1L3j60H4C
         VkNHm4lcZA/HBUkPKKDqqUbf9eoqV4/ve6WIA40IWa4xeV4hYXMzFf55TjZNHxe55unC
         KT2Q==
X-Gm-Message-State: AOAM533xO2vks3Rghe+MgAQFQVl30bfL4eTl8a0DzCOR6Xqtybi7KB73
        2xQAxba9IWlOosk8WC0vF0s=
X-Google-Smtp-Source: ABdhPJx7xJaVWAZeuN5+uJIHN1pBciwpegMVe0fmsin72WhK8v5lJuyy57orUAOEpNUArzwDlLdRFw==
X-Received: by 2002:a63:6dc1:: with SMTP id i184mr838490pgc.345.1593011566312;
        Wed, 24 Jun 2020 08:12:46 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m4sm16818753pgp.32.2020.06.24.08.12.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Jun 2020 08:12:45 -0700 (PDT)
Date:   Wed, 24 Jun 2020 08:12:44 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/135] 4.14.186-rc2 review
Message-ID: <20200624151244.GA54105@roeck-us.net>
References: <20200624055849.358124048@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624055849.358124048@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 24, 2020 at 08:09:52AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.186 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Jun 2020 05:58:15 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 168 fail: 3
Failed builds:
	arm:allmodconfig
	arm:lpc32xx_defconfig
	arm64:allmodconfig
Qemu test results:
	total: 408 pass: 386 fail: 22
Failed tests:
	<all arm:pxa_defconfig>

Failures are due to API changes in nand_release(), as already reported.

Guenter
