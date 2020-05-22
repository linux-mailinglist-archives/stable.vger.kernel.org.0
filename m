Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63BA1DDBEB
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 02:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730687AbgEVAMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 20:12:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:58774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730686AbgEVAMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 20:12:40 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD1DB20823;
        Fri, 22 May 2020 00:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590106360;
        bh=A45qJT0RUkEKB77p9uZs8SZzgdqs69BaQfR8rQ0U8Qc=;
        h=Date:From:To:To:To:Cc:CC:Cc:Subject:In-Reply-To:References:From;
        b=g3lt0ACAyhGtu0V1HJ1qPg0miet8OEbIUfLsegYAFxj7iyxcaNiEEo1ntTIftuq7N
         zGWTL0qhIFXpHtjCIOqL8wtydHf+ZUm+M9KcBdXXOI9W6v5ftWrGVnHC1HueEYDLhR
         3OpEWjAjICvlXlmmOJGvKjas6KxSHNP2j8Rmp59Y=
Date:   Fri, 22 May 2020 00:12:39 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
CC:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/2] jbd2: Avoid leaking transaction credits when unreserving handle
In-Reply-To: <20200518092120.10322-3-jack@suse.cz>
References: <20200518092120.10322-3-jack@suse.cz>
Message-Id: <20200522001239.DD1DB20823@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 8f7d89f36829 ("jbd2: transaction reservation support").

The bot has tested the following trees: v5.6.13, v5.4.41, v4.19.123, v4.14.180, v4.9.223, v4.4.223.

v5.6.13: Build OK!
v5.4.41: Failed to apply! Possible dependencies:
    5559b2d81b51 ("jbd2: Drop pointless wakeup from jbd2_journal_stop()")
    933f1c1e0b75 ("jbd2: Rename h_buffer_credits to h_total_credits")
    a413036791d0 ("ext4: Provide function to handle transaction restarts")
    a9a8344ee171 ("ext4, jbd2: Provide accessor function for handle credits")
    dfaf5ffda227 ("jbd2: Reorganize jbd2_journal_stop()")
    ec8b6f600e49 ("jbd2: Factor out common parts of stopping and restarting a handle")
    fdc3ef882a5d ("jbd2: Reserve space for revoke descriptor blocks")

v4.19.123: Failed to apply! Possible dependencies:
    0b02f4c0d6d9 ("ext4: fix reserved cluster accounting at delayed write time")
    1dc0aa46e74a ("ext4: add new pending reservation mechanism")
    32ea275008d8 ("jbd2: update locking documentation for transaction_t")
    4c273352bb45 ("jbd2: add missing tracepoint for reserved handle")
    5559b2d81b51 ("jbd2: Drop pointless wakeup from jbd2_journal_stop()")
    933f1c1e0b75 ("jbd2: Rename h_buffer_credits to h_total_credits")
    a413036791d0 ("ext4: Provide function to handle transaction restarts")
    a9a8344ee171 ("ext4, jbd2: Provide accessor function for handle credits")
    ad431025aecd ("ext4: generalize extents status tree search functions")
    dfaf5ffda227 ("jbd2: Reorganize jbd2_journal_stop()")
    ec8b6f600e49 ("jbd2: Factor out common parts of stopping and restarting a handle")
    fdc3ef882a5d ("jbd2: Reserve space for revoke descriptor blocks")

v4.14.180: Failed to apply! Possible dependencies:
    0b02f4c0d6d9 ("ext4: fix reserved cluster accounting at delayed write time")
    19fe5f643f89 ("iomap: Switch from blkno to disk offset")
    1dc0aa46e74a ("ext4: add new pending reservation mechanism")
    32ea275008d8 ("jbd2: update locking documentation for transaction_t")
    4c273352bb45 ("jbd2: add missing tracepoint for reserved handle")
    545052e9e35a ("ext4: Switch to iomap for SEEK_HOLE / SEEK_DATA")
    5559b2d81b51 ("jbd2: Drop pointless wakeup from jbd2_journal_stop()")
    933f1c1e0b75 ("jbd2: Rename h_buffer_credits to h_total_credits")
    a413036791d0 ("ext4: Provide function to handle transaction restarts")
    a9a8344ee171 ("ext4, jbd2: Provide accessor function for handle credits")
    ad431025aecd ("ext4: generalize extents status tree search functions")
    dfaf5ffda227 ("jbd2: Reorganize jbd2_journal_stop()")
    ec8b6f600e49 ("jbd2: Factor out common parts of stopping and restarting a handle")
    fdc3ef882a5d ("jbd2: Reserve space for revoke descriptor blocks")

v4.9.223: Failed to apply! Possible dependencies:
    39bc88e5e38e ("arm64: Disable TTBR0_EL1 during normal kernel execution")
    4c273352bb45 ("jbd2: add missing tracepoint for reserved handle")
    538bcaa6261b ("jbd2: fix race when writing superblock")
    5559b2d81b51 ("jbd2: Drop pointless wakeup from jbd2_journal_stop()")
    783d94854499 ("ext4: add EXT4_IOC_GOINGDOWN ioctl")
    7c0f6ba682b9 ("Replace <asm/uaccess.h> with <linux/uaccess.h> globally")
    81378da64de6 ("jbd2: mark the transaction context with the scope GFP_NOFS context")
    933f1c1e0b75 ("jbd2: Rename h_buffer_credits to h_total_credits")
    9cf09d68b89a ("arm64: xen: Enable user access before a privcmd hvc call")
    b4709067ac09 ("jbd2: preserve original nofs flag during journal restart")
    bd38967d406f ("arm64: Factor out PAN enabling/disabling into separate uaccess_* macros")
    dfaf5ffda227 ("jbd2: Reorganize jbd2_journal_stop()")
    ec8b6f600e49 ("jbd2: Factor out common parts of stopping and restarting a handle")
    fb7c02445c49 ("ext4: pass -ESHUTDOWN code to jbd2 layer")
    fdc3ef882a5d ("jbd2: Reserve space for revoke descriptor blocks")

v4.4.223: Failed to apply! Possible dependencies:
    2a222ca992c3 ("fs: have submit_bh users pass in op and flags separately")
    38f252553300 ("block: add __blkdev_issue_discard")
    4c273352bb45 ("jbd2: add missing tracepoint for reserved handle")
    4e49ea4a3d27 ("block/fs/drivers: remove rw argument from submit_bio")
    538bcaa6261b ("jbd2: fix race when writing superblock")
    5559b2d81b51 ("jbd2: Drop pointless wakeup from jbd2_journal_stop()")
    7a4b188f0c0b ("jbd2: move lockdep instrumentation for jbd2 handles")
    81378da64de6 ("jbd2: mark the transaction context with the scope GFP_NOFS context")
    9082e87bfbf8 ("block: remove struct bio_batch")
    933f1c1e0b75 ("jbd2: Rename h_buffer_credits to h_total_credits")
    ab714aff4f74 ("jbd2: move lockdep tracking to journal_s")
    b4709067ac09 ("jbd2: preserve original nofs flag during journal restart")
    bbd848e0fade ("block: reinstate early return of -EOPNOTSUPP from blkdev_issue_discard")
    d57d611505d9 ("kernel/fs: fix I/O wait not accounted for RW O_DSYNC")
    dfaf5ffda227 ("jbd2: Reorganize jbd2_journal_stop()")
    ec8b6f600e49 ("jbd2: Factor out common parts of stopping and restarting a handle")
    fdc3ef882a5d ("jbd2: Reserve space for revoke descriptor blocks")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
