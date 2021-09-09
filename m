Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B5A405530
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349552AbhIINIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:08:51 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:52498 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357574AbhIINDP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 09:03:15 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 8B3CE1FDF7;
        Thu,  9 Sep 2021 13:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631192464;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qh2CPAviOlMg3z4wyKkbrhmA4oJw5dfTVqE1GKjDiYw=;
        b=GVUxA4k19hvy2qh4snLbmpD6lUnMrj66M5T6ROSEjAjebOUxh5qAUPDcIGfvy7GbFcQ4VE
        5Vl0Vfb0N8y8aopdCSLb6MPVZlPuY/YJDXfQSsHyc0oRVCk7FgbUV/+bhc1VgG6KTPB26a
        44rokRiyKkK/304UErfM/GVA+uH/tNE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631192464;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Qh2CPAviOlMg3z4wyKkbrhmA4oJw5dfTVqE1GKjDiYw=;
        b=ZRrCKeLdIaiAPJUbtGP3Jm/Z6crr+9ZBrk5XW9PnCSgDrcneEnpF2SwA+b/5dfA86RXjoW
        174JDRzmorYF0fDA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 80BB9A3C44;
        Thu,  9 Sep 2021 13:01:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 812F4DA7A9; Thu,  9 Sep 2021 15:00:59 +0200 (CEST)
Date:   Thu, 9 Sep 2021 15:00:59 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 082/109] btrfs: subpage: fix race between
 prepare_pages() and btrfs_releasepage()
Message-ID: <20210909130059.GP15306@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, Ritesh Harjani <riteshh@linux.ibm.com>,
        Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210909115507.147917-1-sashal@kernel.org>
 <20210909115507.147917-82-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909115507.147917-82-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 07:54:39AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit e0467866198f7f536806f39e5d0d91ae8018de08 ]

Please drop this patch from stable queue, thanks.
