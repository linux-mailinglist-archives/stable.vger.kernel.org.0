Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB733ABE44
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 23:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhFQVla (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 17:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhFQVl3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 17:41:29 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD8AC061574;
        Thu, 17 Jun 2021 14:39:20 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 5-20020a9d01050000b02903c700c45721so7637119otu.6;
        Thu, 17 Jun 2021 14:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aKnw4pUvTVgie0obyKnCW5Ngc/nye2Qscued7SYZ7J0=;
        b=WjM8Y2qiuu/FewUdXRd1Zqr1w0jE1NI2LekAcWMbz0O4g6tepGg31KrFVdvcVsveBb
         Eh8lwlOFkfS9oakoaGbEMOE1fz0hLfCBAJzXkZ/G08jKeZUqE/JTJew9OyD8ARFvWA9u
         KDozf8NZdzq54VvRy2f5wnazcYjYSPdEnawGImYq42/bmS5uroyXIXOdVV2MOai4UTUH
         BgaVVDu70BPKRHRyxRfJGZ9IS6t6EjK1qyZOWpMfs86BzPnDyHnpI7N+sGxiB9BbEKqd
         rRx6seqcybcuiJZduYT6swh5a3GYj40j+n6mC3VlicHlsvnHqbgyi5IN2jSgkScyaw/7
         FhRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=aKnw4pUvTVgie0obyKnCW5Ngc/nye2Qscued7SYZ7J0=;
        b=GvQ70SnHHRwTyGPoY8K4U9UCROECIBhErDRMOEKQotF6iv7rP7YnGm+0SCAZAJmufl
         QxMPqLN0OLMnFvvOHGssdURpp/9/UzCT4eYvfYuy5YbCW0Eiae7JjcKb+7DV2aFimSZR
         O7sbG1qS/52ImNhWvIi7Zh7QxNlQ4JiQLrQb7piHv2yfHnZofRHAYxHPuGCZDhVF1DA1
         6r/J9JWklmNNXBVg9dem/YSDZ7zt/hTpxP5k/u/s8UMWfUB0brKRAGpglh/HWI03oqFF
         VoP6KOOptmpifOE+SyyD1r78OSnW52es3TZuh8tx5bB6lFznMMFMJ655du6h+KrQKsGZ
         qr9Q==
X-Gm-Message-State: AOAM532z7A/Xik5/AOjofqtv7c3jHEHyxXBGONWQcD//RtXLOytirEpz
        Lze8UZsAUBxA99GqPNYxvao=
X-Google-Smtp-Source: ABdhPJzde8AoPDQY68ey0MHo/K97pMSl9Fen7QrEhbw4f6XNishfr+M9clk3i/iRURjHmqouTTYfTw==
X-Received: by 2002:a9d:12a9:: with SMTP id g38mr6797616otg.114.1623965959723;
        Thu, 17 Jun 2021 14:39:19 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m10sm1398889oig.9.2021.06.17.14.39.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 14:39:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 17 Jun 2021 14:39:16 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/28] 5.4.127-rc1 review
Message-ID: <20210617213916.GA2244035@roeck-us.net>
References: <20210616152834.149064097@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616152834.149064097@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 05:33:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.127 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 18 Jun 2021 15:28:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 428 pass: 428 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
