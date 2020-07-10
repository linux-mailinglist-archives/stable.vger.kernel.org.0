Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F318421B7B2
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 16:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgGJODM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 10:03:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728193AbgGJODJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 10:03:09 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C810207BB;
        Fri, 10 Jul 2020 14:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594389788;
        bh=169imVgUhWvO+9qeDQ8Fj3Y573yPn+TjGS3/WMXdb9k=;
        h=Date:From:To:To:To:CC:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=zS/pCnAUHbFnF/tdyIwsOlc/NgfFIDZiqM9lyUVYc+YOne0Aq0ep1DZfTd5z4qQ03
         nJa1wM/nFVFFp2qf/qEEze8uy+Y912Z8WC1iMzgdS8VJ1RV4nEaP4aiFDIXIj5qPN2
         lvpTfJ3C20z5lcou9M5S/IvGj0UPokhRSNaNCDRI=
Date:   Fri, 10 Jul 2020 14:03:07 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Frank van der Linden <fllinden@amazon.com>
To:     <bfields@fieldses.org>, <chuck.lever@oracle.com>
CC:     Frank van der Linden <fllinden@amazon.com>
Cc:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 01/10] xattr: break delegations in {set,remove}xattr
In-Reply-To: <20200623223927.31795-2-fllinden@amazon.com>
References: <20200623223927.31795-2-fllinden@amazon.com>
Message-Id: <20200710140308.9C810207BB@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.6, v5.4.49, v4.19.130, v4.14.186, v4.9.228, v4.4.228.

v5.7.6: Build OK!
v5.4.49: Build OK!
v4.19.130: Build OK!
v4.14.186: Build OK!
v4.9.228: Build OK!
v4.4.228: Failed to apply! Possible dependencies:
    5d6c31910bc07 ("xattr: Add __vfs_{get,set,remove}xattr helpers")
    6b2553918d8b4 ("replace ->follow_link() with new method that could stay in RCU mode")
    aa80deab33a8f ("namei: page_getlink() and page_follow_link_light() are the same thing")
    cd3417c8fc950 ("kill free_page_put_link()")
    ce23e64013348 ("->getxattr(): pass dentry and inode as separate arguments")
    fceef393a5381 ("switch ->get_link() to delayed_call, kill ->put_link()")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
