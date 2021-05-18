Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB74A387D37
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 18:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350531AbhERQTd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 12:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242950AbhERQTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 12:19:31 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90DB2C061573;
        Tue, 18 May 2021 09:18:12 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id b13so4025209pfv.4;
        Tue, 18 May 2021 09:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kkGl0q5dtXcq1wwjaee1QPCyiht3mYNUlPYkrGV1fYQ=;
        b=vGvJUNgkZxBkxU+5DTcUcfIWo9NYtZB+7mrTe8dBMAEmNAB6Yzq2WpMgPKizlNRhE9
         FMkOLjXlxEinrlQQJ2bJ/XJV+VlyzkhpEq7SFXhIF8eyqPf9QCDYUv7zbtclsbQChuoB
         N3zX8WP+8pJwheydqLaMW+waJhnhc1s4eke95wUaE5twOvtsRhzY+x+mGr6j6IGS0l+H
         Umx0zUY8EA3Ey05w5VxEtCqFCerYs0HGqAxZZzXVONcCiDC6XK46PbwmY8JmHYLkhWLT
         9n2JHL+gZfe9O0cCT0bYfTm4ymnij0BB23vdt/zdtbS6AcPU+9eemNX5GzlRINBvnE+w
         h+5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kkGl0q5dtXcq1wwjaee1QPCyiht3mYNUlPYkrGV1fYQ=;
        b=UkA7/9t2v7Y72Yp8yHTi30BtSPe1Z8a0soBbubDUoptToieraDWxF/CTYZxXFaJTEt
         ohBsSNxRAfqNkymEubWqR641ngY+02cPXnR5P0wNR9lmLgARJYEvOOpENmushtkS2glg
         PSwLkwxU8kXyrbDlGNO1zs79QTWupAnr1I53euciqKrUPMKacdjg01MG5qjPToRnkwDC
         iN0jyPRZi5KaKaoKpPmFZ3FMP8kYK6l8hk/R8eUBD1TRu5S4xQ67xpKy75hVTmKt8unS
         9Sb6pci/DHVd3mjDoVg35xjthWqafAl9rd+ZoKIMMbpg4wrRvlSrTLXnzwtD2H04LKi2
         mWyA==
X-Gm-Message-State: AOAM531mITyj/9BU6Ge6sQj4ximp6ANjRUmlo22Zx0BoZt4q+4B0gzgi
        tPcJlm1LHh4N5uJL8DoFuHpQyHvo7V/DvA==
X-Google-Smtp-Source: ABdhPJwC9EVqhaVUEwh7lnRBmN+zwFMsGPRbW+1TT/t9meat6eB1EMdrJ+RJ162YtfedBDVrTNAOMA==
X-Received: by 2002:a63:f511:: with SMTP id w17mr2306148pgh.44.1621354691699;
        Tue, 18 May 2021 09:18:11 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id t13sm2382827pjo.54.2021.05.18.09.18.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 09:18:10 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/363] 5.12.5-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210518135831.445321364@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f00e26c8-abf7-37fc-e4b6-0684b4e03c20@gmail.com>
Date:   Tue, 18 May 2021 09:18:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210518135831.445321364@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/18/2021 6:59 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.5 release.
> There are 363 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 May 2021 13:57:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.5-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
