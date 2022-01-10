Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18731489069
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 07:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235016AbiAJGzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 01:55:23 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45880 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiAJGzW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 01:55:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7558B80E87;
        Mon, 10 Jan 2022 06:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FD1C36AED;
        Mon, 10 Jan 2022 06:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641797719;
        bh=ivoy7dYTby1hHVGDZtmIJCibvuxZns2thdhxmWukwGM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JInc3EvdGPAdOamGiZc47YM7y9tOOHX3QcFGpNwduaomQtbbILi3B8MGK91+GbJ/D
         b4y6PO4xkoBTc/dvr3ErXzvAmI0O1k+4Ria7iWWuaeb/aSK5RIrXDKBWfBS5nQsGVW
         4n4c/LVyZBrhXnWUTnebrlkW5o1vfJCxCb50R7gE=
Date:   Mon, 10 Jan 2022 07:55:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Karl Kurbjun <kkurbjun@gmail.com>
Cc:     linux-input@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        stable@vger.kernel.org
Subject: Re: [PATCH] HID: Ignore battery for Elan touchscreen on HP Envy X360
 15t-dr100
Message-ID: <YdvYVQub0+pu5ahg@kroah.com>
References: <20220110034935.15623-1-kkurbjun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110034935.15623-1-kkurbjun@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 09, 2022 at 08:49:35PM -0700, Karl Kurbjun wrote:
> Battery status on Elan tablet driver is reported for the HP ENVY x360
> 15t-dr100. There is no separate battery for the Elan controller resulting
> in a battery level report of 0% or 1% depending on whether a stylus has
> interacted with the screen. These low battery level reports causes a
> variety of bad behavior in desktop environments. This patch adds the
> appropriate quirk to indicate that the batery status is unused for this
> target.
> 
> Signed-off-by: Karl Kurbjun <kkurbjun@gmail.com>
> ---
>  drivers/hid/hid-ids.h   | 1 +
>  drivers/hid/hid-input.c | 2 ++
>  2 files changed, 3 insertions(+)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
