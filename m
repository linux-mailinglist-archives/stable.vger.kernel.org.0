Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A5429E9E4
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 12:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgJ2LCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 07:02:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbgJ2LCh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Oct 2020 07:02:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00E2A2072D;
        Thu, 29 Oct 2020 11:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603969356;
        bh=HkZvAn5MjVZOthJYyfmXpbjUnjLgxWPIT1sDs9FNYU0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RoxVHBr5/s0q8Ly0B0NSmsykQw88I3WBCRzmng+S2FJgp6T/ET8/DF/+i7OxNsVE2
         Y1MafCmeaHTwcImhbeEzzjMY7nmTSmd29izdq9kWZ45Lt0Wmw3snYgz9hSlPXndgWM
         rROr5/yoKDUFWWoX71syakVRiqSghZj2/7ahci/w=
Date:   Thu, 29 Oct 2020 12:03:26 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Cc:     stable@vger.kernel.org, Thomas Zimmermann <tzimmermann@suse.de>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        b.zolnierkie@samsung.com, jani.nikula@intel.com,
        daniel.vetter@ffwll.ch, gustavoars@kernel.org,
        dri-devel@lists.freedesktop.org, akpm@linux-foundation.org,
        rppt@kernel.org
Subject: Re: [PATCH 1/1] video: fbdev: fix divide error in fbcon_switch
Message-ID: <20201029110326.GC3840801@kroah.com>
References: <20201021235758.59993-1-saeed.mirzamohammadi@oracle.com>
 <ad87c5c1-061d-8a81-7b2c-43a8687a464f@suse.de>
 <3294C797-1BBB-4410-812B-4A4BB813F002@oracle.com>
 <20201027062217.GE206502@kroah.com>
 <2DA9AE6D-93D6-4142-9FC4-EEACB92B7203@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2DA9AE6D-93D6-4142-9FC4-EEACB92B7203@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 27, 2020 at 10:12:49AM -0700, Saeed Mirzamohammadi wrote:
> Hi Greg,
> 
> Sorry for the confusion. I’m requesting stable maintainers to cherry-pick this patch into stable 5.4 and 5.8.
> commit cc07057c7c88fb8eff3b1991131ded0f0bcfa7e3
> Author: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> Date:   Wed Oct 21 16:57:58 2020 -0700
> 
>     video: fbdev: fix divide error in fbcon_switch

I do not see that commit in Linus's tree, do you?

confused,

greg k-h
