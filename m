Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B235F614AFF
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 13:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiKAMnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 08:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiKAMne (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 08:43:34 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523191A075
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 05:43:34 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso12817798pjc.5
        for <stable@vger.kernel.org>; Tue, 01 Nov 2022 05:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CpIZcLvWIDAPBWXkBZHlMmUtSX3j2NcNGZfR0Ok7J4s=;
        b=b3/83ItsWoAZNA0c0ORRQnM0LotL9vKm5dGxbHxh8aBShKseSGDQFE+tPN91Qjo95s
         4GLKuc4IsXXNNwp7i/iZRrr9n75N5w+jorRzpUpEprZ53EQizg5yGKr/iSamaHQ3i7Md
         G0tqKfC+6A53kuvd9xRAG/rZk3RFZxn54YWONgAClwKk6Ib+g+UMzSLLf37wJsQpGUac
         HyQaPo9MxjEHmrv0nORP3crUMcKnLWQRlsiPB0j1APirVaVk7yldnSYPpBPnhnmBvCwn
         gEMTei10zr6G+SsQpsEuw3EK8pHNa98co77y7sLGYI3JkR0p7jJrFHXi6O3gGOYoz62E
         iM/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CpIZcLvWIDAPBWXkBZHlMmUtSX3j2NcNGZfR0Ok7J4s=;
        b=ufdiHSuALPqmEaLtKQ2rYEFtr30kLeZlPKGa5Cw5OeK9qjeA0kEwSnVaK31b0G/UAc
         rXVIrmjqZDguwqt425in6JCmxXxu7ZqFu9zxucKwZQkBMl7vLLa73bVbxwnE73tbZtDX
         aOuv1bHNSOqtzZShQ/aKbASSMfjb0a6gEtY3isbBv6BqCSFJbYWFiDPcnaHbk15iKoHG
         ftrx4xBS9UJcv6quRXZbjzkUHyCf8gm24c2PV70AJh2FB4Ay4rz2XQUpkW0ky40EQV1D
         MtNzoa1nFBvRrLw6LhbpNTsAukP0hO1mqZPe/orGbytPH+wx86r+hLCmA+iLtoNRWN4D
         nCKw==
X-Gm-Message-State: ACrzQf0fnCMhKMQJmeUzY+mPLVH9ZwJFvfnpDs43+1ghwn/30s2s19cU
        gStTvOYnyN0alxjB5ZWPThE=
X-Google-Smtp-Source: AMsMyM6UEB3RrRM7m3zTApLxT6FRKlXQ0igT02DX1zXaWh+KRYihTIMG+qhiDTFFc9TTCUBQTs9j5A==
X-Received: by 2002:a17:90a:86c6:b0:213:36b6:1b4c with SMTP id y6-20020a17090a86c600b0021336b61b4cmr20330267pjv.7.1667306613916;
        Tue, 01 Nov 2022 05:43:33 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-74.three.co.id. [180.214.232.74])
        by smtp.gmail.com with ESMTPSA id d10-20020aa797aa000000b00561dcfa700asm6454887pfq.107.2022.11.01.05.43.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Nov 2022 05:43:33 -0700 (PDT)
Message-ID: <a57c896c-d737-eed0-b446-3253bf8ed106@gmail.com>
Date:   Tue, 1 Nov 2022 19:43:29 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH openEuler-22.03-LTS] nilfs2: fix NULL pointer dereference
 at nilfs_bmap_lookup_at_level()
To:     Long Li <leo.lilong@huawei.com>, patchwork@huawei.com,
        liuyongqiang13@huawei.com
Cc:     yi.zhang@huawei.com, houtao1@huawei.com,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        syzbot+2b32eb36c1a825b7a74c@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20221101114337.726788-1-leo.lilong@huawei.com>
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20221101114337.726788-1-leo.lilong@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/1/22 18:43, Long Li wrote:
> From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
> 
> mainline inclusion
> from mainline-v6.0-rc3
> commit 21a87d88c2253350e115029f14fe2a10a7e6c856
> category: bugfix
> bugzilla: https://gitee.com/src-openeuler/kernel/issues/I5X1Z4
> CVE: CVE-2022-3621
> > Reference: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=21a87d88c2253350e115029f14fe2a10a7e6c856
> 

Backporting for downstream kernel based on what version?

-- 
An old man doll... just what I always wanted! - Clara

