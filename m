Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6106512E733
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 15:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbgABOUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 09:20:10 -0500
Received: from mail-lj1-f176.google.com ([209.85.208.176]:43195 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728470AbgABOUK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 09:20:10 -0500
Received: by mail-lj1-f176.google.com with SMTP id a13so40844850ljm.10
        for <stable@vger.kernel.org>; Thu, 02 Jan 2020 06:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RgxG+WmZ1WulJSZKFmn0GNk9wca283ZDDHJbDWkCXBs=;
        b=sDKG3CAr49Lqwejj9r7xOCApnVYxgS1JsN93u3QI5Dhg8aQCOOL6Tzp7KmJOTfYsjw
         P7davwQqzvdp+M3E77xiytvRJS7VHu0sVUhbx3sKMUgOYIik+F9itj0hXreKYPpxQ633
         Zw2JYKibD5GBio4MVyM9mIFeco3F9s1iyOYE2NGzs3H3rSqlEf/MnkeyqpJW7wVUWnpE
         h2cHrWrz/qiYMqAaPA/Dxjl3ZmMXZGKhLwbrQv9ySC7qEqSp57i6pelQXVTY8O5vOnjM
         EOe4EH5pth0xsYKkloqGVEgCA2vnuHu71Nv/zaXl2vspMP3xKJmEnu2fdfps3aTC9fOo
         ldnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RgxG+WmZ1WulJSZKFmn0GNk9wca283ZDDHJbDWkCXBs=;
        b=IGVS2x4rFE5tDRwhaxFMMGv5RU8cxeYP+RIcqc9JHRmwVitw23L7BFb2NJb7agVAdi
         SEGXtFe5Ca94Dn3lfxHwkZN/hDP1kQs61cVkM6jPUXeJ6SgrziZ1OJXBjz0aKCPeuMhT
         kQx5ommd/RryAD3bSXijpLbIv922ELhU1A6Kqez2thoIV1cPd2XnRSSxaIkjXsx8v0Bd
         J+DRValf7lGpDVaHnBdZuPEhwIPc8ndGSLiT3Qj9PUxbgCOcnfIAqGr/Z+hpkW1yL70f
         FIrQa1MEglmzN83cvCoQFIHspw2lE2NHDbMvOCNELEIuZThnMRVUXO976S08TcgYN0UU
         9HyQ==
X-Gm-Message-State: APjAAAXEPfNExsp0et7D5LChQljp3T0a6S2s+O4DS2KdJaoGcW19niH4
        lXbSxxiTv+TzqIHboGs91mw4l6+yQ20kRM40k/D7hw==
X-Google-Smtp-Source: APXvYqwmrH3NQVHj2vMFsF6xJ/oaPPkG86Qdq73ajiZhdPBisjnvtfLCzb0rqlCLqfMAlfcETG0cKPgYtV/VrfS+EhM=
X-Received: by 2002:a2e:858b:: with SMTP id b11mr43951372lji.135.1577974807599;
 Thu, 02 Jan 2020 06:20:07 -0800 (PST)
MIME-Version: 1.0
References: <029dab5a-22f5-c4e9-0797-54cdba0f3539@roeck-us.net>
 <5869f050-7b3f-b950-bfb6-5601d2b30fbd@roeck-us.net> <20200102073058.662A9215A4@mail.kernel.org>
 <63d158e4-14ce-279f-1e77-eb50cb07b465@roeck-us.net>
In-Reply-To: <63d158e4-14ce-279f-1e77-eb50cb07b465@roeck-us.net>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Jan 2020 19:49:56 +0530
Message-ID: <CA+G9fYsDEQwdE559dqDBe5bq5_fcAs0QYvYx0LNYMBEn+ij2Ew@mail.gmail.com>
Subject: Re: Clock related crashes in v5.4.y-queue
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Stephen Boyd <sboyd@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-clk@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Guenter

On Thu, 2 Jan 2020 at 19:45, Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 1/1/20 11:30 PM, Stephen Boyd wrote:
> > (Happy New Year!)
> >
> > Quoting Guenter Roeck (2020-01-01 19:41:40)
> >> On 1/1/20 6:44 PM, Guenter Roeck wrote:
> >>> Hi,
> >>>
> >>> I see a number of crashes in the latest v5.4.y-queue; please see below
> >>> for details. The problem bisects to commit 54a311c5d3988d ("clk: Fix memory
> >>> leak in clk_unregister()").

Please share steps to reproduce this crash.

- Naresh
