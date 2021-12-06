Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF6B4691C2
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 09:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239616AbhLFIwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 03:52:01 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51592 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231335AbhLFIwB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 03:52:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E651B611BF
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 08:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8168C341C4;
        Mon,  6 Dec 2021 08:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638780512;
        bh=IAczm1zr1iV7+fxWp43kq+U9l5DQB0MY/V2Z2gmu2YY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oMQ5B6CfmECCC92OYqJ+QYd6hWYPr7Ygi3IIEixTM1U2bwHI8LtzDpMHV4tkuNFMQ
         SiIp91ninVVf+5U/Q76Vl7T79l+ib5osJFg/54A/9XoF4+t+NFlkD9HVGHmtIaxMwO
         hgYH9PWdH9N9ger8/M41yHwg/lx6lpy2zIGX/TO0=
Date:   Mon, 6 Dec 2021 09:48:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     ssuryaextr@gmail.com, dsahern@kernel.org, kuba@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] vrf: Reset IPCB/IP6CB when processing
 outbound pkts in vrf" failed to apply to 4.4-stable tree
Message-ID: <Ya3OXTAESbCxOijc@kroah.com>
References: <1638613684143163@kroah.com>
 <366a22ac-ab74-f4e5-55ab-10ca988a6f0f@gmail.com>
 <YayzH/JxsYmWXdLj@kroah.com>
 <658227e9-091b-cfd3-c71a-a16e5295134a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <658227e9-091b-cfd3-c71a-a16e5295134a@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 05, 2021 at 04:08:53PM -0700, David Ahern wrote:
> On 12/5/21 5:39 AM, Greg KH wrote:
> > so why isn't this needed in 4.4.y?
> 
> The patch fixes a corner case with MPLS + VRF. The VRF feature is not
> really usable before 4.9; I doubt VRF + MPLS with a last label pop is
> usable in 4.4.

Ok, thanks for the explaination.

greg k-h
