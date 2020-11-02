Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B99C12A2E91
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 16:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgKBPp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 10:45:27 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:33693 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726070AbgKBPp1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 10:45:27 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id EB3C1542;
        Mon,  2 Nov 2020 10:45:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 02 Nov 2020 10:45:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=kgcyn2A6hUjwzxMhOEWIOy63TI5
        xgJeupbyhah+d99s=; b=N09gBhxq9xGStJrSz/GA5M0hb28SJCEt+rdsbWAKqW2
        zxK3GluCCY9dVVbyQPn8r8diwJ6LieTMV1JyhSgAp08qbRqrVoctYHTB2EmJCirL
        fh2mgBG7YiYF37sHiD4GHA1USogzqp4l9O29PL6hVvGk9XLbWtII9iYlEfEtFCOS
        LwW3KAWe7f5yWpZEEBzL+RWqseSqGsgIi4iwYx4BHvvggljcsWtHpBtlVAB8F2BD
        3KCLAMekC+C64ErRFuYQL9i/YlwXf4gnJ4xkAN2cRO8QoByJPFprg3avqBtP9E7d
        C9DURV96Tiz4/unl026aXLvLEXRSJTRFtozI3YvpnCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=kgcyn2
        A6hUjwzxMhOEWIOy63TI5xgJeupbyhah+d99s=; b=exL/bwqY3UO/DbrhjxZrp7
        20WsTTZDoHwkePuP1bbqa0/ImDDPt40Xt5Jepzeaj314EJYFSoH3DJlk1aVL2uci
        0hPpU2bsZ/cgB28CP9repcRcGZf3n2GFm961hhPrHQK9JeS1hMpFiXwtkXl4EL67
        pfbcPd/8fEA0XTSFp1Eo4+gacMKZEm4L8fwidmzflkCq4kaDwf88LLn+bnX52l+K
        TDHEWNv+C/hIKpL6m0eGaQJz8YS13YL7nwzYq36wfT0PnFusutFdKvs1vEcUbB3L
        1XVVBUqZw24RvOk0coNs+bcQ8zFKT63G6teGFFs4eT2Cs4QyLuWXpu1ZNd97KP4w
        ==
X-ME-Sender: <xms:limgX6yxf-2DbhHXrAqaetlrfC-CqDXo0fbM6PkfVtKgd5FKoxjJ0Q>
    <xme:limgX2RKhRPW0PmheleUFREdBjgQGBnQayTNrLEQBfgd9iq5kecWSjAHVRwPZYa3M
    WkDR3RtfXYfZg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtuddgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:limgX8XcJlSO_Cm2cKVrrmzU47boqhDgrYDwraOnCPWG8pzfJnDmeg>
    <xmx:limgXwhqZF_zq-x7rUbO-NLlr9BmXbZD3II_phFtjVCJgwwkFvm1Iw>
    <xmx:limgX8AZqMD_UkNkREJ-4eh1LoDKKYYXB7-itpYJGxy_GiHD307Utw>
    <xmx:limgX7_lmpmpw5qy5D-ARzVUryUHOrzvGQ31vFKYVByB1x4nTS1xPg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 06DD03064687;
        Mon,  2 Nov 2020 10:45:25 -0500 (EST)
Date:   Mon, 2 Nov 2020 16:46:19 +0100
From:   Greg KH <greg@kroah.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 00/13] Backport of patch series for stable 5.4 branch
Message-ID: <20201102154619.GB1488920@kroah.com>
References: <20201102094638.3355-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102094638.3355-1-jgross@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 02, 2020 at 10:46:25AM +0100, Juergen Gross wrote:
> Juergen Gross (13):
>   xen/events: avoid removing an event channel while handling it
>   xen/events: add a proper barrier to 2-level uevent unmasking
>   xen/events: fix race in evtchn_fifo_unmask()
>   xen/events: add a new "late EOI" evtchn framework
>   xen/blkback: use lateeoi irq binding
>   xen/netback: use lateeoi irq binding
>   xen/scsiback: use lateeoi irq binding
>   xen/pvcallsback: use lateeoi irq binding
>   xen/pciback: use lateeoi irq binding
>   xen/events: switch user event channels to lateeoi model
>   xen/events: use a common cpu hotplug hook for event channels
>   xen/events: defer eoi in case of excessive number of events
>   xen/events: block rogue events for some time
> 
>  .../admin-guide/kernel-parameters.txt         |   8 +
>  drivers/block/xen-blkback/blkback.c           |  22 +-
>  drivers/block/xen-blkback/xenbus.c            |   5 +-
>  drivers/net/xen-netback/common.h              |  15 +
>  drivers/net/xen-netback/interface.c           |  61 ++-
>  drivers/net/xen-netback/netback.c             |  11 +-
>  drivers/net/xen-netback/rx.c                  |  13 +-
>  drivers/xen/events/events_2l.c                |   9 +-
>  drivers/xen/events/events_base.c              | 422 ++++++++++++++++--
>  drivers/xen/events/events_fifo.c              |  83 ++--
>  drivers/xen/events/events_internal.h          |  20 +-
>  drivers/xen/evtchn.c                          |   7 +-
>  drivers/xen/pvcalls-back.c                    |  76 ++--
>  drivers/xen/xen-pciback/pci_stub.c            |  14 +-
>  drivers/xen/xen-pciback/pciback.h             |  12 +-
>  drivers/xen/xen-pciback/pciback_ops.c         |  48 +-
>  drivers/xen/xen-pciback/xenbus.c              |   2 +-
>  drivers/xen/xen-scsiback.c                    |  23 +-
>  include/xen/events.h                          |  29 +-
>  19 files changed, 710 insertions(+), 170 deletions(-)
> 

All now queued up, thanks for the backports.

greg k-h
