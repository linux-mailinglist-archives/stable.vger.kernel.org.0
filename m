Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D57646156F
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 13:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbhK2MtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 07:49:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44228 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhK2MrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 07:47:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37811611E1
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 12:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD68C004E1;
        Mon, 29 Nov 2021 12:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638189844;
        bh=hQAU9IA14xA76PNOB8CvX0uPnUSda2uBj+oncujujWQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DrAgkyU/p1kIcFuF+4y/nolsP9b1TLij15v+3bL6kh/kEHJPe9y/LHZh3eZJswHJK
         bdJqyDCHVBBrV9r+Ov8hdQm66kQaHuJdbEub7tQj1zMH9NxHDSBDbJ9sh1hsR1Nqhn
         G4xZfgze+4i8fcXIwenugAXjMzn7UXvLtpHjKV8w=
Date:   Mon, 29 Nov 2021 13:44:02 +0100
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
Message-ID: <YaTLEqHMG9mz+Jpv@kroah.com>
References: <16375838338521@kroah.com>
 <20211128155041.89511-1-manfred@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211128155041.89511-1-manfred@colorfullife.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 28, 2021 at 04:50:41PM +0100, Manfred Spraul wrote:
> From: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> 
> For 5.4.y:

This, and the 5.10.y version, now queued up, thanks!

greg k-h
