Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 963851ADDF1
	for <lists+stable@lfdr.de>; Fri, 17 Apr 2020 15:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730640AbgDQM7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Apr 2020 08:59:33 -0400
Received: from verein.lst.de ([213.95.11.211]:57514 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730166AbgDQM7c (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 17 Apr 2020 08:59:32 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A72B768BEB; Fri, 17 Apr 2020 14:59:29 +0200 (CEST)
Date:   Fri, 17 Apr 2020 14:59:29 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     kbusch@kernel.org, axboe@fb.com, hch@lst.de, sagi@grimberg.me,
        linux-stable <stable@vger.kernel.org>,
        "open list:NVM EXPRESS DRIVER" <linux-nvme@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nvme/pci: Use Discard instead of Write Zeroes on SK
 hynix SC300
Message-ID: <20200417125929.GA5053@lst.de>
References: <20200417083641.28205-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417083641.28205-1-kai.heng.feng@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 17, 2020 at 04:36:41PM +0800, Kai-Heng Feng wrote:
> After commit 6e02318eaea5 ("nvme: add support for the Write Zeroes
> command"), SK hynix SC300 becomes very slow with the following error
> message:
> [  224.567695] blk_update_request: operation not supported error, dev nvme1n1, sector 499384320 op 0x9:(WRITE_ZEROES) flags 0x1000000 phys_seg 0 prio class 0]
> 
> Use quirk NVME_QUIRK_DEALLOCATE_ZEROES to workaround this issue.

Do you have a written guarantee from SK Hynix that it will always zero
all blocks discarded?
