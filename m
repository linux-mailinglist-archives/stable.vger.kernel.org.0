Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 769073871FF
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 08:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhERGis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 02:38:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:56832 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230177AbhERGis (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 May 2021 02:38:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8C035B062;
        Tue, 18 May 2021 06:37:29 +0000 (UTC)
Date:   Tue, 18 May 2021 08:37:29 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Enzo Matsumiya <ematsumiya@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH AUTOSEL 5.4 2/2] nvmet: seset ns->file when open fails
Message-ID: <20210518063729.ppvsr4ni4yvirblw@beryllium.lan>
References: <20210518011002.1485938-1-sashal@kernel.org>
 <20210518011002.1485938-2-sashal@kernel.org>
 <BYAPR04MB4965B34C6F9C5E833782C7C1862C9@BYAPR04MB4965.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR04MB4965B34C6F9C5E833782C7C1862C9@BYAPR04MB4965.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Chaitanya,

On Tue, May 18, 2021 at 04:27:32AM +0000, Chaitanya Kulkarni wrote:
> I think the patch subject line is being worked on since it needs to be
> reset and not seset.
> 
> Not sure how we can go about fixing that.

This ship has sailed, as the commit already hit mainline. Fixing the
typo in the back ports is surely possible but I assume it's better not
do change the subject line. seset forever!

Thanks,
Daniel
