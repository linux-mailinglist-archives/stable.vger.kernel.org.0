Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6407340FEE6
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 19:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239575AbhIQSBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Sep 2021 14:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbhIQSBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Sep 2021 14:01:04 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92367C061574;
        Fri, 17 Sep 2021 10:59:42 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id m7-20020a9d4c87000000b0051875f56b95so13952333otf.6;
        Fri, 17 Sep 2021 10:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BuGEzd0vMtKyoOghEWbrerx9BYFsQVEbTG+PVdXDK5g=;
        b=Lf1zc7BrS/eZ7MsjHpWU6AiCnDwTVBanJLzUA9mZV9qlOvzFFS0Q3x4qudYRnUPpv9
         Jo3V+wt3LkZM6pn6zs70RsYztJLM5FV51IVpNCcxHDn5sz+S9t45bE2qI2fuCNIstL9H
         oGIiE5d7zYlFR7L/jPc3HIh7jrtgegYlJ6vSU1lJF6qc/bV76EAULjfU3eG6cS1ZjZRh
         G0g+i/s5gbjp+L4c2TIu875LF/hJDZSNSK7asyqISWHi35zUrhXQcML758fnUtPY/WAq
         SOO2mBHU+lb0ywlpEVdJf6lWFLi/0BhAJNwOpvbAKtypmepZzaUXLdd02UlGQUw6PjCq
         xPjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=BuGEzd0vMtKyoOghEWbrerx9BYFsQVEbTG+PVdXDK5g=;
        b=5jtT3pSoeVj5hCkRIe14GKz8UK6MZHfzfYD0pw+JssBqoB37umVVJSRcf8SrG5nm4X
         a+W1PYETsY/AI6U6HeLP3pA/jnROyi4EtRDdpjyY6hPhT8O/B9GyS50ClZ2oyHGFocTT
         8eToaanqMvQoKgCLq14+tVF8gBGryNqE7PfgZ9UmcsQRuSFJQTVzfAftkjVC3BRFWQaI
         8IpO7dv0XaEsqiXmDN6J1AbDXRSN7I2Hq5Sd60HG5/4MrR0RngVtuBoLjIJ70jP5I7s0
         0iiLCIhU8qeytBfVTPFc8waYw0rBj8c8nfbotkuG0TQjG43O+xhMCxZB4kVXHkJmt29W
         HmWA==
X-Gm-Message-State: AOAM5336Q2Et9n5hEV4CvTBqiLWqGd1PKd+rx73FKaNf/vTGB/54HJRU
        6bHoYy/bKkvQ8tUXuASlCYQ=
X-Google-Smtp-Source: ABdhPJyGfdfgF86NJjhOHCQI1x0PuMvZ0VorOdmuwhB9Hz8dK/iWiwqZjLYZrTh+AyFITGVuxy1GsA==
X-Received: by 2002:a9d:2053:: with SMTP id n77mr10721610ota.9.1631901581996;
        Fri, 17 Sep 2021 10:59:41 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a10sm1550993oil.30.2021.09.17.10.59.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 10:59:41 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 17 Sep 2021 10:59:40 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 000/432] 5.14.6-rc1 review
Message-ID: <20210917175940.GB4056493@roeck-us.net>
References: <20210916155810.813340753@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 16, 2021 at 05:55:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.6 release.
> There are 432 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Sep 2021 15:57:06 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
