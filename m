Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24E321D86B
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 16:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbgGMO1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 10:27:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:37802 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729938AbgGMO1j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Jul 2020 10:27:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EE34DAD4A;
        Mon, 13 Jul 2020 14:27:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4741EDA809; Mon, 13 Jul 2020 16:27:16 +0200 (CEST)
Date:   Mon, 13 Jul 2020 16:27:16 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/4] btrfs: pass checksum type via BTRFS_IOC_FS_INFO
 ioctl
Message-ID: <20200713142716.GJ3703@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <20200713122901.1773-1-johannes.thumshirn@wdc.com>
 <20200713122901.1773-2-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713122901.1773-2-johannes.thumshirn@wdc.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 13, 2020 at 09:28:58PM +0900, Johannes Thumshirn wrote:
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3217,11 +3217,15 @@ static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
>  	struct btrfs_ioctl_fs_info_args *fi_args;
>  	struct btrfs_device *device;
>  	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
> +	u32 flags_in;

u64 here too, I'll fix it.
