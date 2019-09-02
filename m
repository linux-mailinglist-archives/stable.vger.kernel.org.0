Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 986C8A5C11
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 20:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfIBSHn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 14:07:43 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:54755 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726448AbfIBSHm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 14:07:42 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 7E1B862D;
        Mon,  2 Sep 2019 14:07:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 02 Sep 2019 14:07:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=O
        ygM9+eFVUhT15QKH0c+NHGZ0VqNrVrkspmwrM8cZrk=; b=VUMQc4LqLPthXV53J
        K4Ev+1UCKr7hvt76YEi/UnNpVdpKBfNOYEhSeXazPav83Xpd2nYRGFSG94paToFf
        Ud8PfdhQnTD35X+djbNtb/88MkXOG9tlTJsgjs2cBnM8NONv4eWYxp5y1g7NRwCQ
        WztCE+UC8YVu88lzSJJgdhf6IyHwX4bArDixvWJZZwl+TbwhkPCNVMi9X1S8WhA6
        JJL7gARW05ZePPdvtYpmpA6jHkWLT3uH771FG2h51zA7lx/ENRT6/wh0J3oxC4o3
        ktIylCnll+eACiamnvrex+caqS3rM6dQUlHEuUveuF6ZJsU0IQ3oGEzaIBWaLm3h
        TAAUA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=OygM9+eFVUhT15QKH0c+NHGZ0VqNrVrkspmwrM8cZ
        rk=; b=Od5SU0c7xPMCLXyaFkIC7GT/tsCNfwp1r+XGtsSlIMD2bQe+yc0sg2Igr
        65kdfO7hWEoh6f3z/FT7kGvD6dhoHyMS6psYltXTV6RuO8w9w8SgP5yK6M0MIcZs
        IvrswZPQCBJAAOr3HnFEBWQdMcuOyy3hmqaypbVjQgSApKuW3+XhrX9GQrVLU80v
        7rh8Zilmlwj+PchVSEHCzll+42Ud19bAUt02Oc8LuOd/t0nUk5VYnKUm0Jo4D1iO
        07XBba0bDTMyTkDxJJBa/ig6Y/5oCJ/+rbq1dtbSEEu0RqueMwFeaEyTqNnlb5kB
        7t1Q9Yc1+5ikoVB7McaabvoHXzVxQ==
X-ME-Sender: <xms:bFptXYsKLFfZAfvgWbEE81QkFTtSJj_TFGqsbdZOcPObpHEnBF-IBw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejtddguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggugfgjfgesthekredttderjeenucfhrhhomhepifhr
    vghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekle
    druddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:bFptXdBLzMsUIsYU9w4qKRxrapnnoHAG-gcSmJtGdnHaJYaBG1zHDA>
    <xmx:bFptXWA-5DcVd-DzdU1S_4Q9kBc8_CwF_SYRNG0TNKcI5aaSemQ6EA>
    <xmx:bFptXV1vtET_U4vSQxZ_JYerIfmul__FeuNjCQ1rA8mJpxybXKnJDw>
    <xmx:bVptXdXc6st83Q661mqTlT7PhqRqcxLvdHl6kkf99Mei873zbXOmrA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 265B780060;
        Mon,  2 Sep 2019 14:07:40 -0400 (EDT)
Date:   Mon, 2 Sep 2019 20:07:38 +0200
From:   Greg KH <greg@kroah.com>
To:     =?iso-8859-1?Q?Fran=E7ois?= Valenduc <francoisvalenduc@gmail.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org,
        henryburns@google.com, sergey.senozhatsky@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Kernel 5.2.11 dpes not compile
Message-ID: <20190902180738.GA17333@kroah.com>
References: <CACU-xRs6-oog+4gG-zsn-J9MCRS8xF3y-1Aw+yq_iv6PHP7d+A@mail.gmail.com>
 <015acb3e-6722-70c8-b0d5-822f1505fed2@suse.cz>
 <20190829123257.GA8726@jagdpanzerIV>
 <0d340d5b-5495-c66f-eff3-b12c016ed927@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0d340d5b-5495-c66f-eff3-b12c016ed927@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 02, 2019 at 08:01:45PM +0200, François Valenduc wrote:
> 
> Le 29/08/19 à 14:32, Sergey Senozhatsky a écrit :
> > On (08/29/19 14:28), Jiri Slaby wrote:
> > [..]
> >> as is its definition in the structure (and its other uses).
> >>
> >>> ./include/linux/wait.h:67:26: note: in definition of macro ‘init_waitqueue_head’
> >>>    __init_waitqueue_head((wq_head), #wq_head, &__key);  \
> >>>                           ^~~~~~~
> >>> scripts/Makefile.build:278: recipe for target 'mm/zsmalloc.o' failed
> >>> make[1]: *** [mm/zsmalloc.o] Error 1
> >>> Makefile:1073: recipe for target 'mm' failed
> >>>
> >>> You can find my configuration file attached.
> >> You forgot to attach it, but you have CONFIG_COMPACTION=n, I assume.
> >>
> >>> Does anybody have any idea about this ?
> >> Sure, this will fix it (or turn on compaction):
> >> --- a/mm/zsmalloc.c
> >> +++ b/mm/zsmalloc.c
> >> @@ -2413,7 +2413,9 @@ struct zs_pool *zs_create_pool(const char *name)
> >>         if (!pool->name)
> >>                 goto err;
> >>
> >> +#ifdef CONFIG_COMPACTION
> >>         init_waitqueue_head(&pool->migration_wait);
> >> +#endif
> > The fix is correct. I believe Andrew already has the same patch
> > in his tree.
> >
> > 	-ss
> 
> No reaction of the stable team on this ? Meanwhile, the fix is in the
> mainline tree (commit 441e254cd40dc03beec3c650ce6ce6074bc6517f).

Give us a chance to catch up!  :)

> Hopefully it can be included in the next stable releases. However, if I
> read the config text, memory compaction should always be enabled, even
> if it is disabled by default.

It's now queued up everywhere, thanks.

greg k-h
