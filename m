Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58AAC33653
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 19:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727299AbfFCRQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 13:16:35 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43810 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbfFCRQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 13:16:35 -0400
Received: by mail-pg1-f194.google.com with SMTP id f25so8646052pgv.10;
        Mon, 03 Jun 2019 10:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nWPocyGzr05xZyYak/fsO6uoYX3VCtgY9WiKqwr1Zm0=;
        b=nV5DjAkUvRpLAqeJdpNXPu2IiC+gNNX79Efnop3tWMlRf65HAtziFVPLw01cNl0G+0
         q8ms3i62eonvmOg5d/hC2OQvcqprlVYjE7FNXkY08RUZN4f/ckeotM9MFOfKGHYnBFt5
         E/ez0zL97qP8Z/e6drCRK0nzqLCNSvmZJA1r7hYMRykbZEoEqLKVNYIdgDFjOG0Kccgf
         QL4odT+ve9k5XXyZlPZLnmJZZqi8g1zhhdraa520uijV5VoVUQ/FNz3PtpaThiQEEAMh
         9dW16DFy3cnYaHvlah9NOUiLN9w2EAlXqaabjXaQnENSEMSBF1n15KWoF8rHlaInlVXE
         v2eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=nWPocyGzr05xZyYak/fsO6uoYX3VCtgY9WiKqwr1Zm0=;
        b=X6mLix5vo76RFk2bICEUrErqtu7a5eMb/Wn1rva3+IEAuKFqfLPB7LzfvzVN1KflMx
         CiKQAVrTT+NfHrg/so/AqmwDLk9WzPR9dz/Yvy1m2xPMqoUm3J8Al2pzjph8+QcgXshv
         2rkKyOtnhmw23+pqa8tMkX1AgjYXSdLJciOmWPEhqudmPtyWbve3Eqr0etb2jLnwpy/X
         0fC9WH+hPyFo+aGi6HDXS9nCsW4MMpaogtP2ebxg4iQ24BwpmmLpgubRn7/vPsoiaySK
         Sz7qqbMJX55jk3fvUxhqcosuQf+hRUnqdyKMGEd5kNk7FPOz4ORZ6I5AQHB+u6uXnIic
         3PsQ==
X-Gm-Message-State: APjAAAWnyVTL2Q49x7cR8rkYMb6AipDvneWnlczs3XmhIgTMiV3EgzIz
        B6W/4gx1nfX8vJFGIhMr832/AEVU
X-Google-Smtp-Source: APXvYqzLSjBMMD7RPnG4I2evBnbpWjKAXUBZqf53Z3ltECoZ0r4pqLl4kyGy702m2l/GSsBM5qd94w==
X-Received: by 2002:a62:e90b:: with SMTP id j11mr31931539pfh.88.1559582194758;
        Mon, 03 Jun 2019 10:16:34 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q125sm33239373pfq.62.2019.06.03.10.16.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 10:16:33 -0700 (PDT)
Date:   Mon, 3 Jun 2019 10:16:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/32] 4.19.48-stable review
Message-ID: <20190603171631.GA4704@roeck-us.net>
References: <20190603090308.472021390@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603090308.472021390@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 03, 2019 at 11:07:54AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.48 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 05 Jun 2019 09:02:49 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 349 pass: 349 fail: 0

Guenter
