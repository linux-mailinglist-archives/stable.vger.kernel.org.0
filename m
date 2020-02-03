Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA148150F5E
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 19:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgBCSaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 13:30:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:33494 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727934AbgBCSaE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 13:30:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 73AAFB048;
        Mon,  3 Feb 2020 18:30:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 53B21DA7A1; Mon,  3 Feb 2020 19:29:50 +0100 (CET)
Date:   Mon, 3 Feb 2020 19:29:49 +0100
From:   David Sterba <dsterba@suse.cz>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Please add d55966c4279bfc6 to 5.4.x and 5.5.x
Message-ID: <20200203182949.GD2654@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I'd like to ask the stable team to add the patch

d55966c4279bfc6a0cf0b32bf13f5df228a1eeb6
btrfs: do not zero f_bavail if we have available space

to 5.4 and 5.5 stable trees as early as possible.

I'm not familiar with your release schedules but I saw the large patch
sets for review and I hope I could squeeze that one in the upcoming
release.

The commit fixes a problem in 'df' that causes false alerts and there
are a lot of users hitting it. The patch itself is a one-liner, but
with a high impact on usability.

Thanks in advance.
