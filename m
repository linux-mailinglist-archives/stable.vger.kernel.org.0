Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABE2C49A0
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 10:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfJBIgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 04:36:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726063AbfJBIgk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Oct 2019 04:36:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 450E5206C0;
        Wed,  2 Oct 2019 08:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570005399;
        bh=VFLFSHajzI2XLLn4FHsTaAlDTg/W3cYVMp1YuwmvH+E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NU1Ix/Kmiz0krydxGjDuB0292uZb9C/dOsf9acv0fu1756Hd3IBh+PhWnpmUalpe/
         XubQulKwgX/z9RyzfjUfu23qPcERhitR771kDKeWbaWB76ZsRM7P+tHa0JhMSpuGgn
         /VHIR1Hao1kR4zq3naP8EpA+dKkq2LXEuo+q7zJI=
Date:   Wed, 2 Oct 2019 10:36:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Michal Suchanek <msuchanek@suse.de>
Cc:     alsa-devel@alsa-project.org, Vinod Koul <vkoul@kernel.org>,
        Sanyog Kale <sanyog.r.kale@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] soundwire: depend on ACPI
Message-ID: <20191002083637.GA1687317@kroah.com>
References: <20191002081717.GA4015@kitsune.suse.cz>
 <459d62805e8cb20e27667626e80d962569e7e83a.1570005196.git.msuchanek@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <459d62805e8cb20e27667626e80d962569e7e83a.1570005196.git.msuchanek@suse.de>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 02, 2019 at 10:33:29AM +0200, Michal Suchanek wrote:
> The device cannot be probed on !ACPI and gives this warning:
> 
> drivers/soundwire/slave.c:16:12: warning: ‘sdw_slave_add’ defined but
> not used [-Wunused-function]
>  static int sdw_slave_add(struct sdw_bus *bus,
>             ^~~~~~~~~~~~~
> 
> Fixes: 7c3cd189b86d ("soundwire: Add Master registration")
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> ---
>  drivers/soundwire/Kconfig | 1 +
>  1 file changed, 1 insertion(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
