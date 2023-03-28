Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF646CC1C6
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbjC1ONi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbjC1ONh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:13:37 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C3DCDFD
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:12:38 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B8D9B5C005C;
        Tue, 28 Mar 2023 10:11:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 28 Mar 2023 10:11:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1680012705; x=1680099105; bh=HA
        8Qu6+B/fZNk38DDEdiVcaXfkrKbiq/xKn5l8tfllk=; b=Tp5byWAS8UpKkU6S5e
        rjEdRY9+oxtzZ1P+vyQLppjrG8DrfRvzM3mKpVKE/rzcmDsAn7DkM9eceBllPfOw
        CIP6IOYFO9X+53cDY4vvh9fe49kM3IyGDLJ184yAY2MO/ETQC368mEY4ow0ljR+K
        OK+aNJ4adMD0Yq2EZbHTTso+uIQiSQs7OR5cl6nawZQzGpK2XMrouMYduq6l+Cpy
        Pmtzpzg16jQ0/1zGVvihJlfJH6DmhJo6ZtSRCDKN9WCOhGuqER5j/UK1cs2FecW+
        D0bw2A+BuRekkpGf/uD49snm0LR0bZ8v1ynfWz3Jk3h8nNEtkjDZG/cvZvWw7K9e
        Okng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1680012705; x=1680099105; bh=HA8Qu6+B/fZNk
        38DDEdiVcaXfkrKbiq/xKn5l8tfllk=; b=K7oCibKzj40X8PF6IgNni4bXHLG9n
        aPxTuQ1YQXXUg96q6Y30/b035SZG3zl4kVtuzyyt6xReQ4b7+Uyv2Y40PNBN9AxQ
        4ywgCi1NGtfyVgHWyJfHswp7V7e9Jb5P+QIB51VALotzTz/gxl4oJkZqsbOn6xak
        GKI5O8jBpTuMU5iKhRYalndt2yI/nXWqTk0IfyqgvdEs29V2cZJyH2p5nhA5bCIX
        mAR7v84lX7PvV+YStboZgQKnv+aixQtnGcW14MljG5tfir2m8Or4iMEYtdn+w3+O
        J50TshyqvAsRmAFHRMHQKLB5UxqrjYDiTANrrgDaH5cjqwQR56fQnegIw==
X-ME-Sender: <xms:oPUiZAwJP4tVsNRef-XuWzgDbWmp9CPNPVmlWEIATnRfaCpCEwQx5g>
    <xme:oPUiZES-_fLI_T9YvI-RvN4MVqyi73S0JA3XsjixiRUq_GzlVJVIhVgAMdAC-Ko4W
    89dENeSzeEquA>
X-ME-Received: <xmr:oPUiZCVzC8Vk2DFPgCh5cHYRQ2vqEWiz329StoL91r3eOVQ0yfKuXfL9zOk9zD286ZKFS-qPJdcjfuqAnlwaTQtTqLwOC78D-ydazA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdehgedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:ofUiZOiwUrAV_All0nAShKGEfGNoHBC7EiY-LDRV8UkAD7tu5VnT_g>
    <xmx:ofUiZCCHSeCXb09ZfcfOCQU-p8DdbKaUcNlMMpYJmI8WG2k9Mto7Qw>
    <xmx:ofUiZPLkG2EV9kjrWuhJ-xpltD_dfppVmZbiTVzd1fOGWOYhWYpDTQ>
    <xmx:ofUiZG4hoFAwoMBsCUfnctsQy3jqh_TK9_xp9W5-KgcTpZdLbsYcqg>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 28 Mar 2023 10:11:44 -0400 (EDT)
Date:   Tue, 28 Mar 2023 16:11:42 +0200
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@eng.windriver.com>
Cc:     stable@vger.kernel.org, Dai Ngo <dai.ngo@oracle.com>,
        Xingyuan Mo <hdthky0@gmail.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: Re: [PATCH 5.15/5.10 1/1] NFSD: fix use-after-free in
 __nfs42_ssc_open()
Message-ID: <ZCL1notX-7ICuqDH@kroah.com>
References: <20230328134759.401789-1-ovidiu.panait@eng.windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328134759.401789-1-ovidiu.panait@eng.windriver.com>
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 28, 2023 at 04:47:59PM +0300, Ovidiu Panait wrote:
> From: Dai Ngo <dai.ngo@oracle.com>
> 
> commit 75333d48f92256a0dec91dbf07835e804fc411c0 upstream.
> 
> Problem caused by source's vfsmount being unmounted but remains
> on the delayed unmount list. This happens when nfs42_ssc_open()
> return errors.
> 
> Fixed by removing nfsd4_interssc_connect(), leave the vfsmount
> for the laundromat to unmount when idle time expires.
> 
> We don't need to call nfs_do_sb_deactive when nfs42_ssc_open
> return errors since the file was not opened so nfs_server->active
> was not incremented. Same as in nfsd4_copy, if we fail to
> launch nfsd4_do_async_copy thread then there's no need to
> call nfs_do_sb_deactive
> 
> Reported-by: Xingyuan Mo <hdthky0@gmail.com>
> Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
> Tested-by: Xingyuan Mo <hdthky0@gmail.com>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
> ---
>  fs/nfsd/nfs4proc.c | 22 ++++++----------------
>  1 file changed, 6 insertions(+), 16 deletions(-)
> 

Now queued up, thanks.

greg k-h
