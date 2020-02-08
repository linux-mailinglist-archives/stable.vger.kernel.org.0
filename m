Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0820F156481
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 14:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbgBHNPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 08:15:47 -0500
Received: from mail-pl1-f171.google.com ([209.85.214.171]:34385 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727335AbgBHNPq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 08:15:46 -0500
Received: by mail-pl1-f171.google.com with SMTP id j7so927669plt.1
        for <stable@vger.kernel.org>; Sat, 08 Feb 2020 05:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=1nyOeSaNLdzKjL1PQY+xwAceulcnNyWnBYhMVAkohD4=;
        b=IZE92F79eA0r93bm0ccw6ibS1+MeePRysCOd3Z4XXiDNzBZm8WwnIRGytSme2sAR8+
         70FuP4kHOF6uxOgkau/HUtF/3Cg9MVQSt8rgBos98sfdndJQAq5vZ++6XH4sYoeQiCVg
         mF1p8bFQwDr3f2cqOalnbb7XAd1noMdq0j4p7bBypv4Div23a6++90RjPzk8snZgzQor
         Om6PIVL9Ib/0spckH9M/xFU0QbvyGY6uIp09iEoRH9NzZrWMj+Hiup47/zCjIEVMlvfU
         4NNKDoMPy1yBN02QwZz6rVUuQcvFFsMt4KpgIq0plUZ9FKE/F8ez6xI2/n7NPZPjtP+D
         x/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=1nyOeSaNLdzKjL1PQY+xwAceulcnNyWnBYhMVAkohD4=;
        b=o9S6doZUL2WR2Ba5PWolSAXdF4awOB/Z/EIu214Kk5jOEd7x0BbbKSI8LU/ScRHctu
         8fa4r9CaP6iAIehBdTuBADkpFwWzV6t6z1Q/e8CstgrXf1E6DBCDSns2c9qX3AFWzhxC
         pwEEzuqDV8o1rg0oN8GbyBuNsR4MtAHpCrKdAWyCSsRBlQ50UqIe4IcpjLrWIOWWdEJ/
         WKrgQPGL9NudCS39SIX04xC53jgXDdBACXS2vDU7WTFV0iP9TgnbilS5U9F5Is9VQlxn
         a6ASGz+Y86V/8Axz+e4y1kc+Rm8zrzUx2yY0s0ZODhKxCa1M29AH1EIRMVnn+xsnLhJD
         5Gvg==
X-Gm-Message-State: APjAAAXLRHfIlEFqYw0qgwy8YNhhMEEa8yFi1I155HU0FHSnzge3g+YT
        CHkEX2TsV9uLODv2V4KzNHqXQoA8
X-Google-Smtp-Source: APXvYqzeZnOjtr0j+fYdVYMYjtHbVKl4KUtIsNeqM0p6v0NSvfV4hGP4kfn09WB23D7QluZR5X7cUQ==
X-Received: by 2002:a17:90a:3268:: with SMTP id k95mr10220616pjb.48.1581167744585;
        Sat, 08 Feb 2020 05:15:44 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a195sm6606442pfa.120.2020.02.08.05.15.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Feb 2020 05:15:43 -0800 (PST)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: v4.9.y.queue build failures (s390)
Message-ID: <e63c50d7-68c0-1ada-dc05-86452d17a76a@roeck-us.net>
Date:   Sat, 8 Feb 2020 05:15:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For v4.9.213-37-g860ec95da9ad:

arch/s390/mm/hugetlbpage.c:14:10: fatal error: linux/sched/mm.h: No such file or directory
    14 | #include <linux/sched/mm.h>
       |          ^~~~~~~~~~~~~~~~~~
compilation terminated.
scripts/Makefile.build:304: recipe for target 'arch/s390/mm/hugetlbpage.o' failed
make[1]: *** [arch/s390/mm/hugetlbpage.o] Error 1
Makefile:1688: recipe for target 'arch/s390/mm/hugetlbpage.o' failed
make: *** [arch/s390/mm/hugetlbpage.o] Error 2

Guenter
