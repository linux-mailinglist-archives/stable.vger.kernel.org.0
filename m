Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 349D23D02BC
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 22:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbhGTT3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 15:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234001AbhGTT3W (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 15:29:22 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE96C061574;
        Tue, 20 Jul 2021 13:09:59 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id y66so475129oie.7;
        Tue, 20 Jul 2021 13:09:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=in4rObE1pwud251ir7z9cBXTRiRwT/ZWVHLmDJqnJe8=;
        b=J8z/crIdnCb592BAp4QRHCKkFnAIWXUqQI1ty4EqN/kchqk6QHzermRmlyX62HaXTX
         eo52Lakwu6wAGSi8qBs8CuUmfbbx0HzaUyIvATjq6VQEhWGVU6YGW6DZEz1CQVISNI9M
         K2uwGgAhchfAnKFyabKCazL8zbOzSvxloJ3YMqY9Agq9hpWHeik95unGCs7I9gZxPL/K
         TtvIkYVAA+bL7MeqS00XtuvcJb86nE7C+8TV1HLeJZPPUkr0KqGCJWSb34cNO589v/hO
         yJR4QEeC/TC9NqjhgBXloSjNLbJB1pJe5JSeWlt0w1bdO1T6YYHgMW+bNw5VIRMVzkkw
         3PUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=in4rObE1pwud251ir7z9cBXTRiRwT/ZWVHLmDJqnJe8=;
        b=Ocs8yWUNMIki9BAdvvB7uV3Yypx9q0KmHCMjWKeSWZuMOCPxk/Vr72wKbhs1F+2hf1
         mTtRNfV3Xy2qxDZ8wKza4TEjBGyUYIal0AYq0V5wnXBcehwtanHO8RfHqgjcydXdZ0uR
         9n0Cz3+jI/jXSu62WlW5L4/39h3i8+wzcJzNYShIh+V3HT9TnYlFp7W3figZJfEjsnt7
         inToRIEKy53W2gLSx532mysWUxorGP627uRqg/e+2q8GlMPABsPjmuF9BV+NKqVv1PC8
         ZTZv/f5Hst10Sjha0vIMWpi1rA3KPXq8VrVHPI7Na/1ejBSmtHq3yulzifJSYIWHTlh5
         342Q==
X-Gm-Message-State: AOAM530ed7SIl/U/U2E/Ajw1lJvBa7SvBCgpMm+slomIPopGw0OOw0gQ
        sXCUyJv2dzgBnx0Z2290dvA=
X-Google-Smtp-Source: ABdhPJzyN1G+ClvoLlnxgL9cSeRS3fsh7rLTACtWyD7CB7gp0tZpVlIXHpfu5IjotCLNXhw/MOy4/g==
X-Received: by 2002:aca:43c6:: with SMTP id q189mr104503oia.81.1626811798918;
        Tue, 20 Jul 2021 13:09:58 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t64sm4627445oig.48.2021.07.20.13.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 13:09:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 20 Jul 2021 13:09:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/239] 5.10.52-rc2 review
Message-ID: <20210720200957.GF2360284@roeck-us.net>
References: <20210719184320.888029606@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719184320.888029606@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 08:45:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.52 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 458 pass: 458 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
