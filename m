Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8540033D5F6
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 15:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbhCPOmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 10:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232002AbhCPOmB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 10:42:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 507A86507D;
        Tue, 16 Mar 2021 14:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615905721;
        bh=OHX825C3UzAW3uf4c1TTiD26NlTs851j5uLceMniJZg=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=Ot3kGTyIF8EOIESfmOddFY7C/KxlBe7wsHWHza4sCQPdw15RCAqD6YriRVAU+yJNi
         uCZqDKhQwdObTLeR6h2oWct2c+iUzXvBVmlS0It+8ozjb2cAQ04rUvOi6JsOLLLZ0I
         hefo5wsEA6jrBuGWlsrSpxNToO0e8jKUBHrqcJ1v8P7in7axZAC8x6eahm/x4lTKO5
         oHk4T7fHSMvUfvPvzlsxQuJJkAyz/rnA2BF27Diid0FwvQ/Dmfko4MeKYVx+7K2Mma
         8tFb2ox72nEIjEKyusvL9mtX20Q8m6z3jEyjP1zwcm6pJcptUdkXRQoMXY3CFY3bHJ
         i8l9mSKzpqiNA==
Date:   Tue, 16 Mar 2021 15:41:58 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Ping Cheng <pinglinux@gmail.com>
cc:     linux-input@vger.kernel.org, Juan.Garrido@wacom.com,
        Jason.Gerecke@wacom.com, Ping Cheng <ping.cheng@wacom.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] HID: wacom: set EV_KEY and EV_ABS only for non-HID_GENERIC
 type of devices
In-Reply-To: <20210311193009.12692-1-ping.cheng@wacom.com>
Message-ID: <nycvar.YFH.7.76.2103161541470.12405@cbobk.fhfr.pm>
References: <20210311193009.12692-1-ping.cheng@wacom.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 11 Mar 2021, Ping Cheng wrote:

> Valid HID_GENERIC type of devices set EV_KEY and EV_ABS by wacom_map_usage.
> When *_input_capabilities are reached, those devices should already have
> their proper EV_* set. EV_KEY and EV_ABS only need to be set for
> non-HID_GENERIC type of devices in *_input_capabilities.
> 
> Devices that don't support HID descitoprs will pass back to hid-input for
> registration without being accidentally rejected by the introduction of
> patch: "Input: refuse to register absolute devices without absinfo"
> 
> Fixes: 6ecfe51b4082 ("Input: refuse to register absolute devices without absinfo")
> Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
> Reviewed-by: Jason Gerecke <Jason.Gerecke@wacom.com>
> Tested-by: Juan Garrido <Juan.Garrido@wacom.com>
> CC: stable@vger.kernel.org

Applied, thanks Ping.

-- 
Jiri Kosina
SUSE Labs

