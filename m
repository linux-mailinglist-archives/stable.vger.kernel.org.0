Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAA7510F214
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 22:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725874AbfLBVVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 16:21:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:60746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfLBVVq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 16:21:46 -0500
Received: from redsun51.ssa.fujisawa.hgst.com (unknown [199.255.47.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A34E206ED;
        Mon,  2 Dec 2019 21:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575321706;
        bh=KWOzQgN2GjtJ55UhrH4KqmGcy50+XJNobEXbyl1W4Tg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aeBSF0oUHHlTIDzqO/WWMhkIvNTF3wuN5mLriVvhk9pLdHIV8kB+8xjINMaiJz0Ew
         Y15zuGAuS2H0JHjv2XOggRdbfT5pjnpBQ4LmPwB8r7vFWIP5FLlj2W8td634cEn/Sz
         zKexGN4+d/Pw/+pbDpq/qf4l6huYVxm06qMFkzCE=
Date:   Tue, 3 Dec 2019 06:21:40 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Nadolski, Edmund" <edmund.nadolski@intel.com>,
        stable@vger.kernel.org, Ingo Brunberg <ingo_brunberg@web.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH] nvme: Namepace identification descriptor list is optional
Message-ID: <20191202212140.GA25428@redsun51.ssa.fujisawa.hgst.com>
References: <20191202155611.21549-1-kbusch@kernel.org>
 <20191202161545.GA7434@lst.de>
 <20191202162256.GA21631@redsun51.ssa.fujisawa.hgst.com>
 <10e6520d-bc8c-94ff-00c4-32a727131b89@intel.com>
 <20191202162905.GA7683@lst.de>
 <20191202164903.GA21650@redsun51.ssa.fujisawa.hgst.com>
 <20191202173414.GA8950@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202173414.GA8950@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 02, 2019 at 06:34:14PM +0100, Christoph Hellwig wrote:
> Yes. I guess your patch is the best thing for now:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks, applied for-5.5
 
> But I think we might need a new kernel tain flag or something like
> it for devices that are so obviously broken in their identifiers.

That's fine with me. We currently just log a warning when an error
is returned here, we can add_taint() too. Which flag do you think?
TAINT_FIRMWARE_WORKAROUND, TAINT_CRAP, or something else?
