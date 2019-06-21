Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33ED54E849
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 14:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbfFUMvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 08:51:39 -0400
Received: from mail-qt1-f170.google.com ([209.85.160.170]:33085 "EHLO
        mail-qt1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbfFUMvj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 08:51:39 -0400
Received: by mail-qt1-f170.google.com with SMTP id x2so6792859qtr.0
        for <stable@vger.kernel.org>; Fri, 21 Jun 2019 05:51:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Yvbcx3e8NkyT53KmndifZhDJzSRwwvIGD/7pzrJ87rw=;
        b=oRlV1HMGd5I1yhGBtgUjjtc5SDTafXB83Y6ZwWUFYwG9/8vKalofCOj3WAyiqABqbu
         MAZ1JlPfwT01rdbPHsdoK2uinU/ZHSaD0g3rFi768zUORYnjlQGCh2WOpzFlx8Rk+K0k
         Bgbl4auHjNKJmlv6IqKsjs2N3h8oiCahzaPJFFYpHcCUcd1jJrqfWBkayBebzt16JCWW
         d6dLFjREId5J81aA+xPo46RYmgE1n06qXwjHHYYWsGJ7TVXmEHo1zL+mi/+nGwAbzP3s
         VU+zeNgKSi1n3Sf+UYIpUI4UB/3asZgf+D3Iniug3n8V26sgQL15Q3Guoe9obmAbZy/k
         +psg==
X-Gm-Message-State: APjAAAXS+fGtBicT3VoZfVeQSaBlvaUPEwiwHH0rK1TimdkuO+R1fjYa
        zGHscRaGbX243GfvXyN7GazaMQ==
X-Google-Smtp-Source: APXvYqzlBg+j4QxZjcV67777zgRcRjDpa2gCYsjIdAIYhW42vlcbjQY623R4xwf8BCx7VJZ7w5Hl0A==
X-Received: by 2002:a0c:aecd:: with SMTP id n13mr45206921qvd.182.1561121498187;
        Fri, 21 Jun 2019 05:51:38 -0700 (PDT)
Received: from [192.168.1.157] (pool-96-235-39-235.pitbpa.fios.verizon.net. [96.235.39.235])
        by smtp.gmail.com with ESMTPSA id l6sm1112128qkc.89.2019.06.21.05.51.36
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 05:51:37 -0700 (PDT)
To:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        stable <stable@vger.kernel.org>
Cc:     Major Hayden <mhayden@redhat.com>
From:   Laura Abbott <labbott@redhat.com>
Subject: Request for 4.19.x backport (with conflicts)
Message-ID: <0fc1a3e6-59ef-6390-38c4-55e7c48bee78@redhat.com>
Date:   Fri, 21 Jun 2019 08:51:36 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

We're attempting to build stable kernels with gcc9. 4.19.x fails to build with
gcc9 as 146448524bdd ("s390/jump_label: Use "jdd" constraint on gcc9") is missing.
This doesn't apply cleanly to 4.19.x as it needs changes from 13ddb52c165b
("s390/jump_label: Switch to relative references")

Which is better, taking both 13ddb52c165b and 146448524bdd or doing
a backport of 146448524bdd?

Thanks,
Laura
