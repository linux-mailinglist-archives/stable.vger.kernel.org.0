Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 130DC191E54
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 02:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgCYBB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 21:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727113AbgCYBB6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 21:01:58 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62A0220719;
        Wed, 25 Mar 2020 01:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585098117;
        bh=g+LufknV2nEF+nKxCOjoPKR7ov4EySwVfTi8ivJ3PTw=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=eV9fRJWC8D6j36xiVE/tHhONYRUKBJW1xCGOw3J4nQ0cFb1r9/D41xDmaJgiKFmkW
         5c3VIIfXxlcuB3L1IDMwdcSkm5LPlms4R9l5KjPGPV4vwwK3EVvACR+fLEqD63Hhxo
         nRQfdQILW93jhB2sRQfbcLoIPG9xQbX0x1WbX0/k=
Date:   Wed, 25 Mar 2020 01:01:56 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Bob Liu <bob.liu@oracle.com>
To:     dm-devel@redhat.com
Cc:     Damien.LeMoal@wdc.com, linux-block@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH resend] dm zoned: remove duplicated nr_rnd_zones increasement
In-Reply-To: <20200324132245.27843-1-bob.liu@oracle.com>
References: <20200324132245.27843-1-bob.liu@oracle.com>
Message-Id: <20200325010157.62A0220719@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target").

The bot has tested the following trees: v5.5.11, v5.4.27, v4.19.112, v4.14.174.

v5.5.11: Build OK!
v5.4.27: Failed to apply! Possible dependencies:
    5eac3eb30c9a ("block: Remove partition support for zoned block devices")
    6c1b1da58f8c ("block: add zone open, close and finish operations")
    7fc8fb51a143 ("null_blk: clean up report zones")
    ad512f2023b3 ("scsi: sd_zbc: add zone open, close, and finish support")
    c7a1d926dc40 ("block: Simplify REQ_OP_ZONE_RESET_ALL handling")
    c98c3d09fca4 ("block: cleanup the !zoned case in blk_revalidate_disk_zones")
    ceeb373aa6b9 ("block: Simplify report zones execution")
    d41003513e61 ("block: rework zone reporting")
    d9dd73087a8b ("block: Enhance blk_revalidate_disk_zones()")
    dd85b4922de1 ("null_blk: return fixed zoned reads > write pointer")
    e3f89564c557 ("null_blk: clean up the block device operations")

v4.19.112: Failed to apply! Possible dependencies:
    515ce6061312 ("scsi: sd_zbc: Fix sd_zbc_report_zones() buffer allocation")
    5f832a395859 ("scsi: sd_zbc: Fix sd_zbc_check_zones() error checks")
    a2d6b3a2d390 ("block: Improve zone reset execution")
    a91e138022bc ("block: Introduce blkdev_nr_zones() helper")
    bd976e527259 ("block: Kill gfp_t argument of blkdev_report_zones()")
    bf5054569653 ("block: Introduce blk_revalidate_disk_zones()")
    d2e428e49eec ("scsi: sd_zbc: Reduce boot device scan and revalidate time")
    d41003513e61 ("block: rework zone reporting")
    e76239a3748c ("block: add a report_zones method")

v4.14.174: Failed to apply! Possible dependencies:
    08e18eab0c57 ("block: add bi_blkg to the bio for cgroups")
    30e5e929c7bf ("nvme: don't pass struct nvme_ns to nvme_config_discard")
    5238dcf4136f ("block: replace bio->bi_issue_stat with bio-specific type")
    53cfdc10a95d ("blk-throttle: fix null pointer dereference while throttling writeback IOs")
    5d47c89f29ea ("dm: clear all discard attributes in queue_limits when discards are disabled")
    8b904b5b6b58 ("block: Use blk_queue_flag_*() in drivers instead of queue_flag_*()")
    a2d6b3a2d390 ("block: Improve zone reset execution")
    b889bf66d001 ("blk-throttle: track read and write request individually")
    bd976e527259 ("block: Kill gfp_t argument of blkdev_report_zones()")
    bf5054569653 ("block: Introduce blk_revalidate_disk_zones()")
    c8b5fd031a30 ("mmc: block: Factor out mmc_setup_queue()")
    d41003513e61 ("block: rework zone reporting")
    d70675121546 ("block: introduce blk-iolatency io controller")
    e447a0151f7c ("zram: set BDI_CAP_STABLE_WRITES once")
    ed754e5deeb1 ("nvme: track shared namespaces")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
