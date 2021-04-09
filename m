Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7D23599D0
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbhDIJuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:50:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231127AbhDIJuE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:50:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 423166102A;
        Fri,  9 Apr 2021 09:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617961791;
        bh=FxcPREmQx9pWe4X5XZ5knHXTHHK+rX/i2cjEfIy91TU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zDFgBQHKlR3bUh//k6dXUcQx3U3IsvfmBBul14KbYzT0Mv1a5JDtp387jpuZTTXeL
         xOE/T6Nwsqzfva/20+oOnvG5jdO8NsxMVE2k/m8s3dp4hIFtRPk4nhprYLJYH8Axfh
         6LZnh7vQSH0ilm084xW7EElFj2FF8ZmC9uNyIz0k=
Date:   Fri, 9 Apr 2021 11:49:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: COMPILE_TEST related patches for stable branches
Message-ID: <YHAjPd8rCD/rnJ01@kroah.com>
References: <ab0cb60d-9044-695c-dbd4-2a0324296c17@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab0cb60d-9044-695c-dbd4-2a0324296c17@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 07, 2021 at 05:41:15AM -0700, Guenter Roeck wrote:
> Hi,
> 
> please consider adding the following patches to all stable branches.
> 
> v5.11.y:
> 
> ea29b20a8285 init/Kconfig: make COMPILE_TEST depend on HAS_IOMEM
> 
> v4.9.y..v5.10.y:
> 
> 334ef6ed06fa init/Kconfig: make COMPILE_TEST depend on !S390
> ea29b20a8285 init/Kconfig: make COMPILE_TEST depend on HAS_IOMEM
> 
> v4.4.y:
> 
> bc083a64b6c0 init/Kconfig: make COMPILE_TEST depend on !UML
> 334ef6ed06fa init/Kconfig: make COMPILE_TEST depend on !S390
> ea29b20a8285 init/Kconfig: make COMPILE_TEST depend on HAS_IOMEM
> 
> This will prevent issues with s390:randconfig, which may inadvertently
> enable COMPILE_TEST while HAS_IOMEM=n. This results in lots of useless
> compile errors and stray error reports from 0-day.

Thanks for this, all now queued up.

greg k-h
