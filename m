Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA4591D03F2
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 02:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731653AbgEMAtj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 May 2020 20:49:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729646AbgEMAtj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 May 2020 20:49:39 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C841820675;
        Wed, 13 May 2020 00:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589330979;
        bh=5xxEuhqwQ1ZoTeMzuFWoOFfxthfBb2bik4Tj6f2A94U=;
        h=Date:From:To:To:To:To:Cc:CC:Cc:Subject:In-Reply-To:References:
         From;
        b=mXGpcXKm/2jHUhIZXYtstKAwILNMj4dpqdMhidkiN8DEITRe7XvM7MZkG/3qbvAX8
         R/hqIm//X1+ANZdNK85A+aeKRn8VuwrxMuPNEFaMNZ0vbmt2w85PGv3kTMPj419ZwE
         niDINvDmgUGI6X+bzhPjkEXKe2CUETw3DplzMi4E=
Date:   Wed, 13 May 2020 00:49:38 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Marcos Paulo de Souza <marcos@mpdesouza.com>
To:     Marcos Paulo de Souza <mpdesouza@suse.com>
To:     dsterba@suse.com, linux-btrfs@vger.kernel.org, wqu@suse.com
Cc:     Marcos Paulo de Souza <mpdesouza@suse.com>, stable@vger.kernel.org
CC:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: send: Emit file capabilities after chown
In-Reply-To: <20200511021507.26942-1-marcos@mpdesouza.com>
References: <20200511021507.26942-1-marcos@mpdesouza.com>
Message-Id: <20200513004938.C841820675@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.11, v5.4.39, v4.19.121, v4.14.179, v4.9.222, v4.4.222.

v5.6.11: Build OK!
v5.4.39: Build OK!
v4.19.121: Build OK!
v4.14.179: Build OK!
v4.9.222: Build OK!
v4.4.222: Failed to apply! Possible dependencies:
    1ec9a1ae1e30 ("Btrfs: fix unreplayable log after snapshot delete + parent dir fsync")
    ebb8765b2ded ("btrfs: move btrfs_compression_type to compression.h")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
