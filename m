Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49CCE88BF6
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 17:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfHJPpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 11:45:09 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39892 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfHJPpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 11:45:09 -0400
Received: by mail-pl1-f196.google.com with SMTP id b7so46214825pls.6;
        Sat, 10 Aug 2019 08:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dLBBNfump4UN5F64u7m1ARwm4mgYf8HSTxVYTCPwdrE=;
        b=fn3a+Vigu0F345Nvy8BfDZR2GlLO2vcoHa1d8+qv12RPugeqsuu0pjM5sonnPqnNnH
         iRAIZ1ktlUjxX7kcnQZU9rwtKAlNR3642tPPSWzew7yB8ecRFwn4WZfOKHpjQjsB6gMP
         6wpxPGcqR0lGfDjyO9m9Qmz3P4P+z3czW0ubxpi6+Xhz1uhNrxsZHuR6itVETwwC4O8U
         0tBlNAN75nxr+8FC+x3HAagOKK0nc3LIvsOQ2S5Q027Cm1ZWbbtiry3LzWSHQ1bdGyXe
         pEidox9aOqgbnx8dHY8z8f+5G8/JJn4S/tHLaAMKSbxTu8sWEHfBuuJKkvNqdhc4pWDD
         JlNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=dLBBNfump4UN5F64u7m1ARwm4mgYf8HSTxVYTCPwdrE=;
        b=rMv7unS8HhBeOawSdHHOGiST8fuSaT5/NLf7EXmBte0k1FcIoRPg6NPQIyEGvxz/Jg
         GZfMypEYY55wNeKdSZiskzrHqNDMXs8uuWDKuf3wGCV23/jPCBw8vlLFL/S9/K0QVssn
         AZijmcnYANNGZBCGInaL8+EaP2crXQuFct/MI4EXTn6rDi048KaXnFBkymvTIaS/gMGu
         2kOLHzi8Uzph/bYswo/XWJgcNJAQIXcwJ3IeeLWWH8FRCkSfSOqmihEbv6MEMVpTR8G8
         X8rbGe7s2V1gbIBWLEcimwL4I31SOSbDwT3dQv6ikV9pdYF1008BmCkeQcKKiesmJdzE
         vA2A==
X-Gm-Message-State: APjAAAXS74ZHVPV32HTBAfbF8aOlTOZ3io/W7SIBApCnBZLHsrivMl6/
        h7MhIPX1Idf9twj8uV3EdL4=
X-Google-Smtp-Source: APXvYqzbHmqw1sPeV82B2yd2YGEYtDADfc9dQIgJ4ipL5gbMM4Wwk+LQAYQSzfurbdS29KWNDHqQRw==
X-Received: by 2002:a17:902:d90a:: with SMTP id c10mr23985905plz.208.1565451908664;
        Sat, 10 Aug 2019 08:45:08 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g1sm164147092pgg.27.2019.08.10.08.45.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Aug 2019 08:45:07 -0700 (PDT)
Date:   Sat, 10 Aug 2019 08:45:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/21] 4.4.189-stable review
Message-ID: <20190810154506.GA11992@roeck-us.net>
References: <20190809134241.565496442@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809134241.565496442@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 09, 2019 at 03:45:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.189 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 11 Aug 2019 01:42:28 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 324 pass: 324 fail: 0

Guenter
