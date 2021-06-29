Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238B43B77B5
	for <lists+stable@lfdr.de>; Tue, 29 Jun 2021 20:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbhF2SWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Jun 2021 14:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbhF2SWm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Jun 2021 14:22:42 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0884C061760;
        Tue, 29 Jun 2021 11:20:14 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id b2so24905345oiy.6;
        Tue, 29 Jun 2021 11:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QuTmaqVMejam6bEzKVuvrsyr9Ad/KbLiT5cQoxbZh/g=;
        b=ND086eGtZ2KRJUlyiDSULidsj5eYqfNFqRDrdn/5zMB2ShSAXt5nIYE9Yxny9osQK7
         NiYRJ8T7Gu62IM88GxNgVi0I+uaSgjEbOXe9fOyIUpQKsMlG9tk9plmfGU8MBsUHXi+C
         N4/ix8aWV2p3M7FiTOYtf00EqsXTC2QYSi734tJ3n77onT3MFztM45Bfi+uIGqAoilZY
         aTAQzgcgIehnJCPi724TCGNFcP6AyCxkSLnN+DhNUCLdQsu9n+ksISKg28Qo64XQPcvz
         um50QJ8+jipnldD0WGQScKYyBFifPRrq/D80zLZwM+0z1i+bIHYi7sEdBUz24A9FmuKB
         WgNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=QuTmaqVMejam6bEzKVuvrsyr9Ad/KbLiT5cQoxbZh/g=;
        b=duSTTpCY6nht5NdXgO4siKCP5e0HJpUuoSk/fFi77S+v9xXdcDowSny8ovlLpDr8ZQ
         XMdHkOoxGO99YimrUM6nJGu0of0IfZm3DVNzlvUjUWQlljZe3QkvajjjUPGs6Ao913Ak
         u6q9OrppXjpQZDVRsNvKniBetynRF1lMBs5srEQUjtqMiZAsUrMkC4zbA2X4A8jrCC8W
         LOnNkGYpZNbHJhRqmCNFDP9deddiSTaVAyzlqcKhddz4bQM0ww/bdeTry1QZ9aJyLDuZ
         kUFoQYF/jHUDbRHjSMYIoeIvtaB2d4bYyc5Q96QcHL5ldCe81Jutr+uu9cQnxVLRx6eA
         EvRg==
X-Gm-Message-State: AOAM5339OQBtJdNK8xQofrP2kAPqucYm75zvkeyNoOSF9bOrKOgyxQuG
        r00rV+nG/kJirkkOKtcG650=
X-Google-Smtp-Source: ABdhPJz4q0ZzKKmzwNGoYMzeZiNENm+YCcQvKzbQS3xnnMjdWPV2K9BvJgwI88Bb3RBcuwoECQhtwg==
X-Received: by 2002:a54:4796:: with SMTP id o22mr14066908oic.170.1624990814230;
        Tue, 29 Jun 2021 11:20:14 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j13sm3990093oie.27.2021.06.29.11.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 11:20:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 29 Jun 2021 11:20:12 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.4 00/71] 5.4.129-rc1 review
Message-ID: <20210629182012.GE2842065@roeck-us.net>
References: <20210628143004.32596-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628143004.32596-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 28, 2021 at 10:28:53AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.4.129 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 30 Jun 2021 02:29:43 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 428 pass: 428 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
