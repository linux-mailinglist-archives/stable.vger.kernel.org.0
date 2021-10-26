Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A83143BA79
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 21:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236579AbhJZTRo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 15:17:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235650AbhJZTRo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 15:17:44 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 135F7C061570;
        Tue, 26 Oct 2021 12:15:20 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id x27-20020a9d459b000000b0055303520cc4so69467ote.13;
        Tue, 26 Oct 2021 12:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9gwvYNVezb/0w/gV+LYL5k8+BqMgJhEieYPX+RBnnHo=;
        b=pLP/I4GpNS+DlKAS4LSf4njnkn76mV+CEJZO2IZCKqoe+06Dx7pL9ndXqF9n9wbWxL
         pyeb+a94aCXsmsBIsP6cLkp3qj/GdB0qbGug4WMfCFYGg9vO4KPxUt2srIyj2H4TXNo5
         el9ifU8RxBQ3G6APOZrEXq8gYJMvRo1PvaKAby9Bu4HR12+qf47JxJB/3hb0JFtZ0XKc
         DTrX7BbRhvDMEQFCbr+oDcbcnY8T0Q6dioV3CXLO0m9mB9vrWMFYYIyUS8NMkuaW9Tz/
         QuenjK0ObysnBD1EYF/SHNHpbs8NG5g+k4i6tgXFAgH2deoRQ6Oi+8wXrM+z2d1V5csl
         X4hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=9gwvYNVezb/0w/gV+LYL5k8+BqMgJhEieYPX+RBnnHo=;
        b=esSCeQoSz9pVbFS5Z5AoEok7+vJACLk0/2+kE6hSTLu+u6c26uU2JAyWjd0l+4qWOE
         ngMB7mVjTRzidz//RoLzj5jAgJPGwBn652KbGcbAzOyfYXOTLtIxOM6c5crUU9vTR09j
         K8ytQOAGLAx6sa5ASHgY16h9YJSOuME/uQfGXZjGVMnO/4onASZqbo4KaNBz+KRgmSOj
         NBZ708kvJ8JkJCtrdnjBcyQO/LNGWxX4xOrZDJkIgnhxi3/RuhwLU6doqHJmyGiQfdqV
         u6nl3vo/HH2u9q5xtw69T3JxYbpi85+X79Fz7IF1mL0IXinoXbvIgOUxoXMAHIr0pL2U
         aTEQ==
X-Gm-Message-State: AOAM531qtfBOvlP3TjpotKFy6CQBUeQrlchG579tvHMqR8DpNJe5bHw+
        EKo4LVVQ+CqmzTNazfi422I=
X-Google-Smtp-Source: ABdhPJy5xA6oN86WOeTcnacmUHn5XxN4qDnIMvg+b6eB+elxPLJ5iVQcAM7DhC5jz+CYCOrtLOoB9g==
X-Received: by 2002:a05:6830:4021:: with SMTP id i1mr22207783ots.69.1635275719513;
        Tue, 26 Oct 2021 12:15:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f1sm4033855oos.46.2021.10.26.12.15.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 12:15:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 26 Oct 2021 12:15:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/30] 4.14.253-rc1 review
Message-ID: <20211026191517.GB2014125@roeck-us.net>
References: <20211025190922.089277904@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025190922.089277904@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 25, 2021 at 09:14:20PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.253 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
