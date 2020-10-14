Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB4528E1BC
	for <lists+stable@lfdr.de>; Wed, 14 Oct 2020 15:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgJNNzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 09:55:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731499AbgJNNzx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Oct 2020 09:55:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91F532076D;
        Wed, 14 Oct 2020 13:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602683753;
        bh=HoSrYZqsOVCBYPB2bEjXkMrCyELT/EtXh0QDYX8gDLw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GgmZbGaUwfmQA+XXrv7mQwxDPhgZ9Qgi57x9uyMS8lSTpBIPmSstoNTBhSf19p09P
         6AZWvNrAk9o8cHQx+VtKG39jDAAq3zMwDPDcQNzJExTrTDfzTu1QSaTGomgtIy6Pc7
         3wJ4pjZ+c+OnJh0yQyDLkGr+D2F1qzBKucY6f8Iw=
Date:   Wed, 14 Oct 2020 15:56:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Paul Barker <pbarker@konsulko.com>
Cc:     stable@vger.kernel.org
Subject: Re: Backport request: commit 168200b6 to fix perf build with gcc 10
Message-ID: <20201014135627.GA3698844@kroah.com>
References: <CAM9ZRVvsdgad9sSuDGfwCBBZ5cD8zsMsq=TQBzWZyTZkaZGNdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9ZRVvsdgad9sSuDGfwCBBZ5cD8zsMsq=TQBzWZyTZkaZGNdQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 14, 2020 at 12:48:42PM +0100, Paul Barker wrote:
> Hi folks,
> 
> I'm seeing errors building perf with gcc 10 on the linux-5.4.y branch.
> The linker fails as the traceid_list symbol is defined in multiple
> compilation units. It looks like commit
> 168200b6d6ea0cb5765943ec5da5b8149701f36a ("perf cs-etm: Move
> definition of 'traceid_list' global variable from header file") was
> added to master to fix this but it's not been backported yet.
> Cherry-picking this commit locally fixed my build issues.
> 
> Looking at the Fixes tag in that commit, this should probably go into
> every stable branch from 4.16.y onwards which is still maintained.
> 
> See https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=168200b6d6ea0cb5765943ec5da5b8149701f36a
> 
> Let me know if you need more info.

Now queued up, but perf does not seem to be building on the 4.19.y tree
at the moment, so I don't know how useful that will be there :)

thanks,

greg k-h
