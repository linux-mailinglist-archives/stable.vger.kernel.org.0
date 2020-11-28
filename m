Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB2EC2C7431
	for <lists+stable@lfdr.de>; Sat, 28 Nov 2020 23:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732477AbgK1Vtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Nov 2020 16:49:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733300AbgK1SR6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Nov 2020 13:17:58 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D6B4C0254B2
        for <stable@vger.kernel.org>; Sat, 28 Nov 2020 08:58:27 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id o144so7361533ybg.7
        for <stable@vger.kernel.org>; Sat, 28 Nov 2020 08:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xfeAjglHO0NLw2NVtqz72xvaJx4Lg7+L6YQ31fkcxOw=;
        b=s2EuqHn6M95W8MLEkgtmW3k+HZ40bj4s3vnnNnSB5mI00jnzFnvMbWHBvU03br6WWv
         YRI+mgDxMAn8hSBIA7Tcn6kXl1MPAwBpGOUyesOzteIyz7zKFKSuIV0wmEyXALnVyyJq
         F+I/VnyzuKOwpJMDAj4lapMHjvdQZzITaBydGPKUV/xTbe2vlgA8aIo6mYiKVhwGCedv
         KQ7DFkkWBSDkL7sCzAkX4iTJkgMgf3bvyZpaG5vojCyhsH6kZDMkHzGLr7kagXy2I8Mv
         JM2T0siBsA9m3VsU4ItTTKBbSaF+wB2iMpWK+05oSo4vWUn2dmuU2vkIJp6VA49DRStY
         LoFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xfeAjglHO0NLw2NVtqz72xvaJx4Lg7+L6YQ31fkcxOw=;
        b=e/DKHr044NYP9ShRvJz7V7WsI6IRIasR03SLrDLxNfn0A0LOpbTYXazMZgyy2hlXks
         Y8FtDXbleFygdfQRerDq+gXlBVKmZD2GT1K/PTHPP3iASVWhzc+DHkMhJGrAI5rWrdF2
         NPlJQY089YKJESKvFwpaK4UkA3Fx5tAADk33DQ5yWaD1mcSIJbass+KPTjUEX8u4kFVw
         8pTPFMPykJoZL9D1/tYpAdHyfuNvQ37vzdI8npT0NRSZXo7wwyoHZpZUlr9UowESGrMb
         nS8aJDwZkFh1d2VOJNxliQwSAVA81W5WQyZK+xRMlbDsT5xYA/AA+qrp5kwMSukbq/a0
         CYng==
X-Gm-Message-State: AOAM530N08K8BFbxbEdUWpNMjts5CDyIXAVBawCeoU6MdSVCBWDWrc1v
        PJaj0lT4kg5Xjespgq0gycgAhTlRQPt3EqYZf9M=
X-Google-Smtp-Source: ABdhPJxRwaJa9JBKlPRhl5HK/6jArMKvzTID0Wj9KZUgqpJQdZRqsSTW1QFL8iKU1WWDpEZBhWa4qewUe67i/skva+0=
X-Received: by 2002:a25:209:: with SMTP id 9mr21929034ybc.127.1606582706762;
 Sat, 28 Nov 2020 08:58:26 -0800 (PST)
MIME-Version: 1.0
References: <1606575438136209@kroah.com> <2394419.nDFh2rNouh@n95hx1g2>
In-Reply-To: <2394419.nDFh2rNouh@n95hx1g2>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Sat, 28 Nov 2020 16:57:50 +0000
Message-ID: <CADVatmO2irK-zhsmxceyr0Ami-C16y+7e8BZxpnQibMWk3Y_yg@mail.gmail.com>
Subject: Re: Patch "i2c: imx: Fix reset of I2SR_IAL flag" has been added to
 the 5.4-stable tree
To:     Christian Eggers <ceggers@arri.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        u.kleine-koenig@pengutronix.de, wsa@kernel.org,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Christian,

On Sat, Nov 28, 2020 at 3:11 PM Christian Eggers <ceggers@arri.de> wrote:
>
> Hi Greg, hi Sudip, hi Wolfram,
>
> this patch is part of my series :
>
<snip>
>
> Although I am happy seeing my patch in the stable series, I think it should be
> applied to mainline first.

Stable trees can only take fixes which have been applied to the
mainline. This is in mainline since v5.9.

-- 
Regards
Sudip
