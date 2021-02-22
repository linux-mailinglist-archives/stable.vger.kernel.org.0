Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712673214AD
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 12:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbhBVLBt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 06:01:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:34572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230312AbhBVLBd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 06:01:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 309C964E32;
        Mon, 22 Feb 2021 11:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613991652;
        bh=a+RWuCUV+etWS5MvxE2yyOI2eUrusfqcCAfdLoba/dc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nO3OU4iZOCv55fiXLzbirSYfo/SQE/CchfMtoA5jD2sdeNtEQz03pkPWG6bQ7JWIx
         F7ClbB7Jr3GLxp/KBmsEOGeW42Eprm8TqGpFxOvT8JD47E73M+jI1OetR6a8dz/FxN
         jRI/fnmXAm1R2PKc0fG3Qhoqt64t8IzwL4LhDlZk=
Date:   Mon, 22 Feb 2021 12:00:50 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     laijs@linux.alibaba.com, pbonzini@redhat.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] kvm: check tlbs_dirty directly" failed to
 apply to 4.14-stable tree
Message-ID: <YDOO4kmRVXHnOdr8@kroah.com>
References: <161035498424207@kroah.com>
 <YC2SRG41YJD29sq5@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YC2SRG41YJD29sq5@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 17, 2021 at 10:01:40PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Jan 11, 2021 at 09:49:44AM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport, will apply to all branches till 4.4-stable.

THanks for these, all now queued up.

greg k-h
