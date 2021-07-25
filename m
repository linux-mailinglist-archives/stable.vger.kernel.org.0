Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2DF3D4F66
	for <lists+stable@lfdr.de>; Sun, 25 Jul 2021 20:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbhGYRdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 25 Jul 2021 13:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbhGYRdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 25 Jul 2021 13:33:24 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA79C061757
        for <stable@vger.kernel.org>; Sun, 25 Jul 2021 11:13:53 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id f13so4746082edq.13
        for <stable@vger.kernel.org>; Sun, 25 Jul 2021 11:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=oM2lzTp9j3drQuzTHcK/Ps3bqxt2G2TeVGPW5cTzHKA=;
        b=sUt287KHbpcl9x9MDFqXGN30XryRm0E6gN3JN2hnDevwIAZ9RhSheibMOT0TUYsdG+
         T+ojt1WwXimR75OS9A6NO3r9d3/oB+blZKCuuo1tPwWF0HeGBaIwGCzwAxIXwZoIWGux
         Ytq0/KWhw+9KtOcyd81vNOqz/yg+LFWG87vB91IauljlLWKn9s1ml5f1nvLkhn/tc5FD
         t0KGY07Wz3GTm6KiQPyRZBFNp69MY4KbQsRTbJDVh3XoQ2ynuPdfsEsmcL2WSXP0g4dC
         Bw//hQ8a1+IPDaLuiZbFOkvJbBaLddiKvWIcgVt9zaG1AjeEFUzv57ppFOhlXQ9j6HSP
         UZhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=oM2lzTp9j3drQuzTHcK/Ps3bqxt2G2TeVGPW5cTzHKA=;
        b=kfPCaTcvxw9VpGE8fUDTD8gCLIGPx8V3YlE7iydv0XDHmu9tOM0H/bwOU8jMIwpbvq
         V7fZc0tX0LhlNYbXPdIh1rlig4gNye5YpVpIPBTwzIRtFSRz/kspJQNadrtpuMb9Sarp
         4A7zbAoy18FEJFtQE/XSgqgnZWDhNTJGwptWLK8Nd0lID1sSx4W0GWoWpO+VSD1OiaiB
         eymZhkUTfjuq/47aLdjYCO7OYJBiLsXawL9uF86Mdim1o9fxGkRFep9+5hI4VNpY873S
         1QunCIv9KJWR1c/yKYEi1fkKVgp/v+yQ9x6YRShhD2x1sgixpVGlCjEHItgwcmm0VnfT
         j0zg==
X-Gm-Message-State: AOAM530O0ZQ+3QqnUG8VtO3xW935JKzXorc1pfDT337r8KOAwrnGZZH4
        ujWfZFZeomvcthZBOzRFkrEc9sH4WQW6GA==
X-Google-Smtp-Source: ABdhPJybxZmoOrNwQKx/fsCrBpvUmlp87d52Odyg/sc1MhMlb6QPFe1WoJH9HQgx+2F1SYM65xWKxg==
X-Received: by 2002:a05:6402:221c:: with SMTP id cq28mr17491833edb.115.1627236831688;
        Sun, 25 Jul 2021 11:13:51 -0700 (PDT)
Received: from ?IPv6:fd01:5ca1:ab1e:8889:6c7d:3a89:a33e:a797? ([2a09:bac0:20::82c:3b97])
        by smtp.gmail.com with ESMTPSA id y6sm17797812edv.88.2021.07.25.11.13.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Jul 2021 11:13:51 -0700 (PDT)
To:     stable@vger.kernel.org
From:   syphyr <syphyr@gmail.com>
Subject: Additional CVE-2021-3491 commit for 5.10 LTS
Message-ID: <fe4dad2e-c4b9-1a62-ea61-e0364b5300dc@gmail.com>
Date:   Sun, 25 Jul 2021 20:13:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I would like to mention that there is an additional commit required for 
CVE-2021-3491 on 5.10 LTS.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.14-rc2&id=d238692b4b9f2c36e35af4c6e6f6da36184aeb3e


Best Regards

