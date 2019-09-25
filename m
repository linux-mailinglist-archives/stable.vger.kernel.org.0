Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9539FBDF12
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 15:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406587AbfIYNfD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 09:35:03 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:45059 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405963AbfIYNfD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Sep 2019 09:35:03 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 92AA2464;
        Wed, 25 Sep 2019 09:35:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 25 Sep 2019 09:35:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=ggNw9wYyPuOifS0P26hQ35zLC3p
        nPOXBqVN3m9orgTI=; b=TRmbg/7rg0NYIDwZLBX3aRU/Dsbnjt3lY163DS2c8v5
        CPxUWDHLtroN+pGlzjmwlkmKc2vK+UWIBa+9W/z5hCQcTAqfl7KJRnEYy2KVpXEA
        bDfy1CLk+NGIEfBYjxnDNGskLnU634uoiLFbB2ZV5M9aRYShxSlGF/s+vjEpSlWH
        TqCKpFbEoZEjrRbK7HhdvkqgU0NU7AvzEMHnATNkSN3WvEsHEh1Gt41TYhzfN0WV
        JvMdQmTAvbAk4zKYhXF9zBbH86WI+hVZeiKlEd3UzEfzVPavhwjirgDJvDM42OFy
        RvE3J1NsFF+g3AatszoJ4+YMIlaxEY73FXviKha9Mtg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ggNw9w
        YyPuOifS0P26hQ35zLC3pnPOXBqVN3m9orgTI=; b=X54tFEipJVSi7A6c5mjbRx
        0gz1u2rezwPfG+i3zdlWv6JSKkrd1BgFDGfeJRHT33MnQDmvyTzrr4i0pIYKsRW5
        g7kgUXKP45fplYIXtEjewbAvkMGkC31IP2ve462vaGYBZG1rIoJ0HTv4GvmzIFXF
        aiAH/EDSCWMMGKAMPxhAg+KqDPRP9Nf/gNu0J6T8dVEHdkTepwsdPDPIRhLG+cLH
        /6CDtuzxX5nsivc2mi0aHo7tImxzOPNGfvrmCIt+zuAREZBVEN/RQdvLMtulywKE
        CRvgKom7X4n0PsItaZVh865ngGBpeBfRyF0ueTn8dg6yoFNv71PxDcJdASn/BHCg
        ==
X-ME-Sender: <xms:Bm2LXYnJJAPYWeJWIzLVl7R2UCRWopIScXGLmUdp2CTnUoQGlqM0FA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfedvgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjfgesthdtre
    dttdervdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepgh
    hrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Bm2LXTQznUrW5PTR0IEKeDE1IDqXAjdMAN1R_zQjHq_-mSQa_JDy3g>
    <xmx:Bm2LXaKYytSvpOCtDohaDJJOT1RvBrg-IALqp2TnCMDOvYP2WoLGTg>
    <xmx:Bm2LXZBv6etd3MIv3MiNAWw8ps8W_oboiBL-xrF6uItLIPXH6oG7Dg>
    <xmx:Bm2LXeyAatd4zSIdyCheHnGmcB9QhGRepvpsP7rRBugiR6_kYR2nRw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9AE14D60062;
        Wed, 25 Sep 2019 09:35:01 -0400 (EDT)
Date:   Wed, 25 Sep 2019 15:34:58 +0200
From:   Greg KH <greg@kroah.com>
To:     Harmen Stoppels <me@harmenstoppels.nl>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Revert "Bluetooth: validate BLE connection interval updates"
Message-ID: <20190925133458.GA1496797@kroah.com>
References: <vGzt5wshxYXxE0RkVBTLwAKuxpSX7Ik55SyACyeWo7B65PkEParWOuOFwOurc3KMTUcG4lmrGIsR35YBZlqFqQcMi9WuAYuZeuBoArlygRs=@harmenstoppels.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vGzt5wshxYXxE0RkVBTLwAKuxpSX7Ik55SyACyeWo7B65PkEParWOuOFwOurc3KMTUcG4lmrGIsR35YBZlqFqQcMi9WuAYuZeuBoArlygRs=@harmenstoppels.nl>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 25, 2019 at 12:45:06PM +0000, Harmen Stoppels wrote:
> Hi,
> 
> It would be great when 'Revert "Bluetooth: validate BLE connection interval updates"' was backported to Linux 4.14 (and above). The original patch 'Bluetooth: validate BLE connection interval updates' has caused BLE devices to automatically disconnect after a few attempts negotiating connection parameters with 'unacceptable' intervals as the defaults in the kernel changed.
> 
> subject: Revert "Bluetooth: validate BLE connection interval updates"
> commit id: 68d19d7d995759b96169da5aac313363f92a9075

It's already queued up for the next round of stable kernel releases,
thanks!

greg k-h
