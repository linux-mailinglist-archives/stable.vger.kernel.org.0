Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74014184BE
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 23:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhIYVtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 17:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbhIYVtT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 17:49:19 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1939BC061570;
        Sat, 25 Sep 2021 14:47:44 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id n64so522216oih.2;
        Sat, 25 Sep 2021 14:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KVRa91TX06L7C3Qi6F+PECYBPOfAVakjexSjcL5/t2o=;
        b=Su6i1/LGOOJK85vo7RgndkMwwl+Mc6SsUktHrB+o8Z5iTl74+nzt7G8VMGlEikJ6AF
         o7hCwoQ4CE1Z2we74o1t8Uwrg3Rt6Wz2ZM8i3NJGis6SGqqcT94ECgWOBUdHbejfP1Pk
         ihcOHecSar0rJ85sgbkmvNpl5UXWquUeSTNTlQ/WqNCOThu2uaMCY4VzMjG5hn7Nq6S/
         zVOn/BfQ9Uyph8ECz9ZCVUIV6chQMbL8YjVEG28KuD4pRV5LazozIaumiphHSmGa753n
         C5orOYvF6B/kKe6XNjVsgLzTncOt1EsW8U0GC4fZ1sMGlAJW7ZbF6h2UgxGySPgG4mO8
         yLnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=KVRa91TX06L7C3Qi6F+PECYBPOfAVakjexSjcL5/t2o=;
        b=N1nYZTP6m1sFz9xNMx18e7N3FZs6GbXCTigGNcwcCb8U4xkgRSBdcMW1wkhPZu1eRV
         NM/d0SfTuWI6tsnB+6OZ8ORBpJRkLx0XwEI3mOJBMbFOdxWBUdoGDjVNZPTXij+p74dj
         JhTe4WoGNxjUu8zd4+9Yv3Lr7gxP3WP+mczBz2KuPG0l06HI6PAMriGOXfME54vcoIjb
         T4b9AMbCOPPPoZA2Lx+Kl+2TOGb3WhEnK+COfKHLKp9N4FwleWF1TARa7Hd6bi4sEUW2
         fD4ft3sH2aHak/KWkdj07NyzlK5PeCoROPjhgsGtE0L5YxrzE51gPm/1sw5kLhPUuFbx
         osEw==
X-Gm-Message-State: AOAM531H8EeUyrhwlJoVXFeUzF2cpNwrYYE6/P3UQUgSNoDy0ekX597b
        HiLgXsTaJhzZgCNKsdrHw9g=
X-Google-Smtp-Source: ABdhPJwOCjurWZA62F6EOmSB+eArWTGFunI1GtEw5yVUZolGMEnh0MTBQdM9dNkJaMOZW+aHKuUjgg==
X-Received: by 2002:a05:6808:30d:: with SMTP id i13mr6798157oie.0.1632606463470;
        Sat, 25 Sep 2021 14:47:43 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v14sm3113121ook.2.2021.09.25.14.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Sep 2021 14:47:43 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 25 Sep 2021 14:47:41 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/25] 4.9.284-rc2 review
Message-ID: <20210925214741.GB563939@roeck-us.net>
References: <20210925120744.599320551@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210925120744.599320551@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 25, 2021 at 02:13:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.284 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 27 Sep 2021 12:07:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 394 pass: 394 fail:

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
