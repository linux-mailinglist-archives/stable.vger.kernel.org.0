Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 890901F7398
	for <lists+stable@lfdr.de>; Fri, 12 Jun 2020 07:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbgFLFq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jun 2020 01:46:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726361AbgFLFq5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jun 2020 01:46:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95627207ED;
        Fri, 12 Jun 2020 05:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591940817;
        bh=RpfK8tUvYNBslNLLMgwP6HmyOmyHU1xGqpf9TjHA70M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DXFjdxFsy7j+xP8HOLEuk7lb+angvR9lEZzSxC16aFbIt7rUXi+sD8gtFVP15HLVq
         rzoNOWScRZPPcd0YswqMMeEQfJm01Ze1rTrhF8EvyGe/21bBJ371PCCXbwoTwZSDmC
         k0i44cmbbWGsNeJcJNz/1I1ne1iKgEIgjDCjInLA=
Date:   Fri, 12 Jun 2020 07:46:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 4.19 24/25] uprobes: ensure that uprobe->offset and
 ->ref_ctr_offset are properly aligned
Message-ID: <20200612054653.GA2596727@kroah.com>
References: <20200609174048.576094775@linuxfoundation.org>
 <20200609174051.488794266@linuxfoundation.org>
 <CA+G9fYukN5V1z3g6Qwe9K5xnnXEuFafWdqGfDA1Wj2iVstoxfw@mail.gmail.com>
 <20200609190321.GA1046130@kroah.com>
 <20200610145305.GA3254@redhat.com>
 <20200610145855.GA2102398@kroah.com>
 <20200611165116.GE12500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200611165116.GE12500@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 11, 2020 at 06:51:17PM +0200, Oleg Nesterov wrote:
> On 06/10, Greg Kroah-Hartman wrote:
> >
> > > Greg, please let me know if you want me to send the patches for 4.9/4.14/4.19.
> >
> > Please do.  I tried to backport it to those trees, and it seems to
> > build/boot/run, but I would like verification I didn't mess anything up
> > :)
> >
> > Your 4.4 version below matched my version, so I think I'm ok...
> 
> Greg, I was going to send the patches, but after I've cloned
> git/stable/linux-stable-rc.git I see that you have already updated these
> 
> 	origin/queue/4.14
> 	origin/queue/4.19
> 	origin/queue/4.4
> 	origin/queue/4.9
> 
> branches, and the new patches look good to me.
> 
> So I think I can relax? ;)

Yes, please relax, all is fine, thanks for verifying.

greg k-h
