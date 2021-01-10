Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC162F06A5
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 12:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726471AbhAJLad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 06:30:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:48232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbhAJLac (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Jan 2021 06:30:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C2AA23358;
        Sun, 10 Jan 2021 11:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610278192;
        bh=sGeeRK9sD09pML/RBM4O1d31RmSmOl8s45NchDfxtG8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jlHmPieVowxoRMlWijuAgpBfETzI0XJaZk4YlW90FvUVtzgx+wZ3TpBTWu9Oo3/dW
         q9yAr0oBHnq4WFDVTWybCXvqHdippLSP4bko3VJ8aQAHA2Hx3J6z45OvuR5uTXH5v0
         BRBJjBMoXSDOtOQ1qtt50edmvI5VVLkV0JkckuZg=
Date:   Sun, 10 Jan 2021 12:31:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/20] 5.10.6-rc1 review
Message-ID: <X/rletJGG470UUO9@kroah.com>
References: <20210107143052.392839477@linuxfoundation.org>
 <20210108174119.GA4664@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210108174119.GA4664@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 08, 2021 at 09:41:19AM -0800, Guenter Roeck wrote:
> On Thu, Jan 07, 2021 at 03:33:55PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.6 release.
> > There are 20 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 154 pass: 154 fail: 0
> Qemu test results:
> 	total: 427 pass: 427 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Thanks for testing them all and letting me know.

greg k-h
