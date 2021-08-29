Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDD663FA99A
	for <lists+stable@lfdr.de>; Sun, 29 Aug 2021 08:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbhH2G4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Aug 2021 02:56:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhH2G4F (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Aug 2021 02:56:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79178608FB;
        Sun, 29 Aug 2021 06:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630220114;
        bh=/9MWlv86cH7s/o64eTKbQB0R6FPrKWLxHsm8LsaGEVk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0oqQyQuiTz1ZK1u4XehPPNPYla6J2hA4UYxgsuMVs9ftbuwC26zvCnhSk26iKGTdD
         PrBABOwC/mfnUK9w/13IvlRciBLaUf/swSMRKNm9sGop6TaF6QMrFHWlY1qI6PUuJy
         F9TlupMyL2Sw6sa83MIKw0u67hkFCwnUp1P4UhIw=
Date:   Sun, 29 Aug 2021 08:55:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH stable-5.4.y] btrfs: fix race between marking inode needs
 to be logged and log syncing
Message-ID: <YSsvSQR0qHhLeI6C@kroah.com>
References: <2f474ee209a89b42c2471aab71a0df038f7e8d4c.1629969541.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f474ee209a89b42c2471aab71a0df038f7e8d4c.1629969541.git.anand.jain@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 28, 2021 at 06:37:28AM +0800, Anand Jain wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> commit bc0939fcfab0d7efb2ed12896b1af3d819954a14 upstream.

5.10 also needs this, can you provide a working backport for that as
well so that no one would get a regression if they moved to a newer
kernel release?  Then we could take this patch.

thanks,

greg k-h
