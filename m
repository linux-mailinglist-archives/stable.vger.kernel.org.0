Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E67B3D59F3
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 14:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbhGZMSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 08:18:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:51300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234072AbhGZMSf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 08:18:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 31E3160EB2;
        Mon, 26 Jul 2021 12:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627304344;
        bh=OHDlHNh2XkeadD8Md0oCbYDSJ1D1KnzbnWu1Ksxc2hw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iEGwLVIKDOpTH8ZxJJHHZhMLHp2V7PJ21U66Z/A3CuIax9FXwpni/DhSJiD5j4rvT
         0E4/s65Nk49KjaslhI0F2w1wLiHNa/Px0ROcrombAg24Bb6bYbUxKHc52AEgVf30dQ
         Nt9IGZzvcdv0gLD2nTbe2ApmQErXAU9UFQqCfTDI=
Date:   Mon, 26 Jul 2021 14:59:02 +0200
From:   "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>
To:     "Schmid, Carsten" <Carsten_Schmid@mentor.com>
Cc:     USB list <linux-usb@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH for 4.14] xhci: add xhci_get_virt_ep() helper
Message-ID: <YP6xlnOayqS+adpB@kroah.com>
References: <3c42fbd4599a4a3e8b065418592973d9@SVR-IES-MBX-03.mgc.mentorg.com>
 <YP6IzGT6gZNgudI6@kroah.com>
 <9eb2f4a413eb40609f91daf52436cc7b@SVR-IES-MBX-03.mgc.mentorg.com>
 <YP6LkanQfzipHdOR@kroah.com>
 <bfeab6efc5b84cf38aa1c5436d9ce18b@SVR-IES-MBX-03.mgc.mentorg.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bfeab6efc5b84cf38aa1c5436d9ce18b@SVR-IES-MBX-03.mgc.mentorg.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 26, 2021 at 12:22:00PM +0000, Schmid, Carsten wrote:
> Hi Greg,
> 
> >>
> >> May I attach the patches as a file, generated with "git format-patch" meanwhile?
> >> I fear that I'm not allowed to use "git send-mail".
> >
> > For backports for the stable tree, yes, I can handle attachments just fine, you are not the only company with that problem :)
> >
> please find the patches attached.
> 0001-xhci-add-xhci_get_virt_sp-helper.patch.4 for 4.14 and 4.19
> 0001-xhci-add-xhci_get_virt_sp-helper.patch.5 for 5.4 and 5.10
> 
> Applied and compiled, not tested.
> Added Cc: stable@vger.kernel.org in both patches.

Thanks for these, all now queued up.

greg k-h
