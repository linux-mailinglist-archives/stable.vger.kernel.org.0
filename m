Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F4112D290
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 18:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfL3RWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 12:22:55 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:40730 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbfL3RWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Dec 2019 12:22:55 -0500
Received: by mail-pj1-f66.google.com with SMTP id bg7so34352pjb.5;
        Mon, 30 Dec 2019 09:22:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Dx/r3gFYWyu/BL+Nw/dLm9t2W9mKH25PlFJGzDLl3Xk=;
        b=FGg3wVFusl9S0FEVJd+YH/99VSffQUFVb8LGpdl5LbTCe4Jm3a44EmbdB85YCSqyJH
         SuSg/gjQFFSBPjBuCDqOiqwCFCnFUSgjt7nMrLr3K7vWud3gjBOQx+gOIAYJfm2AZeH1
         ybKhfsNvGb+r8E7WQLOq/kdPoxra4pi1/UiS2KRKLShjkaE/9PdLcuWTGi2Kq16toQrJ
         LhwjvvYqAC/ij9Z4ugV+oCyczYrx7qwWKcCV4CwUIKBVt3p+BohgNau9zUoeAiuOThdh
         CQPaT0j51beUs+MDf3aOcq20If10C6uVI46btnFonUVMrK843pfFaKz9TeRriIwpIzBK
         1j3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Dx/r3gFYWyu/BL+Nw/dLm9t2W9mKH25PlFJGzDLl3Xk=;
        b=pZzarJKbeNUqMaXJG5CSLjJm/wKBx5L3IrJWii+6vq8pHaXzmmwEJy0dPa9uxUp8ly
         VTrYIOaMCTsvmq76+walLZ8jjYZA+ln1J0jQkDd64qvBwF0dWeSpMOKAGde0zA4t8oZW
         GPRNAeaBbozUFWc0Fy08OUFkOMe0jLL4iAQNJlnB4eoO8xt+uqdB1Tx1DIppopHwVkdx
         pUZaROMIdtI+Ch1Kv66QY1TaGTCGu/+UYK/ugQO6k5v7n9f6P6bhzoP2c92ZjLeDO1E7
         5z4bhBK1Ia2ni0/yjehxb4LfEveRGEVPmfK8QdKKTbfXWbYjw/apW4tmgM1IKVVdP2J4
         5bAQ==
X-Gm-Message-State: APjAAAVSThccmOrusMj/lyS2GmZfcBVljhWywNqywpZXFKqY/DUc1GUO
        jCQHK+av4IcTkoT8RwoVPHw=
X-Google-Smtp-Source: APXvYqzkegvJ+yuaA5wb2f8jhWMOv5qYgrnEImkTwhTm31b/1rKnVXoJbrBk6meeMfpanhSamnBlfQ==
X-Received: by 2002:a17:902:8541:: with SMTP id d1mr70946852plo.57.1577726575048;
        Mon, 30 Dec 2019 09:22:55 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k10sm48384pjs.13.2019.12.30.09.22.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 30 Dec 2019 09:22:54 -0800 (PST)
Date:   Mon, 30 Dec 2019 09:22:53 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/434] 5.4.7-stable review
Message-ID: <20191230172253.GD12958@roeck-us.net>
References: <20191229172702.393141737@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 06:20:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.7 release.
> There are 434 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 31 Dec 2019 17:25:52 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 145 fail: 13
Failed builds:
	<all mips>
Qemu test results:
	total: 385 pass: 320 fail: 65
Failed tests:
	<all mips>
	<all ppc64_book3s_defconfig>

mips and ppc64 failures are as with v4.19.y.

Guenter
