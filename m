Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A244151F2D
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 18:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgBDRT0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 12:19:26 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37651 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727414AbgBDRT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 12:19:26 -0500
Received: by mail-pj1-f67.google.com with SMTP id m13so1667077pjb.2;
        Tue, 04 Feb 2020 09:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xiQDV/rIbxr4XLs+e7ic/p2cgIZwicIgHmWjxF4UqHE=;
        b=lEbGW1hy0E4aWeTF5t0SG+rDmG1EuZ1FldS3Pih1Cw0GPkizE7ozoGWQq2JUW7o/R7
         KKrmv2b2Qy29D3xVNRI4uJMK2ct6wNUc4mmrsjFswdfg5kt/hIA7P9WJs3eLguxmVLoo
         NDhe3DnToMm8TMqKykPV2McNgBROUP5ninmM26or6mBGAoe3+SluCFNgqNGVLR5kFQd1
         neKf3a468J9ijl/kOZILffMcNfkNVkZsvss5WVbHwwB9co4JH1stdA1Z80YCAeWFajek
         xD97gJ0ov9gkk3z0ObjI/tQ/2X46PADbcA9gSCEdsPr2pxwKzhjDv9Ep6LLdqXit4NZb
         Ulfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=xiQDV/rIbxr4XLs+e7ic/p2cgIZwicIgHmWjxF4UqHE=;
        b=YwQ3TrADoADGu1WoRYWXw7CQVwruxG9dBQA0y1OrGnW7cSaQ0CEpkT0jK2dcM0wkDt
         Muli1kYdOP90LKfVzdB+cCpJkSr4s5O57gaB788N4ghAaAAH/cpfZXFhYErAmx48lV3d
         wF65Ee5Ip4Txh5C62Y22TEM2lIlZoWekWxe6VSNiThfp/Tk1umikU9MTF6fb3MJOUmcH
         yK/tphghMoIcpKyWbSZJnHLPjcHy1fe2lNUbsKSZnGqkfdvyB7M/B7agPIGuTDhhtZlI
         WmpgRsiN7vv9YFoe6qftAza+cAAGP9fI2FiP2gZM5572UbI/hRbF+5t3MnkKrJxizLe+
         c3OQ==
X-Gm-Message-State: APjAAAU1xTjXdEZsqWoPmOw1t3UmhRP6KLNKr+g1ZWPy80KvWuJMr/7J
        ONaaCrNK4CUMRH+lrPxAhbA=
X-Google-Smtp-Source: APXvYqzHohbS0G4pBnb5+0yAi25Tqq7QOavVd9/0lkQG4b7h9XnzIQ8WNOChB78HB3RhPZN3b3PvqA==
X-Received: by 2002:a17:902:bd88:: with SMTP id q8mr29187737pls.13.1580836765771;
        Tue, 04 Feb 2020 09:19:25 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 11sm26126758pfz.25.2020.02.04.09.19.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Feb 2020 09:19:25 -0800 (PST)
Date:   Tue, 4 Feb 2020 09:19:24 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/70] 4.19.102-stable review
Message-ID: <20200204171924.GD10163@roeck-us.net>
References: <20200203161912.158976871@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203161912.158976871@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 03, 2020 at 04:19:12PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.102 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 385 pass: 385 fail: 0

Guenter
