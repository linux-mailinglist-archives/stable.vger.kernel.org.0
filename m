Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D416DD9C5E
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 23:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfJPVSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:18:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:37228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726402AbfJPVSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:18:50 -0400
Received: from localhost (li1825-44.members.linode.com [172.104.248.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20B51218DE;
        Wed, 16 Oct 2019 21:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571260728;
        bh=2ZkYigbPmOBvqZ5JnJ5BhPc5jPT2ECcnWPn3I3f68OM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gsFxFKGe6xzc1f0w2xI+IgIeacK52kyPHhCExYIw7E+9Txhss/vR8nabyQPlnRKFH
         Og+uKU4wTgGl9uHbb/0wj5FRe7lxFwTYtud+D+rIjIEBTQTiMQrNC+l4UTMB0G4riA
         MlmE7CP7sO2c8+mDqcDhjkh5V9oKYNSG/qKeo7So=
Date:   Wed, 16 Oct 2019 14:18:43 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Helge Deller <deller@gmx.de>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] parisc/pci: Switch LBA PCI bus from Hard Fail to Soft
 Fail mode
Message-ID: <20191016211843.GC856391@kroah.com>
References: <20191014192901.GA13704@ls3530.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014192901.GA13704@ls3530.fritz.box>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 09:29:01PM +0200, Helge Deller wrote:
> Dear stable kernel maintainers,
> 
> can you please add the patch below into all stable kernels up until (and
> including) kernel 4.16 ?
> 
> It's upstream patch b845f66f78bf which was merged in kernel 4.17.
> 

It's already there, it was released in the following kernel releases:
	3.18.111 4.4.134 4.9.104 4.14.45 4.16.13 4.17


So are you sure it is still needed?

thanks,

greg k-h
