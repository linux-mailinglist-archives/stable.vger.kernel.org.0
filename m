Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D28BAE0EB
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 00:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406424AbfIIWSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 18:18:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392140AbfIIWRM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Sep 2019 18:17:12 -0400
Received: from localhost (unknown [40.117.208.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 742BC21D7D;
        Mon,  9 Sep 2019 22:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568067431;
        bh=F4QqiO0/iNaU8RBNkAA8s6VtopiUWt51W8bxnSbpvrs=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=QRHfNrlosF3svqhtdKNgymBZEPRhLEAembpuJUnKsTV6JTQkZMZJEd4uJvZ37sjYs
         vh+KN+/NsY5pp/X+jzU2bw9dVIp+PImrnpQGoRwyTYVyk1XPIn7FijHWizEhela0rY
         UFx36YSi4x//W4z+FlXfSwB9QS8/TbmAnhrDPkvI=
Date:   Mon, 09 Sep 2019 22:17:10 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Trond Myklebust <trondmy@gmail.com>
To:     Anna Schumaker <Anna.Schumakerr@netapp.com>
Cc:     linux-nfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] SUNRPC: Dequeue the request from the receive queue while we're re-encoding
In-Reply-To: <20190909134647.77523-1-trond.myklebust@hammerspace.com>
References: <20190909134647.77523-1-trond.myklebust@hammerspace.com>
Message-Id: <20190909221711.742BC21D7D@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 753690898204 SUNRPC: Ensure the bvecs are reset when we re-encode the RPC request.

The bot has tested the following trees: v5.2.13.

v5.2.13: Failed to apply! Possible dependencies:
    b5e924191f87 ("SUNRPC: Remove the bh-safe lock requirement on xprt->transport_lock")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
