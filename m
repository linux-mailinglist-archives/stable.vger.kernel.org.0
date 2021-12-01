Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7D8464A5C
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 10:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242111AbhLAJNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 04:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236345AbhLAJNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 04:13:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC044C061574
        for <stable@vger.kernel.org>; Wed,  1 Dec 2021 01:09:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5520B81DF4
        for <stable@vger.kernel.org>; Wed,  1 Dec 2021 09:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E60C53FCE;
        Wed,  1 Dec 2021 09:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638349793;
        bh=zNRpPjGkrDpL+m1TzGbGgiX+MjXQZzASN2nr+vvG2O0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xHXYTmC4J5Opt0gFOoY1udEfcFBNUtZu1JO4ECKq7E0DmjWP9szq6+ipRfb51l4tK
         qM+dBH1Nhi5KHvZyz1stf70BxKwgOHx6dwKf6w2X/b+vKIa15KEkwRNMMRH/xq+BA/
         iCIgKbWypweOVZXW6/erbWxCl3QlsyOIz3qKuLeU=
Date:   Wed, 1 Dec 2021 10:09:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Manfred Spraul <manfred@colorfullife.com>
Cc:     stable@vger.kernel.org,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Davidlohr Bueso <dave@stgolabs.net>, 1vier1@web.de,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] shm: extend forced shm destroy to support objects from
 several IPC nses
Message-ID: <Yac72UP+1aogNpIw@kroah.com>
References: <163758375777179@kroah.com>
 <20211129184429.40660-1-manfred@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129184429.40660-1-manfred@colorfullife.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 29, 2021 at 07:44:29PM +0100, Manfred Spraul wrote:
> From: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> 
> For 4.19.y:
> 
> Upstream commit 85b6d24646e4 ("shm: extend forced shm destroy to support objects from several IPC nses")

Now queued up, thanks.

greg k-h
