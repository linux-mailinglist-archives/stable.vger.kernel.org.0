Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B925326DE4D
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 16:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgIQOcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 10:32:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727195AbgIQObp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 10:31:45 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B8FE20684;
        Thu, 17 Sep 2020 14:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600353070;
        bh=6xKpUw7jkAlOJLQf8voJCk9CPr7e69UDWri5rQWbXRI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uXvvT/cVdPsfB+g5MZuc/qMTaVWmp8hfervNgHmYUWQUILdc1OuvYzQLSQDVFy6Xx
         hwHZ0ycVrZ05msyUufMP+51YSKZIorB3FFklG25bya8r9BCS2Tlqj+PzKsJm5FWCGN
         JMNfyB6U3ncKSe+AX7B9KyUddhjC0Al/zpD3aMfc=
Date:   Thu, 17 Sep 2020 16:31:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Takashi Iwai <tiwai@suse.de>, Dan Crawford <dnlcrwfrd@gmail.com>,
        stable@vger.kernel.org
Subject: Re: Sound regression in 5.8.8 caused by "ALSA: hda - Fix silent
 audio output and corrupted input on MSI X570-A PRO"
Message-ID: <20200917143142.GC3941575@kroah.com>
References: <7efd2fe5-bf38-7f85-891a-eee3845d1493@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7efd2fe5-bf38-7f85-891a-eee3845d1493@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 16, 2020 at 08:28:29AM +0200, Hans de Goede wrote:
> Hi All,
> 
> This bug got filed against Fedora last night:
> https://bugzilla.redhat.com/show_bug.cgi?id=1879277
> "1879277 - Audio ducking after Linux kernel 5.8.8 update, with headphones plugged in"
> 
> The system in the bug is using a MSI X570-A PRO motherboard. So this is almost
> certainly (this has not been confirmed) caused by commit 8e83bd51016a in the
> stable tree: "ALSA: hda - Fix silent audio output and corrupted input on MSI X570-A PRO".
> 
> I'm not sure how to proceed with this one for the stable series,
> I guess a revert is in order, but that may (re)break non headphone usage?

If you revert, then 5.9-final will also cause the same problem, right?

Or is all ok there?

thanks,

greg k-h
