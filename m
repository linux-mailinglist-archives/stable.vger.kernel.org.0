Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 059F833F61C
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 17:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbhCQQzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 12:55:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:48078 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232158AbhCQQzf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Mar 2021 12:55:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 35E52AE5C;
        Wed, 17 Mar 2021 16:55:34 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id E70E51E3C6D; Wed, 17 Mar 2021 17:55:33 +0100 (CET)
Date:   Wed, 17 Mar 2021 17:55:33 +0100
From:   Jan Kara <jack@suse.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH stable 4.14.y 0/3] ext4: Avoid crash when journal inode
 extents are corrupted
Message-ID: <20210317165533.GF2541@quack2.suse.cz>
References: <20210317164414.17364-1-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317164414.17364-1-jack@suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed 17-03-21 17:44:11, Jan Kara wrote:
> Hello,
> 
> this is a backport of ext4 patches to avoid crashes when ext4 journal inode
> extents are corrupted to 4.14.y kernel.

BTW, these patches apply just fine to 4.9.y and 4.4.y stable kernels as well.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
