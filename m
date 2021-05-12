Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBD237B9BE
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 11:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230375AbhELJ4x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 05:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230295AbhELJ4w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 05:56:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BFA3613FE;
        Wed, 12 May 2021 09:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620813344;
        bh=HcFDldtiVfvbB3pFiIAYSRHFI+pDKYY5woa54J8wwcM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zp9qAL3FW/r77AVD+648xhLS/pQ8t4uVFW8kabS/a9dTpgfltrLRUmzltrcATzhgR
         R8PvJeKXXAvBsRcxgPNq3zcq4vjnKPTRcnm9LXuKxybRYAGq5BmhWSVFm79ZjtPGbp
         MX2wfBsmN257df3lwFRhFszbXmXtKzOPKkmZa1Aw=
Date:   Wed, 12 May 2021 11:55:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] platform/x86: intel-vbtn: Stop reporting
 SW_DOCK events" failed to apply to 5.12-stable tree
Message-ID: <YJumAbFcxjULZZgo@kroah.com>
References: <162080946671117@kroah.com>
 <39b030b4-314f-1271-52df-2df629a81f7d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39b030b4-314f-1271-52df-2df629a81f7d@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 12, 2021 at 11:43:39AM +0200, Hans de Goede wrote:
> Hi Greg,
> 
> On 5/12/21 10:51 AM, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 5.12-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> This is already in 5.12, but then as commit 538d2dd0b9920334e6596977a664e9e7bac73703
> that is the hash it has on my pdx86/fixes branch, where I cherry picked
> it from my pdx86/for-next branch.
> 
> The 2728f39dfc720983e2b69f0f1f0c403aaa7c346f hash you tried to
> cherry-pick is from my pdx86/for-next branch and so this same change
> showed up (again) in 5.13-rc1 under this hash, sorry about the confusion.

Ah, that makes sense, thanks for letting me know.

greg k-h
