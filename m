Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBE73AB680
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 16:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbhFQOyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 10:54:46 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:48663 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S230028AbhFQOyp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 10:54:45 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 15HEqNPa006358
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Jun 2021 10:52:23 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id E7E6615C3CB8; Thu, 17 Jun 2021 10:52:22 -0400 (EDT)
Date:   Thu, 17 Jun 2021 10:52:22 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, adilger.kernel@dilger.ca
Subject: Re: [PATCH] ext4: return error code when ext4_fill_flex_info() fails
Message-ID: <YMthpl31g7j+fB6m@mit.edu>
References: <20210510111051.55650-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510111051.55650-1-yangyingliang@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 10, 2021 at 07:10:51PM +0800, Yang Yingliang wrote:
> After commit c89128a00838 ("ext4: handle errors on ext4_commit_super"), 'ret' may
> be set to 0 before calling ext4_fill_flex_info(), if ext4_fill_flex_info() fails
> ext4_mount() doesn't return error code, it makes 'root' is null which causes
> crash in legacy_get_tree().
> 
> Fixes: c89128a00838 ("ext4: handle errors on ext4_commit_super")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Cc: <stable@vger.kernel.org> # v4.18+
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Applied, thanks.

					- Ted
