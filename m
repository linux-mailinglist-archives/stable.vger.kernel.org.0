Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C627C2C1ECC
	for <lists+stable@lfdr.de>; Tue, 24 Nov 2020 08:22:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730055AbgKXHWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Nov 2020 02:22:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:51508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730003AbgKXHWM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Nov 2020 02:22:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D25520674;
        Tue, 24 Nov 2020 07:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606202532;
        bh=6wBNXvup6PRNoFzqRr8L43niUZDIyEARU1xIJZ67Zm4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0IKiKcwgb+wh8lBp8//QeNU0JugEwe5sG1tTxWIsPlBn9Q2XnQxJLF9L47BPO5WZW
         Qz8yGQsOkh+Xi1e2vqN399jOiXZYX2DOn5fqUVyezTdZjscUjyKCWR64LX+vdTgZAt
         fJjrLCWFx63bEaT5OsDzQNmgRjLvDihMibUPPxfg=
Date:   Tue, 24 Nov 2020 08:23:20 +0100
From:   gregkh <gregkh@linuxfoundation.org>
To:     =?utf-8?B?5b2t5rWp?= <penghao@uniontech.com>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: patch "USB: quirks: Add USB_QUIRK_DISCONNECT_SUSPEND quirk for
 Lenovo A630Z" added to usb-linus
Message-ID: <X7y06AZXcqsdPenY@kroah.com>
References: <1605886383241186@kroah.com>
 <798902232.431636.1606181042043.JavaMail.xmail@bj-wm-cp-6>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <798902232.431636.1606181042043.JavaMail.xmail@bj-wm-cp-6>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 24, 2020 at 09:24:02AM +0800, 彭浩 wrote:
> I can't find the network link of this patch. Why？

It is right here:
	https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git/commit/?h=usb-linus&id=9ca57518361418ad5ae7dc38a2128fbf4855e1a2

and will go to Linus later this week and show up in his tree then.

Note:

> This email message is intended only for the use of the individual or entity who
> /which is the intended recipient and may contain information that is privileged
> or confidential. If you are not the intended recipient, you are hereby notified
> that any use, dissemination, distribution or copying of, or taking any action
> in reliance on, this e-mail is strictly prohibited. If you have received this
> email in error, please notify UnionTech Software Technology  immediately by
> replying to this e-mail and immediately delete and discard all copies of the
> e-mail and the attachment thereto (if any). Thank you.

You really can't send email with this type of footer for kernel
development stuff, as everything we do is NOT confidential.

thanks,

greg k-h
