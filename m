Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A52EA61F7D
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 15:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727576AbfGHNVf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 09:21:35 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:43921 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbfGHNVe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 09:21:34 -0400
Received: by mail-pl1-f172.google.com with SMTP id cl9so8255045plb.10
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 06:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=5S/sW7DZifDDGQWSP9xPO4fm+8D8YCSF1u7WPNN9RkE=;
        b=u725HWPWWz8QKrWBHpH65Act8fuWZq+auf987yNV2tyi/ECRNwymkP+EJsoFzkKL7w
         g8NDcvPHp/GI81A46N0+vFvgIuhQUge+YneYUR6GG8pGaZMKoM6Xu2qmeI4NOnc+pHPI
         /jY/p0j60Whk9PR46JaFwUAaja4obg30zh/5FrZK9bhfzD2CseNbyurPKUNIuPLPWV9h
         3YMQdV0fyufAzH2Xs4iPOl2X1GCwpp6WFai+pnH7Y4gCYMJbLhO8+rfm4HrN5ty7xt7R
         cZzujien9AhYB9GebkXekJQK+jCKzckyC8V+f22i1Il1zAJifm3yPq2a5Tvb34Vt7Eib
         YPvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=5S/sW7DZifDDGQWSP9xPO4fm+8D8YCSF1u7WPNN9RkE=;
        b=imoupjVCIFQsxJljE2dth/7xXfmk1MmVVZBADGQlq3NZeZtAkOVLGc40uwbXcnXfYH
         R9oP/1FeyScTcfLU0MJ04mcCTPFX4mHg4m57WPbJfiUm6jnBal5ltJXMYNrU1pYLQEst
         lQqa+Ow8I+kaZUFaMQ3iE6coSLxeO71/1NrpCyyZKtOpC28F+Mn7qkK6iyKg4eF7Hnwy
         DKiCk7c+EaSuV3uUwXTCauAqeb4B+Gd5pO+WAt16R4MWl5EOCdOY7Khzpv453EOhU8mR
         33z29YIi2lFiAb/v0gqhElBSyItGQA0DEe+RKnfHSnk83qN65O1Hc8t6tqo5apONPPzM
         ytOQ==
X-Gm-Message-State: APjAAAV1EGTH//oHdEMukAY6wRGFqfLKt0fLggmOZT1qz7wO6ge2MGpp
        NV0QJlPb4B2j6B9FS7ImqD8=
X-Google-Smtp-Source: APXvYqwGodvFTgTf11MW3QnBaMtxMWzly4xuRXVprD4Y87C3BFYu+HEi1tVNHubmYO9pflQ8oS3Ptw==
X-Received: by 2002:a17:902:b713:: with SMTP id d19mr25006489pls.267.1562592094247;
        Mon, 08 Jul 2019 06:21:34 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n19sm19109797pfa.11.2019.07.08.06.21.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 06:21:33 -0700 (PDT)
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Build failures in v4.4.y.queue, v4.9.queue
Message-ID: <1d749d61-a489-11e2-bb6b-21408e1057ff@roeck-us.net>
Date:   Mon, 8 Jul 2019 06:21:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Various cris builds:

init/built-in.o: In function `repair_env_string':
main.c:(.init.text+0x106): undefined reference to `abort'
arch/cris/mm/built-in.o: In function `do_page_fault':
(.text+0x44e): undefined reference to `abort'
arch/cris/mm/built-in.o: In function `mem_init':
(.init.text+0x12): undefined reference to `abort'
arch/cris/arch-v10/kernel/built-in.o: In function `cris_request_io_interface':
(.text+0x219e): undefined reference to `abort'
arch/cris/arch-v10/kernel/built-in.o: In function `cris_free_io_interface':
(.text+0x2644): undefined reference to `abort'
kernel/built-in.o:(.text+0x416): more undefined references to `abort' follow

Caused by commit commit b068c10cde7f3e ("bug.h: work around GCC PR82365 in BUG()").
Reverting it fixes the problem. I would suggest to undo the cris specific changes
in that backport. An alternative would be for me to stop build-testing for the
architecture if there is no further interest in keeping it alive for older branches.

Guenter
