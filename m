Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD47A132A79
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 16:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbgAGPvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 10:51:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:42820 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727994AbgAGPvU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 10:51:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1CB9BABEA;
        Tue,  7 Jan 2020 15:51:19 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id D32311E0B47; Tue,  7 Jan 2020 16:51:18 +0100 (CET)
Date:   Tue, 7 Jan 2020 16:51:18 +0100
From:   Jan Kara <jack@suse.cz>
To:     stable@vger.kernel.org
Cc:     Philipp Matthias Hahn <pmhahn@pmhahn.de>
Subject: Include DVD reading fixes
Message-ID: <20200107155118.GH25547@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello!

Phillipp has asked me whether I could send commits:

cba22d86e0a1 bdev: Refresh bdev size for disks without partitioning
731dc4868311 bdev: Factor out bdev revalidation into a common helper

for inclusion into stable. I've noticed they are already in 5.4-stable but
they didn't seem to propagate into say 4.19-stable although they apply just
fine there. Any reason for that?

The fixes fix mounting of encrypted UDF media for some setups and they are
reasonably safe so I'm fine with pushing them to stable.

							Thanks!
								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
