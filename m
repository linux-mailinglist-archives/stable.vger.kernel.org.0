Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAF982AC509
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 20:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgKITdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 14:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729831AbgKITdx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 14:33:53 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931D4C0613CF
        for <stable@vger.kernel.org>; Mon,  9 Nov 2020 11:33:53 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id b12so5234748plr.4
        for <stable@vger.kernel.org>; Mon, 09 Nov 2020 11:33:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=sl29wqUIKXUufuIQiygXdmzoEm6rqS29bZj53/PfalY=;
        b=rvyUomPgC8XCrgeDWSNTQj9AEa0PMaWcO2LJETBW/O24i2TRt7q83VLZuqMnC605pU
         VJ/18KhJOoVqtSMVsXfKbVpm8OcxQ/c7rjx3LSVf1IS+WgS09PvHfizixSx6EW3WBiiu
         SFOON18VSD8xTn+SuRIUR8KiQLJg5+pdCjCTKBIMMHSV74AJHW6qiIpXt/Ozg/aEo0jx
         Od93Wluzar++QafE6AncvhnZ1Jy3ExYKVbwqSfiOqW/CkDSVz6DdDdQvHJSPelOFcj9x
         rqnujpBB62NTuOyCCPPwOroda8ygcHTauUt81ooXNPKc8Fo9Rae5vGOg79KycTUHobjM
         o+nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=sl29wqUIKXUufuIQiygXdmzoEm6rqS29bZj53/PfalY=;
        b=gJZgg3y/E8bIqlUmAADhc4e5iHmTDD0HHDVzpnQ3QqkXZ8hXpsU0yTSPmbsmo51yRL
         Lya46C5FCTVkONNWQROpjpkkid/m0iAPwGZgpATrmvuvco+U6KbY8AqY727wyFDNClJ9
         pQIQByYytImg1HAWIwL2vnXMdPqaM9ur0kfToIJlopQASSDRG6EeTKWGQob7+MSELOHH
         FBSemDJgh5cPYDXpqU3qo8YVjJIBmAJFpr5d9CvscFJ/KYkf4rEZVIp10jmK5MbvS2UK
         Uw0OQUiBHHCTd6Jqa/JBxibszOEW8eJWZnpvVu7WSPMa4anfLXK1OMvlYrcOdGh0z6bR
         B6KQ==
X-Gm-Message-State: AOAM530bPr4VDmndaWTzgJ/9OkR3RCd2ql2Ti+kQZ2oQUIn/pNf+LUQn
        U9B6CPg6CiMFrZ1/ssUOMgQ0IuTtFwtS4zyK
X-Google-Smtp-Source: ABdhPJz5xme62fW/912aMQTOQ0tv95Dx+TQLWZI60GeTY/1ifbraWz13s2vTPiFgr7CGuUWQYa18/g==
X-Received: by 2002:a17:902:ed52:b029:d7:d0af:f89f with SMTP id y18-20020a170902ed52b02900d7d0aff89fmr10082637plb.26.1604950432884;
        Mon, 09 Nov 2020 11:33:52 -0800 (PST)
Received: from debian ([122.174.251.176])
        by smtp.gmail.com with ESMTPSA id l17sm264565pjy.29.2020.11.09.11.32.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 11:33:52 -0800 (PST)
Message-ID: <00f6908d6a5bab39b585ed03dc5533b6f256109f.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.9 000/133] 5.9.7-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Date:   Tue, 10 Nov 2020 01:02:08 +0530
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2020-11-09 at 13:54 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.7 release.
> There are 133 patches in this series, all will be posted as a
> response
> to this one.  If anyone has any issues with these being applied,
> please
> let me know.
> 
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	
> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled and  booted  5.9.7-rc1+. No typical dmesg regressions.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

-- 
software engineer
rajagiri school of engineering and technology  - autonomous

