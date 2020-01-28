Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 560AE14B550
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 14:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbgA1NrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 08:47:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:38306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725852AbgA1NrY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 08:47:24 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BCDF24683;
        Tue, 28 Jan 2020 13:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580219244;
        bh=Nd3bvd7+ISafKgxlCTfToaLEfldXF5HHdK8vm67svx4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t6alKUqQoSfgZQSRcJrTRCFffFrOofbz6JXhT5Mrh4U8vMd13C3/6Z0wT1wo5qYsz
         YAenHH+058BDaGQOVIQbDREPm19NMMtl/sbdpBJUCTlB2mRtfU8N0avwwvCv9rdfTu
         HfDW/xFsK4Q0Ta6nEPS4tSB/UC+H1cHjKsy0wZnY=
Date:   Tue, 28 Jan 2020 15:47:21 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Doug Ledford <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Alexander Matushevsky <matua@amazon.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Leybovich, Yossi" <sleybo@amazon.com>
Subject: Re: [PATCH for-rc] Revert "RDMA/efa: Use API to get contiguous
 memory blocks aligned to device supported page size"
Message-ID: <20200128134721.GA3326@unreal>
References: <20200120141001.63544-1-galpress@amazon.com>
 <0557a917-b6ad-1be7-e46b-cbe08f2ee4d3@amazon.com>
 <20200121162436.GL51881@unreal>
 <47c20471-2251-b93b-053d-87880fa0edf5@amazon.com>
 <20200123142443.GN7018@unreal>
 <60d8c528-1088-df8d-76f0-4746acfcfc7a@amazon.com>
 <9DD61F30A802C4429A01CA4200E302A7C57244BB@fmsmsx123.amr.corp.intel.com>
 <20200124025221.GA16405@ziepe.ca>
 <def88bd8-357f-54b4-90f7-ee0ab382aa95@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <def88bd8-357f-54b4-90f7-ee0ab382aa95@amazon.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 28, 2020 at 02:32:19PM +0200, Gal Pressman wrote:
> On 24/01/2020 4:52, Jason Gunthorpe wrote:
> > On Fri, Jan 24, 2020 at 12:40:18AM +0000, Saleem, Shiraz wrote:
> >> It would be good to get the debug data to back this or prove it wrong.
> >> But if this is indeed what's happening, then ORing in the sgl->length for the
> >> first sge to restrict the page size might cut it. So something like,
> >
> > or'ing in the sgl length is a nonsense thing to do, the length has
> > nothing to do with the restriction, which is entirely based on IOVA
> > bits which can't be passed through.
>
> The weekend runs passed with Leon's proposed patch.
> Leon, can you please submit it so I can drop this revert?

I'll do it now, feel free to reply with your tags.

Thanks

>
> Thanks
