Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5980237B7C0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 10:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbhELIVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 04:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230070AbhELIVr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 04:21:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33D33613F3;
        Wed, 12 May 2021 08:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620807638;
        bh=2L+ZihtRQ6cWBHcPFy3slp3O0mISvBU4/lL4VqptLDM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EcmM9/Y+67Zb2bf9g3jFtRkrUcTNd+c5Lz/O6GZOE49j21T5RFSOYCPJs42aPI0j7
         qCsedED2gEjB8CUn5mEQ29aLbH+OfTR0JyMwCeRcRLiRwby0a5rGb/frAk/JPADMEk
         ZpeTBzWG9wHCG1VAV8dwabSIKE0VnD3/GtV6bEuo=
Date:   Wed, 12 May 2021 10:20:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     George Kennedy <george.kennedy@oracle.com>
Cc:     stable@vger.kernel.org, Dhaval Giani <dhaval.giani@oracle.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: Re: 5.4.y missing upstream commit 4b793acd, causing: WARNING: in
 hsr_addr_subst_dest
Message-ID: <YJuP1J+daFlz1fWv@kroah.com>
References: <c56d7a4e-d276-21e3-322a-66e2756ee6de@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c56d7a4e-d276-21e3-322a-66e2756ee6de@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 11, 2021 at 12:31:34PM -0400, George Kennedy wrote:
> Hello Greg,
> 
> During Syzkaller reproducer testing on 5.4.y (5.4.118-rc1) the following
> crash occurred:
> 
> WARNING: in hsr_addr_subst_dest
> https://syzkaller.appspot.com/bug?id=924b5574f42ebeddc94fad06f2fa329b199d58d3

That is not a "crash", just syzbot complaining about a warning.

But I'll go queue it up, thanks.

greg k-h
