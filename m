Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1D5E1090BC
	for <lists+stable@lfdr.de>; Mon, 25 Nov 2019 16:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbfKYPIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Nov 2019 10:08:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:53644 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728025AbfKYPIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Nov 2019 10:08:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id ECFA5AD35;
        Mon, 25 Nov 2019 15:08:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 4A44FDA898; Mon, 25 Nov 2019 16:08:32 +0100 (CET)
Date:   Mon, 25 Nov 2019 16:08:31 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: don't double lock the subvol_sem
Message-ID: <20191125150831.GE2734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org
References: <20191119185920.3031-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119185920.3031-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 01:59:20PM -0500, Josef Bacik wrote:
> If we're rename exchanging two subvols we'll try to lock this lock
> twice, which is bad.  Just lock once if either of the ino's are subvols.
> 
> cc: stable@vger.kernel.org
> Fixes: cdd1fedf8261 ("btrfs: add support for RENAME_EXCHANGE and RENAME_WHITEOUT")
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Added to misc-next, thanks.
