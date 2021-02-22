Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0FB321482
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 11:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhBVKxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 05:53:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230125AbhBVKxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 05:53:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E78F664E04;
        Mon, 22 Feb 2021 10:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613991141;
        bh=LrtHvzq+DdbQz/cOxtxmCtLfPzUVuoZnEDVC6Sm3JRk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iLL4nPRKDz8KSb4tmtGtpCeov+V3eI1EF5Q0+Qj+I1MEGkyPNIPjn3K/Lj73h7zGQ
         tP9uDukJLQww6s2rk0NoceOenuf4RMBzi4XuT1D9RjYn8p88kH8KMYFjKqHOcRaSWs
         aziuikqx3hCQ1EeUQQMrmjWoR/ZsPY7L9ZWFrn2Q=
Date:   Mon, 22 Feb 2021 11:52:18 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     aeasi@marvell.com, himanshu.madhani@oracle.com,
        martin.petersen@oracle.com, njavali@marvell.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] scsi: qla2xxx: Fix crash during driver
 load on big endian" failed to apply to 4.19-stable tree
Message-ID: <YDOM4oX3bA8FXLPq@kroah.com>
References: <160915383115474@kroah.com>
 <YC14MEZz+sssmM5A@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YC14MEZz+sssmM5A@debian>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 17, 2021 at 08:10:24PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Mon, Dec 28, 2020 at 12:10:31PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> Here is the backport, will apply to all branches till 4.4-stable.

Now applied, thanks!

greg k-h
