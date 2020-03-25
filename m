Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45B1C192C50
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 16:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbgCYPZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 11:25:02 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:37003 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727505AbgCYPY7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 11:24:59 -0400
Received: by mail-pl1-f179.google.com with SMTP id x1so919591plm.4
        for <stable@vger.kernel.org>; Wed, 25 Mar 2020 08:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QQAboEzLhMqCZjpsHcSuxZ7/BUb3hIIZ+G5qkePrAzE=;
        b=zBYxstwL4i+ffT0HEDJS11qPvsxSWVTFt2G21fGIalP3jR/XKmb9kAeIZEClBCX33J
         QiAksvfZ19BwRmMdQsV3i5ycyjwAXJEb02enSv9UlUp0x8SDUsau7rx5nE04i304EfV9
         3SoA3zjU8nojjPUg5YpcVWysN17zdTvStt2y3mamhAXLQMzd1WAKmNrcI8Gmdc3up3J7
         F3B+6KYP+XFbzlTJGKowHcBg8yGmzNirBNxDTQ54yAVaMAlbkE6P/cHKslGjbxGNWwtb
         C2xNiBXsDM2xa+WJbQFhJMlRXET5ThRDTPrIdWc/kWSwT02jx1qdeWcEJDmIBuMSej4H
         sKzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QQAboEzLhMqCZjpsHcSuxZ7/BUb3hIIZ+G5qkePrAzE=;
        b=fs0V0yaAZFh5/UhoUXJpHXVaIlJKC4c/3XON4NWMt2lt8Hal+6hH+1yI6d0YSK1wBG
         zm9L1SiUa79B+hmaLYVBG+Yr0uHRP6rxWA5qpfNJCirrhz8NxRLYEQQSmgPccSvFIpty
         OwiMVZL5pycGulbz+HfRd0xyrRBjCwVQORdt23dBtIvL+0MRhaZMNw6VDiB29qA5Fghe
         LD3M/ehe2RYVUhZ+3Up8EvJsJz6785u46eub6acBdEJMg2z+HslXnAoLorfpyfdBxxmM
         Vvf7I7TP8s3nRCdLNzgi6SFs1KezbGVmRO6xe7r7rY0Sr7GIi+J50gW5ocbm82+ffJPi
         Ya/A==
X-Gm-Message-State: ANhLgQ1g8DOA1BynB/NfOxy3zbPl9tmEKZo9PGBprioC0AS9HvXNjl+p
        SpFPDo/mmdqIrbWvbl8c1kobIg==
X-Google-Smtp-Source: ADFU+vtn2JRR+c/ixt9VlTDZc6IWoPmEPd+gpEC2Gh6kbLAcVJK/sVLxl3XYItLDYinGgpGvtNccWQ==
X-Received: by 2002:a17:90a:cb14:: with SMTP id z20mr4179718pjt.170.1585149897318;
        Wed, 25 Mar 2020 08:24:57 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id f127sm18830556pfa.9.2020.03.25.08.24.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 08:24:56 -0700 (PDT)
Subject: Re: 4.19 LTS high /proc/diskstats io_ticks
To:     "Rantala, Tommi T. (Nokia - FI/Espoo)" <tommi.t.rantala@nokia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "snitzer@redhat.com" <snitzer@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "osandov@fb.com" <osandov@fb.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>
References: <564f7f3718cdc85f841d27a358a43aee4ca239d6.camel@nokia.com>
 <20200325100736.GA3083079@kroah.com>
 <8b876ed9753478764bf5ea74d00b3d54c381b9f2.camel@nokia.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d38259fc-bef1-9905-0575-1fb1192aff83@kernel.dk>
Date:   Wed, 25 Mar 2020 09:24:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <8b876ed9753478764bf5ea74d00b3d54c381b9f2.camel@nokia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/25/20 5:22 AM, Rantala, Tommi T. (Nokia - FI/Espoo) wrote:
> Based on quick looks it's solved by this, I'll need to check if it's enough
> to fix it:
> 
> commit 5b18b5a737600fd20ba2045f320d5926ebbf341a
> Author: Mikulas Patocka <mpatocka@redhat.com>
> Date:   Thu Dec 6 11:41:19 2018 -0500
> 
>     block: delete part_round_stats and switch to less precise counting

Unfortunately that has its own set of issues, which are currently being
fixed just now...

-- 
Jens Axboe

