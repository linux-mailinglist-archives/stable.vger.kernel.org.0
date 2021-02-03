Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE5A30E430
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 21:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbhBCUmM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 15:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbhBCUmI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 15:42:08 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90712C061788;
        Wed,  3 Feb 2021 12:41:27 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id f6so1170815ots.9;
        Wed, 03 Feb 2021 12:41:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IWX1lTfZ5nCM85mPL5whtUh8ugHPERHuEmPRIOsUHeE=;
        b=KtoAHzCbNDso2nkLoGyX9yHF8LjmZg3PagkxP+9G3W5vpe3ZGUk3bx8c1Bd3eJuX36
         ODe2AYS2FU5ySvzRknIOX1LBnoAjFgB/fz9LowEQZPCXpHmoTp1OsFz3WPMwNNQE+tjl
         1yKHPeUTAPWnBk+GsxAzTPhSqpKa20fpkjqzWy0zIPCKvQs9YY/Q9VpMn/9cPFbrVrmw
         9tveMA0Js8m68PHUw2pODHnjLtebYxKfpLcHEawzTOgDFvBxs+/S5FCWLajtW+Oiwg7q
         3QQQzx9so46HRTJiIr0TwEtp/14qyymUo0VcFNxjMHd6uyRve7GYksGNs03vW5t63VoN
         HudA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=IWX1lTfZ5nCM85mPL5whtUh8ugHPERHuEmPRIOsUHeE=;
        b=Nagm+aWsSkt9HqErIBrIdwlDVqVqsc1ZZqad4ueWqC5HqGRX+1HEXDEYXZUy/o9fsr
         kiY1xG8O2IXSXBAgz/LvmeZoXd1QkHxFA6gys1G0Y63rkmOhYAVsS2ERzyOEqTZKJ3yj
         ZBHq3e50JGr63dMlPpZ8HeKQG0ropLMknhJ+389d17NqTPBn1RaUK0AqQ5ZoPdlodVmu
         T6A3YIFONnqNKw1WeNcmRV6FQG94MPPYP7nBY6CnPuz16e7ncWuRY1qhEZlF0ON80+wG
         pOBy+dfarbaly4INtIcPC3Qo1YFdiwK367LzRHrAX9FUK389XNB3q70GZujJ9PXsym12
         WjVg==
X-Gm-Message-State: AOAM530bzWbYNYZDYpaJnUgY4ZBjsmBKiZiDGC6D0W63beSzOSFw571l
        J64Q2xcAyqTO/ANEXDokXhI=
X-Google-Smtp-Source: ABdhPJwxLouJ2Lm6NcRApt+MLwwvsym30ZnQ361b294aBDSAQHRHNBnuz2GzbCyTjyDRlKrGsTCIDA==
X-Received: by 2002:a05:6830:1614:: with SMTP id g20mr3210421otr.77.1612384887054;
        Wed, 03 Feb 2021 12:41:27 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s10sm631721ool.35.2021.02.03.12.41.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Feb 2021 12:41:26 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 3 Feb 2021 12:41:25 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/32] 4.9.255-rc1 review
Message-ID: <20210203204125.GB106766@roeck-us.net>
References: <20210202132942.035179752@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202132942.035179752@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 02:38:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.255 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 382 pass: 382 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
