Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 659CE36C186
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 11:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbhD0JR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 05:17:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:57676 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235179AbhD0JR1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Apr 2021 05:17:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8AF8CB034;
        Tue, 27 Apr 2021 09:16:43 +0000 (UTC)
Date:   Tue, 27 Apr 2021 11:16:43 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     mwilck@suse.com
Cc:     Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Chao Leng <lengchao@huawei.com>,
        Hannes Reinecke <hare@suse.de>, linux-nvme@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] nvme: rdma/tcp: fix list corruption with anatt timer
Message-ID: <20210427091643.sk3uaasam5jm4rlh@beryllium.lan>
References: <20210427085246.13728-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210427085246.13728-1-mwilck@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 27, 2021 at 10:52:46AM +0200, mwilck@suse.com wrote:
> If anyone has better ideas, please advise. The issue occurs very
> sporadically; verifying this by testing will be difficult.

Maybe you could update the commit message with Chao's analysis?

