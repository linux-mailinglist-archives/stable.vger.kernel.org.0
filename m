Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFC63D7CFB
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 20:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhG0SBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 14:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbhG0SBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 14:01:04 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1591BC061757;
        Tue, 27 Jul 2021 11:01:03 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id jm13so139330qvb.5;
        Tue, 27 Jul 2021 11:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jtoNOraOOipggBhPxO8JRXIdEBQBWOA3QwKef8rI7Jg=;
        b=UKSmzV9jSrQSOnfG6nq7OV779ghWUrKaZT+yTaflDMBW6en/psI4bYXWfKgmMGIDfl
         frBqUW7A+tAnGAOhuf2EAq4aWWkoXyOj+lfYvjmACN3Mv8vqmZcK2mCVP6hRvyzKrHQ8
         1EYZlRPl8AQHNWIVYVzd4zr3EkgaKmBihFrgi5IrrdKZ4C+uSHLXFnlj5s9UL2A5IyL0
         rr9xLTTXkRhPQYZeHeHH8EoLJxfzHIeIO7aqP91UBs86kmynUV5IXbxcabVDfcwrHuJQ
         2pPk+hIk6BSqc5ehYQRNUUqD3dZehr/vzCY60UaIu4lQOFLn6GLCSPwR/Ak5LYcL5tLL
         ZOzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=jtoNOraOOipggBhPxO8JRXIdEBQBWOA3QwKef8rI7Jg=;
        b=A1Oepuu4k8YUfa6dD9uaRaFhFsiXpce+Slwmu/YmsF/1ED1pMq/iEru34SptReWh1O
         6aWGaqnKSRZp4PkVP1CGBfEHgeVHI6vZUriZ1oGm4XXcrLAR9Q0jBg4RWOtaDD8xbEwA
         AuxxAT0QhqeL5xqYPukFQ4Kl50D92+MVpTjsbi3aLz1sRUAUUdBWIpfvsr53LCLfMLEM
         rwRfPys+938FaH53QZg1FUy3iHli0+CnyOnE4Hi0fXxwYOGkixNPGTgiUwa+ItA2UyVk
         ew/jSgGxkIbxO6havWYwkroi5Q7N8TIP6yJDQqfiueJkSavbG0QPXwkJ4BmXICsUMJyQ
         RXog==
X-Gm-Message-State: AOAM531rhGptln8cBzGiVvzDCfiGZxgr0Q5AA+ESpTYDRzek9JvMMKHr
        gxJAu9z1NnBNt1gfQ5219Ao=
X-Google-Smtp-Source: ABdhPJw+u/A3oDPlLR4xk0LqDCXBCvRlSy1q02do1btytUgwFHSJRxhPAyvOyyYm23ilJS5ksxfdqg==
X-Received: by 2002:a05:6214:b6e:: with SMTP id ey14mr2740970qvb.4.1627408862345;
        Tue, 27 Jul 2021 11:01:02 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d16sm1624708qtj.69.2021.07.27.11.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 11:01:01 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 27 Jul 2021 11:01:00 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/81] 4.14.241-rc2 review
Message-ID: <20210727180100.GC1721083@roeck-us.net>
References: <20210727061353.216979013@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210727061353.216979013@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 27, 2021 at 08:14:15AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.241 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Jul 2021 06:13:39 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 414 pass: 414 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
