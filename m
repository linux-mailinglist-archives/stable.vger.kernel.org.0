Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 496A01728C5
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 20:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729833AbgB0Tht (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 14:37:49 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35527 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727159AbgB0Tht (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 14:37:49 -0500
Received: by mail-pf1-f195.google.com with SMTP id i19so360332pfa.2;
        Thu, 27 Feb 2020 11:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=khi838gAmVnb+887CrzfT9ttMcf6J3mMmknry1S8sak=;
        b=dEvUTU/DGjxb1NiPlLNPAzIymcvR6dgxwauOKvEn80dVZNq/Z8JcfB8wGkVq1Bl0dR
         T8/W+M0voSN4bao9dZ1IU81iRmJQ+ksCXs9WFaihnOsaSuT4mjsiHnoM0c/+DEX4GjY+
         R4fEAMkxM7p4/kfd4ZZbnbRk6dedqDhHwUqvWwUnE2Mzv2krJ1hseMaBMk/ODyLXpooM
         FaYCHHaLhrPcRFaMtCZZL5GdYzoUJql+OhqYNXYypfLevEKL0pg9J9L2auqMuyU104y5
         cSvyqekpuF4n0lg5hz7LBEjGW9C2lv5HUMZooo/wii8jpRNWIEqiUpqixKB4D1IbrZP6
         PKWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=khi838gAmVnb+887CrzfT9ttMcf6J3mMmknry1S8sak=;
        b=IwVgvOu0To8uE3vpy70JLvqdtijxTF80McuWGBhwx1gOhyU+ZTyzAiL+BvlzoUuzuY
         bjLuDAutR/gZv7TsI1nsNgrnJItdsmYwOZ+G23s1nI8dJMKn3chkp2yQP0CxB8S4cnvl
         LCAY6ouIWvBFN53gN3xGaIx5ZD+sRo1NVtig1sV9p0T+c91apNlwh6TIt+CLzTmWqI9e
         OsXm0lgJJozXzKQa0BfpCuSJe/fG6erCS6vY/mNL/PWOnup9Rd1/L9eC4Y5JUGKVREcF
         SvlHZ6lQpxC8e88hm+erxs5eXwkWnCRo2yN0508JytqP/KNIPGXA8g87SS/SHAlk6/Pj
         pXYg==
X-Gm-Message-State: APjAAAVq/TRLJO/ujHoU62WK1nEB0hFbs2TtUOd/YlMKOZJEonU0E/ti
        7sYGr7cR0Ope5a7S/uhrIEI=
X-Google-Smtp-Source: APXvYqzy1Bu22qpLN7knQ2RX0sl3PAk45D5BnQmj7R23dxkilY65/A9TS2O4DJ/4GQd8/hRC762qDA==
X-Received: by 2002:a63:4a47:: with SMTP id j7mr897453pgl.196.1582832268671;
        Thu, 27 Feb 2020 11:37:48 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g21sm8787608pfb.126.2020.02.27.11.37.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Feb 2020 11:37:48 -0800 (PST)
Date:   Thu, 27 Feb 2020 11:37:46 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/113] 4.4.215-stable review
Message-ID: <20200227193746.GA31847@roeck-us.net>
References: <20200227132211.791484803@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 02:35:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.215 release.  There
> are 113 patches in this series, all will be posted as a response to this one.
> If anyone has any issues with these being applied, please let me know.
> 
> Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.  Anything
> received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 330 pass: 330 fail: 0

Guenter
