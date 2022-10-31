Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8EE61389E
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 15:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbiJaOCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 10:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiJaOCQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 10:02:16 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E65E10565
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 07:02:16 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id f8so7597598qkg.3
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 07:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=51eIv3KD2ipEY8ZUDIA02n/zlG06oyYinsFpQsxISUY=;
        b=VdGdbpZzDbiVOIPMQpG2LXTQ7Gr5tHLOnfHgOeikmYHnr705bpvjLN2QQ8KN1rYAjn
         v9Pg3Ql1Vb6JVcrMybAvK/LQQ5INpHzRQNrMWNF6QLbz735B/rwO/j6ShOuGY6la7aO8
         DehqQd9/0YFFDQGux5sYffg+Rl5eVXMvC25leuGf0smy4Ke0vkrJlwlAx0LCiCDGnY9b
         yY4ZWi/sFnxzMSn1GPMt9IpbmjhSaVhSFnrA6EhQf1nJDZhzDIqLDuZ0c9lblQLlOwfL
         fUor1cYMyfKnT+e+Q1FO12PmP0P6mpQRMK3eDpZ7KMh6Alrz+z9y/TjI2P1QV81DXR41
         fbLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=51eIv3KD2ipEY8ZUDIA02n/zlG06oyYinsFpQsxISUY=;
        b=05qyCRfeWXOa190oOPpH/5PLaqs9PgaTqsMDh79/yaAFi643V9b6/itUEY3xEwYZ4k
         +n0zdLFt7XyjGAgm5bobpAhpEjowCneSQLFpa+/9n/00ZQjtq5eAP5DXrx/eDnEkgiqH
         sSD1KveZyrpudxF0m5cFAF3vsntg37sD1eKPgM7fT81gtJTt8sxqEfy4nAdfvI+oHFCC
         y7Py8JpRfXibJd0TyDFSfn5Fp50KUwn+Ce4Qzu2ImDTgjEZAShmrWjb75IF8109BywGs
         d71q9ccPm7RYfFCKSU+nGWtZHnswQSEvkbTd9B1KPpiWe4Vpj7pmR1kMB9xSNWZcMwsP
         f49g==
X-Gm-Message-State: ACrzQf27rwEGaSZYsqykbgLWi6PDBabF/8lq4yPiWCVSDMMh2wbDUrdj
        QmP4VQ9pjfZIuj3UN5Dr7PE=
X-Google-Smtp-Source: AMsMyM72GXk40VhOFHTrNI2xXE2lZ47rd24vnzfw8gN4M4L2FtZIOEUEO8/bfhRD0MY7QA/EZqdjGA==
X-Received: by 2002:a05:620a:22a5:b0:6fa:1f33:7a8b with SMTP id p5-20020a05620a22a500b006fa1f337a8bmr6147818qkh.219.1667224935423;
        Mon, 31 Oct 2022 07:02:15 -0700 (PDT)
Received: from [192.168.50.208] (ip68-109-79-27.oc.oc.cox.net. [68.109.79.27])
        by smtp.gmail.com with ESMTPSA id bi29-20020a05620a319d00b006f956766f76sm4809247qkb.1.2022.10.31.07.02.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Oct 2022 07:02:15 -0700 (PDT)
Message-ID: <46d3a020-52e7-e79c-5686-a41932e56c35@gmail.com>
Date:   Mon, 31 Oct 2022 07:02:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH v2 0/6] lpfc: LTS 5.15 update to correct path split
 changes
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, justintee8345@gmail.com,
        martin.petersen@oracle.com
References: <20221028210827.23149-1-jsmart2021@gmail.com>
 <Y194tUNlsWa+MpYU@kroah.com>
From:   James Smart <jsmart2021@gmail.com>
In-Reply-To: <Y194tUNlsWa+MpYU@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
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

On 10/31/2022 12:26 AM, Greg KH wrote:
> On Fri, Oct 28, 2022 at 02:08:21PM -0700, James Smart wrote:
>> An issue was identified with lpfc in the LTS 5.15 kernel. There is an
>> FLOGI failure which prevents FC link bringup.
>>
>> In the past several kernel releases, we have been reworking areas of
>> the driver to fix issues in the broader design rather than continuing
>> to create a patchwork on an issue-by-issue basis. This means there are
>> a lot of inter-related patches.
>>
>> In this case, it appears that a portion of the "path split" rework was
>> pulled into 5.15, and the portion that wasn't picked up introduced
>> the error.
>>
>> This patch set reverts the patches for the partial pull in.
> 
> All now queued up, thanks.
> 
> greg k-h

Thank You.

-- james

