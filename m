Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F8E439092
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 09:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbhJYHt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 03:49:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:41264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231835AbhJYHtY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 03:49:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0276660C4A;
        Mon, 25 Oct 2021 07:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635148022;
        bh=3txTgKlW6qs7ehFJR53EISFK40e9vvH5dEu/+6UZhjs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xBXSTTsupl8pB0VfJO+G5qUvHZe+BDKgiFObHSgDACb2lH/wPhxY0XTie04P5lXFw
         F/OK+1jJDxXx9etAGfmn7+l26eSdgzpYW7GwinDb7kv7KlVCLOFVsFnlc6hjBYrc0K
         ku7krhCNlcqvLTT+ft7d2QAXiVyWnHbdIKSOOZeY=
Date:   Mon, 25 Oct 2021 09:47:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     william.xuanziyang@huawei.com, mkl@pengutronix.de,
        stable@vger.kernel.org, linux-can <linux-can@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] can: isotp: isotp_sendmsg(): fix TX
 buffer concurrent access" failed to apply to 5.10-stable tree
Message-ID: <YXZg9Cd78FPJBXCy@kroah.com>
References: <16350748387398@kroah.com>
 <abf4c126-844b-615f-7704-0d6a4697cadb@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abf4c126-844b-615f-7704-0d6a4697cadb@hartkopp.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 24, 2021 at 03:14:50PM +0200, Oliver Hartkopp wrote:
> Hello Greg,
> 
> Linux 5.10 is missing the SF_BROADCAST support which was introduced in 5.11
> - that broke the application of the original patch.
> 
> Just sent out a patch for 5.10-stable some minutes ago:
> 
> [PATCH 5.10-stable] can: isotp: isotp_sendmsg(): fix TX buffer concurrent
> access in isotp_sendmsg()

Now queued up, thanks.

greg k-h
