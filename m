Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 786472BA4D2
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 09:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbgKTIi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 03:38:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:57838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgKTIi5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 03:38:57 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E8EE22244;
        Fri, 20 Nov 2020 08:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605861535;
        bh=WKvFfI2Sv+0jVb8CwghcnGHFMrl9uVpsx6lpick4Z0M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EAmCzyZR6clFaObYfc+Dl5oNlFIcAxPRj48W9WUxD+y1H4j2JTJjk6sTkJJ9zJEHQ
         +h1p2s+ATijTgGK1Y0JtwdwAyf6wbAC9qsJDgo1Zp+TCSCfTyezYUeYqs/PydDyrZe
         YVheAHGPJpQArQGkJNHxqpmfsphUGGwFuPj5iflM=
Date:   Fri, 20 Nov 2020 09:39:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kamal Mostafa <kamal@canonical.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: Re: pick up "usb: dwc2: Avoid leaving the error_debugfs label unused"
Message-ID: <X7eAyumuMGcWBG81@kroah.com>
References: <20201119222342.13619-1-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119222342.13619-1-kamal@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 19, 2020 at 02:23:42PM -0800, Kamal Mostafa wrote:
> Hi Sasha-
> 
> To fix an unused-label warning, please pick up this mainline commit:
> 
> 190bb01b72d2 ("usb: dwc2: Avoid leaving the error_debugfs label unused")
> 
> in these stable branches:
> 
>     linux-5.8.y

5.8.y is long end-of-life, nothing I can do there.

>     linux-5.9.y

It does not apply cleanly to this kernel tree, are you sure it is needed
there?  If so, can you provide a working backport?

thanks,

greg k-h
