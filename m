Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7286438BC8
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 15:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbfFGNi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 09:38:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:56988 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727600AbfFGNi3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 09:38:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 92C6AAF0B;
        Fri,  7 Jun 2019 13:38:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EA7C2DA849; Fri,  7 Jun 2019 15:39:18 +0200 (CEST)
Date:   Fri, 7 Jun 2019 15:39:18 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: start readahead also in seed devices
Message-ID: <20190607133918.GE30187@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        stable@vger.kernel.org
References: <20190606075444.15481-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606075444.15481-1-naohiro.aota@wdc.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 06, 2019 at 04:54:44PM +0900, Naohiro Aota wrote:
> Currently, btrfs does not consult seed devices to start readahead. As a
> result, if readahead zone is added to the seed devices, btrfs_reada_wait()
> indefinitely wait for the reada_ctl to finish.
> 
> You can reproduce the hung by modifying btrfs/163 to have larger initial
> file size (e.g. xfs_io pwrite 4M instead of current 256K).
> 
> Fixes: 7414a03fbf9e ("btrfs: initial readahead code and prototypes")
> Cc: stable@vger.kernel.org # 3.2+: ce7791ffee1e: Btrfs: fix race between readahead and device replace/removal
> Cc: stable@vger.kernel.org # 3.2+
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

Thanks, added to misc-next.
