Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 219C426772D
	for <lists+stable@lfdr.de>; Sat, 12 Sep 2020 04:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725562AbgILCPe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Sep 2020 22:15:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgILCPd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Sep 2020 22:15:33 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B74EAC061573;
        Fri, 11 Sep 2020 19:15:32 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id o6so9989729ota.2;
        Fri, 11 Sep 2020 19:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xQukpSPmz8jJUfNCmmSuD2nq+XhW5pj5WMQpzh7aJRQ=;
        b=Bm/QYDIiQpLJzTJjj6b5JPiQ7XnT57hSPTdiVGQOXbQ9qpeYKttWowuv7cpbgmNavU
         6k7KIFdMWVysGtPAZDdOsQIuNuY+jF5dK1FAjOhLdwrNqxktZqIaDcXosd+LEvTRJciz
         YMdVWw67YKOX6OOYLzBM/pW+x61dQP26CQAHc+E61sX7eZOaUDVdqXtOoPCdpN4Mw8Bf
         9qce2U+bTkw0hh82TOHztGOCG9/PFB4qNR87NXPaY38RyFniTN8rfUES1Y+HX8rQGyTP
         S1vEnhPfxpWQrb3KA/GyA4H3vPeHSVhcTk29IDtv7mK3d2b5yZpW2k8BEUy2+Lct/DPw
         E3pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=xQukpSPmz8jJUfNCmmSuD2nq+XhW5pj5WMQpzh7aJRQ=;
        b=PXwSNmksfsFdBtjCXkt0JOqQkKKzdZzG93q6heErvTcfTkd4hBwvixuH17GFuAaWJh
         eHX1CjqyqVmaD5vkuHN9NUb3uXVG2tkRTIqJK+XCLhFPZlPeL0Ys0XWtXAeOq09oXBDp
         VzkLHgGgnuDiDeAbQCGRYu4pVaubVs4QwJSS+dsm3SvA4/ALjWwqLacriD81txWjAtkU
         Aefn/IKzmpLdHw1Z7bfCx6tC+g3duTyiMEOExI0Mwi3F2vZS6GpuvR3LN6LqkzeGRc2n
         tktuM/toROX9A2ULF3VGggEJQ/JvD9R+SA92rAOLRWarMmALxqNkwtIp+BKEuUlSpBEY
         GWaA==
X-Gm-Message-State: AOAM533qzmf+2S6qSUuekUhlhDcO22Yq3b8t9xZndABCGdgvlglQmysG
        q9LuMeQK8O3/dFRH0eXjyyo=
X-Google-Smtp-Source: ABdhPJwf+3859IYe2f01MCxhKi7zIhM7okapFdKHp78RVOhuRvLtXptK0lQamFTf6slG+1efNL4v8w==
X-Received: by 2002:a9d:5884:: with SMTP id x4mr2842849otg.193.1599876932106;
        Fri, 11 Sep 2020 19:15:32 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w2sm614942oig.12.2020.09.11.19.15.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 11 Sep 2020 19:15:31 -0700 (PDT)
Date:   Fri, 11 Sep 2020 19:15:30 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/62] 4.4.236-rc1 review
Message-ID: <20200912021530.GA50655@roeck-us.net>
References: <20200911122502.395450276@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911122502.395450276@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 11, 2020 at 02:45:43PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.236 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 13 Sep 2020 12:24:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 332 pass: 332 fail: 0

Guenter
