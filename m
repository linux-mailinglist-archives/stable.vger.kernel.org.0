Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B142B26324F
	for <lists+stable@lfdr.de>; Wed,  9 Sep 2020 18:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730478AbgIIQkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 12:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731110AbgIIQj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 12:39:28 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9D8C061573;
        Wed,  9 Sep 2020 09:39:27 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id 37so2857989oto.4;
        Wed, 09 Sep 2020 09:39:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CaxB8F7IM/0pieDUaXXPmTDuE2hB01G/EZUz0Sd7eoU=;
        b=uGIlWtzGiu3o4O+xYUvZ2nE4OBAaiFvaPV9R1iT6gnNVHWzDyEh8iRDCon8MAhglSv
         5GHoQLFADFHp2rrnyo7aO75cx8H84wJI7/DpI3v4xsJMxq2Mb/AKOIfsr0UtXLyqdZxQ
         +im2bCx0P6RfzDQzqS2w/q2h8OUYFp45SmX940lYjXJ5Pi/SThMacF+CYW2Ui1ruRCRg
         Smbx9Ef1Ea+KQ5ubWzlSaf6cSb8nG3rwJAOkh4nuTo63gla9pj4hOMoFOqeAOeFxd7UA
         nNuSUDu2WcFaswActBuCoZsNvBKc0cTyp6+NrvnnhEDza8WBzcbLo+b7A2MqnbV2GGdh
         cxgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=CaxB8F7IM/0pieDUaXXPmTDuE2hB01G/EZUz0Sd7eoU=;
        b=NUqsWszy6AWvL6QttXhd9hi2QdP3RUxk2gL721K13jURV8QtTDiCU3RZMNKXK0voCz
         DsodRzIw9udIAGVDr+0aFxl29LOsTLgfISX1uEYCLC8MBKhNh0P/l+zniAsuSGlFfmSJ
         Sfz+qLc9CTcJp19dauiZZwe/aR8WxpzOWlbW3yQn+gaa477/U4CMLNkO0O71BNEv6okk
         GWwsH1M4CYtvaYmAAVeLlTnkYq6q+erPxQbh47UQLWmUqj9NR1cnbB76qBweDgVomeyG
         wDNhHt1tIrzyDzdrtgxiv32oSktTOnUBuVoaQOyxsLfYt+cUB34mLz6ojINEkGU70Nvw
         y3NQ==
X-Gm-Message-State: AOAM530trPCUX/6FltXra2DLbRz1ZVkqNVIkiy53Qt8LKnLCL8n7mUPW
        GRgRftBHI0HFFnGbWXdhDgnWPGpk3Yk=
X-Google-Smtp-Source: ABdhPJxzoPfDCQsUdP+x5nVpxnCW5GJzSRMTL3VJSW09b6OvxNnAFr3Ex2JXkVFNNxgo/Llpk5zMkg==
X-Received: by 2002:a9d:4e18:: with SMTP id p24mr1304296otf.190.1599669566907;
        Wed, 09 Sep 2020 09:39:26 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h10sm438347otq.32.2020.09.09.09.39.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 09 Sep 2020 09:39:26 -0700 (PDT)
Date:   Wed, 9 Sep 2020 09:39:25 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/88] 4.19.144-rc1 review
Message-ID: <20200909163925.GB1479@roeck-us.net>
References: <20200908152221.082184905@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 08, 2020 at 05:25:01PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.144 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Sep 2020 15:21:57 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
