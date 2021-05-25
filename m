Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465F038F8E4
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 05:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhEYDjD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 23:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhEYDjC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 23:39:02 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF655C061574;
        Mon, 24 May 2021 20:37:33 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q6so16031568pjj.2;
        Mon, 24 May 2021 20:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VUffwK+7IC0tCDt0OY9O/6/zTgAkNujBMjziaP06FdE=;
        b=cg0epT+hZeES5tX6z7lJq+yVABgUSn+j9mzft6PnlkI3wrJarOlpE7o3tcP7uO/fa8
         lbAQoErQ7GDQCiN4tJvwrvUNht7Tw+/JqFOgUdXeiGsnbHYjIM5Kg3d1IgNwHJ/NSQpw
         L7hldJK+1wl11IUUqvqeQHEc/GTQJevR/5KubmB03SNV26UgOpTDX3GhnTAyeuEBuVxc
         4SCh6Ur1LM+mu8bEgfNIBWbw/RJUJeKiqFBwLAjc2MLpREYbYM1bNTofi5poCaxdGtGs
         7OwY4wSaCgBqilxIBt34wOdl131vy2a2iZ6Erg/2Gbex8jz3pGzDOEtdopmBy8K4f9Fi
         xNpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VUffwK+7IC0tCDt0OY9O/6/zTgAkNujBMjziaP06FdE=;
        b=UMbbptrcs+ejtjOqxsI32gqy+aZCJf6Zrefj3oONh6nq/01ojJEu4g8EETIyKDYygY
         iPrDHGPKFa2VJmo002CvCxjVb4J2GvsKketwNv9Tx4fpvRei8zQa0OoOtv6FLujJKIx2
         zcuROU9SAFUGD713rJOFxyJ4IQ/e17dDsuzlV9v65ASimtYgpWeJOj6BESIUCDWJf67b
         R4T38sYHOv4/ER+XVT61l4tzsoxMRG6BI1ojgbNmcI1Q22vUoDb5lyawFaYaQJl2qysd
         EgXDP6rY5c/2z39xHRG4KtHgYC16/zGADYG9HzwqWLL0hl5AixAe5DJhZOIQv1LTw6jE
         synw==
X-Gm-Message-State: AOAM533JkrWhlPEsVIzVMvgB5yS0qSgBvM1PHYVnAf6sIeR1TPXTBHum
        JVWDRDqefqCqjskhuGs9Uwgyf9ODk9w=
X-Google-Smtp-Source: ABdhPJxRtvUfWMfeS7YatzWSiPno9vBgJ+3pyfP4ZpT3l6IxmRLhJimzQfJG3x/hj+XP7ly33xT8GA==
X-Received: by 2002:a17:902:d2c5:b029:f1:c207:b0fd with SMTP id n5-20020a170902d2c5b02900f1c207b0fdmr27902437plc.45.1621913853192;
        Mon, 24 May 2021 20:37:33 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:870d:a395:9098:674])
        by smtp.gmail.com with ESMTPSA id g29sm12444988pgm.11.2021.05.24.20.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 20:37:32 -0700 (PDT)
Date:   Mon, 24 May 2021 20:37:29 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] Input: usbtouchscreen - fix control-request directions
Message-ID: <YKxw+cw4HnyzDjUt@google.com>
References: <20210524092048.4443-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524092048.4443-1-johan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 24, 2021 at 11:20:48AM +0200, Johan Hovold wrote:
> The direction of the pipe argument must match the request-type direction
> bit or control requests may fail depending on the host-controller-driver
> implementation.
> 
> Fix the four control requests which erroneously used usb_rcvctrlpipe().
> 
> Fixes: 1d3e20236d7a ("[PATCH] USB: usbtouchscreen: unified USB touchscreen driver")
> Fixes: 24ced062a296 ("usbtouchscreen: add support for DMC TSC-10/25 devices")
> Fixes: 9e3b25837a20 ("Input: usbtouchscreen - add support for e2i touchscreen controller")
> Cc: stable@vger.kernel.org      # 2.6.17
> Signed-off-by: Johan Hovold <johan@kernel.org>

Applied, thank you.

-- 
Dmitry
