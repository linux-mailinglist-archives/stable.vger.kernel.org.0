Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18B0E6C280C
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 03:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjCUCWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 22:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjCUCWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 22:22:07 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5660938E86
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 19:22:02 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id c18so14554950ple.11
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 19:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679365322;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dKDJd+thGVBC1IVFKDXx0SWcwEiYHVdjzeJ2ZoR4z4A=;
        b=nRn2squL6ViLinzwRfbfEtcIacO/x0AWTKI6L35LkLjd6cc36VvHe4HeeHor8bcd/5
         Ch2QCNYI+U9amPD7EHFwEYSxn1yA1eXiexVvO994Dmrc6czyl5pcSQb5ZRCjU5UOr84q
         g4yAhTG1gRNL3EW88wpUY99j6Tz4sGteV1bCA+Cm8ZgknDKcV1tAtnScXxAiUaBE+dp3
         TEOPg/aQilYZSDX7ndrhMQObcc5LvJcTeGk94w22q2aGgPFvWY0IZw3kB07KJoL+mptg
         4R3UE2o8ZVhmT8ODrew+7f1Iclijmfy9X82020mNAxQ2Fbh/TFHM21FTDIoi1iURaoLT
         lKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679365322;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dKDJd+thGVBC1IVFKDXx0SWcwEiYHVdjzeJ2ZoR4z4A=;
        b=4f0zoAk8JcCZfDNv1hBdgGiwvgP27NXSjhpkWSMoMRjw2B6dHbsYjPmpFAm3AYewel
         NO0ybAzgdl1mDiTd/zKSnoMCvmvqSok87MTeelg0eIG3BAGqwtvJ0lYfwkJWPkE9DZsQ
         oBjtK4K3E+JbemS9UP4W+g+YyF/NLvdVWUKQ8MTSp8aX3MMmszDRh3JDyTSdH0QuQiCz
         CUvvYrLMhVgGcLQJFAvDAZPcz+Usy0P/2nVtwVZvrO9Lp/VuqVUb+2vyFus7+7HlnniO
         wj5FYFm0QVjjODpX1Us0kfMiN+C1w+h4DlH0ThxAzTDRPW5culFFOsQpgW3QYY+lkfwn
         yURg==
X-Gm-Message-State: AO0yUKWxmuHJR/tJnJiTFRuUjVdv6l3HXVR5icDN880IBP3xOO+6+HhV
        jlCNH1uySoRoyznX2FOkeTU=
X-Google-Smtp-Source: AK7set965EFtPzTxbfl3UQOO5Iu+ijvBM6v4OzQ+NsX/kbIHi5eZb8oR0u4cxgGMLMwBRZQ1ZSrGvg==
X-Received: by 2002:a17:90b:1644:b0:23e:feef:38ef with SMTP id il4-20020a17090b164400b0023efeef38efmr830586pjb.41.1679365321863;
        Mon, 20 Mar 2023 19:22:01 -0700 (PDT)
Received: from [30.221.130.251] ([47.246.101.59])
        by smtp.gmail.com with ESMTPSA id oc10-20020a17090b1c0a00b00233df90227fsm4017641pjb.18.2023.03.20.19.21.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 19:22:01 -0700 (PDT)
Message-ID: <bba399a1-8950-6a74-da22-4d98fab506e7@gmail.com>
Date:   Tue, 21 Mar 2023 10:21:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [Ocfs2-devel] FAILED: patch "[PATCH] ocfs2: fix data corruption
 after failed write" failed to apply to 5.10-stable tree
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>, gregkh@linuxfoundation.org,
        ocfs2-devel@oss.oracle.com, akpm@linux-foundation.org,
        gechangwei@live.cn, ghe@suse.com, jack@suse.cz, jlbec@evilplan.org,
        joseph.qi@linux.alibaba.com, junxiao.bi@oracle.com,
        mark@fasheh.com, piaojun@huawei.com, stable@vger.kernel.org
References: <1679313445246112@kroah.com>
 <63069869-30cf-c45f-3b05-b0b9b46bc36a@gmail.com> <ZBkSwL37/9DpfnvP@debian.me>
From:   Joseph Qi <jiangqi903@gmail.com>
In-Reply-To: <ZBkSwL37/9DpfnvP@debian.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/21/23 10:13 AM, Bagas Sanjaya wrote:
> On Tue, Mar 21, 2023 at 10:06:30AM +0800, Joseph Qi wrote:
>> Hi Greg,
>> It can be cleanly applied for linux-5.10.y and linux-4.19.y in my desktop.
>> I'm not sure how it happens.
>>
> 
> If you can apply the backport, why don't you post it here?
> 
My mistake, it requires feature folio.
Will adapt and post it later.

Thanks,
Joseph
