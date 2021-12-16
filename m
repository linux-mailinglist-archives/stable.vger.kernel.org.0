Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB204477B4B
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 19:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235967AbhLPSIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 13:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235319AbhLPSIb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 13:08:31 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CA20C061574;
        Thu, 16 Dec 2021 10:08:31 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id bk14so50409oib.7;
        Thu, 16 Dec 2021 10:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4kEk2jLX5JsaXaml6I3UCQ4HHgVw8B9AtP08glyOGfU=;
        b=iDSPo33D2bBCAKu0XhgEf/A7HDsgQZ7+mD5iufpmn9WJYaD6fpLRvvmD9MTr6jESEA
         RPwddOuud63ZlbsHcLxZaaWHVIc9t6/NoIV550c9DRXmEYkRoNo3oMNduMlg6zbIhxoo
         Yj1WGyADJLpYBfss71h/xJS/nOPYPJHV+Zo8PL8PdMDGKnXlNrlbCZ7iRay+j7+L3ZMd
         zRxpLVCORKXQo1hJUBg2ovQYqqC/ehXvDINxTDe2gLMMsrMryILhr/rr0d0o3xOSgiqF
         q5lpVyi5F5U3el/lbWwAJGhiee/FAq9pDUtk+NGpl86UE1EARltGaiVgOR63kVRbzdpC
         eLrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=4kEk2jLX5JsaXaml6I3UCQ4HHgVw8B9AtP08glyOGfU=;
        b=uogE+oRAqnOwGtFDoe+8PT94DYBccAFR+1b4tA93U8WpII8Bs1Q4apJhwg/ttn96X1
         Nnbog0pLqfDyGNJCz+KSu6TODR5ajsLIPfnReE85/86aapEiJcViUmX2tlyBugEGULXY
         26NrLEtY7mmmXg36FeLW40A5ZGHKBEz113T7pvzXOUQT1o39JyQB+WpK8tHITXPsl4wr
         A0Xp0KgEHqYyPWhAYdggoF1zvt3f5z7t/n1NUDF6n8ivZ/YuuioC2dBxBlVN3B/wKr8h
         QE47RUl9WCa/lnzkYxPIT+qcYyAHeBRsyLL3YN/BFdQnfWsQeqXVHrbiUbas0NoptK/r
         ++Tw==
X-Gm-Message-State: AOAM532TgHQH2bpeepv+zoUIvJ2NGZ8Se80/O/gGJ5U1dDB5neZjvFS7
        QnRMYMhYdrmolccfeCqGC94=
X-Google-Smtp-Source: ABdhPJwZ5GAhmrhiS3mVSDQJX7x4nqUxmkRxia9sZSl0nOGdCgfjLhj+puLbBZ8FQYt/ct0Dlgkm3Q==
X-Received: by 2002:aca:b843:: with SMTP id i64mr5115179oif.109.1639678110524;
        Thu, 16 Dec 2021 10:08:30 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b1sm1153296otj.5.2021.12.16.10.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 10:08:30 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 16 Dec 2021 10:08:28 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 00/42] 5.15.9-rc1 review
Message-ID: <20211216180828.GC1125270@roeck-us.net>
References: <20211215172026.641863587@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 15, 2021 at 06:20:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.9 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Dec 2021 17:20:14 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
