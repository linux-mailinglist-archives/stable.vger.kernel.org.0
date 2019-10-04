Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB63CCC632
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 01:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbfJDXJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 19:09:07 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38125 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDXJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 19:09:07 -0400
Received: by mail-pg1-f194.google.com with SMTP id x10so4585766pgi.5;
        Fri, 04 Oct 2019 16:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TqMjlOsuOLMyXeiEANp5+BSmWBe6CmBgkFgnUP7RRPc=;
        b=p3ewdE3/hWGx7cDEb4BwFs4JlUOnyLe+IHu3MMA3+eM24NVrPYzZxU5QG+RpwMdyMc
         nacqU0xU0li53TsSWgz13feAEjCdBiD9gDbAQpGiVAzbdIsbYNqVytPVf5uRpb9mp2G6
         dZSiauHGkaG3bJgf15Vxv/S5EvjscBsDPUp2D3LRH9oun/iaXgHYIwfBDa+51AYAzHrX
         PbkyUUM5jvTd38GaxXNihlai3y7zczL0cxLl3ycwDpy6kTsimoqQe8vC6Gw7HrwsuRwp
         kGKt53Mz1P2L+gsShJng1dAXY9WQv5tfov5qq06tQbtGVSByI3DTFmww1JOTQeKnBFPV
         qmMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=TqMjlOsuOLMyXeiEANp5+BSmWBe6CmBgkFgnUP7RRPc=;
        b=RP5VOgW2mFDtjjonN1oS9zQmHTsbpCP+iTQXlf5waY7kPGvm1nplzY7eUZupsLht6R
         h5iee78/VxBWZ8rAz3gBkOoNxJH7yWBqdrm9FXCV6pjREbhwlr4H4pF+QadV7ILcYcr5
         mTbkNQSW/toyHpQFHDKvEDqDuQ/qjjcADzK9/EtgDbFY2XBN0Fm1HIxXMVCUeT7VDCFJ
         cNVqDLLzv9A4vs1V/RREsi/GyhoJx1H+yVoFtGxq9RTXqNWaxMyg3Kw4xIBXaoZaQzvm
         oEwVNPIl6tToZRngjWqF41kAXQFL7I3e24Zb+qStlIcYOfqgFxaJXwInH4Dhg+poRoES
         57rw==
X-Gm-Message-State: APjAAAVOlDGgQEIUIKmFPL26TCrzZeQe5yJvix7M/E9g2bAhjxEcYOPt
        MMPszG3GhTkKtuSFS7Uda/ZMx5eW
X-Google-Smtp-Source: APXvYqyAWpszDjzPBz1t7RzTJUCL659hCFP05t/AUQIQ7LxmqW7Objszdm2hzpDd34vI/qbpt+DA4A==
X-Received: by 2002:aa7:9104:: with SMTP id 4mr19980705pfh.176.1570230545654;
        Fri, 04 Oct 2019 16:09:05 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 196sm12578714pfz.99.2019.10.04.16.09.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 04 Oct 2019 16:09:04 -0700 (PDT)
Date:   Fri, 4 Oct 2019 16:09:03 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: Re: [PATCH 3.16 00/87] 3.16.75-rc1 review
Message-ID: <20191004230903.GB15860@roeck-us.net>
References: <lsq.1570043210.379046399@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 02, 2019 at 08:06:50PM +0100, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.16.75 release.
> There are 87 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri Oct 04 19:06:50 UTC 2019.
> Anything received after that time might be too late.
> 
For v3.16.74-85-g811e39a80ea5:

Build results:
	total: 136 pass: 136 fail: 0
Qemu test results:
	total: 229 pass: 229 fail: 0

Guenter
