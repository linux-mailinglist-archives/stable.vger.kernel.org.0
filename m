Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3048C1F9AB6
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 16:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730213AbgFOOrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 10:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728304AbgFOOrb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 10:47:31 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F542C061A0E
        for <stable@vger.kernel.org>; Mon, 15 Jun 2020 07:47:30 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id c71so14909384wmd.5
        for <stable@vger.kernel.org>; Mon, 15 Jun 2020 07:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scylladb-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=dJ+Q+7tlRdq1nE9l87S/+73qxwoOPB9Y1JkZ3LkjeoQ=;
        b=N/8r6teN6DGqUqb09nz6T/xtOnaW1mT1iOGTrjBCDAO3UvePUChz2f0Qryyw/siZsl
         8XUbYY62OUZDHuYL6zIrq0QrD8tEuf3C/InzpAwdjYWp3lyVXDLiREFz7n9agdUx3mak
         FCFqNkwJWP9QGnoYmk7WqQeJLu/+zvQ9mBbm/JaXRgOzmJJ3IiSh42RkRuHKlpPKsOa3
         Vn3CrFQ9pbzL43IyIqXg1oYjFzLf2I0Vl80cCjYBOPEcSpwzD+My56lWDc3+TLOGQYOh
         +2S6g4YjxX0FP4XoHjcXUbcZ6mu1KLPBvkr5B1/wNX5IdQ95BcppQ2a5bVOnuwG2qtTa
         9wgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=dJ+Q+7tlRdq1nE9l87S/+73qxwoOPB9Y1JkZ3LkjeoQ=;
        b=dPpiY27L1UcdDgJ237teC/9zQGfcaWYyjFoiO5KHXozYCoF0ypltonWVQ7/iTjzsCc
         m00dVvHTEUCU0En4qXq/hPJRHPy8R3QTqqGPAJRVtsuegNg1lA7M6fBQundYT7XBUQ4e
         AsOBOR9NrFWm1lDdwXdm3sV6aK5Qehb/kIkbs3fXmtMYhv0ib3NAQg6u6sKusAv8XVFj
         /qphVM4L7c1nyGbsy8izfLE1OkhacPfGAWu9qN91kq4yo26L31K34tYi9XMul6zyjqeT
         pHj2qH/AZdgLVPlvcFtBmr59/HxGwbL1WoAiQ2c/cE8W2b9X5cJiAD4AByD8BVW87CjR
         WkcQ==
X-Gm-Message-State: AOAM532yWbmzhrjopoGc3YCDfS9MNJzwZBiR/8sTeOfc7tPwC9+VbVWm
        MnHT6MFXLTZOGrwExd1AZB9COgcU5GgXSA==
X-Google-Smtp-Source: ABdhPJwlOAp0ZrbI+b64+iPskzP42VY1R3F9+eR0ixrb3HGLk+uOzcjfV+i75ANLPL4tayy2tDkogw==
X-Received: by 2002:a05:600c:4146:: with SMTP id h6mr13978500wmm.170.1592232448721;
        Mon, 15 Jun 2020 07:47:28 -0700 (PDT)
Received: from [10.0.0.1] (system.cloudius-systems.com. [199.203.229.89])
        by smtp.gmail.com with ESMTPSA id d18sm24017446wrn.34.2020.06.15.07.47.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 07:47:27 -0700 (PDT)
Subject: Re: Backport status of "aio: fix async fsync creds"
 (530f32fc370fd1431ea9802dbc53ab5601dfccdb)
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
References: <a88009bc-dcea-eaee-7fe9-943bc8aae781@scylladb.com>
 <20200615123045.GA615921@kroah.com>
From:   Avi Kivity <avi@scylladb.com>
Organization: ScyllaDB
Message-ID: <002df672-1030-c9a4-6533-f790d349771c@scylladb.com>
Date:   Mon, 15 Jun 2020 17:47:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200615123045.GA615921@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 15/06/2020 15.30, Greg KH wrote:
> On Mon, Jun 15, 2020 at 08:27:22AM +0300, Avi Kivity wrote:
>> Commit "aio: fix async fsync creds"
>> (530f32fc370fd1431ea9802dbc53ab5601dfccdb) was committed for v5.8-rc1, but I
>> don't see it in any stable branches or rc queues (it is marked for 4.18+).
>> Did it slip through the cracks? Or is it on some other queue?
> It had to wait until 5.8-rc1 was out before I could take it into a
> stable release.  That just happened a few hours ago, and now I have 250+
> patches to dig through that people decided to push in the -rc1 cycle,
> yet are valid for stable trees...


Thanks, I wasn't aware of this extra gate.


> I'll go queue this up now, but note that this just take longer during
> the -rc1 cycle, and if you need it into a stable tree sooner, please let
> us know.


In fact, I've been waiting for this patch to do into mainline for a few 
months, so waiting a little longer isn't a problem. Knowing it hasn't 
been dropped is sufficient for me.



