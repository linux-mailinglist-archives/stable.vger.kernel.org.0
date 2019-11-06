Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A77F0B6E
	for <lists+stable@lfdr.de>; Wed,  6 Nov 2019 02:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbfKFBJo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 20:09:44 -0500
Received: from verein.lst.de ([213.95.11.211]:48411 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729632AbfKFBJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 20:09:44 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 26E0F68AFE; Wed,  6 Nov 2019 02:09:41 +0100 (CET)
Date:   Wed, 6 Nov 2019 02:09:40 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Marta Rybczynska <mrybczyn@kalray.eu>,
        Charles Machalow <csm10495@gmail.com>,
        linux-nvme <linux-nvme@lists.infradead.org>,
        kbusch <kbusch@kernel.org>, axboe <axboe@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] nvme: change nvme_passthru_cmd64 to explicitly mark
 rsvd
Message-ID: <20191106010940.GA3474@lst.de>
References: <20191105061510.22233-1-csm10495@gmail.com> <442718702.90376810.1572939552776.JavaMail.zimbra@kalray.eu> <20191105153144.GA12437@lst.de> <20191106000836.GH4787@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106000836.GH4787@sasha-vm>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 05, 2019 at 07:08:36PM -0500, Sasha Levin wrote:
> On Tue, Nov 05, 2019 at 04:31:44PM +0100, Christoph Hellwig wrote:
>> On Tue, Nov 05, 2019 at 08:39:12AM +0100, Marta Rybczynska wrote:
>>> Looks good to me. However, please note that the new ioctl made it already to 5.3.8.
>>
>> It wasn't in 5.3, but it seems like you are right and it somehow got
>> picked for the stable releases.
>>
>> Sasha, can you please revert 76d609da9ed1cc0dc780e2b539d7b827ce28f182
>> in 5.3-stable ASAP and make sure crap like backporting new ABIs that
>> haven't seen a release yet is never ever going to happen again?
>
> Sure, I'll revert it. I guess I wasn't expecting to see something like
> this in a -rc release. How did it make it into one if it's not a fix?

76d609da9ed1cc0dc780e2b539d7b827ce28f182 is a backport of
65e68edce0db433aa0c2b26d7dc14fbbbeb89fbb, which went into 5.4-rc2 and
was not marked for stable.  It might kinda bend the normal merge
window rules a little, but I don't see how it could be considered
something to backport.
