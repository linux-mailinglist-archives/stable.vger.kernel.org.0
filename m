Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75880324BD4
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 09:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhBYIOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 03:14:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233001AbhBYIOK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 03:14:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2E8464EF1;
        Thu, 25 Feb 2021 08:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614240809;
        bh=LIY9MDHI95sMD60HPO7nzdaThdUKwfORX4UuKl7NzEg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RB7e1IobPzpS693kybY/RBAMYT/Lk/KoKpoD6dM4Guo4yrH3tJNPIX0TRWEWgYgXj
         X5fd7KpnbrvwAk388qli0kfOLpgRvPgNpKkT5A+wu+trVk768Ar9az637pneITh8cN
         csDR1NWXynxlNMzac98gpZRm8bb1WTwf8M9NfyQw=
Date:   Thu, 25 Feb 2021 09:13:26 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Hui Wang <hui.wang@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Please apply commit 234f414efd11 ("Bluetooth: btusb: Some
 Qualcomm Bluetooth adapters stop working") back to 5.10.y
Message-ID: <YDdcJtpCMA0t7r/T@kroah.com>
References: <YDbBKBgPSytJmAl+@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDbBKBgPSytJmAl+@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 10:12:08PM +0100, Salvatore Bonaccorso wrote:
> Hi
> 
> Please do consider applying 234f414efd11 ("Bluetooth: btusb: Some
> Qualcomm Bluetooth adapters stop working") back to 5.10.y versions.
> The issue got introduced in starting in 5.10-rc1.
> 
> Greg, I realize this is for now only in mainline but not even in
> released tag, so following your earlier suggestion this might as well
> be delayed a bit.
> 
> In https://bugzilla.kernel.org/show_bug.cgi?id=211571,
> https://bugzilla.kernel.org/show_bug.cgi?id=210681 and
> https://bugs.debian.org/981005 several users indicated to be affected
> and would appreciate a fix to be backported to the stable series.

Now queued up, thanks.

greg k-h
