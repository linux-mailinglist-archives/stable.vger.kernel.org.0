Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3CED73AC
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 12:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbfJOKpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 06:45:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbfJOKpc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Oct 2019 06:45:32 -0400
Received: from localhost (unknown [171.76.96.211])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D741F2086A;
        Tue, 15 Oct 2019 10:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571136331;
        bh=77WBH2h9bRchd3kaucl/YpLXYB2oYx+m7W/9F0lJXvk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PyUD/4NOrGSzWLXzapptVHYY7NBEA/f14KabnbZdQCl9yYXhRHHK5fNn6TQ+lYLco
         9UMGzrfIREaj2fHCHC1soEe6LP/nWEmlZczRND4gokDE9nCh9CH4xT4tAqati0PFls
         VGB5xQ5P4mYFXr3JVBie0/AXxoUNqMnz7fA9uHMo=
Date:   Tue, 15 Oct 2019 16:15:27 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Michal Suchanek <msuchanek@suse.de>
Cc:     alsa-devel@alsa-project.org, Sanyog Kale <sanyog.r.kale@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] soundwire: depend on ACPI
Message-ID: <20191015104527.GX2654@vkoul-mobl>
References: <20191002081717.GA4015@kitsune.suse.cz>
 <bd685232ea511251eeb9554172f1524eabf9a46e.1570097621.git.msuchanek@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bd685232ea511251eeb9554172f1524eabf9a46e.1570097621.git.msuchanek@suse.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03-10-19, 12:13, Michal Suchanek wrote:
> The device cannot be probed on !ACPI and gives this warning:
> 
> drivers/soundwire/slave.c:16:12: warning: ‘sdw_slave_add’ defined but
> not used [-Wunused-function]
>  static int sdw_slave_add(struct sdw_bus *bus,

Applied both, thanks
-- 
~Vinod
