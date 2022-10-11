Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 922115FBA87
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 20:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiJKSin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 14:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiJKSik (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 14:38:40 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2679B5A809
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 11:38:39 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 3so12777237pfw.4
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 11:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J0agk2sWS+Mi5h9dV51Nsg3RqUCciA5PQ2AzXKmTmwY=;
        b=UX8F1Qqg05k15VubNsjsrQCFZOGSL2y0dqQMfjdUJ5WFjv7HnAp/smRP0rDpDY/GqW
         fnYLtcH++lhV99URB/TalAcFo2q6HMMdYZGREMDhZNOvhA/QPEBRnQs+Bnof/+pmxavj
         6uvlK8Gru67aKDmcnOimQXP1r58Bv9pxtA0rCC8CMz7qI/BAEokgOuCfUQ+0dpN3Of1a
         2nprNkxXV92wa6SSDIht/xWKrLQZxHP+VSz8WCcYaFn3i6Rp9XKUjpoAS6zunbwGuJgq
         w0vrv8lb9f0sl5MQ0gFE8NIOOvntLUnS4sAWwTf8riT2L3jLRU1bv6JlpJQfM0CtCsoW
         yJaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J0agk2sWS+Mi5h9dV51Nsg3RqUCciA5PQ2AzXKmTmwY=;
        b=hR5y5rCidvtIHEAQT1+9u7Uqgps3Bq3y5vbrM7CzRpKyZjLxxY6/VyeWQVeQAQRnTa
         OZsOzD9bWP44AdyXcN7q/JdB1GeUMY0AJBzmxeoNz8CBa8gsOf5ljJInddOG8ID1DUEb
         qzXFPyFuJUD4unrG9kuCFXOhtmgPWwJcDQTPJVuUqiUdOgcKdg5mEHqHZzKny8VLWURn
         kiP71PvnI9eIyBqcJHDghKRF5ed73o4UacZurRQpbVxgZ4wcZx7A3tzA+hbrO/s/2Xcp
         VcnE9PAXo7p80pwltkhUF6q42xf5tG9p01LtnPiyV+7gyDq/csBaYwedT5TUgDDtYdr8
         23jg==
X-Gm-Message-State: ACrzQf20WfRuat041cSAvnYQHXhAevpS9MSf4cgcjVcQuoH85un1TrGD
        ca/zQagN+z1Cl6N9LYpQg4FfEw==
X-Google-Smtp-Source: AMsMyM7hgCm3o1frXwV8MfCXr7f55woi1BDbvv8MgkVy9eZI9ul9Q/2X5LsWM8EICdoc/uDAmwo6pQ==
X-Received: by 2002:aa7:9107:0:b0:553:92a4:d930 with SMTP id 7-20020aa79107000000b0055392a4d930mr26239125pfh.72.1665513518634;
        Tue, 11 Oct 2022 11:38:38 -0700 (PDT)
Received: from ?IPV6:2601:1c0:4c81:c480:feaa:14ff:fe3a:b225? ([2601:1c0:4c81:c480:feaa:14ff:fe3a:b225])
        by smtp.gmail.com with ESMTPSA id c195-20020a621ccc000000b00541c68a0689sm9343155pfc.7.2022.10.11.11.38.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Oct 2022 11:38:38 -0700 (PDT)
Message-ID: <e1e227a4-4f71-3a01-2bd1-beaf6c52e02a@linaro.org>
Date:   Tue, 11 Oct 2022 11:38:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH] ext4: Add extend check to prevent BUG() in ext4_es_end
Content-Language: en-US
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+a22dc4b0744ac658ed9b@syzkaller.appspotmail.com
References: <20220930202536.697396-1-tadeusz.struk@linaro.org>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <20220930202536.697396-1-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/30/22 13:25, Tadeusz Struk wrote:
> Syzbot reported an issue with ext4 extents. The reproducer creates
> a corrupted ext4 fs image in memory, and mounts it as a loop device.
> It invokes the ext4_cache_extents() and ext4_find_extent(), which
> eventually triggers a BUG() in ext4_es_end() causing a kernel crash.
> It triggers on mainline, and every kernel version back to v4.14.
> Add a call ext4_ext_check_inode() in ext4_find_extent() to prevent
> the crash.
> 
> To: "Theodore Ts'o"<tytso@mit.edu>
> Cc: "Andreas Dilger"<adilger.kernel@dilger.ca>
> Cc:<linux-ext4@vger.kernel.org>
> Cc:<linux-kernel@vger.kernel.org>
> Cc:<stable@vger.kernel.org>
> 
> Link:https://syzkaller.appspot.com/bug?id=641e7a4b900015c5d7a729d6cc1fba7a928a88f9
> Reported-by:syzbot+a22dc4b0744ac658ed9b@syzkaller.appspotmail.com
> Signed-off-by: Tadeusz Struk<tadeusz.struk@linaro.org>

Hi,
Any comments/feedback on this one?

-- 
Thanks,
Tadeusz

