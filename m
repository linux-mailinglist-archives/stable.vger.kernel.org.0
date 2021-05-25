Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C956D39008B
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 14:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhEYMFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 08:05:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:57660 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232290AbhEYMFg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 May 2021 08:05:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1621944245;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3pU7FPIKi204QsYDUsOztm/jKLORrkOdObS2K+LQprg=;
        b=sFnUyODWDvbIcmPhRjtPBzPXt9Jnk0cGy3hSY0x2ID54oJIzTCnieWvo1LOQNKszD4JdLQ
        5YRvV0EKdWk8q60d841RwD3VKDIlNNSQ7fuOzuWTS2zGXAZsZyAnlTqN5yH3txlGm4eABg
        OVCojGsruJY2DhXhwkm+wOAbofHYKvQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1621944245;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3pU7FPIKi204QsYDUsOztm/jKLORrkOdObS2K+LQprg=;
        b=TxyhY0OJPvWJYb62hRkNvthHJpmxspVcsWJZKJ7ud+9o4anVs9Uua/HvjhkQIzrBgrMcYL
        4/ilfCFwaB2yEJAw==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CEE41AE1F;
        Tue, 25 May 2021 12:04:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7A0B1DA734; Tue, 25 May 2021 14:01:29 +0200 (CEST)
Date:   Tue, 25 May 2021 14:01:29 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 5.12 037/127] btrfs: zoned: pass start block to
 btrfs_use_zone_append
Message-ID: <20210525120129.GV7604@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>
References: <20210524152334.857620285@linuxfoundation.org>
 <20210524152336.106395864@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524152336.106395864@linuxfoundation.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 24, 2021 at 05:25:54PM +0200, Greg Kroah-Hartman wrote:
> From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> 
> commit e380adfc213a13677993c0e35cb48f5a8e61ebb0 upstream.
> 
> btrfs_use_zone_append only needs the passed in extent_map's block_start
> member, so there's no need to pass in the full extent map.
> 
> This also enables the use of btrfs_use_zone_append in places where we only
> have a start byte but no extent_map.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

As this is a prerequisite for the other patch, please drop it from
stable queue as well, thanks.
