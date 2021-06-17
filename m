Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFA53ABE4B
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 23:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhFQVm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 17:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhFQVmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 17:42:25 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7256BC061574;
        Thu, 17 Jun 2021 14:40:16 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id u11so8150061oiv.1;
        Thu, 17 Jun 2021 14:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J9haDVI45RQv6bo+4J4/qxgQ2B5XHiQgfLGBal42PDU=;
        b=B4BJ8ah8+7ra7jTjYDzj2RQdS0tWoGV3EAu7R+754m0HQk6slLgtGje2MPCT0NbGqo
         L3GEPJcUjAdLPZU0kFBlcfaya8HWnm9JFNHmosGRRDFs+BMZik6O1aa3K2sfoJT+hOFv
         lVfVLdRDT+rajs7B5NeyDJ9J+4BwgSWEQobQsi0FCSkKsoHJXopbGRJO5opki7TKYGfs
         9be/EL012MUQsTzRvEPKs+uRKDsMyI455HaN85LjP0pHakDVzRR272tWDKaecN4rBfNE
         epZTH1kmTjCvDD+1dQsyllOCPbAJ4kZth/sZNW73TD3dbqw2/uOEMBIbFSbaFcWdyrH5
         IaLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=J9haDVI45RQv6bo+4J4/qxgQ2B5XHiQgfLGBal42PDU=;
        b=SaKRN/8yV/x9znOtKc7Qh+ADNEQ65PoXPYqIY7H35u39Lm7KAUI/zU9OLvdaBfgYuH
         7wbtVKAqnGYM/cljm2CETbLzqwKIyfoaXBhJeXi5sSsOEK+N1xdndIWr/FswnxOO5gej
         PsRMwRBa9D99Eysw0FBSkQnS9iNEb4nHT9qAGxdrRm+T1y2aiGrH14X82djmOl+p2yvF
         0lxjVpBvP+oj3X/wwcSkBA0UtovBRw6vJrMT0RodV4QQuPjrVCCB4939VojYMqIyzmwW
         JGvRMEUeQrjXu2cSJrzX09/2L3wx0JjNJ9o1yG519FiEf9nMaGD3e7JikdeOXG3xado+
         zmXw==
X-Gm-Message-State: AOAM530Us33uxcPN0S24n/qVJ8Wb2OlcGFjOfQs0M2M/tfhTnJt/KyKD
        BFlNEEmm59b90i1Jcbq0wPs=
X-Google-Smtp-Source: ABdhPJz/f9R6dUUFPE7e4+Zl8ytGtWoi6B2BJcKC95DDFqJXPJNPxMXB+p+f0EbeGBtYPNeCHDWGnA==
X-Received: by 2002:aca:b484:: with SMTP id d126mr12246205oif.80.1623966015933;
        Thu, 17 Jun 2021 14:40:15 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f36sm1338045otf.12.2021.06.17.14.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 14:40:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 17 Jun 2021 14:40:14 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 00/48] 5.12.12-rc1 review
Message-ID: <20210617214014.GC2244035@roeck-us.net>
References: <20210616152836.655643420@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616152836.655643420@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 16, 2021 at 05:33:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.12 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 18 Jun 2021 15:28:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 151 pass: 151 fail: 0
Qemu test results:
	total: 462 pass: 462 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
