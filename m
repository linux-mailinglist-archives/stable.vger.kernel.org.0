Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79912336824
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 00:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhCJXxG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 18:53:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234088AbhCJXwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 18:52:38 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4511C061574;
        Wed, 10 Mar 2021 15:52:38 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id 75so14993699otn.4;
        Wed, 10 Mar 2021 15:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1gXUq+p+R+iKDquW0f3NUODuqMro/ccnYwYdXp6bCfk=;
        b=pCLI4k7OwEbKYjn7M61X8yYl7cDO/YX+cwpYehh0thDWyu5ZIfu5Ny+tBktcJygMVn
         mTIqbI8bWACSJ6l4K5GSSdjyYutexpVSOgZmK6d6WRNlOeLzTXljlKWuit1nVjJxaWyn
         Pmd5u3eUNSKNf3td2LFcuJyjGf3x4TMkyktldLHPsoa8g/1mZiA9gDTi0w5iPh5+dm4p
         Jefc+wflMcwEGJ3js8Cylyn3EDFV1tY6cwfosgQsR/g0ONY+WZI2Jvgx2EzdFlUh5s8K
         3FueEt1PpudeiVzFYXJdkZz9ZbQ8T8ULLCqteqBDAsqmqffHB+mMbMdfBt9/yV911Pwv
         gysA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=1gXUq+p+R+iKDquW0f3NUODuqMro/ccnYwYdXp6bCfk=;
        b=CCNqoA7mT9KacwStCKGVlmGWgBz7pRDaRazhNWtOszefZrX8VFw6UzKZVk9xUlUP8x
         DgjkWYB0hS5E9L39eptdHugINu9cpb/JYbVe50y2LCr/54HQYluM4CCniEEyN5WNAljv
         HiUGGJzO5667YAvdK8UpT3kgMVxITYmiC1OdfAzX3O1wfrdZIr1cwxnbGrZAjfRz1RVU
         U59SSAB2tqiUc/LYbkH87IifRDr9upT/7xgtU4lOzRQk/3TUpqBuLblDCAC2/4XNOL6B
         Zn7pe0QeUJ9gGgnM2x3LmJs/blUtkmGfEqtSnc1VR2Tr5qrWJM6QXCQQbpclYE4rAwUa
         goFQ==
X-Gm-Message-State: AOAM532HQ0UC0WbXGRH6+zfFHCsPQdmKG15yTFjv3plUaQKnvRbXxFt0
        IEpZST3n1/UETsiF+FGiWLs=
X-Google-Smtp-Source: ABdhPJyj2YFWGYhCXNIePKm39NopbZ8pmxz8wD71EEZE6ohQOB50vog+CseZB9qrSL8zILDcPiwV7w==
X-Received: by 2002:a05:6830:1da5:: with SMTP id z5mr4703631oti.257.1615420358137;
        Wed, 10 Mar 2021 15:52:38 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s4sm202825oic.3.2021.03.10.15.52.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Mar 2021 15:52:37 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 10 Mar 2021 15:52:36 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/47] 5.10.23-rc2 review
Message-ID: <20210310235236.GF195769@roeck-us.net>
References: <20210310182834.696191666@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310182834.696191666@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 07:29:23PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.10.23 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 18:28:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 432 pass: 432 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
