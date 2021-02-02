Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A0630BB5D
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 10:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhBBJuM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 04:50:12 -0500
Received: from verein.lst.de ([213.95.11.211]:45195 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229693AbhBBJuJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 04:50:09 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9517667357; Tue,  2 Feb 2021 10:49:22 +0100 (CET)
Date:   Tue, 2 Feb 2021 10:49:21 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Thorsten Leemhuis <linux@leemhuis.info>
Cc:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] nvme-pci: add quirk to make Kingston A2000 SSD avoid
 deepest sleep state
Message-ID: <20210202094921.GA18895@lst.de>
References: <20210129052442.310780-1-linux@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129052442.310780-1-linux@leemhuis.info>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks,

applied to nvme-5.11.
