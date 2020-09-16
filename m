Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E38D26CC35
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 22:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgIPUk3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 16:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgIPRFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Sep 2020 13:05:41 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22570C061BD1;
        Wed, 16 Sep 2020 10:05:33 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id v20so3921243oiv.3;
        Wed, 16 Sep 2020 10:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cvQOZo/xIcj29IBDYjXh823Q9aPEvAcLWtHUsWZfAJk=;
        b=OL/ONQA/lo3IgRNuQHX0Y/10BCDIGUhiXTh0vbP9Vx8X8/zrX1rL4+GWEr4iOlXyen
         XA8T/Fxv1dx2Vc3rIk0ymHLt573t/MNzAHwBf7Nu79LfPTNsrvxLA+cEZOFMj8kJmHEZ
         2F3kW7xUKqxlY8L1teX04SGhsT64sqMhAryXQIykDh+Ul8BGtX3eSBSfrFWElyhPolVi
         hXPx3kVyeyLc8cszGU5w7/RQuECoM33gBq1LyHZxWdypoZPFrBE7NWKlCAGtZtkguVRk
         ePpjxQA/J4dQz8ygZUJQXxojra0H45Ait1ECt4TXmiysID+yxkmgo8JH12IsUcEKM4M9
         KjAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=cvQOZo/xIcj29IBDYjXh823Q9aPEvAcLWtHUsWZfAJk=;
        b=Z/p1jNsDSOXgdgkH3oeRaN/qdCNz3D5p9uWW2QvaA14uRnOU3kuC8GbTXv9k1b53VT
         P7vrce7CsYyELiJph7gcc5pYtmjTJBQ8X8jpJhnvDQb/Lktiso67ifzYcMD+FB+7YxNX
         N6H7RuEZ3iw+9oxvGaBD7dYTN59mNBP40FB4iCJ5YCaOQGUCjUz9/0whn1pcaMonCRTX
         ax6vXbXf3u8podo6GHgCISPWB1kEeqJjrqrjhulXwotkzOabWz8N509piqpwfAVHGFpw
         HblYfZlAHvID/RhxOiSPmzxpVdjbc6086j4M4DcwKtcX8kvcr15l5hERYwBeiYNEyeaX
         6XGw==
X-Gm-Message-State: AOAM533Ez8JHilwu1FHHhDmO4eOpxBRIRBgLomnzvXKwqzkn7IwUhtyV
        tyQFczBri6y1OktVAlO44HM=
X-Google-Smtp-Source: ABdhPJwqvHmkz7Fc6pBEnlbwuKHuMjphmEhY9Z5lh2IhIdubZSr8fsPXJ0HlNw55owSANC/QsaFYuQ==
X-Received: by 2002:aca:db42:: with SMTP id s63mr3688211oig.4.1600275931698;
        Wed, 16 Sep 2020 10:05:31 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y25sm8456094oti.26.2020.09.16.10.05.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 16 Sep 2020 10:05:31 -0700 (PDT)
Date:   Wed, 16 Sep 2020 10:05:29 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/78] 4.19.146-rc1 review
Message-ID: <20200916170529.GA93678@roeck-us.net>
References: <20200915140633.552502750@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 15, 2020 at 04:12:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.146 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Sep 2020 14:06:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
