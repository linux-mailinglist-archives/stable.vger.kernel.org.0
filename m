Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C780B124A15
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 15:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfLROse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 09:48:34 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:33329 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfLROsd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 09:48:33 -0500
Received: by mail-pj1-f65.google.com with SMTP id u63so1338965pjb.0;
        Wed, 18 Dec 2019 06:48:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gM/KYzz1l3tkK0niqE8gzGOqbnmvODOPM1NhCTgQRYU=;
        b=gqmY0HpVCUy5rqJCQ8tjq6yl+TXLygBmQOoIelQkdtm9xlPzD+/Cd9hvP65Wuq9gG9
         34AFrwBv8R6YXWQiofNtAEAGZ/SgMoUzcJB9+oWhP5fI4VN38d3HK2AUHMXDJ3mKQSMj
         ROAKH1hU7YTnowKPOvOCRD7GoS3YzIC5zMI/riQLHc616nvNToNi4QJ1vgXM1tIswp2j
         SQY77GrskWdM1LTzSj+O62C9G943Yg48tFrlm9BpHxoS0TinICemMV2kEZPNZUBBSZak
         bNqhv+llW2WaRUaUHH9U24veTWaM26MTtgyAupNxBYOre83VEk16URGpCuqJHUM0oSXB
         Yy/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=gM/KYzz1l3tkK0niqE8gzGOqbnmvODOPM1NhCTgQRYU=;
        b=AhyV+oJoA2xdoxssq65HL7zV9WXGhOgFoe8OUUhG76UMuAB4C4A3HWPeokSoVrh5sc
         J4o9WnSGBZ4XA+ieIfpVsvw4YSdrAKPPAXt9tpPPw9kuW7hFiDmIwJT7wd5r4JlsHt2u
         37atm4fkpQYacIKdPtK/ErqFYLqW02zMPCTOD8krcGySdtdkKba7MueDvqX8/H5GnOnV
         KqR9ADJqUuC0PVfuHEWHdkTczbndP8jdz03pe2yBFfVFQ35YlqQ3RuxIrO1jWsjWmq+8
         2naEmXqI1My55HbV/iQhRuANBqw38/SpdGUavM2Wb6d0V/GHJGNuk3je6TsgfKePj/nh
         Frlw==
X-Gm-Message-State: APjAAAUwZmDLY+y0Cdh2Yg6jb9b5WRzF64Unx3Nmq/7aXIqo4OBh80yp
        7ahW6MDzDlbzLFTUidrbT08=
X-Google-Smtp-Source: APXvYqznxfUUFd0eyhOBrWsCRgTk7a/szB75cFDtWVLUu699uFJROYT4viru2GPKkrmdIvU1cGC9qw==
X-Received: by 2002:a17:902:421:: with SMTP id 30mr3280695ple.324.1576680513091;
        Wed, 18 Dec 2019 06:48:33 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l9sm3460185pgh.34.2019.12.18.06.48.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Dec 2019 06:48:32 -0800 (PST)
Date:   Wed, 18 Dec 2019 06:48:31 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/37] 5.4.5-stable review
Message-ID: <20191218144831.GB19358@roeck-us.net>
References: <20191217200721.741054904@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217200721.741054904@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 17, 2019 at 09:09:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.5 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2019 20:06:21 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 387 pass: 387 fail: 0

Guenter
