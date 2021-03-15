Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4E733AD4D
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 09:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhCOIY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 04:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:55318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230183AbhCOIY5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 04:24:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E65A164E33;
        Mon, 15 Mar 2021 08:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615796697;
        bh=wCh3f3N+dMK+Vsniwym7H4XOnEnUFXpggsAXHQ2dxzg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vi+XkDIMj54Fv9YyTyT3TLd6Mo7Iab4tskJajDwlcxHsdAD8Q3z9TGkdjX+fjyafq
         Y5geS72I7zuEzNXigb0wk89TwM2g/KScZ2dvSGEAsA4V9ax7GPIPZa6jKeUQ1K0ttT
         dA8hTbN4XuflasI2y01UyQi3OVkDTF14g3fLU19I=
Date:   Mon, 15 Mar 2021 09:24:55 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>, linux-alpha@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: Re: alpha patches for v4.4.y / v4.9.y
Message-ID: <YE8Z1wFiRo2SOY33@kroah.com>
References: <44a392c3-418d-3503-7c46-0d283134d980@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44a392c3-418d-3503-7c46-0d283134d980@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 14, 2021 at 11:33:08AM -0700, Guenter Roeck wrote:
> Hi,
> 
> I recently started to add basic networking tests to my qemu test environment.
> When adding the necessary build options to Alpha kernels, I noticed that v4.4.y
> and v4.9.y no longer build due to relocation errors such as
> 
> net/built-in.o: In function `__copy_tofrom_user_nocheck':
> arch/alpha/include/asm/uaccess.h:364:(.text+0xff444):
> 		relocation truncated to fit: BRSGP against symbol `__copy_user'
> 
> The following patches fix the problem.
> 
> v4.9.y:
> 
> 5ed78e5523fd alpha: add $(src)/ rather than $(obj)/ to make source file path
> e19a4e3f1bff alpha: merge build rules of division routines
> 3eec0291830e alpha: make short build log available for division routines
> 4758ce82e667 alpha: Package string routines together
> 
> 8525023121de alpha: switch __copy_user() and __do_clean_user() to normal calling conventions
> 
> v4.4.y:
> 
> 5ed78e5523fd alpha: add $(src)/ rather than $(obj)/ to make source file path
> e19a4e3f1bff alpha: merge build rules of division routines
> 3eec0291830e alpha: make short build log available for division routines
> 4758ce82e667 alpha: Package string routines together
> 
> 00fc0e0dda62 alpha: move exports to actual definitions
> 085354f90796 alpha: get rid of tail-zeroing in __copy_user()
> 8525023121de alpha: switch __copy_user() and __do_clean_user() to normal calling conventions
> 
> Only the last patch of each group is really needed; I pulled the other
> patches in to avoid conflicts.
> 
> Please consider adding those patches to the respective kernels.

All now queued up, thanks.

greg k-h
