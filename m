Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6A8EB13A
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 14:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfJaNac (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 09:30:32 -0400
Received: from verein.lst.de ([213.95.11.211]:51011 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726836AbfJaNac (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 31 Oct 2019 09:30:32 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 88B4668C4E; Thu, 31 Oct 2019 14:30:28 +0100 (CET)
Date:   Thu, 31 Oct 2019 14:30:28 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Jian-Hong Pan <jian-hong@endlessm.com>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] Revert "nvme: Add quirk for Kingston NVME SSD
 running FW E8FK11.T"
Message-ID: <20191031133028.GA4617@lst.de>
References: <20191031093408.9322-1-jian-hong@endlessm.com> <20191031132853.GA46011@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031132853.GA46011@google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 31, 2019 at 08:28:53AM -0500, Bjorn Helgaas wrote:
> On Thu, Oct 31, 2019 at 05:34:09PM +0800, Jian-Hong Pan wrote:
> > Since commit 253eaf4faaaa ("PCI/MSI: Fix incorrect MSI-X masking on
> > resume") is merged, we can revert the previous quirk now.
> 
> 253eaf4faaaa is pending on my pci/msi branch, planned to be merged
> during the v5.5 merge window.
> 
> This revert patch must not be merged before 253eaf4faaaa.  The easiest
> way to do that would be for me to merge this one as well; otherwise
> we have to try to make things happen in the right order during the
> merge window.
> 
> If the NVMe folks ack this idea and the patch, I'd be happy to merge
> it.

Fine with me.

Acked-by: Christoph Hellwig <hch@lst.de>
