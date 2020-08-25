Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF118251FB0
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 21:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgHYTTN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 15:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbgHYTTL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 15:19:11 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D8EEC061574;
        Tue, 25 Aug 2020 12:19:11 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id j13so26385pjd.4;
        Tue, 25 Aug 2020 12:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CHkPYxiJz7RfurndXTXM2/NyRfbRCRqTVCJ4ExH0P7M=;
        b=pkZYaV+w0oo3aPhI3C+RrX66X13wq/heJRzWR6ajT8SSc/Skn0gDX5+3lFdoysbBhW
         VBix8ZsyKeGa3Qz6FxCvgU/eFhYLLGAaIBnRk3if13Nl2PD3ajl6PI6r9eJS4jbZtby1
         6rICc/YeHO2lHX4NSLP+3cQ9tSij2sRvbsRFKA8PyFivMwQtOsqe5df/dkv3N+gIYd3W
         nnSfjKqcJOSuxzBbTjQQVICWw7b2+bSnNyTrpU4pcYiDygIBS9SPnIrJ9rAcB51kIiJV
         uHaSbLE+g/zaFBZDTSGVpggPHwi6HkQebzSAd5W5U3arV6P7GFIuVbY9gSZ00j1cXHrL
         dnqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=CHkPYxiJz7RfurndXTXM2/NyRfbRCRqTVCJ4ExH0P7M=;
        b=BLYgZl5xp8p3R0yym9EvRLl0sdcwtAGmqK6pxpLpSFejNN1uaJ0d/+gGYPMIat6eQ2
         ndmRMHWwHqqX+N5pC/4S9eM9CF2DXG+a5uW/N6ONGUpnh7BDRjpxcakG78JmJSTVT7f4
         Aw906//DpTqdTbOtzFO5byppysnDEq68+jg43AVrDEB8GPT8dTK4ypxTTQ6kEwr5UMUj
         3IdWAs5Q0F2Gbz35i9qlFY3EDhrbJlWNXaKv54n5QyPwTAv95iHm+c8yDs65b43UKIXL
         hHFOMGiB++FjntfT0/HcQhNP9KzEAR/J+cEeMrFN0v2CnsHSSst0OnXgglL3Tu+eC5Qf
         cBYA==
X-Gm-Message-State: AOAM530e1YngrJiWxQq0V/YA/0qeyGGrpNKku4PufPUhm6bOY2AX8/yM
        kmAGryngzyKATlq4Tkd+2Ug=
X-Google-Smtp-Source: ABdhPJxBggtto6dNpsxIW6OGkGAvwa1lYzpYeE7T577CHAJZnJrXvSByfh/ftZNKLM0NskL6ENvubg==
X-Received: by 2002:a17:90a:1117:: with SMTP id d23mr2777109pja.33.1598383150748;
        Tue, 25 Aug 2020 12:19:10 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a12sm5840991pfr.217.2020.08.25.12.19.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Aug 2020 12:19:10 -0700 (PDT)
Date:   Tue, 25 Aug 2020 12:19:08 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/34] 4.4.234-rc2 review
Message-ID: <20200825191908.GA36661@roeck-us.net>
References: <20200824164719.331619736@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824164719.331619736@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 06:49:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.234 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Aug 2020 16:47:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
total: 169 pass: 169 fail: 0
Qemu test results:
total: 332 pass: 332 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
