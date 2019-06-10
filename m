Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 276083B7AE
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 16:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388850AbfFJOpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 10:45:05 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42217 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388373AbfFJOpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 10:45:05 -0400
Received: by mail-pg1-f194.google.com with SMTP id l19so2563769pgh.9;
        Mon, 10 Jun 2019 07:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=C/EioYkWJI+ACXBljRa/OmZ/UyBQX7KXRa97iNPRhJo=;
        b=lJY6JEAurOuuqV7zCNx7iT/zjeN2iexVCBhNyhq/cEF7g+Xw2jj3HxI7SHeA6NHOnf
         KKo9udeasPty+RasDn61/kBt4nuFNzoEo4Xr+IPeqXC2bz9ADFTBN9g8O0x+sdFQwVNe
         wECWIa7H+LMGvtOPJ+uBcpP44fV2lAwjZ1cYZfIGhHNfIYCRMyvYDxVA+NG+Wl1dl6+J
         IKkVYgLxAKMbEpmQwMrHh8w/vVr16bq+t3njNdd8vdoMhnwgl5nqS79gEfvM3m5rKbbD
         fGZzBByJRCLvdB8K3Kffs7r19/WSYJJVtYKBxE/++dWHWqKsWEUU4o343nNIVpx8/KyD
         +AQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=C/EioYkWJI+ACXBljRa/OmZ/UyBQX7KXRa97iNPRhJo=;
        b=BUE6hcHo1EOCgqG4Ma1iVePAJWobXgteEE50H2NO+V+ovi4/IPMCoyX3BNKIMeVzzP
         sStDeXTVZrUjCkF2okX5z28UGjGsVhzFZsMkv1kopFXBOEme7GYU8B4b5CIDjjgNDkwn
         q1eCoOEN4MeNctOiTgpfbaFm+ACo2g7uc9O+hha7oXDm/aWvDlUMrgTIwW6QxKYniigC
         7wlkUq7AJ4yTUzlpwCdYs6WZzbrvfoNdrDcY/WOEW25yeCHP3ZAsjfDXDzs6zV9CI2mS
         dZMO2Kc/mjn4TbfAzokB8s+F2h2lV0EXjWg9DE4urhPfa0zG0RukE4sSma7eU6eHK8Iy
         lZSw==
X-Gm-Message-State: APjAAAXDQR06M6xFqqABxlbNQ9AmykCjH68UqnYVwyUBLt0ST2Lgo7BN
        fznORs9FsszkMq4Sg2pvsQjZiIKw
X-Google-Smtp-Source: APXvYqzXsVtHWAXkxv4b0StfNVlB4bFF3cOZKAaeWlJwuFj8gtQ8T5/vnprUJ2ggeQVC2GLMsYuq0g==
X-Received: by 2002:a17:90a:1b4a:: with SMTP id q68mr21644483pjq.61.1560177904648;
        Mon, 10 Jun 2019 07:45:04 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z128sm12822907pfz.99.2019.06.10.07.45.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 07:45:04 -0700 (PDT)
Date:   Mon, 10 Jun 2019 07:45:03 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/70] 5.1.9-stable review
Message-ID: <20190610144503.GE7705@roeck-us.net>
References: <20190609164127.541128197@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 09, 2019 at 06:41:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.9 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 11 Jun 2019 04:40:04 PM UTC.
> Anything received after that time might be too late.
> 
Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 351 pass: 351 fail: 0

Guenter
