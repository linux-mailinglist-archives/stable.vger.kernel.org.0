Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0982B405514
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352723AbhIINHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:07:55 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:44812 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357629AbhIINDP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 09:03:15 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 13C9122339;
        Thu,  9 Sep 2021 13:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631192508;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iHdEdGIhVVop6l08v0tKyJWKPGgX312SNWUMY7dk2pg=;
        b=OUA5xSzigFkrxQKMguBIDFb62Q4Fc7v5PIB/pmClecIPU2qsLqL+ZGp3pFCgz08x6BIhL4
        sSJHwg/ObGXzyUB4Y2kRPBIFneB3BrdAx12VWrSGZmbxFyaMegD6g6o0qVYPfHwty1HDx+
        Cag56rltCTV/Jkj/7Qf16guZjZEaCEw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631192508;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iHdEdGIhVVop6l08v0tKyJWKPGgX312SNWUMY7dk2pg=;
        b=XNBWLbTGgkf0yeZ1d2UtkTP2WRBG6P9wCbWl3MeEAJkuzoLSMNf1gVH+ZAgWgb303CQp4O
        gg36NfQiOg5Cv/AA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 0E140A3E2D;
        Thu,  9 Sep 2021 13:01:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0E745DA7A9; Thu,  9 Sep 2021 15:01:43 +0200 (CEST)
Date:   Thu, 9 Sep 2021 15:01:42 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9 37/48] btrfs: subpage: check if there are
 compressed extents inside one page
Message-ID: <20210909130142.GU15306@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210909120015.150411-1-sashal@kernel.org>
 <20210909120015.150411-37-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909120015.150411-37-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 08:00:04AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit 3670e6451bc9c39ab3a46f1da19360219e4319f3 ]

Please drop this patch from stable queue, thanks.
