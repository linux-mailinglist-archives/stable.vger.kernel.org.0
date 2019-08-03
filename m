Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 227728075F
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 19:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbfHCRJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 13:09:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:60562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728106AbfHCRJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 3 Aug 2019 13:09:58 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69850214AE;
        Sat,  3 Aug 2019 17:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564852197;
        bh=Ip6tonVSF8MFhK8R/cXChTm0IW11VN7ZR8bx6mN4f0k=;
        h=Date:From:To:To:To:Cc:Subject:In-Reply-To:References:From;
        b=lFbDVXtTkfkOZMGLayDalY2iMePEBO4/Xzv4FDBvAaT1GhEDw6WHYvAqSCWhRJ5n/
         z8jaRT3dzR3O19eXMUfUV7KKbn+zWfkDD5DRysBfK46U6OZ6MIN/XkacKsOgVikYPs
         WQI+D/qIAKeljt+eILh+c5SKm97sChlM092kJbko=
Date:   Sat, 03 Aug 2019 17:09:56 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Trond Myklebust <trondmy@gmail.com>
To:     linux-nfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 8/8] NFSv4: Check the return value of update_open_stateid()
In-Reply-To: <20190803145826.15504-8-trond.myklebust@hammerspace.com>
References: <20190803145826.15504-8-trond.myklebust@hammerspace.com>
Message-Id: <20190803170957.69850214AE@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: e23008ec81ef NFSv4 reduce attribute requests for open reclaim.

The bot has tested the following trees: v5.2.5, v4.19.63, v4.14.135, v4.9.186, v4.4.186.

v5.2.5: Build OK!
v4.19.63: Failed to apply! Possible dependencies:
    ace9fad43aa6 ("NFSv4: Convert struct nfs4_state to use refcount_t")

v4.14.135: Failed to apply! Possible dependencies:
    ace9fad43aa6 ("NFSv4: Convert struct nfs4_state to use refcount_t")
    c9399f21c215 ("NFSv4: Fix OPEN / CLOSE race")

v4.9.186: Failed to apply! Possible dependencies:
    4e2fcac77390 ("NFSv4: Use correct inode in _nfs4_opendata_to_nfs4_state()")
    75e8c48b9ef3 ("NFSv4: Use the nfs4_state being recovered in _nfs4_opendata_to_nfs4_state()")
    ace9fad43aa6 ("NFSv4: Convert struct nfs4_state to use refcount_t")
    c9399f21c215 ("NFSv4: Fix OPEN / CLOSE race")

v4.4.186: Failed to apply! Possible dependencies:
    1393d9612ba0 ("NFSv4: Fix a race when updating an open_stateid")
    4586f6e28327 ("NFSv4.1: Add a helper function to deal with expired stateids")
    4e2fcac77390 ("NFSv4: Use correct inode in _nfs4_opendata_to_nfs4_state()")
    75e8c48b9ef3 ("NFSv4: Use the nfs4_state being recovered in _nfs4_opendata_to_nfs4_state()")
    8a64c4ef106d ("NFSv4.1: Even if the stateid is OK, we may need to recover the open modes")
    a8ce377a5db8 ("nfs: track whether server sets MAY_NOTIFY_LOCK flag")
    ace9fad43aa6 ("NFSv4: Convert struct nfs4_state to use refcount_t")
    b134fc4a5333 ("NFSv4: Don't test open_stateid unless it is set")
    c9399f21c215 ("NFSv4: Fix OPEN / CLOSE race")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
