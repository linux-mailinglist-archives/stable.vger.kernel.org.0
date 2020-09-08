Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0376526180C
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 19:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731682AbgIHRr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 13:47:58 -0400
Received: from verein.lst.de ([213.95.11.211]:53571 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732104AbgIHRrw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 13:47:52 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3C68668AFE; Tue,  8 Sep 2020 19:47:50 +0200 (CEST)
Date:   Tue, 8 Sep 2020 19:47:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     James Smart <james.smart@broadcom.com>
Cc:     linux-nvme@lists.infradead.org, stable@vger.kernel.org,
        Israel Rukshin <israelr@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH] nvme: Revert: Fix controller creation races with
 teardown flow
Message-ID: <20200908174750.GA20319@lst.de>
References: <20200828190150.34455-1-james.smart@broadcom.com> <20200908174727.GA20285@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908174727.GA20285@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 08, 2020 at 07:47:27PM +0200, Christoph Hellwig wrote:
> Applied to nvme-5.8.

Err, 5.9 of course.
