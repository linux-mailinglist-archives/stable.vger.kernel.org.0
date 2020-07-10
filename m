Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3A421B794
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 16:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728328AbgGJOCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 10:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:49844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728330AbgGJOCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 10:02:47 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76C7A207BB;
        Fri, 10 Jul 2020 14:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594389766;
        bh=SGM9git5cbSZWULtLea44yJGOmD2g6GhrUsQUL8FwqM=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=Lf/9cJkUmVGClpvOqVUFAI1hWJ+WRht5cOLM5i1Yx9tXjhAbZFdVINP9UNgOajchH
         MxxlQ9fAFj3x3PvWE8voKdvVIGFanqG/yc7RuI4mthlgJKCXqu1AWudf8vG4KScRik
         5Zrt43g1kLcZtJTu9lyK7NHiVeGC1f7ewZFp1P0s=
Date:   Fri, 10 Jul 2020 14:02:45 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     David Sterba <dsterba@suse.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: allow use of global block reserve for balance item deletion
In-Reply-To: <20200625103528.15154-1-dsterba@suse.com>
References: <20200625103528.15154-1-dsterba@suse.com>
Message-Id: <20200710140246.76C7A207BB@mail.kernel.org>
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
