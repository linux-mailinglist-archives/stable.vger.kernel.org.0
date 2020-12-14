Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBD42DA2FF
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 23:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436562AbgLNWIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 17:08:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441156AbgLNWHm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 17:07:42 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74261C061793
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 14:07:02 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id w16so13673334pga.9
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 14:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=TbW/QR7klkTL5Q0NcAJZPMi5v/vDDc8pXqRkGTGE/H8=;
        b=JqxzVARQe1kB450KnuTgatRR/3dUe4nyZj8g63om3QAWRf2a6rSkZLGsdJ7j/Ind1m
         ZJUK+RVd3La/v520CjE66YNG2Qd8kO12cqb1v8P52qnjK/6qpZOslh2BT6wNKa2ju3od
         m5noLshWryy7E6Ke885jmxItnKUlrWbg6swQanGe7Bv5F2HI4xylFB3qF1ABSPVBMNbD
         pHoru2k9dl32/XVfVX+axXmWVowLN19vC07l6esyLa0zFszIrCxAjwxNl2H11kR75yLE
         qffiBmnZYrAQcuzUCIr+buUH5nRZ5pvrkxd+ZIqUMfzf/qLLMgaP3KFDWyfJZlK+qyq/
         FEiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=TbW/QR7klkTL5Q0NcAJZPMi5v/vDDc8pXqRkGTGE/H8=;
        b=K8gTTpTATa+gCIJhEJBrmZb5if4W4ecjtTW+s9LC+oq2Jvw98s1BqbLOmv7lXbumf2
         1fKJyy87ufZl9thjW1NbeWCFN68Ymset3JyXABrOOJ5wu0s/amVHSuHjpV0+ujaMAc+n
         Il8zWcj6/YTbjzm0YGZdMr2i2kupzpxubmwBjPr1NyCaql5rd9cg0T+KO4QPZkKrm/Pn
         I9ncMc+sDv5zlpXmcc/ZrIJUVHUiTmIqGsWj3hXFzDHBGkGrlY4uIbiQTx94sw9oDNC5
         rW/C22tRBVixpv9K9PjSC8tgXrvCoqUWOe8uCmxgunERXWU9bSUUbJcQf/hwTSOCIFOG
         cfVg==
X-Gm-Message-State: AOAM533SzMjY2f+MSgGNbXBnYsoYikzW6vSTF/tJpN+iTre9K9xajM/n
        JshWAmmJp16g2K9wkIV2dDJtoA==
X-Google-Smtp-Source: ABdhPJyK37b+5r2+zmLtfHveiF0FNGSji0x0FQhwBesNdi+7CNMVAp2VuBim8Sn8sG5aFt8Wd6LqtQ==
X-Received: by 2002:a62:a20f:0:b029:18b:70ec:c75b with SMTP id m15-20020a62a20f0000b029018b70ecc75bmr25517080pff.56.1607983621971;
        Mon, 14 Dec 2020 14:07:01 -0800 (PST)
Received: from [192.168.1.9] ([171.61.231.84])
        by smtp.gmail.com with ESMTPSA id 37sm17722184pjz.41.2020.12.14.14.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 14:07:01 -0800 (PST)
Message-ID: <16c4bcb9a1451fe75c63394c027bb9a42b0256a5.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.9 000/105] 5.9.15-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Date:   Tue, 15 Dec 2020 03:36:57 +0530
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-12-14 at 18:27 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.15 release.
> There are 105 patches in this series, all will be posted as a
> response
> to this one.  If anyone has any issues with these being applied,
> please
> let me know.
> 
> Responses should be made by Wed, 16 Dec 2020 17:25:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.15-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
hello,
 
Compiled and booted  5.9.15-rc1+ . No typical dmesg regression or
regressions

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

-- 
software engineer
rajagiri school of engineering and technology - autonomous


