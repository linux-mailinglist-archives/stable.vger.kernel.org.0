Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8532431147F
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232844AbhBEWGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:06:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:44346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232880AbhBEOwM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:52:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F0DD650DD;
        Fri,  5 Feb 2021 15:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612537749;
        bh=VgoeamMrRJ/nWoAGLMDwkW2XYYOF+2JWQXt539/V+FU=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=rgQIV9lN4/cV4HP0NGd5D3IUWmZaZmQyBXmjMH7ZmD4mtkgb76HBXVrmCP8MmJl6i
         6I5PlZDhRd8ZAtdHDEbQrF93FsqLiwxLlQSCOCWftPzUYIm+WtYgLpTd6j8+FBJ3Cc
         w6A8BsFfflFfwWjn9eYSzdwWH9BdyXhGcIpD2ZyfeoKZdHABaosD1qDqE+lH2Dzvpe
         YXTXw5yx0FSQbzlHIIKQg/29Y7maQYje4+MvmvNd+yiZsBCz8Ug1xR5KBwDCn1PNPS
         0zdUrOFTTBwUAg/VO9VIAsM5NUa6U6BF02zYgBQB8sah6cPVgal+gAkRy13U7T91gd
         YzkMDDKluxoWQ==
Date:   Fri, 5 Feb 2021 16:09:06 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     =?ISO-8859-15?Q?Filipe_La=EDns?= <lains@archlinux.org>
cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?ISO-8859-15?Q?Filipe_La=EDns?= <lains@riseup.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] HID: logitech-dj: add support for keyboard events in
 eQUAD step 4 Gaming
In-Reply-To: <20210205143444.1155367-1-lains@archlinux.org>
Message-ID: <nycvar.YFH.7.76.2102051608550.28696@cbobk.fhfr.pm>
References: <20210205143444.1155367-1-lains@archlinux.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 5 Feb 2021, Filipe Laíns wrote:

> From: Filipe Laíns <lains@riseup.net>
> 
> In e400071a805d6229223a98899e9da8c6233704a1 I added support for the
> receiver that comes with the G602 device, but unfortunately I screwed up
> during testing and it seems the keyboard events were actually not being
> sent to userspace.
> This resulted in keyboard events being broken in userspace, please
> backport the fix.
> 
> The receiver uses the normal 0x01 Logitech keyboard report descriptor,
> as expected, so it is just a matter of flagging it as supported.
> 
> Reported in
> https://github.com/libratbag/libratbag/issues/1124
> 
> Fixes: e400071a805d6 ("HID: logitech-dj: add the G602 receiver")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Filipe Laíns <lains@riseup.net>
> ---
> 
> Changes in v2:
> - added missing Fixes: anc Cc: tags

Applied, thanks Filipe.

-- 
Jiri Kosina
SUSE Labs

