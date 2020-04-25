Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECD91B8779
	for <lists+stable@lfdr.de>; Sat, 25 Apr 2020 17:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgDYPqK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Apr 2020 11:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726108AbgDYPqK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Apr 2020 11:46:10 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4337BC09B04B
        for <stable@vger.kernel.org>; Sat, 25 Apr 2020 08:46:10 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id t40so5165244pjb.3
        for <stable@vger.kernel.org>; Sat, 25 Apr 2020 08:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=l2enFwhEhd1bai1QXh28v67UNsp7tbgTUEvViJTWMRo=;
        b=jMzPFRR5PySv/PWQyJ2xJZhhh9iSeUdHfVyQZZa21gw0/hCzcNl0JqtzicpOApNCys
         Yl4sp2m5YjBlqyhLr04yVoRZr9590D8zm7/JRqhAisthQQ3rS2Ffd2QcorD2bFoDxame
         moyLnYZOqGOEJMTZmWe2ZXoPBNXDay5VkYOwBPLlxI+FSOlNCm1WkyXsSBtXHd6PgUyR
         H6D7oj5ugIUiSVTpF/A9W/aZn+6CJ9zdL4bjcRNsRkx5AdwM+YdxIohOLFSP5S9igdNQ
         7VeEk5WSrRD85QuuC53fVvazPDYAMtck9vfoCjAqr1eh5z0iPzAiOr91Q4bhYSnOIVj3
         Z7Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l2enFwhEhd1bai1QXh28v67UNsp7tbgTUEvViJTWMRo=;
        b=RKVefTuXbZmK+inCLrTtgvlEiGtMQmJ/ga68stva4faVDMc0DzhFUF8jIA2O7cggiP
         HsHd2k8dZlkWTWSwE7z/wCYrLvtAzE4aUWkZDhxZ45iRNYw4y05FnbEmreWemdtYq0jS
         aQxftBbZC5xujQWbSvpxjS4cYnZ3V25QGVZLX8Ud0DyBx1ZG51ZC1gb4NDXp1TqiAZEy
         F79kGXzo/szaYJepTQuF4JRbxvluU48PhF0vL1sGxWJKUduIFkuqR9d5MVpfnLY5F1Cr
         SMKosof1aZa8G+CGeCEvGOOBSIDYEwZa5WWh0JpbkuMFmraCimSSzybQ4eupymTR/0E4
         Hvpw==
X-Gm-Message-State: AGi0Pua8drekiJ0A1mcwnYHR/ICLiXjX0qx0sFdJm1IvgGHsa6V/oxIr
        /pyhnKmhF7tl7vz0r8uTXv3MiRJ//BPWlQ==
X-Google-Smtp-Source: APiQypJaYRgcIU6ypvd5zgzvig1clWbW1/THHDJvL0rgWukFQqwOK1q3Ym6fE4M6woyeveT+xCmA2Q==
X-Received: by 2002:a17:90a:dc01:: with SMTP id i1mr13168327pjv.166.1587829569555;
        Sat, 25 Apr 2020 08:46:09 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id u5sm1189681pgi.70.2020.04.25.08.46.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Apr 2020 08:46:08 -0700 (PDT)
Subject: Re: Queue up bc0c4d1e176e
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
References: <8ed4e92d-b226-61a9-6679-b807dbc4fcbc@kernel.dk>
 <20200425013819.GB13035@sasha-vm>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7afebb0d-4a1d-0d77-ce98-331fbd9fea02@kernel.dk>
Date:   Sat, 25 Apr 2020 09:46:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200425013819.GB13035@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/24/20 7:38 PM, Sasha Levin wrote:
> On Fri, Apr 24, 2020 at 02:58:49PM -0600, Jens Axboe wrote:
>> Hi,
>>
>> Can you queue up this:
>>
>> commit bc0c4d1e176eeb614dc8734fc3ace34292771f11
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Fri Apr 24 11:10:58 2020 -0700
>>
>>    mm: check that mm is still valid in madvise()
>>
>> for 5.6-stable?
> 
> I've queued it up, thanks!

Thanks Sasha!

-- 
Jens Axboe

