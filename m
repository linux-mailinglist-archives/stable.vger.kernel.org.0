Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFD8405569
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 15:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358867AbhIINJs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 09:09:48 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:44680 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354033AbhIINBi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 09:01:38 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 36CFB2231B;
        Thu,  9 Sep 2021 13:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631192427;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lTBH9DU2KIgz1XoqONX3G28NcVsRBxWB/ayIaui9dDc=;
        b=yq3fe3rZEXbUJYv4A3o60hjDYQ8QEwOBefIi71Pqf5EbdLeYH32a7SV+7B1BKtUdXlaX5G
        lY/2edWGM19zUwOJmDmq1Fp97FZVd7JdeDbklaPm8AsCNFB33nIuWcSg6HayrYZIGttR/+
        sBol3SeUcpk6jlscT6fjwXq8v4YBVNM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631192427;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lTBH9DU2KIgz1XoqONX3G28NcVsRBxWB/ayIaui9dDc=;
        b=dtnrlx/Z/40Cf5n3nCkHxS9I4iWGK1i20UcKIlBt0ix0rkihiKdOL/JVqdFJHjSpaVZ4bS
        qNsgebDE+FsAJDDQ==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 2ED04A3FAA;
        Thu,  9 Sep 2021 13:00:27 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 261F1DA7A9; Thu,  9 Sep 2021 15:00:22 +0200 (CEST)
Date:   Thu, 9 Sep 2021 15:00:22 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 137/176] btrfs: reset this_bio_flag to avoid
 inheriting old flags
Message-ID: <20210909130021.GL15306@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qu Wenruo <wqu@suse.com>, Anand Jain <anand.jain@oracle.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20210909115118.146181-1-sashal@kernel.org>
 <20210909115118.146181-137-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909115118.146181-137-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 07:50:39AM -0400, Sasha Levin wrote:
> From: Qu Wenruo <wqu@suse.com>
> 
> [ Upstream commit 4c37a7938496756649096a7ec26320eb8b0d90fb ]

Please drop this patch from stable queue, thanks.
