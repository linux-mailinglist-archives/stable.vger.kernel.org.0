Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7C94655136
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 15:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiLWOOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 09:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiLWOOC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 09:14:02 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3221DEE2
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 06:14:00 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id jo4so12300360ejb.7
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 06:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:subject:from:content-language:to
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aaik9Y22B1m7P468obc4AGNMAP0WdwZv7P0auUPUa/E=;
        b=eXDr57n19OA/kJEWo1V5mEOREHmHZfGhe90LcslRw7B4uSCv5OtS9mnIDuM8/EA6z2
         dCyH5jIpbLI5Q4uT+MIzdVBP+cxFvoTz0GVoM/vaYUVoSItVFLi07aqbJWHhDAUl4c9D
         ZX2RqzM0BR4W/NMx0TeT20cQiKpFVPA/s7XDI8LZHFZyXQHT6Xs0Pb2RoVQPWDCTCC7M
         +qHWqonaOwZ6a6vjDAi0Fd47e0im1UfPJWu0Lt0aIYB+mssGltaSizrcIeB3NjnCMk1k
         P4ssk/T6k1+JfNV43uuDomzAMNLTcJ1OUEWlYXijV4qnc/eKMRvivt1CJYl5ZGhZcZMY
         gcCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:content-language:to
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aaik9Y22B1m7P468obc4AGNMAP0WdwZv7P0auUPUa/E=;
        b=Ee5j8Unr0lDm7/JRVX+WaDRSdoBcdmLsCSLGb9EA0kNWUEyaX5aGDwTt3jnUSilR/f
         7lYRk1Y5A0y0JXekW1UGO/tcR2Hbyg+BwFgUwDR3ZzThTPsFz3jZuCaKKWqyM//lAuOy
         q7F0XwbLGQqETZcy+EX15kJsfE3ueO0ug3PJnyNN629l0sMRmEOvWwdl8KLK7hBqHgJN
         lbMevA3NlUAI5y8LFTvCduZKV4eorc8AcJ96hJ+1ErloyynMCBg3BJHNel3Gy50/7IJu
         J+MKkwLkYfFpv+Zulcrd0IjbQC4aUNqYN+2PEE00T8yZXI5nhhb88yFERRw05hN//n0c
         yAkw==
X-Gm-Message-State: AFqh2kqyXSfl3dE+dMLkJmedBHHKDjNSdgW8M2H0xOnPNGoUuOIjhVDB
        r7WlLQzYRj/TJyp0dPBrBVb2s+jDRFI=
X-Google-Smtp-Source: AMrXdXuh2yovNNjv5UVvoYM/e+7h/Iek0ieIiialwMvyhKVs+SzwT0swQ1AEuy6cQUVFwCA7Y7MVdg==
X-Received: by 2002:a17:906:374e:b0:7c1:f64:61f1 with SMTP id e14-20020a170906374e00b007c10f6461f1mr11418914ejc.45.1671804839394;
        Fri, 23 Dec 2022 06:13:59 -0800 (PST)
Received: from [192.168.10.127] (net-188-216-175-96.cust.vodafonedsl.it. [188.216.175.96])
        by smtp.gmail.com with ESMTPSA id p10-20020a170906614a00b007812ba2a360sm1446767ejl.149.2022.12.23.06.13.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Dec 2022 06:13:58 -0800 (PST)
Message-ID: <cb697d4e-406b-169b-c595-6521f8481304@gmail.com>
Date:   Fri, 23 Dec 2022 15:13:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
To:     stable@vger.kernel.org, regressions@lists.linux.dev
Content-Language: en-US
From:   Sergio Callegari <sergio.callegari@gmail.com>
Subject: Possible regression with kernel 6.1.0 freezing (6.0.14 is fine) on
 haswell laptop
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

just a short note to report regular freezes with kernel 6.1.0 on a 
haswell laptop quad core Intel Core i7-4750HQ (-MT MCP-) with integrated 
graphics.

- system only freezes when launching the desktop environment (working on 
a text console while having the sddm login screen up, without logging 
in, does not seem to cause the issue);

- freezes happens a few seconds to a few minutes after getting to the 
desktop environment (that uses opengl and composition). Freeze happens 
both on X11 or Wayland.

- freeze seems to cause data loss (system not able to complete writes 
when the freeze occurs, data structures on disk get corrupted, e.g. 
system complained on broken btrfs snapshots made by timeshift-like app).

- system on freeze ceases responding to ping from the outside;

- upon reboot I cannot find any trace of any issue in the journal;

- on the same system booting kernels up to 6.0.14 is OK.

Seen using a distro kernel, but it should be fairly mainline (manjaro/arch).

Reported to the distro, but seems serious enough to report here too.

Thanks,

Sergio

