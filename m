Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F15C136C968
	for <lists+stable@lfdr.de>; Tue, 27 Apr 2021 18:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237535AbhD0Q1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Apr 2021 12:27:06 -0400
Received: from verein.lst.de ([213.95.11.211]:46016 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238989AbhD0Q0O (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Apr 2021 12:26:14 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5DF8B68C7B; Tue, 27 Apr 2021 18:25:23 +0200 (CEST)
Date:   Tue, 27 Apr 2021 18:25:21 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     mwilck@suse.com, Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Chao Leng <lengchao@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        linux-nvme@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] nvme: rdma/tcp: fix list corruption with anatt timer
Message-ID: <20210427162521.GA26528@lst.de>
References: <20210427085246.13728-1-mwilck@suse.com> <0ff2dbc0-0182-f54d-b750-084feac53601@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ff2dbc0-0182-f54d-b750-084feac53601@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 27, 2021 at 11:33:04AM +0200, Hannes Reinecke wrote:
> As indicated in my previous mail, please change the description. We have
> since established a actual reason (duplicate calls to add_timer()), so
> please list it here.

So what happens if the offending add_timer is changed to mod_timer?
