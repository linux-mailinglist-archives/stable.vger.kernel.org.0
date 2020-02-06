Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B933154F54
	for <lists+stable@lfdr.de>; Fri,  7 Feb 2020 00:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgBFXYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 18:24:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:48958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726509AbgBFXYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 18:24:39 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B52D820838;
        Thu,  6 Feb 2020 23:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581031479;
        bh=1TY+4+yYPNl7lrsqJ6vECsrVGRKjpz0fusEz4KOCLbU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RnBO8l3uk7RSJc8RIjB3imwkfhMTSquI+2DrUGnahhM2rE9UalfhvFDIZcJHo7TVS
         2AWGAgIsQegsuJzqjtK9olXugbqEd07RJ8yOa8eDq+r6xT8HOt8Nm7Zf55KIIxOLDL
         NjXmIAntV+x1NYCDplwNs4TYgyxEk/EwJXWVH6Qo=
Date:   Thu, 6 Feb 2020 18:24:37 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     monakov.y@gmail.com, andrew.murray@arm.com,
        lorenzo.pieralisi@arm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] PCI: keystone: Fix link training retries
 initiation" failed to apply to 4.19-stable tree
Message-ID: <20200206232437.GP31482@sasha-vm>
References: <158101600590150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <158101600590150@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 06, 2020 at 08:06:45PM +0100, gregkh@linuxfoundation.org wrote:
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
>From 6df19872d881641e6394f93ef2938cffcbdae5bb Mon Sep 17 00:00:00 2001
>From: Yurii Monakov <monakov.y@gmail.com>
>Date: Tue, 17 Dec 2019 14:38:36 +0300
>Subject: [PATCH] PCI: keystone: Fix link training retries initiation
>
>ks_pcie_stop_link() function does not clear LTSSM_EN_VAL bit so
>link training was not triggered more than once after startup.
>In configurations where link can be unstable during early boot,
>for example, under low temperature, it will never be established.
>
>Fixes: 0c4ffcfe1fbc ("PCI: keystone: Add TI Keystone PCIe driver")
>Signed-off-by: Yurii Monakov <monakov.y@gmail.com>
>Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
>Acked-by: Andrew Murray <andrew.murray@arm.com>
>Cc: stable@vger.kernel.org

The code got moved around by b492aca35c98 ("PCI: keystone: Merge
pci-keystone-dw.c and pci-keystone.c"). I've fixed it up and queued for
all branches.

-- 
Thanks,
Sasha
