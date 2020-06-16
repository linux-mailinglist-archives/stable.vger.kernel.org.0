Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F17E1FAFD5
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 14:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgFPMHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 08:07:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:40754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgFPMHY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 08:07:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 715CA2074D;
        Tue, 16 Jun 2020 12:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592309243;
        bh=rHWLg1iKfS8Lyf0NBxPfDpDhcbt3MrCsrm3aIStnX+k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zee3jalf+Tej6ryy4+4ZGQJ+6U5PTUd8sIqXVESgFM6f6nG5Nm7IkmwjaCD5tLNDH
         RWJg3hFZgFgeGRgnnxdmUyKh69naymy3257IydWxHdTgF1GhPb168dWq37QT9bjMQM
         2nz45mwB6EFGyllWCQIka7z4gXW8ONHu4trAwJz8=
Date:   Tue, 16 Jun 2020 14:07:17 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: Please apply backport of commit da2311a6385c ("can: kvaser_usb:
 kvaser_usb_leaf: Fix some info-leaks to USB devices") to v4.9.y
Message-ID: <20200616120717.GA3542686@kroah.com>
References: <20200614075403.GA450037@eldamar.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200614075403.GA450037@eldamar.local>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 14, 2020 at 09:54:03AM +0200, Salvatore Bonaccorso wrote:
> Hi
> 
> The issue fixed with da2311a6385c ("can: kvaser_usb: kvaser_usb_leaf:
> Fix some info-leaks to USB devices") seem to be present as well before
> 4.19, introduced in 3.8 by commit 080f40a6fa28 "can: kvaser_usb: Add
> support for Kvaser CAN/USB devices" already.
> 
> For Debian (for 4.9.210-1 upload) and for 3.16.y upstream Ben
> Hutchings did backport the commit.
> 
> Can you apply it please as well for v4.9.y?

Now applied, thanks.

greg k-h
