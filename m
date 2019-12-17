Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0FC123493
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 19:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfLQSSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 13:18:15 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41269 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbfLQSSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 13:18:15 -0500
Received: by mail-pg1-f194.google.com with SMTP id x8so6106536pgk.8;
        Tue, 17 Dec 2019 10:18:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+D90vs6ZrBkrGT/J7l36gYWE3Lf/lbFGlDSyElYao7I=;
        b=Iwegg206bCHp+lncd0NW5CcPE0n/bBTNr3wfGCSO3ove4OzFTwDnbnCXJV3KsiRM47
         EnEQVe2qQA5nksECs8u2zT8gt8Iz1XlvMi9jwSqXN1ENjVbwyrzYNOxqgbyQDosZdDoe
         1GvdFFZFZO9EshDs+EYC0wqnvPfFRqoDv2nylimylzguwYSG+lPhL6GZD9miNQhjSGJl
         q64zqxaJxKZKeuTxeomKcnYwPUxplY0U/gHigA5RvuF29DGqj4+1xTUEBxmVzxrkXbJN
         hP2ZEHsOYauScsq1aBumAbOsdkQ4rWPCBit+muZxN8ENp84ZOTenblNSVAwkLhF3p2En
         E32w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=+D90vs6ZrBkrGT/J7l36gYWE3Lf/lbFGlDSyElYao7I=;
        b=JIqgn5XnAYTjcUXShdlKAiXypnz0uM6W3lHhRJo+8hPvkeg+vRBWtNwY8yvSMLIXcr
         4apgOOVf5o2GDlDlT0sBN9/nbun5hR72SUEMrJuJ7gXV7tLOAb4keFJ1dY0J0NJzsrue
         O3cKbG5TU3nXLj0XPu3U7/pM9MjcPX9Dszhr9PyQeSPFvDJYjPHwzNtjv3Tw+UjAv1yV
         tNPW7LOU7ur6PuR0LrkNUNZ5n60g/5/4DGwJ3ST2BWAczW6Lxyvml/oTEQfP/q+X4452
         +9UayeyLx5uDzVbzlSKs8I9QdjkU9deb/Sfr1GH7vMQfKrdyNqLzzFI2IQAJT7U7y/ox
         WXGg==
X-Gm-Message-State: APjAAAV7FubxfnL7vkv39oQRJX1zm+26QPwtLAuvC7VBRYevq/3SQ7TJ
        3APYXUqyKHtVm1ORjU2AEd7e8YFC
X-Google-Smtp-Source: APXvYqwH8njC+znW8wGgXdkTuOKQiJv5iLv8Xw+JULSUBJt+8QRC18s0DEn1qkDDQcEk6H8skFwaRg==
X-Received: by 2002:a63:a357:: with SMTP id v23mr26779683pgn.223.1576606694291;
        Tue, 17 Dec 2019 10:18:14 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i68sm28334707pfe.173.2019.12.17.10.18.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 17 Dec 2019 10:18:13 -0800 (PST)
Date:   Tue, 17 Dec 2019 10:18:12 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/267] 4.14.159-stable review
Message-ID: <20191217181812.GA6047@roeck-us.net>
References: <20191216174848.701533383@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 16, 2019 at 06:45:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.159 release.
> There are 267 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Dec 2019 17:41:25 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 375 pass: 375 fail: 0

Guenter
