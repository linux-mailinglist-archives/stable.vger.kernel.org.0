Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05C74F017D
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 16:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbfKEPbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 10:31:48 -0500
Received: from verein.lst.de ([213.95.11.211]:46095 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731039AbfKEPbs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 10:31:48 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 27F7468AFE; Tue,  5 Nov 2019 16:31:45 +0100 (CET)
Date:   Tue, 5 Nov 2019 16:31:44 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Marta Rybczynska <mrybczyn@kalray.eu>
Cc:     Charles Machalow <csm10495@gmail.com>,
        linux-nvme <linux-nvme@lists.infradead.org>,
        kbusch <kbusch@kernel.org>, axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] nvme: change nvme_passthru_cmd64 to explicitly mark
 rsvd
Message-ID: <20191105153144.GA12437@lst.de>
References: <20191105061510.22233-1-csm10495@gmail.com> <442718702.90376810.1572939552776.JavaMail.zimbra@kalray.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <442718702.90376810.1572939552776.JavaMail.zimbra@kalray.eu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 05, 2019 at 08:39:12AM +0100, Marta Rybczynska wrote:
> Looks good to me. However, please note that the new ioctl made it already to 5.3.8.

It wasn't in 5.3, but it seems like you are right and it somehow got
picked for the stable releases.

Sasha, can you please revert 76d609da9ed1cc0dc780e2b539d7b827ce28f182
in 5.3-stable ASAP and make sure crap like backporting new ABIs that
haven't seen a release yet is never ever going to happen again?
