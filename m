Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F6249B43B
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 13:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377244AbiAYMpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 07:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453413AbiAYMmq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 07:42:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A06C06175B;
        Tue, 25 Jan 2022 04:42:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D9DAB817EC;
        Tue, 25 Jan 2022 12:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20F7C340E0;
        Tue, 25 Jan 2022 12:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643114561;
        bh=drfRGxtX945E9LywqF2BdAvCq/4n0zak1aeId/8+nvA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UYGDEHALKbPJJU1QPz3Ta4Xik5t871DdBZpR0LXUzBVfrwUN55xIEwsC1baLAK98A
         cdTk/yuXs05WWf38NTPQF40E587kDUKFT8RYUghKj3ZaCpKU6vypW3CBUGQVfVV3AF
         4b67gUhp1KWToPi9FAtAnt4siEQXgm8ftb6170Xg=
Date:   Tue, 25 Jan 2022 13:42:38 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>,
        Hans de Goede <hdegoede@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Lukas Wunner <lukas@wunner.de>
Subject: Re: [PATCH 5.16 0873/1039] PCI: pciehp: Use
 down_read/write_nested(reset_lock) to fix lockdep errors
Message-ID: <Ye/wPpOrCfmKYCEj@kroah.com>
References: <20220124184154.642601971@linuxfoundation.org>
 <20220125122323.GA1597465@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125122323.GA1597465@bhelgaas>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 25, 2022 at 06:23:23AM -0600, Bjorn Helgaas wrote:
> On Mon, Jan 24, 2022 at 07:44:22PM +0100, Greg Kroah-Hartman wrote:
> > From: Hans de Goede <hdegoede@redhat.com>
> > 
> > commit 085a9f43433f30cbe8a1ade62d9d7827c3217f4d upstream.
> 
> I would hold off on backporting the pciehp changes until we resolve
> this regression in v5.17-rc1:
> 
>   https://bugzilla.kernel.org/show_bug.cgi?id=215525

Thanks, I will drop it from all queues now.  If it gets resolved, please
email stable@vger and we will be glad to add it back, along with the
fix.

thanks,

greg k-h
