Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C95D58FB14
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 13:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbiHKLEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 07:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234203AbiHKLEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 07:04:39 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8DA94115
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 04:04:38 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id ay39-20020a05600c1e2700b003a5503a80cfso2483635wmb.2
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 04:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=pBRcSUqn/UXVGJHxsdg0IWfZOO+XDd/yJ3BX7yfBAd8=;
        b=i/xs5rdHtrPHlYms5cKhjvXIYFnlF9J49EsciB7jY6hGXtWd89f/I7b7saHuxU3Z22
         hhtM2FtzqA+NmAoTDA9x5Xpw/XuvMYHMXqJvYo9oYsLLKWqYIx4sgKPyGgbokAmxEkFE
         CVyOBN2+96deFjha1zvgUWCv/mnWAHphddmhe+WR6prIL2c7ccJvRLi86qTRjbpdTbhj
         +z4AeW7lwZvX4lAORmMdo+5TTJUfgtxfw4TRNO1Wiw4Bwxxcs1Eo7S3mBajx5kbnr5rO
         3jO2SusZalRYBuvQCduC+ig/Rk3TACExsfF3w6ovGvws4SDLc+fIjZsmg0mEi7j+ttuv
         vlHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=pBRcSUqn/UXVGJHxsdg0IWfZOO+XDd/yJ3BX7yfBAd8=;
        b=Twy6J6KhuzETtVb1OwV8Aaypjetn60urPMD0KeuXT0W/NLPSk+qBaVSYosvmLcG1BI
         IRkT+eUeNdiCKREx4qCcYrBd5WAaIEEPXIqHYCeugbqnwaVlodJryDl88lkPgNdzbjSl
         hNoUB/y7y5k/LzaskVWio9xadIuMHYrxlgvoLZCG7uyGWdXwDRoO/zDLg1IySLBdIy2Q
         xLB539P6H79kUNJvtAI0LsqbbIiBHFrq5dDqSK46X8njqKi17Py4th4ilgcCI2QSgexT
         ADEy7jz+FjHvZ77dLaqWeZVxn8excaRE4gIsJwAIG8e5/STTThP9jk8ebgbT1pITglRd
         8GGQ==
X-Gm-Message-State: ACgBeo09RofpYJr4Z6Edg9Q1/w5cAuxtx46ctXE3T4i2+jbYJK0U0FDt
        FV0wCHF/gJXaoiiDbIt4cBc+oyHvXY8=
X-Google-Smtp-Source: AA6agR6KlOeMDbFfeOZ72iqvLKAyUF1JHiQ0mnVDbdyfD6NO0GFUKVxgZcUnMmI6X/3bZ4f2Jim/TQ==
X-Received: by 2002:a1c:44d7:0:b0:3a5:452e:9117 with SMTP id r206-20020a1c44d7000000b003a5452e9117mr5354413wma.117.1660215877192;
        Thu, 11 Aug 2022 04:04:37 -0700 (PDT)
Received: from ?IPV6:2003:f6:af09:a700:e423:d3e6:c12e:483e? (p200300f6af09a700e423d3e6c12e483e.dip0.t-ipconnect.de. [2003:f6:af09:a700:e423:d3e6:c12e:483e])
        by smtp.gmail.com with ESMTPSA id c4-20020a1c3504000000b003a541d893desm5491742wma.38.2022.08.11.04.04.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 04:04:36 -0700 (PDT)
Message-ID: <22d70809-5db1-8258-b695-bc6aaa9ab9bf@gmail.com>
Date:   Thu, 11 Aug 2022 13:04:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 4.9 0/1] selinux: drop super_block backpointer from
 superblock_security_struct
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <20220808115922.331003-1-theflamefire89@gmail.com>
 <YvEPfSBGdBV0ZohA@kroah.com> <7769a909-9054-3215-dd3e-00bfb822d003@gmail.com>
 <YvTYGJh2JQR4vOVZ@kroah.com>
From:   Alexander Grund <theflamefire89@gmail.com>
In-Reply-To: <YvTYGJh2JQR4vOVZ@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11.08.22 12:21, Greg KH wrote:
> On Thu, Aug 11, 2022 at 11:46:09AM +0200, Alexander Grund wrote:
>> I mean this patch removes a superflous pointer of the superblock struct
>> making the kernel use less memory.
> 
> Also, how much measurable memory does this save?  You did not quantify
> it.

It saves one pointer, i.e. usually 8 Byte, per superblock when using SELinux.

I don't know how many of those superblocks will be allocated in total on usual systems
as I'm not familiar with the details of the filesystems.
However following one callchain leads to

> /*
> * Common helper for pseudo-filesystems (sockfs, pipefs, bdev - stuff that
> * will never be mountable)
> */
> struct dentry *mount_pseudo_xattr(struct file_system_type *fs_type, char *name,

So it seems one superblock even for each pseudo-fs of which there can be many.

A quick experiment [1] on my phone shows about 300 superblocks allocated which means
that the patch saves a bit over 2kB of memory.
So not that much on usual systems but could be much for some embedded systems.

I hope that helps,
Alex

[1] For the experiment I added a debug counter to `superblock_alloc_security`
