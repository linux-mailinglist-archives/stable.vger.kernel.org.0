Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCC8F5BFAC
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 17:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfGAPXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 11:23:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbfGAPXb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jul 2019 11:23:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A20920659;
        Mon,  1 Jul 2019 15:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561994610;
        bh=yYKjmCA6SZYbCBcp8t3OKmdmXNrvdT2kdtCPdlLtOZE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iTsNz2wUiFXkNhva7M6RSNzzHlWeczT8Xwyls3he+6Agv7XcpEIzCvYkcqKQjoZ3E
         6g/iB/qe/K8hQrwKZ/KUD2zeUDdVG8a4xVLeXYgjMAPni/2q/6c/NIj7TFTQ7uvYxb
         D15HDbzJbV8/59tJZ2LbFFkE0WhgoBZ23+sq8CLM=
Date:   Mon, 1 Jul 2019 17:23:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Cc:     stable@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Miklos Szeredi <mszeredi@redhat.com>, akaher@vmware.com,
        srinidhir@vmware.com, bvikas@vmware.com, amakhalov@vmware.com,
        srivatsab@vmware.com
Subject: Re: [4.4.y PATCH 1/4] ovl: modify ovl_permission() to do checks on
 two inodes
Message-ID: <20190701152327.GC28557@kroah.com>
References: <156174751125.35226.7600381640894671668.stgit@srivatsa-ubuntu>
 <156174754838.35226.13171581960350534112.stgit@srivatsa-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156174754838.35226.13171581960350534112.stgit@srivatsa-ubuntu>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 28, 2019 at 11:45:58AM -0700, Srivatsa S. Bhat wrote:
> From: Vivek Goyal <vgoyal@redhat.com>
> 
> commit c0ca3d70e8d3cf81e2255a217f7ca402f5ed0862 upstream.
> 
> Right now ovl_permission() calls __inode_permission(realinode), to do
> permission checks on real inode and no checks are done on overlay inode.
> 
> Modify it to do checks both on overlay inode as well as underlying inode.
> Checks on overlay inode will be done with the creds of calling task while
> checks on underlying inode will be done with the creds of mounter.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> [ Srivatsa: 4.4.y backport:
>   - Skipped the hunk modifying non-existent function ovl_get_acl()
>   - Adjusted the error path
>   - Included linux/cred.h to get prototype for revert_creds() ]
> Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>

Applied, thanks.

greg k-h
