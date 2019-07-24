Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B91972E5B
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 14:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfGXMCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 08:02:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727483AbfGXMCf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 08:02:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F16D0229ED;
        Wed, 24 Jul 2019 12:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563969755;
        bh=WAa6k33s0E2+SMSXnvXkcTexH+mbCXUMX2PuAbNXo3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xdqmJ44IlqwDh705rwKW5xyV6kgJA78jvuSdu4FeIJZUsqsq4BL94Wb/qbgOadgeY
         5kqovXJOBA/OQSnVdpli0oGYlQh1ECqsBBpj646Bjz5ft8znwerlq2lu/NdLCKzLf2
         +YjyopMFh3wyA+KU4G2A5BlMVb6zsAp8bxIi9eco=
Date:   Wed, 24 Jul 2019 14:02:33 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: Re: FAILED: patch "[PATCH] PCI: hv: Fix a use-after-free bug in
 hv_eject_device_work()" failed to apply to 4.9-stable tree
Message-ID: <20190724120233.GC3244@kroah.com>
References: <1563883165157254@kroah.com>
 <PU1P153MB0169A3D78122369BE7320A96BFC60@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PU1P153MB0169A3D78122369BE7320A96BFC60@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 12:59:01AM +0000, Dexuan Cui wrote:
> > From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> > Sent: Tuesday, July 23, 2019 4:59 AM
> > To: Dexuan Cui <decui@microsoft.com>; lorenzo.pieralisi@arm.com; Michael
> > Kelley <mikelley@microsoft.com>
> > Cc: stable@vger.kernel.org
> > Subject: FAILED: patch "[PATCH] PCI: hv: Fix a use-after-free bug in
> > hv_eject_device_work()" failed to apply to 4.9-stable tree
> > 
> > 
> > The patch below does not apply to the 4.9-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From 4df591b20b80cb77920953812d894db259d85bd7 Mon Sep 17 00:00:00
> > 2001
> > From: Dexuan Cui <decui@microsoft.com>
> > Date: Fri, 21 Jun 2019 23:45:23 +0000
> > Subject: [PATCH] PCI: hv: Fix a use-after-free bug in hv_eject_device_work()
> 
> Hi,
> To apply this patch to v4.9.186, we need to cherry-pick another patch first:
> e74d2ebdda33 ("PCI: hv: Delete the device earlier from hbus->children for hot-remove")
> 
> Then I backported this commit (4df591b20)
> 
> Please see the two attachments for the two patches.
> They can be cleanly applied to v4.9.186.

Now queued up, thanks.

greg k-h
