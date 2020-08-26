Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A23253982
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 23:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgHZVGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 17:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbgHZVGa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 17:06:30 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5EC3C061574;
        Wed, 26 Aug 2020 14:06:29 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id q1so1456367pjd.1;
        Wed, 26 Aug 2020 14:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=BNVvx026q+w3S50fDZO4SFY1mveXLMUajizgrhaD8KQ=;
        b=mcGogTOTXL0EQfUn4qrkiDJ1f6vcYVDd3HR1c0w0MfhBlcya/nkdxe0DqhfM2sCfB3
         zKc3zbMM8mGt6FzT7j8KtLPgxmt0NNuMWPJZpsgsPZFcM+L6FJGMIcBTIF+PpquIttMh
         ZCmgPrcAOUtVDdZULfWoeXuSpLC56VMNpIUY1gQlAeumhsTtj0fEY3NYdnBOhmYzVcCQ
         rl83rJEW3bJOKamwuKHJFhdZvyvF95XGYjXrFI6QQREbxamyGj0lBbJXJAoj3W3Fcgl3
         dDfgbA4vhAmgkN9Cv/dHodkGBOGR/iSxkTgA9sTrVLQr8F1WC0nnu/Zbxl49henHH9hT
         jiag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=BNVvx026q+w3S50fDZO4SFY1mveXLMUajizgrhaD8KQ=;
        b=qn4hRdpeqecCAXvFSyl0wo7lGCqZ0dULKqv94UCKpN7P7tJ3FmvLGNA11/zV2C+GR+
         Y/tdFxe4FtEW7AEMhaNpJ486dyEYW11bw0wgPOBtThJ/XnkdR56YxCXRznCgotg0gf62
         BvFmglZo6JKi0sOG6n5wN80nMSeWo8OCXGMO8zxjj4HM5mpJeJ98Vz/O/P330pfsqW5Y
         L/dAVTOwsaK+IjJlurvj/LiuCnA3UmvMJxCucM97o1Mh3MRWEqIn5inmwgPv2ISLZWo7
         NHeTwjyXq6v4LKu4cxfx5mH5m073+F0N5O6ApHe2jPQudSMzsCqaxqCvErbG0r9H89+6
         sBRg==
X-Gm-Message-State: AOAM531kMgqHkol+XUhceB4/R6bYNq+Wmj31rk2B11OvaEmL9SgubpsD
        2ezUlaBk/liUF/yXC5/sgTCXsvJoj/A=
X-Google-Smtp-Source: ABdhPJx8qMKzf+YUGkO9ycWzs15QYQEWlFfWtdsSQZwoixwMlBfLlynubJpb7Op32qbOOerq779IJw==
X-Received: by 2002:a17:90b:3543:: with SMTP id lt3mr7942701pjb.180.1598475989306;
        Wed, 26 Aug 2020 14:06:29 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 27sm3032823pgk.89.2020.08.26.14.06.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 26 Aug 2020 14:06:28 -0700 (PDT)
Date:   Wed, 26 Aug 2020 14:06:28 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Paul Burton <paul.burton@mips.com>,
        Huacai Chen <chenhc@lemote.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH 4.19 66/81] MIPS: Disable Loongson MMI instructions for
 kernel build
Message-ID: <20200826210628.GA173536@roeck-us.net>
References: <20191016214805.727399379@linuxfoundation.org>
 <20191016214845.344235056@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191016214845.344235056@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, Oct 16, 2019 at 02:51:17PM -0700, Greg Kroah-Hartman wrote:
> From: Paul Burton <paul.burton@mips.com>
> 
> commit 2f2b4fd674cadd8c6b40eb629e140a14db4068fd upstream.
> 
> GCC 9.x automatically enables support for Loongson MMI instructions when
> using some -march= flags, and then errors out when -msoft-float is
> specified with:
> 
>   cc1: error: ‘-mloongson-mmi’ must be used with ‘-mhard-float’
> 
> The kernel shouldn't be using these MMI instructions anyway, just as it
> doesn't use floating point instructions. Explicitly disable them in
> order to fix the build with GCC 9.x.
> 

I still see this problem when trying to compile fuloong2e_defconfig with
gcc 9.x or later. Reason seems to be that the patch was applied to
arch/mips/loongson64/Platform, but fuloong2e_defconfig uses
arch/mips/loongson2ef/Platform.

Am I missing something ?

Thanks,
Guenter
