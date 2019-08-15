Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3928EF2B
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 17:18:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbfHOPSY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 11:18:24 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46103 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfHOPSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 11:18:24 -0400
Received: by mail-pl1-f194.google.com with SMTP id c2so1172341plz.13;
        Thu, 15 Aug 2019 08:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hwzni+YLLzwfO50LJ7pNOpyf0xcqKnba++DdzfG/gxc=;
        b=iR/dU784s7WPmYofmn/vB2FYuedVW70BIo36PcNoWEcWIp1ENs8uCmsNHwovhonUXd
         L6mroPaGSHYns+kV2WWesbuM1yKTE1/8/5Rs3q0eoNTn02GpFWxXYt1Vcm4TkdVOr6P3
         t1wsj9BBiPen6+nCGFxhzge5jcm5JIXdU/uXKztRNgGYevfqpBwlKglgAPrptws5jbbu
         SrFvtDwRWck7r15UIKYNusQGHzASvDOUVc/rCGqe8ebNXm0zqQtMc+CflC0xagVW1398
         dFy83W+JSumAoDejiOMmY7Z0Z9HmbKepPDI/m41DPeKOpH2ot17I8QUfWuIKJ1EY07Ck
         GkHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=hwzni+YLLzwfO50LJ7pNOpyf0xcqKnba++DdzfG/gxc=;
        b=lRrLolxq1pvNBUf/ur1FhvQ90TbNcDWFDZI1c+dZINoZPJuBmUy7QCRrJNMsa7cj2I
         Bh/Zx/Ks1LIuUGUX220hIgeHGJ4mtZHt25KU0I1weThFocmTdrRhbRjWeIqb3NxWPG9C
         jjU/i35D0BtmA1RP/q30jTQ1xcDWVNU4vmqClXluXa4+iAvsBBaKcDGZHmnAvV4ZN30m
         V1m2VWeLERZ+vRifQBI4+wQqx+1JyLqolWnb2fy7myKomoyTJlXqVfS2sQXDgDsHbCaJ
         WFS4o1P/XVXkngkc14DpJExNsPYWasvWEjYqPMdWE/YkCCXSSCfRETO6C3RkkNDmKSi8
         zovg==
X-Gm-Message-State: APjAAAXdVifv+VdtXHFWjWY7chPbeKqidbmzC3HxTx8Jw4tLk50qfRcB
        yPppqwDPWS1yOilaPalukes=
X-Google-Smtp-Source: APXvYqy2OBBkygqB4tJxPdjmf4PZiwcO+mItfAhU0ShNgsb6dziSuyI444APrOYBDZ8wL4EYd312YQ==
X-Received: by 2002:a17:902:1105:: with SMTP id d5mr4867018pla.197.1565882303436;
        Thu, 15 Aug 2019 08:18:23 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 64sm3176222pfe.128.2019.08.15.08.18.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 08:18:22 -0700 (PDT)
Date:   Thu, 15 Aug 2019 08:18:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/144] 5.2.9-stable review
Message-ID: <20190815151822.GC23562@roeck-us.net>
References: <20190814165759.466811854@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 14, 2019 at 06:59:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.9 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
