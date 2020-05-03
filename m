Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A177E1C2A96
	for <lists+stable@lfdr.de>; Sun,  3 May 2020 09:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgECHnK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 May 2020 03:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbgECHnK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 May 2020 03:43:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA348206EB;
        Sun,  3 May 2020 07:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588491790;
        bh=cKNIEkfCWevMgzu53aYSDJbaXHyisHdRqV0cA7LrHf8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NfgsImc9GA/Uq1X7ukHmx1NzD87s3GNHyHSxQYC0ew8hB3+sXqN0WKn9uLvJJP3rs
         McdE0jwh0pZoPO+fzaZ8+9by+gjwZIwGl9IAM4e/v7oZlc2lnZFOovfsJmauGSNtXh
         J1DFNpKedgN7UhrZN42S2gtrUA7v/gYZW4+Znito=
Date:   Sun, 3 May 2020 09:43:07 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: Please apply commit 191ce17876c9 ("ext4: fix special inode
 number checks in __ext4_iget()") to v4.4.y,v4.9.y,v4.14.y
Message-ID: <20200503074307.GA514300@kroah.com>
References: <7b4601ab-3439-cdb4-91ff-8e5469e46ead@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b4601ab-3439-cdb4-91ff-8e5469e46ead@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 02, 2020 at 09:17:17AM -0700, Guenter Roeck wrote:
> Hi,
> 
> Commit 8a363970d1dc ("ext4: avoid declaring fs inconsistent...")
> was applied to v4.4.y, v4.9.y, and v4.14.y with the latest round
> of stable releases. This commit was later fixed upstream with
> commit 191ce17876c9 ("ext4: fix special inode number checks
> in __ext4_iget()"). Please apply that patch to v4.4.y, v4.9.y,
> and v4.14.y as well.
> 
> [ The fix is present in v4.19.y ]

Thanks for this, now queued up.

greg k-h
