Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E80F1A4500
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 12:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgDJKJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Apr 2020 06:09:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:42708 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgDJKJp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Apr 2020 06:09:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 86C23AB5F;
        Fri, 10 Apr 2020 10:09:43 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 965AEDA72D; Fri, 10 Apr 2020 12:09:06 +0200 (CEST)
Date:   Fri, 10 Apr 2020 12:09:06 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.6 64/68] btrfs: hold a ref on the root in
 btrfs_recover_relocation
Message-ID: <20200410100906.GH5920@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20200410034634.7731-1-sashal@kernel.org>
 <20200410034634.7731-64-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200410034634.7731-64-sashal@kernel.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 09, 2020 at 11:46:29PM -0400, Sasha Levin wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> [ Upstream commit 932fd26df8125a5b14438563c4d3e33f59ba80f7 ]
> 
> We look up the fs root in various places in here when recovering from a
> crashed relcoation.  Make sure we hold a ref on the root whenever we
> look them up.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please drop this patch from all stable versions. It's part of a
larger series that is preparatory switching from SRCU to refcounts, so
the patch on itself does not fix anything.
