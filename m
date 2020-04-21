Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805691B2E60
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgDURgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:36:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbgDURgU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 Apr 2020 13:36:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D3C92070B;
        Tue, 21 Apr 2020 17:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587490579;
        bh=Nd2Ky5AP0fOPeOT0iXoL8NcGJnlzJH+eMXG/Jv+MAoc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nUOJAshrkd1y0A4PCZzIhTKV8bTQAoF/jYbeh0Z9JZh2G2Na+PT1XPylNbcpeBzaB
         vmMfn7RADyt3Ar7WmU93tMbrx3uG6iVSeN2vMTqnXdxq2YSszNIXp/O21eT+D9C2g0
         V1RwOgJzhcDxKFeF2thXZNyj0fylGLDTTCoipiLQ=
Date:   Tue, 21 Apr 2020 19:36:03 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Thomas Backlund <tmb@mageia.org>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        stable <stable@vger.kernel.org>, Chris Evich <cevich@redhat.com>,
        Patrick Dung <patdung100@gmail.com>,
        jordanrussellx+kobz@gmail.com,
        Thorsten Schubert <tschubert@bafh.org>
Subject: Re: block, bfq: port of fix commits to (at least) 5.6
Message-ID: <20200421173603.GA1307163@kroah.com>
References: <BD02F95A-0A08-4BEB-9309-9941998EE14C@linaro.org>
 <d1583eef-44a0-a278-09c0-45dbfb2e4403@mageia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1583eef-44a0-a278-09c0-45dbfb2e4403@mageia.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 08:20:46PM +0300, Thomas Backlund wrote:
> Den 21-04-2020 kl. 13:25, skrev Paolo Valente:
> > Hi,
> > a bug reported for Fedora [1] goes away with the following fix
> > commits, currently available from 5.7-rc1.
> > 
> > 4d38a87fbb77 block, bfq: invoke flush_idle_tree after reparent_active_queues in pd_offline
> > 576682fa52cb block, bfq: make reparent_leaf_entity actually work only on leaf entities
> > c89977366500 block, bfq: turn put_queue into release_process_ref in __bfq_bic_change_cgroup
> > 
> 
> Just to point out to others picking theese patches...
> 
> the list should be applied in reverse order from bottom up (meaning
> c89977366500 first, then 576682fa52cb and 4d38a87fbb77 last...)

Thanks, I've queued these up for 5.4.y and 5.6.y.

greg k-h
