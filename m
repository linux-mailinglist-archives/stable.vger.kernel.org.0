Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 804B98BFFD
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 19:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfHMRz1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 13:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbfHMRz0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 13:55:26 -0400
Received: from localhost (unknown [40.117.208.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B10720679;
        Tue, 13 Aug 2019 17:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565718925;
        bh=ju8G91b9u4kJOs2zIHfSgfzPhoHCu4kCEurTaJMfwqg=;
        h=Date:From:To:To:To:Cc:Subject:In-Reply-To:References:From;
        b=Zt2vRJIjkpNk3U957XGl7YjwLLej5qOS+fNPbfGZffCxrezQ1Mng+TPvcQFeSR6/Z
         J48YwDmXkQpZR/5iaYfeAV9NOPPG27bvvR9KvD9bvdiO7IotD/xaG7WuNQxaC+TI/d
         5q6+hpnK1y7XAztgOzGe2+vEczM+algaccdI+7fs=
Date:   Tue, 13 Aug 2019 17:55:24 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Trond Myklebust <trondmy@gmail.com>
To:     linux-nfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4/5] NFSv4/pnfs: Fix a page lock leak in nfs_pageio_resend()
In-Reply-To: <20190813142806.123268-4-trond.myklebust@hammerspace.com>
References: <20190813142806.123268-4-trond.myklebust@hammerspace.com>
Message-Id: <20190813175525.9B10720679@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: d600ad1f2bdb NFS41: pop some layoutget errors to application.

The bot has tested the following trees: v5.2.8, v4.19.66, v4.14.138, v4.9.189, v4.4.189.

v5.2.8: Build OK!
v4.19.66: Failed to apply! Possible dependencies:
    078b5fd92c49 ("NFS: Clean up list moves of struct nfs_page")

v4.14.138: Failed to apply! Possible dependencies:
    078b5fd92c49 ("NFS: Clean up list moves of struct nfs_page")

v4.9.189: Failed to apply! Possible dependencies:
    078b5fd92c49 ("NFS: Clean up list moves of struct nfs_page")

v4.4.189: Failed to apply! Possible dependencies:
    078b5fd92c49 ("NFS: Clean up list moves of struct nfs_page")
    6272dcc6beeb ("NFS: Simplify nfs_request_add_commit_list() arguments")
    b20135d0b243 ("NFSv4.1/pNFS: Don't queue up a new commit if the layout segment is invalid")
    c18b96a1b862 ("nfs: clean up rest of reqs when failing to add one")
    f57dcf4c7211 ("NFS: Fix I/O request leakages")
    fe238e601d25 ("NFS: Save struct inode COPYING CREDITS Documentation Kbuild Kconfig MAINTAINERS Makefile README REPORTING-BUGS arch block certs crypto drivers firmware fs include init ipc kernel lib mm net samples scripts security sound tools usr virt inside nfs_commit_info to clarify usage of i_lock")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
