Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D452743C4EA
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 10:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbhJ0IUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 04:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235443AbhJ0IUH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 04:20:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 895E961075;
        Wed, 27 Oct 2021 08:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635322662;
        bh=Tvs8vg13VA/N60SGK6ZS4NQQ46MxuCa+cpjFExD0Daw=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=JjXyaWFm5+bpVloyI/NRbuvHnPdVKLZqXdJ08y1XyKvm0fNT9cjzwDaOexTRLWUDr
         tnbDZpDKXyFIHYHGMLdChj1DxKZ1PrXN+JRsdehnkacC/bLmuIAxSqb8FWsKJt4zIg
         2YTF3n2fGcK3w2vig9rIMzLDhUzlZzt3wVOdNpJZ5z3xcuQgH2Cwy2a3Nqk/zpm051
         mHI+qD9IrivYfb7CAb5ut1w9BURfuQm0p5AbtnV0vLrjazD0afdtTa5Ki/sgCdYSGa
         WghaukezHFxt05rtuSNlKVFZ5SXkVjMTDaXqvt354KHbs8C875LJXPTqLEjwfBdMna
         w9KEkLvaED8uA==
Date:   Wed, 27 Oct 2021 10:17:39 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Andrej Shadura <andrew.shadura@collabora.co.uk>
cc:     linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        stable@vger.kernel.org, kernel@collabora.com,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3 1/2] HID: u2fzero: clarify error check and length
 calculations
In-Reply-To: <20211019152917.79666-1-andrew.shadura@collabora.co.uk>
Message-ID: <nycvar.YFH.7.76.2110271017280.12554@cbobk.fhfr.pm>
References: <20211019152917.79666-1-andrew.shadura@collabora.co.uk>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 Oct 2021, Andrej Shadura wrote:

> The previous commit fixed handling of incomplete packets but broke error
> handling: offsetof returns an unsigned value (size_t), but when compared
> against the signed return value, the return value is interpreted as if
> it were unsigned, so negative return values are never less than the
> offset.
> 
> To make the code easier to read, calculate the minimal packet length
> once and separately, and assign it to a signed int variable to eliminate
> unsigned math and the need for type casts. It then becomes immediately
> obvious how the actual data length is calculated and why the return
> value cannot be less than the minimal length.
> 
> Fixes: 22d65765f211 ("HID: u2fzero: ignore incomplete packets without data")
> Fixes: 42337b9d4d95 ("HID: add driver for U2F Zero built-in LED and RNG")
> Signed-off-by: Andrej Shadura <andrew.shadura@collabora.co.uk>

Both now applied, thanks.

-- 
Jiri Kosina
SUSE Labs

