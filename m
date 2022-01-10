Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFAD48A3EE
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 00:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242777AbiAJXti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 18:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242706AbiAJXth (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 18:49:37 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA51C06173F;
        Mon, 10 Jan 2022 15:49:37 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id j124so20771305oih.12;
        Mon, 10 Jan 2022 15:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W8oggl0NuZ/uufaaKQ2UzuxC6K0AhfMqCA07YFcLeNI=;
        b=Ejy4FssA6oGDFOhXJcqKaw6woMrrKSBu1kzrjeZUUoBfnoESNShh8RInijIfcC2nv/
         okgJAYSpYpo/+DjnO+aA4BR2uP1snwkUs9L5F3yszO2yXINDFJ9999WwhT+glu01rFok
         VMpXz8rnU2e97NEqsJj9ViYoaxwzuTYSS5ZFy3u80mDfTn53825yege6ASZB3GuGtpKx
         VubX79XHsCA+dcGCc+nRFGybywUya2Isyx3cOS27wLXx+8QuU5Us8/+A2unNuXxhPR7v
         KXSNlG3AXi8R2Fhq5VuIq+x6XiownjzqFPj08DIOrwiqSWDvlwyDzlkbK6cabJQG7zAS
         QF8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=W8oggl0NuZ/uufaaKQ2UzuxC6K0AhfMqCA07YFcLeNI=;
        b=BrM3ENI/vitzhAVluWnGaLdflyuSPFRb0q3SLF43FFHjFNWip12FDTasGh61zqjCoK
         p6mqLjnR0Z74KtgoWaeOD+//9BPtvdZBA3seTRWhCrPiHw6qX9JAFRiPEH8c8Kim3oGD
         7vr/zZYbXLWjZqJopYZkV8qc+0Fm2H5RWEDbaUGRbhBWh+pG7OYxNWpIx1DIzTFCUdW3
         7xjZXuawVPqWlet+bbWZbjL5L43wCSFSLEgtWQo9STAiQLcu+d/Zh88/LDol+ZuBMZCE
         h8QgMimU8ugBx2/ZU3fQwq2lABdZKjy3x6flRVJAjrq/6WdTcZwZ6r+GWCmgz3T/Uw3n
         K9nw==
X-Gm-Message-State: AOAM530cFVGsSSi5z5cdadKdrcg2nQiWi0y5D59p4DKJMG704k/ordnv
        e2LDrhck1Ze/+q+wy8vtAcs=
X-Google-Smtp-Source: ABdhPJw65Pn4rZDGH44M3pvpzoapwegl8yvHRKJ6mDc8sjDSa0GQG/U0LIerDOwrGv1pDjUbr+kJOQ==
X-Received: by 2002:a05:6808:193:: with SMTP id w19mr123776oic.58.1641858577082;
        Mon, 10 Jan 2022 15:49:37 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w20sm1804076otl.40.2022.01.10.15.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 15:49:36 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 10 Jan 2022 15:49:35 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/21] 4.19.225-rc1 review
Message-ID: <20220110234935.GD1633615@roeck-us.net>
References: <20220110071813.967414697@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110071813.967414697@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 10, 2022 at 08:23:01AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.225 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
