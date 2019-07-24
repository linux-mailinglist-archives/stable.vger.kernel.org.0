Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFD872E64
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 14:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfGXMGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 08:06:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726256AbfGXMGa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 08:06:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E37D229ED;
        Wed, 24 Jul 2019 12:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563969989;
        bh=UrvBfSFfdgX3XtYSua8OOkBjNQwRSpuzD+1Mmojd5GM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dy78UkwRpkS7MDo15BwOg/eN8jsHFFWN4nYUzTF/2XKuc7vZ95uysiOASHMgI6opa
         Vi2+wcTPo8Omx91MynCb5WAQPkkT3edY371PhAOMzYT9DX4vjZHG+j/Sft3U1YEUiE
         lVSP2UpQ6JKZuKddHdK2mMnvXyh1eTCk/2GwTiiw=
Date:   Wed, 24 Jul 2019 14:06:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     torvalds@linux-foundation.org, aarcange@redhat.com,
        hughd@google.com, dave.hansen@intel.com, mgorman@suse.de,
        riel@redhat.com, mhocko@suse.cz, jannh@google.com,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        stable@vger.kernel.org, srivatsab@vmware.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com, srinidhir@vmware.com,
        bvikas@vmware.com, srostedt@vmware.com
Subject: Re: [PATCH 0/8] Backported fixes for 4.4 stable tree
Message-ID: <20190724120627.GF3244@kroah.com>
References: <1563880111-19058-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563880111-19058-1-git-send-email-akaher@vmware.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 23, 2019 at 04:38:23PM +0530, Ajay Kaher wrote:
> These patches include few backported fixes for the 4.4 stable
> tree.
> I would appreciate if you could kindly consider including them in the
> next release.

Why are these needed?  From what I remember, the last patch here is only
needed for machines that are "HUGE" and for those, you shouldn't be
using 4.4.y anymore anyway, right?  You just end up saving so much more
speed and energy using a newer kernel, why would you want to waste it
using an older one?

So I need a really good reason why to accept these :)

thanks,

greg k-h
