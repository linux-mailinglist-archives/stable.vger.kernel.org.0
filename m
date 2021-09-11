Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 552AC407A46
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 21:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbhIKThd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 15:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbhIKThd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Sep 2021 15:37:33 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604DCC061574;
        Sat, 11 Sep 2021 12:36:20 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id w19so8179219oik.10;
        Sat, 11 Sep 2021 12:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J0TmxurvU12vKacM6byn7bxvcTwgo1ca9azhKSuYT64=;
        b=kmEOOx6z+kw/25CyoHvy5FrLkXj7lPR+vuUU0kOkz0HiUtwt46e67vIhFK7J/5hFxL
         M7cl03JZFKrkOIUiU0v+Ixk8geQMk5oY1C6yN907VkHNf1b7psnL4hQAQz16W3m0tqIN
         Cjku9mlxkI33wvn4ZBXYj5upNET5CJe+40X1x7sRiDgmqvQEXDOtS/ddN/DptHSXlFzg
         oFRDSUXSu6j1cQEtJstj9bQF7D8zBS5Lz3Lm+Yz5MjhCVX4Zz4B3iXCxyLiMvW9Tx34h
         hAT05CtW97qE0XdGfFOUt6uOK7uizZyfs3yJzpdxIYdUZJhYfnq2IxDo13K8q0BPnA69
         zNKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=J0TmxurvU12vKacM6byn7bxvcTwgo1ca9azhKSuYT64=;
        b=FwyimhspiaCj0FVUWHlKd+ahG8b62wuGT0Tb06lpe8cG4toeXqH566CG4iioz/Vdw9
         v3eUa5QX08z9w1tWq1dB76uWuvr1Rdrcz4cd5moSc0HsFn5WdyrNbPqyxs47wWswafXr
         LqhkHacS5gnK5OZiSM1z0lUD8wKtidPPptVM2vyr+/xmRQgSAbcZMUg8DYGoXSy77+Jt
         OqfMOL7a5HVnlx+ur3yk0bO0/rNf1ibpLaUpE8NUBDyq+rTjCFHTJIGXJdiT/Zu6S/Y2
         yLNgXFTbK3u0wEgfgnQqYAJ1BFVqRTnZiSZ7aiVsYkEWqFHCaKGL5fM1WdTWVapxFhPZ
         QLvw==
X-Gm-Message-State: AOAM5337Q8yQloh2THupJueDKakY46D3OOURga7yYtdzpmVZ3x02lOqS
        KOMWCbG51msnBe2cRmToIG0=
X-Google-Smtp-Source: ABdhPJzVV5HweKTRvGmqynl9ANeQOuI8mAPPTL24r4FKkDMlkVGmhaORnhdgXcGwQjwRT2eCzrApdw==
X-Received: by 2002:aca:6541:: with SMTP id j1mr2667172oiw.146.1631388979777;
        Sat, 11 Sep 2021 12:36:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a10sm583431oil.30.2021.09.11.12.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 12:36:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 11 Sep 2021 12:36:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 00/23] 5.14.3-rc1 review
Message-ID: <20210911193617.GA2502558@roeck-us.net>
References: <20210910122916.022815161@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210910122916.022815161@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 10, 2021 at 02:29:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.3 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 479 pass: 479 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
