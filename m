Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 502594F5EE
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 15:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbfFVNlm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 09:41:42 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:41538 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfFVNlm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 09:41:42 -0400
Received: by mail-pg1-f172.google.com with SMTP id y72so4697087pgd.8
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 06:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=GksLkGOI2WihOC9VM+8yQKoPjuK1gvghWYr/oAcy394=;
        b=P8Fw1nQh7jFs9P+H3Qbl+Fowa9N+kN2yfn12kTxGGNrgifKHh2jZJi10l4QDAUQJUF
         /0i/50ceziZ8/P4HOFixIPxoo+HWLFq+Dyq0PLJAgQCKb7rNEhW38l85/sWpJFg0DvvR
         YCtYHy+T1ME4V25DcZnMb64D/UoAr4gwYsPIVuB9fRH2mcjSwSHBYYIA5dZoJqiF+BCu
         MXo9NZTktFZMMclM4HpJnt2Mu3BzByemMW8cKEwowgk8GeNfF/sOt7vwGFoNdDGazlX1
         g6lAdMIOpW7Qc5isujROgrl8E8XrLOO/L5CKz6MxorpPvupeHHuChokN6K9EWtuSnHgC
         Jgqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=GksLkGOI2WihOC9VM+8yQKoPjuK1gvghWYr/oAcy394=;
        b=r/jBSazH82ZpLW/MsaNL96b3tPRYqLsN5e9t0mem8xbQreo2JNEBHdVr1NaX/U3/GF
         G7niRADmKQEzk9G+mdHb2AqrY6fG6cL30GSgTNNgXMZV4G6mcBPGIv8kfeSkArSFYKR6
         dkITn5nw2DOW8OCnGRVM5+PypIa/ffnNtvphBJbYoKnbj1dsv8VkjiTTpAnpHGB8r2CU
         6DPGgeGaL6Ucktehp935X1f4YSE0zD9llEYhrOv2sDc+s8K1HCdwGTLvyxUD9UpShT7+
         XF0+dV52HMFqV3eq6Es5WX1+fV+hAlkk+rriKNYy4JecxEB1+1i0RBgLUJwpMZ/ZjWsT
         NAGg==
X-Gm-Message-State: APjAAAUudepP3XKsi4dCd6DIILNL+5rPg7BfQfiPAIdIUGxYx/Z9UTB8
        QMjP7ZSHl4VfGnl9UXK7JAtnA67y
X-Google-Smtp-Source: APXvYqwRV95GmyAnYSuboApG/tSo+fS17fB3pjUkkFFlT76u3pnXLkpwrZKPBgFWfv5ScCUlBJ/N3w==
X-Received: by 2002:a63:1d10:: with SMTP id d16mr5649004pgd.446.1561210900683;
        Sat, 22 Jun 2019 06:41:40 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o2sm4828420pgp.74.2019.06.22.06.41.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 06:41:40 -0700 (PDT)
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: stable queue build failures (ipv4/tcp)
Message-ID: <ff85ebad-2806-810f-0a03-a77c64ff92bf@roeck-us.net>
Date:   Sat, 22 Jun 2019 06:41:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

v4.4.y, v4.9.y, v4.14.y are affected.

net/ipv4/tcp_output.c: In function 'tcp_fragment':
net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared

net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undeclared

Guenter
