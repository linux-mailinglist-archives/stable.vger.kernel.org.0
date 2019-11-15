Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF3DFE65D
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 21:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfKOU0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 15:26:09 -0500
Received: from mail-pl1-f169.google.com ([209.85.214.169]:38237 "EHLO
        mail-pl1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfKOU0J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 15:26:09 -0500
Received: by mail-pl1-f169.google.com with SMTP id q18so1723782pls.5
        for <stable@vger.kernel.org>; Fri, 15 Nov 2019 12:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=ZVwV0Su/mCSi6pnRKM6ly2exmq/+tkRldsAhX2HmYpw=;
        b=LngHprQQ7rYIvRBtWm/sIjeg8lm9PDQxuHFPsluHRQi+shKhLsLOkluiN5+gXTz+W9
         XPxh5MZkrDX9m/Q2TTPk2aC+Uy9jDGKSqFNFR1pQnPArW1sgqRffuDmCBLnSwBaSBjtX
         /wTH93W3dEcTJ+5xKK3k2pchX1ponLhBkRlCZ6BG9xUy+Z0XV5DGywjMhEFSeQqgpykC
         8ruHP7cIp1qyePB8IihR/XQhrzVWQC7NytGupkZf1sYvHvl01sk78DS3tl+JjEeN664/
         rCfqeOPkkw6lH/lWiuWXvQT1k0xvcCXP0QYbrUOSvLhi2oKHmiRDYQ8PM9Et29p16zJQ
         oKZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=ZVwV0Su/mCSi6pnRKM6ly2exmq/+tkRldsAhX2HmYpw=;
        b=btVQDDdM+sRt5FJRelG1KPAXaKxI/fGK9fTWvzZbeIhMnTwdbcaxjRvafz8UlwTs43
         fI+pI+TUfD/QYM1/FBhY5+B6KmaHe25NSbehrAdyfbO628dTPeug9qi3mV9RuMbD5wUE
         zc5dcxxxlYLW2+b8TYMXPZzdHOYJ3jbDXjabKMcQwb+uHPlJtVpWOyPqWMpawgVFOCDQ
         gDPozw/Arsn+OeVK1uFCIWYaat/qAx0X68T5NYapxNTBTM7sp8pOVXKhZVHfxS25HMY9
         UB6CV1DhUOVQ97f1TJD+Hx98f0CgKSs4W7O8vkVPN6jutdBcLzCRZneDuBNTh1Glr2x5
         FR/g==
X-Gm-Message-State: APjAAAXyB6e52JPy+Mr4MKvu6tsShmQaynUj76OMD9E/wjXWiJpBcl0V
        CMJGVyhUw2iWatvduxd3j0D/34R9dO8=
X-Google-Smtp-Source: APXvYqxgJON4Hp0Zr/4qVu2XBMNK0Kh/I9QSz1bLmhwYersP8nge+yFcpGu9VYw0TBoaY6hZAW/Dww==
X-Received: by 2002:a17:902:9343:: with SMTP id g3mr17421449plp.278.1573849566285;
        Fri, 15 Nov 2019 12:26:06 -0800 (PST)
Received: from debian ([122.164.27.240])
        by smtp.gmail.com with ESMTPSA id x203sm11001126pgx.61.2019.11.15.12.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 12:26:05 -0800 (PST)
Date:   Sat, 16 Nov 2019 01:55:59 +0530
From:   Jeffrin Jose <jeffrin@rajagiritech.edu.in>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, jeffrin@rajagiritech.edu.in
Subject: PROBLEM: error and warning from 5.4.0-rc7
Message-ID: <20191115202559.GA160812@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hello all

i get error and warning from a typical 5.4.0-rc7.

------x--------x--error---x---------------x----

$cat 5.4.0-rc7-error.txt 
[    2.064029] Couldn't get size: 0x800000000000000e
[   12.906185] tpm_tis MSFT0101:00: IRQ index 0 not found
$

-------------x------------------x--------------



----------x----------warning----x-------------x-------------------------x-------------

$cat 5.4.0-rc7-warn.txt 
[    0.249749] MDS CPU bug present and SMT on, data leak possible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for more details.
[    0.249783]  #3
[    0.253901] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    2.011803] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    2.013717] rtc rtc0: invalid alarm value: 2019-11-14T14:63:40
[    2.234933] sdhci-pci 0000:00:1e.6: failed to setup card detect gpio
[    2.280028] i2c_hid i2c-ELAN1300:00: i2c-ELAN1300:00 supply vdd not found, using dummy regulator
[    2.280065] i2c_hid i2c-ELAN1300:00: i2c-ELAN1300:00 supply vddl not found, using dummy regulator
[    3.043252] usb 1-8: config 1 interface 1 altsetting 0 endpoint 0x83 has wMaxPacketSize 0, skipping
[    3.043254] usb 1-8: config 1 interface 1 altsetting 0 endpoint 0x3 has wMaxPacketSize 0, skipping
[   15.114547] platform regulatory.0: Direct firmware load for regulatory.db failed with error -2
[   16.059585] uvcvideo 1-6:1.0: Entity type for entity Extension 4 was not initialized!
[   16.059587] uvcvideo 1-6:1.0: Entity type for entity Processing 2 was not initialized!
[   16.059588] uvcvideo 1-6:1.0: Entity type for entity Camera 1 was not initialized!
[   23.368830] usb 1-8: config 1 interface 1 altsetting 0 endpoint 0x83 has wMaxPacketSize 0, skipping
[   23.368835] usb 1-8: config 1 interface 1 altsetting 0 endpoint 0x3 has wMaxPacketSize 0, skipping
[ 1415.852546] done.
[ 1416.144078] usb 1-8: config 1 interface 1 altsetting 0 endpoint 0x83 has wMaxPacketSize 0, skipping
[ 1416.144083] usb 1-8: config 1 interface 1 altsetting 0 endpoint 0x3 has wMaxPacketSize 0, skipping
[ 1421.652063] usb 1-8: config 1 interface 1 altsetting 0 endpoint 0x83 has wMaxPacketSize 0, skipping
[ 1421.652068] usb 1-8: config 1 interface 1 altsetting 0 endpoint 0x3 has wMaxPacketSize 0, skipping
$

------------------x-------------------x-------------------x----------------



--
software engineer
rajagiri school of engineering and technology
