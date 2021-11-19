Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4566745683F
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 03:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbhKSCoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 21:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbhKSCoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 21:44:24 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730C3C061748
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 18:41:23 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id t4so15715pgn.9
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 18:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=19eC0yHN8Knq4er8eprHiiNnMBPtyRfdZNlAGVkzuA0=;
        b=g8V+RgDmhoLzRSSJmgnK+xoftMqWOQCDMkW7SMd7B/E63Mcto/jSrX63qkrEY7m9xt
         ElaG7vQHV0nBCYK6WBA1O6HlFiWqGNdvL83Sv8mnV8dPub4Dc0oEoU6uWRP0r2U95wBu
         hp66iNrtjPeUNgY717zMNX2JqYWAHBwPfiCIC7C/8TBBV0x21MqGAmOMlpgt6hA9Vjin
         oS1B5Nug/+PBeoByVZBZcRHG6JfxUyTnHjRb5qR9WCmY/wbOrQvyuCOqVFKVRVkyqzPv
         wC6toe7e5ybjaen7vf5R3e5C42+Vd4x+NZhfG9lnHO9yB8Mxk03M9ynzS7UUjR3Sxz5a
         3fuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=19eC0yHN8Knq4er8eprHiiNnMBPtyRfdZNlAGVkzuA0=;
        b=Er6IJX2o7HwpSyCxdlDVwK++UHU7VpZImYB8JnSvbMP+OVXqXtePu5Z6SbJBh5MlC5
         OwX2HfJL9amQ9HTe6qSJMtkqqr95cDUggD+CY1OlhepHHti9JXblgwnAykxP6F0fPAs1
         0pV5xBnpOjxPmWOLYtMuulse1n67qTkxI5uLLIgN5Byh/Nn7o1N0WIVnBLrprIyWv7DE
         hN2GCUbnrYPp+ECeMjJ5XFW9uE6d+UhwzjNIYE8nv4oDtV7P9wOt6uemPFUSYgRgcIR8
         OvxJjnLLPL7oNITCpoyURa5CuhS8gL/IFkwG7fvobxpQm9MKin+wOEskwdEeXVfiw8MD
         fy5A==
X-Gm-Message-State: AOAM533+NYdHYCsWFSp4CSE47bPayTq602ShEYNH99ZRzo+DCGsFgFtP
        VSNta7Qa4YPapJ+fWkBSZcnY4Q==
X-Google-Smtp-Source: ABdhPJyH7dLIVlWvWY2gnMMXBa3wdH+uvv8pklXAX+TNq575sm9EEbxFByiudWsfj2dx/Ox4bYD2ZA==
X-Received: by 2002:a05:6a00:1909:b0:49f:a0d0:abcf with SMTP id y9-20020a056a00190900b0049fa0d0abcfmr60556058pfi.70.1637289682906;
        Thu, 18 Nov 2021 18:41:22 -0800 (PST)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id e18sm714007pgl.50.2021.11.18.18.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 18:41:22 -0800 (PST)
Message-ID: <debb322e-395d-90a9-2052-0cf69d96f024@linaro.org>
Date:   Thu, 18 Nov 2021 18:41:21 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 5.15] block: Add a helper to validate the block size
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        stable@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+662448179365dddc1880@syzkaller.appspotmail.com,
        xieyongji@bytedance.com
References: <7e6c4c23-f071-f33b-7bd4-da11980d34c6@linaro.org>
 <20211118235738.1128085-1-tadeusz.struk@linaro.org>
 <df37d57e-86e1-56dd-54b7-f3d7b96ffd56@opensource.wdc.com>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <df37d57e-86e1-56dd-54b7-f3d7b96ffd56@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/18/21 17:55, Damien Le Moal wrote:
> But where is this used in 5.15 ? I do not see any callers for this.
> So why backport it ?
It will be used after the
af3c570fb0df ("loop: Use blk_validate_block_size() to validate block size")
is applied.
Please read the first message in the thread to get the context.

-- 
Thanks,
Tadeusz
