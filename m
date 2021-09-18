Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7073F410658
	for <lists+stable@lfdr.de>; Sat, 18 Sep 2021 14:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhIRMUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Sep 2021 08:20:08 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:40077 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230333AbhIRMUH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Sep 2021 08:20:07 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id C6E112B01213;
        Sat, 18 Sep 2021 08:18:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 18 Sep 2021 08:18:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=iRLBf3WrhDpNS0i+Si62yDtyDBy
        h99mHvR4p/74M3xg=; b=VpuqDuutQFpm/RHjyVK0AXW6/twFocaOcHyeuP+E7UB
        VHU6+YgIf3tzg+MBpPdckISizlCli8y4/nr/9oPP8tejVIzRVotXWp75wFPsq1p9
        v289ci2W0PHC68H+EgK0wtMPdwRo8YpmSYYkTTSDlEKjq4AgWhz12PYwAUBfYGyo
        T+10VVARDEYCmgl4J/P56wKoKzcs1gHXSkz9d0unelvwFvkwv/2h9JIzlSlbt1C3
        /QCx7bWq1whTBF7wSfGGUAlxfB5MRCg23D4+uqXjVgXo7+l/IV1U9t9Zy+0gSfEY
        OPIp/BWu5+vpTzEOFHkoLXpOW/+CfQJj5fwdF3oMqng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=iRLBf3
        WrhDpNS0i+Si62yDtyDByh99mHvR4p/74M3xg=; b=AYVkLLXwaSJZlmVp7PUv3Y
        BI2bpX+2Ej2TqPIOoAwJtvlx6mcHAthXzw0/4qqdSKK1qZpBEUhMu1jFLYsxz4f1
        haIqgBvdFWQRVieREtq3sQg0qHRp1axw5OJrTFTbueGtasE/SU4hh0gln998klX/
        7XzrXVifvSrOYanobndvpezxSUgjpWMdyIX1ekIH3oSlUkodXfzjephdUaSl2m5e
        bjWhFG29zRVFZxDWUZ6v9od1IZwT3yDkR8v6wsEDPDYloQUj1uBDTsgfaYAmrDUp
        +E8BtTG1WTPKEL+c8OuGfhQaPHaGhgpywQBrYn7PdeKJLJkGe9IDELtTerLn3uoQ
        ==
X-ME-Sender: <xms:ItlFYbU_tER0FYmqDuctQuNzOTYIiypkHZkUZC3F2Zck9XoFFrMV6A>
    <xme:ItlFYTnazSqpeHopBzWdxf_fsEeo2S2sfZa6wXUi4B5wq22ccJlUmzZZrzq6bKa1f
    QrkMB32X4wGtw>
X-ME-Received: <xmr:ItlFYXZ4ob0dT8VWbtyWGiGDTpJXj3N78Z88Tj3sUWxEt_nBVtpUVJLevs6viz0EguAis5i6o2C2yBvlDO_6TNqmox5k3U5p>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehkedggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ItlFYWW6pXXgO1fZxT5MqhQNKHsuidpFW3mkmPdOn7EpB9CEX2VhnQ>
    <xmx:ItlFYVnfZqRVgeuQPdzfTF70aYEo0oVxxxtVgO1fna-uzJFv_Jn7Mw>
    <xmx:ItlFYTeraQGdj-woZq3mPXFFiZtxhv1GPATnJPaBcDwbTD1h5qSlJw>
    <xmx:ItlFYef5l7Bw3ibCxsZK3PA57o0cCqMrF3_2GzkYfh9IS9i65M4qo5hzafk>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 18 Sep 2021 08:18:41 -0400 (EDT)
Date:   Sat, 18 Sep 2021 14:18:40 +0200
From:   Greg KH <greg@kroah.com>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org,
        Alexander Tsvetkov <alexander.tsvetkov@oracle.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH stable-5.4.y stable-5.10.y] btrfs: fix upper limit for
 max_inline for page size 64K
Message-ID: <YUXZIHWG97Pae1HG@kroah.com>
References: <305e717a1ce9bda18b1867c6fb079f91d6e54c98.1631776544.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <305e717a1ce9bda18b1867c6fb079f91d6e54c98.1631776544.git.anand.jain@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 16, 2021 at 03:34:01PM +0800, Anand Jain wrote:
> Commit 6f93e834fa7c5faa0372e46828b4b2a966ac61d7 upstream.
> 
> The mount option max_inline ranges from 0 to the sectorsize (which is
> now equal to page size). But we parse the mount options too early and
> before the actual sectorsize is read from the superblock. So the upper
> limit of max_inline is unaware of the actual sectorsize and is limited
> by the temporary sectorsize 4096, even on a system where the default
> sectorsize is 64K.
> 
> Fix this by reading the superblock sectorsize before the mount option
> parse.
> 
> Reported-by: Alexander Tsvetkov <alexander.tsvetkov@oracle.com>
> CC: stable@vger.kernel.org # 5.4+
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/disk-io.c | 45 +++++++++++++++++++++++----------------------
>  1 file changed, 23 insertions(+), 22 deletions(-)

Now queued up, thanks.

greg k-h
