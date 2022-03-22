Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 842044E4565
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 18:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239225AbiCVRn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 13:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238025AbiCVRn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 13:43:57 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E438D68D
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 10:42:30 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id mj15-20020a17090b368f00b001c637aa358eso3720806pjb.0
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 10:42:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=8eVxzRvyLtCG7jsxYp2DMv5IzFzQJ8tF2ct1zspcSHM=;
        b=CFN0faYqJEMiGGiJ3/jcs6SXeF7Ypf47fmbFWVnsXCh1OLgjcru4hRQ6G9Qzb9kc98
         1fpOP6GO9bDh7FNxEHSNNOLgjaP6FPwosn0mZ7LOA6uVP5W1IAbyUQiq+OX1UnQ3bs+X
         RP3sMuyDBbemnWWXnk+Xgm3smBTU3nlHc1snpOtNcIosBdNgwzUXx4heTfUYk7t0mYLD
         UaVO1G81vlzQWa2SAgGLxXQ5rSNR+tgMVCKwSOO1QqkX3jDPIuxlIXZP3m2hSOMFMfdY
         QUWkGEfT90Z6GO6twtb5sRDDWRRmH3BnfrhBFmHx99nmkiEAwglm1Ktl1c8lwiFvqFDR
         7MNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=8eVxzRvyLtCG7jsxYp2DMv5IzFzQJ8tF2ct1zspcSHM=;
        b=nUR+NA94j4aOZFR1wUi//2+GEEfA98/iz91cexTbvXSZ8uNWEQuUpThq4hqo2cXSoZ
         m3UXqEi8anwdV2AwWjz5Xb9D1Yz9NGXct4uDSvuGcaGlmAXtJMg3XXJuTaAV7IhLTwA7
         1XhJ26RY0dzGJ1bN9bD4fqA8pQw0Q1sciZLJDzNY2n+ZQIS/kD5zSKLX/W8PehJZJ8AD
         X97s1rguhEP2wm9P0duspCp+/s81URphkA54PHhfyU+Zw40qjrLsuqNgdgZVjVFEldq5
         xpns1CU7OLIXbyrKjuIC4uH7iuhjyEggJ0GHXgZjGAWhdGU9Xo+Nu98a1eyG+tqe42KI
         BfWg==
X-Gm-Message-State: AOAM53347LjPGyWsSXc8XGxZxloAx47vQQN2fd6ueloZNiUqKu0YXb+8
        pFX2di2DbCcwpM+ajPWvgg7HvFXJHhPDKQ==
X-Google-Smtp-Source: ABdhPJy9vC4WUq3ufn8fXKBmqrQWJW3Ut0rwyp1dty7ZEUF2OrW08MT7FKi9Ac+qsazRDCMbpmaKUA==
X-Received: by 2002:a17:90b:1643:b0:1c6:e74b:31e1 with SMTP id il3-20020a17090b164300b001c6e74b31e1mr6363736pjb.182.1647970949596;
        Tue, 22 Mar 2022 10:42:29 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id oo17-20020a17090b1c9100b001bf0ccc59c2sm3713845pjb.16.2022.03.22.10.42.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 10:42:28 -0700 (PDT)
Message-ID: <da6deb10-62e9-cbe6-e6f4-15f956e966b1@linaro.org>
Date:   Tue, 22 Mar 2022 10:42:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     tytso@mit.edu, Andreas Dilger <adilger.kernel@dilger.ca>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        linux-ext4@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+7a806094edd5d07ba029@syzkaller.appspotmail.com
References: <20220315215439.269122-1-tadeusz.struk@linaro.org>
 <Yjn7V3whEZ3UmJlF@iweiny-desk3>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH v2] ext4: check if offset+length is valid in fallocate
In-Reply-To: <Yjn7V3whEZ3UmJlF@iweiny-desk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ira,
On 3/22/22 09:37, Ira Weiny wrote:
> On Tue, Mar 15, 2022 at 02:54:39PM -0700, Tadeusz Struk wrote:
>> Syzbot found an issue [1] in ext4_fallocate().
>> The C reproducer [2] calls fallocate(), passing size 0xffeffeff000ul,
>> and offset 0x1000000ul, which, when added together exceed the disk size,
>> and trigger a BUG in ext4_ind_remove_space() [3].
>> According to the comment doc in ext4_ind_remove_space() the 'end' block
>> parameter needs to be one block after the last block to remove.
>> In the case when the BUG is triggered it points to the last block on
>> a 4GB virtual disk image. This is calculated in
>> ext4_ind_remove_space() in [4].
>> This patch adds a check that ensure the length + offest to be
>> within the valid range and returns -ENOSPC error code in case
>> it is invalid.
> 
> Why is the check in vfs_fallocate() not working for this?
> 
> https://elixir.bootlin.com/linux/v5.17-rc8/source/fs/open.c#L300

Good question. From reading the comment:
https://elixir.bootlin.com/linux/v5.17/source/fs/ext4/file.c#L225

it is possible that, for the bitmap-format, the limit might be smaller
than the s_maxbytes.

But even for a extent-mapped file the offest+len needs to be within the
first to last-1 block range for fallocate(fd, FALLOC_FL_PUNCH_HOLE, ...)
If it points to the last one then it is invalid, no?

The check you pointed to in vfs code checks if offest+len goes beyond
maximal file size.

> Also why do other file systems not fail?  Is it because ext4 is special due to
> the end block needing to be one block after the last.  That seems to imply the
> last block can't be used or there is some off by one issue somewhere?

According to the comment in
https://elixir.bootlin.com/linux/v5.17/source/fs/ext4/indirect.c#L1214
it has to be one block after the last to be removed.

-- 
Thanks,
Tadeusz
