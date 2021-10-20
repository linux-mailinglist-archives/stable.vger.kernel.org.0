Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9D0434B39
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 14:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhJTMfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 08:35:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhJTMfl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 08:35:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A26861355;
        Wed, 20 Oct 2021 12:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634733207;
        bh=Koyjugp2bqtUckORJ1r45cRwPgJNVbC2R36d8cLnHQY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jBO3Bc89Ii1XH/6qUluS0uAeqRgqTqx+fCwtyJ2+qZhfE8gMAE0xqqGOqal/Aw0Ti
         /1zXoyAvbEqiMv+dcYR0Bp/RBGmMLeGeGE1i3Dvbxwroc3X3leRYAUJ4rn2z9ybpbC
         RRR3bKezYJVbRyC387dOS3dhGa+1yv0JAn0qm7sA=
Date:   Wed, 20 Oct 2021 14:33:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Fabian =?iso-8859-1?Q?Bl=E4se?= <fabian@blaese.de>
Cc:     stable@vger.kernel.org
Subject: Re: Backport switchdev fix for bridge-in-bridge configurations to
 linux-5.4
Message-ID: <YXAMlYYM60/H3l+F@kroah.com>
References: <4be2f5fb-9694-2244-9d5f-a85edff0199f@blaese.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4be2f5fb-9694-2244-9d5f-a85edff0199f@blaese.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 19, 2021 at 03:08:00PM +0200, Fabian Bläse wrote:
> 
> Hi,
> 
> Is it possible to backport the commit "net: switchdev: do not propagate bridge updates across bridges" [1] to linux-5.4?
> 
> This patch fixes faulty hardware configuration when nesting DSA-offloaded bridges into software bridges, which can cause vlan_filtering to be disabled in hardware, even though it should be enabled. Therefore, ports/vlans get connected, even though they should be isolated.
> 
> A backport of this patch for linux-5.4 has recently been accepted in OpenWrt [2]
> 
> Best regards,
> Fabian Bläse
> 
> [1] 07c6f9805f12f1bb538ef165a092b300350384aa
> [2] https://github.com/openwrt/openwrt/pull/4493



Now queued up, thanks.

greg k-h
