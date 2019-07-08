Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C84961F40
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 15:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731133AbfGHNFr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 09:05:47 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34328 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728800AbfGHNFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 09:05:47 -0400
Received: by mail-lf1-f68.google.com with SMTP id b29so10921961lfq.1
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 06:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=eng.ucsd.edu; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=3G1xWiLRveQufUy4czQFKlLV6/S0Oxxp00Zgaxp779A=;
        b=LELtTuNFVhVuc34C/jKXlj11scoGzAUkn7yJ5qGtaqRsSEzVvlsbLSg37OZ4KKACA/
         cje50xyprIexkvMb7RWGLTvj7sw3OSymSOZ5e6YNjKNk9hMZYo/tvi839BSvbOhV5uIS
         eFXwARDMSRQHrARp7Bzvfzo5ck1/jC1CBzpLw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=3G1xWiLRveQufUy4czQFKlLV6/S0Oxxp00Zgaxp779A=;
        b=UalOS+r+QKFaA2HyL6CFFzeqWPlsVjFpiLW1Q3zVggMpltI+uCecIOE9GmKR8YIHL2
         2me26VZHfINHV6aS3iuwexqgkvw9Js6sZ2elNtCZe2eS9UNzsk/ffa1d45kkpajyfwYh
         w58xRCQIvQ4IiVEAn+DMSZnFlGsMD32u7MiQReE4j4oRNzAEfO+Jhme6g5QXOryI+pvU
         35p5gE6/8qVzkT9EcuSXHCgXykzBftBWjucIIt16lTSqmVMobHfuwNrjf6OPxYL1+6ZM
         h/WjASkCgXqRu4U9DWivxwVNdb0i7HClh3glCcz3gngW+zbnYo7w7tzTunJn84jkfvQI
         w7Kw==
X-Gm-Message-State: APjAAAXrmdRH3qUKIP7URtmdRBNLiM6ZX9FpP8NjU6qQA9Y1xb4AROfS
        2xVhsKYJfqzTRgkWmyCLp/FJaWjUVgqzCQ==
X-Google-Smtp-Source: APXvYqyu8KLlGXUs6ikA3V7LKlY+SPgLgJtLTRKkw/ZVGH2g7/mS/5KQzQQxFWnpBLpeyOYJifVEhg==
X-Received: by 2002:a19:7f17:: with SMTP id a23mr9285124lfd.49.1562591145343;
        Mon, 08 Jul 2019 06:05:45 -0700 (PDT)
Received: from luke-XPS-13 (77-255-206-190.adsl.inetia.pl. [77.255.206.190])
        by smtp.gmail.com with ESMTPSA id l25sm3640321lja.76.2019.07.08.06.05.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 06:05:44 -0700 (PDT)
Date:   Mon, 8 Jul 2019 06:05:42 -0700
From:   Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>
Subject: Re: [PATCH 3.16 000/129] 3.16.70-rc1 review
Message-ID: <20190708130511.GA4626@luke-XPS-13>
References: <lsq.1562518456.876074874@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello, 

I got 1 error when applying this patch series to the latest linux-3.16.y
stable branch

fs/fuse/file.c:218:3: error: implicit declaration of function ‘stream_open’

Thanks, 
- Luke
