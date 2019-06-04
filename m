Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A60A34B9D
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 17:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbfFDPIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 11:08:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727822AbfFDPH7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 11:07:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C00372075B;
        Tue,  4 Jun 2019 15:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559660879;
        bh=HgdedshKqr1Ys+hFidkotL5bYoiAItmgQsqA7jEQk30=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EbYBWqZNwXGgXPlJP7cChQNan6XLawsykZD1cBVIFNoWXAmEiWU3borq/vxZo/fkh
         jeGPuwte7dbWgXpcYpOOhR0MURuEIU0zqwbPon6cAM+pV2ErVfQTNRGS7JIycg218C
         aEI30xS/K46XQDVdcyxpybul/xl02y8h+Nh8xHdI=
Date:   Tue, 4 Jun 2019 17:07:56 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     stable@vger.kernel.org, aarcange@redhat.com,
        akpm@linux-foundation.org, ben.hutchings@codethink.co.uk,
        jannh@google.com, jgg@mellanox.com, oleg@redhat.com,
        peterx@redhat.com, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, stable-commits@vger.kernel.org
Subject: Re: Patch "coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping" has been added to the
 4.4-stable tree
Message-ID: <20190604150756.GA24221@kroah.com>
References: <155965961313615@kroah.com>
 <20190604145216.GJ4669@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604145216.GJ4669@dhcp22.suse.cz>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 04, 2019 at 04:52:31PM +0200, Michal Hocko wrote:
> Please note that I have posted my backport today
> http://lkml.kernel.org/r/20190604094953.26688-1-mhocko@kernel.org and it
> differs from this one. Please have a look!

Ah, good point, I just noticed that.  Ben, any thoughts as to the
difference?

thanks,

greg k-h
