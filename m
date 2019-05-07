Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706E316A70
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 20:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbfEGSi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 14:38:29 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39361 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbfEGSi3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 14:38:29 -0400
Received: by mail-pl1-f195.google.com with SMTP id g9so1190552plm.6;
        Tue, 07 May 2019 11:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=VgEvmYU2NRRaBRYl0OqTIzDOzn4l2fBD3fRizooIIAw=;
        b=mmUHWJIFPqTaQynpdN4twnjub7WZm/FI+yk+1Cm+2RV2MCQXPuZ+cyMPoOLxjC/pOj
         IzoZ75F9O/UhUAoN38ipmMK6iy8gRTpylJSPswU8WRqoE+K8jEYDSVV5UqAdQKKgdkQy
         Mw75g9tZ0hD8sxJizKLTEvw8dKRboe0GnjWoKb5k5GP02oB/1bl1pWa0SxxZxhKY/bmO
         czFo/j1JjMsAs40xtDW+W4ulgkXu1pEX0mAKRjIWs/Sgsp+gBhWUtKVtc2OXmGtSlA/y
         79WilEKNZSnIMYopIJnJVm5JRj07Stbr/XFgVY3QOxLm2kg/NlTItaSE1nL/w66yRVPi
         pAJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=VgEvmYU2NRRaBRYl0OqTIzDOzn4l2fBD3fRizooIIAw=;
        b=c0NUXlFGi+61xSLedN1qVvZxCohQ8q1d6WA7RjQKs9ucCoukG4mtZ2ZGpC0ef90/pp
         UVe69cPv7UAkKl5Yo3piSwxsreiGlqX/se5LB2I5M98Xj3Bz+A530qUm4fBiXI0gEZfw
         LYCIEhgS+D1rvGw0SiB5HdU5w4UKZlNvasO+9pQePZbg9DBhdTASYi6Dd/gBWmO2jo4k
         yeEMPD6WS5M+M4bfpgwkIS40Fb/qFTK+3b2GLcOBkEx5x52mLbgR9K6jtBi8qwxqaojE
         gwXBKwYT5qY53UzH2FV8P5gv4mgDsvUWaGcv987aQJp3J+wLOoXb45ArNQkTok6x5RRd
         wRsw==
X-Gm-Message-State: APjAAAVU8qFfaH8hzuex5IOaH98FBQ0IeZqU1RjRe8hcG/5gl+NW6qXK
        +OA1NV7faA64azrlmYNmLjM=
X-Google-Smtp-Source: APXvYqwlbRXpjSm90t9tJE9PcU5uSzU1/lnOp5IqfY0fxSKWTP4thJcEE2SJsgy4rREVGXI85BHVrA==
X-Received: by 2002:a17:902:8507:: with SMTP id bj7mr20435988plb.214.1557254308516;
        Tue, 07 May 2019 11:38:28 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q5sm22053331pfb.51.2019.05.07.11.38.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 11:38:27 -0700 (PDT)
Date:   Tue, 7 May 2019 11:38:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/62] 4.9.174-stable review
Message-ID: <20190507183826.GA30225@roeck-us.net>
References: <20190506143051.102535767@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 06, 2019 at 04:32:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.174 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 08 May 2019 02:29:15 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 320 pass: 320 fail: 0

Guenter
