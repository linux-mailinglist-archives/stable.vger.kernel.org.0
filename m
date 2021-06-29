Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B6E3B77B9
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 20:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231856AbhF2SXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 14:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235041AbhF2SXK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 14:23:10 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB43FC061760;
        Tue, 29 Jun 2021 11:20:41 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id a5-20020a05683012c5b029046700014863so6816671otq.5;
        Tue, 29 Jun 2021 11:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KP0WiGGcvrGrFHsQLhEaO+Nn/32MYPYjJAnUPXg2lAA=;
        b=eQNgk5cqu3LPTuJCRroKaidXE/qVQQ1TZhZtSabU5icGnTM8xG1Gj/hX/Y98B6Bohu
         otEYdSz5iPFtWtopccv+XsClYkBuE9BzOMLE9JYTT2+rxbRn4DmXqRO6tEHX6Voi9TLa
         xziYEUU0szeZHA/QaF8qiCIxR/kkMrsQqhavR2Q6RrSHZJWo0lRbIv50gk2ebCI1CF9+
         SuKHpYhdjE2QZuZPKzXmfWLaI2ozInwU7VPCVfpzHx8Gq9s2mIpjmwO2GI0lhctaR+kj
         d7+Xtyddf22aPf0azdnpE/iMO5F6rfEYgMV0A5iHyQUNHZUNKX3qIVX5cBgSZ9jYasn1
         CBbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=KP0WiGGcvrGrFHsQLhEaO+Nn/32MYPYjJAnUPXg2lAA=;
        b=GbtOo4/FG90vhsxKk7DiiBeFcE3nc+4QceB7M1xBAKS1DzwN2oKdndLGjuWMKReh0z
         uJle8z15UOAIj3YZqiSdhvOmnaDQdsTgiA2s0y5D5TVPH8uXeTmxmIS6vDXZUM2Myby5
         PrqBVjUSkSMJJR01ocvNaL049dVzEYO3fyXtdHvyVcgD9hHweXQDqeY6kyCncbqTR782
         KNRZzJEenGbTr4KndDmDDvUTrY3hfBFyfsPU61P3RVz+3IS7JrKpspzeiaDIe4otJxcB
         oRk9cSTYAuwSgOAmGZas1HpvJ3P4O1JiubjRu2MUqf1Vtb1myOsY5HATrbXX8V7a9CfT
         NZyg==
X-Gm-Message-State: AOAM532x8CBVaa8bfMfdeU/T1H3W7W/+bqs4zaSQZxI8gAX4NmgybdmM
        QYu3G6M7C7k9h8SccnzLnPU=
X-Google-Smtp-Source: ABdhPJx2rneV4OBfDenl+hpBaK3lyZrnbpVOmsBrJBh/EVcPduYIlD5OBw6YWp/FqPIb2TrYQLWEAg==
X-Received: by 2002:a9d:644f:: with SMTP id m15mr5525972otl.99.1624990841338;
        Tue, 29 Jun 2021 11:20:41 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l2sm4435582otl.27.2021.06.29.11.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 11:20:40 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 29 Jun 2021 11:20:39 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.10 000/101] 5.10.47-rc1 review
Message-ID: <20210629182039.GF2842065@roeck-us.net>
References: <20210628142607.32218-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628142607.32218-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 10:24:26AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.10.47 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 30 Jun 2021 02:25:36 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
