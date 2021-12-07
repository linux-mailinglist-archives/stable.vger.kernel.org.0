Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADC6A46C4C7
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 21:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236669AbhLGUof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 15:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236592AbhLGUoe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 15:44:34 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40647C061574;
        Tue,  7 Dec 2021 12:41:04 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id r26so871101oiw.5;
        Tue, 07 Dec 2021 12:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eoJfv24gN+SSPyfADwp/kzNCPhUNfaRbBthCI/jvQag=;
        b=jVOSeN3LSFVKZu7uNm+3JwPxbzId3zt8ES1R9y+jeXNRHUWeErMWn7EN4CM8/NLGA6
         ftDFtOrcjyEOAFZgAPPWjvZfiohO8UGFz80pqqZSjAQrd4sHBlc4vjmMHwWMJLDvbMMo
         2TIhukyX2LjfSqS22G0MN4XIxoHhJ8AHqr5wS3kFhL3xqdg5dfA8lS4sEhUo175kvmIl
         KTpjW/DXESq4vdpXoo58dlSrMX7ctrliVncSHsO3zoN4qZwPsAmMvD43B6h9UnOqL03V
         pHhU9KSvuOJzCmmgb6pG/awjfneXx4UV92ExpSpazwFtZYjxsHTc3Q+PJj2CiWzZYwOm
         W/3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=eoJfv24gN+SSPyfADwp/kzNCPhUNfaRbBthCI/jvQag=;
        b=YbVferD9wiFUCc5dkdvcbuQ6+D/8MdQFJT8gBkQhVc39HUMR/O4WAMF/hjaFLxFB5U
         4RHY/38pGL9pxkzyL/Ib7Y9/RLDHWUtVDOo/pYsc6Sm3lJDw1cGBFCbEuVBJHouzwKlv
         UJfUi1tVF5oXUdPtgqFD5If5zKqfT2zcSIrOuzThPdb7cMg+1NrMDL3HWjAoOz6ZFJ/9
         UlR4gHsw68n5hDcbI/dw9aKOTjH3uSRQ+NQ2WrRSgYUeQKdnc2uW22QEHohnIqAYthN1
         7AXr+GkjktHQ8Wx615sY4kNHwzBQMI5tlVyU696jhsfYyrs4AknB/cEfgpxkSVmtAkAD
         xeQg==
X-Gm-Message-State: AOAM533Dt1AUWnle/M+7YhE0Ee61CAe16HQQW20igDUfJrIofAFGs2D2
        BiyMAG8VQLdQD6wAvH2F1Mg=
X-Google-Smtp-Source: ABdhPJwpQBQaTTqLAPdP4gCVIm4sUwlXjJ0yB0b7kmooRl7YtZIsaoQ8s4F0JI8xZ8qti62u0dz/1g==
X-Received: by 2002:aca:30c5:: with SMTP id w188mr7185788oiw.35.1638909663679;
        Tue, 07 Dec 2021 12:41:03 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c9sm168015oog.43.2021.12.07.12.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 12:41:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 7 Dec 2021 12:41:02 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/48] 4.19.220-rc1 review
Message-ID: <20211207204102.GD2091648@roeck-us.net>
References: <20211206145548.859182340@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206145548.859182340@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 06, 2021 at 03:56:17PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.220 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 441 pass: 441 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
