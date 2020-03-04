Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1B5F1795BE
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 17:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgCDQxP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 11:53:15 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37154 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgCDQxP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Mar 2020 11:53:15 -0500
Received: by mail-pg1-f196.google.com with SMTP id z12so1255874pgl.4;
        Wed, 04 Mar 2020 08:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SDrq0LCQilEggOddpVsCXxYnWz73kS6jDdpyzCkjlEA=;
        b=cK3ohcOWvX0JGRCVm7PwhAzjRNkvoneALUpyJFqeiMzKtYdWUYfr8KTxF/KOkh8Xcm
         fVQELqOCxQlN1lNVuSFj/UPJZ1lH/nnqCHkjwcEpzT9nwMB1tS/cuYHc6AFW7nis+FeB
         9auOyjDkb40QrkFFhPisG0O0Fm1qicXF0j8vna1My8vcBXJHYXmi2duyHxncmg2FvDtf
         zidC7T2ACOesE+Dy8HjM7eUIbHp21RcNWhg/kl3fJ6coseK5+ypmZJFGZ5MiGHB25B9m
         pVZss5T4rtMZdUbNqgedJ4FVSynq658PyZxygEOOybDAEG3pjd/3LwfxwutHf1SnzdRr
         OX/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=SDrq0LCQilEggOddpVsCXxYnWz73kS6jDdpyzCkjlEA=;
        b=PEDa1C+QVtcpkxpvOtJLN/WtfU3S9tFgAG0W1z2npIXNvIQhgDpp7GVIyYngPcmKsu
         CrhfiW7cS2w3NU46oJ37XecHoXCs5d/GNL6iJUsnktnehNmAv3rVJh9q1xfG+sNJmOHn
         wI/GTwX4oPcfTzm7CTYhU6m1OnGtdIKiSiBnLcZVDT553uPqHMaGpwHNkW8V2wSwUCmj
         Xrl+lYQD6K8DRnP+yYtBbxFIlDVbFlq/8i4LKNPRhZ0kVkcEKgN09f7tEUayN5L+a0l2
         hhl4lYTg2zXsgX2s7Hr5ORPA+z9gjK9DVUv2nHwwMYniK+ciHwc+PrY8h77DHzCtYWw+
         4q7w==
X-Gm-Message-State: ANhLgQ2oAq7OYB9zcRSZIBWOmfIA0sHy2YWynbEO3/zrfS2+Qvdkdcko
        oaZA/Q5S8eG0oHRBeX+DTxk=
X-Google-Smtp-Source: ADFU+vsV+hTX8uGIABbRsKEZwuy+DVPHNyZQ0LOF0/+E/OiEgLCtOFOYjGZrn44u2ebgaod7KpsuRw==
X-Received: by 2002:a63:28c3:: with SMTP id o186mr3478699pgo.248.1583340794000;
        Wed, 04 Mar 2020 08:53:14 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d77sm16287341pfd.109.2020.03.04.08.53.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Mar 2020 08:53:13 -0800 (PST)
Date:   Wed, 4 Mar 2020 08:53:12 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/176] 5.5.8-stable review
Message-ID: <20200304165312.GC22358@roeck-us.net>
References: <20200303174304.593872177@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 03, 2020 at 06:41:04PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.8 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Mar 2020 17:42:06 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Guenter
