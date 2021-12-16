Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F76476751
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 02:12:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbhLPBMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 20:12:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhLPBMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 20:12:22 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D2FC061574;
        Wed, 15 Dec 2021 17:12:21 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id n15-20020a17090a394f00b001b0f6d6468eso866430pjf.3;
        Wed, 15 Dec 2021 17:12:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=udXZAQy4E0Faqhl32LNiPMBQIiDIHS8mQ2zOfVP9VxQ=;
        b=REdkhUvTNyU0AcmAdgv/UT5WJ6BEAy8e5t2CPPr8oh1ul/2ckLIGcRiUvGQ16e0gZb
         a+t6YrjTlD2urpuqybwe99EAgFr7Q9iLAGToMWJnyMs1oOg0/DpOPzEkpjN148UFBol2
         LclUlhxQbvFezJkizYIZCuasBwKTgmWWC9LtP44blnySktHi9RT508gtOJw2EQfgEwfG
         eKcWA8fF8Mbcw1MyDdTPXwZVfIwTTOgSG+tSgBMGRN3HZInqYmb3zUztn600QMBi7hAY
         Jqc6zanIoGc4octznLTStjcKXWAlQdDR82UctYWfobVhTuTMI7848V+WzuCdrpawytYO
         G03A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=udXZAQy4E0Faqhl32LNiPMBQIiDIHS8mQ2zOfVP9VxQ=;
        b=EhFaYh5KN9GFpe4W+wOzG+HLvoOz7AMdqkuCEvD185ioKwpjvKU7zGTMzBtpkcF7Hg
         m698AJMxxvfdmjlOdnquIIw/k9RDAGCLzYgTJbRg054B7LK4N9P3uxTVcEoe4Lp3Mg2k
         Ak07v/FLN7hDA4D7MezJtwwIMmELxk4q+iaU+4cqXTGZxXcibO7Ms7d5NkOPmuYXTj0z
         aMeTI+dmYhpb2R4VXdfWFBgsXZ6EMxSKl/gTCfCM2r6kyr52wlgUvz1b8A/YQjm7vNCd
         i8KD3EiTmZz+yDj/TOKollc4Z4mgiAwoppjQ4NfgOMkYAjAoAVQtud1vjzufDwmE8Sak
         ej+A==
X-Gm-Message-State: AOAM532lkcMOy6mLFnbXML5No9P1bWmiWKRx1cX5OHPIX/guyqU52mcS
        foMIUqgbjs9qIxNWfkjYrEQZ5BW+uV46kV/kTGE=
X-Google-Smtp-Source: ABdhPJyjew+HCIxrWGu6UJL7DSRx3OB8g54R+wvS1o+LSihBTLiULJ05Ppvo7m/5HpEGH/SbhKyoGg==
X-Received: by 2002:a17:90a:6d23:: with SMTP id z32mr3040587pjj.144.1639617140735;
        Wed, 15 Dec 2021 17:12:20 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id j7sm7428363pjf.41.2021.12.15.17.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 17:12:20 -0800 (PST)
Message-ID: <61ba9274.1c69fb81.62ec3.4c04@mx.google.com>
Date:   Wed, 15 Dec 2021 17:12:20 -0800 (PST)
X-Google-Original-Date: Thu, 16 Dec 2021 01:12:18 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211215172024.787958154@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/33] 5.10.86-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 15 Dec 2021 18:20:58 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.86 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Dec 2021 17:20:14 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.86-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.86-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

