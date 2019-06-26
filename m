Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72698567D2
	for <lists+stable@lfdr.de>; Wed, 26 Jun 2019 13:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbfFZLkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jun 2019 07:40:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725930AbfFZLkw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Jun 2019 07:40:52 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A734C20656;
        Wed, 26 Jun 2019 11:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561549251;
        bh=cXDjADq70yEofAmBMymoAZA6jFegl+M2Q3RHsZ+ZK0U=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=Y0PKSEt2+uMdOdXtfZN6kwh3IkXozKcntfrGIzuBjYgvpt1tRbEyWLaywxeD/mvMu
         qsQ9Ve7OQFKVvAtHNbgf1WygGSB0g18ThStxiRz1Rst1cpKkV6uTpNVkeix5n73r1o
         +NWbnp+jWc0Zz2Kfpy2i9QgrU+YmsK5JEC725wUI=
Date:   Wed, 26 Jun 2019 13:40:47 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Oleksandr Natalenko <oleksandr@redhat.com>
cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        "Herton R . Krzesinski" <herton@redhat.com>,
        Oliver Neukum <oneukum@suse.de>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sebastian Parschauer <s.parschauer@gmx.de>
Subject: Re: [PATCH] hid: add another quirk for Chicony PixArt mouse
In-Reply-To: <20190621091736.14503-1-oleksandr@redhat.com>
Message-ID: <nycvar.YFH.7.76.1906261340350.27227@cbobk.fhfr.pm>
References: <20190621091736.14503-1-oleksandr@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 21 Jun 2019, Oleksandr Natalenko wrote:

> I've spotted another Chicony PixArt mouse in the wild, which requires
> HID_QUIRK_ALWAYS_POLL quirk, otherwise it disconnects each minute.
> 
> USB ID of this device is 0x04f2:0x0939.
> 
> We've introduced quirks like this for other models before, so lets add
> this mouse too.
> 
> Link: https://github.com/sriemer/fix-linux-mouse#usb-mouse-disconnectsreconnects-every-minute-on-linux
> Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs

