Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1272910B4
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 10:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437615AbgJQIMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 04:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408113AbgJQIMC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 17 Oct 2020 04:12:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD6042072D;
        Sat, 17 Oct 2020 08:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602922320;
        bh=Fdv+SrEB+S3f6Ce4YSY8YMKKjArM3G8B7oba96e+lHY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1ethAoxxp66PI9AxEwMMl3Hb230JkEFp70omfMXrxQD9Yq8F/t9FFT55cg5XSdP1n
         5gaXgbTSQnXYCYe76blV1mo2gkkXLlRR2qZJx2bnNtvi6GqX/9wGFLOIMNyCs+4DGw
         OJpTcadIxsRhyPlqrKDmUv1hSlJUKkdnMmVzJW2g=
Date:   Sat, 17 Oct 2020 10:12:49 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        syzbot+009f546aa1370056b1c2@syzkaller.appspotmail.com,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>
Subject: Re: [PATCH 4.19 14/21] staging: comedi: check validity of
 wMaxPacketSize of usb endpoints found
Message-ID: <20201017081249.GA310845@kroah.com>
References: <20201016090437.301376476@linuxfoundation.org>
 <20201016090437.987989197@linuxfoundation.org>
 <20201016130626.GA4335@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016130626.GA4335@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 03:06:27PM +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> > 
> > commit e1f13c879a7c21bd207dc6242455e8e3a1e88b40 upstream.
> > 
> > While finding usb endpoints in vmk80xx_find_usb_endpoints(), check if
> > wMaxPacketSize = 0 for the endpoints found.
> > 
> > Some devices have isochronous endpoints that have wMaxPacketSize = 0
> > (as required by the USB-2 spec).
> > However, since this doesn't apply here, wMaxPacketSize = 0 can be
> > considered to be invalid.
> > 
> > Reported-by: syzbot+009f546aa1370056b1c2@syzkaller.appspotmail.com
> > Tested-by: syzbot+009f546aa1370056b1c2@syzkaller.appspotmail.com
> > Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> > Cc: stable <stable@vger.kernel.org>
> > Link: https://lore.kernel.org/r/20201010082933.5417-1-anant.thazhemadam@gmail.com
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Why duplicate Sign-off?

My scripts, I missed this :(
