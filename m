Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7A0B097F
	for <lists+stable@lfdr.de>; Thu, 12 Sep 2019 09:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbfILHao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Sep 2019 03:30:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfILHao (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Sep 2019 03:30:44 -0400
Received: from localhost (unknown [40.117.208.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0D6D20830;
        Thu, 12 Sep 2019 07:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568273444;
        bh=eSno5oWZdjvWc0BcI1bJMaVCqkQPb3mwV3ZomdGFiGg=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=s7M1VbeQSGeDEmAmQqhZaEqsk3CXm+kQ4w8UifF/pSKC3e+O8VmpLp7+ZOoSyPMCo
         8Phbl/HJSp3uMsXr5jMkHZA7JQKNo1UhTjVVWjvHLOABik3xhhBQajWREwNg1jt53+
         V+YYellOBgRGMgeF6qcCksJC910XqpaYnGjS8POU=
Date:   Thu, 12 Sep 2019 07:30:43 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Trond Myklebust <trondmy@gmail.com>
To:     Anna Schumaker <Anna.Schumaker@netapp.com>
Cc:     linux-nfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] SUNRPC: Dequeue the request from the receive queue while we're re-encoding
In-Reply-To: <20190910170135.104865-1-trond.myklebust@hammerspace.com>
References: <20190910170135.104865-1-trond.myklebust@hammerspace.com>
Message-Id: <20190912073043.E0D6D20830@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 753690898204 SUNRPC: Ensure the bvecs are reset when we re-encode the RPC request.

The bot has tested the following trees: v5.2.14.

v5.2.14: Failed to apply! Possible dependencies:
    b5e924191f87 ("SUNRPC: Remove the bh-safe lock requirement on xprt->transport_lock")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
