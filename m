Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43BB1421423
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 18:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235704AbhJDQdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 12:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237096AbhJDQdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 12:33:19 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A2DC061745;
        Mon,  4 Oct 2021 09:31:30 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 75so17081000pga.3;
        Mon, 04 Oct 2021 09:31:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=leCByaBR4VwohltYHvd9zNi6Md2LWVW63j3JCb3RDPs=;
        b=YlBY3I/QWx/pwShjtYE3RIXLHVVQxsIv2ZeKHJXFvgMDlnDYu3tqLJq0rbanyIL0V3
         /4eCWjn4+9VhxVE31Rb19P1kEMprbtPFhlj3WQbiOHIOn2UBoqmEfl8uOVlRBKvPc2E+
         Ne9CC2CJzrsGEdUNRKCy7gI2NfwL68OBvVxYU7unQscTsBnuj5aq3+C1bQ7N0CSDzZTz
         cxBVDr/d43PXgXhscOOA1R2HrKdFys8jrcAxuYkIbR5RR3vOUUcU9YOqaYmMn309wUzi
         m9Mii7Wylt/d1FVPyS1lRB5jRR5I50m61CtPho2c/fw+qd5jf+z9EBR1SrJTVM4mrbYm
         e/CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=leCByaBR4VwohltYHvd9zNi6Md2LWVW63j3JCb3RDPs=;
        b=NSCxFepZ63N2BxeA724olBL+3wwbYQewqsyX+moRdUZ2NTH/XbTSCo/9P4o+hPOY21
         7gIBjOxSKwXFWt/UnbtKr4PsJ4+SANzmpr5fTZUzVBqxkgan7BQV1+GinWKIOzE9iUuA
         6TSiKeH+jKY46beoeJl56ZcTZRyRzxrZ6wvumABZ4DSILYIpD92AF7P9I7PYkXppt0iR
         +EcpI9Ym3X0ZaxSuJiRfHXpo/OJJWk3vCuAQWJjA/O5/WFTsi87mHGNP6d8rhbqNSGpq
         Jw+2st07fRTYRdmMFqSD6cEszijr5CUuS7oPRDDPZRIFoBXA/1R0Pch0OOR6sdSQXOzt
         aIKw==
X-Gm-Message-State: AOAM532KQegALor/iIHLVF2G3f9EmhXJTLDuDXgZ50yxeEkkzzSwOVhW
        7xJCfAd13H9pLe8TcdsaMq2QD/6xxkKlUIWNyUA=
X-Google-Smtp-Source: ABdhPJzPfSaDMqw/w+nJ7dBYmljJufseNyEiLC0xT0LPeQhZpbg07kxZmfDX4t7iTR4I9CrNGyAlFQ==
X-Received: by 2002:a62:15c6:0:b0:44c:74b7:14f5 with SMTP id 189-20020a6215c6000000b0044c74b714f5mr935093pfv.80.1633365089404;
        Mon, 04 Oct 2021 09:31:29 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id w5sm14350165pgp.79.2021.10.04.09.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 09:31:28 -0700 (PDT)
Message-ID: <615b2c60.1c69fb81.f491f.aa0f@mx.google.com>
Date:   Mon, 04 Oct 2021 09:31:28 -0700 (PDT)
X-Google-Original-Date: Mon, 04 Oct 2021 16:31:26 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/93] 5.10.71-rc1 review
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

On Mon,  4 Oct 2021 14:51:58 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.71 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.71-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.71-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

