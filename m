Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E63BC107702
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 19:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKVSJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 13:09:41 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:41408 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbfKVSJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 13:09:41 -0500
Received: by mail-oi1-f196.google.com with SMTP id e9so7278066oif.8;
        Fri, 22 Nov 2019 10:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LzPGe9jNoFe06HsvZcJh28F5+rCWRe7dlKz7ip1T8jM=;
        b=aocSHzwQyqD0J1tEblob40O5AI2fghfC/QQIzWQUKEW1DCUeY0H1su3oHYU8XF+LBa
         m851LWRqjMKDlQF0lX7GVJnXty5WbLhxj9CPxbEigzW8Y/2zYFGIRNigJ4bq1BIwl5aa
         uIoTApjUraYIgaEtuyXBrqjoT94+gqHAj8cKIRCfOWOJNv1nqHv+X0daAFdCOXouHsyT
         teu+063Byr52i97MnLImFGLhmZTK/Bt2LprB/Pjgq9dvLRldrS13PX+BY6vtIjodBiOF
         kNcJ/YQ1w3q2aa3BIkOaqmXRiYHVH19TH5nWrEyXqkmwYarxiIRO6NRadc8QJBG4g/s/
         +kIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=LzPGe9jNoFe06HsvZcJh28F5+rCWRe7dlKz7ip1T8jM=;
        b=FrJkda23T6pM/jF8C8wNMlyEmUrllv74iQqGEbQ3cr+Jit0zM+XnpIQfPWfxM4RH1+
         yPJl15MpgXSNaQ03ZxbIICDFZdB3Ejpx0O5XPflLgGqgaG1nNGtW/mEff9UM8d0VRPgs
         C4sQ8UHAL/JyXdfmLEhrkb17GvgqqiPnw0Ko9+ssfjC34Gq1fcpqvxxzGCVCGy0EWoI2
         8h1IjM4CcjfpcM4o9tdBxDrJe+h2ORrCYlsKYbEV3WaeMRXkGbX3tWTyzG0DS0uvbWo1
         lg1xZl1W/jAsT5LGa+sFyNDkcjraO32oUYgV+Cif10Y21xNRcT2OJEhodPMkQpREf8sL
         D6/Q==
X-Gm-Message-State: APjAAAUcxkVeqQV1YD9WDcsWsoWc3vFT9PFlhY9iiggSU8io6mvba18T
        lf/+3MpIi1slVGK8z25yHaFL3w0n
X-Google-Smtp-Source: APXvYqyCyqE8PONQTIi7O0k94MtnqcIAM2ZCphgst7ZRhRg9xTaEGo4DblFfCysVbt8OySM/oCkiyg==
X-Received: by 2002:a05:6808:995:: with SMTP id a21mr12631144oic.108.1574446179966;
        Fri, 22 Nov 2019 10:09:39 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e19sm2387811otj.51.2019.11.22.10.09.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Nov 2019 10:09:39 -0800 (PST)
Date:   Fri, 22 Nov 2019 10:09:37 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/159] 4.4.203-stable review
Message-ID: <20191122180937.GA13514@roeck-us.net>
References: <20191122100704.194776704@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 11:26:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.203 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
> Anything received after that time might be too late.
> 

For v4.4.202-159-gdbaac4c54573:

Build results:
	total: 170 pass: 168 fail: 2
Failed builds:
	arm:allmodconfig
	arm:omap2plus_defconfig
Qemu test results:
	total: 325 pass: 307 fail: 18
Failed tests:
	<many arm tests>

------------
Error log:
Error: arch/arm/boot/dts/omap5-board-common.dtsi:636.1-6 Label or path dwc3 not found
FATAL ERROR: Syntax error parsing input tree

Guenter
