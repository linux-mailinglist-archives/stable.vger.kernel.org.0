Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9B0638CF
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 17:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbfGIPog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 11:44:36 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39590 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfGIPog (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jul 2019 11:44:36 -0400
Received: by mail-pl1-f195.google.com with SMTP id b7so10303913pls.6;
        Tue, 09 Jul 2019 08:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rBSYD3TIeV10dpPGSnZAIDV4eDvbq6imUadVBmJjg0c=;
        b=uXAfduAMO3rYjchKGJ46I19EP2W/0JZBhI/rp8UTiDBtgRpWLffX81POM3SaDJ1H8e
         s4v74/CXBZtFJCBkNZUWrTYow+HeCch6W1k9TtN22Q6k3LHpNiH96Cw34WCBxMJ8G2y2
         QCea5KAL/fC45YUH3VV5aXdUGhdJIhQmIYIhdP2CQ82W8B1vmqjSdocvzOUStVCpzDD5
         6Cby6kWdZvbdcepHP06eLpAs7S4pxzlcJsI2zyPCbJsymcAoX+PN/Fm9/OOpUytYa2ki
         4oJ6ThN6S7HEBDZyPaC7TY4MjYRIcfPYifUrVyg93hHabwhHagd8NLc4Zj6hGmWVeEe2
         pmXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rBSYD3TIeV10dpPGSnZAIDV4eDvbq6imUadVBmJjg0c=;
        b=q/Mnmy/k45UzDCTyHqp37tWCzUccEztp+kgVlHqXfi2ZnxN+L6guzc4/z1H0WmTyfz
         A7Gg2zmHRAI/5ERDs/l2XXPHCRxoVvsy/BujSScGOTnTFomcfxEaaY4TKknICepQB5n4
         5rt8h+Fy4NUEPpKwyIIQuBl0jS/+M2HFSR3n5O3G0mfPDqm0y3f99jj4dmRMk9BvoLwr
         7oLrjVk/c/GCG1MmDYAkqlAYLx4Ih5XQng8A5D8KDe6U/8PK1DHGnVY8niwjkUaACHq2
         DlIVdnZa4uBE9y3wowRCoSzTVFqGsFLyNAmdNuPehDLeA0fsvyTAWpzZu+UTVx7ux9VE
         EoVQ==
X-Gm-Message-State: APjAAAVjA04kGj2ePxMXziJhB1XysSzJw8F5eGg+cbMZs1ZFVIWDJdVE
        TIXfUCwdj5JUhCXrALJKEQc=
X-Google-Smtp-Source: APXvYqytM46hXlifPvXUlCb2uoDrs7LBjdwkrcuL67Oew94Dp0701YrzEOB8rR8fG5iUfdNANcCD+Q==
X-Received: by 2002:a17:902:28e9:: with SMTP id f96mr31772255plb.114.1562687075186;
        Tue, 09 Jul 2019 08:44:35 -0700 (PDT)
Received: from arch ([43.250.158.197])
        by smtp.gmail.com with ESMTPSA id b29sm41498777pfr.159.2019.07.09.08.44.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 09 Jul 2019 08:44:34 -0700 (PDT)
Date:   Tue, 9 Jul 2019 21:14:29 +0530
From:   Amol Surati <suratiamol@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCH 4.19 00/90] 4.19.58-stable review
Message-ID: <20190709154429.GA2793@arch>
References: <20190708150521.829733162@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 08, 2019 at 05:12:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.58 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.58-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

x86_64 compiled and booted; no regressions between 4.19.57 and
4.19.58-rc1 among dmesg and kselftests.

Thanks,
-amol
