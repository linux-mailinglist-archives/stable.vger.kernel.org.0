Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6604175659
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 19:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727616AbfGYR4O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 13:56:14 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46643 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbfGYR4O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 13:56:14 -0400
Received: by mail-pg1-f193.google.com with SMTP id k189so4366417pgk.13;
        Thu, 25 Jul 2019 10:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5o9SYGWI02yoZmuJQOfnNmowQ/BEMSNThozEVCK1W6U=;
        b=CHtrZSteUVJksZ4LtPuDpqcyROVaKvpnfL88qHsGq+Mc9L/PdbU7RA4x7LrYSC9v6x
         10ZegfC9qCUfu+S64mlXYcK3DtMQmmu9EXWI/XSMzmIuOXQuZ6N+M6+Ezdu7Wbye6nER
         /uhu4ac9O1MVeKrAN2fpGAhjXiTYh9KdhtRMCPEuaAlkuxpJwxaZeP79SMc1igXgDGi4
         Ba06lNwli7sc0rtxh3gO+BsFoajwYSf0ab+Xy3OSNRwxX4e8ps1KxvQNeO/EA5xnVCPI
         ulrXgPoZrrV3oh65T/Z3C0Xos5HWSDeY/zjvTeC9ZhpQKoyO46SPurFYcjFNHmP16qKd
         Ffag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=5o9SYGWI02yoZmuJQOfnNmowQ/BEMSNThozEVCK1W6U=;
        b=r8+X5RavpbNWrzR94l6KCZPMFHySGm4vxzW3g2W5k4OE/m3SxlKe8cdf4eq0Fwceb2
         kR50XiOhulJAPbVPU23sSFWDSUiUZThLq4Jw1wCuYt2B0NY4mNov1tLSpHo8pDjhM81N
         wCuyD3ESrXtB80e6oiDMUURPIaE5LY3m99sZY+B6SU+vQLF9IVGIUghzjCs/ATgnZrXE
         x+1pOzS/iCBgjBNdGMvIvbMMDL1U81J/pf9JS0fAB/SJoRr87rfi2sHekOm/fPFza5cA
         abQi/h4N4z34xYKgoA2Bzi1X34UMwaB3URqiW+Ih8+yVqqdVrMHpOnYgjdGlptdsysO9
         csyg==
X-Gm-Message-State: APjAAAXd/zlmfNm4mZpv7Fq9rVkdo8C53Rmct3jwyPpJYvg8ygzC2azr
        w2XGLILxbuPi1TnnddDTES4=
X-Google-Smtp-Source: APXvYqxQt4HKtU+mhTRODf4SoAxaQDHF0I/aUHtP9fs5nk899u2krgegn8ajeLFv89fnU61AdhzHfQ==
X-Received: by 2002:a63:4b02:: with SMTP id y2mr86185042pga.135.1564077373464;
        Thu, 25 Jul 2019 10:56:13 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l124sm50834686pgl.54.2019.07.25.10.56.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 10:56:12 -0700 (PDT)
Date:   Thu, 25 Jul 2019 10:56:11 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/271] 4.19.61-stable review
Message-ID: <20190725175611.GA29814@roeck-us.net>
References: <20190724191655.268628197@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 09:17:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.61 release.
> There are 271 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 26 Jul 2019 07:13:35 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 364 pass: 364 fail: 0

Guenter
