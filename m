Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 315A5B0981
	for <lists+stable@lfdr.de>; Thu, 12 Sep 2019 09:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729307AbfILHaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Sep 2019 03:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfILHaq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Sep 2019 03:30:46 -0400
Received: from localhost (unknown [40.117.208.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A2B520CC7;
        Thu, 12 Sep 2019 07:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568273445;
        bh=/4FFg4V9Dw7gfO91ycK9E3A5BotunSngO5z+vqD/Ets=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=qWJ+acnEHomkZti/bnkK3mP+tBUkufK96aIeccKIIc8iPtzzYydCKEc0VezWnQ+Sg
         63YpL0XV5jHpoov5/8vBxnx33tdYwpGkELeOd2/1sfDEuscMkfgT5LS6k0Wr2o2jAF
         AUPNkbIWZXx1cDWZ8JvOF2R4JTMVErdIposXvSSg=
Date:   Thu, 12 Sep 2019 07:30:44 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Ming Lei <ming.lei@redhat.com>
To:     Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc:     Ming Lei <ming.lei@redhat.com>, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH V2] dm-raid: fix updating of max_discard_sectors limit
In-Reply-To: <20190911113133.837-1-ming.lei@redhat.com>
References: <20190911113133.837-1-ming.lei@redhat.com>
Message-Id: <20190912073045.1A2B520CC7@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.2.14, v4.19.72, v4.14.143, v4.9.192, v4.4.192.

v5.2.14: Build OK!
v4.19.72: Failed to apply! Possible dependencies:
    53b471687012 ("dm: remove indirect calls from __send_changing_extent_only()")
    61697a6abd24 ("dm: eliminate 'split_discard_bios' flag from DM target interface")

v4.14.143: Failed to apply! Possible dependencies:
    00716545c894 ("dm: add support for secure erase forwarding")
    0519c71e8d46 ("dm: backfill abnormal IO support to non-splitting IO submission")
    0776aa0e30aa ("dm: ensure bio-based DM's bioset and io_pool support targets' maximum IOs")
    18a25da84354 ("dm: ensure bio submission follows a depth-first tree walk")
    318716ddea08 ("dm: safely allocate multiple bioset bios")
    3d7f45625a84 ("dm: fix __send_changing_extent_only() to send first bio and chain remainder")
    53b471687012 ("dm: remove indirect calls from __send_changing_extent_only()")
    552aa679f265 ("dm raid: use rs_is_raid*()")
    61697a6abd24 ("dm: eliminate 'split_discard_bios' flag from DM target interface")
    64f52b0e3148 ("dm: improve performance by moving dm_io structure to per-bio-data")
    745dc570b2c3 ("dm: rename 'bio' member of dm_io structure to 'orig_bio'")
    978e51ba38e0 ("dm: optimize bio-based NVMe IO submission")
    f31c21e4365c ("dm: remove unused 'num_write_bios' target interface")

v4.9.192: Failed to apply! Possible dependencies:
    124d6db07c3b ("nbd: use our own workqueue for recv threads")
    19372e276917 ("loop: implement REQ_OP_WRITE_ZEROES")
    3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
    48920ff2a5a9 ("block: remove the discard_zeroes_data flag")
    552aa679f265 ("dm raid: use rs_is_raid*()")
    61697a6abd24 ("dm: eliminate 'split_discard_bios' flag from DM target interface")
    7ab84db64f11 ("dm integrity: improve the Kconfig help text for DM_INTEGRITY")
    9561a7ade0c2 ("nbd: add multi-connection support")
    b0d9111a2d53 ("nbd: use an idr to keep track of nbd devices")

v4.4.192: Failed to apply! Possible dependencies:
    33e53f06850f ("dm raid: introduce extended superblock and new raid types to support takeover/reshaping")
    4c9971ca6a17 ("dm raid: make sure no feature flags are set in metadata")
    552aa679f265 ("dm raid: use rs_is_raid*()")
    61697a6abd24 ("dm: eliminate 'split_discard_bios' flag from DM target interface")
    676fa5ad6e96 ("dm raid: use rt_is_raid*() in all appropriate checks")
    702108d194e3 ("dm raid: cleanup / provide infrastructure")
    73c6f239a862 ("dm raid: rename variable 'ret' to 'r' to conform to other dm code")
    92c83d79b07e ("dm raid: use dm_arg_set API in constructor")
    f090279eaff8 ("dm raid: check constructor arguments for invalid raid level/argument combinations")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
