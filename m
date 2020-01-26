Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD1E9149C6D
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 20:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbgAZTFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 14:05:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgAZTFz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Jan 2020 14:05:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A57612070A;
        Sun, 26 Jan 2020 19:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580065555;
        bh=42vwx3SiX8MMbcVxpmi5+63e5azozIxrYdct4iyy6h0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nY9BaQ9nsGZS1lrolIAkTapXAlf2QasAizAXpa0Mm50iUlAqReSyorFQVPVoiAzbf
         mdGCdlqxOP746huLDv3TsYIwYTnB3atZAlvZAS2xm6mKMg8yUF56V2Lhn4WFcIe1bm
         DX436S8a/VPFAUv5LLk0uyKdLgJCSc8tkIMMGdx4=
Date:   Sun, 26 Jan 2020 20:05:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jonathan Billings <jsbillings@jsbillings.org>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 325/639] afs: Fix AFS file locking to allow fine
 grained locks
Message-ID: <20200126190553.GA4095102@kroah.com>
References: <20200124093047.008739095@linuxfoundation.org>
 <20200124093127.839498079@linuxfoundation.org>
 <20200126185703.GB26911@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200126185703.GB26911@amd>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 26, 2020 at 07:57:03PM +0100, Pavel Machek wrote:
> On Fri 2020-01-24 10:28:15, Greg Kroah-Hartman wrote:
> > From: David Howells <dhowells@redhat.com>
> > 
> > [ Upstream commit 68ce801ffd82e72d5005ab5458e8b9e59f24d9cc ]
> > 
> > Fix AFS file locking to allow fine grained locks as some applications, such
> > as firefox, won't work if they can't take such locks on certain state files
> > - thereby preventing the use of kAFS to distribute a home directory.
> > 
> > Note that this cannot be made completely functional as the protocol only
> > has provision for whole-file locks, so there exists the possibility
> 
> Is this suitable for -stable?

Yes, it fixes a bug.
