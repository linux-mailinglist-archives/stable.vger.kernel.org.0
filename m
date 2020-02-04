Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A98F3152291
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 23:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbgBDW4Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 17:56:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:36206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727412AbgBDW4Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Feb 2020 17:56:16 -0500
Received: from localhost (unknown [167.98.85.149])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73FB62087E;
        Tue,  4 Feb 2020 22:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580856974;
        bh=U8Tdm6VZowdahM3Ii+vu7aEG0jWdeFdxEp7o4xmydII=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FgeP3Hup75Kr1Ntt2Ao4qUoWruSMWvCKJS5G0zEbSuyq+G6v4miT9eIXW2m62Vwgk
         cz51RiLF91LTVIo3zeDng9uWVz+i4BWHRGrFsSOHx5pKw91/TdjlKGzaZP0ocE9MyQ
         4t43B+Q92n37ryp5+2P3r0IF/nxTU7hUKPnLXdlI=
Date:   Tue, 4 Feb 2020 22:56:12 +0000
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.5 00/23] 5.5.2-stable review
Message-ID: <20200204225612.GA1129826@kroah.com>
References: <20200203161902.288335885@linuxfoundation.org>
 <20200204172047.GF10163@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204172047.GF10163@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 04, 2020 at 09:20:47AM -0800, Guenter Roeck wrote:
> On Mon, Feb 03, 2020 at 04:20:20PM +0000, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.2 release.
> > There are 23 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 157 pass: 157 fail: 0
> Qemu test results:
> 	total: 393 pass: 393 fail: 0

Yeah, one is right.  I'll tackle the rest of these tomorrow, thanks
for all of the testing and reports.

greg k-h
