Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 804CDB3B15
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 15:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732986AbfIPNQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 09:16:04 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45388 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732956AbfIPNQE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 09:16:04 -0400
Received: by mail-pg1-f194.google.com with SMTP id 4so19801302pgm.12
        for <stable@vger.kernel.org>; Mon, 16 Sep 2019 06:16:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ra8d/GrnIpESHXKLR4oZdag9mQ8SMgLVUROanYRdoGM=;
        b=E00ioboFc3etL+qdxuhp2+ZoiDtreRvFqGKqCZvJ/cSHjtJBJ9UvBzCJf+/2Prgr9r
         vDEI5E6uDTSxoGJDeFO+op4+NJJ4090G5z8rNj8KFNPpAhKiVSZb71g/d1Dx9pqFwQnI
         z7S/sElvAe1dZMEZcG2eLXk8wiyzBpuOSKU1SXhCXTNmmvYcuLK0RFVILD55S43Wod3Y
         vgNmsyZxBCEbTyDXVuC5k+9KiUwaMhYl8/4ncIbeiYr2dUEyIg/NK06GUNvaqsfgXTub
         Rlea4Z5Ck+M0VIN6t8/73FjPbRIGCDgcmzdhc9NcjDKTnHtl9I0LbTYUpHF3OQmGNbDJ
         b18Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ra8d/GrnIpESHXKLR4oZdag9mQ8SMgLVUROanYRdoGM=;
        b=WM+s4U7VDxltXQFpBKd2XtG+S15/9Xaeu/qhL0/YBmC61kD8xCNPc5fNOGsSUnzxV4
         YlPlx8pgIXZ9zaZvjBIYP2icdSDVmJlxbRSfhQOVqx7ctG4OL4whKxPFwVTQ5H/aQqwa
         KLfQTl5zzmq2/Hr94XFfharH+OjeThtbmXk08DwhkEGyBUG2+gYulvO4WQ4r9ap8jLD5
         n05vH8WFEbvd6CXWJ3FUFw21jw78JTZ/cC2jiXEM+l5R7N6xRhifkBSbI5yDRxOt1WKZ
         vFeWf59769YoV7Jh09fL9ZK+Zop0yhcHWyH2jbjMg9kd4HqLfoAR/H/wFoy/L+vH2J8Q
         EAgA==
X-Gm-Message-State: APjAAAX/cxPXeF2jbl5O0wVe2fh4BN0hYyRRhgimpKtz1ZZmYoLPIr8m
        LLBTYkmVLGIPP1LK6gj/BTHV0162
X-Google-Smtp-Source: APXvYqxbuFgiIAwH1qrc/KlWMoWw1BVmtShi6gqSyD2ML9hTwrmCNLT+YUCke8zywhWCE3lwfTUMFA==
X-Received: by 2002:a17:90a:ba93:: with SMTP id t19mr10778109pjr.141.1568639762333;
        Mon, 16 Sep 2019 06:16:02 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p88sm5110546pjp.22.2019.09.16.06.16.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Sep 2019 06:16:00 -0700 (PDT)
Subject: Re: Please revert upstream commit e4849aff1e16 ("MIPS: SiByte: Enable
 swiotlb ...") in v4.4.y and v4.14.y
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>,
        "Maciej W. Rozycki" <macro@linux-mips.org>
References: <4318a9db-0c54-319d-cc32-ed26ac95ddee@roeck-us.net>
 <20190916060723.GA605279@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <c7bc60c5-1219-089d-8062-17c63a3210d1@roeck-us.net>
Date:   Mon, 16 Sep 2019 06:15:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190916060723.GA605279@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/15/19 11:07 PM, Greg Kroah-Hartman wrote:
> On Sun, Sep 15, 2019 at 04:01:08PM -0700, Guenter Roeck wrote:
>> Upstream commit e4849aff1e16 ("MIPS: SiByte: Enable swiotlb for SWARM,
>> LittleSur and BigSur") results in build failures in v4.4.y and v4.14.y.
>>
>> make bigsur_defconfig:
>>
>> warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XEN && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR_BOARD)
>> warning: (SIBYTE_SWARM && SIBYTE_SENTOSA && SIBYTE_BIGSUR && SWIOTLB_XEN && AMD_IOMMU) selects SWIOTLB which has unmet direct dependencies (CAVIUM_OCTEON_SOC || MACH_LOONGSON64 && CPU_LOONGSON3 || NLM_XLP_BOARD || NLM_XLR_BOARD)
>>
>> and the actual build:
>>
>> lib/swiotlb.o: In function `swiotlb_tbl_map_single':
>> (.text+0x1c0): undefined reference to `iommu_is_span_boundary'
>> Makefile:1021: recipe for target 'vmlinux' failed
>>
>> Please revert.
> 
> Shouldn't I also revert it in 4.9.y?
> 

Yes, of course. Sorry. Somehow 4.9 keeps slipping my mind :-(.

Guenter
