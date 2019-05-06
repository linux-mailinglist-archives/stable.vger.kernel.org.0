Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93F8115289
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 19:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfEFRS4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 13:18:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbfEFRSz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 13:18:55 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BCAA2053B;
        Mon,  6 May 2019 17:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557163135;
        bh=y0Mzto3RS5jlUtNRZSOhAY2x7OBcpm4XTT3JgOQe1/s=;
        h=Date:From:To:To:To:Cc:Subject:In-Reply-To:References:From;
        b=gwRtXO4b33S2wVqVchsdTdDD1E82Rn4uMSjjMMF4H1qNzJgFAN8M4OWPnmTgrKWqH
         xRgKzLQKmqAscvHZzLAlP/snVr/gjIeo/BXDQu07bSD3BZTzsmrxGV7i9rVlHm7m8W
         X6KIp5i7MKPwcebCsCkCIE40idjy8dIi8paxyanI=
Date:   Mon, 06 May 2019 17:18:54 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Filipe Manana <fdmanana@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/2] Btrfs: fix race between ranged fsync and writeback of adjacent ranges
In-Reply-To: <20190506154402.20097-1-fdmanana@kernel.org>
References: <20190506154402.20097-1-fdmanana@kernel.org>
Message-Id: <20190506171855.0BCAA2053B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 3.16+

The bot has tested the following trees: v5.0.13, v4.19.40, v4.14.116, v4.9.173, v4.4.179, v3.18.139.

v5.0.13: Build OK!
v4.19.40: Build OK!
v4.14.116: Build OK!
v4.9.173: Build OK!
v4.4.179: Build OK!
v3.18.139: Failed to apply! Possible dependencies:
    9dcbeed4d7e1 ("btrfs: fix signed overflows in btrfs_sync_file")


How should we proceed with this patch?

--
Thanks,
Sasha
