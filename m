Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 395BB11F8F2
	for <lists+stable@lfdr.de>; Sun, 15 Dec 2019 17:25:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726136AbfLOQZB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Dec 2019 11:25:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:44890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfLOQZB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Dec 2019 11:25:01 -0500
Received: from localhost (unknown [73.61.17.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17A1F206D8;
        Sun, 15 Dec 2019 16:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576427101;
        bh=oGkkMXvFf4iangj1PeSie8pXGjMkopETTk35LDUqi0E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dZY49NCcfCapJd/2p04nN0hWrf2WG8Nptq9u0CvHnCa4qNxbrPFWLLQmznf0I3x/X
         Ik8Q7omIfJBbxyaIELUIB0EAeiwtNMSIM50pP+ZQaiukAFj4TFR/TwIh4If23C3vAi
         1HZxWtdk1LrbPO1HylwF0YAe09AFa/2enTkH+8hM=
Date:   Sun, 15 Dec 2019 11:24:58 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     maier@linux.ibm.com, bblock@linux.ibm.com,
        martin.petersen@oracle.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] scsi: zfcp: trace channel log even for
 FCP command responses" failed to apply to 4.19-stable tree
Message-ID: <20191215162457.GC18043@sasha-vm>
References: <157633580122434@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <157633580122434@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 14, 2019 at 04:03:21PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
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
>From 100843f176109af94600e500da0428e21030ca7f Mon Sep 17 00:00:00 2001
>From: Steffen Maier <maier@linux.ibm.com>
>Date: Fri, 25 Oct 2019 18:12:53 +0200
>Subject: [PATCH] scsi: zfcp: trace channel log even for FCP command responses
>
>While v2.6.26 commit b75db73159cc ("[SCSI] zfcp: Add qtcb dump to hba debug
>trace") is right that we don't want to flood the (payload) trace ring
>buffer, we don't trace successful FCP command responses by default.  So we
>can include the channel log for problem determination with failed responses
>of any FSF request type.
>
>Fixes: b75db73159cc ("[SCSI] zfcp: Add qtcb dump to hba debug trace")
>Fixes: a54ca0f62f95 ("[SCSI] zfcp: Redesign of the debug tracing for HBA records.")
>Cc: <stable@vger.kernel.org> #2.6.38+
>Link: https://lore.kernel.org/r/e37597b5c4ae123aaa85fd86c23a9f71e994e4a9.1572018132.git.bblock@linux.ibm.com
>Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
>Signed-off-by: Steffen Maier <maier@linux.ibm.com>
>Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
>Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Conflicts due to:

	f9eca0227600 ("scsi: zfcp: drop duplicate fsf_command from zfcp_fsf_req which is also in QTCB header")

I've adjusted it to address the missing commit and queued it for
4.19-4.4.

-- 
Thanks,
Sasha
