Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709B2614B0A
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 13:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiKAMp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 08:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiKAMp6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 08:45:58 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E2A192BC;
        Tue,  1 Nov 2022 05:45:58 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 78so13292365pgb.13;
        Tue, 01 Nov 2022 05:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lrG+YXaUGAscfFFfn+JVBJvhu3xyIhC/RE4Ontt4Bn8=;
        b=X5FvDNq+UEDBiGr4dMhgnutQKwbuvBz1+LajQr9xTClsadOf/VNuAKXKgZ504MocjN
         f0O1aY683/QyRDtBAyCxBgVI8SpDKwcta9V3TMnls6+vgoiBBTyL/WpXWiHAKRF5q09C
         WgAB7WqUyen7eW0Ynq1ko+qJfBciJ0dOfG1HMw6+JZ3EZn2uRnM3YHBOAc8deYvnvPRN
         lJMtT4RjbV98ULwIbQPeWdP1Rbh212vmbKdlM5BTufiKBiIS33DP+g3vw65zp0f+xLDA
         P8UfZr3y7KiPPxZ8RYqz12A4mxz0/7OGoW/G6OJPcWBmIwgexnDEtDziSZNtBxJiew6R
         0JDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lrG+YXaUGAscfFFfn+JVBJvhu3xyIhC/RE4Ontt4Bn8=;
        b=0UuWLUqwYGQQpivvdKopvKizI/VJ3LEXUxzO6T2G4IqIEtI4Aho8rhVluwnj7GPRER
         tS2HvVgO/OY5LrJL75AI1/ki2bybnC5dGG8z5ZFBR3tWzPfG8WdvClJkbBFUlfYx05re
         lRbsxOpRMnogdFEeYwr+NNzbPPZ1hkZ0fURpiyI0puCRFH8G1QbZkR4LPtgEpfNo/hqk
         5KhSKj6ne8z9NPWeRSRoYPPv00NDWo6WKeyjIP0DvIXro4O0E6JVeMEokSW8vvqL0Gnz
         0pzewvioVxAGeW4DX3k55yR8f39NR3XYVVmM2t1C1d4v+n42zJceoWdF6vFk26RRuJM7
         05dA==
X-Gm-Message-State: ACrzQf3gVBrDjQc3pjaofjIQO2faeroViJUJdNHezyv1bUgvhiPjaSu5
        Co/maJzD/hNm8ZozgzqKWPc=
X-Google-Smtp-Source: AMsMyM4HzgkWxuPH9DkJZ5EmFj0kWanp79esgEtSFYJJkil56qYRzaD6XGNaQ2HBrhCykiTV3g0fAw==
X-Received: by 2002:aa7:818f:0:b0:562:dc99:8a84 with SMTP id g15-20020aa7818f000000b00562dc998a84mr19555257pfi.30.1667306757992;
        Tue, 01 Nov 2022 05:45:57 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-74.three.co.id. [180.214.232.74])
        by smtp.gmail.com with ESMTPSA id 77-20020a621750000000b0056c2e497ad6sm6606351pfx.93.2022.11.01.05.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Nov 2022 05:45:57 -0700 (PDT)
Message-ID: <55d9baa0-6ab2-63ff-51c1-57f379efff29@gmail.com>
Date:   Tue, 1 Nov 2022 19:45:54 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH -next 1/2] PM: hibernate: fix spelling mistake for
 annotation
Content-Language: en-US
To:     TGSP <tgsp002@gmail.com>, rafael@kernel.org, len.brown@intel.com,
        pavel@ucw.cz, huanglei@kylinos.cn
Cc:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiongxin <xiongxin@kylinos.cn>, stable@vger.kernel.org
References: <20221101022840.1351163-1-tgsp002@gmail.com>
 <20221101022840.1351163-2-tgsp002@gmail.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20221101022840.1351163-2-tgsp002@gmail.com>
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

On 11/1/22 09:28, TGSP wrote:
> From: xiongxin <xiongxin@kylinos.cn>
> 
> The actual calculation formula in the code below is:
> 
> max_size = (count - (size + PAGES_FOR_IO)) / 2
> 	    - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE);
> 
> But function comments are written differently, the comment is wrong?
> 
> By the way, what exactly do the "/ 2" and "2 *" mean?
> 

Shouldn't the description above better below triple-dash (just
before diffstat)?

-- 
An old man doll... just what I always wanted! - Clara

