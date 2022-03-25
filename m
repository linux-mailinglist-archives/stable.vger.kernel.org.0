Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030904E6FDE
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 10:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356156AbiCYJQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 05:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350066AbiCYJQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 05:16:04 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C58CF48C
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 02:14:30 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 5F2303200645;
        Fri, 25 Mar 2022 05:14:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 25 Mar 2022 05:14:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; bh=yLe9hcsgY3txbEpFliqOEDmdU1iT0Fsv2forD5
        OLtE4=; b=D65Vb5YdkYmOD9e4Iu+w3hjVoZEHtP3xRbX7HIU8UhAbIehpvEtIz8
        JLeWER6jpWcO9puRlIDX7XjCtYf+iD3X6Tzi/G2xoDg3DRchPYavY9gloNMXfS0F
        Tgpvh4IomY/hX2e+cOGHYZpAbKhh/dSoGc+6DbM+fL3UBfysojz25+jtI/Hbz5ES
        5m6sUaqKWbNZPWBJIxg326X4ZijFQFaPPFFJOzxxdVwkXGIvsg0BlxelMhza1ikc
        PYhakfD+Hguc3nZF+81yED+3Ge5JTOfUnpTVVLygwPackCp9pwVWGzvQc/HRlQAk
        GIyFDBO8dhkSG9W93Wg/QowB2PHWWT+Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=yLe9hcsgY3txbEpFl
        iqOEDmdU1iT0Fsv2forD5OLtE4=; b=WTHJbqrq3K4yu4R7sZrNHxhoFZGIkxO2S
        VG6juxSpDHUEKZsR6YnsWhR+c9l1C6SYKZlrr4XZz2fpJWnd/guIzaG5DcZPa8hB
        k7uoT6z++onkBi/dIyL9okOA7fFJFuEmdRwx/FRR7+u9YljFyUaoSa+t1IB5D2qO
        9eyKW+jbl9kAp7pgSk0kvLfIktVkZfo4dxk3ATzHvBzv/eLnjSJ7hjM0oLNsdGc0
        6qsQIuIH+4y1/eEyMUUSNYCcbJj6GUFqd0S7vB2ezugy2oc/uVYDLVtBwq1KXoSs
        UbODqVo6W7aF3nsJ3t3QVVq+gdtGJhVId7whZgTVq8qjeomOPh/Mw==
X-ME-Sender: <xms:8oc9YpYRpTzcSOiwpuCj8T7W6XVD-ES0fIjGff1dY8NfaNH61qZuNw>
    <xme:8oc9YgZdU7KdK2f2-YF2AOspwcN6ASy1zSzmps_1N-5Xv8HctT17Jggw9spPiCQhJ
    sR28pM3QJaVIQ>
X-ME-Received: <xmr:8oc9Yr9X-r9Ky3oYY1urBobKMAjsRnZYI_9adpgqSjCut4eijxTUa8qPghYaRHMtnEgXy4EnD4ZNY-qFwPWsz253pXFpSItg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudehuddgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:8oc9YnpiZHPpMbbuYSqVRTBLIHqC-5QC47ZX-UHqkH8uku93oRvUaA>
    <xmx:8oc9YkpO8yKvvuQQWRVn-aKG4vHl7rkr-zX-AbziwRFIAysQLqLWqA>
    <xmx:8oc9YtRtDVPtS6wKktCQfUuJ_3tcUgOGSpKh1OloO1bM-NgxStjLnw>
    <xmx:8oc9YvADZ0BRna3clcmszIOFr-aCEo64uIHhdUmKB_ejW7MqrtuVEA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 25 Mar 2022 05:14:25 -0400 (EDT)
Date:   Fri, 25 Mar 2022 10:14:23 +0100
From:   Greg KH <greg@kroah.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Doug Gilbert <dgilbert@interlog.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH for 5.4.y 0/2] backort of ddbd89deb7d3 and aa6f8dcbab47
Message-ID: <Yj2H7zd8tS1zy1eb@kroah.com>
References: <20220322124128.2232849-1-pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322124128.2232849-1-pasic@linux.ibm.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 22, 2022 at 01:41:26PM +0100, Halil Pasic wrote:
> This is a backport of ddbd89deb7d3 ("swiotlb: fix info leak with
> DMA_FROM_DEVICE") and aa6f8dcbab47 ("swiotlb: rework "fix info leak with
> DMA_FROM_DEVICE"") for 5.4.y.
> 
> I had to handle some merge conflicts, that at this point we have
> swiotlb_tbl_sync_single() as opposed to
> swiotlb_sync_single_for_device(), and also a file rename from
> Documentation/DMA-attributes.txt to
> Documentation/core-api/dma-attributes.rst. 
> 
> 
> Halil Pasic (2):
>   swiotlb: fix info leak with DMA_FROM_DEVICE
>   swiotlb: rework "fix info leak with DMA_FROM_DEVICE"
> 
>  kernel/dma/swiotlb.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
> 
> 
> base-commit: 7f44fdc1563d6bca95ee9fb4414e4b8286bccb0c
> -- 
> 2.32.0
> 

All now queued up, thanks!

greg k-h
