Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5521C6097F9
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 03:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiJXBzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Oct 2022 21:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiJXBzt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Oct 2022 21:55:49 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EC9659E8
        for <stable@vger.kernel.org>; Sun, 23 Oct 2022 18:55:48 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id l6so3470005pjj.0
        for <stable@vger.kernel.org>; Sun, 23 Oct 2022 18:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TRIt0uL21MORZeq8vb3DqpkpjPVJvOVOwgVHEabPeCk=;
        b=mvZglVMWQiRgqBrWVi6seQU6VBX43dvcEa5mF+IevrBskQWwL0FxBILSo2JZ+SOrnc
         UthOEAEYBkMMfPTUM77gL7C+/Df8lBy0n0qrPp6yuptqxp0PgfxFPbl375fLI+8i60ZJ
         EpVYNqInrYT9ZHEeNdjzAuRq5FcTcPzt/4VyBMJxJGQgjoKTcHjsu2my1ZveMZCFtNgt
         pFXpv7p9x+f9z3yAf5i2kJ+CLgtQzpL19589CzupPc78Cw5psx04oC6j0RY71hfF/9kr
         ou0qHUoYslcgbddXejtNnN6LIY9UpB54TYG1EuRBZigiZgAC3Tj+wRUO+xeu00WANhhx
         J+hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TRIt0uL21MORZeq8vb3DqpkpjPVJvOVOwgVHEabPeCk=;
        b=vnxQnpok0ALuFUv25Bf5MBxwClxLeQLBNorYhf+bv2afoE0spHVkQje27CUgFgT08/
         THeSriPgSy6MJHSlJdiSo6EmMHMHuybekoaAeYqwX91jUhabbhlmzXZMa7Ryf2GdM0wT
         Z0cg/baFPIKrQQU7BshczjOoDbq9tki0LWvehXAIMxIW/BaA2yBnK+0nV1MUvptegdfV
         dN/EunidTuPeapNk48HSxESnCfO+cRAmw7qSod7Jqxs/dxdF/LOyFS7S+ahHIMWHnGdj
         7RWy6tVjocgtDupBK1m5GRQ3aIoz7VPu6gw0qilE00ficmpED7rK7vesSt0RkF82YDEr
         q49Q==
X-Gm-Message-State: ACrzQf0Wbmn7CJ0Uw8ZjAjoQq78QJpHtd1fq3zDJUwSUtPf8PQwPLV84
        vq9HaQPknzS3RG/YoXxGLNUzg/TuRpo/mg==
X-Google-Smtp-Source: AMsMyM51PqZk4rOBBHmfSWqW+fNe4l5T2DXJQfj+MTk5K4MIS/cl1/PdfKQ0+omZU18A8mYGTxlQBA==
X-Received: by 2002:a17:90a:ae16:b0:212:d2bd:82f0 with SMTP id t22-20020a17090aae1600b00212d2bd82f0mr16650814pjq.12.1666576548386;
        Sun, 23 Oct 2022 18:55:48 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-5.three.co.id. [180.214.232.5])
        by smtp.gmail.com with ESMTPSA id a5-20020a17090a008500b0020adf65cebbsm3285685pja.8.2022.10.23.18.55.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Oct 2022 18:55:48 -0700 (PDT)
Message-ID: <5eaf893b-15f6-92c3-6cf1-9f78683eb49e@gmail.com>
Date:   Mon, 24 Oct 2022 08:55:44 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [Regression] v6.0.3 rcu_preempt detected expedited stalls
 btrfs-cache btrfs_work_helper
Content-Language: en-US
To:     Ernst Herzberg <earny@net4u.de>, stable@vger.kernel.org,
        josef@toxicpanda.com
References: <10522366-5c17-c18f-523c-b97c1496927b@net4u.de>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <10522366-5c17-c18f-523c-b97c1496927b@net4u.de>
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

On 10/23/22 13:21, Ernst Herzberg wrote:
> 
> Kernel v5.19.16 works without issues.
> Booting v6.0.3:
> 

Can you try bisecting v5.19..v6.0 instead?

-- 
An old man doll... just what I always wanted! - Clara

