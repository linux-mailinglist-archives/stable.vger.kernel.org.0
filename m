Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DAE9261F8E
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 22:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732155AbgIHUEm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 16:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730403AbgIHPXv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 11:23:51 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DFCC0619C3
        for <stable@vger.kernel.org>; Tue,  8 Sep 2020 06:45:24 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id r25so6125188ioj.0
        for <stable@vger.kernel.org>; Tue, 08 Sep 2020 06:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pWGVRptb+v3Vee33mruxDZLDMs4rFUK/y90Kni9uKwU=;
        b=gW0zPnM4z8N9omrWmCDxJHmq7DKEA2brEFIGacCnZ+yPzZ29jUuH/whV8AE18mMhY/
         8sUWYO0FFP6gcsGkSF5i2uijzG0GK3CXlkCYC4QItTEImnRPAMh8rdONbFTkFzYvR1K/
         OTJ0Awhu9tEeCQCfq1PdMSphJXtxWdrBqKJHitYfStd3YjrVFYVbpDrNbh0RWYBMa0yx
         SwQIFUsoPbHHkW4jA18CgN0UketeVj3d55inqhy/vU/C3YV3YZObavT+CvS32ne4B1c8
         p7KS+8JEp6mTuX1e2idvhluJoPuS5P8DGluSUuobgScQnne07q4w4QFyt787MvcnoHHD
         fM0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pWGVRptb+v3Vee33mruxDZLDMs4rFUK/y90Kni9uKwU=;
        b=OvnOOgDym+5o70pdUnUtSvJrmVFzL+fuzw5v+aRk6T7UsJvjlQAfTIvVtchP0r/Ipr
         f8sr0zjGVG1jACBxgLV1rE8V7c86jkstUW282DdVsmNEFxo8I6YJf7RWNAcPT0yn9Oze
         I1RjaZPZtB221i/DKQhlCRObRGldIV8on5KXFLNmyaMbd5FYTLloYoCQyvqZE19IHoPa
         x5z4nBBXzidzN+cJnQhRggYCI7iuV4uZQEqdd8BbtBF1TJ30AEU0HleqtvKOPaMbXFjg
         dSSaPlMm4AZlQa6Ds0AcbQRFaeBqdWiTek9CRjmJq52yaYo+X15T/w6XdSJpZzcA3lSt
         4jIg==
X-Gm-Message-State: AOAM530ZVoMgHBz0MqzfZV/epfM1OXT5FXusKJMNJ8WK2G8MVyzJ3xCA
        eMwKCiZ8pLxA4R2a/7GkwF9EoLACTBKX0CfB
X-Google-Smtp-Source: ABdhPJyMj0b9jmwAKM10HG6tFOfaemflS0D4XoSgXWNHHiedE9T/OSvgONejoQtpZap39MurKFf3dQ==
X-Received: by 2002:a02:a498:: with SMTP id d24mr24386895jam.137.1599572720255;
        Tue, 08 Sep 2020 06:45:20 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a21sm8437477ioh.12.2020.09.08.06.45.19
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 06:45:19 -0700 (PDT)
Subject: Re: 5.8 stable inclusion request
From:   Jens Axboe <axboe@kernel.dk>
To:     stable@vger.kernel.org
References: <fc20c685-8cd1-37f3-8c8f-9ce70b0911c1@kernel.dk>
Message-ID: <cf6761b6-2f20-9d0b-9f4c-dfde1d567beb@kernel.dk>
Date:   Tue, 8 Sep 2020 07:45:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <fc20c685-8cd1-37f3-8c8f-9ce70b0911c1@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/8/20 7:29 AM, Jens Axboe wrote:
> Hi,
> 
> Can I get these two queued up, in this order:
> 
> commit b7ddce3cbf010edbfac6c6d8cc708560a7bcd7a4
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Sun Sep 6 00:45:14 2020 +0300
> 
>     io_uring: fix cancel of deferred reqs with ->files
> 
> and
> 
> commit c127a2a1b7baa5eb40a7e2de4b7f0c51ccbbb2ef (tag: io_uring-5.9-2020-09-06, origin/i
> o_uring-5.9, io_uring-5.9)
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Sun Sep 6 00:45:15 2020 +0300
> 
>     io_uring: fix linked deferred ->files cancellation
> 
> which should both cherry-pick cleanly into the 5.8-stable tree.

They do pick cleanly, but missing some infrastructure... I'll send these
in separately.

-- 
Jens Axboe

