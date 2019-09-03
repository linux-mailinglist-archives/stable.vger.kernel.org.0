Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD450A764B
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 23:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfICVfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 17:35:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:55004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbfICVfG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 17:35:06 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7422621883;
        Tue,  3 Sep 2019 21:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567546505;
        bh=JJMYpLi7hOgf/PeMnToxVctQhByHIieaCYReoMqHmR4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GBxdBjGsTm3RacGmLkn0433nszitc/PKuwJ6hBHVeJrH/VjT98X4XrMZxymliETLO
         473vNhcgFLF4AfVQKOjSI7N/i7wbb8Vnlsi0qo8La+V+/k81Q20qnaYOQHjLuV8Ivk
         4gxkae+0OI8Fi2A02NlhFWuz2MZ2qJvcUHZYyPsw=
Date:   Tue, 3 Sep 2019 17:35:04 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     manasi.d.navare@intel.com, jani.nikula@intel.com,
        jani.nikula@linux.intel.com, maarten.lankhorst@linux.intel.com,
        stable@vger.kernel.org, ville.syrjala@linux.intel.com
Subject: Re: FAILED: patch "[PATCH] drm/i915/dp: Fix DSC enable code to use
 cpu_transcoder" failed to apply to 5.2-stable tree
Message-ID: <20190903213504.GT5281@sasha-vm>
References: <156753739120970@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <156753739120970@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 09:03:12PM +0200, gregkh@linuxfoundation.org wrote:
>The patch below does not apply to the 5.2-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.

drivers/gpu/drm/i915/intel_vdsc.c was renamed to
drivers/gpu/drm/i915/display/intel_vdsc.c; I've fixed it up and queued
it for 5.2, it's not needed on older kernels.

--
Thanks,
Sasha
