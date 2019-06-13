Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 095CA44413
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730771AbfFMQeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:34:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730762AbfFMHvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 03:51:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB62E20851;
        Thu, 13 Jun 2019 07:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560412275;
        bh=07bkpKEzMR5J7jcewXkizrrcYdEWtLPi1MRpGfleZ6s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zxrTPABW1S+WfcBg2HM87A7hR+EswsuArXO1S7J5FhTJdewwfg7Zt19tGJPhUmevv
         /TS4VgSYlBqPR+jQo5XHwtByyu2WiITcz1hUekXHyNudmSAM7LExXbfUFRikeztr2j
         9tb/SIKDVIZdozTkJewVDLE/wCdQFKAa+7xoLtp8=
Date:   Thu, 13 Jun 2019 09:51:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Helen Koike <helen.koike@collabora.com>
Cc:     stable@vger.kernel.org, dri-devel@lists.freedesktop.org,
        kernel@collabora.com
Subject: Re: [PATCH v5] drm/vc4: fix fb references in async update
Message-ID: <20190613075112.GE19685@kroah.com>
References: <156007492924468@kroah.com>
 <20190610131859.7616-1-helen.koike@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610131859.7616-1-helen.koike@collabora.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 10:18:59AM -0300, Helen Koike wrote:
> commit c16b85559dcfb5a348cc085a7b4c75ed49b05e2c upstream.
> 
> Async update callbacks are expected to set the old_fb in the new_state
> so prepare/cleanup framebuffers are balanced.
> 
> Calling drm_atomic_set_fb_for_plane() (which gets a reference of the new
> fb and put the old fb) is not required, as it's taken care by
> drm_mode_cursor_universal() when calling drm_atomic_helper_update_plane().
> 
> Cc: <stable@vger.kernel.org> # v4.19+
> Fixes: 539c320bfa97 ("drm/vc4: update cursors asynchronously through atomic")
> Suggested-by: Boris Brezillon <boris.brezillon@collabora.com>
> Signed-off-by: Helen Koike <helen.koike@collabora.com>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
> Link: https://patchwork.freedesktop.org/patch/msgid/20190603165610.24614-5-helen.koike@collabora.com
> ---
> 
> Hi,
> 
> This patch failed to apply on kernel stable v4.19, I'm re-sending it
> fixing the conflict.

Now applied, thanks.

greg k-h
