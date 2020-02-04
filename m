Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90183151F39
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 18:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgBDRUu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 12:20:50 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:52424 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbgBDRUu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 12:20:50 -0500
Received: by mail-pj1-f68.google.com with SMTP id ep11so1665691pjb.2;
        Tue, 04 Feb 2020 09:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kPZ0FP9iKn3NpVfyfbzekp4EaJMOqkAb0O78P8cCHmE=;
        b=qRm5XH2Oz9MFbIZaQQrdSsAKqrRuGi3L+pMYoCHSFURgZ4O5oho0bTJmTQe4sMtORU
         iupgsRqnlcbS7q9LAEiY8BcckCM+cPQRa5NY+4zkFJlC82rocf62moXnw7NqHEW7RoHB
         274QXrgvD9yyZxMi8aAImk2iiwXnuvLDLrEg3o7/Opy75ghIdtnw7+383qrd7gNWq4qp
         +va7aQRZ61nIJqKPyrt22aHLM4CeQ6Vd7eqZ7r1zgKeWa3ciTD7Zmgl0uC2iqgu2beNA
         QCOTrADXQlUPhCNn1REv95UAMwirf/Ox6V8XhqHAzfA+Dnz3xHZramfwJVsXphcFmy5g
         U26Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=kPZ0FP9iKn3NpVfyfbzekp4EaJMOqkAb0O78P8cCHmE=;
        b=SNdSA/biT9FYVTEf/XXpqpSS6M9tGXhNvXUBD8HKBPPQMd2KZGtenPsvd2MCkJEucL
         3+TF9Yy9pXNPcc1LnrQiFtTY00jlOtfAdDYwDbzuZnhhBzywWLPxlpiQ8coUrOJNaEcr
         zJgDQV9oxr6TH/sDbLZwGHJFihReinG0xsGmwZr8noB73V6+v8TGYVP+VfjdsyCV1OzG
         NQCfNvHtTfFkhOh0cA5oN0qYROw6VjFdACwybOf8CP6ghk69wknd7pMM/BZKeuPk6Slf
         ZjvYT4EfhTECHdgjfWnPZEjQ5seJUUPO8XR1SnFnugikI3t4GTb0sbqP8QnfcPr8APou
         a8Ow==
X-Gm-Message-State: APjAAAVD1+CNF7eCGDVI+Y/lB20liXc95lMmnbQFOhZZWXMwW9KMdWcI
        hj6NpRZqBFG2SgLt9I3qGD0=
X-Google-Smtp-Source: APXvYqy/xjE4+827o1ywDM9A1uTExyptoPE1eReZLLBC99Ns70ZHmdQHyG9IcWF1H8JzhBmoKppm5w==
X-Received: by 2002:a17:90b:14e:: with SMTP id em14mr124044pjb.112.1580836848714;
        Tue, 04 Feb 2020 09:20:48 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d22sm24082720pfo.187.2020.02.04.09.20.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Feb 2020 09:20:48 -0800 (PST)
Date:   Tue, 4 Feb 2020 09:20:47 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.5 00/23] 5.5.2-stable review
Message-ID: <20200204172047.GF10163@roeck-us.net>
References: <20200203161902.288335885@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203161902.288335885@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 03, 2020 at 04:20:20PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.2 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 393 pass: 393 fail: 0

Guenter
