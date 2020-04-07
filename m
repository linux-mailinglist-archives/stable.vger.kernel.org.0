Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A79AC1A1063
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 17:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbgDGPj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 11:39:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:57214 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728917AbgDGPj5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 11:39:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 522E0ADDD;
        Tue,  7 Apr 2020 15:39:55 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 828541E1233; Tue,  7 Apr 2020 17:39:55 +0200 (CEST)
Date:   Tue, 7 Apr 2020 17:39:55 +0200
From:   Jan Kara <jack@suse.cz>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jan Kara <jack@suse.cz>, Andrei Vagin <avagin@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH] ucount: Fix wrong inotify ucounts in /proc/sys/user
Message-ID: <20200407153955.GH9482@quack2.suse.cz>
References: <20200407121814.26073-1-jack@suse.cz>
 <87o8s3jskc.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o8s3jskc.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 07-04-20 16:09:39, Thomas Gleixner wrote:
> Jan Kara <jack@suse.cz> writes:
> > Commit 769071ac9f20 "ns: Introduce Time Namespace" broke reporting of
> > inotify ucounts (max_inotify_instances, max_inotify_watches) in
> > /proc/sys/user because it has added UCOUNT_TIME_NAMESPACES into enum
> > ucount_type but didn't properly update reporting in
> > kernel/ucount.c:setup_userns_sysctls(). Update the reporting to fix the
> > issue and also add BUILD_BUG_ON to catch a similar problem in the
> > future.
> 
> Just merged that:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?h=timers/urgent&id=eeec26d5da8248ea4e240b8795bb4364213d3247
> 
> Could you please send a patch with just the build bug on ?

Sure, will do.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
