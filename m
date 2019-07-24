Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214A072B14
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 11:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfGXJFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 05:05:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbfGXJFf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 05:05:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B86F2189F;
        Wed, 24 Jul 2019 09:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563959134;
        bh=zwEiWTQWjAqafbdjJayIXBEpHubO0/IsvAUbox8JfJI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YWY7OdduIBih/nHMmPXSAF/sG2oQHzORLyPDXX9kSufHr219im78GkEvQeMRqzS9V
         yaRjqtzGDw/bzwb/ZMrp/SJiSqQm23L+fvcR2AYU12Td8XpQZ500ZRETyAp1ujdaG3
         Pztaw9a0c1v08BDOgSeRGxBpPO9w62sbqjg7Gfc8=
Date:   Wed, 24 Jul 2019 11:05:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux- stable <stable@vger.kernel.org>, jthumshirn@suse.de,
        dsterba@suse.com, nborisov@suse.com, lkft-triage@lists.linaro.org
Subject: Re: stable-rc 4.14: i386 and armv7 builds failed
Message-ID: <20190724090532.GA1838@kroah.com>
References: <CA+G9fYt3sCcazODJodtrJUsLDKusaMx1NWeM03hyrgcSVGUM8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYt3sCcazODJodtrJUsLDKusaMx1NWeM03hyrgcSVGUM8Q@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 01:22:33PM +0530, Naresh Kamboju wrote:
> stable rc 4.14 stable rc i386 and armv7 builds failed due to below error.
> 
> fs/btrfs/file.c: In function 'btrfs_punch_hole':
> fs/btrfs/file.c:2787:27: error: invalid initializer
>    struct timespec64 now = current_time(inode);
>                            ^~~~~~~~~~~~
> fs/btrfs/file.c:2790:18: error: incompatible types when assigning to
> type 'struct timespec' from type 'struct timespec64'
>    inode->i_mtime = now;
>                    ^
> fs/btrfs/file.c:2791:18: error: incompatible types when assigning to
> type 'struct timespec' from type 'struct timespec64'
>    inode->i_ctime = now;
>                   ^

Yeah, that's an odd one, it passes x86 at the moment and I can't see
why...

