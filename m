Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDB6C107705
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 19:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfKVSKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 13:10:15 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:39203 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKVSKP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Nov 2019 13:10:15 -0500
Received: by mail-ot1-f66.google.com with SMTP id w24so6965046otk.6;
        Fri, 22 Nov 2019 10:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qNx1WVL4moQBRhfh4yqyaKA4K9+JLS/LnFDl5THS6/k=;
        b=akimwxMtdFtYq4nOKrjOFbR9r+40GSbqDnVedFY8bg5RcPvLOBhHRgu7GA4/VMUFs8
         DOOxchlDfa2EY55aEiVBj3gB62pJ1KhhBfk5OXhQBtcCk25ms8kyOs8RTEcNP4Z38Ivk
         imGMUI3jmD/23IAWQjVBOGsiebT9evoSf9/TckA2yQVo1YWpeKU+BG6U/1OkfNBhI2mx
         tmEnDJUsRSLSVNOzkVHY0c1TliyEuT52/Pe8va/VGaj+ibz3YVIhDLbF6vbNT3IERS/z
         lsrGZ5R7donFdlQNnfO14kwaQ1O1K3lEiEAGptwPTubHz2xVOw/oaRS9RKOpba1R50rl
         zwmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=qNx1WVL4moQBRhfh4yqyaKA4K9+JLS/LnFDl5THS6/k=;
        b=SFyqhBKfrX0ujHiGt6AwpFZOwl1OYj5gT/keLHYcslvzu1sqp/K30IfFmYO+liaVSj
         SwtBDq+jG17MPE/S+xd/he+SLsPYOnPei6nfHuA851yqHJ375/L4u+8A3jPUrmTgWfwh
         O6d9ed+wUDMbdu4uBY/Ij0c2ecH3sizJzS5XN675rhyl4ffAL+2ANQcbOdAsvKAHdy/5
         0Cab2ydo6hlTJujIt8IVqA2+aDh4WYpiIa0GSGH7rLkCy9si0RE/aCB/C2RPRbB/Qyef
         uLUZfUDLJQDukkbj4RtFvNNES49rVeZ3rTyFF6y5J9VvOASp/D4gbB8HM4lo3+pgEuhC
         L09g==
X-Gm-Message-State: APjAAAWqdXUyCBTSnF04F+XUKr9GIaF0Ah0Vyrb7s4CF/YIK5GNmUNzD
        daRYY5xNoYybLWt3wggjyaY=
X-Google-Smtp-Source: APXvYqxFiBIXau2zBTUU15KoPVlLOubs7Xbv/TdZq/emjcTZqnV+VFCyKtygK0MHICHip1RqI1U4iw==
X-Received: by 2002:a05:6830:1d74:: with SMTP id l20mr11856561oti.111.1574446213726;
        Fri, 22 Nov 2019 10:10:13 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w26sm2412450otm.28.2019.11.22.10.10.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 22 Nov 2019 10:10:13 -0800 (PST)
Date:   Fri, 22 Nov 2019 10:10:12 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/222] 4.9.203-stable review
Message-ID: <20191122181012.GB13514@roeck-us.net>
References: <20191122100830.874290814@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 22, 2019 at 11:25:40AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.203 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Nov 2019 09:59:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 356 pass: 356 fail: 0

Guenter
