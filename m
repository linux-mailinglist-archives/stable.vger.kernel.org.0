Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51513A2A75
	for <lists+stable@lfdr.de>; Fri, 30 Aug 2019 01:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbfH2XBb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 19:01:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727826AbfH2XBa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 19:01:30 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D2D220828;
        Thu, 29 Aug 2019 23:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567119689;
        bh=W9b8uz0feEaW6eZCGVA4xllacD7howC1goKBJQjIsP4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bSJ6EehHO0cOzJSIr27S1Lja+mZUxP500FnEZtxxAgXtdPYX6f/m17eD5+lda6brA
         YPZdc70TZBBcV2AmJtoXO5/c/Ds6ILtQM+spB9LQXswf+yQTXxIL3t7auVDhf7WLdA
         tSelT+jtK3910rMvMUNQ02HQ6j9R79g+fxFCiYJY=
Date:   Thu, 29 Aug 2019 19:01:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mathieu Poirier <mathieu.poirier@linaro.org>
Cc:     stable@vger.kernel.org, architt@codeaurora.org,
        a.hajda@samsung.com, Laurent.pinchart@ideasonboard.com,
        airlied@linux.ie, jsarha@ti.com, tomi.valkeinen@ti.com,
        vinholikatti@gmail.com, jejb@linux.vnet.ibm.com,
        martin.petersen@oracle.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [BACKPORT 4.19.y 1/3] drm/bridge: tfp410: fix memleak in
 get_modes()
Message-ID: <20190829230128.GP5281@sasha-vm>
References: <20190829200001.17092-1-mathieu.poirier@linaro.org>
 <20190829200001.17092-2-mathieu.poirier@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190829200001.17092-2-mathieu.poirier@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 29, 2019 at 01:59:59PM -0600, Mathieu Poirier wrote:
>From: Tomi Valkeinen <tomi.valkeinen@ti.com>
>
>commit c08f99c39083ab55a9c93b3e93cef48711294dad upstream
>
>We don't free the edid blob allocated by the call to drm_get_edid(),
>causing a memleak. Fix this by calling kfree(edid) at the end of the
>get_modes().
>
>Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
>Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>Link: https://patchwork.freedesktop.org/patch/msgid/20190610135739.6077-1-tomi.valkeinen@ti.com
>Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>

I've queued this one for 4.14-5.2, thanks!

--
Thanks,
Sasha
