Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A67206FE6
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 11:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388798AbgFXJVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 05:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728637AbgFXJVs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 05:21:48 -0400
Received: from pobox.suse.cz (nat1.prg.suse.com [195.250.132.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 71C4720857;
        Wed, 24 Jun 2020 09:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592990507;
        bh=G4aQpoTZNsrV3mkPmSf2U3ilmxIUH5dXG5OtKjygbds=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=bmj7lHFKl4trHvPBILzvZaLAwVnAdsUdGhV1r7o8ELCwbclskLR4jjuDM8ca0B2UB
         j3x5FjXd9kU1Q+oJwW486kbuLNcNeTooCpZ7wptwOIJlu6yyhCJPzE0zVRmHwBfpZ+
         c0w1b2Wl7QO1rxzQwlq+02kV+NcWBzEF3bej3gf8=
Date:   Wed, 24 Jun 2020 11:21:37 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     James Hilliard <james.hilliard1@gmail.com>
cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] HID: quirks: Ignore Simply Automated UPB PIM
In-Reply-To: <20200623192415.2024242-1-james.hilliard1@gmail.com>
Message-ID: <nycvar.YFH.7.76.2006241121290.15962@cbobk.fhfr.pm>
References: <20200623192415.2024242-1-james.hilliard1@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 23 Jun 2020, James Hilliard wrote:

> As this is a cypress HID->COM RS232 style device that is handled
> by the cypress_M8 driver we also need to add it to the ignore list
> in hid-quirks.

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs

