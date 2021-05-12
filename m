Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B080137B7B6
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhELIVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:21:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230111AbhELIVA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 04:21:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E183F613F8;
        Wed, 12 May 2021 08:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620807592;
        bh=/3pFwu3X6ChDGcY5sgoZ5/pomaoeXMcmdE1BUG6PPHE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TLeEY0RVd9ZwNsOJJjX5hbHwrMXxh7HkXSPw/hLwQeX5I9tj47DbbdVIIoR/wDkGs
         EqVp66lQvRLqB+gtxyjagKiPtnyviXLP4xJzG8F1MYfW6SZ6TVPQW0eL5gsUIHXj7E
         /BGLCScXLp3HfX6HF/Gfjo5nFrMgk7sb+Sl/A86Q=
Date:   Wed, 12 May 2021 10:19:48 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     stable@vger.kernel.org, Dhaval Giani <dhaval.giani@oracle.com>,
        dmitry Vyukov <dvyukov@google.com>
Subject: Re: 5.4.y missing upstream commit 5c4c8c95, causing: BUG: KASAN:
 use-after-free in hci_send_acl
Message-ID: <YJuPpNjaEcsdbe0r@kroah.com>
References: <e19ed0de-1e5c-7a1c-5f53-a32956fca1c5@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e19ed0de-1e5c-7a1c-5f53-a32956fca1c5@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 11, 2021 at 12:29:49PM -0400, George Kennedy wrote:
> Hello Greg,
> 
> During Syzkaller reproducer testing on 5.4.y (5.4.118-rc1) the following
> crash occurred:
> 
> BUG: KASAN: use-after-free in hci_send_acl
> https://syzkaller.appspot.com/bug?extid=98228e7407314d2d4ba2
> 
> We cherry-pick'd upstream commit 5c4c8c95 to 5.4.y and the crash no longer
> occurs (rebooted 10 times with the fix commit - no failures).
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5c4c8c9544099bb9043a10a5318130a943e32fc3

Now queued up, thnaks.

greg k-h
