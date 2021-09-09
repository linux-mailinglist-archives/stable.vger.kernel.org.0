Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F43404D10
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240389AbhIIMAs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:00:48 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:34062 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244789AbhIIL4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 07:56:35 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 909932237D;
        Thu,  9 Sep 2021 11:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631188524;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k3YHBtl38t/Y/4ZvUtGV1INe14QmPB6t0AhmWfzGF6k=;
        b=h4ewyp0TWqvxv3/wDGJ/RONTV5b7Ye8d4+d32S169NRrbRgUSMvsDbFNvfxb3/LuzL/sAW
        5Hz/w4hp32EdjF1hO5SQhcYGp2HOVjXlwemHIcnvoh4nKmnkVCDrVDCHUfwpQ8J199TXYq
        EIhmuUEZaRbsMX79MvaKzZfvz6BllUw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631188524;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k3YHBtl38t/Y/4ZvUtGV1INe14QmPB6t0AhmWfzGF6k=;
        b=B452BiTSm5OfL+KrMk1KSrq6rVOS0eqaV8OIImbLjGRPfuMpJV0U8pQByDvV2Q26BKPpYJ
        tCyTbNBcMiBH6lCw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 89564A3C63;
        Thu,  9 Sep 2021 11:55:24 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 91973DA7A9; Thu,  9 Sep 2021 13:55:19 +0200 (CEST)
Date:   Thu, 9 Sep 2021 13:55:19 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.14 192/252] btrfs: subpage: check if there are
 compressed extents inside one page
Message-ID: <20210909115519.GB15306@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210909114106.141462-1-sashal@kernel.org>
 <20210909114106.141462-192-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909114106.141462-192-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 07:40:06AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit 3670e6451bc9c39ab3a46f1da19360219e4319f3 ]

Please drop this patch from stable queue, thanks.
