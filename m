Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86C4F4CD65A
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 15:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239794AbiCDO3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 09:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232296AbiCDO3q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 09:29:46 -0500
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB0C1B60AA
        for <stable@vger.kernel.org>; Fri,  4 Mar 2022 06:28:57 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6192358050E;
        Fri,  4 Mar 2022 09:28:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 04 Mar 2022 09:28:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=UK9vkuMHfT6LnlApSa4x+a66PQwwwcr7oPki2j
        NRUl0=; b=N+2jGOBsXN0LXBB6xpsLSwG5wEZEcvyzL7pZEiazTL/puLHXyFartJ
        wY2GgQwA246+Rm2Z9M0bpUIVvZLPLqwIphTydqjpp3wRzejaJibmv0KbtTidXrlm
        NyqNW81owC1QIHdyNAGmgs985wRWLozVp4hKzcRfblUywWbneKLIJncESUQ3aeCm
        Ri+sBzHqiGo9RgSTRGO75Gxd+FyvXT4TCwuz7F7QDePJmMoaEgqzY+ty93BjbreF
        zg9LQMAmoAsKTDgpfXYX4omprPYsTD8/d4LWgQi9kNMCxCJrbIJoDzQVZIeJ1Y5f
        DjzSGBxz8aKs/mBPo0PT15GaMA9XnzVg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=UK9vkuMHfT6LnlApS
        a4x+a66PQwwwcr7oPki2jNRUl0=; b=jxsMnJdHvoEDIWm72z0o3JNNsD2R2drEF
        t5AQLHbz3jkHG9yjJrExlW5zXOqu1HpJkFD7W2nEaUa8RJIq4+etetIdbfPlrUFY
        4zYQzE2d1X2QejX/1EnbbpFsg22TkRJ6TEdadWwCBjgaHFmK9eNSgmM2uDVu8Env
        SkUffrQ6yPJXDpfwQeD8zlNZZyIm6iA1C65j0K9Y48VazaAodXvJoK/PDQqa2o0x
        c4ldf55xo5aAcLPa/kpqKzx7djUyDhbJnvTSKgRaaRGA4f/RDvpG8ltPAo0tlDuF
        +vyj9Mf+rPuUIYuz2GLisFfVl1ycXon7gbenDMRbeQzym+2e01bcg==
X-ME-Sender: <xms:JiIiYpVNpGU1syshHadKzxKQBGoWD-MALEZQkvO2v0gpANnCKF_2Wg>
    <xme:JiIiYpkC--e_SyPbdxtPj8-AFU_1F6oi8DfG1X0eoKhrIBQJ0CML62wNSVlao7Ewg
    JnJW3v7AVLRSQ>
X-ME-Received: <xmr:JiIiYlbpoVQCgpXtrfV57St-5LuaBX2zMLy3Z76ldq8k8GBU91U6VdUzA7XAKDPqNzlzdCiqj50dEQKNKjzQvuc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddtkedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:JiIiYsUJv3QSdXgD6l7R5N5gzBfx3362HvVTTR-cxnC4cyYBbECwAA>
    <xmx:JiIiYjnr_WtejZ7tuFlxKzYT-Lpwal5SndpiBRVWO_8m1-JPoXLH0Q>
    <xmx:JiIiYpf55OOf3rbqytIPo4xQtS4SJ6UhiNnpDfFL_sHGev5yisz45A>
    <xmx:JyIiYmES6l-MuAH030JMSuAW09JHHFg0PcZDL9AVLl9Ct1XcaMlSWA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Mar 2022 09:28:54 -0500 (EST)
Date:   Fri, 4 Mar 2022 15:28:52 +0100
From:   Greg KH <greg@kroah.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Ali Haider <ali.haider@ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] swiotlb: fix info leak with DMA_FROM_DEVICE
Message-ID: <YiIiJGVmQgqne22R@kroah.com>
References: <20220304135859.3521513-1-pasic@linux.ibm.com>
 <20220304135859.3521513-3-pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304135859.3521513-3-pasic@linux.ibm.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 04, 2022 at 02:58:59PM +0100, Halil Pasic wrote:
> The problem I'm addressing was discovered by the LTP test covering
> cve-2018-1000204.
> 
> A short description of what happens follows:
> 1) The test case issues a command code 00 (TEST UNIT READY) via the SG_IO
>    interface with: dxfer_len == 524288, dxdfer_dir == SG_DXFER_FROM_DEV
>    and a corresponding dxferp. The peculiar thing about this is that TUR
>    is not reading from the device.
> 2) In sg_start_req() the invocation of blk_rq_map_user() effectively
>    bounces the user-space buffer. As if the device was to transfer into
>    it. Since commit a45b599ad808 ("scsi: sg: allocate with __GFP_ZERO in
>    sg_build_indirect()") we make sure this first bounce buffer is
>    allocated with GFP_ZERO.
> 3) For the rest of the story we keep ignoring that we have a TUR, so the
>    device won't touch the buffer we prepare as if the we had a
>    DMA_FROM_DEVICE type of situation. My setup uses a virtio-scsi device
>    and the  buffer allocated by SG is mapped by the function
>    virtqueue_add_split() which uses DMA_FROM_DEVICE for the "in" sgs (here
>    scatter-gather and not scsi generics). This mapping involves bouncing
>    via the swiotlb (we need swiotlb to do virtio in protected guest like
>    s390 Secure Execution, or AMD SEV).
> 4) When the SCSI TUR is done, we first copy back the content of the second
>    (that is swiotlb) bounce buffer (which most likely contains some
>    previous IO data), to the first bounce buffer, which contains all
>    zeros.  Then we copy back the content of the first bounce buffer to
>    the user-space buffer.
> 5) The test case detects that the buffer, which it zero-initialized,
>   ain't all zeros and fails.
> 
> This is an swiotlb problem, because the swiotlb should be transparent in
> a sense that it does not affect the outcome (if all other participants
> are well behaved), and without swiotlb we leak all zeros.  Even if
> swiotlb_tbl_map_single() zero-initialised the allocated slot(s) to avoid
> leaking stale data back to the caller later, when it comes to unmap or
> sync_for_cpu it still fundamentally cannot tell how much of the contents
> of the bounce slot have actually changed, therefore if the caller was
> expecting the device to do a partial write, the rest of the mapped
> buffer *will* be corrupted by bouncing the whole thing back again.
> 
> Copying the content of the original buffer into the swiotlb buffer is
> the only way I can think of to make swiotlb transparent in such
> scenarios. So let's do just that.
> 
> The extra bounce is expected to hurt the performance. For the cases
> where the extra bounce is not necessary we could get rid of it, if we
> were told by the client code, that it is not needed. Such optimisations
> are out of scope for this patch, and are likely to be a subject of some
> future work.
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Reported-by: Ali Haider <ali.haider@ibm.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  kernel/dma/swiotlb.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
