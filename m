Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B42213306
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 19:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbfECRQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 13:16:33 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41475 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728417AbfECRQd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 13:16:33 -0400
Received: by mail-pl1-f195.google.com with SMTP id d9so2990312pls.8;
        Fri, 03 May 2019 10:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GNlMdZfsQqjoS9c+9HGOtApMgl/OXNfonaWmiMWHe4c=;
        b=vOh/egGEiwhzR0nKnRnku35WuWdJ44qZoBPU8Su711pkumi7OjLA8LLfMR8VK1sotK
         LraeeEHp476INHqkBBK6noMgwboKbM0xpic7pDp9EpyXa9ytMxgbO7bQyqo/Nf6japH3
         EpJ76qs8Rn/2/ekpxot8t6xvs3r/xrBPsJv212KuC8LMWlyr6ItG5v2ZsEL7mohtHx5y
         PMuWLBQ3n5SvqjHyt0+v2B+IYPGqTgxvOQoSdDw0EaAkNVz5a57WeRLVuc8ZKukA34bZ
         /teDjBU4ZV+wIN8avKgMUSBUvkz6eLjwbk0xdcaalP/csJySwE6U7Wo7nipNCcwaTTnv
         ywfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=GNlMdZfsQqjoS9c+9HGOtApMgl/OXNfonaWmiMWHe4c=;
        b=fxmbUxsndUcNOA/4BV0c6CvjMEwHM6Wcx38O92iO1/lvGPu8wdQehlZYKFFTuxOiyL
         utMzdwPkhwOd+9ybhR5rkW0yDx+5qsuKKYx0vwprrsvO9dl4bTrseVSTyT08402HxmZ5
         nOnY9i+lThG95OUpUC4HAiNh7QZAbktAWNmJiKqE9IPg5gRbnIz99L98w6z8Ap7MOd0O
         TJ8P3yvHKYi9udhXovBfqmJqQPjFehRNSs5Cc0nRp0WEapKHVinAffeNiPBA67oz4Wiu
         CoQoRGsAiDnFFx/kVNzOBu7ac5/2kj1mNgeCaHVJFAG5RaiOJFC6G0rcm1ECdx+hFTni
         IrGw==
X-Gm-Message-State: APjAAAU8TzzG2o9WAkVm22FH3jgeS+rGC+XExEvd3k7d960hpEq9/kJJ
        097sNR0bI9Sq19ABtpssQUk=
X-Google-Smtp-Source: APXvYqynhvofAcRbw/HNFSl/R1QfW/iLjTwzlBLzxqKmzFrbNtFmB+AjXgIJPQKv0aUcT+NE+MWzOw==
X-Received: by 2002:a17:902:6bc2:: with SMTP id m2mr11962621plt.194.1556903792824;
        Fri, 03 May 2019 10:16:32 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y17sm3575206pfb.161.2019.05.03.10.16.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 10:16:31 -0700 (PDT)
Date:   Fri, 3 May 2019 10:16:30 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.0 000/101] 5.0.12-stable review
Message-ID: <20190503171630.GD2359@roeck-us.net>
References: <20190502143339.434882399@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 05:20:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.0.12 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 04 May 2019 02:32:10 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 349 pass: 349 fail: 0

Guenter
