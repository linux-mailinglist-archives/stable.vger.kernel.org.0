Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B10BB6CB6
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 21:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfIRTiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 15:38:10 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35100 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfIRTiK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Sep 2019 15:38:10 -0400
Received: by mail-pf1-f195.google.com with SMTP id 205so678573pfw.2;
        Wed, 18 Sep 2019 12:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tzv2Ax1hPF2BZywfWr0OKBgmes+uOH1s/OS2Io4eYM4=;
        b=T2ltWZHZ9KXYx1KkmYR9Vgbw2/FJM73hGvuv1tXDRhu5YtbZgo51f5PYiB9WWt6UqK
         1xDi+evwNKi714P5I7Rwr6EVzXaeO3lTWlFjUIo+ga3yRwPREZV8RKUgWPGXRU6OuyrH
         kmeZ80u8SxY9q/n4wNUaveIuqhk/Tmp1C781AU9B4TbAsbeLtUC0DKNgX5tlkMLoSs75
         3Rj/wf3ctxpvwSrcmEMWqZogTmgV1U5/54r6M/6DPJ1TePdu/Pw3Tr/kamKHRxT7TWzV
         NTohy3B9HltUwGdAAAmOZa8qfwMXemBW1hdm2g70E1PpsHfMvsMsLfWQc3sBfNhX7sat
         ZZvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=tzv2Ax1hPF2BZywfWr0OKBgmes+uOH1s/OS2Io4eYM4=;
        b=akjPVDAImLoLAZ49e5pJAnF3Z1J7Asr1LhEBNQR3w96aHyKofSlaW7ytlaou6o8O+e
         BcT8+Tk8ReGbHzviH8mrz6DehbPrIvdaRvdU8x3Xq3Smi6J5Q1WJ0qnrI+AVc3b335FV
         ZkgumLFJxorXWT37jQUiwCtGHQLCMr5Nn8F0ND7yVZ3hPskmtesTvw5X+NHyknubczcQ
         tvWQMdBFEYko6l4KJ9JItB68fe8FkF5q4Jeg0NHhm9vOqncEOlXihmIhcGgSbarS2H1+
         fQ40W1tfKD7nhJXf+jCVc7uXnmGOZtsam4VjixM/50HJiu4AP51MLQzpbIQ+qd7apY4W
         +zGA==
X-Gm-Message-State: APjAAAULZdE732QQd17egMtah3R3pXS5yxa5gl9iCEOm9iXNfiIIqRzL
        lpKkN+lkMamnFXdkAWI0DZ0=
X-Google-Smtp-Source: APXvYqx288tYymYpo2LwmSTeD403mw/gSKLE8c/uQeqBDPEiivwM+Yje0FGhDl7bdcHmj4CbxEOSkQ==
X-Received: by 2002:a63:cb4f:: with SMTP id m15mr5553216pgi.100.1568835489789;
        Wed, 18 Sep 2019 12:38:09 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c64sm7031945pfc.19.2019.09.18.12.38.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Sep 2019 12:38:09 -0700 (PDT)
Date:   Wed, 18 Sep 2019 12:38:08 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/85] 5.2.16-stable review
Message-ID: <20190918193808.GC30544@roeck-us.net>
References: <20190918061234.107708857@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 18, 2019 at 08:18:18AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.16 release.
> There are 85 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 20 Sep 2019 06:09:47 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
