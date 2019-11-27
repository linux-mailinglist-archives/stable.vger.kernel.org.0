Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C82B410B62D
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 19:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfK0Syo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 13:54:44 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39233 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfK0Syo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Nov 2019 13:54:44 -0500
Received: by mail-pg1-f194.google.com with SMTP id b137so9033371pga.6;
        Wed, 27 Nov 2019 10:54:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iNMKV6JKx16eJZPWeMfLiRiiW9bu99KddtEjmyG/dBw=;
        b=iRZSk9YZXucgxSGamn2ePuWOld1AtB7dlllIpqHr1CwQNJkz01jFxrBoWcRpQ+Ly4B
         TXd5D4yiPRTZYWKsGJc9VlBgXcaF3cRg1+uAFMtddC7OU+qvb78nKuQ8CulRt8gREFDl
         EScQrazXX0FAzfoyYVuxxP5f6v+e8ODqme2fPNke5ZuxpA93ydjYQRWUOD8wUOqvzqn0
         KAh62up1efrIRhg5yQlhFWimnz/a7VvjPWdft3E8UbgD3G1KqV2+Jn+xS1AyE2rIKXFV
         LJCgm0ySmPREaaD1aUTrL3WEk9H21pZE8iExes1o/RHYaTq0uAFqp5qVqgHu1sLzgJN9
         Syvw==
X-Gm-Message-State: APjAAAXng/oZb8gaucRTcS69FEOE4cjz3ZTHYqS6or2opOAgGNk7f6aI
        +DtHBwWW0Bx7aCj8bMGGul8G6isQ4uA=
X-Google-Smtp-Source: APXvYqwM60udEdRU61xo0iuYVsNDZqo6TRXXgKHNgiD1W7HWHYnqXvx+mPjwp9lBn9tcojds7pkzhw==
X-Received: by 2002:a63:447:: with SMTP id 68mr6357827pge.364.1574880882964;
        Wed, 27 Nov 2019 10:54:42 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id j7sm3831350pgn.0.2019.11.27.10.54.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 10:54:41 -0800 (PST)
Subject: Re: [f2fs-dev] [PATCH v3] loop: avoid EAGAIN, if offset or block_size
 are changed
To:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        stable@vger.kernel.org
References: <20190518004751.18962-1-jaegeuk@kernel.org>
 <20190518005304.GA19446@jaegeuk-macbookpro.roam.corp.google.com>
 <20191127181809.GA42245@jaegeuk-macbookpro.roam.corp.google.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <898950e4-3759-c78e-dd5d-422af9f8c507@acm.org>
Date:   Wed, 27 Nov 2019 10:54:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191127181809.GA42245@jaegeuk-macbookpro.roam.corp.google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/27/19 10:18 AM, Jaegeuk Kim wrote:
> Previously, there was a bug where user could see stale buffer cache (e.g, 512B)
> attached in the 4KB-sized pager cache, when the block size was changed from
> 512B to 4KB. That was fixed by:
> commit 5db470e229e2 ("loop: drop caches if offset or block_size are changed")

[ ... ]

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
