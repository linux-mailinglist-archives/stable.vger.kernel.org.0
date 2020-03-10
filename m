Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F233517F430
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 10:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgCJJxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 05:53:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:47930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726199AbgCJJxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 05:53:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E447F208E4;
        Tue, 10 Mar 2020 09:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583833994;
        bh=HjyOiOBIg/zu40RS8VP4Cv3KOku/wIMVy17lgi55akc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qdkrwtL6a51+wl25t/LT33F1IZJ9SerKktV0R4OlWjhsMrAu71rLR7F2zBeTYOwS7
         LvhXQwcO2hxSsTZHm/9yPxrHAEbqHoqBMYQWpZ9Injb5rWsxcnZFg+TLc1RE/WD3va
         +O8o6ru55h71Gj3lntybIcB5gs8U0PF8rTHwxtTQ=
Date:   Tue, 10 Mar 2020 10:53:12 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>,
        Jan Stancek <jstancek@redhat.com>,
        LTP Mailing List <ltp@lists.linux.it>,
        Ondrej Moris <omoris@redhat.com>,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: Re: =?utf-8?B?4p2MIFBBTklDS0VE?= =?utf-8?Q?=3A?= Test report for
 kernel 5.5.8-6afe1f4.cki (stable-queue)
Message-ID: <20200310095312.GA2534479@kroah.com>
References: <cki.FE14F151C1.JS9OFUV72I@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.FE14F151C1.JS9OFUV72I@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 09:45:37AM -0000, CKI Project wrote:
> 
> Hello,
> 
> We ran automated tests on a recent commit from this kernel tree:
> 
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>             Commit: 6afe1f4aeae9 - ASoC: topology: Fix memleak in soc_tplg_manifest_load()
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: PANICKED

Given that there's nothing I can do about this, I'm just starting to
flat-out ignore the results of these emails :(

greg k-h
