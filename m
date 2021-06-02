Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA84397EF7
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 04:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhFBCYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 22:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231288AbhFBCYd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 22:24:33 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40ED7C061756;
        Tue,  1 Jun 2021 19:22:50 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id x196so913203oif.10;
        Tue, 01 Jun 2021 19:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JdjyYpCvGrZYNyKb+OU/RBOeGnGuewm4hjV3HNVnCrA=;
        b=n2erlzyNRw8MvzSR3xTftWyyoaNhW56pHNjEsKS/xhBJ9PXzUrCl3CEMfpVd7LuNAS
         AcuoC6eMXKFztfImb9w3jgF50Tne+WeZHPuzeOfyUT5e7gSmj37G0yuep2E566uCZsiK
         svuAYWJyDLgagJEHQLLyVqy8b09gIu6yMOfbZw3LVE67uWQWRM8QQf8/egsMGPmXxsJz
         H/e4XY9fOib3bh8DZfj40Ze7ubgesBOdl8vNeTcLJz7AMoEoyK+SmYBhUguRzKS0YhK/
         tKC5KBCBapXhvpmiE9knLxokhhSXBVJkMl3VEr1Yp+LQGXg809dWv56jd2QUA1n9dH7u
         1QTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=JdjyYpCvGrZYNyKb+OU/RBOeGnGuewm4hjV3HNVnCrA=;
        b=TDXEhj4yiOuZvklrEnwbg6TLTDkJIgg8/ldgtzX9TtxasUkwJOJRy++QsB3KdmqTK5
         Mf7WIo4jQqIbGKwMU6krYtNe7yRBhTvxG7VE9O2NSswa06T69eQsKV4sfNgx9WbbkKXs
         ZoEUxViCWLl+657qH6fwRyjI56FmSv8VR2CpP+UJCcsLnaY/ui6K9CdTPD5Fh5C3m7Om
         m02MqOtwm/I5zbr6sbA510LTD6+wmHweA+oQAWMEQTHV8/CJ4/Kuzr27fhZVlU34tvsn
         LKArXj0C5M2EQdnMXKgJdoqaejONo8OdzqjCczRtxDryyKQoU5R6cHIHmiBBt8vemclJ
         JRYA==
X-Gm-Message-State: AOAM532WAldCbMLw0qOjFM+QEFK11tfny2ZApJEUYD7Yei0qgo65atKp
        tNMFgJN3RbjkjVfQ6vamrsE=
X-Google-Smtp-Source: ABdhPJxx54AbruB1jInOlZgNsQ/BPa/BOHGKHQsME0Q/OtZjlzT2WSAIwpWfNOFbSA8q1u6OEmM6Cg==
X-Received: by 2002:aca:f4d0:: with SMTP id s199mr3954829oih.149.1622600569692;
        Tue, 01 Jun 2021 19:22:49 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n186sm3757648oia.1.2021.06.01.19.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 19:22:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 1 Jun 2021 19:22:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/84] 4.14.235-rc2 review
Message-ID: <20210602022247.GC3253484@roeck-us.net>
References: <20210601072913.387837810@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601072913.387837810@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 01, 2021 at 10:34:11AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.235 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 03 Jun 2021 07:28:28 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 406 pass: 406 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
