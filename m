Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 764F530FD2C
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 20:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237720AbhBDToD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 14:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236813AbhBDTn6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 14:43:58 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B86C061788
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 11:43:18 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id u15so2332821plf.1
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 11:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sVKAr/j8S5Ltd/Il4EoLWzEKNd8BaZbQXC4m28X/HXk=;
        b=hx+ZExhKzSJtpAXqe5GcJ37a6OjGDL75tpXq6TzDUBxNzhaWe7g5+tVltwuCvsSc4+
         A8OGVJxmCK0zoLhsR5aYOn5v4Ai3iD/yMGg8Bf4Jh9KkJVbA33SGNfHx3SB+MN+xgRPr
         SQKmb5AWP1WhuhpnYne24ha6ijmXeDdFpHJe5qFyuRidRrTL3s4efdvuZigSjn3m1PCm
         qD8NbymMtKH8PPhn47H0i5hpBSn1CV5ov/vbO3DTHY2Kg1YGqMkLOysjOctEGO+QFobY
         Zs/OdMFs5J5J9OdSpy5PU0YwUHFlT7PfTst+KZ39oIaQUEfUvrr9BBhAzwXiFmkVHBt3
         XLJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sVKAr/j8S5Ltd/Il4EoLWzEKNd8BaZbQXC4m28X/HXk=;
        b=YPEpixxt5TZXtWisQ2uKs+iEeDWr4by9VpD/QV+qVo2DB+ab5RdM5k6sioV3Mhj/t7
         Gl2KorezGCoLkes081UOYqhUKxbCs8rWtVvabHzucAI4z0mZMkRucNmdETmfzNGDOpnJ
         u6Ra/J9Ar3AD8LITu5T0xSYMk3eKwYrTYD1g0+Pn13jr9H6/qrPD5jGvhlBHCjIZwwQf
         JDBZnIoQ+tMDfAYdqLskk8NexsRHXwxDJ+9WQmspGN5MwwYIOl/bT4nYBLg3h7BLcobV
         VcwfPQJl/nMuXklC6RAcmrXnPdX5rkcnu2SBZIHQ/9M8+QGGAZTfcOd6hjxLI495SDmf
         MaBQ==
X-Gm-Message-State: AOAM531UKBwfGE6xytZBRRxy5giCpcUpjeWgz1DuRKE40xNO2irRJD8w
        sAoiMPkYi5A+KzY64Q1VJgobPw41sO1GSM/p
X-Google-Smtp-Source: ABdhPJxAIthc348Xn/1lEWIvzFJQz37QRk9t4bRp1IRyXZxYHYk9QDJY7lAh85Wh6lvxGi4RidutjQ==
X-Received: by 2002:a17:902:d202:b029:e1:8936:cf31 with SMTP id t2-20020a170902d202b02900e18936cf31mr787910ply.51.1612467797559;
        Thu, 04 Feb 2021 11:43:17 -0800 (PST)
Received: from ?IPv6:2600:380:762f:84cb:60e5:b29f:59f2:990b? ([2600:380:762f:84cb:60e5:b29f:59f2:990b])
        by smtp.gmail.com with ESMTPSA id 194sm4632924pfu.165.2021.02.04.11.43.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 11:43:17 -0800 (PST)
Subject: Re: [PATCH] io_uring: drop mm/files between task_work_submit
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <741fe19ee895393f54d01b8f7d25242e7fa27120.1612466514.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <53e3b065-182c-2f05-bb1d-57198a2212ad@kernel.dk>
Date:   Thu, 4 Feb 2021 12:43:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <741fe19ee895393f54d01b8f7d25242e7fa27120.1612466514.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/4/21 12:22 PM, Pavel Begunkov wrote:
> Since SQPOLL task can be shared and so task_work entries can be a mix of
> them, we need to drop mm and files before trying to issue next request.

Thanks, applied.

-- 
Jens Axboe

