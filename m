Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E9F3FF6B7
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 23:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347944AbhIBV7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 17:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347941AbhIBV7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 17:59:03 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8E3C061575;
        Thu,  2 Sep 2021 14:58:03 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so4386835otf.6;
        Thu, 02 Sep 2021 14:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7XIMCPXPfpjCMBn2EIysqMZE/uVHfPxf01Yk2stwj4A=;
        b=Lvp5HsAxmKIUcNpW7y8NKtzSL/YKKHJRhVIcCVzHD7pgvMMHFiItNkUyPoPEoWKojB
         zkxHS4pQWxujMoTq6YPAsoXkieZHrDWpAlA8Xgc/PljxTpFlwGVuvAmVv5XgBAAQ/y+P
         4qshyOAIodKR6KYtZHO3xaUhyYi+XB7XEdVs/9QSAA10fhooreVSbC86yVCOeF+SmTPf
         QeRWhAJm6YmRykmS91jJbifCdm4v2fpOlDi9kYLjN9p4RPDE+DV3mv1q5w4P5Yo/3mp0
         ApNQK1AGKRQRbFjN5ac3VGgKZFjd5GSIgKiN6iaQy4mddK/i42KYHhXEIeoziAkYmM+/
         PgJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=7XIMCPXPfpjCMBn2EIysqMZE/uVHfPxf01Yk2stwj4A=;
        b=rGklBqT71Au9HT8iAvNfma73XGU2KZSAv2ojMDXtenLMhuohdna9SemgP4+4/ZGq0B
         7TdzmyAZMXWdIfs1OjONodmKi/8RQJQ8nM+R+IlNjCmxdbBGQY6nL5+SLX6Nj1hKkKZE
         wCoqAplphhcK6uX8DX8gVtAovkQE28MR7tS8J5U5IaqtK2L5QtriDEbUgoYLOY7zrLQy
         ddOSN97AEr1FUncekmadBc4sckkc2HIUywbDrfjyc5sQR4hPOnrLOafT2bi6bYL8+7Tt
         547g370SaQhPQlY8AsLcL8/3I2Rsn1ta0rThQD4qWEA2EKI4p0qM3wz/gUaqukxIuhVG
         1Cmg==
X-Gm-Message-State: AOAM532gB1N6PLFRL2GEqlvO6XeV63DalL3mHpWfwakaLYYrX863kDSf
        Ep+YM0W6LpqUOhlO2+f1crshyjzSbYY=
X-Google-Smtp-Source: ABdhPJy3RSO3mTXddODFvvZ6pJgA7GkkbzJDGwSC4d1jmMPuoFSbCy7Q2aISjA7pw9pkvhAxLacI/w==
X-Received: by 2002:a05:6830:238e:: with SMTP id l14mr318839ots.354.1630619882721;
        Thu, 02 Sep 2021 14:58:02 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r28sm620259oiw.45.2021.09.02.14.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 14:58:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 2 Sep 2021 14:58:00 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/103] 5.10.62-rc1 review
Message-ID: <20210902215800.GH4158230@roeck-us.net>
References: <20210901122300.503008474@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 01, 2021 at 02:27:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.62 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 471 pass: 471 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
