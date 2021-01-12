Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4BD2F3DA3
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 01:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406904AbhALVhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 16:37:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437158AbhALV1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 16:27:47 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4C35C061786
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 13:27:06 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id m6so2201415pfk.1
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 13:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=nV2YxyA4/ZIpjZwyrSDwm5mpymMjhPOxNLI8P7K98eM=;
        b=L4wcvs3U+l6ec/onFLltF83UeZscGeIt7cSa4y0uB5Wt9D+X9mFDmrdJy1Cx79WdQI
         5wVWvgpwaUwU8cegx3ESIarSjvG/N9XLYKYwFHH+c++VLkgePPw7m4XfMBvH8abJ63e6
         hR2Rw0nyvzY/STWrlfMpN0k5GzveOqoXv9cOsoLESUkkt0vfeOCRT7OUBoENeNvK1RTQ
         l1MC0e3Kz7lxhTRF8/WjbHhJTbtvt8ZDE/xZZvaWOEigpafQ8eWpuBEfv+J/XJ0L3RAL
         TDgnIqEUdU57Zt9fpU71t9PfR3koP3iUPknN0eyqtM7912V8j6+ZTplf+2/+UFVu0D+O
         CNAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=nV2YxyA4/ZIpjZwyrSDwm5mpymMjhPOxNLI8P7K98eM=;
        b=Gp0yxVqUXiUnYb9p7U14lXN0rJwrC0EucO4Ky9kb1akCFmO8uEywmHa6xhNnJ6aOvu
         WzBXSlpjp5Tbxv772TqdBtld4dw2qokA+l8u3EPNoDpSlwBsMaWnnA97pF9FnSJJjbkd
         s5FThm8aJa8ZJLczCpE/MDdhORLHiWBqgn545wUkYtPRv/NhD9siiI6NRjIFP4YGL5c6
         Jo6v3qrow5L+veCAWH31gMEQi7dymwMEb/Jdj7dG5Hr0kZWE4fypS3E0g0HHUdLDa3C3
         vWSe/UK3N+tKMzH1U97sJJ07jAGJKjM21GHG8gbLp9F8KAj7wKbie0FqV6yfUJx6fYTC
         9+CA==
X-Gm-Message-State: AOAM530llQhZ20l861d8grgNipxCpM3zw1XLqg4tTZAJYZG/kzGPGPhN
        q1+cUz3xJhYLBoFifnbYWB/ITSCO8WYaww==
X-Google-Smtp-Source: ABdhPJwXCCJM7o31BN5jjHciWAv3d8GWo+HfC1pdnfUgaEbw+pNhIiyMX/XunCC4zXJJwBSOlHCmEA==
X-Received: by 2002:a63:e101:: with SMTP id z1mr1047578pgh.190.1610486826114;
        Tue, 12 Jan 2021 13:27:06 -0800 (PST)
Received: from Shannons-MacBook-Pro.local ([50.53.47.17])
        by smtp.gmail.com with ESMTPSA id e29sm21885pfj.174.2021.01.12.13.27.04
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 13:27:05 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     stable@vger.kernel.org
Subject: [PATCH] Request backport of ionic driver patch for 5.10 stable
Message-ID: <3ebd98b2-e680-13c4-2e42-0a6ebafc243b@pensando.io>
Date:   Tue, 12 Jan 2021 13:27:03 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply upstream commit 8f56bc4dc101 ("ionic: start queues before 
announcing link up") to 5.10.

When initially discussed, the implied race condition was still 
theoretical.  Since then, a case has been found to generate the race 
issue and cause a failure to bring up the netdev interface by having the 
device in a bond and the bond driver trying to bring up the device on 
the netif_carrier_on() notification but before the queues have been started.

This should be applied to 5.10 stable.

Thanks,
sln

