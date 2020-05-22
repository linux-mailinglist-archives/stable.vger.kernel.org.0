Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1456C1DDB9D
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 02:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730159AbgEVAGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 20:06:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729771AbgEVAGT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 May 2020 20:06:19 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8986C206BE;
        Fri, 22 May 2020 00:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590105978;
        bh=zyo3iu5Y1RoBgPitVXZLD5EtBSmKf3x+2CJG/qE55Ao=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x/kmkM33UP/ljSvdictxwH/tstgkDaPt1YWB5jj+8Elm2fc2hD6gdPSCrhp7mSa3m
         59He2VtCfi24lJW12rbWX7e9FZoY7s2VaqmtUCbVAun46Icypm+6YzRYIRbJ8XfGe4
         JSd3OgrOmTdOJEpvB29TBfpz+WtNhxkS0rsPw4gA=
Date:   Thu, 21 May 2020 20:06:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Catalin Marinas <catalin.marinas@arm.com>
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4.14] arm64: fix the flush_icache_range arguments in
 machine_kexec
Message-ID: <20200522000617.GL33628@sasha-vm>
References: <20200521144135.11616-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200521144135.11616-1-catalin.marinas@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 21, 2020 at 03:41:35PM +0100, Catalin Marinas wrote:
>From: Christoph Hellwig <hch@lst.de>
>
>Commit d51c214541c5154dda3037289ee895ea3ded5ebd upstream.
>
>The second argument is the end "pointer", not the length.
>
>Fixes: d28f6df1305a ("arm64/kexec: Add core kexec support")
>Cc: <stable@vger.kernel.org> # 4.8.x-
>Signed-off-by: Christoph Hellwig <hch@lst.de>
>Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Queued your 4.14 and 4.9 backport, thank you!

-- 
Thanks,
Sasha
