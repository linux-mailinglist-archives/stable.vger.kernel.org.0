Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7339E49D693
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 01:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbiA0ALq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 19:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbiA0ALp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 19:11:45 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0AAC06161C;
        Wed, 26 Jan 2022 16:11:45 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id q19-20020a056830441300b0059a54d66106so986319otv.0;
        Wed, 26 Jan 2022 16:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R01Ruz4LeNlNh/YHEYTcUp58EClPFOIswB4tZCRStoc=;
        b=GhXbEACZKZw8Q5AtNL+ZEkKcrOhs5i9vrofrZTDlk6xcMUFZPiCRtwLZfyQj8xPnkx
         RnHD3GCpd/8pHk/pciRMgJlyyfhYKXRrSa73TqjyNwJMSPT6pZTYMqAtVYPiPH8jAOWy
         z3jAlxS51eKRseBncMvwxPY14Y2MUxAdtgpHkcQzpTlo8G3BBLv/3faRhEPlOhpu625v
         JCM4ZnrvuGe0UO3+V2yrekJWN5Q3WHZa9svC3GfM4k5ULlmOrCplUn92bFbWabz12WFf
         3bdAnRWHjulJ6P77EPf19p7Qflth46iJbWXdGELiuzd67PofbPO5y00qPXW9V/GVI4yJ
         WpJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=R01Ruz4LeNlNh/YHEYTcUp58EClPFOIswB4tZCRStoc=;
        b=Mh+hm9RMjQ8wMhRNLXp0kyLm+5T9VExmGSZMWXVe/QZSv891om05lelkHQgYbHNUKG
         QaaIb7Ax6V2mcnGT8LRjfnwZUCLRctIVcYjArvP9RLiP3j/2NgbqrGfp0gcj/8HMxQBd
         pUXIMJS2e+WcQyVNQfB1B52v1XB8hbDeLLCTjds/UVguYFkBCaDPLYw3cTtBAvwZWUii
         j1jjp5S2Jqjk/6O7tnQn7FCbgAFncRbfREfex518X6oQvurGSJT4rEu6Ngab9MagASPV
         etxyWGW9tsBI5hDg7yzyQ8jgSwu+5BEBJ08kOcNjZ2fxleP7AmpS1V1NjO3QY9TX0RuM
         3fhQ==
X-Gm-Message-State: AOAM532/WhB24x38rdQreMCxKOHztTVph7awWZQJJB88Cw9MGldF8UgK
        YID3fLfnzyhf79cXFKEy3Ng=
X-Google-Smtp-Source: ABdhPJzku5jrfCkKN9XBttkwmXsQzwyZWxaC+5wPIe7dcoapxnJECHmkiunZ8tt4G6iiFREyC1ElRg==
X-Received: by 2002:a05:6830:3105:: with SMTP id b5mr767593ots.68.1643242304684;
        Wed, 26 Jan 2022 16:11:44 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p26sm6136818oth.14.2022.01.26.16.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 16:11:43 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 26 Jan 2022 16:11:42 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/114] 4.4.300-rc1 review
Message-ID: <20220127001142.GA630606@roeck-us.net>
References: <20220124183927.095545464@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124183927.095545464@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 24, 2022 at 07:41:35PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.300 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Jan 2022 18:39:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 342 pass: 342 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
