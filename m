Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D36EEA762C
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 23:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfICV3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 17:29:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:51990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbfICV3m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 17:29:42 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97C10230F2;
        Tue,  3 Sep 2019 21:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567546181;
        bh=GTtkR9D5ZRel4ZlvKEFxvV68t2JAXRqjYF68rCsRI4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YUFs6ctIiXIeu2gd8WAth7ybJw8V/x2E99/Ed4TVq80ba6iLPRgp1jwrPVwe4Vwxf
         +k3ZtsEsoJRRvLkW1Kp0/q4IeBuMOcrgUBjWZhvgEm8qDcXRJSinJDVbg/yQdJczu2
         Lz0F4DjNISDbO6lSSXwcWH7ga0rdcVKsKshtokFI=
Date:   Tue, 3 Sep 2019 17:29:40 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     ville.syrjala@linux.intel.com, daniel.vetter@ffwll.ch,
        jani.nikula@intel.com, jose.souza@intel.com, lyude@redhat.com,
        sean@poorly.run, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] drm/i915: Do not create a new max_bpc
 prop for MST connectors" failed to apply to 5.2-stable tree
Message-ID: <20190903212940.GS5281@sasha-vm>
References: <156753737870202@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <156753737870202@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 09:02:58PM +0200, gregkh@linuxfoundation.org wrote:
>The patch below does not apply to the 5.2-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.

drivers/gpu/drm/i915/intel_dp_mst.c was renamed to
drivers/gpu/drm/i915/display/intel_dp_mst.c; I've fixed it up and queued
it for 5.2, it's not needed on older kernels.

--
Thanks,
Sasha
