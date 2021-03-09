Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1315332775
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 14:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhCINpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 08:45:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230359AbhCINpc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Mar 2021 08:45:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF84864F51;
        Tue,  9 Mar 2021 13:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615297532;
        bh=GL/9FdbL/mNfFudmifPMdv9N9PgRMek2BObAf9xBoLk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OQJXkR4W4JpS58qkfbJu3Kr5QgldXDNGanQxHFs8x+GO6+uTdwaaf68Fb6sA7CG7b
         zeLl2vo5UUm6WpBTU5dQzrrI5ql7WZqhtuEoTdcEswLAg0HEA+aea48c3JpwdlfQNF
         fYS9V4i3pUJeSQ+V6995NBbhnn3MMo9zxhZJkGqw=
Date:   Tue, 9 Mar 2021 14:45:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     "Rafael J . Wysocki" <rjw@rjwysocki.net>, stable@vger.kernel.org
Subject: Re: [PATCH 0/1] ACPICA: Fix race in generic_serial_bus (I2C) and
 GPIO op_region parameter handling
Message-ID: <YEd7+aP73m1EOHZY@kroah.com>
References: <20210309132607.13158-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309132607.13158-1-hdegoede@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 09, 2021 at 02:26:06PM +0100, Hans de Goede wrote:
> Hi Greg,
> 
> Here is a fix for a race in ACPICA which has been present for a long
> time, but has only recently been discovered. It would be good if we
> can get this fixed added to the various stable series.

Queued up for 5.11, 5.10, and 5.4 kernels.  It fails to apply on older
kernels, so a backport is needed if you want it older than 5.4.

thanks,

greg k-h
