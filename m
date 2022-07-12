Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC05570F39
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 03:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbiGLBLK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 21:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbiGLBLJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 21:11:09 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CE32C125;
        Mon, 11 Jul 2022 18:11:08 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id c15so1082980pla.6;
        Mon, 11 Jul 2022 18:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mK7hxLg5UKFL7t/H5O/qd6wHK0RsB8Iz9ru3iD5fvE4=;
        b=Bg0D5+/2uRnojIw5BvCRjFnwUxcuoZWZkzVCrEL/Dt4/FkZlSOLs9/OOeM5xCf2bnx
         KxKZK65i6gJGsRce5QabzLnjZTcAJ1S6aWxUPE0XpRQ3bJCTYx9sP/a24zOqaSUTDH7o
         Dm2f7Wv2pFvbPRpNqtx8WwsX8fkPcjdZ02l8/wi5Qq0y30+3LRLWgl5IY5IM5fRZkC9t
         oVdVJebgDvddVCf8xQ74jflIBgQxhG1BUSjgcC6LlAqaCgGWC38kps51+o/xU48LASJx
         LLicCxX/cRin6PumIOSgt9dfHEOMXxR+LCm+x1zmKMBEYsN312whA2i3BODHtK/5WB+J
         1GzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=mK7hxLg5UKFL7t/H5O/qd6wHK0RsB8Iz9ru3iD5fvE4=;
        b=VOZpiCNslj8YoRyITe/nvuqt1XZGvTB/sZmA4pCgUhKxjmz1qNYUtOljXZuCY4alZG
         YBxQ1IbtA1f0McDKOUgwWeiFHYH5w0GlydA3u8amNxkyrn7WY+H8dC8av/288jpxuZZZ
         U1SeO7jPCkEfeBn2hPHoSb3Rvz/V2ac1xK7DyDFgAyAsxNYQnaNSMiDaprkOhydRC9Ss
         a0bMah1Ku6K6XcknkEe2vZ+WTn+73turOXKrnWtQZRuS5eLCuDndV5MHoDh0EX2mqP0K
         rGxF6t3IOYeqNZZN5yHXBpTG12Zf4AUu3xJEmM+CdTr3dX2u1ANah/1xtiO3sNxpf//N
         6iZw==
X-Gm-Message-State: AJIora+VNxGj6qQwz/prHVHbDVhHrr6giKwc6QGMFkbqZ2XL8wqz9tCt
        hwyfBYOspFRF1Lw1g58sxQU=
X-Google-Smtp-Source: AGRyM1vEmrDt/ujVKHrsLs9FuZSlqND/wtzg/oBp8PE6LEZCt2azNgUkuJEQMf3ZY5F6f8qiUgO+qw==
X-Received: by 2002:a17:902:e84e:b0:16c:773:9daf with SMTP id t14-20020a170902e84e00b0016c07739dafmr21486215plg.43.1657588267739;
        Mon, 11 Jul 2022 18:11:07 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d5-20020a623605000000b0052ac725ea3esm3690924pfa.97.2022.07.11.18.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 18:11:06 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 11 Jul 2022 18:11:05 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/14] 4.9.323-rc1 review
Message-ID: <20220712011105.GA2305683@roeck-us.net>
References: <20220711090535.517697227@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711090535.517697227@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 11:06:19AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.323 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 164 pass: 164 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
