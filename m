Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26DA7F414E
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 08:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730151AbfKHHXp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 02:23:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:43580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730144AbfKHHXp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 02:23:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27C1920865;
        Fri,  8 Nov 2019 07:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573197824;
        bh=DDfs6FWc8p3pAzEndhsq6wQPUgefCA0dOddZfYHyZkY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fJ3ccBshDAatN6O+7cCd/FlB+Eac964P6cE8s4mGkbVG/ypROfy4YZmqnjKic6bcc
         XBbP0hYexFDzyMtYEeihnMqXHIzIQQUJq33IzoeRCTErwiqXrGSrUM+tlxMch0hkCV
         +wk85BEc3lBvvDrM2Rb5l66ExRIiIpS8hEk8hlg4=
Date:   Fri, 8 Nov 2019 08:23:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4.19 114/149] UAS: Revert commit 3ae62a42090f ("UAS: fix
 alignment of scatter/gather segments")
Message-ID: <20191108072342.GA583220@kroah.com>
References: <Pine.LNX.4.44L0.1911051007140.1678-100000@iolanthe.rowland.org>
 <1572968467.2921.27.camel@suse.com>
 <20191105163805.GB2760793@kroah.com>
 <1573126365.3024.4.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573126365.3024.4.camel@suse.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 07, 2019 at 12:32:45PM +0100, Oliver Neukum wrote:
> Am Dienstag, den 05.11.2019, 17:38 +0100 schrieb Greg Kroah-Hartman:
> > > > Given this information, perhaps you will decide that the revert is 
> > > > worthwhile.
> > > 
> > > Damned if I do, damned if I do not.
> > > Check for usbip and special case it?
> > 
> > We should be able to do that in the host controller driver for usbip,
> > right?  What is the symptom if you use a UAS device with usbip and this
> > commit?
> 
> Yes, that patch should then also be applied. Then it will work.
> Without it, commands will fail, as transfers will end prematurely.

Ok, I'm confused now.  I just checked, and I really have no idea what
needs to be backported anymore.  3ae62a42090f ("UAS: fix alignment of
scatter/gather segments") was backported to all of the stable kernels,
and now we reverted it.

So what else needs to be done here?

thanks,

greg k-h
