Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3B0743BA76
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 21:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236509AbhJZTRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 15:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235650AbhJZTRT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 15:17:19 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12850C061570;
        Tue, 26 Oct 2021 12:14:55 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id q124so96761oig.3;
        Tue, 26 Oct 2021 12:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y+zEz08kHBGhu7R8XTDsBEXzZSWT7wtgKoTDOb5ajPw=;
        b=c3Zh+1X7UmneHWZsoRehuHIRL0fPB+Oh2m7C1gMeTxMsn5GtMj3ubGru9GUbhpiFie
         ICxgB2ECUjWXlj3KL0HwVwl48NH7scCv/P9EbUpQbOZ8ZNpFoLRHF1bJHwVO8+UQM4j3
         Gug2sz0w3Lid/qiZQ2lLp4rseSE4dVVCMsL8ibSx9jk1+fbN7RmmpfSxjje9u9H9oMzM
         7B3cCKUvMymYp53obuYIbjcBz7nOEjZL+V7a+r1iixCX038YalNev+ncVOoMpsLSA7oc
         lR88EWkS9EsaTeha9joeU52pm+FH+MWhMtxfP61y34khNwZrvkCQqAs4W7RVFFfN0N98
         Iylg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=y+zEz08kHBGhu7R8XTDsBEXzZSWT7wtgKoTDOb5ajPw=;
        b=Z/KA4K5ytnJ3g9ofGfZWU/6Zt2C+QWdtB+ecprPA5mDvyYhJDSCczh8Q6Pfzmc2+td
         XjKNGZR462v4/37PvJFrY8zgiXsf+3tjHo5kRzvpkzzPphfjFG+flDlJ2KghherKt6de
         8wwU3KEZrULgHpesB1a/E332uzg+qxj54cpTdHGkHmnkuqg1TfxblSrM4Frt0Xbs2G+H
         D7zFMDPfD5S6V8Z1K1jXJYDGRGnXM6zumq1NduSNAeyiD8/BGdLT37icj9oByy9TfalJ
         pEz4LT6aj4vZhpN+5PN12JaXXtdT9Forj1JFubXsfz+eOrkmvugo1EiIMTLEzxN5eyq3
         K6mA==
X-Gm-Message-State: AOAM5301ElMseE6iExmMLbyS85T03sl5pjDOSGJnF6/gperT8uFBng0v
        iY0UEe6/MI6IEDfI2CuhX0g=
X-Google-Smtp-Source: ABdhPJxmUUy5GSDH9I8l7WmEPlWDuVIPbxYRijNT0y+YZeFKIli/fTQ8lV+EJlpZtt/x9IZ0dYnMIA==
X-Received: by 2002:a54:4401:: with SMTP id k1mr450772oiw.25.1635275693047;
        Tue, 26 Oct 2021 12:14:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j7sm802613oon.13.2021.10.26.12.14.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 12:14:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 26 Oct 2021 12:14:49 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/50] 4.9.288-rc1 review
Message-ID: <20211026191449.GA2014125@roeck-us.net>
References: <20211025190932.542632625@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025190932.542632625@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 25, 2021 at 09:13:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.288 release.
> There are 50 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 394 pass: 394 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
