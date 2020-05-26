Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 950901E186C
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 02:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgEZAXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 20:23:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729044AbgEZAXz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 May 2020 20:23:55 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9717F20706;
        Tue, 26 May 2020 00:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590452634;
        bh=5qEZqECAybei2ZM42cH8AEN9NCrVOWtAr3u4lbxkXkE=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=M6BxKFTnLTOJG80CI1jx0prR28L6X9EDvfY7UC8tGIOnYgCAP5V5+F3YaXL61ufgT
         hlBUWiSjDmqf1C2sMabrjjCTmC8Bmah2hDOrZiRFNldtI9bPImg0MDVn61CFIx3cX5
         fK1HBgqfTRi6H+jMCTgOatjrVQGsE8Sl54VbhklE=
Date:   Tue, 26 May 2020 00:23:53 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     NeilBrown <neilb@suse.de>
To:     "J. Bruce Fields" <bfields@fieldses.org>
Cc:     linux-nfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 3/3] sunrpc: clean up properly in gss_mech_unregister()
In-Reply-To: <159011289300.29107.18158467549734203675.stgit@noble>
References: <159011289300.29107.18158467549734203675.stgit@noble>
Message-Id: <20200526002354.9717F20706@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 2.6.12+

The bot has tested the following trees: v5.6.14, v5.4.42, v4.19.124, v4.14.181, v4.9.224, v4.4.224.

v5.6.14: Build OK!
v5.4.42: Build OK!
v4.19.124: Build OK!
v4.14.181: Build OK!
v4.9.224: Build OK!
v4.4.224: Failed to apply! Possible dependencies:
    302d3deb2068 ("xprtrdma: Prevent inline overflow")
    65b80179f9b8 ("xprtrdma: No direct data placement with krb5i and krb5p")
    94f58c58c0b4 ("xprtrdma: Allow Read list and Reply chunk simultaneously")
    cce6deeb56aa ("xprtrdma: Avoid using Write list for small NFS READ requests")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
