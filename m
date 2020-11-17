Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2542B5E72
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 12:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbgKQLeh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 06:34:37 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34975 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727759AbgKQLeh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Nov 2020 06:34:37 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 2EADD5C0160;
        Tue, 17 Nov 2020 06:34:36 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 17 Nov 2020 06:34:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=aww8/rEJVBkygcCTpscpSvLfOSz
        xSm4ocp+75B+ZGSo=; b=UptSwWN9jKeuGgILsMVv/2PxZZz3UToHb44xucSNjEC
        NQm3vMHawefmqs4GKbn5kRJMaYsGGept6PT6NSE5G4jT39Zta3oQY4xYZbrpukXI
        0g6I95oINnRlcUXaw3yHJmWaHckyJ+rujcsaQUocem4VZHlov48aOKWT1sIUSars
        RUi/JQ8TA2g5hXPDNU17yqnKR5kL7FCYSPvZHzNQT4xGBl2eOjpICLIb9BWjtMuU
        rZlqK0PVSro3Z2YH0KAgBSU8XMazr0bWmlvbzzK2kRUcIa7Kv27x8r1636IW0M3i
        hQTUvXWsSMfcQEqIjUkU6SmkDEW8ySARMRTQyqR5BOA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=aww8/r
        EJVBkygcCTpscpSvLfOSzxSm4ocp+75B+ZGSo=; b=hflqB+WWcpZYFqRx8W5Kcy
        xP3P82/OYvRr2YZKOg2hgAQ4M4VcV2ijy+K25h4Olwq/q5w1gawPjZ7g9g27t9nc
        GCby2sALbB/zVTHocGYVz69LnpGnvLvq+dmyHRj2tRAZeKeR29nlrj9YRDsIOTke
        U6T/Wa4knPixBDaiHSPfGCuThxBdBHVjASUaIIH5LOcHVXsnc4X9XC0jDLNst+jT
        32mUPy7e0Exg9NFZukvXg70jtbP4fsBXEyiXzw293XWYteLNctekffF0LFp9KUAf
        jB20RMHMOTf3j+3JV0dkFNo2NEvc+Hg7UbD2gUn60sgSgCXw1ioCpFLl7+bppeKQ
        ==
X-ME-Sender: <xms:TLWzXzpK4NrYckxXVyLkPUzr1bsHA1saiEOIBzkfEcQ-f25_TBkKZA>
    <xme:TLWzX9rSnbUIldzxrAO-qVldIUxQhPlkwu3D_h6Dp-JybPRyDbOOcqJsj2v2Ytz10
    YdQ5_5s_rPodQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeffedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:TLWzXwP7-oMDbaIgwi_hTCRTUtPN6-acGYt86LOiung7hseI7g_YqQ>
    <xmx:TLWzX27-CPVZty70AancekIU9bdGTNrv4X0Vqz_fdQNpMvRp23c_qQ>
    <xmx:TLWzXy7tFpcE9xS-d55T1Kpf0t2JqzVgilVc09oRkZK6JCv7T317YQ>
    <xmx:TLWzX_XGk77niwSlzc9ssBPs7r8w0BdMI2MUMoxnOMgXDBuTquhraw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9A7C83280063;
        Tue, 17 Nov 2020 06:34:35 -0500 (EST)
Date:   Tue, 17 Nov 2020 12:35:25 +0100
From:   Greg KH <greg@kroah.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 00/13] Backport of patch series for stable 4.9 branch
Message-ID: <X7O1fWtctN3n+brk@kroah.com>
References: <20201103143528.22780-1-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201103143528.22780-1-jgross@suse.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 03:35:15PM +0100, Juergen Gross wrote:
> V2: correct patch 2
> 
> Juergen Gross (13):
>   xen/events: don't use chip_data for legacy IRQs
>   xen/events: avoid removing an event channel while handling it
>   xen/events: add a proper barrier to 2-level uevent unmasking
>   xen/events: fix race in evtchn_fifo_unmask()
>   xen/events: add a new "late EOI" evtchn framework
>   xen/blkback: use lateeoi irq binding
>   xen/netback: use lateeoi irq binding
>   xen/scsiback: use lateeoi irq binding
>   xen/pciback: use lateeoi irq binding
>   xen/events: switch user event channels to lateeoi model
>   xen/events: use a common cpu hotplug hook for event channels
>   xen/events: defer eoi in case of excessive number of events
>   xen/events: block rogue events for some time

All now queued up, thanks.

greg k-h
