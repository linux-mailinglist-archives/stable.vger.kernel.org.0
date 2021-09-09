Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A76E404D48
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343638AbhIIMB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:01:27 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:42860 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344876AbhIIL70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 07:59:26 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 0EE7E1FDEA;
        Thu,  9 Sep 2021 11:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631188696;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mPg244Jyiykd9EcKUC6y+33FUcEYZymFC6T/xJVcFn0=;
        b=vG/oucSRasdzG0KghSUzFTWIY8TATBKjg4r/AkDCJroYkc17rO7EixoGxHFar5PU23xZRv
        o6TkyNy1CfcpLwfSR2SUELi7hhe+1Jgqj0nBmYrFeVg82TLfCyi7LMsKxTe1nPaX5a3O6m
        zPbv1uiLnPV1UMaPWBs5RszRhZfuaYg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631188696;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mPg244Jyiykd9EcKUC6y+33FUcEYZymFC6T/xJVcFn0=;
        b=C1+fl9KzxDXV4yQ8nLeh3eEdpHV6RAs4JReKDA3hNeQRIN8u7lLk99AzGh3c8B5Rffd/8L
        SgEfISdkJDu1m7CQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 00CFEA3FE7;
        Thu,  9 Sep 2021 11:58:15 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 04542DA7A9; Thu,  9 Sep 2021 13:58:10 +0200 (CEST)
Date:   Thu, 9 Sep 2021 13:58:10 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.13 173/219] btrfs: subpage: fix race between
 prepare_pages() and btrfs_releasepage()
Message-ID: <20210909115810.GI15306@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, Ritesh Harjani <riteshh@linux.ibm.com>,
        Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210909114635.143983-1-sashal@kernel.org>
 <20210909114635.143983-173-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909114635.143983-173-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 07:45:49AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit e0467866198f7f536806f39e5d0d91ae8018de08 ]

Please drop this patch from stable queue, thanks.
