Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D42A3726EF
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 10:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhEDIJM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 04:09:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:50796 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230108AbhEDIJM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 May 2021 04:09:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1620115696; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7YLxD4201LgDHt76WCSlvgaGUhn0EbWLY1JsN+RF+qE=;
        b=WzESRdUbXbhqakrRxoTT0SfkiyVbjoCvrnlMo9UhEgBb3mYjFBOs1QnMxyNgXXQLbMcQpb
        17ESFnkWA87pr++MRcEoAUatkLeilEsqJU0u356DhfvqwDFU31DoGF9fo8TVtvn09OnRcA
        IrbcqQM65gK7KqANW53zNzqSs2feNfM=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9BCC5AECB;
        Tue,  4 May 2021 08:08:16 +0000 (UTC)
Message-ID: <976928a1a0ea430f48af8c20b6b3799e7e6791ec.camel@suse.com>
Subject: Re: [PATCH v4] nvme: rdma/tcp: fix list corruption with anatt timer
From:   Martin Wilck <mwilck@suse.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
        Chao Leng <lengchao@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>,
        linux-nvme@lists.infradead.org, stable@vger.kernel.org
Date:   Tue, 04 May 2021 10:08:14 +0200
In-Reply-To: <20210504075257.GA17142@lst.de>
References: <20210427093110.16461-1-mwilck@suse.com>
         <20210429122433.GA27567@lst.de> <20210504075257.GA17142@lst.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Christoph,

On Tue, 2021-05-04 at 09:52 +0200, Christoph Hellwig wrote:
> On Thu, Apr 29, 2021 at 02:24:33PM +0200, Christoph Hellwig wrote:
> > Martin,
> > 
> > can you give this patch a spin and check if this solves your issue?
> 
> ping?

I've provided a test kernel with your patch to the SUSE partner in
question, but it's hard to reproduce, the test will take time.

Regards
Martin


