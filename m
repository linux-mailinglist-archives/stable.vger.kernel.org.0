Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFDC4CD988
	for <lists+stable@lfdr.de>; Fri,  4 Mar 2022 17:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbiCDQ4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Mar 2022 11:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbiCDQ4f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Mar 2022 11:56:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894A21C4B10;
        Fri,  4 Mar 2022 08:55:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 340C5B82A8B;
        Fri,  4 Mar 2022 16:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1876C340E9;
        Fri,  4 Mar 2022 16:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646412944;
        bh=B+UV2G70h7lvv+8DpIMYl/VkQqHKKqEhFln4Go7FLAs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yrtl1+N2serLhyYw9ro0Lc+ScqdI+QhjwGsZ0Xcn8nioqaibMGTcmY1W15X8iYB1F
         qAxiCwOm2XWiux8ofFHdnD0uHKn8HsMYLNsBVOnRmslIyO7dFoMT2jypzsNiaDbhAq
         9eFsm7WD16wtZniLKMPz3NP/VREUDo22CgO2S7xA=
Date:   Fri, 4 Mar 2022 17:55:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
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
Subject: Re: [PATCH 1/2] Revert "swiotlb: fix info leak with DMA_FROM_DEVICE"
Message-ID: <YiJEjLdpXoGxtJsO@kroah.com>
References: <20220304135859.3521513-1-pasic@linux.ibm.com>
 <20220304135859.3521513-2-pasic@linux.ibm.com>
 <YiIiHD7uA1o7Sj1X@kroah.com>
 <20220304173447.27dc0798.pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304173447.27dc0798.pasic@linux.ibm.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 04, 2022 at 05:34:47PM +0100, Halil Pasic wrote:
> On Fri, 4 Mar 2022 15:28:44 +0100
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > On Fri, Mar 04, 2022 at 02:58:58PM +0100, Halil Pasic wrote:
> > > This reverts commit ddbd89deb7d32b1fbb879f48d68fda1a8ac58e8e.  
> > 
> > Why???
> 
> TLDR; We got v4 merged instead of v7

That makes no sense at all to me, you need to describe it in detail.

You know better than this :(

thanks,

greg k-h
