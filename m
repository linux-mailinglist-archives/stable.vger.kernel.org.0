Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373B01F5BD3
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 21:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729807AbgFJTLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 15:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgFJTLH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 15:11:07 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB9AC03E96B;
        Wed, 10 Jun 2020 12:11:07 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id j1so1525067pfe.4;
        Wed, 10 Jun 2020 12:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ai8ZLwroTocNuS+ffMWN70NubDGHs3SZPv+zBM8q0Ng=;
        b=XQ33DbGcxVwQWikOqjELj14EH9jc/DUmNSFw6AyGE5dfcwJTJBlhypIe/EFNmftks6
         6jlrgUWU7MQz64ePgP2BSq6ENXgdcxACfu0902+WgCjAthfz3Rqi4VOKg1bOzxRzdf3x
         9NKBr/WDpsSNXBge55kdRUOLeTrD0Er8faZbLYhFYkKtkzqd9DD4N3pnn2O8uq4WHMrr
         tyLfo9s3Z3QGzTiX4KvIRFb6cPTRm6XIIPer0LPuovF8HYTXpgvix1eDEvK8SZh+I2T5
         Xcmge+SBetVyzEsrIIh1fYIHI/wuRsnwXy0k9/Qh2XC0q8YhurAUVkse6R+1rvCtDLhc
         yF9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ai8ZLwroTocNuS+ffMWN70NubDGHs3SZPv+zBM8q0Ng=;
        b=bpj9G6GqHY4054I613ryr/BiYXb1RoqeTBlkmR9gP/p5C8UUDBUSyOxg8wpxLV8l23
         F9ZhEwVBnezvTuttM8di0NiLpmsDd339aX+Z5pYZrjoFHR0hOOkpjfADfzm5XBi/Wdm+
         GA0hyZx0hZw2wrer8ZHiX+dtJigzpAjW3ZYi+sJjsi/STE1p335MNnkOHY2wD5EJ7PBL
         LsOVIzm9HkRP98RnPokaKj26ebozQCc7qdfsN7r/W6hfvR3VFKkz1SuG//bl2DemhA+8
         /R/N2l5CkLh1tp8xcEkajMUbpc0CyLvnqsDJ4d3KIXVYvDC4jJ40lYsSQTarpvVeqWDe
         1hpg==
X-Gm-Message-State: AOAM533jlV0If+DkwF7dZG/wLYwBuTpNHuDEvyRxqLJC0TwnomONerbd
        i+cHAT1szMgtYu2J7XHBYOV7eA7z
X-Google-Smtp-Source: ABdhPJydZqls4JdUJZfMb/WrbNTSYf4nXGlq+lDSmjRDbtxQsLJDfliJc4OlMuKCSWcHOLNQS/4HiA==
X-Received: by 2002:a63:4451:: with SMTP id t17mr3736404pgk.224.1591816267449;
        Wed, 10 Jun 2020 12:11:07 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i191sm644956pfe.99.2020.06.10.12.11.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Jun 2020 12:11:06 -0700 (PDT)
Date:   Wed, 10 Jun 2020 12:11:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.6 00/41] 5.6.18-rc1 review
Message-ID: <20200610191105.GG232340@roeck-us.net>
References: <20200609174112.129412236@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609174112.129412236@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 09, 2020 at 07:45:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.18 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jun 2020 17:40:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 431 pass: 431 fail: 0

Guenter
