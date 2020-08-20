Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D6024C68C
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 22:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728174AbgHTUFp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 16:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728147AbgHTUFn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 16:05:43 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41619C061385;
        Thu, 20 Aug 2020 13:05:43 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id nv17so1447838pjb.3;
        Thu, 20 Aug 2020 13:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=l30XnrXoJAM9THkminRWLbNFJ5YYy4tEF7yC8pg9wUk=;
        b=Pgf7f1UChyXn9DWP2TsCQm+gtQ+rph7TTxkaaCtUecutn9uCM6mIQEEF0uQSlo5mUK
         T/oNymnh386QrrozUQc7F1ddDmQscoF0pP5hdTNrvRbhlbHmSp3Y6orcsscdIVpqAaoj
         uNfxd4CxBVERbqY0bv9od1uQZ40W1ZofiUa4aArLxeDkU4hnqPxOPBhPg8ixAO3ELZNg
         cMP5PY0rTrRSWG8yrKLnT+q2HJlIDG3eUQGXt6ArjaVH3PdHsVbLbj6YsimDE6SxgU+M
         Ju8lknLpf2T/XZUX3ilOwUNaXt+CTaUFT1W1q+vPrvzTEmmtuHJDQuMwTtyJiYnyVgkC
         OLVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=l30XnrXoJAM9THkminRWLbNFJ5YYy4tEF7yC8pg9wUk=;
        b=VOqwdlWBUzr6wLgXHHqwGJM+wIzq1XQO8Dp6iMGBxhlfzUGYzU63N0eZBKUJnf/pAW
         IQr02kqrrHptvdmWDoLHxy1jJ74xOOSZw1eEkY2w/63y1kW6K+wQHzEK6/sdWSGESNbr
         tMg4Ob8/H/ud8/SJn5trDhoachTmPj4dwErhpzTAvBUlBYgwvmteaxLkC/xUATTc1a7M
         sVdgNE0nXgMyBOpGMbUCAF/x8E3Bp4wdFrqC72Fc7734S/Qlmg0mboOBQhkgjg1699Bf
         2BrCI3gWjJJD1Tg+S8pOg4Uu+oNqT7bjyWhvsXmbaf9dJ26INhn5Y1/VgVqDFrEv1p4z
         NumQ==
X-Gm-Message-State: AOAM533zP5P57EvFM+vJ0LuuFjgqA0ZfzPMJf7SKATNYFe8DxV7dS7EY
        2L7WmPXz9Bgi0UyHEy7KqkxJ7gTnOh0=
X-Google-Smtp-Source: ABdhPJy4jURGxq1hrEioq+KJYCrngzty3KSufNt8kIKSA4Gi+xlpowGhoqD2UVeUXaexDSO0/KDBoA==
X-Received: by 2002:a17:90a:498b:: with SMTP id d11mr227707pjh.179.1597953942880;
        Thu, 20 Aug 2020 13:05:42 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f6sm3800529pfa.23.2020.08.20.13.05.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 20 Aug 2020 13:05:42 -0700 (PDT)
Date:   Thu, 20 Aug 2020 13:05:41 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/92] 4.19.141-rc1 review
Message-ID: <20200820200541.GH84616@roeck-us.net>
References: <20200820091537.490965042@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 11:20:45AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.141 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> Anything received after that time might be too late.
> 

Tested-by: Guenter Roeck <linux@roeck-us.net>

