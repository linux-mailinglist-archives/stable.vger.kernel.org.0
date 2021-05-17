Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3138E3829DC
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 12:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233034AbhEQKep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 06:34:45 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:60061 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231754AbhEQKeo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 06:34:44 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 58B7A3ED;
        Mon, 17 May 2021 06:33:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 17 May 2021 06:33:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=Fy6GZEPeBPxHprbIy4s5tD7DjYa
        x1n2KBsklprbZC7E=; b=r3NPhLU7gGP5ZU2tlxQTSs/VhL8x0O2doOqybaTEBgr
        mITstaImBXAWPjOXpECNf9RkemlYB0K+IO5SB0XuS7cFkaKrnHxbh6mBmAbj90gX
        DjkhK5zaXrNXsZ4M1y8aVR1Svjw5MTKDCs+CMa5IZwAlsZEGSrT+7kz0rXdxG1pS
        sLWxBjW460/AORXSmxxkoL7DWU/3m68kFjYxW/B9412odpNysM9MKcaQcCzAR+TR
        nt9KKGmJGo1BOH3JeGhterpUGKNGe0xfYMi1acjYNg3je0rSLgSNvL2Lk64c4Obo
        7jBIJCUNFFOfM4GeW8N/Pq9K+kof15VKaSsQXiWmnkg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Fy6GZE
        PeBPxHprbIy4s5tD7DjYax1n2KBsklprbZC7E=; b=nZRq56Hg9xYuMz18f2tG/J
        cILcknPuG8HQv33Un9zur31ARUZI2sSnwcJNGuF9ZP0yrbuGB/lD8NSrA3cNiUQo
        b+l1j1Lt/svGkGUIT+8/65BAPgtK6XNtZ1eofqLJl2A5IL2oq1UBX18H+XJPMcEg
        Nxz0uOftFgvVaFT4Zo7ntIoAWHN1OQJFPYzc6H/dXyUuQoyRhSMlFA3OzAwSPHrA
        eNWC7Mf++uxoG1nfxMNaoVQFGI1Ikh9oy3W/XQm9jRC6Qbo3HQ/Ipb0K2rgCVUFA
        TST6GR2viP2KdxRqLjr0EogrmH5j5AM51Tk9z+8XxegrPtAuHPS93kuvOhLPpOqg
        ==
X-ME-Sender: <xms:dkaiYMg_INeXuyemdyNwsxBH5qkI2GMaEllZf0hM9V0VJ1ZBe3uuDQ>
    <xme:dkaiYFD0XhZ54weG-w1hoK5NLe5LTtkWyuw9bOuo76eluRY7_22Be1d7aYMfZmWIR
    bFiI0eNhQhU8Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:dkaiYEE-DmdKarph-VYoTcSqxsQv3A6_QOXYfdMzQRW3y5_pGJP2yw>
    <xmx:dkaiYNRTzrPRmZFFEHHHzfbjFBokddg8Sg4pXf2JeOJPLLS9lDYIDw>
    <xmx:dkaiYJzt3Uku6uHN81Hbfzc7LqW3XxUrJkkjwR254t5TrZcjScR-Dg>
    <xmx:dkaiYBCE8-OvAlnyR65VOa7Ix5P4ZZNaTHl-qNoaNcHalhthkv1lr6c6PPk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 06:33:26 -0400 (EDT)
Date:   Mon, 17 May 2021 12:33:22 +0200
From:   Greg KH <greg@kroah.com>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>,
        Andrew Boyer <andrew.boyer@dell.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        Henry Orosco <henry.orosco@intel.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>
Subject: Re: RDMA/i40iw: Avoid panic when reading back the IRQ affinity hint
Message-ID: <YKJGcjv0nRH+ayTN@kroah.com>
References: <CAKOOJTwPx5MTU=rjNmmBMD9u22AdSwgiGcf38C5Dj6064XEwaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKOOJTwPx5MTU=rjNmmBMD9u22AdSwgiGcf38C5Dj6064XEwaQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 13, 2021 at 09:34:46AM -0700, Edwin Peer wrote:
> Hello stable team,
> 
> Please consider adding the following upstream commit to the 4.14 stable series:
> 
> commit 43731753c4b7d832775cf6b2301dd0447a5a1851
> Author: Andrew Boyer <andrew.boyer@dell.com>
> Date:   Mon May 7 13:23:38 2018 -0400
> 
> RDMA/i40iw: Avoid panic when reading back the IRQ affinity hint
> 
> The current code sets an affinity hint with a cpumask_t stored on the
> stack. This value can then be accessed through /proc/irq/*/affinity_hint/,
> causing a segfault or returning corrupt data.
> 
> Move the cpumask_t into struct i40iw_msix_vector so it is available later.
> ...
> ...
> ...
> Fixes: 8e06af711bf2 ("i40iw: add main, hdr, status")
> Signed-off-by: Andrew Boyer <andrew.boyer@dell.com>
> Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
> Signed-off-by: Doug Ledford <dledford@redhat.com>
> 
> Note, the fixes tag above appears to be incorrect. The problem was
> introduced in:
> 
> commit e69c5093617afdbd2ab02c289d0adaac044dff66
> Author: Henry Orosco <henry.orosco@intel.com>
> Date:   Wed Nov 9 21:24:48 2016 -0600
> 
> i40iw: Use vector when creating CQs
> 
> Assign each CEQ vector to a different CPU when possible, then
> when creating a CQ, use the vector for the CEQ id. This
> allows completion work to be distributed over multiple cores.
> 
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> Signed-off-by: Henry Orosco <henry.orosco@intel.com>
> Signed-off-by: Doug Ledford <dledford@redhat.com>
> 
> Thus, affected kernels range from 4.10 to pre 4.17.
> 
> Regards,
> Edwin Peer

Now queued up, thanks.

greg k-h

