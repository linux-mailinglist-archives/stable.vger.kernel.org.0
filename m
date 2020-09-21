Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD760273226
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 20:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgIUSpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 14:45:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:59372 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728083AbgIUSpK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 14:45:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AC4F6B198;
        Mon, 21 Sep 2020 18:45:45 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6E759DA6E0; Mon, 21 Sep 2020 20:43:54 +0200 (CEST)
Date:   Mon, 21 Sep 2020 20:43:54 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Denis Efremov <efremov@linux.com>
Cc:     David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: use kvzalloc() to allocate clone_roots in
 btrfs_ioctl_send()
Message-ID: <20200921184354.GQ6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Denis Efremov <efremov@linux.com>,
        David Sterba <dsterba@suse.com>, Josef Bacik <josef@toxicpanda.com>,
        Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200921170336.82643-1-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921170336.82643-1-efremov@linux.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 08:03:35PM +0300, Denis Efremov wrote:
> btrfs_ioctl_send() used open-coded kvzalloc implementation earlier.
> The code was accidentally replaced with kzalloc() call [1]. Restore
> the original code by using kvzalloc() to allocate sctx->clone_roots.
> 
> [1] https://patchwork.kernel.org/patch/9757891/#20529627
> 
> Cc: stable@vger.kernel.org
> Fixes: 818e010bf9d0 ("btrfs: replace opencoded kvzalloc with the helper")
> Signed-off-by: Denis Efremov <efremov@linux.com>

Thanks, the kvzalloc fixup got lost on the way.
