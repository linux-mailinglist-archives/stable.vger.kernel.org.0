Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2314B3F42B2
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 02:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhHWAzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Aug 2021 20:55:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234471AbhHWAzP (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Aug 2021 20:55:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56BF56115A;
        Mon, 23 Aug 2021 00:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629680073;
        bh=vHoZptWC/8lGOS7N6F8lwLU19b+z8uaFjApu94S9n6I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oj+7eIBO4csEEEwzCEHM1lQnDrsFkjzEZ7M0rOwjZRN8vBv+AQ+VH9iYJBuwnBnyL
         N7bpHTSe0wJsyZvdZvdM5STxZQhFLelngow+S27C9GCfEDWKenXhkoS3NKyD+yjJos
         lhRnEvmhwDhSzdCZcTnh8QvxaVaqTvb92te51kuBW2oMD6e9y0m40V7RLWALrg7t4t
         eEzAnhwYnqQy1/AcVmhw8xfzhg5HroYeg84bfpEKdV9zW8V0zLrFDISOOg49LddUo+
         99Jxf24r8UBlFDmqCsacleea08znts9E2CQ330Vjg9lLi+Zkrfm3gQbVyD1igQGwuw
         yWbiL+JbBuP9A==
Date:   Sun, 22 Aug 2021 20:54:32 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     stable@vger.kernel.org, miklos@szeredi.hu,
        Murphy Zhou <jencce.kernel@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [PATCH] ovl: add splice file read write helper
Message-ID: <YSLxyD9nKxSeu2vE@sashalap>
References: <20210820195929.1926705-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210820195929.1926705-1-leah.rumancik@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 20, 2021 at 07:59:29PM +0000, Leah Rumancik wrote:
>From: Murphy Zhou <jencce.kernel@gmail.com>
>
>Now overlayfs falls back to use default file splice read
>and write, which is not compatiple with overlayfs, returning
>EFAULT. xfstests generic/591 can reproduce part of this.
>
>Tested this patch with xfstests auto group tests.
>
>[ Needed in 5.4 to fix a deadlock triggered via
>  xfstests overlay/019 -- Leah Rumancik ]

I've queued this up for 5.4, thanks Leah.

-- 
Thanks,
Sasha
