Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A2723371C
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 18:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgG3Qr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 12:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgG3Qr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 12:47:59 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564A3C061574;
        Thu, 30 Jul 2020 09:47:59 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id p1so14672669pls.4;
        Thu, 30 Jul 2020 09:47:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=x/0P9T5r8/QsFIsqZLENWbCrNYfDsnQ5E3/r4NgnWI0=;
        b=atXJyqgr1GgzHorztadjmtSRGfJFiepkRoYzcXh7d9yKkD3x9sS/DEZrnNyP2o08fX
         1cVRExkWF1qGCdhcp7+B56eoPP4NPLRu2f8y80hUKerTM5rXc3WOyp4C+3O083lg7kVc
         But/6nNzHHWxOweCkNSrs10oZTRtD5YAbVz2Ou1462qrvi6sCHHuU4v9q0iBJTlosRYq
         47CmRRMpYRguHXi/1tKNe8DJxbzO9kAyOLOKaoQVdf6spTYUY6+rh+9fMZqytiZhSwem
         pR0HOF711S7WH1QMeNRh/liojpuTtY32mhjpI8tz462Yj8VrMGy0ViKkqI5rbFAmH3N6
         xn+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=x/0P9T5r8/QsFIsqZLENWbCrNYfDsnQ5E3/r4NgnWI0=;
        b=d2GWOnWJSFDjWqhaO9HrH29/7BrW5OFQ1+DOyTtMIC6IFSPWEsKgec1YfTxOSe0u+6
         9ktAH1dPZKhMKCueL3HymgjXn747ec1bpifRJvTapAlrPRAVBStQTUN0UPoJ5AAI955P
         GOVaneRaqpb2v2kmKbP0ZkuYcmlRaaimgdzZitWLdONeSLexcr2gwoYy604wDP3FV/m7
         pVUgJw8xEYUctXDJJMlPhVNfKsEZeFyTHlDig13PAnKBRE2v+J+evDnIUbwbdZDI7IQd
         FMlCW4T5dwi5XWVPSJ8yny65ClsYJMx10NUG6w6itVI7tO1lwb7xpDIgWdbwQIpXHkDI
         uxnA==
X-Gm-Message-State: AOAM532DorpaNo6EbKk9P5s2vkvI/ho47gc0+VKFxxcjnFBu655Md+Ly
        0eRXxVmVbPJuZXGNPTceASc=
X-Google-Smtp-Source: ABdhPJzNxK0p+ZL9zRsfbE8N37t5k6S7Pe3Ybbr/89roo4peUAc/QlpTh8+v+yhfXNMfzCkfmQsZ1Q==
X-Received: by 2002:a63:4a0e:: with SMTP id x14mr37007724pga.271.1596127678987;
        Thu, 30 Jul 2020 09:47:58 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v3sm7335002pfb.207.2020.07.30.09.47.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Jul 2020 09:47:58 -0700 (PDT)
Date:   Thu, 30 Jul 2020 09:47:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/19] 5.4.55-rc1 review
Message-ID: <20200730164757.GE57647@roeck-us.net>
References: <20200730074420.502923740@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730074420.502923740@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 30, 2020 at 10:04:02AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.55 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2020 07:44:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 429 pass: 429 fail: 0

Guenter
