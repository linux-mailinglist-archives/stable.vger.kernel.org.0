Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB051E89E3
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 14:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388625AbfJ2NsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 09:48:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:56008 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388274AbfJ2NsH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 09:48:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B9148B139;
        Tue, 29 Oct 2019 13:48:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A810ADA734; Tue, 29 Oct 2019 14:48:15 +0100 (CET)
Date:   Tue, 29 Oct 2019 14:48:15 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH 1/2] btrfs: qgroup: Always free PREALLOC META reserve in
 btrfs_delalloc_release_extents()
Message-ID: <20191029134815.GT3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>, David Sterba <dsterba@suse.com>
References: <20191028065149.89155-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028065149.89155-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 28, 2019 at 02:51:48PM +0800, Qu Wenruo wrote:
> commit 8702ba9396bf7bbae2ab93c94acd4bd37cfa4f09 upstream.

Please don't forget to note for which stable version the backport is,
ideally in the subject in the [PATCH ...] section or at least somewhere
in the tag section.
