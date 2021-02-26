Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7AB32637F
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 14:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbhBZNq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 08:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhBZNq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 08:46:28 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46926C06174A
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 05:45:48 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id u14so8645031wri.3
        for <stable@vger.kernel.org>; Fri, 26 Feb 2021 05:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3o8PI97/pmH5gUIyy1yCJ9JJhjS0lOlwnNAt2sS3mtY=;
        b=N2RrOw8qQC/y23HcCQINU1brdy1piWrBoMGXTw4gIFP6C9xUskWtAMzjnUFog1WiHE
         bS642ClMKw7KEMNMS0phES3R90H/tWp2qzN3ht1uOKNamg/2SKHBfiywC4jqNr/XrzS5
         hlzYdsaeFOnXTTpTl2Izh4EaPFkx3gGxaNKDc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3o8PI97/pmH5gUIyy1yCJ9JJhjS0lOlwnNAt2sS3mtY=;
        b=fSE7JsUyMjpBxKUqpdXVPpjRbejRcGKUqhPzNvQk+eHGFeqK9WcLfbt7rPM8q9005f
         DXSzgtK73s3AlIQ3DnG5+GHZ38SUu14Lh1E5n9nOpZ9RYnydgrPJ6FkVupMvjJYAIZPk
         V+m0IsqIW2cDUuKQnBfRnfQHa5EjAjLCwH3k7GMYYSOd6Kl5Lq7DjSAJsi6BQtC/Mbi5
         bzZsbeUM85sRrTX7Ts10sZhIBbwUPkt5QAhtsIcCyCwwfXFgzcK8SxzD2PnYKVLeZn8i
         sInS/AkuKvAnTsBlaKIq6QP/uEaUHnZssBwhwPEGuNzFw9oCCIzR/Mp9NZsr+9w0Jb4L
         q07w==
X-Gm-Message-State: AOAM533r9G6gciTPeRvAdsySTdMqXGn9VWwnmOIcb6+ABKWPOMPESIPO
        JApM7OGZToJkwBPTpM0io1eQxvUDQj58Ow==
X-Google-Smtp-Source: ABdhPJySKPz73gO2bHinBihw6kNSB8EOYy5fJ4JmqzTuebQ2u7fzKxIKRgrubiheZdoAwKaVYlm2vw==
X-Received: by 2002:a5d:4fca:: with SMTP id h10mr3435679wrw.70.1614347147021;
        Fri, 26 Feb 2021 05:45:47 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id m24sm13077341wmc.18.2021.02.26.05.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 05:45:46 -0800 (PST)
Date:   Fri, 26 Feb 2021 14:45:44 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Maxime Ripard <maxime@cerno.tech>
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        stable@vger.kernel.org,
        syzbot+620cf21140fc7e772a5d@syzkaller.appspotmail.com
Subject: Re: [PATCH] drm/compat: Clear bounce structures
Message-ID: <YDj7iE4PNBRHx0fS@phenom.ffwll.local>
References: <20210222100643.400935-1-daniel.vetter@ffwll.ch>
 <20210225164911.k2bwswyivied36i5@gilmour>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225164911.k2bwswyivied36i5@gilmour>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 05:49:11PM +0100, Maxime Ripard wrote:
> On Mon, Feb 22, 2021 at 11:06:43AM +0100, Daniel Vetter wrote:
> > Some of them have gaps, or fields we don't clear. Native ioctl code
> > does full copies plus zero-extends on size mismatch, so nothing can
> > leak. But compat is more hand-rolled so need to be careful.
> > 
> > None of these matter for performance, so just memset.
> > 
> > Also I didn't fix up the CONFIG_DRM_LEGACY or CONFIG_DRM_AGP ioctl, those
> > are security holes anyway.
> > 
> > Reported-by: syzbot+620cf21140fc7e772a5d@syzkaller.appspotmail.com # vblank ioctl
> > Cc: syzbot+620cf21140fc7e772a5d@syzkaller.appspotmail.com
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
> 
> Acked-by: Maxime Ripard <mripard@kernel.org>

Merged to drm-misc-next, thanks for taking a look.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
