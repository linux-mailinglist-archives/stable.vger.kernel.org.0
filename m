Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D66E12D265
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 18:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfL3RMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 12:12:23 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37979 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfL3RMX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 12:12:23 -0500
Received: by mail-pg1-f194.google.com with SMTP id a33so18291704pgm.5;
        Mon, 30 Dec 2019 09:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=JTbs89AH+1QPr5AGQTuMFIg+aTf5JhGPnig+kCL0ylU=;
        b=OI6pMz8TRGnW/de8m3soZt1/6XSbxhkhes5CwMGhk3XYR+8sbujxY/k7TNvnP+RVcM
         HEp/jqSGIiJu80z8XroJB4kPQTKdAz8eQexriK2TQBZEfyLMAA869IiPZUOQX/4J2sP4
         dDxP22OF5PiZqKaulP5Sy3zg50ilcW9quPrICFat9LJ1dHWURv/32hQSC9hFyKqQWw5I
         ulcHcMJ2h4UqtOCO6UVrGECWi1YDcj/C61hJpgbBpmVRnEru5gY7lco7smTZdTG3UcCH
         XfrD7bpLK5lUf35h1e25crKCLDkxAAtPVcyce7u9AKAR3DLKCYIR+WDaDa7WVBLISuBO
         Ejuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=JTbs89AH+1QPr5AGQTuMFIg+aTf5JhGPnig+kCL0ylU=;
        b=jITxMoyFOwa4XKz134Srqey2qKifdli5hoMK3OezdZH8gdLO4rEQoTPFXadf9cE7jE
         slYUwXy5sYyVgy19FEgxFVWOonSUw1jFY4yLfs2PA+DBWpzwpHzuw0E1auqB74xtmm2j
         WQEVOBiQMvEE6AKfejH9FpcOLKM7Mk4gOG2dlXrZjXOIHYOW0bT5Akoy6/Bb2jCSCGSS
         oQPnB7E+Psi1nT5mKsfpEuIEmzvnlrFxOFrrv7JMpcOtbDqvuDhC5FYtLqaVfLg+olDL
         pnOVUdNGzyq6LAySnpZ+fAfD9XprjLJA0U7dnXAGsmxLG3XmPxY7jL6f/GheL5XUCgvY
         9qJw==
X-Gm-Message-State: APjAAAXlsqviBJdAUX3fP3UoAY7mXK+mjpvA4SCdQ7Bg9km0AQxeebHA
        INGP0BQ3iFQ2tqPFZ4RAn04=
X-Google-Smtp-Source: APXvYqyruPah8jOoN7mgWxU0JlEaRmYXiEzw23ES97SF1UyzgpQvDVoDPUb2ZFLmLebWLlvgYlmD+A==
X-Received: by 2002:a62:ea06:: with SMTP id t6mr49647782pfh.73.1577725942443;
        Mon, 30 Dec 2019 09:12:22 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i2sm47238732pgi.94.2019.12.30.09.12.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 30 Dec 2019 09:12:21 -0800 (PST)
Date:   Mon, 30 Dec 2019 09:12:20 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/161] 4.14.161-stable review
Message-ID: <20191230171220.GB12958@roeck-us.net>
References: <20191229162355.500086350@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 06:17:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.161 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 31 Dec 2019 16:17:25 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 172 pass: 170 fail: 2
Failed builds:
	i386:tools/perf
	x86_64:tools/perf
Qemu test results:
	total: 373 pass: 373 fail: 0

util/probe-finder.c: In function ‘probe_point_inline_cb’:
util/dwarf-aux.c: In function ‘__die_walk_funclines_cb’:
util/probe-finder.c:971:7: error: implicit declaration of function ‘die_entrypc’; did you mean ‘dwarf_entrypc’?

Guenter
