Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D36141272FA
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 02:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfLTBos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 20:44:48 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:33151 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727089AbfLTBos (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 20:44:48 -0500
Received: by mail-io1-f66.google.com with SMTP id z8so7839282ioh.0
        for <stable@vger.kernel.org>; Thu, 19 Dec 2019 17:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WEwk0J0BmZw6m3cUGWGohPOAXpqKE+sp6lfv0aKYwSA=;
        b=BCEJG8Pnn7zRX2hVFrKBtfEvBy5FVy2pKsPDlJnMqBSlW3lSfVWwGWGY/XWUBLf7cy
         oZ2UA3E3wReM6h6V3zBhiSta/C/LGav3Lt5hP+XeEzziKgLA3q3V2wxhT7Am0giAvLAC
         nvN8M8xCJ+cSfarEHrjp8Nzb9OlHrjswjB4JE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WEwk0J0BmZw6m3cUGWGohPOAXpqKE+sp6lfv0aKYwSA=;
        b=sVhlXXCrr0AdcOkhLSZfHly3I8fnTznJNZFAO9iw+byhA2wKFL4m2DkJm3jywrJY5e
         jZR9yOzflWxxp+NJqEMQH+Vp5Qc9KSLrw1ra7CB5y8onbEWDrMYyCjwAF2cZupjsj2Hb
         PVExTi5XS0tKcJ2yoWD/2FI/EmkiyT5ptbG4LfhtX7MdMauLDFIx3IoP5fbeBgaAePMP
         /Nw6Pwwr7m0J2Bcg0ehts9Juw9PP/1+yyXVGd0VaPMe4wA0JvcN82z6yAfP4vdRFdvW5
         AdYiZ6N0rqXEwpTPu+U6PBWJd2DjvSWMrfnS9IqPMiIh7U9pElZ1Z67bSycO8SnKFsGR
         gl9w==
X-Gm-Message-State: APjAAAVj1Sc3jS+3cmmdAFZBuZe5mXA4qHI4uubQ+bxr6fbs9zrl+78c
        5z7d07e1ZDKTrKVzM9lZ5RdHnQ==
X-Google-Smtp-Source: APXvYqyY3jEL4NiI53AQszGHY3N9Ba44JmALN8fmmooTeX1dfVOwzufANLzAhloEAhLvM+j/gVZNYw==
X-Received: by 2002:a6b:c007:: with SMTP id q7mr7896221iof.58.1576806287673;
        Thu, 19 Dec 2019 17:44:47 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id z15sm3514958ill.20.2019.12.19.17.44.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2019 17:44:46 -0800 (PST)
Subject: Re: [PATCH for 5.5 1/1] rseq/selftests: Turn off timeout setting
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Boqun Feng <boqun.feng@gmail.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Paul Turner <pjt@google.com>,
        linux-api@vger.kernel.org, stable@vger.kernel.org,
        Dmitry Vyukov <dvyukov@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20191211162857.11354-1-mathieu.desnoyers@efficios.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <f8f04858-ff13-8ec3-0249-8c864fad406a@linuxfoundation.org>
Date:   Thu, 19 Dec 2019 18:44:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191211162857.11354-1-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/11/19 9:28 AM, Mathieu Desnoyers wrote:
> As the rseq selftests can run for a long period of time, disable the
> timeout that the general selftests have.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
> Cc: "Paul E. McKenney" <paulmck@linux.ibm.com>
> Cc: Boqun Feng <boqun.feng@gmail.com>
> Cc: "H . Peter Anvin" <hpa@zytor.com>
> Cc: Paul Turner <pjt@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> ---
>   tools/testing/selftests/rseq/settings | 1 +
>   1 file changed, 1 insertion(+)
>   create mode 100644 tools/testing/selftests/rseq/settings
> 
> diff --git a/tools/testing/selftests/rseq/settings b/tools/testing/selftests/rseq/settings
> new file mode 100644
> index 000000000000..e7b9417537fb
> --- /dev/null
> +++ b/tools/testing/selftests/rseq/settings
> @@ -0,0 +1 @@
> +timeout=0
> 

I am pulling this patch in for Linux 5.5-rc4.

Let me know if you have any objections.

thanks,
-- Shuah
