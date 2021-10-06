Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F700424A8E
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 01:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbhJFXgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 19:36:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231341AbhJFXgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 19:36:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B967C60F41;
        Wed,  6 Oct 2021 23:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633563260;
        bh=9JXQC7RDl2RFEEASxsydH2MUKYznuW/b0vQFCjiVXoY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X8U8kGd9zqKCYUqgiJJV3Vb0aJFM/zn4V9j6yz3bZv19BE30U8IHBnIb45kcVhnEo
         mzbIEHKO5kNptBeX0yYNDSmpTDQeoC9B5x7JdeGi1WGwyCLbj4rELBgnYbi2MNzjv4
         aBewVDlauZMXX1R6Zo2aq0xOwe2zKE21sz22he/vzZsJqyxVcTj+AwAxeT2SV0F8Vo
         tcOMPg3GOSaDqnkDCybcI/GBNsn6yZ5WWpwkz2pWmGBeCtHQzf6HLWj3v10TNR78WC
         Y9RIInSaE3hyImgCKVDPEuvD3yopsdLIfinwVG00qCADfH2ulnmp5Qg6QY+Dkq/zhd
         a/OHVHEK+NIrg==
Date:   Wed, 6 Oct 2021 16:34:18 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ramji Jiyani <ramjiyani@google.com>
Cc:     arnd@arndb.de, viro@zeniv.linux.org.uk, bcrl@kvack.org, hch@lst.de,
        kernel-team@android.com, linux-aio@kvack.org,
        linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        Jeff Moyer <jmoyer@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] aio: Add support for the POLLFREE
Message-ID: <YV4yevOZqSJJVuVJ@gmail.com>
References: <20211006224311.26662-1-ramjiyani@google.com>
 <YV4nnko8rmWAWj2+@gmail.com>
 <CAKUd0B-9ifaMBAxhaUZjppks8PCy4oCy=erRNnPBjrRxOGKUxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKUd0B-9ifaMBAxhaUZjppks8PCy4oCy=erRNnPBjrRxOGKUxQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 06, 2021 at 04:28:23PM -0700, Ramji Jiyani wrote:
> Should the Fixes tag refer to Commit bfe4037e722e ("aio: implement
> IOCB_CMD_POLL") [2] in this case?
> 
> [1] https://lore.kernel.org/lkml/20180110155853.32348-32-hch@lst.de/
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/fs/aio.c?h=v4.19.209&id=bfe4037e722ec672c9dafd5730d9132afeeb76e9

That's the commit that introduced this bug, right?  The binder change was
earlier.  So it seems the answer is yes.

- Eric
