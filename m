Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBD7393CD1
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 08:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbhE1GBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 02:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbhE1GBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 02:01:31 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEB1C061574;
        Thu, 27 May 2021 22:59:56 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id h9so3221783oih.4;
        Thu, 27 May 2021 22:59:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iHVj+eL/LmCAYfcEOUvmMxhDP4gK/ygKDgThCm5FGDw=;
        b=Nj6oE5bDY/Z/ZOgAzFQ5GUUbZ7Dfav+Dr6bLIliae0W1WX/P3r3mrCVfBLIvKhGWpj
         te48n5/9AIWYBw7DgliM4zdkiuy3v4gQCjiYDgTnNXwxtVqGZH7qz/FdHBwnD8kRDfgs
         DUl3ZYmiN9SViF/dopS2dabZA5HKh9XiVzVxM1gw7y55SyD8ayBzDpsn16a4ZZ75km/p
         SqGY+j9G9seWNSg0osHL4bCllGNjszdsoJs6QElmml57F/n8ncBRTTCZ3eqZeYNz8cEP
         EoYXEsP+IK7mqIE2UN8sIGuaQUHt+KJMH4l4AufV+C2t6NDZj3HcRjwfgm/m0OTEX/vZ
         h7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=iHVj+eL/LmCAYfcEOUvmMxhDP4gK/ygKDgThCm5FGDw=;
        b=ihg8GJSSw18dmpvF9A/e5s57Q8iyS2Pvh42U9/8MDzxna+RqmPlt4T9dsA6nGsPZt0
         844Jb16iLAsX+zjwjZIMbEPOHA1NRmN2Rl9R2RsCZoxT5ggfYMLvLdr/JQqdwYqjp7qR
         Ka07UMptXXk75/idV4R+XtwLo+KQF/b7Ul11BZiypOJqS0GoOlNQglTa9kUcW+lZWip5
         vef3xBorkLwv4VULeNYEKyfNdlfvtxaoc6PNhjecKggTTCV8DSYKEVi5yUfsgmQ49EQQ
         JfgtfcBGYUrNzuISO4VT/W0qxm3Hd8n32zLWzYyCUWeJfQemgJPsFmK7cEoDa7Q1WwtY
         vo8A==
X-Gm-Message-State: AOAM530Bj3pxBql74INeO2mgkeoiDSXCudIT5Wg/5HSF9+UhtmnE+haR
        FZb6zA0GiNPKEt9sFt/Oru55xZXPsb0=
X-Google-Smtp-Source: ABdhPJzclcZtpo0VhMqykgCxS/9D48T7N5QoMIbZ4GX3gsp+iN2esEJKF23arMOSpT4VMS5m2ga9fg==
X-Received: by 2002:a05:6808:a02:: with SMTP id n2mr7760068oij.104.1622181595700;
        Thu, 27 May 2021 22:59:55 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w13sm978475otp.10.2021.05.27.22.59.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 22:59:55 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 27 May 2021 22:59:53 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 0/7] 5.4.123-rc1 review
Message-ID: <20210528055953.GA2447409@roeck-us.net>
References: <20210527151139.224619013@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527151139.224619013@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 27, 2021 at 05:12:42PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.123 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 May 2021 15:11:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 428 pass: 428 fail: 0

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Guenter
