Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E44D2BC64
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 01:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfE0Xoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 19:44:39 -0400
Received: from mail-pg1-f180.google.com ([209.85.215.180]:46628 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727313AbfE0Xoj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 May 2019 19:44:39 -0400
Received: by mail-pg1-f180.google.com with SMTP id v9so3394042pgr.13
        for <stable@vger.kernel.org>; Mon, 27 May 2019 16:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=bZMrXewllU88w+6DcgktFYsXUtl2Ji0uBwh67s1CWxQ=;
        b=L7O0Vc+EwBJeiYMgaso05vygev6gbWXUoOhYMf5M7O0y58112ziExvjZj+bL1H63LI
         mB/a9tH17KA/OecrRBVLn9Pc78S34pEsichU9qtsb1RHwF1h+CEBqsjr0gZXm8vdddhK
         NF3xkwsXRZo7W9PMYhWOJSMuDxkUCTfn/+ziMeJDBiYTG4/A7kq2mBBqBAywJd9TdKe9
         v6QM4TEmkKCWJ/PkxG29jyJVzHTQgPjs1MK1xGO8U/uyOZERNqZYlxbIoYpta5LRXeln
         5rdozIlkSiX+UD2T5FWDGYNpIK7WHnwzhqxL6Uil37p2ZZlPUs/zJECdvPUydpGQMcyg
         vglA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=bZMrXewllU88w+6DcgktFYsXUtl2Ji0uBwh67s1CWxQ=;
        b=bNURq037A2/6cw66xm9W/katfVaMmrnkiGfKPC1CCiZQDmwVpZaniNXt9AKqmbJJYl
         vCRXhi7WV/B629vvlTttJUpAednWUxKOkoy0hrNl7xz3R3SIi90yXYugeSDF4UPzUhk5
         fJzhA1NOZi8OPMEvcrdmbBTTJ6mcdADKPqq/TR1ondYE7WV11/VPmHP7s+E8aNGf3pO7
         AYETBZ+OAX52TmA+7cNFYg9bAgrrPQOExnB0IKGMqCa2lV7D1/+HU+GeaWTUOzL87vG1
         MZO30kuygqmLTUcqzf/jk3qbkLTbr1cyKdQ13Q5/svfsujfRbJKSuwmjghoysW8ycFxk
         0AWw==
X-Gm-Message-State: APjAAAX1N2fWHyQaupE9KyhU294cTaV8ogcFod+Wns0KBQicX/Di7mPl
        NB/1Rb0M/lTCM9ykhGQAHK/CUYBT
X-Google-Smtp-Source: APXvYqwDyAc71G9vIbGRqwHmP887hfTj8Tat5MVzotyp5uzYxbfWzb8kjGwTQqIT44hzRxLYQNroZw==
X-Received: by 2002:a65:4646:: with SMTP id k6mr33534840pgr.324.1559000678443;
        Mon, 27 May 2019 16:44:38 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l38sm498072pje.12.2019.05.27.16.44.37
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 16:44:37 -0700 (PDT)
To:     stable <stable@vger.kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Build/test failures in v4.4.y.queue
Message-ID: <9f66f53a-331c-ddef-9f66-3855b2d1bc49@roeck-us.net>
Date:   Mon, 27 May 2019 16:44:37 -0700
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

parisc, parisc64:

Build reference: v4.4.180-76-gb17fdeda327c
gcc version: hppa-linux-gcc (GCC) 8.3.0

Configuration file workarounds:
     "s/# CONFIG_MLONGCALLS is not set/CONFIG_MLONGCALLS=y/"

Building parisc:defconfig ... failed
--------------
Error log:
/opt/buildbot/slave/stable-queue-4.4/build/arch/parisc/lib/fixup.S: Assembler messages:
/opt/buildbot/slave/stable-queue-4.4/build/arch/parisc/lib/fixup.S:62: Error: Unrecognized .LEVEL argument

The problem affects all tested configurations.

Guenter
