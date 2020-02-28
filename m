Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D44D0174071
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 20:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgB1Tox (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 14:44:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:58428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726046AbgB1Tox (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 14:44:53 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17C3F2469D;
        Fri, 28 Feb 2020 19:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582919092;
        bh=GtzUOUZfYfso0z7LZO8ZMsfUiy9ROA5jckCwXM3IFRs=;
        h=Date:From:To:To:To:CC:Cc:Subject:In-Reply-To:References:From;
        b=Ac2eCzsjkx3Wj7GkxZ5+28BD5xZsH1d1rE9ULBItjaig54oNFYJdhCBwZ8K42EyP1
         EFYPg22RI0tyqFKA2cXYPnCBkUxBqCqevqPUXscuOwykiHepKNlV2TYrZ3MAp/hY9t
         iVBoDPsfkijYMY/PoNPSa1hJeSotWDdEt4/uliTk=
Date:   Fri, 28 Feb 2020 19:44:50 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Gao Xiang <gaoxiang25@huawei.com>
To:     Chao Yu <yuchao0@huawei.com>, <linux-erofs@lists.ozlabs.org>
CC:     LKML <linux-kernel@vger.kernel.org>, Miao Xie <miaoxie@huawei.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] erofs: correct the remaining shrink objects
In-Reply-To: <20200226081008.86348-1-gaoxiang25@huawei.com>
References: <20200226081008.86348-1-gaoxiang25@huawei.com>
Message-Id: <20200228194452.17C3F2469D@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: e7e9a307be9d ("staging: erofs: introduce workstation for decompression").

The bot has tested the following trees: v5.5.6, v5.4.22, v4.19.106.

v5.5.6: Build OK!
v5.4.22: Failed to apply! Possible dependencies:
    bda17a4577da ("erofs: remove dead code since managed cache is now built-in")

v4.19.106: Failed to apply! Possible dependencies:
    05f9d4a0c8c4 ("staging: erofs: use the new LZ4_decompress_safe_partial()")
    0a64d62d5399 ("staging: erofs: fixed -Wmissing-prototype warnings by making functions static.")
    14f362b4f405 ("staging: erofs: clean up internal.h")
    152a333a5895 ("staging: erofs: add compacted compression indexes support")
    22fe04a77d10 ("staging: erofs: clean up shrinker stuffs")
    3b423417d0d1 ("staging: erofs: clean up erofs_map_blocks_iter")
    5fb76bb04216 ("staging: erofs: cleanup `z_erofs_vle_normalaccess_readpages'")
    6e78901a9f23 ("staging: erofs: separate erofs_get_meta_page")
    7dd68b147d60 ("staging: erofs: use explicit unsigned int type")
    7fc45dbc938a ("staging: erofs: introduce generic decompression backend")
    89fcd8360e7b ("staging: erofs: change 'unsigned' to 'unsigned int'")
    8be31270362b ("staging: erofs: introduce erofs_grab_bio")
    ab47dd2b0819 ("staging: erofs: cleanup z_erofs_vle_work_{lookup, register}")
    bda17a4577da ("erofs: remove dead code since managed cache is now built-in")
    d1ab82443bed ("staging: erofs: Modify conditional checks")
    e7dfb1cff65b ("staging: erofs: fixed -Wmissing-prototype warnings by moving prototypes to header file.")
    f0950b02a74c ("staging: erofs: Modify coding style alignments")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
