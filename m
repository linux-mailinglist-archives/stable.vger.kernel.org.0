Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0B96D7E4
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 02:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbfGSApa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 20:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbfGSApa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 20:45:30 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E4422173B;
        Fri, 19 Jul 2019 00:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563497129;
        bh=pxYV1gErDXR/y6Mf/1SrvGzxwRVh54wTFtUKu1RYsBo=;
        h=Date:From:To:To:To:Cc:Subject:In-Reply-To:References:From;
        b=JNvXXSWL48IcOyzrk97y61c07PEObPNrUk7ezbmTq5512T87k88lEPNP3mRp/cykf
         LKtBuHVhIXP6OaCY4fg0B5T//lcDNuCWC5DZskjcyGsEIsgUzGSvVy+Wv2TQCw0bum
         Uyb/CeZA9D2O9NNIGoy5R7/Li/e9DcTGqJHFFWYo=
Date:   Fri, 19 Jul 2019 00:45:28 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Trond Myklebust <trondmy@gmail.com>
To:     linux-nfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] pnfs: Fix a problem where we gratuitously start doing I/O through the MDS
In-Reply-To: <20190718194039.119185-1-trond.myklebust@hammerspace.com>
References: <20190718194039.119185-1-trond.myklebust@hammerspace.com>
Message-Id: <20190719004529.2E4422173B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: d03360aaf5cc pNFS: Ensure we return the error if someone kills a waiting layoutget.

The bot has tested the following trees: v5.2.1, v5.1.18, v4.19.59.

v5.2.1: Build OK!
v5.1.18: Build OK!
v4.19.59: Failed to apply! Possible dependencies:
    400417b05f3e ("pNFS: Fix a typo in pnfs_update_layout")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
