Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 600A2249B3E
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 12:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgHSKxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 06:53:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:34390 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726820AbgHSKxr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 06:53:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D1EFEB69C
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 10:54:12 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 27CC5DA703; Wed, 19 Aug 2020 12:52:41 +0200 (CEST)
Date:   Wed, 19 Aug 2020 12:52:40 +0200
From:   David Sterba <dsterba@suse.cz>
To:     stable@vger.kernel.org
Subject: Please add 881a3a11c2b858f to 4.19.x
Message-ID: <20200819105240.GJ2026@suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

please add patch

881a3a11c2b8 ("btrfs: fix return value mixup in btrfs_get_extent")

to 4.19 tree.

It's a fixup for patch 6bf9e4bd6a27 ("btrfs: inode: Verify inode mode to
avoid NULL pointer dereference"). I don't see it queued yet and the patch
is tagged for 5.4, this is just a heads up so it's not forgotten.

All the related patches:

6bf9e4bd6a27 ("btrfs: inode: Verify inode mode to avoid NULL pointer dereference")
9f7fec0ba891 ("Btrfs: fix selftests failure due to uninitialized i_mode in test inodes")
881a3a11c2b8 ("btrfs: fix return value mixup in btrfs_get_extent")

From 5.4 up it's fine.

Thanks.
