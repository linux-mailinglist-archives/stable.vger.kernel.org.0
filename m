Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 389AB4F6B8
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 18:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfFVQDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 12:03:21 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33175 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfFVQDV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 12:03:21 -0400
Received: by mail-pf1-f194.google.com with SMTP id x15so5124995pfq.0
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 09:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5mtk6CiCbuJOV5zXZVQd76HAEVdvwDB/f1xqdhDdbR4=;
        b=XZ7F/zxiSMLkL4ERD2WRPLXruAD2bcc3lf5rgzInG+Kj+INMYA+kGtKTnQWxHjXyhA
         Be712Yeg3eQOcCZdb1iuyHVACy+Sn25wlSHSTrlsx22UlSW0RaeZJwhT3wul1iGnQOi3
         VuIy0xkWGgOPatBQ7jyc1dW1z8PNKPf/7Zhjbwaes0rFPudvYPj1xfhUxQzYF3U5iprH
         ZVYikOJwLZYTKqNh+EV67hPGAWuWKY//wr8WDzCUt+N4/cT/tKfch4LC+5AsrdWecD9n
         3ohN4iDP/DBYsiOOHCfH6f2REU5grWKZ7YXSm6htu0cOXpuilhs8c5KnU+NmOzsfEIyN
         ymQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5mtk6CiCbuJOV5zXZVQd76HAEVdvwDB/f1xqdhDdbR4=;
        b=mFlGYCdzFqpIGQ92d+JBH4xF7LKhkN0C3G6YtgJI8giW4a/ju+igC0B5VyHTrOTeC9
         D+jz92PGOhD8WL0DMOmAhzK7gLy/5YPGZUGFhCQVnH+5ErORMQRU9rcv2xz8/JIxPSE3
         CsUMCaMYLc8tddjGBxypoXxPOXst/zH5qnvdBZxefGnl7i2ZD+n7wotXYFvU1CApeIBu
         vHfzo9ic4EMl7K3OiWPwb2t66aGC+Pp+D5lKB0yTtpokp1yYBehsIaMvPB4ZwiZ6N0sJ
         OkNvzyzlr6Yg7fvvAMgqWD6lTUAoycAwFIgmqY2g9QlEB86fZ6h0ZmDUcu6n425i4s6P
         4ZYg==
X-Gm-Message-State: APjAAAV2F5FyveONIzaVbWY2VYq+kPiC+vG78GE2jcZKJP228+ge3jXR
        9klG7899NIrhwXBv4YZi+OJNx6dJ
X-Google-Smtp-Source: APXvYqyiuKpZA1hi1JUeKa3rjKsVn5eAGQdaRApKrYOXw1iRI31t92NC9TOMfTGQxSv8AVW0BeaiTw==
X-Received: by 2002:a63:d4c:: with SMTP id 12mr4696127pgn.30.1561219400117;
        Sat, 22 Jun 2019 09:03:20 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f15sm7183349pje.17.2019.06.22.09.03.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 09:03:19 -0700 (PDT)
Subject: Re: stable queue build failures (ipv4/tcp)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
References: <ff85ebad-2806-810f-0a03-a77c64ff92bf@roeck-us.net>
 <20190622152929.GA2586@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <8467eb18-9a48-7104-8ded-e61b19047bc9@roeck-us.net>
Date:   Sat, 22 Jun 2019 09:03:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190622152929.GA2586@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/22/19 8:29 AM, Greg Kroah-Hartman wrote:
> On Sat, Jun 22, 2019 at 06:41:38AM -0700, Guenter Roeck wrote:
>> v4.4.y, v4.9.y, v4.14.y are affected.
>>
>> net/ipv4/tcp_output.c: In function 'tcp_fragment':
>> net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared
>>
>> net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undeclared
> 
> I deleted that patch a while ago, do you not see that update to the
> queue?
> 

I sent my e-mail at 6:41am today. The failing build was based on changes
the builders had picked up during the night. The builders picked up another
change at 8:45am, and one more at 8:55am. With those, the problem is gone.

Thanks,
Guenter
