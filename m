Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF4E8399C3F
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 10:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhFCIIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 04:08:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhFCIIy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 04:08:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31895613E3;
        Thu,  3 Jun 2021 08:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622707630;
        bh=WXsfO/KW+jLlsbAUYDaBCwHIkEDowNVy0RxxHJMzav4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u6sMiN3Ncr1mENBZuy3BA4OMkCxHdUJbyr0zeconm/4TUq+fwD3CEM93j1TPeHeUW
         d8K/COOY4tI1Tj0fCFK+f3RoLde/KHKappTreDg2x3J8nOuxnJFy65OsDU9VYmgvxh
         P5LIm6URhqurhmD5AwP2sdkSdBhywLeIFIKQVL2s=
Date:   Thu, 3 Jun 2021 10:07:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?Q?Lauren=C8=9Biu_P=C4=83ncescu?= <lpancescu@gmail.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Backporting fix for #199981 to 4.19.y?
Message-ID: <YLiNrCFFGEmltssD@kroah.com>
References: <c75fcd12-e661-bc03-e077-077799ef1c44@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c75fcd12-e661-bc03-e077-077799ef1c44@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 03, 2021 at 09:53:46AM +0200, Laurențiu Păncescu wrote:
> Hi there,
> 
> I'm running Debian Buster on an old Asus EeePC and I see the battery always
> at 100% when unplugged, with an estimated battery life of 4200 hours, no
> matter how long I've been using it without AC power.
> 
> I suspect this might be bug #201351, marked as duplicate of #199981 and
> fixed in 5.0-rc1. Would you please consider backporting it to the 4.19 LTS
> kernel?

What specific commit in Linus's tree is this so we know what to
backport?

thanks,

greg k-h
