Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADAD1559C5
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 15:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgBGOhr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Feb 2020 09:37:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:51152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbgBGOhr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Feb 2020 09:37:47 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DC4820720;
        Fri,  7 Feb 2020 14:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581086266;
        bh=IgNzPCCnPfGUXDEMokOy2rVbjVxw6khgXrJZTaYsVvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yTsU3sOLEHCxgrDRwmZMnssR+DOj347pROA2/FI3ZY2IhIvKwsh9Ogh1ctxCDbrEQ
         b8PngUCOdvaVR3m/HUoRYxPKg/oBvHJGKB+Boi0KAnpYbUbzTNnW8yfsBLL+rPP8+W
         +JfQaeJ35V0qaTkIisObPLUeCy3Srt+To3s3AbKs=
Date:   Fri, 7 Feb 2020 09:37:45 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     qutran@marvell.com, hmadhani@marvell.com,
        martin.petersen@oracle.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] scsi: qla2xxx: Fix stuck login session
 using prli_pend_timer" failed to apply to 5.4-stable tree
Message-ID: <20200207143745.GU31482@sasha-vm>
References: <158106535523929@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158106535523929@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 07, 2020 at 09:49:15AM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 5.4-stable tree.
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
>From 8aaac2d7da873aebeba92c666f82c00bbd74aaf9 Mon Sep 17 00:00:00 2001
>From: Quinn Tran <qutran@marvell.com>
>Date: Tue, 17 Dec 2019 14:06:11 -0800
>Subject: [PATCH] scsi: qla2xxx: Fix stuck login session using prli_pend_timer
>
>Session is stuck if driver sees FW has received a PRLI. Driver allows FW to
>finish with processing of PRLI by checking back with FW at a later time to
>see if the PRLI has finished. Instead, driver failed to push forward after
>re-checking PRLI completion.
>
>Fixes: ce0ba496dccf ("scsi: qla2xxx: Fix stuck login session")
>Cc: stable@vger.kernel.org # 5.3
>Link: https://lore.kernel.org/r/20191217220617.28084-9-hmadhani@marvell.com
>Signed-off-by: Quinn Tran <qutran@marvell.com>
>Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
>Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

A few conflicts due to not having 84ed362ac40c ("scsi: qla2xxx: Dual
FCP-NVMe target port support") on 5.4. Fixed up and queued up for 5.4.

-- 
Thanks,
Sasha
