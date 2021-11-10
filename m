Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8BC44CB60
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 22:42:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbhKJVow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 16:44:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbhKJVov (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 16:44:51 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5FBC061766;
        Wed, 10 Nov 2021 13:42:03 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id gt5so2628316pjb.1;
        Wed, 10 Nov 2021 13:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=uhVvGvVYqwDOBxsemQ0lNiOOnNEqohtMc7/gkkEKXOw=;
        b=IVjXUim5EMcs+9U8v8Jo6Py5rDpxWl+8QlvBWL26fN607PbwRFowuVIQ2UDEhyuu7T
         PRhDa4gCrmvts3XJB3RGQ6egroFZuaoiMbIW1s4pO72lCO0ibzhvpS1n6gW1cOY5ed2V
         S0UJk5H4GIGgpXWGP1NsPpfKFmSXc2Ei9jApGfhNmgytG0GKGYhVbOXP7q4cRr4ceAs6
         PaZ2BRf9GQzLEeAsNI8GC/6hk/IZ3Jfm+CY9QET+/gRgSzqMwDT3Xjpar3YVIuTlNANO
         wN2YBNowuT4Zd6/trHnD9hkh2XzvoLgc+bCRTvyfgAKDxALQR0+0VeoeTllqIDtfA2iy
         0SvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=uhVvGvVYqwDOBxsemQ0lNiOOnNEqohtMc7/gkkEKXOw=;
        b=HqYunadE/FWzw0SHPE+ebvtTHbaoZJoEALIwAdW8Fgd9wISyneJOL0CsMadRwOuzI+
         Ls4KF2NkviDSMxFC3bTzoxqef12w5/Dy+ttjTuaQ5oH/w3dFcqS3SXW6+HhynLRtpzFT
         hNmEnZiLP4+tQulA3sHebNTd4K53cR8OpxmAqAAf362NwYmU3TSvu3mGI3FRXXd0en1W
         hRTX/6NORfLH+OLoae7sIwVIAEG0pZHHYQqe9VcA/2PsQCg/noRZC9CLW7zvjDkgPOs4
         zOQRePIDCX5VMeaeCSuluFv2vlW+Wfr8prZuOBkfXvnOP4JNjXg5BuW8YHsuSLZH32ka
         1gRA==
X-Gm-Message-State: AOAM531aC3/PT5wog7fkH8PaAmESS3b7DZv4ZsM3JejB9cstl6jMNOgg
        F1yAN9ehm7lWPgqml14XztWQsugloIo3eWBkhQ8=
X-Google-Smtp-Source: ABdhPJxoBypp4XYzqmcWEPh+xtID+iW20IrecAZmKu3RdENfsXg6KWDfWug5EnSmf0+Ec+dHQwcfqg==
X-Received: by 2002:a17:902:8695:b0:142:7171:abf5 with SMTP id g21-20020a170902869500b001427171abf5mr2593647plo.74.1636580522522;
        Wed, 10 Nov 2021 13:42:02 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id z30sm563709pfg.30.2021.11.10.13.42.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 13:42:01 -0800 (PST)
Message-ID: <618c3ca9.1c69fb81.71eb9.2869@mx.google.com>
Date:   Wed, 10 Nov 2021 13:42:01 -0800 (PST)
X-Google-Original-Date: Wed, 10 Nov 2021 21:42:00 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211110182002.964190708@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/21] 5.10.79-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 10 Nov 2021 19:43:46 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.79 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.79-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.79-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

