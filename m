Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B531AFEEB
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 01:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgDSXkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Apr 2020 19:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgDSXkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Apr 2020 19:40:13 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0A3A20771;
        Sun, 19 Apr 2020 23:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587339613;
        bh=8HW96paTqUPga/ybcu0VQG2Ba66pP4d10K1wkYORe1c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sVBgZB5lsM5jjSEQwp7VYRhH7h57yQdK4/lS0qqxc8zv1K4Y1t9EeH0RWWoA1DN4z
         9i/LaNjg/T7bAAV39KU0z88lMD9hTN0TRSI1DIKjgyKvaTntkyjlN35EQrIch0PQeH
         lSBZ85RZQwhw3FWyLtcS3DOavyWUnQm6cA701JFM=
Date:   Sun, 19 Apr 2020 19:40:11 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Andrew Donnellan <ajd@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Alastair D'Silva <alastair@d-silva.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH AUTOSEL 5.5 73/75] ocxl: Add PCI hotplug dependency to
 Kconfig
Message-ID: <20200419234011.GF1809@sasha-vm>
References: <20200418140910.8280-1-sashal@kernel.org>
 <20200418140910.8280-73-sashal@kernel.org>
 <c2bceeb6-07bb-1cc4-0d67-48b9fe0f6ba9@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c2bceeb6-07bb-1cc4-0d67-48b9fe0f6ba9@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 20, 2020 at 02:32:19AM +1000, Andrew Donnellan wrote:
>On 19/4/20 12:09 am, Sasha Levin wrote:
>>From: Frederic Barrat <fbarrat@linux.ibm.com>
>>
>>[ Upstream commit 49ce94b8677c7d7a15c4d7cbbb9ff1cd8387827b ]
>>
>>The PCI hotplug framework is used to update the devices when a new
>>image is written to the FPGA.
>>
>>Reviewed-by: Alastair D'Silva <alastair@d-silva.org>
>>Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
>>Signed-off-by: Frederic Barrat <fbarrat@linux.ibm.com>
>>Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>>Link: https://lore.kernel.org/r/20191121134918.7155-12-fbarrat@linux.ibm.com
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>
>This shouldn't be backported to any of the stable trees.

I'll drop it, thanks!

-- 
Thanks,
Sasha
