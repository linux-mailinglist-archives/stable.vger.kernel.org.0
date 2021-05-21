Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63E038CDC8
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 20:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbhEUSzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 14:55:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231174AbhEUSzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 May 2021 14:55:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8392661183;
        Fri, 21 May 2021 18:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621623257;
        bh=lTuJNLLQkW8AEVKlm6CgBumSA95VPju0hOS+ikF685E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=08v1KIPC8luliOM4e0PBD298lsa7aGntjxIgt2N1OCVaXshzOCDuD1qE8IljLmJjN
         UeuLoGudx7CMk+csjmVAHlOCIWw+gJ5LlrVdz1NyeG8X1H00YWLb8rvGxO2leDNDGA
         7ErlBIA9bBKkFHEj1Xj7SGjfHHMq4p34mRDfgmrA=
Date:   Fri, 21 May 2021 20:54:14 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     daniel.vetter@ffwll.ch, Vegard Nossum <vegard.nossum@oracle.com>,
        Dhaval Giani <dhaval.giani@oracle.com>, stable@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: 5.4.y missing upstream commits 7beb691f and 51f644b4, causing:
 WARNING in vkms_vblank_simulate
Message-ID: <YKgB1hSk+GmZrr4S@kroah.com>
References: <c6ba0ebc-41da-60b0-4c59-53ee76c60ba0@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6ba0ebc-41da-60b0-4c59-53ee76c60ba0@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 21, 2021 at 02:33:22PM -0400, George Kennedy wrote:
> Hello Greg,
> 
> During Syzkaller reproducer testing on 5.4.y ( 5.4.121-rc1) the following
> warning occurred:
> 
> WARNING in vkms_vblank_simulate
> https://syzkaller.appspot.com//bug?id=0ba17d70d062b2595e1f061231474800f076c7cb
> 
> First, upstream commit 7beb691f was cherry-pick'd to 5.4.y as upstream
> commit 51f644b4 is dependent on it.
> drm: Initialize struct drm_crtc_state.no_vblank from device settings
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=7beb691f1e6f349c9df3384a85e7a53c5601aaaf
> 
> 
> Second, upstream commit 51f644b4 was cherry-pick'd to 5.4.y, the conflicts
> were resolved, and the warning no longer occurs (rebooted 10 times with the
> fix commits - no "WARNING in vkms_vblank_simulate" messages).
> drm/atomic-helper: reset vblank on crtc reset
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=51f644b40b4b794b28b982fdd5d0dd8ee63f9272
> 
> 
> Cherry-pick'd upstream commit 51f644b4 with conflicts resolved (showing the
> cherry-pick'd commit ID):

I don't understand.

If you want me to take a backported version of an upstream commit,
properly send it to us in a format we can apply it in (your patch was
whitespace damaged.)

Look at the archives of the stable mailing list for loads of examples of
how people do this.

Also, always include the developers of the patches you wish to have
backported and the maintainers, on the cc: so that they can speak up if
they want to.  For drm stuff like this, I will require them to give
their ACK before applying them.

thanks,

greg k-h
