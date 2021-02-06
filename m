Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765E4311D2C
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 13:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhBFMsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 07:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhBFMsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Feb 2021 07:48:19 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D11C06174A;
        Sat,  6 Feb 2021 04:47:38 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id f19so10532437ljn.5;
        Sat, 06 Feb 2021 04:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/z7HFF3L/qI3FvkGB7cDrmovm/gwu9it6WOSqPW1Scg=;
        b=rpVOK/Rd+ASx3prdTxZHrUJZejSp7hH4U8F7NpDj9T5UkUTPfSAASfTEOxSvGSCoY4
         HAU8U6PIh5eBMnpifru+4ktXo6U8dhLr4UntJQ+Ty8GyA5Ce3Ftxb+rvAetptvq4EDIn
         8AOGuBQL81nhWUHgmGLt1LnIKeQ2FlQRd0OIRvYnIzqOXgr/j2M+fbrqgXZf6KkBwidZ
         ctYs4eMAXL7yN6Ey08jKnrbsjr22NoxCy8H04JrgYTRb75C8MIm62RMViPdm/tW4w/MS
         RS5dxTOqm+ZSFNyGgSuQdx+xF4ihXBlXqan6m3EqBziSfQ2sg9TtNvpw+Bt+N5qS8gJa
         D9Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/z7HFF3L/qI3FvkGB7cDrmovm/gwu9it6WOSqPW1Scg=;
        b=b2v8p+CSIVypT/g9kyqO+YfX7cgWx/gOFismGz/gQHM6XvqnA7RFRD8+IOINPM1zkC
         7fMsrmeboHtT+SggAt31aQnZ4k8M21nUWLWc3TSqsuZ0dADq8me/mYFDp+uhJ7SdueZq
         eBaPifsZdsl6YO77EAsxepEAOx2Fx7i7Z6r5Ben7NJJ163SDLM9M5B4INFlaHiEGSpDE
         dFAH1WjS5sbVN4zvdR32qY16+bi7pyQH+g1htM3izjdKLOehTel5/83SP24bthwVTg5c
         QUrHhLx/lR3DJ+lj19kMF/sjdPqBRCGrjFE4PhbZzm5F5if7aemZzpC+WvAPtHrGBHMp
         b5hg==
X-Gm-Message-State: AOAM531yLlc8YKHxTIj/o+ILf/2BjQ4Ze8m8ZCnhXIMjLKKyDROF3oST
        ZvraDoNyZ39yDmdBPJw9HPo=
X-Google-Smtp-Source: ABdhPJyO0e3Ypvqx5DBPT8VEOqHxfnsDG3RyNFOa/SOLmE4YPmAafx82BiTBU3OQjif04/Fyljtz4g==
X-Received: by 2002:a2e:580b:: with SMTP id m11mr5605637ljb.426.1612615655093;
        Sat, 06 Feb 2021 04:47:35 -0800 (PST)
Received: from grain.localdomain ([5.18.103.226])
        by smtp.gmail.com with ESMTPSA id q63sm1300622ljq.35.2021.02.06.04.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Feb 2021 04:47:33 -0800 (PST)
Received: by grain.localdomain (Postfix, from userid 1000)
        id 5F21056011E; Sat,  6 Feb 2021 15:47:32 +0300 (MSK)
Date:   Sat, 6 Feb 2021 15:47:32 +0300
From:   Cyrill Gorcunov <gorcunov@gmail.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Lucas Stach <l.stach@pengutronix.de>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        stable@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH v3] kcmp: Support selection of SYS_kcmp without
 CHECKPOINT_RESTORE
Message-ID: <20210206124732.GK2172@grain>
References: <20210205163752.11932-1-chris@chris-wilson.co.uk>
 <20210205220012.1983-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205220012.1983-1-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.14.6 (2020-07-11)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 05, 2021 at 10:00:12PM +0000, Chris Wilson wrote:
> Userspace has discovered the functionality offered by SYS_kcmp and has
> started to depend upon it. In particular, Mesa uses SYS_kcmp for
> os_same_file_description() in order to identify when two fd (e.g. device
> or dmabuf) point to the same struct file. Since they depend on it for
> core functionality, lift SYS_kcmp out of the non-default
> CONFIG_CHECKPOINT_RESTORE into the selectable syscall category.
> 
...
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
