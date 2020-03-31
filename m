Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 520FA199705
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 15:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730560AbgCaNLS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 09:11:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730543AbgCaNLS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 09:11:18 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B436206F5;
        Tue, 31 Mar 2020 13:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585660277;
        bh=+WakbIJ2tDYa4ngFBTKurNcfOdvNQ+Z6MF01/GY6uKQ=;
        h=Date:From:To:To:To:CC:Cc:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=UzPfEtZZ811macz6dqKYTg4bVvvedvR1e56Fi1LDuhlvfmKPVoHgFgr4yWu/yAXmR
         cx584V9/jXBJ/b+5SHxstXeCG+fYTI65LFNSAOyHbufD3BB8Z634oaVXgklZquQQz3
         xhMNnE8LCe1RmuWq2glyPiMKU0hX7phHx0V2gqqw=
Date:   Tue, 31 Mar 2020 13:11:16 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Frank van der Linden <fllinden@amazon.com>
To:     <bfields@fieldses.org>, <chuck.lever@oracle.com>
CC:     Frank van der Linden <fllinden@amazon.com>
Cc:     stable@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 01/11] xattr: break delegations in {set,remove}xattr and add _locked versions
In-Reply-To: <20200327232717.15331-2-fllinden@amazon.com>
References: <20200327232717.15331-2-fllinden@amazon.com>
Message-Id: <20200331131117.7B436206F5@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.13, v5.4.28, v4.19.113, v4.14.174, v4.9.217, v4.4.217.

v5.5.13: Build OK!
v5.4.28: Build OK!
v4.19.113: Build OK!
v4.14.174: Build OK!
v4.9.217: Build OK!
v4.4.217: Failed to apply! Possible dependencies:
    5d6c31910bc0 ("xattr: Add __vfs_{get,set,remove}xattr helpers")
    6b2553918d8b ("replace ->follow_link() with new method that could stay in RCU mode")
    aa80deab33a8 ("namei: page_getlink() and page_follow_link_light() are the same thing")
    cd3417c8fc95 ("kill free_page_put_link()")
    ce23e6401334 ("->getxattr(): pass dentry and inode as separate arguments")
    fceef393a538 ("switch ->get_link() to delayed_call, kill ->put_link()")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
