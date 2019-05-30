Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB8F8301E6
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 20:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbfE3S1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 14:27:51 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34028 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726079AbfE3S1u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 14:27:50 -0400
Received: by mail-pf1-f195.google.com with SMTP id c14so2077404pfi.1;
        Thu, 30 May 2019 11:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Uzm65HhSNN1fcmtt/Wa7yU7SbppJINSbRm2BJyTrW0A=;
        b=sbSnuErKWDWIZt2mopN4EdYZQM3stYUcIVPMv1WlxRUnQ1+utWW/t9SQ/+xdZNoRE/
         z4rrtFtWTV8AoL4Fw2ZVqKRpAZal+YAgGS+iE8ZcmObpeOdpu2AraB7nK66IODU/QUt+
         p36zqrfW/03F09bwF7ANH5PgD2umX1wAniB2kDVoUGlj+KHaDjPdTrzs6LARVzqpJHwr
         6jm4VFdrJBsejmbqF0EIrsPMt6MYPJn2whD9sEk76DBXljDONt0TQBFL2Wr+H8oM1XsZ
         8w+1kFaRgkVwWVxCDJlo02CycZgNP28ygF2zU6M9bmMz42QPrxy918fnUuIqJewgSTLT
         nOpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Uzm65HhSNN1fcmtt/Wa7yU7SbppJINSbRm2BJyTrW0A=;
        b=aJcEq0W4C60oHIupJgOK9VmtJ4keImzFYOupB1dN955BaYPAYtpg3T3En/3rfATk+f
         l+5bU7WMiZTVi+U3gew1KjXrlLpJuks9jy8ywWwJlgu18YxqwCC3YwGtA2NxyzjB9/nL
         f1b4NqJtJT2ykuFiihP7Nu8Zq+/bJy6NFbTZAY0AMjzne87UiRS8LwCwA7Z8GR3CSG2x
         0NbARk0aZ9SirfUgLU9131IG+W8J/02L5Mq9vlmfsq0e6aDhXCjlPlXMIe6YvS0n6bjv
         4SoHgNwmFupmBdGYH01z6kikKuBGwBFYgzuu2RVs7T7d07gyLUikrQBUTGs6PtEWAAlW
         U/uw==
X-Gm-Message-State: APjAAAW4JmhWuPtK1Qz1c4UOHNT1na3Fp+73WZpiTIhzR8Eb/bcnTM6c
        3c4X2UikcnTNmeD1onXGERI=
X-Google-Smtp-Source: APXvYqzdplx15olZulXztvbcPMjAW8y3Q0IQ6Xo6P5SFLiKz+/5oTDn5Vy4bUMmmscwsvXtDgfPhDQ==
X-Received: by 2002:a63:fc08:: with SMTP id j8mr4772350pgi.432.1559240870190;
        Thu, 30 May 2019 11:27:50 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z18sm3630452pfa.101.2019.05.30.11.27.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 11:27:49 -0700 (PDT)
Date:   Thu, 30 May 2019 11:27:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/128] 4.9.180-stable review
Message-ID: <20190530182747.GA22970@roeck-us.net>
References: <20190530030432.977908967@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 29, 2019 at 08:05:32PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.180 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 01 Jun 2019 03:02:06 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 320 pass: 320 fail: 0

Guenter
