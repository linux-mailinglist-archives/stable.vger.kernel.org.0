Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0853B14FF90
	for <lists+stable@lfdr.de>; Sun,  2 Feb 2020 23:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgBBWXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Feb 2020 17:23:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:45498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726989AbgBBWW7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 Feb 2020 17:22:59 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12F1420658;
        Sun,  2 Feb 2020 22:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580682179;
        bh=xDPutBN0/A3YrhddJFSF0I1HNNb7llmlYLnUTX7u+4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=for/iUXVeTIvPXgBwUz47ReDEo4slop88+lTTZrek31laj5OeI4QUz7bG9mCxDppZ
         bMb494/B+LMo2kjopW2TVoWfVSFR47FfvA2nMl6aisGioUxNIh+eHVJ5/6gPJ4+x9t
         xDHDIx8+3+UhePRepJKqQFe9BdD/9I5XLae+m7r4=
Date:   Sun, 2 Feb 2020 17:22:58 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: e1000e: Revert "e1000e: Make watchdog use delayed work" in 5.4
Message-ID: <20200202222258.GC1732@sasha-vm>
References: <7b4b20e95883db121b9aa539bea82f9c93390e7a.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <7b4b20e95883db121b9aa539bea82f9c93390e7a.camel@infinera.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 31, 2020 at 04:42:06PM +0000, Joakim Tjernlund wrote:
>Obove commit was reverted because it mask som e1000e cards unstable:
>https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/drivers/net/ethernet/intel/e1000e/netdev.c?h=linux-5.5.y&id=d5ad7a6a7f3c87b278d7e4973b65682be4e588dd
>
>5.4 does not have this revert, feels forgotten?
>
>bugs:
> https://bugzilla.redhat.com/show_bug.cgi?id=1787026
> https://bugzilla.kernel.org/show_bug.cgi?id=205067

A stable tag would make sure that it wouldn't have been forgotten :)

Queued up for 5.4...

-- 
Thanks,
Sasha
