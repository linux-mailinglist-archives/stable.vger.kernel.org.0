Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 932B116586B
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 08:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgBTHb5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 02:31:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:53400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgBTHb4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 02:31:56 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C56CC24654;
        Thu, 20 Feb 2020 07:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582183916;
        bh=+ij1NUsmlyAfPgOtLIOjdSZDr9cf3FXoH36S6rZNd0k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UG34zOxUnVlmWZINh4RgGvTHzYaBhU8Z3O3jOQ+Hy4aXLJ5oS3l5eHRaBncezmSUG
         OXcM9dHe3ET7VA97BAnB1SmFLNKtBKRw0OjSx/puhZDJZOoA9e6MY/eNjCLK5OpPtD
         ZPrCbgWu7HiYIyL64hqi9z4yrdCE3zO/Y6EzXsWo=
Date:   Thu, 20 Feb 2020 08:31:54 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ajay Kaher <akaher@vmware.com>
Cc:     stable@vger.kernel.org, srivatsab@vmware.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com, srinidhir@vmware.com,
        bvikas@vmware.com, anishs@vmware.com, vsirnapalli@vmware.com,
        sharathg@vmware.com, srostedt@vmware.com,
        martin.petersen@oracle.com, hmadhani@marvell.com, mwilck@suse.com,
        allen.pais@oracle.com
Subject: Re: [PATCH v4.14.y] scsi: qla2xxx: fix a potential NULL pointer
 dereference
Message-ID: <20200220073154.GB3253157@kroah.com>
References: <1582172443-20029-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582172443-20029-1-git-send-email-akaher@vmware.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 20, 2020 at 09:50:41AM +0530, Ajay Kaher wrote:
> From: Allen Pais <allen.pais@oracle.com>
> 
> commit 35a79a63517981a8aea395497c548776347deda8 upstream
> 
> alloc_workqueue is not checked for errors and as a result a potential
> NULL dereference could occur.
> 
> Link: https://lore.kernel.org/r/1568824618-4366-1-git-send-email-allen.pais@oracle.com
> Signed-off-by: Allen Pais <allen.pais@oracle.com>
> Reviewed-by: Martin Wilck <mwilck@suse.com>
> Acked-by: Himanshu Madhani <hmadhani@marvell.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> [Ajay: Modified to apply on v4.14.y]
> Signed-off-by: Ajay Kaher <akaher@vmware.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 4 ++++
>  1 file changed, 4 insertions(+)

All 3 patches now queued up, thanks.

greg k-h
