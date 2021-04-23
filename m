Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1021369B00
	for <lists+stable@lfdr.de>; Fri, 23 Apr 2021 21:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231337AbhDWTph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 15:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhDWTph (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 15:45:37 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75463C061574
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 12:45:00 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id h4so40415794wrt.12
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 12:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pjUorXDiL5Af3RoEDmQRwxYw4TrsmikRBnTHD9IsPfY=;
        b=frowzpoR3KyiakiWRZnqP91goc3wi7EQuF493d4TOAATu6m1vWti6il7FGlvBuIIdH
         UI774/Fxr07McoWv9+LQmlBekZWxZqMsLrRl4SC20u8IYroZiAFZ4Xw2V6y+o82faNKb
         VWrRKb2tn7uL4hGgg1AflR11N06gmx0ADejpvez7NbfnyQDbnw4KmaGEs1hSE0vhN8Cb
         4ppt5l4rKSzBHWbrQYVgy6cXo8vSm7REZIZb+Ly4MPBBTrezRoqPO98LmuSC0t4Q1mnA
         aYTkgkABZXc/0UiOS/npMK9tzjiy4c7YwJtYEAZ7yUe95YrjkW8sJI1c7tj/M5B/Nd9L
         P88g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pjUorXDiL5Af3RoEDmQRwxYw4TrsmikRBnTHD9IsPfY=;
        b=g6nRf5yg3PagYhIZcKHK00Lzs95EUnoy420Uh3fgTe9CeEx0vhUp7sR2o87gw3JRuQ
         mKwXVxaiHyO7ICxxPh7t0VRuugHdBoH9MZKcjp1NLaBgz5eDU1KpANpHzr6Ls3rV0yGf
         95QE243kI6lgaKWbC8tqiNNYfgGGKVFQDF9K/O6yDxM/f1UY7U8/tyO3a+aTv5YJN08Z
         n8gXzXX3RBrfTQAGcZ+4bG3y50dDrEzX91eeh1cGxqpYAlvUMR9OZYQAM1ukfibOgBIm
         ocFelmbwRl4FZp/3rB3iXW6Qi2NLpLJucydP6wlTjRpzXGTTleCpYebs8M2xbvXnnKjp
         xgXA==
X-Gm-Message-State: AOAM533s9z52h3iB9mJeljwl+1EoA4PQkLF5CfIqZg+/0iIXYh0kmcNn
        C+hbV/qa7PSXBNwZn/xLLnqX2edYcvwzNQ==
X-Google-Smtp-Source: ABdhPJwJUdfxVMUOhAXp/wdOQ+PH6IdHekCh/l8GrLlbs2h44HW/zKjR1MU8KcDtTWFVja1P37IqBA==
X-Received: by 2002:adf:e809:: with SMTP id o9mr6710709wrm.25.1619207099222;
        Fri, 23 Apr 2021 12:44:59 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id b12sm11359724wrn.18.2021.04.23.12.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Apr 2021 12:44:58 -0700 (PDT)
Date:   Fri, 23 Apr 2021 20:44:57 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     skhan@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] usbip: vudc synchronize sysfs code paths"
 failed to apply to 4.14-stable tree
Message-ID: <YIMjud72SYv5t5tt@debian>
References: <161812561233164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161812561233164@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Sun, Apr 11, 2021 at 09:20:12AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From bd8b82042269a95db48074b8bb400678dbac1815 Mon Sep 17 00:00:00 2001

Just wondering if you have missed this one as I am not seeing it in your
queue for 4.14-stable but can see in 4.9-stable queue. And this will apply
directly on top of your 4.14-stable queue.


--
Regards
Sudip
