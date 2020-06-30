Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B50520F0D8
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 10:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731637AbgF3Isd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 04:48:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:32988 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731642AbgF3Isc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jun 2020 04:48:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 95F48ADCA;
        Tue, 30 Jun 2020 08:48:30 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 67B07DA790; Tue, 30 Jun 2020 10:48:15 +0200 (CEST)
Date:   Tue, 30 Jun 2020 10:48:15 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Hans van Kranenburg <hans@knorrie.org>
Cc:     dsterba@suse.cz, Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3] btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl
Message-ID: <20200630084815.GU27795@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Hans van Kranenburg <hans@knorrie.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <20200626150107.19666-1-johannes.thumshirn@wdc.com>
 <20200626200619.GI27795@twin.jikos.cz>
 <e59c3b69-d10c-198d-2f69-b3936f908a73@knorrie.org>
 <b43e807b-97f8-3b46-b29d-46318398a215@knorrie.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b43e807b-97f8-3b46-b29d-46318398a215@knorrie.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 28, 2020 at 12:35:27AM +0200, Hans van Kranenburg wrote:
> So, the same thing as done here could be done when extending
> GET_DEV_STATS because I see users are asking about counters for repaired
> errors to be added, so they can be used for early warning alerts of
> failing disks.

Yes the dev stats are extensible following the same scheme and we'll add
new counters eventually.
