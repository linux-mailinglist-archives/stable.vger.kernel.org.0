Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1B7515FEE5
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 16:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgBOPBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Feb 2020 10:01:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:34666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbgBOPBT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Feb 2020 10:01:19 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B22262084E;
        Sat, 15 Feb 2020 15:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581778878;
        bh=qBUYI2zSZtk8ZUAEu63KQ9P3E3oN2/fqDe8SmjX2OKY=;
        h=Date:From:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:
         References:From;
        b=xExgRMMD56IRs3F3c6WpdXf04u55fjjTHUkaiSEGP3ymRIygpEJWX15VIATQDFF0F
         orsSrIBoq2ZC+6L0Ta9OwCX6fzFmJaghiS5J0UMGcJKy9fc1ueijhq7NPhZM0rz5LY
         Qg3z5pLAwcHxe/FXr7sW7t6gjwZYWlXcLv/2sjEg=
Date:   Sat, 15 Feb 2020 15:01:18 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Sasha Levin <sashal@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH for 4.19-stable] padata: fix null pointer deref of pd->pinst
In-Reply-To: <20200214182821.337706-1-daniel.m.jordan@oracle.com>
References: <20200214182821.337706-1-daniel.m.jordan@oracle.com>
Message-Id: <20200215150118.B22262084E@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: dc34710a7aba ("padata: Remove broken queue flushing").

The bot has tested the following trees: v5.5.3, v5.4.19, v4.19.103.

v5.5.3: Build failed! Errors:
    kernel/padata.c:460:4: error: ‘struct parallel_data’ has no member named ‘pinst’

v5.4.19: Build failed! Errors:
    kernel/padata.c:460:4: error: ‘struct parallel_data’ has no member named ‘pinst’

v4.19.103: Build OK!

NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks,
Sasha
