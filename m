Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29F53421CA3
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 04:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbhJECmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 22:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbhJECmP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 22:42:15 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5FCC061745;
        Mon,  4 Oct 2021 19:40:26 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id n64so24302114oih.2;
        Mon, 04 Oct 2021 19:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0BJ0P2Yg9ZT4yuVtYgihYwzsYivfk2NjvAbY5QjvY4k=;
        b=Rth9H0FRuchUS8EDAPPgtXacEKSRom1euDALfXAzUBpK4I02TbozYWIDN/iW3o0NKt
         yxFwqqOXvDDafawl4o0Uiw9pyxpns6bApqQpJ7Z8HrD8f+qHbFqSRY6RL8f/+Y/2+EIl
         fNixSZK/o5HLv6pDoDSiFJGiM5ES4EET6uuof8kmmCz3wSfyGxzx6oOUCouxX2PqcXP8
         ADYuWdn98PRY6eb3dx45vPSIlVwKTlTSeHdLeMiTAVvjiTbVTyInWijv3/snfcut2LE+
         ldPzx+yb7sR9kWVVrRQm1r21IzGPQnIHT98pgnvwUxz3+kvhKd0YIFatoCy1eSriRTzq
         I8XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=0BJ0P2Yg9ZT4yuVtYgihYwzsYivfk2NjvAbY5QjvY4k=;
        b=fQK6EvE90bQA9Cf3oWboGCt2jb/OxXT8qwrzHDE6o62DX0dEo2jlQWPApZQOPC8jMm
         EObZgBuXn7c38/Shl63XIyQ1goAUqYRdwznNFRG44geY6MRV3CWAGhCR20EqDEgma5Cf
         EVPrTRhYk7XYm9L3v2/3kBZViFiuZK1wV46jIcIjGcPfGUr7/2KNH2a9hh0gyFe1zgOq
         QGagncCHSfIW1u9Zxs7rkc0DzMB2rdYduP/GA/fIhU4Vpm+E0BGxTde0V0C64c8n6bvf
         8N2V7DEf9EnSzWTZAsRbbn67zqvmYpm1BmbgVDHnIDBe99R7vJlbODk6FLdWn32dlMcL
         CDDA==
X-Gm-Message-State: AOAM5323WgiXAgY2f0DEXrzu/HJJoRBlIRsjmfJdNNl/JG8Z5INm1JzM
        KOP9rKev3/AirvkyJH2PqCY=
X-Google-Smtp-Source: ABdhPJxBNSdz6Fm49nPid4J3uIhC9vjzvFsvQp43aGWW2astsmjpAcXBBFW6rJBFY8Ef69nH/zwxZg==
X-Received: by 2002:a05:6808:243:: with SMTP id m3mr504915oie.54.1633401625504;
        Mon, 04 Oct 2021 19:40:25 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x4sm3310910otq.25.2021.10.04.19.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 19:40:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 4 Oct 2021 19:40:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/93] 5.10.71-rc1 review
Message-ID: <20211005024023.GA1391345@roeck-us.net>
References: <20211004125034.579439135@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 04, 2021 at 02:51:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.71 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
