Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF7E135A7B9
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 22:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbhDIUPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 16:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233824AbhDIUPG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 16:15:06 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E20C061762;
        Fri,  9 Apr 2021 13:14:51 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 65-20020a9d03470000b02902808b4aec6dso2130499otv.6;
        Fri, 09 Apr 2021 13:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0BSgAj1XEbq6i5gH+aLavclUB+bFaxuJztpujfJL28M=;
        b=sSpq7rj8QRrPYaMRuD2N1TjLsn1gYi/vy8q36dqFv+ihUPJRYuopYxm2SI2i440E12
         nxi1AnCPllgKwb4ko/ql85DIjhs45P82EsUB/3dZbe2KRGltH7e62VLZO9snoIGjNU75
         jaoKptq3TrmkOqOd2DbsnaHPZjUt0e23CMJm4kPhQQKcoF/iZcm36Vf5yoXTUv6ZQJqP
         a0Fv/aK/YxqOJ32UWrqN8PApfKscNKpUgKH0L6BDC6v2i7+fb7hRu7uPrdlbqFnNZhph
         rLNiQBexsQ+H+zG6fQP4WHS23GGnGcDQhk4nB3prItKie35fCpXsoLJEvC7FWj9DLifC
         cxFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=0BSgAj1XEbq6i5gH+aLavclUB+bFaxuJztpujfJL28M=;
        b=hHHd/sQf9eUjJ84P+GwNMxIUuMuzyVojeFEi7hAI+tvzO4/zBj6XN0f95nt23uth3G
         RRBBvhCj6GmUmsKavZqdfQUtZN9KYvlswwlUBf4tjapio5yFuBT34pCthCaxZ8LNlj/9
         vw7w/0zlmASpjupDwth1K7dl1Vo+v5ARsbfmVKwdcXUkb3Zl2QhQan68l1HhhPv1+2w3
         Dm8U/tY9VipSVm0fPvnbP4uhwvuOxCvAGTUZ6eQvQYmhk6WeP5stNrpVcGo/2FNK3tol
         9d82OiF+RYmDc9E1ddMajvW4mPgS19dRcpE2KIJ15XzkDbjTF9rj1M769Ef0EHiO2D2g
         xZsQ==
X-Gm-Message-State: AOAM530WWE/KeizG19i9thuXfh22z+W2UAGUsILw4/gvRUIm1TjVx4lO
        uS9NOjJ2zKACLO4DBpOgQg4=
X-Google-Smtp-Source: ABdhPJwsfHsndDnTTJoe9GXstPvYfKmfmJMRI+VBdaQ9LSd3X4fipeX3Kj+77JqORZ3XDcfCB1KScQ==
X-Received: by 2002:a9d:51cb:: with SMTP id d11mr13752541oth.32.1617999291047;
        Fri, 09 Apr 2021 13:14:51 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y2sm265549ooa.10.2021.04.09.13.14.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Apr 2021 13:14:50 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 9 Apr 2021 13:14:49 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 00/45] 5.11.13-rc1 review
Message-ID: <20210409201449.GG227412@roeck-us.net>
References: <20210409095305.397149021@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 09, 2021 at 11:53:26AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.13 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 460 pass: 460 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
