Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 125DE11F907
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 17:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbfLOQcs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 11:32:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfLOQcs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 11:32:48 -0500
Received: from localhost (unknown [73.61.17.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A5FC206D8;
        Sun, 15 Dec 2019 16:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576427567;
        bh=Ed+owUMEBOYtcL7SlrH+yY2TomHqgxCG5QCcvEzPZ4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mhbHvhn8MlfSpgQyAIuPBFp95dcYc9VmeoR8bJNyauxgaTKyxB+RSgAYLPCxCRUcb
         D0e3PY/t29TvIVL/UYn4n7EsMq0y0K7/Gb9cS2zzrr06cRhUDufEo+QX19Y1LyT6zK
         7gvVnQPgYAFL7BC6fKOtQDIqUGGAcZ3KFCQI64Sg=
Date:   Sun, 15 Dec 2019 11:32:40 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     qutran@marvell.com, emilne@redhat.com, hmadhani@marvell.com,
        martin.petersen@oracle.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] scsi: qla2xxx: Do command completion on
 abort timeout" failed to apply to 5.3-stable tree
Message-ID: <20191215163240.GD18043@sasha-vm>
References: <1576335855212105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1576335855212105@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 14, 2019 at 04:04:15PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.3-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From 71c80b75ce8f08c0978ce9a9816b81b5c3ce5e12 Mon Sep 17 00:00:00 2001
>From: Quinn Tran <qutran@marvell.com>
>Date: Tue, 5 Nov 2019 07:06:51 -0800
>Subject: [PATCH] scsi: qla2xxx: Do command completion on abort timeout
>
>On switch, fabric and mgt command timeout, driver send Abort to tell FW to
>return the original command.  If abort is timeout, then return both Abort
>and original command for cleanup.
>
>Fixes: 219d27d7147e0 ("scsi: qla2xxx: Fix race conditions in the code for aborting SCSI commands")
>Cc: stable@vger.kernel.org # 5.2
>Link: https://lore.kernel.org/r/20191105150657.8092-3-hmadhani@marvell.com
>Reviewed-by: Ewan D. Milne <emilne@redhat.com>
>Signed-off-by: Quinn Tran <qutran@marvell.com>
>Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
>Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

I took in this additional patch to resolve the conflict:

	0c6df59061b2 ("scsi: qla2xxx: Fix abort timeout race condition.")

-- 
Thanks,
Sasha
