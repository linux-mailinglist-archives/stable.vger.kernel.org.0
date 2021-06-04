Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1259B39BD62
	for <lists+stable@lfdr.de>; Fri,  4 Jun 2021 18:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhFDQkp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 12:40:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229690AbhFDQko (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Jun 2021 12:40:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52C8D610E7;
        Fri,  4 Jun 2021 16:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622824738;
        bh=KwdAFV0jfCDXV1fhMRJ10q3Zn2ml+o/TGxWndAzf1iU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CrcESnY81cxpaorNOcUOD+VsbZ5dioS8sOTQ2YM8zPdNkEH6R5k2Atkx3Su+gJSUy
         9rED1+MbC/cCU9sbvCi7TPhbA97LE68pCoV6Glrs1ukVNsfxFEp71+GbF4ssdFi0Rv
         7S8YGOVSIeNfwrvFshNKQUo8Pfjw8mWTqInEmHpJu7ERZirb7F+qTE15fRzvQy4B20
         HYbIbM53G3TXNBI79I6czpF69v7Y3boe4lK51ffn/mplrGf8Df0gqNkeh+uu6j4CZZ
         OpoVzQsPur4r9/2TSbZThi65BjQsybF5hAnqnzatnTW9hk1GvGBiua+mNXjH3fHup9
         dhRvg17pO7vUA==
Date:   Fri, 4 Jun 2021 12:38:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     stable@vger.kernel.org, 989451@bugs.debian.org,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: Re: [5.10.x] Please backport "net: usb: cdc_ncm: don't spew
 notifications" (de658a195ee23ca6aaffe197d1d2ea040beea0a2)
Message-ID: <YLpXIXV96XXv3PP5@sashalap>
References: <YLpRCHB1R1qhBZsk@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YLpRCHB1R1qhBZsk@localhost>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 04, 2021 at 09:12:56AM -0700, Josh Triplett wrote:
>Some USB Ethernet devices using the cdc_ncm driver produce several of
>these messages per second:
>
>Jun 03 19:25:17 s kernel: cdc_ncm 3-2.2:2.0 enx(mac address): 1000 mbit/s downlink 1000 mbit/s uplink
>
>This results in substantial log noise and disk usage.
>
>Please consider backporting
>net: usb: cdc_ncm: don't spew notifications
>(git commit de658a195ee23ca6aaffe197d1d2ea040beea0a2)
>to the 5.10.x stable kernel, to fix this problem.

Queued up, thanks!

-- 
Thanks,
Sasha
