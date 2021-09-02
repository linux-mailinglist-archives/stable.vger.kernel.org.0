Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096753FF5D2
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 23:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347352AbhIBVuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 17:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232060AbhIBVuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 17:50:44 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78C15C061575;
        Thu,  2 Sep 2021 14:49:45 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id p2so4485455oif.1;
        Thu, 02 Sep 2021 14:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8Jo5RkVShXqTrMTypMHfQ+kSCidR7oDv478vporpNVw=;
        b=FLp1jsDHNiVD+EDRdpdHRa+AlcMD3TMaW2W4/JmC3ehB8AW6rgqCnkI658nGX5DQPG
         vftKLMWGC9ycb3KJaXSFl8XwOfykM9aSFqPYV8S9xNn3DhCQ4ZKSrhhxmOQSnb+e0nOr
         g2Q07up/+CVtp7a+Pa/ps8PBxJNaS4yMi+gds8X7twkLDAFWAphy4sA0dASZAhXyEpGS
         ERTRqSJwDdr15169IPQyzej4dfd/zYs/WQVuSA7J5tpXDDRghnbloyzvWKlAGjK8QWn4
         z4VCgT1osjmYBJ6YKg88pcmC16zvuHKyhl7YBwVrTc0CCZe1326qeYuz+s6588E4/WcB
         cFtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=8Jo5RkVShXqTrMTypMHfQ+kSCidR7oDv478vporpNVw=;
        b=KVhxdK98OTzEiLFFicwzXVIYOtAEEe8FA9QIhCWMXTt6F+GxdRqR0r2s3iAW6Jsp6T
         JRq3GkRsWUh/KwbSavu7Iyj3Svzjbl3rtUQ4XUXG2jiGcgmAntvPP5cI7caII+DiA8Fg
         xl/eRjFo4YbsAlRVLeM5ZQsgs3TyOcEXnV76yKTOEfYIjsB1T6UIPnsrOTOTDKRtcptA
         6br4vnWc+QbBpO9Mua5yQFs/fbpbs9kBWurPvRPwpSj31ipqx1+bSXZVnCkFfD6vizbK
         E5Zvx7Eitrrkt30KElznnNaiT6d31pHTUwNfUZLiVEauoj5xqLjVxcuL32eCT3/a6tq+
         I0eQ==
X-Gm-Message-State: AOAM530yZh2f7BxG0rfqyELYSBZ5kx6ysIn86y3wtyq3VnqxSXxbxosm
        RLKPic+If/8chrwJf7XBYKw=
X-Google-Smtp-Source: ABdhPJxo+HUY0Sg1rOh+JvRTDh9taB7hqE/reePat2IiuEpH4mMxrVXCTb0AtQUty6sYmR008vrAGQ==
X-Received: by 2002:aca:ea8b:: with SMTP id i133mr4038270oih.44.1630619384921;
        Thu, 02 Sep 2021 14:49:44 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y7sm592774oov.36.2021.09.02.14.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 14:49:44 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 2 Sep 2021 14:49:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/16] 4.9.282-rc1 review
Message-ID: <20210902214943.GB4158230@roeck-us.net>
References: <20210901122248.920548099@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901122248.920548099@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 01, 2021 at 02:26:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.282 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Sep 2021 12:22:41 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 393 pass: 393 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
