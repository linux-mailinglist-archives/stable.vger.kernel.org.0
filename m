Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 465E0B2B89
	for <lists+stable@lfdr.de>; Sat, 14 Sep 2019 16:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389107AbfINOHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Sep 2019 10:07:52 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43373 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388939AbfINOHw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Sep 2019 10:07:52 -0400
Received: by mail-pg1-f196.google.com with SMTP id u72so16801318pgb.10;
        Sat, 14 Sep 2019 07:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JbUbAw0VVXINygWGBsvGaLceUfQ4N6Z+giypAUiOofs=;
        b=i1KlTQK1M6UgtHNOxJDqH7tBY+c7d7f0b1qCOstXcXxAm/CVO+na4voF1TtiujnIz7
         uiPzGYpB7r5xZIljyOvgHof+7quJSVd+J5QGcNENF2MVlDNE/vJFJ0i/D/0qr4459c2m
         slvpjuuwWBG2eXsczJz6HnLSmLnRR/Lx42bjloU1kQLzGlcFxt7KItK2Fr5CW4UimVUa
         v+JsCJlVHvRrGStnDp5SbyVN/LJYj0RnXAMb/WC0YvD9qSrT1zYNHaOXfD/btFOJeKXl
         SLPwgnJ0sUiHcfD6Pz9LkdJq73lPTQQF9QXYE93NeURn49aWivPfku5oS4r/Vp2Dmkcl
         DZqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JbUbAw0VVXINygWGBsvGaLceUfQ4N6Z+giypAUiOofs=;
        b=csB4OFmtDAqas8DPspVSWKH0o9+aPdSIuE1L0hLF5fcgPRwytLtmaC2KkdzUlGOGoF
         IDreVHzeEraU6Kn0we9Yql4RGhvFwGxPBmgNT2wOYuW5BWLvcrDdYvu0x/ygY7FAIEwG
         tiBibudSI53IfRJabmvVtQl17tx0M/rjnxkwKx072F9fSPDkAMrQOGL+TRuO23/nhUDz
         b8hJ4Ds3+/p1iw+6Uye6IPyjps2lboUhlVlqZtbHf5HXEIHNTm80ovR0R3pQ6IxN71jo
         daIf2/T5B71Ys+15RmFs5TxUwcYy7idDmOMELoGBkqiU8cwZsIrASA6P20RbJayadIqw
         PcgA==
X-Gm-Message-State: APjAAAW+ob2JMyDW3ShO1ahaymHxRVGQsOnsZbNaVSmWMMGgFLOvWH2m
        nkiQWiLDIRRmgSIkuM1PO/j3rUIk
X-Google-Smtp-Source: APXvYqzBdanY5eREQr5+FkzZm30b19+pBgOkzabAbBBp9lXPg33eAskY8nhOUiv7kFPwnyQ3sP2pMA==
X-Received: by 2002:a62:83cb:: with SMTP id h194mr9764019pfe.66.1568470071268;
        Sat, 14 Sep 2019 07:07:51 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z23sm35431679pfn.45.2019.09.14.07.07.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Sep 2019 07:07:50 -0700 (PDT)
Subject: Re: [PATCH 4.19 000/190] 4.19.73-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190913130559.669563815@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <843e1f24-600c-9b07-83aa-5a77e76f3247@roeck-us.net>
Date:   Sat, 14 Sep 2019 07:07:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/13/19 6:04 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.73 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 15 Sep 2019 01:03:32 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 152 fail: 4
Failed builds:
	arm:allmodconfig
	i386:allyesconfig
	i386:allmodconfig
	mips:allmodconfig
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
