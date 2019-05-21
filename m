Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1595B24B05
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 11:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfEUI77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 04:59:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbfEUI77 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 04:59:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F112521019;
        Tue, 21 May 2019 08:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558429198;
        bh=x2txS7THJ/jBJV//3EMAJkSBNNOz38X4KjsVyAnhXbk=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=ew4tLmbmotAgpQjV+fNEjPc/ciP624arxTYzgxJsLp5p5jkTp2ReHb+hjY/n1cfCs
         SYEetbeK0fa32deeRRi4YuP5AYq7/I4JVjuuIn0kZORxUmi99el1aoVWfUpedvx8Or
         /0Wxujb52We2XULIIBpyEOqYUiyahDeGF5wjLeMw=
Date:   Tue, 21 May 2019 10:59:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-ext4@vger.kernel.org,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4.19 000/105] 4.19.45-stable review
Message-ID: <20190521085956.GC31445@kroah.com>
References: <20190520115247.060821231@linuxfoundation.org>
 <20190520222342.wtsjx227c6qbkuua@xps.therub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520222342.wtsjx227c6qbkuua@xps.therub.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 20, 2019 at 05:23:42PM -0500, Dan Rue wrote:
> On Mon, May 20, 2019 at 02:13:06PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.45 release.
> > There are 105 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed 22 May 2019 11:50:49 AM UTC.
> > Anything received after that time might be too late.
> 
> We're seeing an ext4 issue previously reported at
> https://lore.kernel.org/lkml/20190514092054.GA6949@osiris.
> 
> [ 1916.032087] EXT4-fs error (device sda): ext4_find_extent:909: inode #8: comm jbd2/sda-8: pblk 121667583 bad header/extent: invalid extent entries - magic f30a, entries 8, max 340(340), depth 0(0)
> [ 1916.073840] jbd2_journal_bmap: journal block not found at offset 4455 on sda-8
> [ 1916.081071] Aborting journal on device sda-8.
> [ 1916.348652] EXT4-fs error (device sda): ext4_journal_check_start:61: Detected aborted journal
> [ 1916.357222] EXT4-fs (sda): Remounting filesystem read-only
> 
> This is seen on 4.19-rc, 5.0-rc, mainline, and next. We don't have data
> for 5.1-rc yet, which is presumably also affected in this RC round.
> 
> We only see this on x86_64 and i386 devices - though our hardware setups
> vary so it could be coincidence.
> 
> I have to run out now, but I'll come back and work on a reproducer and
> bisection later tonight and tomorrow.
> 
> Here is an example test run; link goes to the spot in the ltp syscalls
> test where the disk goes into read-only mode.
> https://lkft.validation.linaro.org/scheduler/job/735468#L8081

Odd, I keep hearing rumors of ext4 issues right now, but nothing
actually solid that I can point to.  Any help you can provide here would
be great.

thanks,

greg k-h
