Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B13A968A6
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 20:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729639AbfHTSg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 14:36:29 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42879 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727358AbfHTSg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 14:36:29 -0400
Received: by mail-pf1-f195.google.com with SMTP id i30so3890937pfk.9
        for <stable@vger.kernel.org>; Tue, 20 Aug 2019 11:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=EF5TlUVT7eWmHnobQhg37B0S6/k93CaGoTV3aWhJKqQ=;
        b=vgvkbyBXeL5qqV8uwPtEhBStUMPAlAa1Y9bguufxdBM3GrsQlRlicQ6cm3YOkIY3vj
         xbPxEZxuYiCIkvGMtbA/ywPp6AbBOARaIeBw2CJw8wjtJRPGxlBGllBES3wnbxsSGx0m
         01lT647NoPltwOi850qoXuIQKkUMGe5wGEwLaKSgYG3q0EN3S8qhSLDmG1AaKwSyTYX0
         T37r1SDYu20iqGWZ3Pkst6OEHdJ6VSTotBIgwXlC3qKUghCmpTuBWe/wA+Pw2jgQT92c
         rVh0aF68ykO9KLITHxvIU8WllcYvl14TEoPDe8PCw+OEfyFzaJnuaZOB7A03UnagrEZ0
         xWJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=EF5TlUVT7eWmHnobQhg37B0S6/k93CaGoTV3aWhJKqQ=;
        b=OWohtnyu7hTDu/8TopL7fPCWIGEBfk5uiP6XfsMXaKvYpAaiRiq4JzgPax+M1026yD
         Tc7LmNtujLypmxiYqLGd9x0HyCIyczYt+MXOC7bclvT/tlm1mqCRPIG23b75juHt+Lt/
         eLZVBvI7o5Ggfodl2jMc/oiSVRLEhmQ/z53pUviOC8Zxaalm2iIWiv6nkLUHo1WQE0po
         GSnThEgRuYn5uJC/h9JZaw/KUdG3R7peOMDi4grPlThRZk0DiSCkCVFFRrnZBzEnf9eS
         eyEVN8PTYJhu6C8HAzaP8HOSN0vROuMTTZXT6JdZXUR/yMtRFM7PlsY/CFaXkVfJVtrX
         goPg==
X-Gm-Message-State: APjAAAUM0aped/Zr4Bth4D+Y9CZm89/kPoby8cLwwbOW9eLrjVOhcy0Z
        KHQdP8GxnHCZ8viNODmBC7M=
X-Google-Smtp-Source: APXvYqzTxA5LLEmrqFlnVvDb+DRpOylSnr1CX9ql3fMQI9AMM3bc/PPnj2QKlrXbMkGlqiibQOVIrQ==
X-Received: by 2002:a63:3203:: with SMTP id y3mr26275681pgy.191.1566326188441;
        Tue, 20 Aug 2019 11:36:28 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e66sm20730955pfe.142.2019.08.20.11.36.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Aug 2019 11:36:27 -0700 (PDT)
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Please apply commit 3c047057d120 ("asm-generic: default BUG_ON(x) to
 if(x)BUG()") to v4.4.y
Message-ID: <79c1d071-b13a-455f-bc7a-b32387a002d2@roeck-us.net>
Date:   Tue, 20 Aug 2019 11:36:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply commit 3c047057d120 ("asm-generic: default BUG_ON(x) to if(x)BUG()")
to linux-4.4.y.

The commit is somewhat related to commit 173a3efd3edb ("bug.h: work
around GCC PR82365 in BUG()") which has already been applied to v4.4.y.
That patch assumes that commit 3c047057d120 is applied as well.

Commit 3c047057d120 avoids warnings such as

arch/x86/kernel/irqinit.c:157:2: warning: if statement has empty body [-Wempty-body]

which are reported randomly by 0day build reports. Besides, as Arnd
points out in the commit, it avoids random behavior with CONFIG_BUG=n.

Thanks,
Guenter
