Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0E215391A
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 20:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgBET3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 14:29:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:41354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727079AbgBET3r (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 14:29:47 -0500
Received: from localhost (unknown [193.117.204.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8386B20720;
        Wed,  5 Feb 2020 19:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580930986;
        bh=eUhNS3HobXfsDB2TsG5d09BnyQcQUUPRFhkqjqBwFlI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WoqKwgm/wn5dU5KzsyN1izYJdyVVnQJbzfQ5R0Nu6sd4FUI+ESQo7CtxATjM2EQ4i
         GG13w86tw7khYUkBn9TQT8+2PKiaq9npxEqLwRZXUBSKYofPdrbYy6cK6GBXeNxVmW
         25w0yIDhzDtKR9wWR2494an0b0S2Y8mo9QuQR9yc=
Date:   Wed, 5 Feb 2020 19:29:45 +0000
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/90] 5.4.18-stable review
Message-ID: <20200205192945.GB1327971@kroah.com>
References: <20200203161917.612554987@linuxfoundation.org>
 <9a5a92f2-6e28-a9ab-a851-8d7e56482df6@roeck-us.net>
 <20200205150605.GA1236691@kroah.com>
 <20200205162524.GC25403@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205162524.GC25403@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 05, 2020 at 08:25:24AM -0800, Guenter Roeck wrote:
> On Wed, Feb 05, 2020 at 03:06:05PM +0000, Greg Kroah-Hartman wrote:
> > On Tue, Feb 04, 2020 at 06:37:38AM -0800, Guenter Roeck wrote:
> > > ---
> > > Building riscv:{defconfig, allnoconfig, tinyconfig} ... failed
> > > 
> > > Error log:
> > > arch/riscv/lib/tishift.S: Assembler messages:
> > > arch/riscv/lib/tishift.S:9: Error: unrecognized opcode `sym_func_start(__lshrti3)'
> > > [ many of those ]
> > 
> > Dropped the offending patch here, thanks.
> > 
> This problem is indeed fixed with v5.4.17-99-gbd0c6624a110 (-rc4).

Good!  Thanks for letting me know.

greg k-h
