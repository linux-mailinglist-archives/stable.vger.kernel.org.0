Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314591C2654
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 16:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbgEBOzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 10:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbgEBOzl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 May 2020 10:55:41 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852C7C061A0C;
        Sat,  2 May 2020 07:55:41 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id w3so4820006plz.5;
        Sat, 02 May 2020 07:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ImEL3kEha8swo46OkwuN7UmVsslsvFGrzhZBeji10/k=;
        b=F34zdE2TqIqf9gVO9/LI4agEqqwyZK8yaYZpw2h254OvgDbvkGCihIndMPrbTlkAuc
         78h6PZujAj3phKId8CwXmE0z36lY5Zgx6KJdSFbbC9pl27HCEvpFL3vw4PMDFI/CrKi4
         o68aUKc0f0LLGziUlMjFyNFDX3+eAsbsNx3fmRCXsrTa+YPodQplkiwpyEWmVAKiAAyk
         /vASWexRJZ/jGjt24uZtmsEX0t9/Iye4x5FEQTjy47/P/npe3L6SLnvuf+NWpsQ6N6rW
         E579Ej+8JrZd/2leB0p+z3S5zvIcfpazgzo94lycQbSbr6YIZZDTsv5KdQEt8IQ2mEz+
         1JoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ImEL3kEha8swo46OkwuN7UmVsslsvFGrzhZBeji10/k=;
        b=qom+cVJ37TQJGKX3+GYko89Iy3vxjn4X12mzkArjHxK9xP0XL7Ap9qQqtVeZEOKI4X
         XABOmxo+gacaj3Er2fhqynrCilygmS9++pq7izxIwbSqKlkJAQ2o/I5IC8/nImM8Hv8N
         F8o4pUc1T8l809688NuRvYiVsSFPPl0YsGD0mLk2jpfmdEeTOan0raQOktbfUQ5bmETv
         rDieCWWSrJ6+VQuUSpZDdY0aiHZlDTdsC11IzYXsWLA9mS3WOljV5EJUC9hKDg4t3wBe
         eFkhcHWLT2SWZbpDreF9sNCc9r2sWPOWyKwyoaXProHo6YhwpLWlnog5PrR2Muk3BZ+Q
         Wtag==
X-Gm-Message-State: AGi0PubqkeKJikprX5m0TVVxW5FdjWJqSRd5ADiP9UPp9dpwunEtf+yp
        2teI6b9IN4pIuYzqOZUDLtfoRG10
X-Google-Smtp-Source: APiQypLhdgEe9YJ5NE6xoNxJcM1ks3cfVKN0bDFCLzRMxqo+n0wUXV2khF9jYh3d+hm/GqcB5oSnbw==
X-Received: by 2002:a17:902:a706:: with SMTP id w6mr9569035plq.173.1588431341115;
        Sat, 02 May 2020 07:55:41 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y24sm4681612pfn.211.2020.05.02.07.55.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 02 May 2020 07:55:40 -0700 (PDT)
Date:   Sat, 2 May 2020 07:55:39 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/70] 4.4.221-rc2 review
Message-ID: <20200502145539.GA189389@roeck-us.net>
References: <20200502064240.568495432@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200502064240.568495432@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 02, 2020 at 08:46:53AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.221 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 04 May 2020 06:40:34 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 169 pass: 169 fail: 0
Qemu test results:
	total: 335 pass: 335 fail: 0

Guenter
