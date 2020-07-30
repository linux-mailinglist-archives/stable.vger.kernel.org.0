Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADE38233710
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 18:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbgG3Qq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 12:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgG3Qq0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 12:46:26 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF904C061574;
        Thu, 30 Jul 2020 09:46:26 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id b9so14666872plx.6;
        Thu, 30 Jul 2020 09:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=E9wgKNF89nMY2ADGRokAy0qBSB4WUfKmi8IgRPD/ipQ=;
        b=UlLwJKulY6TDnJabacT87ez7Y3hfFlEZcKhpH56qOb+Rsss0clVJ9RUlcdUaBJhCaQ
         JLUOS6Mv6AaYWgYRcaQboWE1i386n3pSrOt4sXY4/pfoEVXGkqiw+b/M85gtMrijOZsX
         ALz2Y1A991QYlrmnARcsgC8eVbMWhbCkPLnz5lD4qOZ1sdSCreyOcavWWjODwXE/o2Fh
         J3grOLx1/lH+x7L/p0GwvjZY7gWz4tiEnzZKjlO8AD1m9vGG8ez2gFHg6REM1t+ritDy
         txcdzf6ot6B5n2Bm+WGrfwX5c2X/m45wvDrf+zj7iHmj8Od5Prt6NQw51nwTLUrUKWGN
         mgVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=E9wgKNF89nMY2ADGRokAy0qBSB4WUfKmi8IgRPD/ipQ=;
        b=EZnUjzIFowDyzuw60HSZRLF8qRW9tjONvVD+uNj8hJ3DV/7S5WSe5AG+Mecasol9nt
         o7vrbFIeRMVEAQ0oR7150H28JS3locywu05ZON+NxmMq6Y1JRcWSCCEzdjT6tYxzxg2/
         srZechNTH7zA8ldGe9Dm1HF1XThs1hTjehphmLizTZdlBWPblRndkUEIkWQxuKpnTDoV
         3pCYJ2vtJRghMH8VF1sjPpe1I/kiqH9Cg61ZOpduzje/rJqqy4fQhKjAn7/UHgOG48kw
         0N61+UjljfaxGG6l4heslP1fDaidgMNI7aoEFvgBvKXRXFQ26JNyeS50ixHUhGFq6WtE
         Ljgg==
X-Gm-Message-State: AOAM530z1/NKCBbB18/JmTO+cBljpewuTU4y+33pAWhDyzcPxJDEWjXr
        HaqinF5cbWPqkPzp0EjKuvQ=
X-Google-Smtp-Source: ABdhPJyyWV6EP2rRBCGkus5eZ0bkMGOWxEV78cRTylyF5aaJfkzaIx85YOCDq6VYiU2ZGe3bTxn2EQ==
X-Received: by 2002:a63:210c:: with SMTP id h12mr34881505pgh.152.1596127586288;
        Thu, 30 Jul 2020 09:46:26 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z8sm7010811pgz.7.2020.07.30.09.46.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Jul 2020 09:46:25 -0700 (PDT)
Date:   Thu, 30 Jul 2020 09:46:24 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/54] 4.4.232-rc1 review
Message-ID: <20200730164624.GA57647@roeck-us.net>
References: <20200730074421.203879987@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730074421.203879987@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 30, 2020 at 10:04:39AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.232 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2020 07:44:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 169 pass: 169 fail: 0
Qemu test results:
	total: 331 pass: 331 fail: 0

Guenter
