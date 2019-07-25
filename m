Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3389754BC
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 18:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388311AbfGYQ5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 12:57:51 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37183 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388306AbfGYQ5v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 12:57:51 -0400
Received: by mail-pf1-f194.google.com with SMTP id 19so23055726pfa.4;
        Thu, 25 Jul 2019 09:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aKLAkdgGuztboXUQ231yrhN/tIPVnnEKocDh0muuJAI=;
        b=a8C1w4JSufMm02r4M0vK4NHF0sBpZD/IvloJN8iutYssW7arHCkP8D6Ud992G9zZtb
         YOZ+8y1QWU05CxYpRl/NJWKd6PHH0sjZJ+MCHcaBwPCvwRGHshlfG8hLK8ogG+vnBgTi
         6J/pFhRXwPIX0aOfb5sBjkHnoaqlEO4fRA/pjl7+oh7ZKs/HgJcF7DnrsnpKelV5mmm5
         fuE38wn3rrfM6YUBf01esfN2RFKNFQWYsgo45UMwP6rW1RAaiKmsppyzE5cc+uEr70g/
         FbQ8K1c0+j9+Vx3KFKI1mLHK9U8jbvWZXJFz8lcn+k93JxyonCW2GEFoLYoVpdCNejQQ
         zDQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=aKLAkdgGuztboXUQ231yrhN/tIPVnnEKocDh0muuJAI=;
        b=UrzS/k3mimUPrQ7gtweU3G7nwJEMd7GSCG1BMvZgY2oWleObi9LaG/F2cRFU/ehNzX
         nAdjHDOTzyn4SOkSIffIyTA0UmMQkhW4cn0iSeX9Gy4aAzhOACzdjMd0Jpah8fN8z7LF
         mhrHZm9aat7lqZtLoGiNty42ZIyP5/zOhkIWilzcd6l+dLnJjmBNMfybGy/KP5757Zvs
         9wwV6GsTc2Oub0BUi8AmQjlx8iD1X+Gg5um4T0KFrNjq2MSyspfJBDc0en9Vdk1CbxAK
         gJRl7Er8sM3k9gJdTmFYYeEsXb8wcfxtU3FM8dtIQy5HG3VMY08yfEAlJVqwmeuNbRQY
         8chQ==
X-Gm-Message-State: APjAAAVrLW24mHJHh+0P3r/vF+N4qpbNteH9UIpfKBd12LI/UelWcP/O
        cisSgBf2h2wEMr7iDzBBOaISvXf0
X-Google-Smtp-Source: APXvYqysSSuM1FUvn18dh50+Z4TMcS3HUBv9iJY0omiwVZj/KMvAWZzwbJ1sZ7SsN1WFTYaQ/HHTdg==
X-Received: by 2002:a63:6c7:: with SMTP id 190mr86048967pgg.7.1564073870805;
        Thu, 25 Jul 2019 09:57:50 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l1sm65188868pfl.9.2019.07.25.09.57.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 09:57:50 -0700 (PDT)
Date:   Thu, 25 Jul 2019 09:57:49 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/413] 5.2.3-stable review
Message-ID: <20190725165749.GA12684@roeck-us.net>
References: <20190724191735.096702571@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 09:14:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.3 release.
> There are 413 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 26 Jul 2019 07:13:35 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 364 pass: 364 fail: 0

Guenter
