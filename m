Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862EC21139C
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 21:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgGATdT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 15:33:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726752AbgGATdR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 15:33:17 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0EA420870;
        Wed,  1 Jul 2020 19:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593631996;
        bh=SGM9git5cbSZWULtLea44yJGOmD2g6GhrUsQUL8FwqM=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=j7LtOaGgqPnI4/VmrdEvZ3Hu/SaXQCVPKufwCPYT6WDOvbc+i81ZQfSyEsSWIKxmp
         ecKStNJ9dSA83jj9UrF7TeL6boJ040MEAvUzYsd4e3v11pXRepy8kEFqh+OyiszrkQ
         DQD/Aee7+fpkSWsg6s3PYb2lfo7i7QQxPhy/quZA=
Date:   Wed, 01 Jul 2020 19:33:16 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: allow use of global block reserve for balance item deletion
In-Reply-To: <20200625103528.15154-1-dsterba@suse.com>
References: <20200625103528.15154-1-dsterba@suse.com>
Message-Id: <20200701193316.A0EA420870@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 4.4+

The bot has tested the following trees: v5.7.6, v5.4.49, v4.19.130, v4.14.186, v4.9.228, v4.4.228.

v5.7.6: Build OK!
v5.4.49: Build OK!
v4.19.130: Build failed! Errors:
    fs/btrfs/volumes.c:3082:10: error: too few arguments to function ‘btrfs_start_transaction_fallback_global_rsv’

v4.14.186: Build failed! Errors:
    fs/btrfs/volumes.c:3109:10: error: too few arguments to function ‘btrfs_start_transaction_fallback_global_rsv’

v4.9.228: Build failed! Errors:
    fs/btrfs/volumes.c:3097:10: error: too few arguments to function ‘btrfs_start_transaction_fallback_global_rsv’

v4.4.228: Build failed! Errors:
    fs/btrfs/volumes.c:3012:10: error: too few arguments to function ‘btrfs_start_transaction_fallback_global_rsv’


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
