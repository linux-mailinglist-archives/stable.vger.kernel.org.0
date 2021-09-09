Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE7B405520
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354996AbhIINIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:08:25 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:44910 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353709AbhIINDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 09:03:41 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id B4A4422367;
        Thu,  9 Sep 2021 13:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631192529;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r5lfdoUKeH0kmo/VAVCjyEyeBxk1DucjJPKK50iG0W8=;
        b=kHLnbPNiNr5u1ZwG5eUSdXan3c4Sf4Qhflbg9DzWfEiMwnJ1UZfZ0IMQx8GE2OGIhV2PVJ
        Y+Lf5LzlFQw/ogrqncnsgYhkGG8WemXPtZrH0XEytMcMoLr+06xZZLTa8oNFHrk1zPuz9R
        AWtLTBjeF7lcrWWpoAuI3uHvnIrHrhA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631192529;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r5lfdoUKeH0kmo/VAVCjyEyeBxk1DucjJPKK50iG0W8=;
        b=eVgQonJBNAJg1DEcOsOZpX2ReZCbE4Y2fHxZvDewVneULyY6YTDEJv/xRHAw5rEbHoSTvg
        fWANgVfHaRCNYpBQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id AB395A437D;
        Thu,  9 Sep 2021 13:02:09 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id ACA1FDA7A9; Thu,  9 Sep 2021 15:02:04 +0200 (CEST)
Date:   Thu, 9 Sep 2021 15:02:04 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 28/35] btrfs: subpage: fix race between
 prepare_pages() and btrfs_releasepage()
Message-ID: <20210909130204.GX15306@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, Ritesh Harjani <riteshh@linux.ibm.com>,
        Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210909120116.150912-1-sashal@kernel.org>
 <20210909120116.150912-28-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909120116.150912-28-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 08:01:09AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit e0467866198f7f536806f39e5d0d91ae8018de08 ]

Please drop this patch from stable queue, thanks.
