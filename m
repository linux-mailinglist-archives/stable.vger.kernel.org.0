Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE92263252
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 18:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730978AbgIIQkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 12:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730469AbgIIQkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 12:40:16 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 651B7C061573;
        Wed,  9 Sep 2020 09:40:16 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id x69so2976468oia.8;
        Wed, 09 Sep 2020 09:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0JIgpPfwpM3oTuJq85El0mT6gJOs2X8hJ6g0xSVZbOc=;
        b=aK1T568HHyJikWgtHwUfZhirq6QONF/u+igjVRmA1TzpdOhpFKMi5gTnPqR+0+pgoa
         UbTy2a4WgWm2S3EJM4rfk/j/wkcaGuhzrCbakWfQQPQPruvNZgocA8lqUYjBYohZ30u8
         OiHvMv8dZUdZqwIjzH9QDcn6sdFBQig6TmuRmQWmoaueHD8/EDdQrgSytEeZqCYPsjvP
         civ7uIjAyqvNNXQfasJ4Yz3IcHqdDEfbsCygm6z6z4mexLL1swt+kuH04fhQrXbOT8FN
         qlybSBR5gAT58SYOc7eHW9159d5iOhptGtrJtJlfWzm1lXUuHFCwwoTebkhhHGOWF7Kq
         KIdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=0JIgpPfwpM3oTuJq85El0mT6gJOs2X8hJ6g0xSVZbOc=;
        b=R3HVhY4LV4LmteaZNT5S2JvfNKVXx1UEvk4akBR2mj01i+OA24qJq9PNQbePhBeJNT
         Z8HJFEqKmQgRdGhGcYZI5Jud1MTtzjLhZWBV0M5xinIQWg7vGicUMYoXthu5fZXAB0pW
         0cVBzpVgcSr56w4kG05h+DRWHYB/ukAEm8bKRu0Sc0PLQJ0GGLcyyzo4QkJCMxq50xgx
         NN8RMelvvFZIE1yZ0+sjCBTma2H7+SaYsb31iMbwtV47JLM0kRld1KkIkYYom93qL2mK
         3W9/ZErehZAZMktteRhupyop5JHhzqPLvfOeblthhQ9amCANcUHyjNBaGp6C1jh+QZB/
         J3Og==
X-Gm-Message-State: AOAM532CaKeHLVsgkR81VF37ohQJox/1j+6kYWOgbxLV8M5YyDzuE7KS
        h6UnHq/CAFwOMc7xT9WMai4=
X-Google-Smtp-Source: ABdhPJw07i2ZN17HrpiYARTg0jSxYbWZwb4VWeSOfAoCHeu92eatXkyiZKkYhcBzl70Fu8WDpJ1jEA==
X-Received: by 2002:a54:411a:: with SMTP id l26mr1122874oic.12.1599669615841;
        Wed, 09 Sep 2020 09:40:15 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m20sm443122oof.23.2020.09.09.09.40.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 09 Sep 2020 09:40:15 -0700 (PDT)
Date:   Wed, 9 Sep 2020 09:40:14 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/129] 5.4.64-rc1 review
Message-ID: <20200909164014.GD1479@roeck-us.net>
References: <20200908152229.689878733@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 08, 2020 at 05:24:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.64 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
