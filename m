Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802BA28E18C
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 15:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731343AbgJNNn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 09:43:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726152AbgJNNn0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 09:43:26 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8497D2076D;
        Wed, 14 Oct 2020 13:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602683005;
        bh=50Isp1fMzF5odDRXVVph1ceNw+hQjzrFBAILlrLX2Pw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VLCdrvtuFG07Z1otCTA6ipma9/tMTg6ZBE84GGwqekGo+fEI829dON8/2wEoEWo2J
         9Wy5/VSiRYI49fMWlG3KkC4gAtgrhRfGMBgBEwUfQwLQ5Rimh8M0fh5uaONE+fv/Wo
         0G1VvxaSqeGB8AAxryBG+QZ9lwBNe8q1+GMbNzL8=
Date:   Wed, 14 Oct 2020 09:43:24 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org, nborisov@suse.com, wqu@suse.com,
        jthumshirn@suse.de, josef@toxicpanda.com, dsterba@suse.com
Subject: Re: [PATCH stable-5.4] backport enospc issues during balance
Message-ID: <20201014134324.GP2415204@sasha-vm>
References: <cover.1602243894.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <cover.1602243894.git.anand.jain@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 14, 2020 at 10:44:45AM +0800, Anand Jain wrote:
>Patch 1 is a preparatory patch to reduce conflicts. Patch 2 fixes
>balance failure due to ENOSPC in btrfs/156 on arm64 systems with
>pagesize=64k. Minor conflicts in fs/btrfs/block-group.c are resolved.
>Thanks.

Queued up, thanks!

-- 
Thanks,
Sasha
