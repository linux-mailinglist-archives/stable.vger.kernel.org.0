Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6007110ECE4
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 17:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfLBQPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 11:15:48 -0500
Received: from verein.lst.de ([213.95.11.211]:39217 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727471AbfLBQPs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 11:15:48 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 537AD68BE1; Mon,  2 Dec 2019 17:15:45 +0100 (CET)
Date:   Mon, 2 Dec 2019 17:15:45 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Keith Busch <kbusch@kernel.org>
Cc:     linux-nvme@lists.infradead.org, hch@lst.de,
        Ingo Brunberg <ingo_brunberg@web.de>,
        Sagi Grimberg <sagi@grimberg.me>, stable@vger.kernel.org
Subject: Re: [PATCH] nvme: Namepace identification descriptor list is
 optional
Message-ID: <20191202161545.GA7434@lst.de>
References: <20191202155611.21549-1-kbusch@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202155611.21549-1-kbusch@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 03, 2019 at 12:56:11AM +0900, Keith Busch wrote:
> Despite NVM Express specification 1.3 requires a controller claiming to
> be 1.3 or higher implement Identify CNS 03h (Namespace Identification
> Descriptor list), the driver doesn't really need this identification in
> order to use a namespace. The code had already documented in comments
> that we're not to consider an error to this command.
> 
> Return success if the controller provided any response to an
> namespace identification descriptors command.
> 
> Fixes: 538af88ea7d9de24 ("nvme: make nvme_report_ns_ids propagate error back")
> Reported-by: Ingo Brunberg <ingo_brunberg@web.de>

Why would we ignore the error?  Do you have a buggy controller messing
this up?
