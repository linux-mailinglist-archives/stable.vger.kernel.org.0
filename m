Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 407AC11B463
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733237AbfLKPrP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:47:15 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:42129 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732459AbfLKPrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 10:47:15 -0500
Received: by mail-il1-f195.google.com with SMTP id f6so19815667ilh.9
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 07:47:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K5tV1Nbe1r0pXJnCPxMbOe7kndEwjfC++jBrsJjlTJ4=;
        b=g97qMAEbDugNtjFu0nHCUBg9SghaU0t+zHk415SH3KffcD+76x9KR/wGKzyJlghYjV
         ZqBcIcHDB7QU+L/tIYtHk5SAM09kJoFZGmyGS5Ooifd9ZgOAORfwgmi5ER0zgOt7I63G
         DLic0hIJ0fhlRyD+vF87026NYmQsa9Q+hngCA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K5tV1Nbe1r0pXJnCPxMbOe7kndEwjfC++jBrsJjlTJ4=;
        b=IsSZYdxPd7bIppur/fzlJcxAure/2MRuUp93Rli2+FNcQ9QebrAudr57myqYwX2f6p
         oWtA6hOyl3HqVikqn51Ka3nqBPm3J55ztZr09pjZ4P3CMHID3hyDseBWY4hZ7zF0UdfX
         ND1do/y9M7NheeaG9Rjd4iCYa/xsPBeQBpEwng3u6HnJPcP8R9tbRkJabZTY+SWzz6Bl
         IfdTK12eT/wWCBux4Hv66felnSlxQI4mEqlv+rwZQYSr5zPh/0rQswoCodCAnhUtc/VD
         6ugBfef9rLGyAE9gDChBJjnEgLeV4Jh2IRi+S6AuKTBYzWJuQnDhkqUV22Ox8evnO8O3
         xlbg==
X-Gm-Message-State: APjAAAUBdNYxy/xHyK9WP6CoZXFf9wJ0yBGUxGpdMtQW+W1Jt7H0M0Sq
        D2Z4v3C5EWu6FW/Vanmy2EL0/g==
X-Google-Smtp-Source: APXvYqwhpn/QF1wbC4mB0ya8wkAJ3m32nxicCLfymqByaY87HWI497bwVXALV2E51FptLj56RfQm5Q==
X-Received: by 2002:a92:d18a:: with SMTP id z10mr3864672ilz.48.1576079234387;
        Wed, 11 Dec 2019 07:47:14 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id u23sm808618ila.27.2019.12.11.07.47.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 07:47:13 -0800 (PST)
Subject: Re: [PATCH for 5.4 0/3] Restartable Sequences Fixes
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        paulmck <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api <linux-api@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20190917182959.16333-1-mathieu.desnoyers@efficios.com>
 <211848436.2172.1576078102568.JavaMail.zimbra@efficios.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <b67930c1-c8e0-124f-9a88-6ecace27317c@linuxfoundation.org>
Date:   Wed, 11 Dec 2019 08:47:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <211848436.2172.1576078102568.JavaMail.zimbra@efficios.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/11/19 8:28 AM, Mathieu Desnoyers wrote:
> Hi Thomas,
> 
> I thought those rseq fixes posted in September were in the -tip tree, but it
> seems that they never made it to mainline.
> 
> Now Shuah Khan noticed the issue with gettid() compatibility with glibc
> 2.30+. This series contained that fix.
> 
> Should I re-post it, or is this series on track to get into mainline
> at some point ?
> 

It will be great this can make it into 5.5-rc2 or so.

thanks,
-- Shuah

