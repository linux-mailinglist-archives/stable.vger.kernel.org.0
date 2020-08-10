Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FD62406FB
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 15:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgHJNwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 09:52:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbgHJNwH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 09:52:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4EF6120734;
        Mon, 10 Aug 2020 13:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597067526;
        bh=ky8q12nps6XR1CLk7mITGJzp58pN0JcVTRBo/U1W5HA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CXtTV469HiDRgKLf7lCfrE861GdEHlCOGufh8AGEATb3DH7n9K720rbLh/jzDSWxR
         uCebORZ1l6VoNMaxq76myLR1CieaiCHSPjPc1eVzZYWvGh8+D/htMZ4DqG7ccuiuLQ
         vqQAIImR+HzHCmQHxQPdc2CYvOyY4odOyjQn3FRw=
Date:   Mon, 10 Aug 2020 15:52:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chuck Lever <chuck.lever@oracle.com>,
        Timo Rothenpieler <timo@rothenpieler.org>
Cc:     stable@vger.kernel.org
Subject: Re: Backport request: nfsd: Fix NFSv4 READ on RDMA when using readv
Message-ID: <20200810135218.GC3491228@kroah.com>
References: <9cc28958-b715-5e51-e0c8-6f1821d2bfe0@rothenpieler.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9cc28958-b715-5e51-e0c8-6f1821d2bfe0@rothenpieler.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 04, 2020 at 10:47:26PM +0200, Timo Rothenpieler wrote:
> Sorry if this is not the right approach to this, but I'd like to request a
> backport of 412055398b9e67e07347a936fc4a6adddabe9cf4, "nfsd: Fix NFSv4 READ
> on RDMA when using readv" to Linux 5.4.
> 
> The patch applies cleanly and fixes a rare but severe issue with NFS over
> RDMA, which I just spent several days tracking down to that patch, with
> major help from linux-nfs/rdma.
> 
> I have right now manually applied it to my 5.4 Kernel and can confirm it
> fixes the issue.

It's good to cc: the developers/maintainers of the patch you are asking
about, to see if they object or not.

Chuck, any objection for the above patch being added to 5.4 and maybe
4.19?

thanks,

greg k-h
