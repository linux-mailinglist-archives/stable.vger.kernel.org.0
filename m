Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81338145C27
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 20:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbgAVTAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 14:00:30 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44802 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgAVTAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 14:00:30 -0500
Received: by mail-pf1-f193.google.com with SMTP id 62so261614pfu.11;
        Wed, 22 Jan 2020 11:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1xnwdfZsxEBGEk0TCCz7my7E/yNX01rg/ngKCzenvNE=;
        b=oMiya3/4rhad0w28O2YaIs2vykU6OtWn+s/OSRQup3uEb3aapra1Bkp0vFAagkQtzz
         p1YiaUYtt8bimFLBwvIKd438cMwMbqA6O3lxPpV747O1/iel78lpZydVhaKu8HL14tUO
         CssH0yAbnxT5ETgcVDd2EJk/Ad3LgV+j1R7iaVQ+St1hp5OMejr4n7MoLeLKXVDBrsRo
         MrJsxjOhmJVPaDVtl8IbbrlC+h5mL6x7agLDdF9ToHse8XAc1ZTa0QwEp2/m3Sx/H60u
         IyDwCNI/+EfsaQZBBrT959qVAl6MdzbL869C3XM+GktEmCEc+eTBwMLi0mH0Vfg53vQQ
         emNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=1xnwdfZsxEBGEk0TCCz7my7E/yNX01rg/ngKCzenvNE=;
        b=PG0ljfHICBPQLn+YAyOAFM/i35Txq6g+YLUjp+G7MHawmM3Ah4TWh+XF52riFZmpD1
         EW01B1szzz1SN/0Vb9G/IQklwiOiDucOoU6JenKrnTnfMFaH8vjstoi0hunv6ErMZh6i
         5A7HH1NkosbyvJBNMj3NSaoZQ4+iQw9x6Xy3/RFRcAWdXrIN925fj4Lb5AGOCpnhl3Em
         F3vMBFlUysQKPs/LfRe2UDTLs0212WskF2/0Ad5s945ZeDdX/lMiGYCZJDTSGDBBievj
         dnXq2QCeKklPJyV0HI4tU4/cOFoI/8nYOGVJHLBsC+jjsAghUuIKORYxR3UIPleDBMnZ
         Ae1A==
X-Gm-Message-State: APjAAAU/e/HM7oobUtGFO2V9YPNHi9LGfwRwzaefmgs3PU0/XI9l30q4
        oferDOzmKiw8lVRr28jXfP0=
X-Google-Smtp-Source: APXvYqxnQo/hegx7P4BjRwdxZj/IAEQiVhzgjz6qwGaPKudFOAlW8ZwWpbNrdrvpBo3hu2F31K+Igg==
X-Received: by 2002:a63:1f16:: with SMTP id f22mr3878pgf.2.1579719629944;
        Wed, 22 Jan 2020 11:00:29 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u13sm4274874pjn.29.2020.01.22.11.00.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Jan 2020 11:00:29 -0800 (PST)
Date:   Wed, 22 Jan 2020 11:00:28 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/103] 4.19.98-stable review
Message-ID: <20200122190028.GD20093@roeck-us.net>
References: <20200122092803.587683021@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 22, 2020 at 10:28:16AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.98 release.
> There are 103 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 383 pass: 383 fail: 0

Guenter
