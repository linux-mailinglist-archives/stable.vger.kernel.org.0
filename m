Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5A6404837
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 12:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhIIKIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 06:08:55 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:55757 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229980AbhIIKIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 06:08:54 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 1D5023200922;
        Thu,  9 Sep 2021 06:07:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 09 Sep 2021 06:07:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=1K0/ZBiegBz77RDKugnz5oOr1bJ
        GQ2coLljxrhEuL/w=; b=xqsSUI87cW3U5oPZeCHQc90SI3l07gfGR/XF64WAiZV
        oV13IC/rmAGNP+OOGe1Vp0vosCJW9YPuG9L3SnjYXYUKGklzgr7KatWplSKtEWYT
        BPluid8QRjfboTRnetKpLl3ui966q4U02o3EvBWNUtgpYcdqqVQL/AmD8AVIgUnU
        S9u9+T+UTbXgJF+SOmyH8Qr1fx6tgUq1F9/m5a4+9BrvzhfbWltVWx8EVRolNwWq
        r5TaUHitsUN4cWuKrBEQYUFQR7pEuzMffOq5VJzTkr6cUjJe1O3Z0lXEZFtiQkIs
        Q/eDJQCSP/DsTcoQVoINQsHCJ36CdEOY+flZbmpeHLg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1K0/ZB
        iegBz77RDKugnz5oOr1bJGQ2coLljxrhEuL/w=; b=uCGD0nQAUoVY8GtWlrAMdv
        tG0IR3A4/26sVNPQUsK5AQ7kbzvke+KURQVZ0Rlz2yaRdhD3Rwwv1xQYFbGKB9bi
        5cNYTzVZtQygQd2BhPzussuW6SloW6LF1919AaECkE84oa3ALnAaViRsOyB7XENm
        dnOVBE+8U3kwHUwmLeL8l5Vv05sVXtOOmsPXGhslU/yLemRozU1Q8XDx7wUDRsLH
        fkLJS/Z4pLsgXIbp6VJQYEEP5b8M3jqW9uoQUmfhEU4QuJLSy4VZcZAsz4E6uNKJ
        mjI+z3KqOXR6fOdpGaw6o0EfzwMGJXdajFcx5rGSkDoktX9n36USn20XH2NU+lbA
        ==
X-ME-Sender: <xms:8Nw5YfqO07PxOBBEWjRIUMc5QgV6GhtvU71G6ovMFuzqiLD5UVn4iQ>
    <xme:8Nw5YZqY9oUS_9gd1imrO6cZAQr1LgqNOHrhJUfsuedwO7pJnxp3vrBYi1aNKyCA3
    cwesscdUqAPVw>
X-ME-Received: <xmr:8Nw5YcOtccggEbkIwkSzz92aDu7sVlDLkLFWRKXXIpD2BrAbnTQ6m7A9iMzejScDlnN18ZFSaq7krtXi7DGwoTRcUCAQCctO>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudefledgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:8Nw5YS6aKwmQ7-B-4QXHy7in7Oq7hK5EIazLh5qhEca5lKLD7nuo2g>
    <xmx:8Nw5Ye69wVZWsj8d6IIoxPf8WYgV01zZ_6Rm3aWZhvMv5cuKB1bcUw>
    <xmx:8Nw5YahOcP1PfUMEv7QY70c--wj82Y4NMlfaaL0ijQkX-r_K22xTPw>
    <xmx:8Nw5YbumioQwMdUoNvOAj4wkVxfoRSuSAzc_pcW23NjA3AsARt2efg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Sep 2021 06:07:43 -0400 (EDT)
Date:   Thu, 9 Sep 2021 12:07:32 +0200
From:   Greg KH <greg@kroah.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Yi Zhang <yi.zhang@redhat.com>,
        linux-block <linux-block@vger.kernel.org>, stable@vger.kernel.org
Subject: Re: [bug report] NULL pointer at blk_mq_put_rq_ref+0x20/0xb4
 observed with blktests on 5.13.15
Message-ID: <YTnc5Ja/DKR30Euy@kroah.com>
References: <CAHj4cs-noupgFn3QjB96Z20hv-BhFLHOyFZFEtrhGpESkeoRSA@mail.gmail.com>
 <CAFj5m9J4sxRwQb7+nHzYOurX9QRpEgsEMCqdx4SHA4THnsJXBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFj5m9J4sxRwQb7+nHzYOurX9QRpEgsEMCqdx4SHA4THnsJXBA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 05:14:18PM +0800, Ming Lei wrote:
> On Thu, Sep 9, 2021 at 4:47 PM Yi Zhang <yi.zhang@redhat.com> wrote:
> >
> > Hello
> >
> > I found this issue with blktests on[1], did we miss some patch on stable?
> > [1]
> > https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > queue/5.13
> >
> > [   68.989907] run blktests block/006 at 2021-09-09 04:34:35
> > [   69.085724] null_blk: module loaded
> > [   74.271624] Unable to handle kernel NULL pointer dereference at
> > virtual address 00000000000002b8
> > [   74.280414] Mem abort info:
> > [   74.283195]   ESR = 0x96000004
> > [   74.286245]   EC = 0x25: DABT (current EL), IL = 32 bits
> > [   74.291545]   SET = 0, FnV = 0
> > [   74.294587]   EA = 0, S1PTW = 0
> > [   74.297720] Data abort info:
> > [   74.300588]   ISV = 0, ISS = 0x00000004
> > [   74.304411]   CM = 0, WnR = 0
> > [   74.307368] user pgtable: 4k pages, 48-bit VAs, pgdp=000008004366e000
> > [   74.313796] [00000000000002b8] pgd=0000000000000000, p4d=0000000000000000
> > [   74.320577] Internal error: Oops: 96000004 [#1] SMP
> > [   74.325443] Modules linked in: null_blk mlx5_ib ib_uverbs ib_core
> > rfkill sunrpc vfat fat joydev acpi_ipmi ipmi_ssif cdc_ether usbnet mii
> > mlx5_core psample ipmi_devintf mlxfw tls ipmi_msghandler arm_cmn
> > cppc_cpufreq arm_dsu_pmu acpi_tad fuse zram ip_tables xfs ast
> > i2c_algo_bit drm_vram_helper drm_kms_helper crct10dif_ce syscopyarea
> > ghash_ce sysfillrect uas sysimgblt sbsa_gwdt fb_sys_fops cec
> > drm_ttm_helper ttm nvme usb_storage nvme_core drm xgene_hwmon
> > aes_neon_bs
> > [   74.366458] CPU: 31 PID: 2511 Comm: fio Not tainted 5.13.15+ #1
> 
> Looks the fixes haven't land on linux-5.13.y:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a9ed27a764156929efe714033edb3e9023c5f321
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c2da19ed50554ce52ecbad3655c98371fe58599f

Now queued up.  Someone could have told us they were needed :)

thanks,

greg k-h
