Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3B34054E0
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:31:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356007AbhIINDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:03:55 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:52456 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354336AbhIINBp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 09:01:45 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B823E1FDF0;
        Thu,  9 Sep 2021 13:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631192434;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bFeFTHrZQcPWXQZNmc5c/AIw5QUyu0cOPDHFokue7lI=;
        b=uNldYXLyrRl5BQ32sVz9eZvRC6sbtEb6yvSQkQLSbzT2pZYYwhyKrSD0dXskZhECUqGagH
        96s59xOsLYyb24t2VhXLURKc/vbMlwtGSSuzyGz3CcwENjNKNH7SnLOewazsujGJnB9X4F
        zRcuhaPE4e5KUcNBrwguwgye5m3mVnI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631192434;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bFeFTHrZQcPWXQZNmc5c/AIw5QUyu0cOPDHFokue7lI=;
        b=luq914zskX6erhzyxhH8IXFOuFXIWRUSuQWmb5bCDb+NRiZqqzucTweDGFBAD3ZBbcGpN7
        E9DCRshXVejFiNAQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id AFBB7A3EA9;
        Thu,  9 Sep 2021 13:00:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id B1599DA7A9; Thu,  9 Sep 2021 15:00:29 +0200 (CEST)
Date:   Thu, 9 Sep 2021 15:00:29 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 138/176] btrfs: subpage: check if there are
 compressed extents inside one page
Message-ID: <20210909130029.GM15306@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210909115118.146181-1-sashal@kernel.org>
 <20210909115118.146181-138-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909115118.146181-138-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 07:50:40AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit 3670e6451bc9c39ab3a46f1da19360219e4319f3 ]

Please drop this patch from stable queue, thanks.
