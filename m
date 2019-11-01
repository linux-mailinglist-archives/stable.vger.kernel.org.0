Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8E5ECBA0
	for <lists+stable@lfdr.de>; Fri,  1 Nov 2019 23:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbfKAWoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Nov 2019 18:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727698AbfKAWoS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 Nov 2019 18:44:18 -0400
Received: from localhost (unknown [69.71.4.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 49B6B20679;
        Fri,  1 Nov 2019 22:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572648257;
        bh=jKdvO6K6agf1X5ZMKWmP5BbUA3Dp+9K9j78HOVQdQB0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=mLfWOnV1eB6Wls7fOmu5HwS2ta7iYqfF+lU4Naj8OH/ubYXaEr3/kLNgW57+ZJltH
         MHG42tXl03V3NabxM/fdpPL5bXs+Mb6BOmrlrLLyTlIHTeh05LbkbyHtDToOjdV8Gv
         a+K5JEZAErTjNeGslhGLkVraqB0Ds2UAoyE5QOhg=
Date:   Fri, 1 Nov 2019 17:44:16 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jian-Hong Pan <jian-hong@endlessm.com>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] Revert "nvme: Add quirk for Kingston NVME SSD running
 FW E8FK11.T"
Message-ID: <20191101224416.GA225762@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031133028.GA4617@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 31, 2019 at 02:30:28PM +0100, Christoph Hellwig wrote:
> On Thu, Oct 31, 2019 at 08:28:53AM -0500, Bjorn Helgaas wrote:
> > On Thu, Oct 31, 2019 at 05:34:09PM +0800, Jian-Hong Pan wrote:
> > > Since commit 253eaf4faaaa ("PCI/MSI: Fix incorrect MSI-X masking on
> > > resume") is merged, we can revert the previous quirk now.
> > 
> > 253eaf4faaaa is pending on my pci/msi branch, planned to be merged
> > during the v5.5 merge window.
> > 
> > This revert patch must not be merged before 253eaf4faaaa.  The easiest
> > way to do that would be for me to merge this one as well; otherwise
> > we have to try to make things happen in the right order during the
> > merge window.
> > 
> > If the NVMe folks ack this idea and the patch, I'd be happy to merge
> > it.
> 
> Fine with me.
> 
> Acked-by: Christoph Hellwig <hch@lst.de>

OK, I'll ask Linus to merge this revert after my main PCI pull request
for v5.5-rc1.
