Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 845C9AD94F
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 14:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728703AbfIIMpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 08:45:07 -0400
Received: from mail-lj1-f177.google.com ([209.85.208.177]:36308 "EHLO
        mail-lj1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfIIMpH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 08:45:07 -0400
Received: by mail-lj1-f177.google.com with SMTP id l20so12595492ljj.3
        for <stable@vger.kernel.org>; Mon, 09 Sep 2019 05:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=XZNU9mYm+eA3iubpUKCBjLPxCWOCN99H94H5Z96yb+c=;
        b=NWhyNH6OabvIz4lctQbmreCqzgzmH2Xa7CaDocgi/tonXDYHk80PSyfhhYpKu6EPLG
         mxB79qkb8zpLjQzxTPijpm6U5xjzJDQnNxGhFJnmDfMiuqcFu/4QCX6IztYek69O90hy
         lLx3c5ohXqkL/mm4g2hK2DhXxTmEi6TN7HQcVbgLvE5Sx+78Nelgo8f7Xj0yQCZsJ4Oc
         /S0AcSJySMsEoDITjm8vkMPUyftNde8L1Gj53WtW6ca0oXO3L6JlxhNwwLFebmU9GX3t
         nlJ6UYP/+Dbt2jyachGKB1Kqx1Ic3VbVT1j63TnBrob4Qf2SWrY8V4gZyYfp+mumgdSa
         exxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=XZNU9mYm+eA3iubpUKCBjLPxCWOCN99H94H5Z96yb+c=;
        b=lv2AhJFPSd0+4j8WzCfd196hhVoBTl265NcGi61z9DeBOOyUjR807sSjtRPwDoOLMs
         BNSGVfDLdWQ8M7fpW2/u4LVmw4Fr8y8KNXd4Sq8/dqBby/QoEpglBaDnFDUVpZoC48U9
         VsfT0ggXwEObhXLaiCpCF2R75eRoJZ1pTacv5td2xW+bKIsWJ4so69h9uiMm6iYq1Qvj
         V1tmjBgzC9Uyv3fmvOOlkzG8yyYMQ8EpE0KJk+XR1FtonNBTuDqgXflelsbCy3QAykNi
         0ZdSRL62H9qLmTjexC1DUYTjqAguSXMS34+I5+OVwdbDWKMK/RvZwfwnrtInYs1Hqsw8
         m5RA==
X-Gm-Message-State: APjAAAV2ClquUZ20PvmqGqyPJq9EZYm42QqvkRg2Ggb1gGMgL3HSFzVA
        uh14ULjpBbzVmDP6kuwYs4GjYtApc2c=
X-Google-Smtp-Source: APXvYqyThmC0MpAEFB4INR+SFYVizkkvnw5Zhg8d4DXEDYZWY8IUKCOBIQDSY6UCpYiSySQFc8NiYQ==
X-Received: by 2002:a2e:3102:: with SMTP id x2mr7498528ljx.218.1568033104962;
        Mon, 09 Sep 2019 05:45:04 -0700 (PDT)
Received: from centauri (ua-84-219-138-247.bbcust.telenor.se. [84.219.138.247])
        by smtp.gmail.com with ESMTPSA id r11sm2904021ljh.23.2019.09.09.05.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2019 05:45:04 -0700 (PDT)
Date:   Mon, 9 Sep 2019 14:45:01 +0200
From:   Niklas Cassel <niklas.cassel@linaro.org>
To:     stable@vger.kernel.org
Cc:     will.deacon@arm.com
Subject: stable backport request, add cortex-a cpus to whitelist
Message-ID: <20190909124501.GA14378@centauri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

I would like to request
2a355ec25729 ("arm64: kpti: Whitelist Cortex-A CPUs that don't implement the CSV3 field")

to be backported to 4.19 stable.

These CPUs are not susceptible to Meltdown, so enabling the mitigations
for Meltdown (kpti) should be redundant, especially since we know that
it can have a huge performance penalty for certain workloads.

kpti will still be automatically enabled if KASLR is enabled.


Kind regards,
Niklas
