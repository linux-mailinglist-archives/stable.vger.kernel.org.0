Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3D4E7E0A2
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 18:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbfHAQ5J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 12:57:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbfHAQ5I (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Aug 2019 12:57:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78E632064A;
        Thu,  1 Aug 2019 16:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564678628;
        bh=4ezqwlPAovpVuLlfTDzS1AWwDrqX++zYUnYp2p9b17s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q1WUKMDY3IL927TyRZwS7f3cRNOL2/DXVLQ+l59r43JrdhEuA+JvbMqeohhpPkBdx
         nJvgax8KDyIsfdyhEQQKyhCmL8cobgwK5sJfEO5liDwipVQeCbsQBRR8eSZPbFopkq
         Xn31aLfYr1p+KwmYrTHZlHG8Ci5LD29j5OoBfJ9o=
Date:   Thu, 1 Aug 2019 18:57:05 +0200
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
Message-ID: <20190801165705.GA29730@kroah.com>
References: <1563880111-19058-1-git-send-email-akaher@vmware.com>
 <20190724120627.GF3244@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724120627.GF3244@kroah.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 02:06:27PM +0200, Greg KH wrote:
> On Tue, Jul 23, 2019 at 04:38:23PM +0530, Ajay Kaher wrote:
> > These patches include few backported fixes for the 4.4 stable
> > tree.
> > I would appreciate if you could kindly consider including them in the
> > next release.
> 
> Why are these needed?  From what I remember, the last patch here is only
> needed for machines that are "HUGE" and for those, you shouldn't be
> using 4.4.y anymore anyway, right?  You just end up saving so much more
> speed and energy using a newer kernel, why would you want to waste it
> using an older one?
> 
> So I need a really good reason why to accept these :)

It's been a week, so I'm dropping this from my queue now.  Please resend
with this information if you still want these in the tree.

thanks,

greg k-h
