Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91AB2212A4A
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 18:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgGBQt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 12:49:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726300AbgGBQt2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 12:49:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B986F20720;
        Thu,  2 Jul 2020 16:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593708568;
        bh=lLUBehbgSA7L5Nlu4GfgmJqSXvphy6taLoYB1eTlx+M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C+Isv7xnfhCimIaRG8HzlNiyeOdCQhgh7FX4x/v37JvXvnSxrkZIG33KmZlrqtepC
         B6Ne9uJXYenSYKe7KfUN/0uY/bnz7eKK0WbquKpUq2yb6Dhkc2eLKvHX+++LsSvZhN
         +q6pMsxRSp5/VKl7RnsvtgOPPc8VsZxiDIUXkYzc=
Date:   Thu, 2 Jul 2020 18:49:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Denis Grigorev <d.grigorev@omprussia.ru>, stable@vger.kernel.org
Subject: Re: 3.16 EOL
Message-ID: <20200702164931.GA2147773@kroah.com>
References: <20200630153641.21004-1-d.grigorev@omprussia.ru>
 <1bf72bc1ace92609fec953daf17342e1d2d48394.camel@decadent.org.uk>
 <20200702073919.GG1073011@kroah.com>
 <514c425e2b4dca71a11b0c669746d3122f7039a5.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514c425e2b4dca71a11b0c669746d3122f7039a5.camel@decadent.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 02, 2020 at 03:55:04PM +0100, Ben Hutchings wrote:
> On Thu, 2020-07-02 at 09:39 +0200, Greg KH wrote:
> > On Thu, Jul 02, 2020 at 12:31:01AM +0100, Ben Hutchings wrote:
> > > On Tue, 2020-06-30 at 18:36 +0300, Denis Grigorev wrote:
> > > > This series of commits fixes a problem with closing l2cap connection
> > > > if socket has unACKed frames. Due an to an infinite loop in l2cap_wait_ack
> > > > the userspace process gets stuck in close() and then the kernel crashes
> > > > with the following report:
> > > > 
> > > > Call trace:
> > > > [<ffffffc000ace0b4>] l2cap_do_send+0x2c/0xec
> > > > [<ffffffc000acf5f8>] l2cap_send_sframe+0x178/0x260
> > > > [<ffffffc000acf740>] l2cap_send_rr_or_rnr+0x60/0x84
> > > > [<ffffffc000acf980>] l2cap_ack_timeout+0x60/0xac
> > > > [<ffffffc0000b35b8>] process_one_work+0x140/0x384
> > > > [<ffffffc0000b393c>] worker_thread+0x140/0x4e4
> > > > [<ffffffc0000b8c48>] kthread+0xdc/0xf0
> > > > 
> > > > All kernels below v4.3 are affected.
> > > [...]
> > > 
> > > Thanks for your work, but I'm afraid the 3.16-stable branch is no
> > > longer being maintained (as of today).
> > 
> > Want me to mark it EOL and remove it from the release table on
> > kernel.org now?
> 
> I was about to send that patch myself, but you're welcome to do so.

Now done.

> Thanks again for all your assistance with releasing updates for 3.2 and
> 3.16 over the past 8 years.

Hey, thanks for doing all the real work there, that was a lot!

greg k-h
