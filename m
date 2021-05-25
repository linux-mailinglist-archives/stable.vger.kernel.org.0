Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13EAE390057
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 13:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbhEYLyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 07:54:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229896AbhEYLyD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 07:54:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F6E46128D;
        Tue, 25 May 2021 11:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621943554;
        bh=9ZukJetR3nO4OU06xXfgJgJmLtE7I9siMrqqkw8nFDQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qYaXJIsDMEj2wRDMTA4Bxncz77G/IFoPUduc3e8QDKOIE8br0L/bKVZxv33iyK+LN
         kjGJgepCbrJTTv3ssY5FxzeoQ/7tq/PQwowZQetsrXxCaZ+YYZic39LAB03LFRva4P
         qioHV7jjvs9t5i/RRAo593DMK+v7pFZ1kXL03O6w=
Date:   Tue, 25 May 2021 13:52:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Michael Tokarev <mjt@tls.msk.ru>,
        Mike Snitzer <snitzer@redhat.com>,
        Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: Patch regression - Re: [PATCH 5.10 070/104] dm snapshot: fix a
 crash when an origin has no snapshots
Message-ID: <YKzk/2aqQooFsI28@kroah.com>
References: <20210524152332.844251980@linuxfoundation.org>
 <20210524152335.174655194@linuxfoundation.org>
 <alpine.LRH.2.02.2105250734180.13437@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2105250734180.13437@file01.intranet.prod.int.rdu2.redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 25, 2021 at 07:36:57AM -0400, Mikulas Patocka wrote:
> Hi Greg
> 
> I'd like to ask you to drop this patch from all stable branches.
> 
> It causes regression with snapshot merging and the regression is much 
> worse than the bug that it fixes.

Sure, but is there a fix in Linus's branch for this that I should take
instead, or is it reverted in linux-next already?

thanks,

greg k-h
