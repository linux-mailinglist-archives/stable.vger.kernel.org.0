Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF566AF90C
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 11:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbfIKJff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 05:35:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727471AbfIKJff (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 05:35:35 -0400
Received: from localhost (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 46A9B2089F;
        Wed, 11 Sep 2019 09:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568194534;
        bh=Un1JpOS93XSCTrbz75Ep3c5FA22URzD0+5XcajleO3Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GttIcZwrTmVuDE/ngRKjYYUGYBilG83frfYUE4JC4NPhNfqwnJvdtA25fUHQPPtvd
         4gjPLPgY/azpMk1Xf1f1dBqZDoge7KwTJAtWzTaVGR8LEAg4xybwLtkb0agoR4ggRD
         gAu1QHXC9sray77FSkrmrsHanGpAufcZvH/1HICY=
Date:   Wed, 11 Sep 2019 10:35:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Tiwei Bie <tiwei.bie@intel.com>, stable@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com
Subject: Re: [PATCH 4.14] vhost/test: fix build for vhost test
Message-ID: <20190911093532.GA17308@kroah.com>
References: <20190911025055.26774-1-tiwei.bie@intel.com>
 <20190911091631.GI2012@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911091631.GI2012@sasha-vm>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 11, 2019 at 05:16:31AM -0400, Sasha Levin wrote:
> On Wed, Sep 11, 2019 at 10:50:55AM +0800, Tiwei Bie wrote:
> > commit 264b563b8675771834419057cbe076c1a41fb666 upstream.
> > 
> > Since vhost_exceeds_weight() was introduced, callers need to specify
> > the packet weight and byte weight in vhost_dev_init(). Note that, the
> > packet weight isn't counted in this patch to keep the original behavior
> > unchanged.
> > 
> > Fixes: e82b9b0727ff ("vhost: introduce vhost_exceeds_weight()")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Tiwei Bie <tiwei.bie@intel.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Acked-by: Jason Wang <jasowang@redhat.com>
> 
> I've queued it up for 4.14, 4.9, and 4.4. Thank you.

So did I, I think you will get conflicts when you try to merge :)
