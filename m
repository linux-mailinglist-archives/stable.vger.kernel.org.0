Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21E9E37FF5A
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 22:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhEMUio (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 16:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbhEMUin (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 16:38:43 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FD4C061574
        for <stable@vger.kernel.org>; Thu, 13 May 2021 13:37:32 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id i67so26828105qkc.4
        for <stable@vger.kernel.org>; Thu, 13 May 2021 13:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=+gs3WryVIcnk/9Ztb3PMr4k2Lcgv/Gr10erEfgpAOQA=;
        b=onKSRT4pz6pxm1BZwrg4mSLqxnGPv3ck8BL5eo6YAUWqIPnuu0TeXlOLVDf/8H8qkc
         nw6aF94eTCIKNTtpJUNOyoNpLZ3LeUOC9zk2XR//ZhSWAOpE5QdvfXWQNhVEc4piddaP
         8GRetxdZUOCE2R1L25vbH0lrpk+xKUcmlbQ3wiv33mZVOv5D0I5BSs7ltMjwUJZa5l5E
         02QKA24gaNrHMGyc4+BWfXQ/P/cwdZhFiiBimcnUAS5HVMTG6oexm6LkFLGluHz7esjA
         J/tSXVQmcLmU19QjLrju5yxwy2Bb13PwWCUP4ILGiyOog1nm/pPM2/ybbDonl6F9oQEr
         oYwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:from:subject:message-id:date
         :user-agent:mime-version:content-transfer-encoding:content-language;
        bh=+gs3WryVIcnk/9Ztb3PMr4k2Lcgv/Gr10erEfgpAOQA=;
        b=Xn71dHcKei4fcv4BTBrZUite1OVCp9lm9j5nzFzb3sLqrDtODSD8OX51AH1R4zbpsR
         r9XbTaVYQEOquG1R0hOi4VLvl6LBKn0Emo12ePxRT6me9vC+H/giIiKm3FGHZVHfwbga
         FxTXBA7ze5CM/2jAODke3XQRD5yCIok6PjlBKF73M3xkOmTiccCcksXn793q9mApcNOI
         Dvq8LPNS8EUEdiar2NqExQ9aj+yGe7lFlNzV0b5gS4N4flFwlaQNp9p+Jf59LeTvdVz4
         sI3jmqvkgUJwoVz0ec8iVItpo1/c4DDP520zsoBDNWty6eDRzZaPSQS9uu2j/fOp6NKe
         GeYQ==
X-Gm-Message-State: AOAM530CvDD24hDN05ZJmgky6h7hcZpAMu8Fu7+lW2lN2bxbI2cLnIvE
        D3Z3O2W7uLKxQUVvlmtRJ0WDg+5+GxU=
X-Google-Smtp-Source: ABdhPJxVy8BHDQYgqf7LtHdiRW6WkNvcsQKSTDW9IHjNhzNwyDSywXA/biZ8Wlrf0cdSnEh21USIAA==
X-Received: by 2002:a05:620a:2456:: with SMTP id h22mr39366519qkn.292.1620938251521;
        Thu, 13 May 2021 13:37:31 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t139sm3327728qka.85.2021.05.13.13.37.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 May 2021 13:37:31 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Build failures in v4.19.y.queue
Message-ID: <d2f28d84-424d-6f8e-973f-88f5975eafdd@roeck-us.net>
Date:   Thu, 13 May 2021 13:37:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Build results:
     total: 155 pass: 153 fail: 2
Failed builds:
     arm:allmodconfig
     arm:axm55xx_defconfig
Qemu test results:
     total: 424 pass: 423 fail: 1
Failed tests:
mipsel:mips32r6-generic:malta_32r6_defconfig:nocd:smp:net,pcnet:ide:rootfs

Failures are similar to the build failures in v5.4.y, plus:

drivers/crypto/omap-aes.c: In function 'omap_aes_hw_init':
drivers/crypto/omap-aes.c:110:8: error: implicit declaration of function 'pm_runtime_resume_and_get'

Guenter

