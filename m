Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B99B22A531
	for <lists+stable@lfdr.de>; Sat, 25 May 2019 18:07:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727150AbfEYQHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 12:07:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727149AbfEYQHK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 25 May 2019 12:07:10 -0400
Received: from localhost (unknown [62.129.28.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D82F2085A;
        Sat, 25 May 2019 16:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558800429;
        bh=Pdw0jGKErkhT0bJIjq4QixGkfv0ZqcxOnCNjhjVD+vk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WUgcwxRQwAx90gLA/19qmofd2xWlEpufoO0+Kpw/7u3qFe0O7vox9y0Y2FVcXcW9y
         CRmrWjbTfK50NQTYDZxVHUj9eccfn5PcpGPtI/1I6KvTeIV5Tv/yPHWS0eTzdDpPYt
         XPSJ//1zx5uI/+CqVlkIJvpSTIUZfgISDWDEabS4=
Date:   Sat, 25 May 2019 18:07:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Nigel Croxon <ncroxon@redhat.com>, Xiao Ni <xni@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH 4.19 108/114] Revert "Dont jump to compute_result state
 from check_result state"
Message-ID: <20190525160706.GA26722@kroah.com>
References: <20190523181731.372074275@linuxfoundation.org>
 <20190523181740.646499661@linuxfoundation.org>
 <20190525120835.GA2975@xo-6d-61-c0.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190525120835.GA2975@xo-6d-61-c0.localdomain>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 25, 2019 at 02:08:35PM +0200, Pavel Machek wrote:
> On Thu 2019-05-23 21:06:47, Greg Kroah-Hartman wrote:
> > From: Song Liu <songliubraving@fb.com>
> > 
> > commit a25d8c327bb41742dbd59f8c545f59f3b9c39983 upstream.
> > 
> > This reverts commit 4f4fd7c5798bbdd5a03a60f6269cf1177fbd11ef.
> > 
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Nigel Croxon <ncroxon@redhat.com>
> > Cc: Xiao Ni <xni@redhat.com>
> > Signed-off-by: Song Liu <songliubraving@fb.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> We normally reject patches without changelog, and this has none. Why
> make exception here?

Why are you reviewing stable kernel patches as if there is anything you
can do about them at this point in time to change things like this?
These are all mirrors of what is in Linus's tree.  If you object to the
original patch, that's fine, but please respond to the original patch,
not the stable kernel patches as there's nothing I can do about
changelog text at this late in the process.

thanks,

greg k-h
