Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B9F7E6001
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 01:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfJZXds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 19:33:48 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:38284 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfJZXds (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Oct 2019 19:33:48 -0400
Received: by mail-pf1-f182.google.com with SMTP id c13so4156186pfp.5
        for <stable@vger.kernel.org>; Sat, 26 Oct 2019 16:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=c5ENVkzJ+xxWoR9gOg7fsw3GiSl5Tev3IR0Xrr6Ttrs=;
        b=byZEmFIg1eUQhTWCpjyUmeMGPQXJnVjmhxwlGGt3mRoFVcJ/WXTZIXlXjMM10a5NrX
         Mien1EFh0k4UG/LA/9PofRID4Vy55EU/80kAiHHWhX2gSd1+m6wj/umVkjsGZ8LIf3C7
         glmUlgs6jIBcL4v60DfeSkI6CcQ0TmpQMtlbdPWlsauGIK7ZS1WKahcYSVfqoscZKbcY
         P/7AoI08LT85AhDkwsmD6McTjVpbizrSWqEVMoZdGTzOZPXPid7D4dMCqm3f6ryiLp1U
         DqzrqxMUcGFv8N6ZosMYPFfz82cGsKmOCfoYopY6G4Ll/tBB0zrlZ9COZuufMK9y5raO
         G29w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=c5ENVkzJ+xxWoR9gOg7fsw3GiSl5Tev3IR0Xrr6Ttrs=;
        b=VCBZnnaIqFlg73L+XoKFFBWMD2D3sKIjevwqW2QBXf80nnugebnQJ3mOdE/ASpkY0s
         lSIhfxVyY8zHLxgcamrSQOOW1ClqXHFyT1jklmcVHvwvY3K34i0coLdHXqjHxZK2FM0W
         2e8L/UwxHxVyTAVW26zPUEfdjRsseKhArkszSULhqWzJOFy+i8WPsuiJ+b3GGmPpJt3S
         zaGvE/qEUMRjQf+8QA/ghQQRL2GefNLHh7EZGBS356eY9VWd6iXwSf8tcEIo5/jCpPrr
         y9JZjJDIQU0UsPpgRwEJMnZFdUJKmM8YFT3mp/4GtGgtLR8dvSFOVwhi/jNiRl4ThjXp
         lcTQ==
X-Gm-Message-State: APjAAAXCN25HqBpaxMtfdd6DKBV0RwI5bav0+LGlgI8WASH0dSiqTmM9
        edWlMAXVXTXTCPWqgahkMNZwGhm0u0dLEQ==
X-Google-Smtp-Source: APXvYqxEI2ORSLahCp2q7MBTrXqAN111+cZWHuExWw6kdTMbT7U2AlHILPSRsmWkDgOQoUQ7z/l6qQ==
X-Received: by 2002:a63:d308:: with SMTP id b8mr13145853pgg.246.1572132825152;
        Sat, 26 Oct 2019 16:33:45 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id q23sm5539426pjd.2.2019.10.26.16.33.43
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 26 Oct 2019 16:33:44 -0700 (PDT)
To:     stable@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: io_uring stable 5.3 backports
Message-ID: <efc9278b-de72-40b2-9a0a-48df0c64edc1@kernel.dk>
Date:   Sat, 26 Oct 2019 17:33:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

For some reason I forgot to mark these stable, but they should go
into stable. In order of applying them, they are:

bc808bced39f4e4b626c5ea8c63d5e41fce7205a
ef03681ae8df770745978148a7fb84796ae99cba
a1f58ba46f794b1168d1107befcf3d4b9f9fd453
84d55dc5b9e57b513a702fbc358e1b5489651590
fb5ccc98782f654778cb8d96ba8a998304f9a51f
935d1e45908afb8853c497f2c2bbbb685dec51dc
498ccd9eda49117c34e0041563d0da6ac40e52b8
2b2ed9750fc9d040b9f6d076afcef6f00b6f1f7c

Thanks!

-- 
Jens Axboe

