Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB50240550A
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353022AbhIINHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:07:42 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:52482 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349438AbhIINCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 09:02:01 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D86F11FDF6;
        Thu,  9 Sep 2021 13:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631192450;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J2cvUsCJq+PItl9xkgcP9a5cHDi8s93kYy+jeRgAepU=;
        b=C9RBZH6Q4WbYWiuAdUMx6sYTltfoWDY3f1AQEsiVkf/3cuIQbaCXq0ic3blWIIZZPUy1I2
        e8WeyVm8mY3BbQIcsZphjgYCqdQj47B8W1sklPHpPjTh8KjPr88fDJXdDEGgBomL7qbqKV
        LQBSshwoGiQlznq+ahEGisUDVY1iors=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631192450;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J2cvUsCJq+PItl9xkgcP9a5cHDi8s93kYy+jeRgAepU=;
        b=wv8VcTFF5JWzHNBYGurpVf4YNtfoNtIGvf3qI2upQxda5uRAPaqrFWgE/U7tSCINnG4Foc
        v2XNa0FYjsjsw+AQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id D019DA3D86;
        Thu,  9 Sep 2021 13:00:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D0165DA7A9; Thu,  9 Sep 2021 15:00:45 +0200 (CEST)
Date:   Thu, 9 Sep 2021 15:00:45 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 081/109] btrfs: subpage: check if there are
 compressed extents inside one page
Message-ID: <20210909130045.GO15306@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20210909115507.147917-1-sashal@kernel.org>
 <20210909115507.147917-81-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909115507.147917-81-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 07:54:38AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit 3670e6451bc9c39ab3a46f1da19360219e4319f3 ]

Please drop this patch from stable queue, thanks.
