Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BE4D123536
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 19:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727594AbfLQSqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 13:46:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:38606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726742AbfLQSqL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 13:46:11 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C688F20733;
        Tue, 17 Dec 2019 18:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576608371;
        bh=8cTPAJdBPTsQ48Rtaj+AtGz744Volp3zu/XplimkmTE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KV14Yv630RBT6HY1Vbkz5YQvSNEqJjx93wxbveUJ7sFbdN18dlV35lX+b5kH97ipO
         dG9UfTRb44j+7Rn9ArllKEA02K6y/8z19yUtuUC2v0qOl2v+ZfUOO83erVE5jlZxAF
         1L+Z80x5fPIq1e7MX10MhAFpr00wPi6YErtj/Fk0=
Date:   Tue, 17 Dec 2019 10:46:09 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-mtd@lists.infradead.org, Richard Weinberger <richard@nod.at>,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>
Subject: Re: [PATCH 1/2] ubifs: fix FS_IOC_SETFLAGS unexpectedly clearing
 encrypt flag
Message-ID: <20191217184608.GB89165@gmail.com>
References: <20191209222325.95656-2-ebiggers@kernel.org>
 <20191216150636.0511E2072D@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191216150636.0511E2072D@mail.kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 03:06:35PM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: d475a507457b ("ubifs: Add skeleton for fscrypto").
> 
> The bot has tested the following trees: v5.4.2, v5.3.15, v4.19.88, v4.14.158.
> 
> v5.4.2: Build OK!
> v5.3.15: Build OK!
> v4.19.88: Build failed! Errors:
>     fs/ubifs/ioctl.c:130:28: error: ‘UBIFS_SUPPORTED_IOCTL_FLAGS’ undeclared (first use in this function)
> 
> v4.14.158: Build failed! Errors:
>     fs/ubifs/ioctl.c:127:28: error: ‘UBIFS_SUPPORTED_IOCTL_FLAGS’ undeclared (first use in this function)
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?
> 

4.19 and 4.14 will build if you apply commit 2fe8b2d5578d
("ubifs: Reject unsupported ioctl flags explicitly") first.
That was a bug fix too, so I recommend applying it.

- Eric
