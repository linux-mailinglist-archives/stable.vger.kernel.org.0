Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15F0FE6163
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 08:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbfJ0HTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 03:19:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:37002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfJ0HTd (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 03:19:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 935022064A;
        Sun, 27 Oct 2019 07:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572160773;
        bh=xQocncbOlIoL/WgM7t2ulFQv3e8xeuC0u9dM7LGqdKY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qjnGhrPmLNZcKq4OIOUdHyDeuyU+1HJFjZHvGMh1kUaLfruWe/o1wUsgVtUWOWUlM
         I5GRasfvFU8uUSqy71X4E0aRhRVfpBKzaXbCYwp3Hz4GrtDL8tiTUS4WPTRn4CvQN2
         A8t/myODNNFjAeCLIrL6VBpRVvNLvzCfYsCXBef4=
Date:   Sun, 27 Oct 2019 08:19:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vincent Fortier <th0ma7@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: Request for backporting to 4.4 & 4.9: xenbus: Avoid deadlock
 during suspend due to open transactions
Message-ID: <20191027071930.GA1755924@kroah.com>
References: <CALAySuL6D7_LAK6tpzhBg07664NYFGfhe-A5G0H2vNWvdP=uqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALAySuL6D7_LAK6tpzhBg07664NYFGfhe-A5G0H2vNWvdP=uqA@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 26, 2019 at 03:41:27PM -0400, Vincent Fortier wrote:
> Hi all,
> 
> I just found out that there may be a fix for our live-migration issues
> that we have been plagued with for quite a while.  The fix sits under
> 5.2 kernel at:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v5.2.21&id=d10e0cc113c9e1b64b5c6e3db37b5c839794f3df
> 
> I believe this is material for the 4.4 & 4.9 stable trees as we've
> been hitting this issue under ubuntu 4.4 kernels.

Have you tested this change there?  It does not apply cleanly to those
kernel trees, if you can provide a working backport for 4.14.y, 4.9.y,
and 4.4.y I will be glad to queue it up.

thanks,

greg k-h
