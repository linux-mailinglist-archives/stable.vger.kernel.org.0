Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1356368E
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 15:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfGINMV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 09:12:21 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41989 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726501AbfGINMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jul 2019 09:12:21 -0400
Received: by mail-pf1-f193.google.com with SMTP id q10so9275067pff.9;
        Tue, 09 Jul 2019 06:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=soAPOe6ih8tkO1SzpXlTIE8MerV+aOYsemjpB1yNW54=;
        b=beBQHaBLCiFSzYk8Ibe8uqGODy8KGV8qIwkrArSb45PoZUYSSus8LpwBAohf0OVQa+
         BE9qaM9q/OdBaJHBo0MJOuvaH5NLZWHXNTUEfQf0FKBRbKTKA6Q4xJ6pBegXH9Xa5/4V
         B36xiaoNK3Dffe9RWTXTecU49B0c0+rhpICRMJuVQeMJ4ovTY+lYS4cVi2CEzGO5U/nN
         pr2mo5DdDs9YgV+YB/EsTOPIKsK7oSyJMLplV5OOoYyHAYc+2RMdiAcINKQfK6GjnqrR
         efim1dHzLlGiE0TukG3v1stTUHaB8MrMiUxDEnyNEo1rlrVvm47eZ5UkwX4FyFWj+1Oq
         UKvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=soAPOe6ih8tkO1SzpXlTIE8MerV+aOYsemjpB1yNW54=;
        b=TA8vDxgAKlPrMAH+I6XUjAOnzUnNPC0tde3wJXmWuRyFJEOKD7mdgQYHdNXuOlwWw6
         EVXlzrDdxaa5SPWBtm/W++3wqFRoEFKNmYofQxPTCgAcQRz/hPQrsGzH8jDTA5754BYX
         iIoL1AjugB3oq+GXqjMgrZEBRO1v8D5mKsOwz/WiPNVMrDt4uCbhTeWTkMK6JeoeCmdM
         YIXlkANvEXZzX2HImwEDP8HW6tQ7lY4G+CBBlYk24fjuw6iVpRpB7Cd/FIwMCVlzASou
         tidWqr84/saPq2La4Wz5Ob1t7aslQDojCshEQmIxV6+ojBLdXD9Gpx5cQm5L47Rhm7N2
         tnNg==
X-Gm-Message-State: APjAAAVUmiRZFWwQ/zAGdUejnLkSUb8M5NccoGIUJy6bO9N/+gYyyH++
        ZGECoJHQOf9Pu8vQhrFb8Wc=
X-Google-Smtp-Source: APXvYqx9kv8MNlJQO+z5Dn9rUVkyMoi69mfTi6wVP0m0DNBlh2lcfoeC8G/fMv4pNK0p74of+y8iQA==
X-Received: by 2002:a63:3046:: with SMTP id w67mr31272984pgw.37.1562677940677;
        Tue, 09 Jul 2019 06:12:20 -0700 (PDT)
Received: from arch ([43.250.158.197])
        by smtp.gmail.com with ESMTPSA id q7sm7103795pff.2.2019.07.09.06.12.16
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 06:12:19 -0700 (PDT)
Date:   Tue, 9 Jul 2019 18:42:14 +0530
From:   Amol Surati <suratiamol@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/96] 5.1.17-stable review
Message-ID: <20190709131214.GA32761@arch>
References: <20190708150526.234572443@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 08, 2019 at 05:12:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.17 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.1.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled, booted; no regressions between 5.1.16 and 5.1.17-rc1 for
dmesg, and kselftests (at least those that did run in my environment).
