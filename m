Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2BE26927
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 19:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729172AbfEVRgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 13:36:49 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:42998 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729085AbfEVRgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 13:36:49 -0400
Received: by mail-pg1-f181.google.com with SMTP id e17so1522789pgo.9
        for <stable@vger.kernel.org>; Wed, 22 May 2019 10:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nsdIr6vIsobebNitre+yMKwaX/E1/lRGkdW5n7MnntA=;
        b=bl0t3nCyYP5QAtuPdqjEe50QN23zrVPBzdcS/pQoSLUD2tgELRIpf9TRtZKfo9cgIj
         cYrKtBSi2mY6TKoRKnS/CFevpNLstv7h2zGcp45j38mmCnpKI/GFJrN6hQM74upb5POo
         0mL38wlqpG/7kjI35reUg8T3PzdIQjxl2KNcaQ+1DvZWhTZLoIfONOqgabK0J43lYLuu
         uWiv6QDl95R3dB5sSEU7lhzvp2/w24e8FJB+OIuF3eY7nBjamLxKcnocnZ4/BnDO92qN
         h8lU+twRCYHT7YBuOAgTksvYnBtGMaKdDxavBx+X5e+B/kqEaC1cbYZsD8EMChXW/4fe
         2a+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nsdIr6vIsobebNitre+yMKwaX/E1/lRGkdW5n7MnntA=;
        b=THXaPbkn90UMyJL1ncN7DMZ/ErnHyLzD/JoTNxMSlXZEoYiMHt5a4m4FS8WbERU6xD
         U9aTS3Nu6YXljKatFhiWkBt/CfoFz0W0/f+Y8UDi4LrYj21nnRAqfTprQxtT1WqkaODr
         abNwY/cK9NRDpMrdfKKBiAN+i4iwnyFp4QEtIawjeB/Tk6IuJhpfLWR962tD0fcm/0VX
         koNnEia2PEK/t6g/AHPdx+0Zy1dwwmOO6+9bfJUsFtePDPMUIjsC1KHLe6oxGge4wXnT
         TvFaqxsNMfsAM8HN9JMvGIZAgovbpntFAIIjnBFIpNhZ2a/W4BD6yLpYh0on/X7i/tTv
         +k4w==
X-Gm-Message-State: APjAAAWLB9MNUzfhyOa8n6h2rwFrhDLtB+EMRRZqb6cenA8XcA1JATe1
        aIinnkC/Zye9al8c6fSK6KMICHBk
X-Google-Smtp-Source: APXvYqzk9ReU3YKpS+hSuhjbbjX8fl71qRSPG+84YBTzrhRxR76oqingmtg+/+ac4+E0SD/r+J++gQ==
X-Received: by 2002:a63:5659:: with SMTP id g25mr92485786pgm.59.1558546608483;
        Wed, 22 May 2019 10:36:48 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:f892:82c5:66c:c52c? ([2601:282:800:fd80:f892:82c5:66c:c52c])
        by smtp.googlemail.com with ESMTPSA id x28sm36437211pfo.78.2019.05.22.10.36.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 10:36:47 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] ipv6: prevent possible fib6 leaks" failed
 to apply to 4.14-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     edumazet@google.com, davem@davemloft.net, kafai@fb.com,
        syzkaller@googlegroups.com, weiwan@google.com,
        stable@vger.kernel.org
References: <155854389617965@kroah.com>
 <84edd412-c07d-28be-1723-a4727ae2ea56@gmail.com>
 <20190522172945.GA25977@kroah.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6081e160-5d74-0ec7-59cc-56cdecbaad41@gmail.com>
Date:   Wed, 22 May 2019 11:36:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190522172945.GA25977@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/22/19 11:29 AM, Greg KH wrote:
> Thanks, but someone backported the commit mentioned in the Fixes line:
> 	Fixes: 93531c674315 ("net/ipv6: separate handling of FIB entries from dst based routes")
> 
> to 4.14.y.  If it's really not relevant there, not a big deal, now
> dropped.


Just checked and that commit is not in 4.14 line.

It is one of like 90 other patches that actually depend on other changes
in 4.15, 4.16. I can not imagine some poor soul backporting all of that
to 4.14.
