Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 237E44F6C3
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 18:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfFVQMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jun 2019 12:12:52 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:42900 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726276AbfFVQMw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jun 2019 12:12:52 -0400
Received: by mail-pl1-f196.google.com with SMTP id ay6so4452377plb.9
        for <stable@vger.kernel.org>; Sat, 22 Jun 2019 09:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2ryss2ah8as3ubDlbF9cMSaGVhFbwpTnmoVXI2Ybu3w=;
        b=LcJP/Pe7sTIyN3V/wHUW8x4aYF1d4Gg1gYEIEl9eb0QZ5Wo5T76fXBEPKAWzqJV3A/
         ln1OAqUXcPUVSA/mpm2z8GMSVR5MXcsX9ZUL4suIa5SVfP/E1JTNjzhxdVHIjE2Ktg0U
         q3hKLY5N9qoYCwptryxtvXPHPIT3sYTo8V+n3Kd67CtYc0v1J/lS3uO7bcHxeS7DQG/H
         UYQ8jF8BF8/e9DVeowJkPDes62hTZTtrfWVTyOQHZxB+/U6lMKgq5l2WUGLLkl8NyEKz
         eagFTZCGkHRgQ+8lX1MRk1S9jFsIufUQTZhblAcWX2I6oxTNereusPXRFPfedGxryMiu
         2ZiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2ryss2ah8as3ubDlbF9cMSaGVhFbwpTnmoVXI2Ybu3w=;
        b=FlQnPXQvv5uSs9TtupOhfeaNlzcy28ZekC0sliOR5cG88iJawXiQoA2b5MAQgGonKV
         JImwH6zY+YaQy/czM99ef9ISbR7JyKHr8MF2/qAYK/ADudwpi5++xiMQxBpYbK64I1Zr
         /DVVde6Je81sTtWJbp6hnmyqrcv9nnK5s9cEY0Ijh2kDV/SrZwgWscFd0TOP1N8iFddz
         Z7QGR3HsRblBICUVM0mrD27EQ0grKSKBaki/2KAZRQ8AaQet7VpZkzyIOViEceyJwBum
         BCvgajf/GpviDva2s2tXSUgiUpSxvNwqu9+UuV+PlC+tN0P87a5acO00UezXUYNmM2Yq
         51Zg==
X-Gm-Message-State: APjAAAVBh7oOCZGHfEOmwy3j9c8AMJCelrLmJpppJk/A7BZbruSSnHBV
        Nr6MjzFkacLJPZpMjg0KT5Y8xgVW
X-Google-Smtp-Source: APXvYqxpDAVsia4ieGeUzn2ZfVL8LnHAlH/dIoJAe5HE+tZglOkP4bxcig6EcxB1L+oUReKZ4Ah2JA==
X-Received: by 2002:a17:902:694a:: with SMTP id k10mr64008388plt.255.1561219971413;
        Sat, 22 Jun 2019 09:12:51 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s43sm6970760pjb.10.2019.06.22.09.12.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 09:12:50 -0700 (PDT)
Subject: Re: stable queue build failures (ipv4/tcp)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
References: <ff85ebad-2806-810f-0a03-a77c64ff92bf@roeck-us.net>
 <20190622152929.GA2586@kroah.com> <20190622154029.GA4520@kroah.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <1dfbb2bf-fd86-efc5-6862-90f31cb5d072@roeck-us.net>
Date:   Sat, 22 Jun 2019 09:12:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190622154029.GA4520@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/22/19 8:40 AM, Greg Kroah-Hartman wrote:
> On Sat, Jun 22, 2019 at 05:29:29PM +0200, Greg Kroah-Hartman wrote:
>> On Sat, Jun 22, 2019 at 06:41:38AM -0700, Guenter Roeck wrote:
>>> v4.4.y, v4.9.y, v4.14.y are affected.
>>>
>>> net/ipv4/tcp_output.c: In function 'tcp_fragment':
>>> net/ipv4/tcp_output.c:1165:8: error: 'tcp_queue' undeclared
>>>
>>> net/ipv4/tcp_output.c:1165:21: error: 'TCP_FRAG_IN_WRITE_QUEUE' undeclared
>>
>> I deleted that patch a while ago, do you not see that update to the
>> queue?
> 
> I have pushed out updated linux-stable-rc git updates in case you were
> building off of those.
> 

Ah yes, I keep forgetting that you don't update those immediately.
Sorry for the noise.

Guenter

