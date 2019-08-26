Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3657A9D774
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 22:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfHZUjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 16:39:31 -0400
Received: from mail-io1-f46.google.com ([209.85.166.46]:34568 "EHLO
        mail-io1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbfHZUjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 16:39:31 -0400
Received: by mail-io1-f46.google.com with SMTP id s21so40721455ioa.1
        for <stable@vger.kernel.org>; Mon, 26 Aug 2019 13:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=KJoAgsYPtScRuSXohmF/mjXUv9x/CQ91OY/lLS8zIJc=;
        b=h8FCZ7DxQsXZnJ8DvH0DfZLiFnyPgZuzKhOGuIBmWZ5l4lgMZqjf3Lhz0yjBqlHA+q
         kjrYUe5ssnVpOSxcr9G7qu8tBxhrzW6hZYI74PV08sLQIPRkz6OQrsR58l3SO6o5yCxW
         E+E+uuntkbVvDa6T893jQYLP1SPRYuJPhI6JBn3o7sucScozcUhm8mbU6UVxopX1iJeK
         IK0C/AJ69LpeVo+N92xmSlz3UGkeOKYpWsVlYV0ftz5+BEEPFzdTGVUImosChlac/f5p
         +mS7mCzYJjJc1RXZddvVKIVEmBaMet4F3Rf8uFxnAx0GU5w2rOqCZm5s9Yu2MdnvV3Sp
         BuBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=KJoAgsYPtScRuSXohmF/mjXUv9x/CQ91OY/lLS8zIJc=;
        b=KEtBlez9MUmPRvMHehicBa/ZHFTx4BZsp+5ARXrPwXqH2wNyq6ovLDOqR+B7TGS/7L
         LSWvkOiUtkbAgTA0A6+q46LRXQwoJm8t7Y9rfZQA2JNb68dLkin//Po29DKq1afFyBIL
         LBQbaAHrPsnGCVXJ+tm9bFhmq4fjcmoqx6iNvKZiORGBtldTgugIohQ6i/TkI9n532Ot
         VGSgAj1m1Txyfo/Ntw1Rkgpv8KmLC1QBl2rvem4njtAt7ic0JD3gm8TC+dvrwWJmLecu
         86J85qZCAB9eN4Megey4XVYPq5e4jl6ZkiV0jUAqUc1GipHypLa4kf7eDNJmcQxnA906
         qD/Q==
X-Gm-Message-State: APjAAAVdLozQOvELNYz5qsV3CNEArwP50JGfQ7TizjYgtLQ6U1zL5qX+
        gK5e7PnScopduM4cuSc5HU7Q/6j27bgISA==
X-Google-Smtp-Source: APXvYqzEJWoDdiasbJqIQhBmDpbvUlXL8NgusF3JJFcm2+IvOE9Zoy4xcdJXEs6R/x/zDyR7hX/a/Q==
X-Received: by 2002:a05:6638:1e5:: with SMTP id t5mr20000237jaq.79.1566851970104;
        Mon, 26 Aug 2019 13:39:30 -0700 (PDT)
Received: from [192.168.1.50] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id n22sm13626657iob.37.2019.08.26.13.39.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Aug 2019 13:39:29 -0700 (PDT)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
From:   Jens Axboe <axboe@kernel.dk>
Subject: fs/io_uring.c stable additions
Message-ID: <06ff6a5e-ecaa-ce53-5db0-6ff6e128c119@kernel.dk>
Date:   Mon, 26 Aug 2019 14:39:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Round two of this show, I forget to add these stable tags sometimes
apparently... Can you add these four to 5.2 stable? Again listed
in order of how they should be applied.

a982eeb09b6030e567b8b815277c8c9197168040
500f9fbadef86466a435726192f4ca4df7d94236
a3a0e43fd77013819e4b6f55e37e0efe8e35d805
08f5439f1df25a6cf6cf4c72cf6c13025599ce67


Thanks!

-- 
Jens Axboe

