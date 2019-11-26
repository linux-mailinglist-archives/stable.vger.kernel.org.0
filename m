Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB52010A475
	for <lists+stable@lfdr.de>; Tue, 26 Nov 2019 20:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbfKZT1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Nov 2019 14:27:24 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41303 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZT1Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Nov 2019 14:27:24 -0500
Received: by mail-qk1-f194.google.com with SMTP id m125so17159506qkd.8
        for <stable@vger.kernel.org>; Tue, 26 Nov 2019 11:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=pqEek6iJJMqcyDblxZodrD/8h6Zp+g54pA6x0F/hDDE=;
        b=jCUCqPy7jEp+Makst3iesebZI2932dsNiL+0qPC7oe3eP3r8vzlK73OmejKHC4q4mF
         W3gV6zOyxla5MSYnWczpX5QTgYjgM8ZaX/Z17EzA4OVRIdf0ZtecvuVVKwtLxSf+bdgY
         OWflkfMeTDM8whtZFE16LqhqXvXWLvfvyP0ZB46SMrhrcLaqTSrYMgLPPhkt2If01oCk
         5ZwLPm/FrUVbPez1LSuOA0FXsFYJH7GNyPySrX9sehS5dTEcuCv3/vL1tlgsheQ3PO7V
         cAiq1H6VahZAhaWWbM49NuBem1qJMe2pljQQep27iOOOiv6MZrsD8UJBBlODyzPaNZtp
         gkTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=pqEek6iJJMqcyDblxZodrD/8h6Zp+g54pA6x0F/hDDE=;
        b=PsSsRBX4Q3ZYBC1DUjdv/IUMqY1lJRe0rvUa+ZnLZ6lm0kHax9l1JyfLQ5uQN10nd1
         XCUWFCbxWumLcu/bEcJqha5PHOy3dLn58+0Frc9NCGKCoAZi/+c6ZjcZmbkP3zEUVOH7
         mL9vywh1zVaKbwwP1X+6GllwkilXBy3p3gnolAeM685dhnY/fPWdludrmzs5OA3An3Ib
         xRH9lgUggMsLJwR6ByubBnR1y0oCVQSTiIdw6iSQNT5Iqt7gg7wyKVFR20+XmhxAif3I
         GMs0i7yg8HlIf67CEig8wkMY81U60stfJDyLO/nrU5yDXR/7rYMZrv75oNauvfq1vkzM
         qwxg==
X-Gm-Message-State: APjAAAWL4+CjwtJp07021jDhOVUW1oi7moyZ+SIJhp/9DczC5EfDBthB
        6Hmz3uQ9PFdr1KCTrQv8Qep2afaxHjNKBw==
X-Google-Smtp-Source: APXvYqwGjkoJ5BNGgrXk9fbl3mDr9T0A7lPLQHQaaL4oDPSBfU0siu2xel1UoTZ0ACkW6SY3j+cFYw==
X-Received: by 2002:a05:620a:112c:: with SMTP id p12mr32035024qkk.179.1574796443633;
        Tue, 26 Nov 2019 11:27:23 -0800 (PST)
Received: from ?IPv6:2804:14d:72b1:8920:a2ce:f815:f14d:bfac? ([2804:14d:72b1:8920:a2ce:f815:f14d:bfac])
        by smtp.gmail.com with ESMTPSA id c6sm5661174qka.111.2019.11.26.11.27.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2019 11:27:23 -0800 (PST)
To:     stable@vger.kernel.org
Cc:     skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org
From:   "Daniel W. S. Almeida" <dwlsalmeida@gmail.com>
Subject: Linux 5.3.13 BOOT TEST: Compiled, Booted, everything OK.
Message-ID: <55294cee-5a17-bcd1-1014-b0f51c4360bd@gmail.com>
Date:   Tue, 26 Nov 2019 16:19:42 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

No crashes and no new errors on dmesg.


Thanks,

Daniel.

