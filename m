Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCD23DB1BD
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 18:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439446AbfJQQBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 12:01:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436580AbfJQQBS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Oct 2019 12:01:18 -0400
Received: from localhost (unknown [192.55.54.60])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A39620872;
        Thu, 17 Oct 2019 16:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571328078;
        bh=hW6huek/OCNo03LBsH5IaDKCEp+GDUUB0WU02dwM/i8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fU38KlaRL7+XxryfBW2q/qTk9vRR7R2oGrGGuM+F4hhU4Rp48QFtSbl+PgEnSVz8a
         p10R9pwGqbyRa2y8tCIzQ5ZYTi8TSEEBxUQlcElVRzIKp/TWQNkkLrvLSV51NbNNA2
         0jG6bjMZ5/WakDxSy+bm3uFQIk/nH+RQNWhvkYiM=
Date:   Thu, 17 Oct 2019 09:01:17 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     sashal@kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Dave Wysochanski <dwysocha@redhat.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH 4.19 62/81] cifs: use cifsInodeInfo->open_file_lock while
 iterating to avoid a panic
Message-ID: <20191017160117.GA1083277@kroah.com>
References: <20191016214805.727399379@linuxfoundation.org>
 <20191016214843.979454273@linuxfoundation.org>
 <20191017085538.GA5847@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017085538.GA5847@amd>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 17, 2019 at 10:55:39AM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Dave Wysochanski <dwysocha@redhat.com>
> > 
> > Commit 487317c99477 ("cifs: add spinlock for the openFileList to
> > cifsInodeInfo") added cifsInodeInfo->open_file_lock spin_lock to protect
> 
> > Fixes: 487317c99477 ("cifs: add spinlock for the openFileList to cifsInodeInfo")
> > 
> > CC: Stable <stable@vger.kernel.org>
> > Signed-off-by: Dave Wysochanski <dwysocha@redhat.com>
> > Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> 
> This is missing upstream commit ID and a signoff.

Good catch, Sasha forgot to do that :(

I'll go fix that now, thanks.

greg k-h
