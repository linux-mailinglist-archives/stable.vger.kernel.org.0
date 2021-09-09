Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3B1404D44
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245690AbhIIMBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:01:25 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:34610 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344530AbhIIL7W (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 07:59:22 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9438C22379;
        Thu,  9 Sep 2021 11:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631188685;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3ZXEwp058pGiCQOi/Oa5OneY5GtXvC387hZs5TBBNCY=;
        b=i+jqqYWpOwg+Gp5haW/SAPXbhCb0+OfV6AeMyo3SnvqjQfXFgl3OfxspUg94mZXUY7vTiP
        YOPmX0nC2EMRl8waaASdAGOtiMLOFFriFjrZLMk5909jj0YRotQX4swZnWz1D/RO9SPImJ
        KlXn3d1sx1TIhFLpLM3/Y7B6KKXHs5Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631188685;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3ZXEwp058pGiCQOi/Oa5OneY5GtXvC387hZs5TBBNCY=;
        b=20TQZIOza7xsBlT818WRcMShyispTeHL341ddLChpo24mw5BrBQrKeRapijOiDjTH32XYg
        /q+ouGW2z5c7uCAw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 8C369A3FDD;
        Thu,  9 Sep 2021 11:58:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 776A4DA7A9; Thu,  9 Sep 2021 13:58:00 +0200 (CEST)
Date:   Thu, 9 Sep 2021 13:58:00 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.13 171/219] btrfs: subpage: check if there are
 compressed extents inside one page
Message-ID: <20210909115800.GG15306@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210909114635.143983-1-sashal@kernel.org>
 <20210909114635.143983-171-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909114635.143983-171-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 07:45:47AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit 3670e6451bc9c39ab3a46f1da19360219e4319f3 ]
> 
Please drop this patch from stable queue, thanks.
