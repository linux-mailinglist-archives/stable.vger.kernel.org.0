Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369DE24C687
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 22:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgHTUFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 16:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgHTUFQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 16:05:16 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175F7C061385;
        Thu, 20 Aug 2020 13:05:16 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id y10so1419992plr.11;
        Thu, 20 Aug 2020 13:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3ouFUSplgOJrWAOCIysZcSKryYkqIQMMAL6CbaExNnM=;
        b=lcLePvkvydmAJ2FToRJuOyyzTmoSIdIEeNwW2xpWbhEhkXd//yUPs0pt2sGBrRWi7X
         iiCKE0UeZug9RZtDgFSSl3roUA9dajL5Jus9sQpIVLOg8pdCfA4gWsw0/4va0YqPN9kb
         KuVlC5LZzEXVXbpe4hXV6FNjwPkrOxPlMPnDB+lUAH3sqLddo5fsTxSpGPHvPXWOnOWb
         Ypn2tx5eHmjeiBb5uGG7ljywkrRT/Ngc67y04UgcRu62dWozMiz5ZbIqXJNlfEIZqj+c
         SLDQWXyfkHvhZX6tVv2NcN3/KMTUCF4pQw0pRu+WwH1oOz7Y62NK3hniIPffKXmRURzk
         evjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=3ouFUSplgOJrWAOCIysZcSKryYkqIQMMAL6CbaExNnM=;
        b=S0btebChA+CRwC71hsx36kg5lrFFaJ+XshIqGZwuJB8tkBP5HRSuX4NONFW7VVavuM
         jMwZIklu9cujH/iz/EoZT46Tjj8nrwx+tvdSWup5nqx6Lm0GcHB1TWSz5/f1zqSbJG/a
         dFWxzvOzF1sA4wBVXuop1I/yKQEhrCiWjLws9dXjlzNE+YaalAIcTBVPVmzi7/BJC9kL
         FslXDkCAVhAweVaY+9hpyIg5V63w1LARCyS69kk95BHReV2qKdMULMcWgbUmTQDklcTp
         8P8CYocac7f+plKt8FMaDWK3ouYnMXJhPNPIxccdvlOpcBZCPZ0QbR8lGURqlVNU4Rz+
         ivMg==
X-Gm-Message-State: AOAM530bUBkUQ8Pj07bAGHHy/KkvbUTwaO0mHKX+YSFiFM66es8E81bB
        Zod/3Y9ytRNs1MniVNZRVz0=
X-Google-Smtp-Source: ABdhPJwyncc0M7oIy99NFJjuQwOUiwH79pPQSj4L6VeHV0+L5f9AwHNY0Xn158665pXlf4kU0RaVRQ==
X-Received: by 2002:a17:902:5985:: with SMTP id p5mr28498pli.230.1597953915709;
        Thu, 20 Aug 2020 13:05:15 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l19sm3738857pff.8.2020.08.20.13.05.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 20 Aug 2020 13:05:15 -0700 (PDT)
Date:   Thu, 20 Aug 2020 13:05:14 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/149] 4.4.233-rc1 review
Message-ID: <20200820200514.GF84616@roeck-us.net>
References: <20200820092125.688850368@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 11:21:17AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.233 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 09:21:01 +0000.
> Anything received after that time might be too late.
> 
Oh, and:

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
