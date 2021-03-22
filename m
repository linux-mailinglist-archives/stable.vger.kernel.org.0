Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60300343B9D
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 09:22:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbhCVIWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 04:22:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:48646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229955AbhCVIWI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 04:22:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B67C61967;
        Mon, 22 Mar 2021 08:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616401328;
        bh=CZsoXS4pvunxg0Xxd6ZM6Az/+gNltMawubJvOeQbZcM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q9jR11ysigNZjr+ZktwhoMI5LXbZpdxinjgXmW+SUU9A7K3T5gA+VL6g+F9Y1LR1h
         xCfTmlOvcrJ/ceGmq/rjAW76sloz+6b3OewgftnWCp7tcpNuIr/zy+RH3woR2xSEN+
         HGTDIrDic4EJkiO3OXYQnx5fO5NBhhvrkbCE5aFimIBR34RIV28v7BSZ0rEvabQy28
         Uti/+zutBN5nrLL7ibwouyFe0oxAN2K9vdC44aprEKy8+LGnuCkwj8DbRHjUUhQzDg
         VgQX61FNEqHxGKm7Ejbpw6dM26z7PWJbohYFZlWaHtzXQgsXd+QT659MFxHmaV6Lvu
         MZ1cwDtc4gDBA==
Received: from johan by xi with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1lOFpP-0002WC-Tx; Mon, 22 Mar 2021 09:22:24 +0100
Date:   Mon, 22 Mar 2021 09:22:23 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Rob Herring <robh@kernel.org>,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Jens Frederich <jfrederich@gmail.com>,
        Jon Nettleton <jon.nettleton@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] x86/apic/of: Fix CPU devicetree-node lookups
Message-ID: <YFhTv5Q++b0PtH8P@hovoldconsulting.com>
References: <20210312092033.26317-1-johan@kernel.org>
 <87mtuyby66.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mtuyby66.fsf@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 11:01:37PM +0100, Thomas Gleixner wrote:
> On Fri, Mar 12 2021 at 10:20, Johan Hovold wrote:
> >  arch/x86/kernel/apic/apic.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > It's been over three months so resending.
> 
> Sorry, was probably lost in my post X-mas mark all mails read habit.

Figured that may have had something to do with it, and I guess you
didn't see my reminder either as you'd marked the thread as read. I'll
resend sooner next time.

> > Can someone please pick this up for 5.12 or -next?
> 
> Sure.

Great, thanks!

Johan
