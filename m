Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803B5327E7D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 13:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235039AbhCAMnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 07:43:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:48554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235015AbhCAMnD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 07:43:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 041BA64E2E;
        Mon,  1 Mar 2021 12:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614602542;
        bh=ACNDSOHuslDDOEcNBt6bp/qQAJl4VZgkh4bQxp8DbV4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nXsI30Qe0h3VgaWNjdYL84pvXCmWSTXOxe8clmc005HCxomms6gcCp3iN4Eo6XWTy
         2LPtrJ829lLUcCKilTaAvjS9/2j+yYoAirCVaub60l//UYSyuYKdhv5l/IKRPTQKZ+
         fNv+jSkDJ4xyTLAtBkBDscq2KaLKvA9601rlwF2Y=
Date:   Mon, 1 Mar 2021 13:42:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     songmuchun@bytedance.com, akpm@linux-foundation.org,
        david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        osalvador@suse.de, shy828301@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: FAILED: patch "[PATCH] mm: hugetlb: fix a race between freeing
 and dissolving the" failed to apply to 4.4-stable tree
Message-ID: <YDzhK5LM3MnSgaft@kroah.com>
References: <161278206820815@kroah.com>
 <YDgHlEEifKxKKPb/@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDgHlEEifKxKKPb/@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 08:24:52PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Feb 08, 2021 at 12:01:08PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.4-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport.

All now queued up, thanks.

greg k-h
