Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6E21AA44A
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636014AbgDONXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 09:23:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:53714 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2636005AbgDONXH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 09:23:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 82DB7AE87;
        Wed, 15 Apr 2020 13:23:03 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8CEB3DA840; Wed, 15 Apr 2020 15:22:24 +0200 (CEST)
Date:   Wed, 15 Apr 2020 15:22:24 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.6 051/129] btrfs: handle NULL roots in
 btrfs_put/btrfs_grab_fs_root
Message-ID: <20200415132224.GB5920@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <20200415113445.11881-1-sashal@kernel.org>
 <20200415113445.11881-51-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415113445.11881-51-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 07:33:26AM -0400, Sasha Levin wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> [ Upstream commit 4cdfd93002cb84471ed85b4999cd38077a317873 ]
> 
> We want to use this for dropping all roots, and in some error cases we
> may not have a root, so handle this to make the cleanup code easier.
> Make btrfs_grab_fs_root the same so we can use it in cases where the
> root may not exist (like the quota root).

This is another patch from the preparatory series, not needed for
stable. Please drop it, thanks.
