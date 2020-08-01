Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10799235498
	for <lists+stable@lfdr.de>; Sun,  2 Aug 2020 01:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgHAXSR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 19:18:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:50384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726807AbgHAXSP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Aug 2020 19:18:15 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F1A4207FB;
        Sat,  1 Aug 2020 23:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596323894;
        bh=XNByyhL9Y2whfuo7uld8tDXRV7zi64mizD0FKxzuXz4=;
        h=Date:From:To:To:To:Cc:CC:Cc:Subject:In-Reply-To:References:From;
        b=PYg0QgUSrIrX/kcYu4GpXsAWmFquKJIzLuzz7ko6OZYxhR/wiUowCs25og8zXZ224
         itfZ0nezwnsuZj0yPNpXuCqUB9hU8QVbZz+Oi6ebd4AE+u9tn1l8+uW6LcC50jQc+s
         xOH4wmumLxW4+3FcdZN6cBf5zzcTbdar6VhVi9ho=
Date:   Sat, 01 Aug 2020 23:18:14 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
CC:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix checking of entry validity
In-Reply-To: <20200731162135.8080-1-jack@suse.cz>
References: <20200731162135.8080-1-jack@suse.cz>
Message-Id: <20200801231814.8F1A4207FB@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 109ba779d6cc ("ext4: check for directory entries too close to block end").

The bot has tested the following trees: v5.7.11, v5.4.54, v4.19.135, v4.14.190, v4.9.231, v4.4.231.

v5.7.11: Build OK!
v5.4.54: Build OK!
v4.19.135: Build OK!
v4.14.190: Build OK!
v4.9.231: Failed to apply! Possible dependencies:
    364443cbcfe7 ("ext4: convert DAX reads to iomap infrastructure")
    39bc88e5e38e ("arm64: Disable TTBR0_EL1 during normal kernel execution")
    7046ae35329f ("ext4: Add iomap support for inline data")
    7c0f6ba682b9 ("Replace <asm/uaccess.h> with <linux/uaccess.h> globally")
    9cf09d68b89a ("arm64: xen: Enable user access before a privcmd hvc call")
    b886ee3e778e ("ext4: Support case-insensitive file name lookups")
    bd38967d406f ("arm64: Factor out PAN enabling/disabling into separate uaccess_* macros")
    ee73f9a52a34 ("ext4: convert to new i_version API")
    eeca7ea1baa9 ("ext4: use current_time() for inode timestamps")

v4.4.231: Failed to apply! Possible dependencies:
    12735f881952 ("ext4: pre-zero allocated blocks for DAX IO")
    2dcba4781fa3 ("ext4: get rid of EXT4_GET_BLOCKS_NO_LOCK flag")
    364443cbcfe7 ("ext4: convert DAX reads to iomap infrastructure")
    7046ae35329f ("ext4: Add iomap support for inline data")
    705965bd6dfa ("ext4: rename and split get blocks functions")
    b886ee3e778e ("ext4: Support case-insensitive file name lookups")
    ba5843f51d46 ("ext4: use pre-zeroed blocks for DAX page faults")
    c86d8db33a92 ("ext4: implement allocation of pre-zeroed blocks")
    ee73f9a52a34 ("ext4: convert to new i_version API")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
